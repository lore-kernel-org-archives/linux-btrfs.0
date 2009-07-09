From: Piavlo <piavka@cs.bgu.ac.il>
Subject: kmemleak influence on write btrfs performance
Date: Thu, 09 Jul 2009 14:08:01 +0300
Message-ID: <4A55CF91.90708@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Hi,

I'm running 2.6.31-rc2 and noticed that then kmemleak is enabled it
lowers the sequential disk write benchmark performance by an order of
two for btrfs
while for other files systems like ext4 the change is barely noticeable
(around 1%)
While for both btrfs and ext4 the system cpu load rises very high with
kmemleak enabled - but only write btrfs performance suffers.
Does someone have an explanation for this behavior?

Below are benchmark results:

# tiotest -t 1 -f 9000 -r 15000 -b 4096 -d /btrfs/
Tiotest results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        9000 MBs |  391.0 s |  23.017 MB/s |   0.6 %  |  73.5 % |
| Random Write   59 MBs |   31.4 s |   1.865 MB/s |   0.1 %  |  88.3 % |
| Read         9000 MBs |  193.8 s |  46.448 MB/s |   0.5 %  |  49.1 % |
| Random Read    59 MBs |  129.0 s |   0.454 MB/s |   0.0 %  |   4.1 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.163 ms |      307.458 ms |  0.00000 |   0.00000 |
| Random Write |        0.177 ms |       60.377 ms |  0.00000 |   0.00000 |
| Read         |        0.084 ms |      167.255 ms |  0.00000 |   0.00000 |
| Random Read  |        8.598 ms |      144.846 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.151 ms |      307.458 ms |  0.00000 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

# echo off > /sys/kernel/debug/kmemleak

# tiotest -t 1 -f 9000 -r 15000 -b 4096 -d /btrfs/
Tiotest results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        9000 MBs |  191.7 s |  46.953 MB/s |   0.9 %  |  28.3 % |
| Random Write   59 MBs |   23.5 s |   2.498 MB/s |   0.0 %  |  91.9 % |
| Read         9000 MBs |  186.8 s |  48.177 MB/s |   0.5 %  |  12.4 % |
| Random Read    59 MBs |  124.0 s |   0.472 MB/s |   0.0 %  |   0.8 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.075 ms |      650.163 ms |  0.00000 |   0.00000 |
| Random Write |        0.033 ms |       52.492 ms |  0.00000 |   0.00000 |
| Read         |        0.081 ms |      227.223 ms |  0.00000 |   0.00000 |
| Random Read  |        8.268 ms |      117.314 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.104 ms |      650.163 ms |  0.00000 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

# tiotest -t 1 -f 9000 -r 15000 -b 4096 -d /ext4/
Tiotest results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        9000 MBs |  221.3 s |  40.661 MB/s |   0.7 %  |  59.2 % |
| Random Write   59 MBs |   44.9 s |   1.306 MB/s |   0.0 %  |   3.6 % |
| Read         9000 MBs |  215.6 s |  41.740 MB/s |   0.5 %  |  14.3 % |
| Random Read    59 MBs |  125.1 s |   0.468 MB/s |   0.0 %  |   2.4 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.095 ms |      872.236 ms |  0.00000 |   0.00000 |
| Random Write |        0.064 ms |        1.737 ms |  0.00000 |   0.00000 |
| Read         |        0.093 ms |      179.890 ms |  0.00000 |   0.00000 |
| Random Read  |        8.340 ms |      151.676 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.120 ms |      872.236 ms |  0.00000 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

# echo off > /sys/kernel/debug/kmemleak
# tiotest -t 1 -f 9000 -r 15000 -b 4096 -d /ext4/
Tiotest results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        9000 MBs |  217.7 s |  41.346 MB/s |   0.8 %  |  11.0 % |
| Random Write   59 MBs |   43.2 s |   1.355 MB/s |   0.0 %  |   1.3 % |
| Read         9000 MBs |  215.5 s |  41.758 MB/s |   0.5 %  |   6.6 % |
| Random Read    59 MBs |  123.0 s |   0.476 MB/s |   0.0 %  |   0.7 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.093 ms |     1314.872 ms |  0.00000 |   0.00000 |
| Random Write |        0.013 ms |        3.884 ms |  0.00000 |   0.00000 |
| Read         |        0.093 ms |      246.652 ms |  0.00000 |   0.00000 |
| Random Read  |        8.202 ms |      111.633 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.119 ms |     1314.872 ms |  0.00000 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'


