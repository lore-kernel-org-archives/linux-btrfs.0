Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.univ-lille1.fr ([193.49.225.19]:47255 "EHLO
	smtp01.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbDYR5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 13:57:10 -0400
Message-ID: <553BD565.1080007@gnieh.org>
Date: Sat, 25 Apr 2015 19:56:53 +0200
From: Martin Monperrus <martin.monperrus@gnieh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: How to repair a BTRFS block?
References: <55320BAE.1030007@gnieh.org> <5539345C.1040905@gnieh.org> <553A810F.6010907@gnieh.org>
In-Reply-To: <553A810F.6010907@gnieh.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

>> Beyond this corrupted file, is my disk dead?
>> Can I repair the file system or re-create a new one on the same disk?
> A direct answer is beyond my knowledge level, certainly without SMART
> status information, etc.
I attach the result of `smartctl -x` below.

Best regards,

--Martin

smartctl -x /dev/sda
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.16.0-4-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG MZ7PD256HCGM-000H7
Serial Number:    S1N8NSAGC23049
LU WWN Device Id: 5 012548 500000000
Firmware Version: DXM06H6Q
User Capacity:    256,060,514,304 bytes [256 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Apr 25 19:45:38 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x02) Offline data collection activity
          was completed without error.
          Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine
completed
          without error or no self-test has ever
          been run.
Total time to complete Offline
data collection:    (    0) seconds.
Offline data collection
capabilities:        (0x53) SMART execute Offline immediate.
          Auto Offline data collection on/off support.
          Suspend Offline collection upon new
          command.
          No Offline surface scan supported.
          Self-test supported.
          No Conveyance Self-test supported.
          Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
          power-saving mode.
          Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
          General Purpose Logging supported.
Short self-test routine
recommended polling time:    (   2) minutes.
Extended self-test routine
recommended polling time:    (  17) minutes.
SCT capabilities:          (0x003d) SCT Status supported.
          SCT Error Recovery Control supported.
          SCT Feature Control supported.
          SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   199   199   002    -    790
  5 Reallocated_Sector_Ct   PO--CK   099   099   010    -    48
  9 Power_On_Hours          -O--CK   099   099   000    -    203
12 Power_Cycle_Count       -O--CK   099   099   000    -    460
170 Unknown_Attribute       PO--C-   099   099   010    -    4550
171 Unknown_Attribute       -O--CK   100   100   010    -    0
172 Unknown_Attribute       -O--CK   100   100   010    -    0
173 Unknown_Attribute       PO--C-   098   098   005    -    54
174 Unknown_Attribute       -O--CK   099   099   000    -    59
183 Runtime_Bad_Block       -O--CK   099   099   001    -    82
184 End-to-End_Error        PO--CK   100   100   097    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    790
188 Command_Timeout         -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   079   053   000    -    21
196 Reallocated_Event_Count -O----   099   099   000    -    48
198 Offline_Uncorrectable   ----CK   099   099   000    -    3
199 UDMA_CRC_Error_Count    -OSRCK   099   099   000    -    3
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
0x01       GPL,SL  R/O      1  Summary SMART error log
0x02       GPL,SL  R/O      1  Comprehensive SMART error log
0x03       GPL,SL  R/O      1  Ext. Comprehensive SMART error log
0x06       GPL,SL  R/O      1  SMART self-test log
0x07       GPL,SL  R/O      1  Extended self-test log
0x09       GPL,SL  R/W      1  Selective self-test log
0x10       GPL,SL  R/O      1  SATA NCQ Queued Error log
0x11       GPL,SL  R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
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
  255        0    65535  Read_scanning was completed without error
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        SCT command executing in background (5)
Current Temperature:                    40 Celsius
Power Cycle Min/Max Temperature:     40/40 Celsius
Lifetime    Min/Max Temperature:      0/70 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     3 (Unknown, should be 2)
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/70 Celsius
Min/Max Temperature Limit:            0/70 Celsius
Temperature History Size (Index):    128 (0)

Index    Estimated Time   Temperature Celsius
  1    2015-04-25 17:38     ?  -
...    ..(125 skipped).    ..  -
127    2015-04-25 19:44     ?  -
  0    2015-04-25 19:45    40  *********************

SCT Error Recovery Control:
          Read: Disabled
          Write: Disabled

Device Statistics (GP/SMART Log 0x04) not supported

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
0x0009  2            2  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2            0  R_ERR response for host-to-device non-data FIS,
non-CRC



On 04/24/2015 07:44 PM, Martin Monperrus wrote:
> Hi Duncan,
>
>> The kernel log (dmesg, also logged to syslog/journald on most systems)
>> from during the scrub should capture more information on those errors. 
> Thanks. The dmesg log indeed contains the file path (see below).
>
> The error is in /home/martin/XXXXX. It is related to a low-level error
> ("failed command: READ DMA").
>
> Beyond this corrupted file, is my disk dead?
> Can I repair the file system or re-create a new one on the same disk?
>
> Best,
>
> --Martin
>
> [ 7695.806090] BTRFS: i/o error at logical 167135232000 on dev
> /dev/sda2, sector 213189792, root 5, inode 2963892, offset 7700480,
> length 4096, links 1 (path: /home/martin/XXXXX)
> [ 7695.806097] BTRFS: bdev /dev/sda2 errs: wr 0, rd 401, flush 0,
> corrupt 0, gen 0
> [ 7695.812770] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [ 7695.812774] ata1.00: irq_stat 0x40000001
> [ 7695.812778] ata1.00: failed command: READ DMA
> [ 7695.812783] ata1.00: cmd c8/00:08:a0:dc:91/00:00:00:00:00/ee tag 23
> dma 4096 in
>          res 51/40:00:00:00:00/00:00:00:00:00/ee Emask 0x9 (media error)
> [ 7695.812785] ata1.00: status: { DRDY ERR }
> [ 7695.812786] ata1.00: error: { UNC }
> [ 7695.813013] ata1.00: supports DRM functions and may not be fully
> accessible
> [ 7695.813210] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
> [ 7695.813770] ata1.00: supports DRM functions and may not be fully
> accessible
> [ 7695.813859] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
> [ 7695.814164] ata1.00: configured for UDMA/133
> [ 7695.814179] sd 0:0:0:0: [sda] Unhandled sense code
> [ 7695.814181] sd 0:0:0:0: [sda] 
> [ 7695.814182] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [ 7695.814183] sd 0:0:0:0: [sda] 
> [ 7695.814185] Sense Key : Medium Error [current] [descriptor]
> [ 7695.814187] Descriptor sense data with sense descriptors (in hex):
> [ 7695.814188]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [ 7695.814195]         0e 00 00 00
> [ 7695.814198] sd 0:0:0:0: [sda] 
> [ 7695.814199] Add. Sense: Unrecovered read error - auto reallocate failed
> [ 7695.814201] sd 0:0:0:0: [sda] CDB:
> [ 7695.814202] Read(10): 28 00 0e 91 dc a0 00 00 08 00
> [ 7695.814208] end_request: I/O error, dev sda, sector 244440224
> [ 7695.814222] ata1: EH complete
> [ 7695.814227] BTRFS: unable to fixup (regular) error at logical
> 167135232000 on dev /dev/sda2
>
>
>
> On 04/23/2015 08:05 PM, Martin Monperrus wrote:
>> Hi,
>>
>> More on my issue, I have "uncorrectable errors"
>>
>> # btrfs scrub status /
>> scrub status for e11013b3-b244-4d1a-a9c7-3956db1a699c
>>     scrub started at Thu Apr 23 19:07:45 2015 and finished after 372 seconds
>>     total bytes scrubbed: 167.13GiB with 13 errors
>>     error details: read=13
>>     corrected errors: 0, uncorrectable errors: 13, unverified errors: 0
>>
>> Before going to my backups, how can know the files impacted by those
>> uncorrectable errors?
>>
>> Best regards,
>>
>> --Martin
>>
>>
>>
>> On 04/18/2015 09:45 AM, Martin Monperrus wrote:
>>> Dear Btrfs developers,
>>>
>>> For some unknown reasons, my BTRFS filesystem is corrupted. dmesg prints
>>>
>>> |BTRFS critical (device sda2): corrupt leaf, slot offset bad:
>>> block=43231330304,root=1, slot=47|
>>>
>>> (more than 1000x in the dmesg trace).
>>>
>>> btrfs check --repair fails with:
>>>
>>> read block failed check_tree_block
>>> incorrect offset 12725 2298746482
>>> items overlap, can't fix
>>> cmds_check.c:2918: fix_item_offset: Assertion 'ret' failed
>>>
>>> How to list the files in block #43231330304 affected by the corruption?
>>> How to repair block #43231330304?
>>>
>>> Best regards,
>>>
>>> --Martin
>>>

