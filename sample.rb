select (select count(*) from alerts) as count1,
  (select count(*) from alerts_active) as count2,
  (select count(*) from alerts_inactive) as count3;

100.times { |t| Alert.create(name: "alert#{t}", deleted_at: rand(2).zero? ? Time.current : nil) }
100.times { |t| Want.create(name: "want#{t}", alert_id: Alert.first(:offset => rand(Alert.count)).id) }

CREATE TABLE alerts AS SELECT * FROM alerts_old WHERE FALSE;
create table new (
    like old
    including defaults
    including constraints
    including indexes
);

select (select count(*) from motor_models) as count1,
  (select count(*) from motor_models_active) as count2,
  (select count(*) from motor_models_inactive) as count3;

select (select count(*) from wants) as count1,
  (select count(*) from wants_active) as count2,
  (select count(*) from wants_inactive) as count3;


psql -U findsyou -W -h localhost findsyou_development < /home/rails/findsyou-staging-20_10_2014.sql
