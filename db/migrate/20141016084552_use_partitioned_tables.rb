class UsePartitionedTables < ActiveRecord::Migration
  def up
    execute "ALTER TABLE alerts RENAME TO alerts_old"

    execute "CREATE TABLE alerts (
              LIKE alerts_old
              INCLUDING DEFAULTS
              INCLUDING CONSTRAINTS
              INCLUDING INDEXES
            );"

    execute "CREATE TABLE alerts_inactive (
              CHECK (deleted_at IS NOT NULL)
            ) INHERITS (alerts);"

    add_index :alerts_inactive, :deleted_at

    execute "CREATE TABLE alerts_active (
              CHECK (deleted_at IS NULL)
            ) INHERITS (alerts);"

    add_index :alerts_active, :name

    execute "CREATE OR REPLACE FUNCTION alert_insert()
            RETURNS TRIGGER AS $$
            BEGIN
              IF (NEW.deleted_at IS NOT NULL) THEN
                INSERT INTO alerts_inactive VALUES (NEW.*);
              ELSIF (NEW.deleted_at IS NULL) THEN
                INSERT INTO alerts_active VALUES (NEW.*);
              END IF;
              RETURN NULL;
            END;
            $$
            LANGUAGE plpgsql;"

    execute "CREATE TRIGGER alert_insert_trigger
            BEFORE INSERT OR UPDATE ON alerts
            FOR EACH ROW EXECUTE PROCEDURE alert_insert();"

    execute "CREATE OR REPLACE FUNCTION active_partition_constraint()
            RETURNS TRIGGER AS $$
            BEGIN
              IF (NEW.deleted_at IS NOT NULL) THEN
                INSERT INTO alerts_inactive VALUES (NEW.*);
                DELETE FROM alerts_active WHERE id = NEW.id;
                RETURN NULL;
              ELSE
                RETURN NEW;
              END IF;
            END;
            $$
            LANGUAGE plpgsql;"

    execute "CREATE TRIGGER active_constraint_trigger
            BEFORE UPDATE ON alerts_active
            FOR EACH ROW EXECUTE PROCEDURE active_partition_constraint();"

    execute "CREATE OR REPLACE FUNCTION inactive_partition_constraint()
            RETURNS TRIGGER AS $$
            BEGIN
              IF (NEW.deleted_at IS NULL) THEN
                INSERT INTO alerts_active VALUES (NEW.*);
                DELETE FROM alerts_inactive WHERE id = NEW.id;
                RETURN NULL;
              ELSE
                RETURN NEW;
              END IF;
            END;
            $$
            LANGUAGE plpgsql;"

    execute "CREATE TRIGGER inactive_constraint_trigger
            BEFORE UPDATE ON alerts_inactive
            FOR EACH ROW EXECUTE PROCEDURE inactive_partition_constraint();"

    execute "SET constraint_exclusion = on;"

    execute "INSERT INTO alerts
             SELECT * FROM alerts_old"
  end

  def down
    execute "DROP TRIGGER alert_insert_trigger ON alerts"
    execute "DROP TRIGGER active_constraint_trigger ON alerts_active"
    execute "DROP TRIGGER inactive_constraint_trigger ON alerts_inactive"
    execute "DROP TABLE alerts_inactive"
    execute "DROP TABLE alerts_active"
    execute "DROP TABLE alerts"
    execute "ALTER TABLE alerts_old RENAME TO alerts"
    execute "SET constraint_exclusion = off"
  end
end
