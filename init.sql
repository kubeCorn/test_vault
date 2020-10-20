USE `mysql`;

DROP TABLE IF EXISTS
    `kubedb_table`;

CREATE TABLE `kubedb_table`(
    `id` BIGINT(20) NOT NULL,
    `name` VARCHAR(255) DEFAULT NULL,
    `nickname` VARCHAR(255) DEFAULT NULL
);

--
-- Dumping data for table `kubedb_table`
--

INSERT INTO `kubedb_table`(`id`, `name`, `nickname`)
VALUES(1, 'florian', 'kubeflo'),(2, 'david', 'mon david'),(3, 'yann', 'coffee break'), (4, 'loic', 'notre vauveur');

--
-- Indexes for table `kubedb_table`
--

ALTER TABLE
    `kubedb_table` ADD PRIMARY KEY(`id`);

--
-- AUTO_INCREMENT for table `kubedb_table`
--

ALTER TABLE
    `kubedb_table` MODIFY `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 5;

