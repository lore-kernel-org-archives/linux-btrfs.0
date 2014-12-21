Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:49284 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbaLUV44 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 16:56:56 -0500
Message-ID: <54974226.2080300@pobox.com>
Date: Sun, 21 Dec 2014 13:56:54 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: constantine <costas.magnuse@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Uncorrectable errors on RAID-1?
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
In-Reply-To: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/21/2014 11:34 AM, constantine wrote:
> Some months ago I had 6 uncorrectable errors. I deleted the files that
> contained them and then after scrubbing I had 0 uncorrectable errors.
> After some weeks I encountered new uncorrectable errors.
>
> Question 1:
> Why do I have uncorrectable errors on a RAID-1 filesystem in the first place?

These are disk/platter/hardware errors. They happen for one of two 
reasons. (most likely) There is a flaw, new or existing, on the platter 
itself and data just cannot live in that spot. (least likely) You 
suffered an environmental hazard (hard jolt) while a sector was being 
written and the drive is just choking on the digital wreckage.


> Question 2:
> How do I properly correct them? (Again by deleting their files? :( )

You have to _force_ the system to write the sector. If the disk can 
correct the sector (not a hardware flaw) the problem goes away forever. 
If it can't the drive will re-map the sector with a spare sector and it 
will seem to go away forever.

Here is a decent tutorial :: 
http://smartmontools.sourceforge.net/badblockhowto.html and which 
version of things you need to do will vary by hardware, so read the 
whole thing.

_BUT_ on my system I had to use hdparam to write the sectors instead of 
just using dd. Math is involved to find the LBA and you have to use the 
"yes I really know what I am doing" option to force the write at the low 
level.

[Quick version :: smartctl --test=long (or range if you know the range). 
Test will stop on the read error. Force writ the the "lba of first 
error" block with hdparam or use the sg-spare thing. Repeat until the 
long test will read the entire drive.

My current smartctl --all /dev/sda shows that recent remapping exercise.

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     36605 
      -
# 2  Selective offline   Completed without error       00%     36603 
      -
# 3  Selective offline   Aborted by host               90%     36603 
      -
# 4  Selective offline   Completed without error       00%     36603 
      -
# 5  Selective offline   Completed: read failure       90%     36603 
      19530186
# 6  Selective offline   Completed: read failure       90%     36603 
      19530182
# 7  Extended offline    Completed: read failure       90%     36602 
      19530182
# 8  Extended offline    Completed: read failure       90%     36602 
      19530182
# 9  Extended offline    Completed: read failure       90%     36592 
      19530182
#10  Extended offline    Completed: read failure       90%     36094 
      19530182
#11  Extended offline    Completed without error       00%      4222 
      -
6 of 6 failed self-tests are outdated by newer successful extended 
offline self-test # 1


The good news is that since you are using RAID1 and checksums you 
shouldn't need to delete any files. Just coerce the write and then btrfs 
scrub your filesystem and the checksum/rewrite thing should recover the 
degraded copy from the good copy in the mirror.

>
> Question 3:
> How do I prevent this from happening?

If the disk only shows an error or two it's probably still in normal 
range. If you have to spare out a lot of sectors then your disk may be 
reaching end-of-life and so likely needs replacing.

ALL DISKS FAIL EVENTUALLY so you don't "prevent it from happening". You 
use RAID1 (etc) and backups to prevent data loss and you periodically 
run the tests and check the output to prevent data loss.

That is, you can't prevent eventual disk loss, your job is to prevent 
data loss. So good on you for the RAID1

>
>
> Thanks a lot!
>
> constantine

>
> PS.
> The disks can be considered old (some with > 15000 hrs online), but
> SMART long tests complete without errors. I have this filesystem:

I don't see the smart test results in any of these blocks. Are you sure 
you are looking at the correct part of the results? You should have been 
showing us the table after the heading "SMART Self-test log structure 
revision number 1" if you are trying to show us tests completing without 
errors.

See smartctl --all and/or --xall output, e.g. _lower_ _case_ "a" or "x", 
not upper case "A" "attributes", test results will be near the bottom.

The "attribute" section is interesting but not dispositive of recent 
test results. It only shows non-test event counters.

>
> # btrfs fi show /mnt/thefilesystem
> Label: 'thefilesystem'  uuid: 1d1d0850-d1bc-4c76-96a1-17d168ff2431
>          Total devices 5 FS bytes used 6.11TiB
>          devid    1 size 2.73TiB used 2.63TiB path /dev/sda1
>          devid    2 size 3.64TiB used 3.54TiB path /dev/sdg1
>          devid    3 size 1.82TiB used 1.72TiB path /dev/sdd1
>          devid    4 size 1.82TiB used 1.72TiB path /dev/sdc1
>          devid    5 size 2.73TiB used 2.63TiB path /dev/sdh1
>
> Btrfs v3.17.3
>
> # btrfs fi df /mnt/thefilesystem
> Data, RAID1: total=6.10TiB, used=6.10TiB
> System, RAID1: total=32.00MiB, used=896.00KiB
> Metadata, RAID1: total=10.00GiB, used=8.98GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> ===================
> SMART information from each of the disks:
>
> # for i in  a g d c h ; do smartctl -A /dev/sd$i; done
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
>    3 Spin_Up_Time            0x0027   177   175   021    Pre-fail
> Always       -       6108
>    4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       201
>    5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>    7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
>    9 Power_On_Hours          0x0032   093   093   000    Old_age
> Always       -       5836
>   10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
>   11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
>   12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       185
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       118
> 193 Load_Cycle_Count        0x0032   189   189   000    Old_age
> Always       -       33154
> 194 Temperature_Celsius     0x0022   114   098   000    Old_age
> Always       -       36
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
> Offline      -       0
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
>    3 Spin_Up_Time            0x0027   179   175   021    Pre-fail
> Always       -       8050
>    4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       141
>    5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>    7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
>    9 Power_On_Hours          0x0032   094   094   000    Old_age
> Always       -       4842
>   10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
>   11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
>   12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       140
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       91
> 193 Load_Cycle_Count        0x0032   194   194   000    Old_age
> Always       -       18614
> 194 Temperature_Celsius     0x0022   114   100   000    Old_age
> Always       -       38
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
> Offline      -       0
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x000f   102   099   006    Pre-fail
> Always       -       4738696
>    3 Spin_Up_Time            0x0003   092   092   000    Pre-fail
> Always       -       0
>    4 Start_Stop_Count        0x0032   100   100   020    Old_age
> Always       -       836
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       144
>    7 Seek_Error_Rate         0x000f   078   060   030    Pre-fail
> Always       -       69594766
>    9 Power_On_Hours          0x0032   077   077   000    Old_age
> Always       -       20554
>   10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> Always       -       0
>   12 Power_Cycle_Count       0x0032   100   100   020    Old_age
> Always       -       721
> 183 Runtime_Bad_Block       0x0032   092   092   000    Old_age
> Always       -       8
> 184 End-to-End_Error        0x0032   100   100   099    Old_age
> Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age
> Always       -       0
> 188 Command_Timeout         0x0032   100   099   000    Old_age
> Always       -       14
> 189 High_Fly_Writes         0x003a   097   097   000    Old_age
> Always       -       3
> 190 Airflow_Temperature_Cel 0x0022   068   042   045    Old_age
> Always   In_the_past 32 (0 15 39 23 0)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
> Always       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> Always       -       320
> 193 Load_Cycle_Count        0x0032   100   100   000    Old_age
> Always       -       947
> 194 Temperature_Celsius     0x0022   032   058   000    Old_age
> Always       -       32 (0 13 0 0 0)
> 195 Hardware_ECC_Recovered  0x001a   014   003   000    Old_age
> Always       -       4738696
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
> Always       -       0
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age
> Offline      -       19390 (116 2 0)
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age
> Offline      -       2165686930
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age
> Offline      -       1913785108
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       1
>    3 Spin_Up_Time            0x0027   182   178   021    Pre-fail
> Always       -       5900
>    4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       310
>    5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>    7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
>    9 Power_On_Hours          0x0032   086   086   000    Old_age
> Always       -       10839
>   10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
>   11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
>   12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       275
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       175
> 193 Load_Cycle_Count        0x0032   123   123   000    Old_age
> Always       -       233706
> 194 Temperature_Celsius     0x0022   120   102   000    Old_age
> Always       -       30
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
> Offline      -       0
>
> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail
> Always       -       154070800
>    3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
> Always       -       0
>    4 Start_Stop_Count        0x0032   100   100   020    Old_age
> Always       -       198
>    5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
> Always       -       0
>    7 Seek_Error_Rate         0x000f   077   060   030    Pre-fail
> Always       -       4346841135
>    9 Power_On_Hours          0x0032   090   090   000    Old_age
> Always       -       9283
>   10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> Always       -       0
>   12 Power_Cycle_Count       0x0032   100   100   020    Old_age
> Always       -       185
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
> Always       -       0
> 184 End-to-End_Error        0x0032   100   100   099    Old_age
> Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age
> Always       -       0
> 188 Command_Timeout         0x0032   100   100   000    Old_age
> Always       -       0 0 0
> 189 High_Fly_Writes         0x003a   098   098   000    Old_age
> Always       -       2
> 190 Airflow_Temperature_Cel 0x0022   065   046   045    Old_age
> Always       -       35 (Min/Max 23/45)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
> Always       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> Always       -       129
> 193 Load_Cycle_Count        0x0032   098   098   000    Old_age
> Always       -       5879
> 194 Temperature_Celsius     0x0022   035   054   000    Old_age
> Always       -       35 (0 19 0 0 0)
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
> Always       -       0
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age
> Offline      -       8753h+05m+40.278s
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age
> Offline      -       36640474598
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age
> Offline      -       94882096088
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

