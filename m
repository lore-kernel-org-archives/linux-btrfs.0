Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36307 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbbBHRMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 12:12:24 -0500
Received: by mail-lb0-f175.google.com with SMTP id n10so21516383lbv.6
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 09:12:22 -0800 (PST)
MIME-Version: 1.0
From: constantine <costas.magnuse@gmail.com>
Date: Sun, 8 Feb 2015 17:12:02 +0000
Message-ID: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
Subject: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

I have a Raid-1 btrfs filesystem with 5 devices and I was running
btrfs scrub once a week. Unfortunately, one disk (4TB) failed.
I added two new  (6TB each) disks in the array and now I get:

# btrfs filesystem df /mnt/mountpoint
Data, RAID1: total=6.58TiB, used=6.57TiB
System, RAID1: total=32.00MiB, used=1.02MiB
Metadata, RAID1: total=11.00GiB, used=9.61GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Label: 'label'  uuid: 1d0d0850-d0bc-4376-96a3-177968ff2431
        Total devices 7 FS bytes used 6.58TiB
        devid    1 size 2.73TiB used 2.68TiB path /dev/sdi1
        devid    3 size 1.82TiB used 1.68TiB path /dev/sdd1
        devid    4 size 1.82TiB used 1.60TiB path /dev/sdc1
        devid    5 size 2.73TiB used 2.49TiB path /dev/sdg1
        devid    6 size 5.46TiB used 878.03GiB path /dev/sda
        devid    7 size 5.46TiB used 878.03GiB path /dev/sdb
        *** Some devices missing

This was working for some time (the new disks got ~878GB each):
# mount -o degraded /dev/sdi1 /mnt/mountpoint
# btrfs device delete missing /mnt/mountpoint

but it stopped with Input/Output error which appears again after
restarting my system.

# btrfs device delete missing /mnt/mountpoint
ERROR: error removing the device 'missing' - Input/output error

dmesg shows:
dmesg | grep BTRFS
[  117.535217] BTRFS info (device sdc1): relocating block group
10792241987584 flags 17
[  133.386996] BTRFS info (device sdc1): csum failed ino 257 off
541310976 csum 4144645530 expected csum 4144645376
[  133.413795] BTRFS info (device sdc1): csum failed ino 257 off
541310976 csum 4144645530 expected csum 4144645376
[  133.423884] BTRFS info (device sdc1): csum failed ino 257 off
541310976 csum 4144645530 expected csum 4144645376
[  303.627547] BTRFS info (device sdc1): relocating block group
10792241987584 flags 17
[  308.604231] BTRFS info (device sdc1): csum failed ino 258 off
541310976 csum 4144645530 expected csum 4144645376
[  308.631229] BTRFS info (device sdc1): csum failed ino 258 off
541310976 csum 4144645530 expected csum 4144645376
[  308.641205] BTRFS info (device sdc1): csum failed ino 258 off
541310976 csum 4144645530 expected csum 4144645376



What should be my next step?

Should I run a btrfs scrub?
Should I do a btrfsck?
Something else?
Can I somehow ignore or solve these sdc1 errors?
On the proposed solution, should the filesystem be mounted (in
degraded mode?) or not?


Thanks a lot! ;)


PS:
As you can see from the following, I should probably remove /dev/sdc,
too, right? I ignored the errors because they happened in ~7k hours
but at ~11k hours (and before) extended offline test(s) completed
successfully. I considered them to be "SATA-cable related errors".

#########################
####  smartctl -a /dev/sdi ####
#########################
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   173   173   021    Pre-fail
Always       -       6350
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       236
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   091   091   000    Old_age
Always       -       6887
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       220
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       141
193 Load_Cycle_Count        0x0032   189   189   000    Old_age
Always       -       33166
194 Temperature_Celsius     0x0022   125   098   000    Old_age
Always       -       25
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

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      6872         -
# 2  Short offline       Completed without error       00%      6850         -
# 3  Short offline       Completed without error       00%      6826         -
# 4  Short offline       Completed without error       00%      6802         -
# 5  Short offline       Completed without error       00%      6775         -
# 6  Short offline       Completed without error       00%      6751         -
# 7  Short offline       Completed without error       00%      6727         -
# 8  Short offline       Completed without error       00%      6703         -
# 9  Short offline       Completed without error       00%      6679         -
#10  Short offline       Completed without error       00%      6655         -
#11  Extended offline    Completed without error       00%      6640         -
#12  Short offline       Completed without error       00%      6632         -
#13  Short offline       Completed without error       00%      6607         -
#14  Short offline       Completed without error       00%      6583         -
#15  Short offline       Completed without error       00%      6560         -
#16  Short offline       Completed without error       00%      6536         -
#17  Short offline       Completed without error       00%      6512         -
#18  Short offline       Completed without error       00%      6488         -
#19  Extended offline    Completed without error       00%      6473         -
#20  Short offline       Completed without error       00%      6464         -
#21  Short offline       Completed without error       00%      6440         -

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


####  smartctl -a /dev/sdd ####

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   109   099   006    Pre-fail
Always       -       21614376
  3 Spin_Up_Time            0x0003   092   092   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       855
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       144
  7 Seek_Error_Rate         0x000f   078   060   030    Pre-fail
Always       -       71435522
  9 Power_On_Hours          0x0032   076   076   000    Old_age
Always       -       21605
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       765
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
190 Airflow_Temperature_Cel 0x0022   072   042   045    Old_age
Always   In_the_past 28 (0 15 33 17 0)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       351
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       990
194 Temperature_Celsius     0x0022   028   058   000    Old_age
Always       -       28 (0 13 0 0 0)
195 Hardware_ECC_Recovered  0x001a   024   003   000    Old_age
Always       -       21614376
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       20440 (165 78 0)
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       3218197508
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       3647327274

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Self-test routine in progress 90%     21605         -
# 2  Short offline       Completed without error       00%     21590         -
# 3  Short offline       Completed without error       00%     21568         -
# 4  Short offline       Completed without error       00%     21544         -
# 5  Short offline       Completed without error       00%     21520         -
# 6  Short offline       Completed without error       00%     21493         -
# 7  Short offline       Completed without error       00%     21469         -
# 8  Short offline       Completed without error       00%     21445         -
# 9  Short offline       Completed without error       00%     21421         -
#10  Short offline       Completed without error       00%     21397         -
#11  Short offline       Completed without error       00%     21373         -
#12  Extended offline    Completed without error       00%     21356         -
#13  Short offline       Completed without error       00%     21350         -
#14  Short offline       Completed without error       00%     21325         -
#15  Short offline       Completed without error       00%     21302         -
#16  Short offline       Completed without error       00%     21278         -
#17  Short offline       Completed without error       00%     21254         -
#18  Short offline       Completed without error       00%     21230         -
#19  Short offline       Completed without error       00%     21206         -
#20  Extended offline    Completed without error       00%     21189         -
#21  Short offline       Completed without error       00%     21182         -

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


#########################
####  smartctl -a /dev/sdc ####
#########################
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       1
  3 Spin_Up_Time            0x0027   180   178   021    Pre-fail
Always       -       6000
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       351
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   084   084   000    Old_age
Always       -       11890
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       316
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       204
193 Load_Cycle_Count        0x0032   123   123   000    Old_age
Always       -       233719
194 Temperature_Celsius     0x0022   125   102   000    Old_age
Always       -       25
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

SMART Error Log Version: 1
ATA Error Count: 39929 (device log contains only the most recent five errors)
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

Error 39929 occurred at disk power-on lifetime: 7923 hours (330 days + 3 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 61 02 00 00 00 a0  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  ef 10 02 00 00 00 a0 00      03:22:19.694  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.693  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      03:22:19.693  SET FEATURES [Set transfer mode]
  ef 10 02 00 00 00 a0 00      03:22:19.693  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.692  IDENTIFY DEVICE

Error 39928 occurred at disk power-on lifetime: 7923 hours (330 days + 3 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 61 46 00 00 00 a0  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  ef 03 46 00 00 00 a0 00      03:22:19.693  SET FEATURES [Set transfer mode]
  ef 10 02 00 00 00 a0 00      03:22:19.693  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.692  IDENTIFY DEVICE
  ef 10 02 00 00 00 a0 00      03:22:19.687  SET FEATURES [Enable SATA feature]

Error 39927 occurred at disk power-on lifetime: 7923 hours (330 days + 3 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 61 02 00 00 00 a0  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  ef 10 02 00 00 00 a0 00      03:22:19.693  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.692  IDENTIFY DEVICE
  ef 10 02 00 00 00 a0 00      03:22:19.687  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.686  IDENTIFY DEVICE

Error 39926 occurred at disk power-on lifetime: 7923 hours (330 days + 3 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 61 02 00 00 00 a0  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  ef 10 02 00 00 00 a0 00      03:22:19.687  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.686  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      03:22:19.686  SET FEATURES [Set transfer mode]
  ef 10 02 00 00 00 a0 00      03:22:19.686  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.684  IDENTIFY DEVICE

Error 39925 occurred at disk power-on lifetime: 7923 hours (330 days + 3 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 61 46 00 00 00 a0  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  ef 03 46 00 00 00 a0 00      03:22:19.686  SET FEATURES [Set transfer mode]
  ef 10 02 00 00 00 a0 00      03:22:19.686  SET FEATURES [Enable SATA feature]
  ec 00 00 00 00 00 a0 00      03:22:19.684  IDENTIFY DEVICE
  ef 10 02 00 00 00 a0 00      03:22:19.678  SET FEATURES [Enable SATA feature]

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     11875         -
# 2  Short offline       Completed without error       00%     11853         -
# 3  Short offline       Completed without error       00%     11829         -
# 4  Short offline       Completed without error       00%     11804         -
# 5  Short offline       Completed without error       00%     11778         -
# 6  Short offline       Completed without error       00%     11754         -
# 7  Short offline       Completed without error       00%     11730         -
# 8  Short offline       Completed without error       00%     11706         -
# 9  Short offline       Completed without error       00%     11682         -
#10  Short offline       Completed without error       00%     11658         -
#11  Extended offline    Completed without error       00%     11641         -
#12  Short offline       Completed without error       00%     11634         -
#13  Short offline       Completed without error       00%     11610         -
#14  Short offline       Completed without error       00%     11586         -
#15  Short offline       Completed without error       00%     11563         -
#16  Short offline       Completed without error       00%     11539         -
#17  Short offline       Completed without error       00%     11515         -
#18  Short offline       Completed without error       00%     11491         -
#19  Extended offline    Completed without error       00%     11474         -
#20  Short offline       Completed without error       00%     11467         -
#21  Short offline       Completed without error       00%     11443         -

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

#########################
####  smartctl -a /dev/sdg ####
#########################
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   116   099   006    Pre-fail
Always       -       106908352
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       209
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   077   060   030    Pre-fail
Always       -       4348513412
  9 Power_On_Hours          0x0032   089   089   000    Old_age
Always       -       10333
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       221
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
190 Airflow_Temperature_Cel 0x0022   070   046   045    Old_age
Always       -       30 (Min/Max 13/42)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       155
193 Load_Cycle_Count        0x0032   093   093   000    Old_age
Always       -       15629
194 Temperature_Celsius     0x0022   030   054   000    Old_age
Always       -       30 (0 13 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       9237h+36m+04.967s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       37444358230
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       141936622515

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Self-test routine in progress 90%     10333         -
# 2  Short offline       Completed without error       00%     10318         -
# 3  Short offline       Completed without error       00%     10296         -
# 4  Short offline       Completed without error       00%     10272         -
# 5  Short offline       Completed without error       00%     10248         -
# 6  Short offline       Completed without error       00%     10223         -
# 7  Short offline       Completed without error       00%     10199         -
# 8  Short offline       Completed without error       00%     10175         -
# 9  Short offline       Completed without error       00%     10151         -
#10  Short offline       Completed without error       00%     10127         -
#11  Short offline       Completed without error       00%     10103         -
#12  Extended offline    Completed without error       00%     10085         -
#13  Short offline       Completed without error       00%     10079         -
#14  Short offline       Completed without error       00%     10055         -
#15  Short offline       Completed without error       00%     10031         -
#16  Short offline       Completed without error       00%     10008         -
#17  Short offline       Completed without error       00%      9984         -
#18  Short offline       Completed without error       00%      9960         -
#19  Short offline       Completed without error       00%      9936         -
#20  Extended offline    Completed without error       00%      9918         -
#21  Short offline       Completed without error       00%      9912         -

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

#########################
####  smartctl -a /dev/sda ####
#########################
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   253   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   100   253   021    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       5
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       19
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       5
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       0
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       23
194 Temperature_Celsius     0x0022   126   118   000    Old_age
Always       -       26
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%         4         -
# 2  Short offline       Completed without error       00%         0         -
# 3  Short offline       Completed without error       00%         0         -

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

#########################
####  smartctl -a /dev/sdb ####
#########################
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   253   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   100   253   021    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       4
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       19
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       4
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       0
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       20
194 Temperature_Celsius     0x0022   125   120   000    Old_age
Always       -       27
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%         4         -
# 2  Short offline       Completed without error       00%         0         -

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
