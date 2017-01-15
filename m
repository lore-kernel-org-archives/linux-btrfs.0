Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz10.laposte.net ([194.117.213.175]:56172 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751224AbdAOUeG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 15:34:06 -0500
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout004 (Postfix) with ESMTP id A49D45933FE
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jan 2017 21:28:01 +0100 (CET)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout004 (Postfix) with ESMTP id 86AD758DA6C
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jan 2017 21:28:01 +0100 (CET)
Date: Sun, 15 Jan 2017 21:28:01 +0100 (CET)
From: "randomtechguy@laposte.net" <randomtechguy@laposte.net>
Reply-To: randomtechguy@laposte.net
To: linux-btrfs@vger.kernel.org
Message-ID: <997304564.3648227.1484512081332.JavaMail.zimbra@laposte.net>
In-Reply-To: <13125824.3612316.1484511403145.JavaMail.zimbra@laposte.net>
Subject: [ISSUE] uncorrectable errors on Raid1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello /all, 

I have some concerns about the raid 1 of BTRFS. I have encountered 114 uncorrectable errors on the directory hosting my 'seafile-data'. Seafile is a software to backup the data. My 2 hard drives seems to be fined. SMARTCTL reports do not identify any badlocks (Reallocated_Event_Count or Current_Pending_Sector). 
How can I have uncorrectable errors since BTRFS is assuring data integrity ? How did my data got corrupted ? What can I do to ensure that it does not happen again ? 

Sincerely, 


You can find below all the useful information I can think of. If you need more, let me know. 

sudo btrfs scrub status /mnt 
scrub status for 89f6f57e-90d9-46ac-1132-144e6ac150e4 
scrub started at Sat Jan 14 17:09:36 2017 and finished after 2207 seconds 
total bytes scrubbed: 598.03GiB with 114 errors 
error details: csum=114 
corrected errors: 0, uncorrectable errors: 114, unverified errors: 0 


if I look, at the dmesg log , I can that both logical block seems to be corrupted. 
[ 1047.312852] BTRFS: bdev /dev/sde1 errs: wr 0, rd 0, flush 0, corrupt 49, gen 0 
[ 1047.352631] BTRFS: unable to fixup (regular) error at logical 429848649728 on dev /dev/sde1 
[ 1062.667080] BTRFS: checksum error at logical 441348554752 on dev /dev/sdd1, sector 195114560, root 5, inode 964364, offset 819200, length 4096, links 1 (path: seafile-data/storage/blocks/bd71e3e1-95bd-40fc-b6db-55c4ea9467c1/30/bfa04bb182ff8050fe4a0f357da7df335e7511) 
[ 1062.667092] BTRFS: bdev /dev/sdd1 errs: wr 0, rd 0, flush 0, corrupt 18, gen 0 
[ 1062.710999] BTRFS: unable to fixup (regular) error at logical 441348554752 on dev /dev/sdd1 
[ 1074.536137] BTRFS: checksum error at logical 441348554752 on dev /dev/sde1, sector 195075648, root 5, inode 964364, offset 819200, length 4096, links 1 (path: seafile-data/storage/blocks/bd71e3e1-95bd-40fc-b6db-55c4ea9467c1/30/bfa04bb182ff8050fe4a0f357da7df335e7511) 


sudo btrfs inspect-internal logical-resolve 441348554752 -v /mnt 
ioctl ret=0, total_size=4096, bytes_left=4056, bytes_missing=0, cnt=3, missed=0 
ioctl ret=0, bytes_left=3965, bytes_missing=0, cnt=1, missed=0 
/vault/seafile-data/storage/blocks/bd71e3e1-95bd-40fc-b6db-55c4ea9467c1/30/bfa04bb182ff8050fe4a0f357da7df335e7511 


If I attempt to read the corresponding file, I have an " Input/output error ". 


Here is my Raid1 configuration: 

sudo btrfs fi show /mnt 
Label: none uuid: 91f6f57e-23d7-46ac-8056-144e6ac150e4 
Total devices 2 FS bytes used 299.02GiB 
devid 1 size 2.73TiB used 301.03GiB path /dev/sdd1 
devid 2 size 2.73TiB used 301.01GiB path /dev/sde1 

btrfs-progs v3.19.1 

sudo btrfs fi df /mnt 
Data, RAID1: total=299.00GiB, used=298.15GiB 
Data, single: total=8.00MiB, used=0.00B 
System, RAID1: total=8.00MiB, used=64.00KiB 
System, single: total=4.00MiB, used=0.00B 
Metadata, RAID1: total=2.00GiB, used=887.55MiB 
Metadata, single: total=8.00MiB, used=0.00B 
GlobalReserve, single: total=304.00MiB, used=0.00B 


sudo btrfs fi us /mnt 
Overall: 
Device size: 5.46TiB 
Device allocated: 602.04GiB 
Device unallocated: 4.87TiB 
Device missing: 0.00B 
Used: 598.04GiB 
Free (estimated): 2.44TiB (min: 2.44TiB) 
Data ratio: 2.00 
Metadata ratio: 2.00 
Global reserve: 304.00MiB (used: 0.00B) 


Data,single: Size:8.00MiB, Used:0.00B 
/dev/sdd1 8.00MiB 


Data,RAID1: Size:299.00GiB, Used:298.15GiB 
/dev/sdd1 299.00GiB 
/dev/sde1 299.00GiB 


Metadata,single: Size:8.00MiB, Used:0.00B 
/dev/sdd1 8.00MiB 


Metadata,RAID1: Size:2.00GiB, Used:887.55MiB 
/dev/sdd1 2.00GiB 
/dev/sde1 2.00GiB 


System,single: Size:4.00MiB, Used:0.00B 
/dev/sdd1 4.00MiB 


System,RAID1: Size:8.00MiB, Used:64.00KiB 
/dev/sdd1 8.00MiB 
/dev/sde1 8.00MiB 


Unallocated: 
/dev/sdd1 2.43TiB 
/dev/sde1 2.43TiB 


btrfs --version 
btrfs-progs v3.19.1 


sudo smartctl -a /dev/sde 
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.10.0-327.28.3.el7.x86_64] (local build) 
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org 
=== START OF INFORMATION SECTION === 
Model Family: Western Digital Red (AF) 
Device Model: WDC WD30EFRX-68EUZN0 
Serial Number: WD-WCC4N1003742 
LU WWN Device Id: 5 0014ee 25f64a417 
Firmware Version: 80.00A80 
User Capacity: 3 000 592 982 016 bytes [3,00 TB] 
Sector Sizes: 512 bytes logical, 4096 bytes physical 
Rotation Rate: 5400 rpm 
Device is: In smartctl database [for details use: -P show] 
ATA Version is: ACS-2 (minor revision not indicated) 
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s) 
Local Time is: Sun Jan 15 16:46:37 2017 CET 
SMART support is: Available - device has SMART capability. 
SMART support is: Enabled 
=== START OF READ SMART DATA SECTION === 
SMART overall-health self-assessment test result: PASSED 


General SMART Values: 
Offline data collection status: (0x00) Offline data collection activity 
was never started. 
Auto Offline Data Collection: Disabled. 
Self-test execution status: ( 0) The previous self-test routine completed 
without error or no self-test has ever 
been run. 
Total time to complete Offline 
data collection: (40080) seconds. 
Offline data collection 
capabilities: (0x7b) SMART execute Offline immediate. 
Auto Offline data collection on/off support. 
Suspend Offline collection upon new 
command. 
Offline surface scan supported. 
Self-test supported. 
Conveyance Self-test supported. 
Selective Self-test supported. 
SMART capabilities: (0x0003) Saves SMART data before entering 
power-saving mode. 
Supports SMART auto save timer. 
Error logging capability: (0x01) Error logging supported. 
General Purpose Logging supported. 
Short self-test routine 
recommended polling time: ( 2) minutes. 
Extended self-test routine 
recommended polling time: ( 402) minutes. 
Conveyance self-test routine 
recommended polling time: ( 5) minutes. 
SCT capabilities: (0x703d) SCT Status supported. 
SCT Error Recovery Control supported. 
SCT Feature Control supported. 
SCT Data Table supported. 


SMART Attributes Data Structure revision number: 16 
Vendor Specific SMART Attributes with Thresholds: 
ID# ATTRIBUTE_NAME FLAG VALUE WORST THRESH TYPE UPDATED WHEN_FAILED RAW_VALUE 
1 Raw_Read_Error_Rate 0x002f 200 200 051 Pre-fail Always - 0 
3 Spin_Up_Time 0x0027 198 176 021 Pre-fail Always - 5100 
4 Start_Stop_Count 0x0032 100 100 000 Old_age Always - 134 
5 Reallocated_Sector_Ct 0x0033 200 200 140 Pre-fail Always - 0 
7 Seek_Error_Rate 0x002e 100 253 000 Old_age Always - 0 
9 Power_On_Hours 0x0032 085 085 000 Old_age Always - 11308 
10 Spin_Retry_Count 0x0032 100 100 000 Old_age Always - 0 
11 Calibration_Retry_Count 0x0032 100 100 000 Old_age Always - 0 
12 Power_Cycle_Count 0x0032 100 100 000 Old_age Always - 134 
192 Power-Off_Retract_Count 0x0032 200 200 000 Old_age Always - 126 
193 Load_Cycle_Count 0x0032 200 200 000 Old_age Always - 432 
194 Temperature_Celsius 0x0022 122 106 000 Old_age Always - 28 
196 Reallocated_Event_Count 0x0032 200 200 000 Old_age Always - 0 
197 Current_Pending_Sector 0x0032 200 200 000 Old_age Always - 0 
198 Offline_Uncorrectable 0x0030 100 253 000 Old_age Offline - 0 
199 UDMA_CRC_Error_Count 0x0032 200 200 000 Old_age Always - 0 
200 Multi_Zone_Error_Rate 0x0008 100 253 000 Old_age Offline - 0 


SMART Error Log Version: 1 
No Errors Logged 


SMART Self-test log structure revision number 1 
Num Test_Description Status Remaining LifeTime(hours) LBA_of_first_error 
# 1 Conveyance offline Completed without error 00% 9489 - 
# 2 Short offline Completed without error 00% 9479 - 


SMART Selective self-test log data structure revision number 1 
SPAN MIN_LBA MAX_LBA CURRENT_TEST_STATUS 
1 0 0 Not_testing 
2 0 0 Not_testing 
3 0 0 Not_testing 
4 0 0 Not_testing 
5 0 0 Not_testing 
Selective self-test flags (0x0): 
After scanning selected spans, do NOT read-scan remainder of disk. 
If Selective self-test is pending on power-up, resume after 0 minute delay. 
