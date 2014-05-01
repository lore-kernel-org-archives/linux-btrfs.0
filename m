Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53186 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaEARuR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 13:50:17 -0400
Message-ID: <53628953.8030707@friedels.name>
Date: Thu, 01 May 2014 19:50:11 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Very high load when reading/writing
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

I have very high load when writing/reading from/to two of my btrfs 
volumes.  One sda1, mounted as /mnt/BTRFS, the other, sdd2/sde2 (raid) as /
sda1 is a 3TB disc, whereas the sdd2/sde2 are small SSDs of 16GB.

I wrote a small script to demonstrate it. It does:
-echo what it will do
-show the current load
-dd from one volume to the other.
-show the current load
-sync and flush the cache
-sleep 300s in order to get the load down again.


Here the output:
Test from /mnt/BTRFS to /tmp
1.05 0.55, 0.41
124,553 s, 16,8 MB/s
6.98 2.94, 1.30

Test /mnt/BTRFS to /mnt/BTRFS
0.23 1.32, 1.10
127,008 s, 16,5 MB/s
4.76 2.82, 1.69

Test /mnt/BTRFS to /dev/null
0.17 1.29, 1.39
21,9972 s, 95,3 MB/s
0.64 1.31, 1.39

Test from /tmp to /mnt/BTRFS
0.23 0.64, 1.08
124,655 s, 16,8 MB/s
8.63 3.44, 2.03


I'm sure, this is not normal, is it?
What I mean:
The load is very high and the data rate is very low.

Below some Information on the Filesystems and Disks.

I'd appreciate any help to understand what's wrong.

Regards,
Hendrik



# ~/btrfs/integration/devel/btrfs fi show /mnt/BTRFS/Video/
Label: 'Daten'  uuid: d3ba0e97-24ae-4f94-b407-05bf2cd4ddf4
         Total devices 1 FS bytes used 2.31TiB
         devid    1 size 2.73TiB used 2.35TiB path /dev/sda1

Btrfs this-will-become-v3.13-48-g57c3600
# ~/btrfs/integration/devel/btrfs fi show /
Label: 'ROOT_BTRFS_RAID'  uuid: a2d5f2db-04ca-413a-aee1-cb754aa8fba5
         Total devices 2 FS bytes used 7.50GiB
         devid    1 size 14.85GiB used 14.36GiB path /dev/sde2
         devid    2 size 14.65GiB used 14.36GiB path /dev/sdd2





uname -r
3.14.0-031400rc4-generic


./btrfsck /dev/sda1
Checking filesystem on /dev/sda1
UUID: d3ba0e97-24ae-4f94-b407-05bf2cd4ddf4
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 1264928671538 bytes used err is 0
total csum bytes: 2475071700
total tree bytes: 2829418496
total fs tree bytes: 55672832
total extent tree bytes: 72744960
btree space waste bytes: 210148896
file data blocks allocated: 2535102173184
  referenced 2533075963904
Btrfs this-will-become-v3.13-48-g57c3600



Checking filesystem on /dev/sdd2
UUID: a2d5f2db-04ca-413a-aee1-cb754aa8fba5
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 423637793 bytes used err is 0
total csum bytes: 8078432
total tree bytes: 421920768
total fs tree bytes: 393560064
total extent tree bytes: 18857984
btree space waste bytes: 71825111
file data blocks allocated: 16775815168
  referenced 8751009792
Btrfs this-will-become-v3.13-48-g57c3600

smartctl -a  /dev/sdd2
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.14.0-031400rc4-generic] 
(local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     MXSSD2MSLD16G-V
Serial Number:    0YWOMT24NF16IB8U
Firmware Version: 20130221
User Capacity:    15.837.691.904 bytes [15,8 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Thu May  1 19:48:58 2014 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Total time to complete Offline
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x00)         Offline data collection 
not supported.
SMART capabilities:            (0x0002) Does not save SMART data before
                                         entering power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x00) Error logging NOT supported.
                                         No General Purpose Logging support.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x0000   100   100   050    Old_age 
Offline      -       0
   5 Reallocated_Sector_Ct   0x0002   100   100   050    Old_age 
Always       -       0
   9 Power_On_Hours          0x0000   100   100   050    Old_age 
Offline      -       4690
  12 Power_Cycle_Count       0x0000   100   100   050    Old_age 
Offline      -       15
160 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       0
161 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       136
162 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       121
163 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       4
164 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       847849
165 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       445
166 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       381
167 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       416
168 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       100000
169 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       100
192 Power-Off_Retract_Count 0x0000   100   100   050    Old_age 
Offline      -       0
194 Temperature_Celsius     0x0000   100   100   050    Old_age 
Offline      -       55
195 Hardware_ECC_Recovered  0x0000   100   100   050    Old_age 
Offline      -       0
196 Reallocated_Event_Count 0x0000   100   100   050    Old_age 
Offline      -       0
198 Offline_Uncorrectable   0x0000   100   100   050    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x0000   100   100   050    Old_age 
Offline      -       0
241 Total_LBAs_Written      0x0032   100   100   050    Old_age   Always 
       -       62687
242 Total_LBAs_Read         0x0032   100   100   050    Old_age   Always 
       -       7975

SMART Error Log not supported
Error SMART Error Self-Test Log Read failed: scsi error aborted command
Smartctl: SMART Self Test Log Read Failed
Device does not support Selective Self Tests/Logging



  smartctl -a  /dev/sde2
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.14.0-031400rc4-generic] 
(local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     MXSSD2MMSLF-16G
Serial Number:    AA00000000000108304
Firmware Version: M0424E
User Capacity:    16.047.407.104 bytes [16,0 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Thu May  1 19:47:45 2014 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Total time to complete Offline
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x00)         Offline data collection 
not supported.
SMART capabilities:            (0x0002) Does not save SMART data before
                                         entering power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x00) Error logging NOT supported.
                                         No General Purpose Logging support.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x0000   100   100   050    Old_age 
Offline      -       0
   5 Reallocated_Sector_Ct   0x0002   100   100   050    Old_age 
Always       -       0
  12 Power_Cycle_Count       0x0000   100   100   050    Old_age 
Offline      -       12
160 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       0
161 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       114
162 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       100
163 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       1
164 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       700678
165 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       373
166 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       308
167 Unknown_Attribute       0x0000   100   100   050    Old_age 
Offline      -       343
192 Power-Off_Retract_Count 0x0000   100   100   050    Old_age 
Offline      -       0
194 Temperature_Celsius     0x0000   100   100   050    Old_age 
Offline      -       25
195 Hardware_ECC_Recovered  0x0000   100   100   050    Old_age 
Offline      -       0
196 Reallocated_Event_Count 0x0000   100   100   050    Old_age 
Offline      -       0
198 Offline_Uncorrectable   0x0000   000   000   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x0000   100   100   050    Old_age 
Offline      -       0
241 Total_LBAs_Written      0x0032   100   100   050    Old_age   Always 
       -       68531
242 Total_LBAs_Read         0x0032   100   100   050    Old_age   Always 
       -       11949

SMART Error Log not supported
Error SMART Error Self-Test Log Read failed: scsi error aborted command
Smartctl: SMART Self Test Log Read Failed
Device does not support Selective Self Tests/Logging


root@homeserver:/mnt/BTRFS/Video# smartctl -a  /dev/sda1
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.14.0-031400rc4-generic] 
(local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-9YN166
Serial Number:    Z1F0HLRF
LU WWN Device Id: 5 000c50 03fe071a4
Firmware Version: CC4B
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Thu May  1 19:48:16 2014 CEST

==> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/223651en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      (  39) The self-test routine was 
interrupted
                                         by the host with a hard or soft 
reset.
Total time to complete Offline
data collection:                (  575) seconds.
Offline data collection
capabilities:                    (0x73) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         No Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 255) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   111   099   006    Pre-fail 
Always       -       41785552
   3 Spin_Up_Time            0x0003   092   092   000    Pre-fail 
Always       -       0
   4 Start_Stop_Count        0x0032   092   092   020    Old_age 
Always       -       9214
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail 
Always       -       0
   7 Seek_Error_Rate         0x000f   073   054   030    Pre-fail 
Always       -       34538763506
   9 Power_On_Hours          0x0032   065   065   000    Old_age 
Always       -       31127
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail 
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age 
Always       -       195
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always 
       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always 
       -       0
187 Reported_Uncorrect      0x0032   096   096   000    Old_age   Always 
       -       4
188 Command_Timeout         0x0032   100   099   000    Old_age   Always 
       -       4 4 4
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always 
       -       0
190 Airflow_Temperature_Cel 0x0022   070   050   045    Old_age   Always 
       -       30 (0 11 46 24)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always 
       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always 
       -       168
193 Load_Cycle_Count        0x0032   091   091   000    Old_age   Always 
       -       18955
194 Temperature_Celsius     0x0022   030   050   000    Old_age   Always 
       -       30 (Min/Max 0/32768)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age 
Offline      -       12713h+28m+42.648s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age 
Offline      -       198677093686033
242 Total_LBAs_Read         0x0000   100   253   000    Old_age 
Offline      -       255171735004347

SMART Error Log Version: 1
ATA Error Count: 4
         CR = Command Register [HEX]
         FR = Features Register [HEX]
         SC = Sector Count Register [HEX]
         SN = Sector Number Register [HEX]
         CL = Cylinder Low Register [HEX]
         CH = Cylinder High Register [HEX]
         DH = Device/Head Register [HEX]
         DC = Device Command Register [HEX]
         ER = Error register [HEX]
         ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 4 occurred at disk power-on lifetime: 29355 hours (1223 days + 3 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   60 00 08 ff ff ff 4f 00  20d+22:23:53.940  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  20d+22:23:53.940  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  20d+22:23:53.939  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  20d+22:23:53.939  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  20d+22:23:53.923  READ FPDMA QUEUED

Error 3 occurred at disk power-on lifetime: 29355 hours (1223 days + 3 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   60 00 80 ff ff ff 4f 00  20d+22:23:50.852  READ FPDMA QUEUED
   60 00 00 ff ff ff 4f 00  20d+22:23:50.852  READ FPDMA QUEUED
   60 00 00 ff ff ff 4f 00  20d+22:23:50.851  READ FPDMA QUEUED
   60 00 08 d0 ac 14 40 00  20d+22:23:50.834  READ FPDMA QUEUED
   60 00 b0 ff ff ff 4f 00  20d+22:23:50.823  READ FPDMA QUEUED

Error 2 occurred at disk power-on lifetime: 29328 hours (1222 days + 0 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   60 00 08 ff ff ff 4f 00  19d+19:57:48.409  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  19d+19:57:48.409  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  19d+19:57:48.409  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  19d+19:57:48.409  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  19d+19:57:48.392  READ FPDMA QUEUED

Error 1 occurred at disk power-on lifetime: 29328 hours (1222 days + 0 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   60 00 80 ff ff ff 4f 00  19d+19:57:45.214  READ FPDMA QUEUED
   60 00 00 ff ff ff 4f 00  19d+19:57:45.214  READ FPDMA QUEUED
   60 00 00 ff ff ff 4f 00  19d+19:57:45.213  READ FPDMA QUEUED
   60 00 08 ff ff ff 4f 00  19d+19:57:45.198  READ FPDMA QUEUED
   60 00 80 ff ff ff 4f 00  19d+19:57:45.190  READ FPDMA QUEUED

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      70%     31123 
      -
# 2  Short offline       Completed without error       00%     31110 
      -
# 3  Short offline       Completed without error       00%     31085 
      -
# 4  Short offline       Completed without error       00%     31061 
      -
# 5  Short offline       Completed without error       00%     31037 
      -
# 6  Short offline       Completed without error       00%     31013 
      -
# 7  Extended offline    Completed without error       00%     30995 
      -
# 8  Short offline       Completed without error       00%     30989 
      -
# 9  Short offline       Completed without error       00%     30965 
      -
#10  Short offline       Completed without error       00%     30941 
      -
#11  Short offline       Completed without error       00%     30917 
      -
#12  Short offline       Completed without error       00%     30893 
      -
#13  Short offline       Completed without error       00%     30869 
      -
#14  Short offline       Completed without error       00%     30845 
      -
#15  Extended offline    Completed without error       00%     30827 
      -
#16  Short offline       Completed without error       00%     30821 
      -
#17  Short offline       Completed without error       00%     30797 
      -
#18  Short offline       Completed without error       00%     30773 
      -
#19  Short offline       Completed without error       00%     30749 
      -
#20  Short offline       Completed without error       00%     30725 
      -
#21  Short offline       Completed without error       00%     30701 
      -

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

---
Diese E-Mail ist frei von Viren und Malware, denn der avast! Antivirus Schutz ist aktiv.
http://www.avast.com

