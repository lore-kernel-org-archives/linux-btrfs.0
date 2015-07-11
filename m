Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fmxout03.freemail.hu ([195.228.245.73]:41622 "EHLO
	fmxout03.freemail.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbbGKGpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 02:45:06 -0400
Date: Sat, 11 Jul 2015 06:19:49 +0200 (CEST)
From: None None <whocares0101@freemail.hu>
Subject: Re: Can't remove missing device
To: None None <whocares0101@freemail.hu>
cc: linux-btrfs@vger.kernel.org, None None <whocares0101@freemail.hu>
In-Reply-To: <freemail.20150710060521.7704.1@fmxmldata04.freemail.hu>
Message-ID: <freemail.20150711061949.95217.3@fmxmldata03.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; CHARSET=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I now ran "btrfs check" and it found some errors, I tried "-o degraded,clear_cache" to get rid of the "failed to load free space cache for block group" errors but without success.
Is "btrfs check --repair" able to fix my problems or would it make things worse?



dmesg for degraded,clear_cache
[ 6034.974188] BTRFS info (device sda): allowing degraded mounts
[ 6034.974203] BTRFS info (device sda): force clearing of disk cache
[ 6034.974208] BTRFS info (device sda): disk space caching is enabled
[ 6034.990498] BTRFS warning (device sda): devid 7 missing
[ 6035.176337] BTRFS: bdev (null) errs: wr 57611, rd 6576553, flush 0, corrupt 0, gen 0



The "checking fs roots" stage took about 4 hours.

# btrfs check /dev/sda
warning devid 7 not found already
Checking filesystem on /dev/sda
UUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
checking extents
checking free space cache
...
there are a lot of these space cache errors
...
Error reading 65837128155136, -1
failed to load free space cache for block group 86320755769344
Error reading 65473418690560, -1
failed to load free space cache for block group 86322147229696
Error reading 65488787603456, -1
failed to load free space cache for block group 86323536068608
Error reading 66592644005888, -1
failed to load free space cache for block group 86326311649280
Error reading 65494865608704, -1
failed to load free space cache for block group 86329084346368
Error reading 66592780910592, -1
failed to load free space cache for block group 86330467680256
Error reading 65547785207808, -1
failed to load free space cache for block group 86333233037312
Error reading 65546530521088, -1
failed to load free space cache for block group 86334612963328
Error reading 66592982564864, -1
failed to load free space cache for block group 86335992627200
Error reading 68234986389504, -1
failed to load free space cache for block group 86375265337344
checking fs roots
root 260 inode 164555 errors 400, nbytes wrong
root 260 inode 176322 errors 400, nbytes wrong
found 20384231645281 bytes used err is 1
total csum bytes: 19856909464
total tree bytes: 23720411136
total fs tree bytes: 884711424
total extent tree bytes: 799186944
btree space waste bytes: 2086359131
file data blocks allocated: 105517330931712
 referenced 19815959842816
btrfs-progs v4.1.1



None None <whocares0101@freemail.hu> írta:
>One of my 3TB drives failed (not recognized anymore) recently so I got two new 4TB drives, I mounted the fs with -o degraded and used "btrfs dev add" to add the new drives then I did "btrfs dev del missing".
>Now delete missing always returns an error
>ERROR: error removing the device 'missing' - Input/output error
>
>According to dmesg sda returns bad data but the smart values for it seem fine.
>How do I get the FS working again?
>
>
>
>Debian/SID, kernel v4.1
>
>
>
># btrfs fi df /srv/
>Data, RAID5: total=18.96TiB, used=18.52TiB
>System, RAID1: total=32.00MiB, used=2.30MiB
>Metadata, RAID1: total=24.06GiB, used=22.09GiB
>GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
>
># btrfs fi sho
>Label: none  uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
>        Total devices 11 FS bytes used 18.54TiB
>        devid    1 size 2.73TiB used 2.56TiB path /dev/sdh
>        devid    2 size 2.73TiB used 2.63TiB path /dev/sdg
>        devid    3 size 2.73TiB used 2.64TiB path /dev/sdj
>        devid    4 size 2.73TiB used 2.60TiB path /dev/sdk
>        devid    5 size 2.73TiB used 2.63TiB path /dev/sdb
>        devid    6 size 2.73TiB used 2.73TiB path /dev/sda
>        devid    9 size 2.73TiB used 2.73TiB path /dev/sdd
>        devid   10 size 2.73TiB used 2.73TiB path /dev/sdl
>        devid   11 size 3.64TiB used 2.66GiB path /dev/sdc
>        devid   12 size 3.64TiB used 2.66GiB path /dev/sde
>        *** Some devices missing
>
>btrfs-progs v4.0
>
>
>
># dmesg | tail -n 40
>[ 9474.630480] BTRFS warning (device sda): csum failed ino 384 off 2927886336 csum 1204172668 expected csum 3738892907
>[ 9474.630487] BTRFS warning (device sda): csum failed ino 384 off 2927919104 csum 729502971 expected csum 57406087
>[ 9474.630493] BTRFS warning (device sda): csum failed ino 384 off 2927923200 csum 1688454633 expected csum 4263548653
>[ 9474.630495] BTRFS warning (device sda): csum failed ino 384 off 2927927296 csum 3679588162 expected csum 4283532667
>[ 9484.066796] BTRFS info (device sda): relocating block group 66338809643008 flags 129
>[ 9505.492349] __readpage_endio_check: 6 callbacks suppressed
>[ 9505.492356] BTRFS warning (device sda): csum failed ino 385 off 2927886336 csum 1204172668 expected csum 3738892907
>[ 9505.492366] BTRFS warning (device sda): csum failed ino 385 off 2927890432 csum 645393967 expected csum 1519548271
>[ 9505.492372] BTRFS warning (device sda): csum failed ino 385 off 2927894528 csum 3254966910 expected csum 2168664573
>[ 9505.492377] BTRFS warning (device sda): csum failed ino 385 off 2927898624 csum 3464250141 expected csum 1621289634
>[ 9505.492382] BTRFS warning (device sda): csum failed ino 385 off 2927902720 csum 2214000308 expected csum 2797028572
>[ 9505.492387] BTRFS warning (device sda): csum failed ino 385 off 2927906816 csum 3719155761 expected csum 561200354
>[ 9505.492392] BTRFS warning (device sda): csum failed ino 385 off 2927910912 csum 98768328 expected csum 1311354303
>[ 9505.492397] BTRFS warning (device sda): csum failed ino 385 off 2927915008 csum 996429330 expected csum 1552366519
>[ 9505.492402] BTRFS warning (device sda): csum failed ino 385 off 2927919104 csum 729502971 expected csum 57406087
>[ 9505.492407] BTRFS warning (device sda): csum failed ino 385 off 2927923200 csum 1688454633 expected csum 4263548653
>[ 9515.428150] BTRFS info (device sda): relocating block group 66338809643008 flags 129
>[ 9534.605158] __readpage_endio_check: 7 callbacks suppressed
>[ 9534.605165] BTRFS warning (device sda): csum failed ino 386 off 2927886336 csum 1204172668 expected csum 3738892907
>[ 9534.605174] BTRFS warning (device sda): csum failed ino 386 off 2927890432 csum 645393967 expected csum 1519548271
>[ 9534.605184] BTRFS warning (device sda): csum failed ino 386 off 2927894528 csum 3254966910 expected csum 2168664573
>[ 9534.605192] BTRFS warning (device sda): csum failed ino 386 off 2927898624 csum 3464250141 expected csum 1621289634
>[ 9534.605194] BTRFS warning (device sda): csum failed ino 386 off 2927902720 csum 2214000308 expected csum 2797028572
>[ 9534.605198] BTRFS warning (device sda): csum failed ino 386 off 2927906816 csum 3719155761 expected csum 561200354
>[ 9534.605204] BTRFS warning (device sda): csum failed ino 386 off 2927910912 csum 98768328 expected csum 1311354303
>[ 9534.605206] BTRFS warning (device sda): csum failed ino 386 off 2927915008 csum 996429330 expected csum 1552366519
>[ 9534.605212] BTRFS warning (device sda): csum failed ino 386 off 2927919104 csum 729502971 expected csum 57406087
>[ 9534.605215] BTRFS warning (device sda): csum failed ino 386 off 2927923200 csum 1688454633 expected csum 4263548653
>[ 9543.317995] BTRFS info (device sda): relocating block group 66338809643008 flags 129
>[ 9564.879155] __readpage_endio_check: 7 callbacks suppressed
>[ 9564.879161] BTRFS warning (device sda): csum failed ino 387 off 2927886336 csum 1204172668 expected csum 3738892907
>[ 9564.879171] BTRFS warning (device sda): csum failed ino 387 off 2927890432 csum 645393967 expected csum 1519548271
>[ 9564.879176] BTRFS warning (device sda): csum failed ino 387 off 2927894528 csum 3254966910 expected csum 2168664573
>[ 9564.879182] BTRFS warning (device sda): csum failed ino 387 off 2927898624 csum 3464250141 expected csum 1621289634
>[ 9564.879187] BTRFS warning (device sda): csum failed ino 387 off 2927902720 csum 2214000308 expected csum 2797028572
>[ 9564.879192] BTRFS warning (device sda): csum failed ino 387 off 2927906816 csum 3719155761 expected csum 561200354
>[ 9564.879196] BTRFS warning (device sda): csum failed ino 387 off 2927910912 csum 98768328 expected csum 1311354303
>[ 9564.879202] BTRFS warning (device sda): csum failed ino 387 off 2927915008 csum 996429330 expected csum 1552366519
>[ 9564.879207] BTRFS warning (device sda): csum failed ino 387 off 2927919104 csum 729502971 expected csum 57406087
>[ 9564.879212] BTRFS warning (device sda): csum failed ino 387 off 2927923200 csum 1688454633 expected csum 4263548653
>
>
>
># smartctl -a /dev/sda
>smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.1.0-custom+] (local build)
>Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
>=== START OF INFORMATION SECTION ===
>Model Family:     Seagate Barracuda 7200.14 (AF)
>Device Model:     ST3000DM001-1CH166
>Serial Number:    XXXXXXXX
>LU WWN Device Id: 5 000c50 04eee2715
>Firmware Version: CC29
>User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>Sector Sizes:     512 bytes logical, 4096 bytes physical
>Rotation Rate:    7200 rpm
>Form Factor:      3.5 inches
>Device is:        In smartctl database [for details use: -P show]
>ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
>SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
>Local Time is:    Fri Jul 10 03:43:08 2015 UTC
>SMART support is: Available - device has SMART capability.
>SMART support is: Enabled
>
>=== START OF READ SMART DATA SECTION ===
>SMART overall-health self-assessment test result: PASSED
>
>General SMART Values:
>Offline data collection status:  (0x82) Offline data collection activity
>                                        was completed without error.
>                                        Auto Offline Data Collection: Enabled.
>Self-test execution status:      (   0) The previous self-test routine completed
>                                        without error or no self-test has ever
>                                        been run.
>Total time to complete Offline
>data collection:                (  584) seconds.
>Offline data collection
>capabilities:                    (0x7b) SMART execute Offline immediate.
>                                        Auto Offline data collection on/off support.
>                                        Suspend Offline collection upon new
>                                        command.
>                                        Offline surface scan supported.
>                                        Self-test supported.
>                                        Conveyance Self-test supported.
>                                        Selective Self-test supported.
>SMART capabilities:            (0x0003) Saves SMART data before entering
>                                        power-saving mode.
>                                        Supports SMART auto save timer.
>Error logging capability:        (0x01) Error logging supported.
>                                        General Purpose Logging supported.
>Short self-test routine
>recommended polling time:        (   1) minutes.
>Extended self-test routine
>recommended polling time:        ( 336) minutes.
>Conveyance self-test routine
>recommended polling time:        (   2) minutes.
>SCT capabilities:              (0x3085) SCT Status supported.
>
>SMART Attributes Data Structure revision number: 10
>Vendor Specific SMART Attributes with Thresholds:
>ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>  1 Raw_Read_Error_Rate     0x000f   108   099   006    Pre-fail  Always       -       15470024
>  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail  Always       -       0
>  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       92
>  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
>  7 Seek_Error_Rate         0x000f   075   059   030    Pre-fail  Always       -       47614627725
>  9 Power_On_Hours          0x0032   077   077   000    Old_age   Always       -       20473
> 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       91
>183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
>184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
>187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
>188 Command_Timeout         0x0032   100   099   000    Old_age   Always       -       0 0 6
>189 High_Fly_Writes         0x003a   083   083   000    Old_age   Always       -       17
>190 Airflow_Temperature_Cel 0x0022   067   061   045    Old_age   Always       -       33 (Min/Max 26/33)
>191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
>192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       42
>193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       219
>194 Temperature_Celsius     0x0022   033   040   000    Old_age   Always       -       33 (0 17 0 0 0)
>197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
>198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
>199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
>240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       20467h+17m+19.660s
>241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       127039808220
>242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       92772194111
>
>SMART Error Log Version: 1
>No Errors Logged
>
>SMART Self-test log structure revision number 1
>No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>
>SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>    1        0        0  Not_testing
>    2        0        0  Not_testing
>    3        0        0  Not_testing
>    4        0        0  Not_testing
>    5        0        0  Not_testing
>Selective self-test flags (0x0):
>  After scanning selected spans, do NOT read-scan remainder of disk.
>If Selective self-test is pending on power-up, resume after 0 minute delay.
>
