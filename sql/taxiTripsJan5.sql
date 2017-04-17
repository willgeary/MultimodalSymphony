select 
	cab_type_id as type_id,
	pickup_datetime as starttime,
	dropoff_datetime as stoptime,
	extract(EPOCH from (dropoff_datetime - pickup_datetime))::float as tripduration,
	pickup_latitude as start_lat,
	pickup_longitude as start_lon,
	dropoff_latitude as end_lat,
	dropoff_longitude as end_lon
from 
trips
where
	pickup_longitude != 0
	and
	pickup_latitude != 0
	and
	dropoff_longitude != 0
	and
	dropoff_latitude != 0
	and
	pickup_datetime 
		between 
			'2015-01-05'
		and 
			'2015-01-06'
order by
type_id ASC,
starttime ASC;
