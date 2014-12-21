Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:35842 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaLUTep (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 14:34:45 -0500
Received: by mail-la0-f43.google.com with SMTP id s18so3074864lam.2
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 11:34:43 -0800 (PST)
MIME-Version: 1.0
From: constantine <costas.magnuse@gmail.com>
Date: Sun, 21 Dec 2014 19:34:22 +0000
Message-ID: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
Subject: Uncorrectable errors on RAID-1?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some months ago I had 6 uncorrectable errors. I deleted the files that
contained them and then after scrubbing I had 0 uncorrectable errors.
After some weeks I encountered new uncorrectable errors.

Question 1:
Why do I have uncorrectable errors on a RAID-1 filesystem in the first place?

Question 2:
How do I properly correct them? (Again by deleting their files? :( )

Question 3:
How do I prevent this from happening?


Thanks a lot!

constantine

PS.
The disks can be considered old (some with > 15000 hrs online), but
SMART long tests complete without errors. I have this filesystem:

# btrfs fi show /mnt/thefilesystem
Label: 'thefilesystem'  uuid: 1d1d0850-d1bc-4c76-96a1-17d168ff2431
        Total devices 5 FS bytes used 6.11TiB
        devid    1 size 2.73TiB used 2.63TiB path /dev/sda1
        devid    2 size 3.64TiB used 3.54TiB path /dev/sdg1
        devid    3 size 1.82TiB used 1.72TiB path /dev/sdd1
        devid    4 size 1.82TiB used 1.72TiB path /dev/sdc1
        devid    5 size 2.73TiB used 2.63TiB path /dev/sdh1

Btrfs v3.17.3

# btrfs fi df /mnt/thefilesystem
Data, RAID1: total=6.10TiB, used=6.10TiB
System, RAID1: total=32.00MiB, used=896.00KiB
Metadata, RAID1: total=10.00GiB, used=8.98GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

===================
SMART information from each of the disks:

# for i in  a g d c h ; do smartctl -A /dev/sd$i; done
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   177   175   021    Pre-fail
Always       -       6108
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       201
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   093   093   000    Old_age
Always       -       5836
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       185
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       118
193 Load_Cycle_Count        0x0032   189   189   000    Old_age
Always       -       33154
194 Temperature_Celsius     0x0022   114   098   000    Old_age
Always       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   179   175   021    Pre-fail
Always       -       8050
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       141
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   094   094   000    Old_age
Always       -       4842
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       140
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       91
193 Load_Cycle_Count        0x0032   194   194   000    Old_age
Always       -       18614
194 Temperature_Celsius     0x0022   114   100   000    Old_age
Always       -       38
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   102   099   006    Pre-fail
Always       -       4738696
  3 Spin_Up_Time            0x0003   092   092   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       836
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       144
  7 Seek_Error_Rate         0x000f   078   060   030    Pre-fail
Always       -       69594766
  9 Power_On_Hours          0x0032   077   077   000    Old_age
Always       -       20554
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       721
183 Runtime_Bad_Block       0x0032   092   092   000    Old_age
Always       -       8
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   099   000    Old_age
Always       -       14
189 High_Fly_Writes         0x003a   097   097   000    Old_age
Always       -       3
190 Airflow_Temperature_Cel 0x0022   068   042   045    Old_age
Always   In_the_past 32 (0 15 39 23 0)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       320
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       947
194 Temperature_Celsius     0x0022   032   058   000    Old_age
Always       -       32 (0 13 0 0 0)
195 Hardware_ECC_Recovered  0x001a   014   003   000    Old_age
Always       -       4738696
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       19390 (116 2 0)
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       2165686930
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       1913785108

smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       1
  3 Spin_Up_Time            0x0027   182   178   021    Pre-fail
Always       -       5900
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       310
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   086   086   000    Old_age
Always       -       10839
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       275
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       175
193 Load_Cycle_Count        0x0032   123   123   000    Old_age
Always       -       233706
194 Temperature_Celsius     0x0022   120   102   000    Old_age
Always       -       30
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-1-bfs] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail
Always       -       154070800
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       198
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   077   060   030    Pre-fail
Always       -       4346841135
  9 Power_On_Hours          0x0032   090   090   000    Old_age
Always       -       9283
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       185
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0 0 0
189 High_Fly_Writes         0x003a   098   098   000    Old_age
Always       -       2
190 Airflow_Temperature_Cel 0x0022   065   046   045    Old_age
Always       -       35 (Min/Max 23/45)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       129
193 Load_Cycle_Count        0x0032   098   098   000    Old_age
Always       -       5879
194 Temperature_Celsius     0x0022   035   054   000    Old_age
Always       -       35 (0 19 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       8753h+05m+40.278s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       36640474598
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       94882096088
