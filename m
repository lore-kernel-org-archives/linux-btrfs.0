Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:33794 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbcAYVvs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 16:51:48 -0500
Received: from moh3-ve1.go2.pl (moh3-ve1.go2.pl [193.17.41.30])
	by tur.go2.pl (Postfix) with ESMTP id 877FD10203AE
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 22:29:31 +0100 (CET)
Received: from moh3-ve1.go2.pl (unknown [10.0.0.117])
	by moh3-ve1.go2.pl (Postfix) with ESMTP id DD539516005
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 22:29:29 +0100 (CET)
Received: from unknown (unknown [10.0.0.74])
	by moh3-ve1.go2.pl (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 22:29:29 +0100 (CET)
Date: Mon, 25 Jan 2016 22:29:29 +0100
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: suspected BTRFS errors resulting in file system becoming
 unrecovable
Message-ID: <20160125212929.GD6110@pontus.sran>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And an answer with smartctl output.


----- Forwarded message from WillIam Thorne <will.thorne@me.com> -----
Date: Mon, 25 Jan 2016 16:52:44 +0000
From: WillIam Thorne <will.thorne@me.com>
To: Piotr Szymaniak <szarpaj@grubelek.pl>
Subject: Re: suspected BTRFS errors resulting in file system becoming unrecovable
X-Mailer: Apple Mail (2.3112)

Hi Piotr,

Thanks for your help, here’s the output from smartctl. By the way, should I cc answers to linux-btrfs@vger.kernel.org?

pi@mail /var/log $ sudo smartctl -d sat /dev/sda -x
smartctl 5.41 2011-06-09 r3365 [armv7l-linux-4.1.7-v7+] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD20EZRX-00D8PB0
Serial Number:    WD-WMC4N0J17JYP
LU WWN Device Id: 5 0014ee 605b50871
Firmware Version: 80.00A80
User Capacity:    2,000,365,380,096 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   9
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Jan 25 16:51:57 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		(32340) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x7035)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   195   195   051    -    78
  3 Spin_Up_Time            POS--K   199   172   021    -    5050
  4 Start_Stop_Count        -O--CK   100   100   000    -    382
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    269
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    316
192 Power-Off_Retract_Count -O--CK   200   200   000    -    241
193 Load_Cycle_Count        -O--CK   199   199   000    -    4765
194 Temperature_Celsius     -O---K   113   108   000    -    37
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    6 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xa0 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa1 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa2 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa3 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa4 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa5 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa6 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa7 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaa has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xab has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xac has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xad has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xae has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaf has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb1 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb2 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb3 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb4 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb5 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb6 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb7 has   39 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP    Log at address 0xc1 has   93 sectors [Device vendor specific log]
GP    Log at address 0xcf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 64 (device log contains only the most recent 24 errors)
	CR     = Command Register
	FEATR  = Features Register
	COUNT  = Count (was: Sector Count) Register
	LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
	LH     = LBA High (was: Cylinder High) Register    ]   LBA
	LM     = LBA Mid (was: Cylinder Low) Register      ] Register
	LL     = LBA Low (was: Sector Number) Register     ]
	DV     = Device (was: Device/Head) Register
	DC     = Device Control Register
	ER     = Error register
	ST     = Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 64 [15] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:50.583  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:47.209  READ DMA EXT
  25 00 d0 00 08 00 00 20 00 08 00 40 00     00:30:47.207  READ DMA EXT
  25 00 d0 00 08 00 00 00 02 08 00 40 00     00:30:47.207  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:43.833  READ DMA EXT

Error 63 [14] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:47.209  READ DMA EXT
  25 00 d0 00 08 00 00 20 00 08 00 40 00     00:30:47.207  READ DMA EXT
  25 00 d0 00 08 00 00 00 02 08 00 40 00     00:30:47.207  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:43.833  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:39.856  READ DMA EXT

Error 62 [13] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:43.833  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:39.856  READ DMA EXT
  25 00 d0 00 08 00 00 20 00 00 00 40 00     00:30:36.678  READ DMA EXT
  25 00 d0 00 08 00 00 00 02 00 00 40 00     00:30:36.678  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 00 80 40 00     00:30:36.677  READ DMA EXT

Error 61 [12] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:30:39.856  READ DMA EXT
  25 00 d0 00 08 00 00 20 00 00 00 40 00     00:30:36.678  READ DMA EXT
  25 00 d0 00 08 00 00 00 02 00 00 40 00     00:30:36.678  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 00 80 40 00     00:30:36.677  READ DMA EXT
  25 00 d0 00 08 00 00 20 00 00 00 40 00     00:30:36.675  READ DMA EXT

Error 60 [11] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:27.477  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:24.070  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:20.695  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 20 40 00     00:22:20.695  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:17.324  READ DMA EXT

Error 59 [10] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:24.070  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:20.695  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 20 40 00     00:22:20.695  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:17.324  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 0b f8 40 00     00:22:17.324  READ DMA EXT

Error 58 [9] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:20.695  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 20 40 00     00:22:20.695  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:17.324  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 0b f8 40 00     00:22:17.324  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 0b f0 40 00     00:22:17.323  READ DMA EXT

Error 57 [8] occurred at disk power-on lifetime: 262 hours (10 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 00 00 08 80 40 00  Error: UNC 8 sectors at LBA = 0x00000880 = 2176

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 d0 00 08 00 00 00 00 08 80 40 00     00:22:17.324  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 0b f8 40 00     00:22:17.324  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 0b f0 40 00     00:22:17.323  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 0b e8 40 00     00:22:17.323  READ DMA EXT
  25 00 d0 00 08 00 00 00 00 0b e0 40 00     00:22:17.322  READ DMA EXT

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

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

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    37 Celsius
Power Cycle Min/Max Temperature:     29/37 Celsius
Lifetime    Min/Max Temperature:      2/42 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (458)

Index    Estimated Time   Temperature Celsius
 459    2016-01-25 08:54    35  ****************
 460    2016-01-25 08:55    36  *****************
 ...    ..( 11 skipped).    ..  *****************
 472    2016-01-25 09:07    36  *****************
 473    2016-01-25 09:08     ?  -
 474    2016-01-25 09:09    19  -
 475    2016-01-25 09:10     ?  -
 476    2016-01-25 09:11    22  ***
 477    2016-01-25 09:12     ?  -
   0    2016-01-25 09:13    35  ****************
 ...    ..(  9 skipped).    ..  ****************
  10    2016-01-25 09:23    35  ****************
  11    2016-01-25 09:24     ?  -
  12    2016-01-25 09:25    37  ******************
 ...    ..(  4 skipped).    ..  ******************
  17    2016-01-25 09:30    37  ******************
  18    2016-01-25 09:31     ?  -
  19    2016-01-25 09:32    25  ******
  20    2016-01-25 09:33    25  ******
  21    2016-01-25 09:34    26  *******
  22    2016-01-25 09:35    26  *******
  23    2016-01-25 09:36    27  ********
  24    2016-01-25 09:37    27  ********
  25    2016-01-25 09:38     ?  -
  26    2016-01-25 09:39    28  *********
 ...    ..(  2 skipped).    ..  *********
  29    2016-01-25 09:42    28  *********
  30    2016-01-25 09:43    29  **********
  31    2016-01-25 09:44    29  **********
  32    2016-01-25 09:45    30  ***********
  33    2016-01-25 09:46    30  ***********
  34    2016-01-25 09:47    30  ***********
  35    2016-01-25 09:48     ?  -
  36    2016-01-25 09:49    31  ************
 ...    ..(  2 skipped).    ..  ************
  39    2016-01-25 09:52    31  ************
  40    2016-01-25 09:53    32  *************
  41    2016-01-25 09:54    31  ************
  42    2016-01-25 09:55    32  *************
 ...    ..( 11 skipped).    ..  *************
  54    2016-01-25 10:07    32  *************
  55    2016-01-25 10:08    33  **************
  56    2016-01-25 10:09    33  **************
  57    2016-01-25 10:10    33  **************
  58    2016-01-25 10:11    34  ***************
  59    2016-01-25 10:12    33  **************
 ...    ..(  3 skipped).    ..  **************
  63    2016-01-25 10:16    33  **************
  64    2016-01-25 10:17    34  ***************
 ...    ..(  3 skipped).    ..  ***************
  68    2016-01-25 10:21    34  ***************
  69    2016-01-25 10:22    35  ****************
  70    2016-01-25 10:23    35  ****************
  71    2016-01-25 10:24     ?  -
  72    2016-01-25 10:25    41  **********************
  73    2016-01-25 10:26     ?  -
  74    2016-01-25 10:27    33  **************
 ...    ..( 28 skipped).    ..  **************
 103    2016-01-25 10:56    33  **************
 104    2016-01-25 10:57    34  ***************
 105    2016-01-25 10:58     ?  -
 106    2016-01-25 10:59    29  **********
 ...    ..(  6 skipped).    ..  **********
 113    2016-01-25 11:06    29  **********
 114    2016-01-25 11:07    30  ***********
 115    2016-01-25 11:08    30  ***********
 116    2016-01-25 11:09    30  ***********
 117    2016-01-25 11:10    31  ************
 ...    ..( 11 skipped).    ..  ************
 129    2016-01-25 11:22    31  ************
 130    2016-01-25 11:23    32  *************
 ...    ..(  9 skipped).    ..  *************
 140    2016-01-25 11:33    32  *************
 141    2016-01-25 11:34    33  **************
 ...    ..(  6 skipped).    ..  **************
 148    2016-01-25 11:41    33  **************
 149    2016-01-25 11:42    34  ***************
 ...    ..(  6 skipped).    ..  ***************
 156    2016-01-25 11:49    34  ***************
 157    2016-01-25 11:50    35  ****************
 ...    ..(  9 skipped).    ..  ****************
 167    2016-01-25 12:00    35  ****************
 168    2016-01-25 12:01    36  *****************
 ...    ..( 18 skipped).    ..  *****************
 187    2016-01-25 12:20    36  *****************
 188    2016-01-25 12:21    37  ******************
 ...    ..(269 skipped).    ..  ******************
 458    2016-01-25 16:51    37  ******************

Warning: device does not support SCT Error Recovery Control command
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            0  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4        21174  Vendor specific

> On 25 Jan 2016, at 16:48, Piotr Szymaniak <szarpaj@grubelek.pl> wrote:
> 
> On Mon, Jan 25, 2016 at 02:58:31PM +0000, WillIam Thorne wrote:
>> Jan 20 09:43:18 mail kernel: [2762823.972851] blk_update_request: I/O error, dev sda, sector 16198688
>> Jan 20 09:43:18 mail kernel: [2762823.977052] blk_update_request: I/O error, dev sda, sector 16198928
>> Jan 20 09:43:18 mail kernel: [2762823.978318] blk_update_request: I/O error, dev sda, sector 16199168
>> Jan 20 09:43:18 mail kernel: [2762823.983304] blk_update_request: I/O error, dev sda, sector 16172024
>> Jan 20 09:43:18 mail kernel: [2762823.987855] blk_update_request: I/O error, dev sda, sector 16172264
>> Jan 20 09:43:18 mail kernel: [2762823.989193] blk_update_request: I/O error, dev sda, sector 16172504
> 
> Hi,
> 
> This looks like bad sectors, not btrfs fault (on the other hand, few bad
> sectors should not make fs unrecoverable).
> 
> Can you paste smartctl -x /dev/[yourdevice] output?
> 
> 
> Best regards,
> Piotr Szymaniak.
----- End forwarded message -----
