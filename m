Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:34107 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbeIFXNb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 19:13:31 -0400
Received: by mail-wr1-f46.google.com with SMTP id g33-v6so12474067wrd.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 11:36:45 -0700 (PDT)
Subject: Re: btrfs send hung in pipe_wait
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
 <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com>
 <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
From: Stefan Loewen <stefan.loewen@gmail.com>
Message-ID: <d0223039-5c8f-38db-fe32-0b46b220e699@gmail.com>
Date: Thu, 6 Sep 2018 20:36:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------57B9F54D54943639C0192DFD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------57B9F54D54943639C0192DFD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Output of the commands is attached.

The broken-sector-theory sounds plausible and is compatible with my new 
findings:
I suspected the problem to be in one specific directory, let's call it 
"broken_dir".
I created a new subvolume and copied broken_dir over.
- If I copied it with cp --reflink, made a snapshot and tried to 
btrfs-send that, it hung
- If I rsynced broken_dir over I could snapshot and btrfs-send without a 
problem.

But shouldn't btrfs scrub or check find such errors?


On 9/6/18 8:16 PM, Chris Murphy wrote:
> OK you've got a different problem.
>
> [  186.898756] sd 2:0:0:0: [sdb] tag#0 FAILED Result:
> hostbyte=DID_ERROR driverbyte=DRIVER_OK
> [  186.898762] sd 2:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 15 26 a0 d0
> 00 08 00 00
> [  186.898764] print_req_error: I/O error, dev sdb, sector 354853072
> [  187.109641] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
> using xhci_hcd
> [  187.345245] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
> using xhci_hcd
> [  187.657844] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
> using xhci_hcd
> [  187.851336] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
> using xhci_hcd
> [  188.026882] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
> using xhci_hcd
> [  188.215881] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
> using xhci_hcd
> [  188.247028] sd 2:0:0:0: [sdb] tag#0 FAILED Result:
> hostbyte=DID_ERROR driverbyte=DRIVER_OK
> [  188.247041] sd 2:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 15 26 a8 d0
> 00 08 00 00
> [  188.247048] print_req_error: I/O error, dev sdb, sector 354855120
>
>
> This is a read error for a specific sector.  So your drive has media
> problems. And I think that's the instigating problem here, from which
> a bunch of other tasks that depend on one or more reads completing but
> never do. But weirdly there also isn't any kind of libata reset. At
> least on SATA, by default we see a link reset after a command has not
> returned in 30 seconds. That reset would totally clear the drive's
> command queue, and then things either can recover or barf. But in your
> case, neither happens and it just sits there with hung tasks.
>
> [  189.350360] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 0,
> rd 2, flush 0, corrupt 0, gen 0
>
> And that's the last we really see from Btrfs. After that, it's all
> just hung task traces and are rather unsurprising to me.
>
> Drives in USB cases add a whole bunch of complicating factors for
> troubleshooting and repair. Including often masking the actual logical
> and physical sector size, the min and max IO size, alignment offset,
> and all kinds of things. They can have all sorts of bugs. And I'm also
> not totally certain about the relationship between the usb reset
> messages and the bad sector. As far as I know the only way we can get
> a sector LBA expressly noted in dmesg along with the failed read(10)
> command, is if the drive has reported back to libata that discrete
> error with sense information. So I'm accepting that as a reliable
> error, rather than it being something like a cable. But the reset
> messages could possibly be something else in addition to that.
>
> Anyway, the central issue is sector 354855120 is having problems. I
> can't tell from the trace if it's transient or persistent. Maybe if
> it's transient, that would explain how you sometimes get send to start
> working again briefly but then it reverts to hanging. What do you get
> for:
>
> fdisk -l /dev/sdb
> smartctl -x /dev/sdb
> smartctl -l sct erc /dev/sdb
>
> Those are all read only commands, nothing is written or changed.
>
>
>

--------------57B9F54D54943639C0192DFD
Content-Type: text/x-log;
 name="output.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="output.log"

[root@archlinux ~]# fdisk -l /dev/sdb
Disk /dev/sdb: 931.5 GiB, 1000204140544 bytes, 1953523712 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x1cc21bd2
Device     Boot      Start        End    Sectors  Size Id Type
/dev/sdb1             2048 1933593750 1933591703  922G 83 Linux
/dev/sdb2       1933610176 1953525167   19914992  9.5G 83 Linux


[root@archlinux ~]# smartctl -x /dev/sdb
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.5-arch1-1-ARCH] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
=== START OF INFORMATION SECTION ===
Model Family:     Seagate Samsung SpinPoint M8 (AF)
Device Model:     ST1000LM024 HN-M101MBB
Serial Number:    S2RXJ9FCB07612
LU WWN Device Id: 5 0004cf 208d24759
Firmware Version: 2AR10002
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      2.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 3.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Sep  6 18:23:57 2018 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM level is:     254 (maximum performance), recommended: 254
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Unknown
=== START OF READ SMART DATA SECTION ===
SMART Status not supported: Incomplete response, ATA output registers missing
SMART overall-health self-assessment test result: PASSED
Warning: This result is based on an Attribute check.
General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
was completed without error.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever 
been run.
Total time to complete Offline 
data collection:                (13560) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
Offline surface scan supported.
Self-test supported.
No Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 226) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    10
2 Throughput_Performance  -OS--K   252   252   000    -    0
3 Spin_Up_Time            PO---K   086   086   025    -    4463
4 Start_Stop_Count        -O--CK   098   098   000    -    2675
5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
8 Seek_Time_Performance   --S--K   252   252   015    -    0
9 Power_On_Hours          -O--CK   100   100   000    -    339
10 Spin_Retry_Count        -O--CK   252   252   051    -    0
11 Calibration_Retry_Count -O--CK   100   100   000    -    8
12 Power_Cycle_Count       -O--CK   100   100   000    -    462
191 G-Sense_Error_Rate      -O---K   100   100   000    -    13
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   053   000    -    30 (Min/Max 17/51)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    31
223 Load_Retry_Count        -O--CK   100   100   000    -    8
225 Load_Cycle_Count        -O--CK   100   100   000    -    8580
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
0x02           SL  R/O      2  Comprehensive SMART error log
0x03       GPL     R/O      2  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      2  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xc0-0xdf  GPL,SL  VS      16  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer
SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
No Errors Logged
SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       264         -
# 2  Short offline       Completed without error       00%       264         -
# 3  Extended offline    Aborted by host               90%       165         -
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
1        0        0  Completed [00% left] (0-65535)
2        0        0  Not_testing
3        0        0  Not_testing
4        0        0  Not_testing
5        0        0  Not_testing
Selective self-test flags (0x0):
After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
SCT Status Version:                  2
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    30 Celsius
Power Cycle Min/Max Temperature:     25/31 Celsius
Lifetime    Min/Max Temperature:     18/52 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (100)
Index    Estimated Time   Temperature Celsius
101    2018-09-06 07:45    30  ***********
102    2018-09-06 07:50    28  *********
...    ..(  2 skipped).    ..  *********
105    2018-09-06 08:05    28  *********
106    2018-09-06 08:10    31  ************
107    2018-09-06 08:15    33  **************
108    2018-09-06 08:20    34  ***************
109    2018-09-06 08:25    35  ****************
110    2018-09-06 08:30    35  ****************
111    2018-09-06 08:35    35  ****************
112    2018-09-06 08:40    36  *****************
...    ..(  7 skipped).    ..  *****************
120    2018-09-06 09:20    36  *****************
121    2018-09-06 09:25    33  **************
122    2018-09-06 09:30    33  **************
123    2018-09-06 09:35    34  ***************
124    2018-09-06 09:40    35  ****************
125    2018-09-06 09:45    31  ************
126    2018-09-06 09:50    32  *************
127    2018-09-06 09:55    34  ***************
0    2018-09-06 10:00    33  **************
1    2018-09-06 10:05    30  ***********
2    2018-09-06 10:10    33  **************
3    2018-09-06 10:15    30  ***********
4    2018-09-06 10:20    29  **********
5    2018-09-06 10:25    29  **********
6    2018-09-06 10:30    29  **********
7    2018-09-06 10:35    30  ***********
8    2018-09-06 10:40    31  ************
9    2018-09-06 10:45    31  ************
10    2018-09-06 10:50    32  *************
11    2018-09-06 10:55    32  *************
12    2018-09-06 11:00    31  ************
13    2018-09-06 11:05    30  ***********
14    2018-09-06 11:10    29  **********
...    ..(  7 skipped).    ..  **********
22    2018-09-06 11:50    29  **********
23    2018-09-06 11:55    31  ************
24    2018-09-06 12:00    34  ***************
25    2018-09-06 12:05    35  ****************
26    2018-09-06 12:10    37  ******************
27    2018-09-06 12:15    38  *******************
28    2018-09-06 12:20    38  *******************
29    2018-09-06 12:25    39  ********************
...    ..(  4 skipped).    ..  ********************
34    2018-09-06 12:50    39  ********************
35    2018-09-06 12:55    40  *********************
36    2018-09-06 13:00    40  *********************
37    2018-09-06 13:05    40  *********************
38    2018-09-06 13:10    39  ********************
39    2018-09-06 13:15    39  ********************
40    2018-09-06 13:20    39  ********************
41    2018-09-06 13:25    40  *********************
42    2018-09-06 13:30    39  ********************
...    ..(  5 skipped).    ..  ********************
48    2018-09-06 14:00    39  ********************
49    2018-09-06 14:05    37  ******************
50    2018-09-06 14:10    35  ****************
51    2018-09-06 14:15    34  ***************
52    2018-09-06 14:20    31  ************
53    2018-09-06 14:25    28  *********
54    2018-09-06 14:30    31  ************
55    2018-09-06 14:35    34  ***************
56    2018-09-06 14:40    36  *****************
57    2018-09-06 14:45    37  ******************
58    2018-09-06 14:50    38  *******************
59    2018-09-06 14:55    38  *******************
60    2018-09-06 15:00    39  ********************
...    ..(  3 skipped).    ..  ********************
64    2018-09-06 15:20    39  ********************
65    2018-09-06 15:25    40  *********************
66    2018-09-06 15:30    39  ********************
...    ..(  7 skipped).    ..  ********************
74    2018-09-06 16:10    39  ********************
75    2018-09-06 16:15    25  ******
76    2018-09-06 16:20    26  *******
77    2018-09-06 16:25    27  ********
78    2018-09-06 16:30    29  **********
...    ..(  2 skipped).    ..  **********
81    2018-09-06 16:45    29  **********
82    2018-09-06 16:50    27  ********
83    2018-09-06 16:55    27  ********
84    2018-09-06 17:00    26  *******
85    2018-09-06 17:05    27  ********
86    2018-09-06 17:10    27  ********
87    2018-09-06 17:15    26  *******
88    2018-09-06 17:20    26  *******
89    2018-09-06 17:25    26  *******
90    2018-09-06 17:30    28  *********
91    2018-09-06 17:35    27  ********
92    2018-09-06 17:40    27  ********
93    2018-09-06 17:45    29  **********
94    2018-09-06 17:50    30  ***********
95    2018-09-06 17:55    30  ***********
96    2018-09-06 18:00    30  ***********
97    2018-09-06 18:05    31  ************
98    2018-09-06 18:10    31  ************
99    2018-09-06 18:15    31  ************
100    2018-09-06 18:20    30  ***********
SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed
Device Statistics (GP/SMART Log 0x04) not supported
Pending Defects log (GP Log 0x0c) not supported
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  4            0  Command failed due to ICRC error
0x0002  4            0  R_ERR response for data FIS
0x0003  4            0  R_ERR response for device-to-host data FIS
0x0004  4            0  R_ERR response for host-to-device data FIS
0x0005  4            0  R_ERR response for non-data FIS
0x0006  4            0  R_ERR response for device-to-host non-data FIS
0x0007  4            0  R_ERR response for host-to-device non-data FIS
0x0008  4            0  Device-to-host non-data FIS retries
0x0009  4           13  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4           12  Device-to-host register FISes sent due to a COMRESET
0x000b  4            0  CRC errors within host-to-device FIS
0x000d  4            0  Non-CRC errors within host-to-device FIS
0x000f  4            0  R_ERR response for host-to-device data FIS, CRC
0x0010  4            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  4            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  4            0  R_ERR response for host-to-device non-data FIS, non-CRC
0x8e00  4            0  Vendor specific
0x8e01  4            0  Vendor specific
0x8e02  4            0  Vendor specific
0x8e03  4            0  Vendor specific
0x8e04  4            0  Vendor specific
0x8e05  4            0  Vendor specific
0x8e06  4            0  Vendor specific
0x8e07  4            0  Vendor specific
0x8e08  4            0  Vendor specific
0x8e09  4            0  Vendor specific
0x8e0a  4            0  Vendor specific
0x8e0b  4            0  Vendor specific
0x8e0c  4            0  Vendor specific
0x8e0d  4            0  Vendor specific
0x8e0e  4            0  Vendor specific
0x8e0f  4            0  Vendor specific
0x8e10  4            0  Vendor specific
0x8e11  4            0  Vendor specific


[root@archlinux ~]# smartctl -l scterc /dev/sdb
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.18.5-arch1-1-ARCH] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
SMART WRITE LOG does not return COUNT and LBA_LOW register
SCT (Get) Error Recovery Control command failed

--------------57B9F54D54943639C0192DFD--
