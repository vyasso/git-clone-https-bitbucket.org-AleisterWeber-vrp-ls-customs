ALTER TABLE `vrp_user_vehicles`
DROP `car_id`;
ALTER TABLE `vrp_user_vehicles`
ADD  `car_id` int(11)  UNIQUE;
ALTER TABLE `vrp_user_vehicles` CHANGE `car_id` `car_id` INT(11) NULL DEFAULT NULL AUTO_INCREMENT;
