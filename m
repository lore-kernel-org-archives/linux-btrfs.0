Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35395 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbGIWDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 18:03:35 -0400
Received: by oihr66 with SMTP id r66so143188421oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 15:03:34 -0700 (PDT)
MIME-Version: 1.0
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Thu, 9 Jul 2015 17:03:15 -0500
Message-ID: <CAC=t97ASkaa3icJT7kLzDJ7fqMxQjharOLx4R9LmhNLRX6VAsQ@mail.gmail.com>
Subject: Odd scrub behavior - Raid5/6
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Something I've noticed scrubbing two pools that I have, one is Raid6
and the other is Raid5.

The scrubbing goes along very slowly and I think it's because there is
always one disk that's operating differently than the rest.  Which
disk changes.

Here is an iostat of the current scrub, and you can see that /dev/sdj
is the odd ball.   Below the iostat output is the smart statistics for
sdj and they indicate a healthy drive.  And to be sure I recently ran
extended tests twice without incident.

Below that is another iostat output, where literally as I'm typing
this email the behavior changed to a different drive in the pool,
/dev/sdo and the smart data follows, also showing a healthy drive (and
a load cycle count that would make a seagate blush).

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.34    0.00    5.88   93.20    0.00    0.59

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdp               0.00     2.00    0.00    5.00     0.00     0.08
31.47     0.05    9.07    0.00    9.07   8.93   4.47
sda               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdr              31.33     0.00   41.67    1.00     4.56     0.02
220.12     0.39    9.05    9.26    0.67   3.50  14.93
sdi              26.33     0.00   65.67    2.00     5.73     0.10
176.47     0.75   11.04   11.36    0.67   3.73  25.23
sdf               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdn              30.33     0.00   58.33    1.33     5.50     0.06
190.97     0.54    8.99    9.19    0.50   3.90  23.27
sdo              33.00     0.00   64.67    1.00     6.10     0.04
191.72     0.73   11.06   11.22    0.67   3.88  25.47
sds              30.33     0.00   59.00    1.67     5.56     0.05
189.45     0.53    8.66    8.90    0.40   3.66  22.23
sdc               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdk              28.67     0.00   62.33    1.67     5.65     0.08
183.29     2.73   42.72   43.86    0.40   8.20  52.47
sdl               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdu              35.00     0.00   62.00    0.33     6.04     0.00
198.59     0.74   11.88   11.95    0.00   4.41  27.50
sdt              26.33     0.00   61.33    1.00     5.58     0.02
184.00     0.65   12.05   12.24    0.33   3.76  23.43
sdj              34.67     0.00   31.67    0.67     3.79     0.04
242.80   129.66 3822.54 3876.24 1271.50  30.93 100.00
sdq              33.33     0.00   43.33    0.67     4.79     0.03
224.42     0.56   12.68   12.88    0.00   6.02  26.47
sdm               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdh              34.33     0.00   46.00    1.67     5.02     0.10
220.20     0.53   11.17   11.57    0.40   4.45  21.20
sdg              30.00     0.00   48.67    1.67     4.90     0.05
201.11     0.45    8.99    9.29    0.00   3.52  17.70


[root@san01 ~]# smartctl -a /dev/sdj
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.1.0-1.el7.elrepo.x86_64]
(local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD15EARX-00PASB0
Serial Number:    WD-WCAZAK449717
LU WWN Device Id: 5 0014ee 2b27dbe1a
Firmware Version: 51.0AB51
User Capacity:    1,500,301,910,016 bytes [1.50 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Jul  9 16:58:52 2015 CDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                (38280) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 369) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3035) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   173   171   021    Pre-fail
Always       -       6325
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       51
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   086   086   000    Old_age
Always       -       10301
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       51
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       50
193 Load_Cycle_Count        0x0032   195   195   000    Old_age
Always       -       15611
194 Temperature_Celsius     0x0022   118   109   000    Old_age
Always       -       32
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
# 1  Extended offline    Completed without error       00%     10060         -
# 2  Extended offline    Completed without error       00%     10050         -
# 3  Short offline       Completed without error       00%     10040         -

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




avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.25    0.00    6.47   93.28    0.00    0.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdp               0.00     0.67    0.00    7.00     0.00     0.08
24.38     0.05    7.10    0.00    7.10   6.57   4.60
sda               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdr              30.33     0.00   61.33    0.00     5.73     0.00
191.30     0.52    8.42    8.42    0.00   3.24  19.87
sdi              28.33     0.00   66.33    0.00     5.92     0.00
182.67     0.89   13.44   13.44    0.00   3.47  23.03
sdf               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdn              30.00     0.00   56.00    0.00     5.38     0.00
196.57     0.42    7.62    7.62    0.00   3.40  19.03
sdo              37.33     0.00   35.00    0.00     5.19     0.00
303.54   128.61 2571.61 2571.61    0.00  28.57 100.00
sds              23.33     0.00   57.67    0.00     5.06     0.00
179.79     0.39    6.96    6.96    0.00   3.09  17.80
sdc               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdk              34.00     0.00   72.67    0.00     6.75     0.00
190.24     1.84   50.25   50.25    0.00   4.47  32.47
sdl               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdu              27.00     0.00   66.33    0.00     5.85     0.00
180.70     0.75   11.35   11.35    0.00   4.38  29.03
sdt              27.00     0.00   65.67    0.00     5.79     0.00
180.63     0.56    8.61    8.61    0.00   3.48  22.83
sdj              42.00     0.00   63.33    0.00     7.28     0.00
235.28    16.48  340.41  340.41    0.00  13.04  82.57
sdq              32.67     0.00   62.00    0.00     6.42     0.00
211.96     3.37  124.92  124.92    0.00   6.67  41.37
sdm               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdh              36.67     0.00   49.67    0.00     5.42     0.00
223.36     0.49   10.10   10.10    0.00   4.23  21.03
sdg              32.00     0.00   69.00    0.00     6.48     0.00
192.31     0.76   11.14   11.14    0.00   3.96  27.33


[root@san01 ~]# smartctl -a /dev/sdo
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.1.0-1.el7.elrepo.x86_64]
(local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (AF)
Device Model:     WDC WD15EARS-00MVWB0
Serial Number:    WD-WMAZA3274320
LU WWN Device Id: 5 0014ee 6ab6d3bc1
Firmware Version: 51.0AB51
User Capacity:    1,500,301,910,016 bytes [1.50 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Thu Jul  9 17:01:50 2015 CDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                (27360) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 266) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3035) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   253   253   021    Pre-fail
Always       -       1125
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       121
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   074   074   000    Old_age
Always       -       19430
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       120
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       119
193 Load_Cycle_Count        0x0032   001   001   000    Old_age
Always       -       947508
194 Temperature_Celsius     0x0022   117   102   000    Old_age
Always       -       33
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
# 1  Extended offline    Completed without error       00%     19188         -
# 2  Short offline       Completed without error       00%     19170         -

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
