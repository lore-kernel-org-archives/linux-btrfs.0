Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35421 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbDAPsL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 11:48:11 -0400
Received: by wgdm6 with SMTP id m6so58028408wgd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 08:48:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Wed, 1 Apr 2015 11:47:49 -0400
Message-ID: <CACPiFCL031Yxjw5PXXbX0fKASZ9+S6cSOH3cHL9hG1LCJO=w0Q@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 4:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>A failure of the
>> HDD cannot be ruled out, low power conditions, cheap consumer part...
>
> Well you have to rule that out before anyone on this list can really
> help. Try booting Fedora 21 install media, and using smartctl -x on
> the drive.

smartctl thinks the drive is ok. Unfortunately, it doesn't have a
truth serum to distinguish whether this drive lies about writes or
not...

[root@localhost liveuser]# smartctl -x /dev/sda
smartctl 6.2 2014-07-16 r3952 [x86_64-linux-3.17.4-301.fc21.x86_64]
(local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Laptop SSHD
Device Model:     ST500LM000-1EJ162
Serial Number:    W3709VQD
LU WWN Device Id: 5 000c50 069f901e9
Firmware Version: SM14
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Apr  1 11:44:43 2015 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM level is:     128 (minimum power consumption without standby)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Write SCT (Get) XXX Error Recovery Control Command failed: scsi error
aborted command
Wt Cache Reorder: N/A

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  139) seconds.
Offline data collection
capabilities:              (0x73) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    No Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      (  98) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x1081)    SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   112   099   006    -    46707576
  3 Spin_Up_Time            PO----   099   099   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    147
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   078   060   030    -    65832005
  9 Power_On_Hours          -O--CK   092   092   000    -    7775
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    159
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    1
189 High_Fly_Writes         -O-RCK   095   095   000    -    5
190 Airflow_Temperature_Cel -O---K   070   058   045    -    30 (Min/Max 27/31)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    25
193 Load_Cycle_Count        -O--CK   066   066   000    -    68484
194 Temperature_Celsius     -O---K   030   042   000    -    30 (0 16 0 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
254 Free_Fall_Sensor        -O--CK   100   100   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x24       GPL     R/O   1223  Current Device Internal Status Data log
0x25       GPL     R/O   1223  Saved Device Internal Status Data log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    3900  Device vendor specific log
0xa8       GPL,SL  VS     129  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xab       GPL     VS       1  Device vendor specific log
0xae       GPL     VS       1  Device vendor specific log
0xb0       GPL     VS    4580  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xc1       GPL,SL  VS      10  Device vendor specific log
0xc2       GPL,SL  VS      50  Device vendor specific log
0xc4       GPL,SL  VS       5  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
No Errors Logged

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

SCT Data Table command not supported

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS



-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
