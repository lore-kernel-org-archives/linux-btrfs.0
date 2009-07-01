From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: high cpu load for random write
Date: Wed, 01 Jul 2009 11:30:23 +0300
Message-ID: <4A4B1E9F.1070201@cs.bgu.ac.il>
References: <4A4A0AF1.9060107@cs.bgu.ac.il> <20090630134103.GB8345@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090630134103.GB8345@think>
List-ID: <linux-btrfs.vger.kernel.org>

 Hi Chris,

I've tried a test with mount -o nodatacow and see no noticeable
difference in cpu load.

Results with -o nodatacow (dmesg confirms "btrfs: setting nodatacow")
Tiotest results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        9000 MBs |  195.7 s |  45.984 MB/s |   0.8 %  |  39.2 % |
| Random Write   59 MBs |   23.7 s |   2.470 MB/s |   0.1 %  |  91.6 % |
| Read         9000 MBs |  189.3 s |  47.538 MB/s |   0.6 %  |  11.6 % |
| Random Read    59 MBs |  124.8 s |   0.470 MB/s |   0.0 %  |   1.0 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.079 ms |     3521.734 ms |  0.00009 |   0.00000 |
| Random Write |        0.021 ms |        0.449 ms |  0.00000 |   0.00000 |
| Read         |        0.082 ms |      308.059 ms |  0.00000 |   0.00000 |
| Random Read  |        8.318 ms |       31.541 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.107 ms |     3521.734 ms |  0.00004 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

Resutls without -o nodatacow
 Tiotest results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write        9000 MBs |  199.4 s |  45.130 MB/s |   0.6 %  |  39.1 % |
| Random Write   59 MBs |   23.8 s |   2.457 MB/s |   0.1 %  |  92.1 % |
| Read         9000 MBs |  187.1 s |  48.110 MB/s |   0.5 %  |  11.9 % |
| Random Read    59 MBs |  125.7 s |   0.466 MB/s |   0.0 %  |   1.1 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.081 ms |     3608.655 ms |  0.00026 |   0.00000 |
| Random Write |        0.021 ms |        1.032 ms |  0.00000 |   0.00000 |
| Read         |        0.081 ms |      252.264 ms |  0.00000 |   0.00000 |
| Random Read  |        8.376 ms |      192.319 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.107 ms |     3608.655 ms |  0.00013 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'

Alex

Chris Mason wrote:
> There are two causes of the high CPU load.  The first is data
> checksumming (which is constant for creating the file and for random
> writes) and the second is the cost of maintaining back references for
> the file data extent.
>
> In btrfs, we track the owners of each extent, which makes repair, volume
> management and other things much easier.  Small random writes make for a
> lot of extents, and so they also make for a lot of tracking.
>
> In general, you'll find that mount -o ssd will be faster here, just
> because it forces the allocator into more sequential allocations for
> this workload.
>
> You'll find that mount -o nodatacow uses much less CPU time, but this
> disables checksumming and a few other advanced features.
>
> -chris
>   

