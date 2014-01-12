Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:54216 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaALWb7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 17:31:59 -0500
Message-ID: <52D317CF.2070007@friedels.name>
Date: Sun, 12 Jan 2014 23:31:43 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com> <52C87B67.1040503@friedels.name> <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com> <52CC65C9.3090605@friedels.name> <52D08812.3040707@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
In-Reply-To: <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> Kernel version?
3.12.0-031200-generic


> It mounts OK with no kernel messages?

Yes. Here I mount the three subvolumes:
dmesg:
[105152.392900] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 1 
                         transid 164942 /dev/sdb1
[105152.394332] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105152.394663] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 1 
                         transid 164942 /dev/sdb1
[105152.394759] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105152.394845] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105152.395941] btrfs: disk space caching is enabled
[105195.320249] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 1 
                         transid 164942 /dev/sdb1
[105195.320256] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105195.320263] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 1 
                         transid 164942 /dev/sdb1
[105195.320290] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105195.320308] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105208.832997] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 1 
                         transid 164942 /dev/sdb1
[105208.833005] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105208.833026] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 1 
                         transid 164942 /dev/sdb1
[105208.833030] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1
[105208.833032] btrfs: device fsid 989306aa-d291-4752-8477-0baf94f8c42f 
devid 2 
                         transid 164942 /dev/sdc1

Syslog:
Jan 12 23:25:43 homeserver kernel: [105152.392900] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 1 transid 164942 /dev/sdb1
Jan 12 23:25:43 homeserver kernel: [105152.394332] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:25:43 homeserver kernel: [105152.394663] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 1 transid 164942 /dev/sdb1
Jan 12 23:25:43 homeserver kernel: [105152.394759] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:25:43 homeserver kernel: [105152.394845] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:25:43 homeserver kernel: [105152.395941] btrfs: disk space 
caching is enabled
Jan 12 23:26:26 homeserver kernel: [105195.320249] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 1 transid 164942 /dev/sdb1
Jan 12 23:26:26 homeserver kernel: [105195.320256] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:26:26 homeserver kernel: [105195.320263] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 1 transid 164942 /dev/sdb1
Jan 12 23:26:26 homeserver kernel: [105195.320290] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:26:26 homeserver kernel: [105195.320308] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:26:39 homeserver kernel: [105208.832997] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 1 transid 164942 /dev/sdb1
Jan 12 23:26:39 homeserver kernel: [105208.833005] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:26:39 homeserver kernel: [105208.833026] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 1 transid 164942 /dev/sdb1
Jan 12 23:26:39 homeserver kernel: [105208.833030] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1
Jan 12 23:26:39 homeserver kernel: [105208.833032] btrfs: device fsid 
989306aa-d291-4752-8477-0baf94f8c42f devid 2 transid 164942 /dev/sdc1


> What do you get for:
> btrfs fi show
./btrfs/btrfs-progs/btrfs fi show
Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
         Total devices 2 FS bytes used 4.37TiB
         devid    1 size 2.73TiB used 2.73TiB path /dev/sdb1
         devid    2 size 2.73TiB used 2.73TiB path /dev/sdc1

Btrfs v3.12

> btrfs fi df <mp>
./btrfs/btrfs-progs/btrfs fi df /mnt/BTRFS/rsnapshot/
Data, RAID0: total=5.45TiB, used=4.37TiB
System, RAID1: total=8.00MiB, used=396.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=6.00GiB, used=5.41GiB
Metadata, single: total=8.00MiB, used=0.00
(for all Subvolumes)

> btrfs device stats </dev or mountpoint>
./btrfs/btrfs-progs/btrfs device stats /mnt/BTRFS/backups/
[/dev/sdb1].write_io_errs   0
[/dev/sdb1].read_io_errs    0
[/dev/sdb1].flush_io_errs   0
[/dev/sdb1].corruption_errs 0
[/dev/sdb1].generation_errs 0
[/dev/sdc1].write_io_errs   0
[/dev/sdc1].read_io_errs    0
[/dev/sdc1].flush_io_errs   0
[/dev/sdc1].corruption_errs 0
[/dev/sdc1].generation_errs 0


Greetings and thanks for your help!

Hendrik


Appendix:

> If there are any errors reported for device stats, what do you get for smartctl -x /dev/X
There are none, but for completeness:

smartctl -x /dev/sdc1
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.12.0-031200-generic] 
(local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-9YN166
Serial Number:    Z1F0HAZN
LU WWN Device Id: 5 000c50 03fec37b4
Firmware Version: CC4B
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Jan 12 23:30:28 2014 CET

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
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test 
has ever
                                         been run.
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
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR--   119   099   006    -    222649736
   3 Spin_Up_Time            PO----   092   092   000    -    0
   4 Start_Stop_Count        -O--CK   095   095   020    -    5128
   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
   7 Seek_Error_Rate         POSR--   076   057   030    -    13026610297
   9 Power_On_Hours          -O--CK   068   068   000    -    28432
  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
  12 Power_Cycle_Count       -O--CK   100   100   020    -    167
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   099   000    -    2 2 2
189 High_Fly_Writes         -O-RCK   092   092   000    -    8
190 Airflow_Temperature_Cel -O---K   060   046   045    -    40 (0 10 47 26)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    148
193 Load_Cycle_Count        -O--CK   095   095   000    -    11707
194 Temperature_Celsius     -O---K   040   054   000    -    40 (0 15 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    - 
10383h+50m+39.165s
241 Total_LBAs_Written      ------   100   253   000    -    80975340592299
242 Total_LBAs_Read         ------   100   253   000    -    194401514224638
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
GP    Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART 
error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP    Log at address 0x21 has    1 sectors [Write stream error log]
GP    Log at address 0x22 has    1 sectors [Read stream error log]
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
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 4496 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has   20 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xab has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 5067 sectors [Device vendor specific log]
GP    Log at address 0xbd has  512 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     28411 
      -
# 2  Extended offline    Completed without error       00%     28394 
      -
# 3  Short offline       Completed without error       00%     28387 
      -
# 4  Short offline       Completed without error       00%     28363 
      -
# 5  Short offline       Completed without error       00%     28339 
      -
# 6  Short offline       Completed without error       00%     28316 
      -
# 7  Short offline       Completed without error       00%     28292 
      -
# 8  Short offline       Completed without error       00%     28268 
      -
# 9  Short offline       Completed without error       00%     28243 
      -
#10  Extended offline    Completed without error       00%     28226 
      -
#11  Short offline       Completed without error       00%     28220 
      -
#12  Short offline       Completed without error       00%     28196 
      -
#13  Short offline       Completed without error       00%     28172 
      -
#14  Short offline       Completed without error       00%     28148 
      -
#15  Short offline       Completed without error       00%     28124 
      -
#16  Short offline       Completed without error       00%     28100 
      -
#17  Short offline       Completed without error       00%     28076 
      -
#18  Extended offline    Completed without error       00%     28058 
      -
#19  Short offline       Completed without error       00%     28052 
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

Warning: device does not support SCT Data Table command
Warning: device does not support SCT Error Recovery Control command
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            3  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS


