Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45041 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbbGMDjP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 23:39:15 -0400
Subject: Re: Can't remove missing device
To: None None <whocares0101@freemail.hu>
References: <freemail.20150710192845.67858.3@fmxmldata06.freemail.hu>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
From: Anand Jain <Anand.Jain@oracle.com>
Message-ID: <55A33216.7070709@oracle.com>
Date: Mon, 13 Jul 2015 11:35:50 +0800
MIME-Version: 1.0
In-Reply-To: <freemail.20150710192845.67858.3@fmxmldata06.freemail.hu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





On 07/11/2015 01:28 AM, None None wrote:
> I can't apply your patch on btrfs-progs v4.1 nor v4.0
> http://www.spinics.net/lists/linux-btrfs/msg43422.html
> git apply --check
> error: Documentation/btrfs-device.txt: No such file or directory
> error: patch failed: cmds-device.c:169
> error: cmds-device.c: patch does not apply

  I have rebased it on latest now. Kindly find v2.

> http://www.spinics.net/lists/linux-btrfs/msg43646.html
> git apply --check
> does not return any errors for the kernel patch with 4.1
>
>
> Are these patches included in the new 4.2-rc1 kernel?

No.

> Also isn't "missing" for cases when a device is not available anymore, why would I want to delete a device by ID?

  Its for the similar situation where you need to replace the device
  with out reading the src-device.

Thanks, Anand



>
> Anand Jain <Anand.Jain@oracle.com> írta:
>>
>>   The patches sent before helps to delete device without
>>   reading the device to be deleted. So it should help here.
>>   Can you try,
>>
>>     [PATCH V2 1/8] Btrfs: device delete by devid
>>     [PATCH 2/2] btrfs-progs: device delete to accept devid
>>
>> Thanks, Anand
>>
>> On 07/10/2015 12:05 PM, None None wrote:
>>> One of my 3TB drives failed (not recognized anymore) recently so I got two new 4TB drives, I mounted the fs with -o degraded and used "btrfs dev add" to add the new drives then I did "btrfs dev del missing".
>>> Now delete missing always returns an error
>>> ERROR: error removing the device 'missing' - Input/output error
>>>
>>> According to dmesg sda returns bad data but the smart values for it seem fine.
>>> How do I get the FS working again?
>>>
>>>
>>>
>>> Debian/SID, kernel v4.1
>>>
>>>
>>>
>>> # btrfs fi df /srv/
>>> Data, RAID5: total=18.96TiB, used=18.52TiB
>>> System, RAID1: total=32.00MiB, used=2.30MiB
>>> Metadata, RAID1: total=24.06GiB, used=22.09GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>
>>>
>>>
>>> # btrfs fi sho
>>> Label: none  uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
>>>           Total devices 11 FS bytes used 18.54TiB
>>>           devid    1 size 2.73TiB used 2.56TiB path /dev/sdh
>>>           devid    2 size 2.73TiB used 2.63TiB path /dev/sdg
>>>           devid    3 size 2.73TiB used 2.64TiB path /dev/sdj
>>>           devid    4 size 2.73TiB used 2.60TiB path /dev/sdk
>>>           devid    5 size 2.73TiB used 2.63TiB path /dev/sdb
>>>           devid    6 size 2.73TiB used 2.73TiB path /dev/sda
>>>           devid    9 size 2.73TiB used 2.73TiB path /dev/sdd
>>>           devid   10 size 2.73TiB used 2.73TiB path /dev/sdl
>>>           devid   11 size 3.64TiB used 2.66GiB path /dev/sdc
>>>           devid   12 size 3.64TiB used 2.66GiB path /dev/sde
>>>           *** Some devices missing
>>>
>>> btrfs-progs v4.0
>>>
>>>
>>>
>>> # dmesg | tail -n 40
>>> [ 9474.630480] BTRFS warning (device sda): csum failed ino 384 off 2927886336 csum 1204172668 expected csum 3738892907
>>> [ 9474.630487] BTRFS warning (device sda): csum failed ino 384 off 2927919104 csum 729502971 expected csum 57406087
>>> [ 9474.630493] BTRFS warning (device sda): csum failed ino 384 off 2927923200 csum 1688454633 expected csum 4263548653
>>> [ 9474.630495] BTRFS warning (device sda): csum failed ino 384 off 2927927296 csum 3679588162 expected csum 4283532667
>>> [ 9484.066796] BTRFS info (device sda): relocating block group 66338809643008 flags 129
>>> [ 9505.492349] __readpage_endio_check: 6 callbacks suppressed
>>> [ 9505.492356] BTRFS warning (device sda): csum failed ino 385 off 2927886336 csum 1204172668 expected csum 3738892907
>>> [ 9505.492366] BTRFS warning (device sda): csum failed ino 385 off 2927890432 csum 645393967 expected csum 1519548271
>>> [ 9505.492372] BTRFS warning (device sda): csum failed ino 385 off 2927894528 csum 3254966910 expected csum 2168664573
>>> [ 9505.492377] BTRFS warning (device sda): csum failed ino 385 off 2927898624 csum 3464250141 expected csum 1621289634
>>> [ 9505.492382] BTRFS warning (device sda): csum failed ino 385 off 2927902720 csum 2214000308 expected csum 2797028572
>>> [ 9505.492387] BTRFS warning (device sda): csum failed ino 385 off 2927906816 csum 3719155761 expected csum 561200354
>>> [ 9505.492392] BTRFS warning (device sda): csum failed ino 385 off 2927910912 csum 98768328 expected csum 1311354303
>>> [ 9505.492397] BTRFS warning (device sda): csum failed ino 385 off 2927915008 csum 996429330 expected csum 1552366519
>>> [ 9505.492402] BTRFS warning (device sda): csum failed ino 385 off 2927919104 csum 729502971 expected csum 57406087
>>> [ 9505.492407] BTRFS warning (device sda): csum failed ino 385 off 2927923200 csum 1688454633 expected csum 4263548653
>>> [ 9515.428150] BTRFS info (device sda): relocating block group 66338809643008 flags 129
>>> [ 9534.605158] __readpage_endio_check: 7 callbacks suppressed
>>> [ 9534.605165] BTRFS warning (device sda): csum failed ino 386 off 2927886336 csum 1204172668 expected csum 3738892907
>>> [ 9534.605174] BTRFS warning (device sda): csum failed ino 386 off 2927890432 csum 645393967 expected csum 1519548271
>>> [ 9534.605184] BTRFS warning (device sda): csum failed ino 386 off 2927894528 csum 3254966910 expected csum 2168664573
>>> [ 9534.605192] BTRFS warning (device sda): csum failed ino 386 off 2927898624 csum 3464250141 expected csum 1621289634
>>> [ 9534.605194] BTRFS warning (device sda): csum failed ino 386 off 2927902720 csum 2214000308 expected csum 2797028572
>>> [ 9534.605198] BTRFS warning (device sda): csum failed ino 386 off 2927906816 csum 3719155761 expected csum 561200354
>>> [ 9534.605204] BTRFS warning (device sda): csum failed ino 386 off 2927910912 csum 98768328 expected csum 1311354303
>>> [ 9534.605206] BTRFS warning (device sda): csum failed ino 386 off 2927915008 csum 996429330 expected csum 1552366519
>>> [ 9534.605212] BTRFS warning (device sda): csum failed ino 386 off 2927919104 csum 729502971 expected csum 57406087
>>> [ 9534.605215] BTRFS warning (device sda): csum failed ino 386 off 2927923200 csum 1688454633 expected csum 4263548653
>>> [ 9543.317995] BTRFS info (device sda): relocating block group 66338809643008 flags 129
>>> [ 9564.879155] __readpage_endio_check: 7 callbacks suppressed
>>> [ 9564.879161] BTRFS warning (device sda): csum failed ino 387 off 2927886336 csum 1204172668 expected csum 3738892907
>>> [ 9564.879171] BTRFS warning (device sda): csum failed ino 387 off 2927890432 csum 645393967 expected csum 1519548271
>>> [ 9564.879176] BTRFS warning (device sda): csum failed ino 387 off 2927894528 csum 3254966910 expected csum 2168664573
>>> [ 9564.879182] BTRFS warning (device sda): csum failed ino 387 off 2927898624 csum 3464250141 expected csum 1621289634
>>> [ 9564.879187] BTRFS warning (device sda): csum failed ino 387 off 2927902720 csum 2214000308 expected csum 2797028572
>>> [ 9564.879192] BTRFS warning (device sda): csum failed ino 387 off 2927906816 csum 3719155761 expected csum 561200354
>>> [ 9564.879196] BTRFS warning (device sda): csum failed ino 387 off 2927910912 csum 98768328 expected csum 1311354303
>>> [ 9564.879202] BTRFS warning (device sda): csum failed ino 387 off 2927915008 csum 996429330 expected csum 1552366519
>>> [ 9564.879207] BTRFS warning (device sda): csum failed ino 387 off 2927919104 csum 729502971 expected csum 57406087
>>> [ 9564.879212] BTRFS warning (device sda): csum failed ino 387 off 2927923200 csum 1688454633 expected csum 4263548653
>>>
>>>
>>>
>>> # smartctl -a /dev/sda
>>> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.1.0-custom+] (local build)
>>> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Seagate Barracuda 7200.14 (AF)
>>> Device Model:     ST3000DM001-1CH166
>>> Serial Number:    XXXXXXXX
>>> LU WWN Device Id: 5 000c50 04eee2715
>>> Firmware Version: CC29
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    7200 rpm
>>> Form Factor:      3.5 inches
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
>>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
>>> Local Time is:    Fri Jul 10 03:43:08 2015 UTC
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> General SMART Values:
>>> Offline data collection status:  (0x82) Offline data collection activity
>>>                                           was completed without error.
>>>                                           Auto Offline Data Collection: Enabled.
>>> Self-test execution status:      (   0) The previous self-test routine completed
>>>                                           without error or no self-test has ever
>>>                                           been run.
>>> Total time to complete Offline
>>> data collection:                (  584) seconds.
>>> Offline data collection
>>> capabilities:                    (0x7b) SMART execute Offline immediate.
>>>                                           Auto Offline data collection on/off support.
>>>                                           Suspend Offline collection upon new
>>>                                           command.
>>>                                           Offline surface scan supported.
>>>                                           Self-test supported.
>>>                                           Conveyance Self-test supported.
>>>                                           Selective Self-test supported.
>>> SMART capabilities:            (0x0003) Saves SMART data before entering
>>>                                           power-saving mode.
>>>                                           Supports SMART auto save timer.
>>> Error logging capability:        (0x01) Error logging supported.
>>>                                           General Purpose Logging supported.
>>> Short self-test routine
>>> recommended polling time:        (   1) minutes.
>>> Extended self-test routine
>>> recommended polling time:        ( 336) minutes.
>>> Conveyance self-test routine
>>> recommended polling time:        (   2) minutes.
>>> SCT capabilities:              (0x3085) SCT Status supported.
>>>
>>> SMART Attributes Data Structure revision number: 10
>>> Vendor Specific SMART Attributes with Thresholds:
>>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>>>     1 Raw_Read_Error_Rate     0x000f   108   099   006    Pre-fail  Always       -       15470024
>>>     3 Spin_Up_Time            0x0003   094   093   000    Pre-fail  Always       -       0
>>>     4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       92
>>>     5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
>>>     7 Seek_Error_Rate         0x000f   075   059   030    Pre-fail  Always       -       47614627725
>>>     9 Power_On_Hours          0x0032   077   077   000    Old_age   Always       -       20473
>>>    10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
>>>    12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       91
>>> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
>>> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
>>> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
>>> 188 Command_Timeout         0x0032   100   099   000    Old_age   Always       -       0 0 6
>>> 189 High_Fly_Writes         0x003a   083   083   000    Old_age   Always       -       17
>>> 190 Airflow_Temperature_Cel 0x0022   067   061   045    Old_age   Always       -       33 (Min/Max 26/33)
>>> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
>>> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       42
>>> 193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       219
>>> 194 Temperature_Celsius     0x0022   033   040   000    Old_age   Always       -       33 (0 17 0 0 0)
>>> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
>>> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
>>> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
>>> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       20467h+17m+19.660s
>>> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       127039808220
>>> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       92772194111
>>>
>>> SMART Error Log Version: 1
>>> No Errors Logged
>>>
>>> SMART Self-test log structure revision number 1
>>> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>>>
>>> SMART Selective self-test log data structure revision number 1
>>>    SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>>>       1        0        0  Not_testing
>>>       2        0        0  Not_testing
>>>       3        0        0  Not_testing
>>>       4        0        0  Not_testing
>>>       5        0        0  Not_testing
>>> Selective self-test flags (0x0):
>>>     After scanning selected spans, do NOT read-scan remainder of disk.
>>> If Selective self-test is pending on power-up, resume after 0 minute delay.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
