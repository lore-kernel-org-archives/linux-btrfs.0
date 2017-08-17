Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36856 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753195AbdHQUR7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 16:17:59 -0400
Received: by mail-qk0-f173.google.com with SMTP id o124so34568203qke.3
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 13:17:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQjh07f6EYGVUPpWL7aXChVSXdok1DOg-+ZwOSqNMq_7Q@mail.gmail.com>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <CAJCQCtQPMNnC4wHfubV1aHstdUnZXQoRMuss85=_ZAv51qFpSw@mail.gmail.com>
 <pan$b0a14$8f1e0555$f8f395d6$3ede559@cox.net> <CAJCQCtQjh07f6EYGVUPpWL7aXChVSXdok1DOg-+ZwOSqNMq_7Q@mail.gmail.com>
From: Paulo Dias <paulo.miguel.dias@gmail.com>
Date: Thu, 17 Aug 2017 17:17:37 -0300
Message-ID: <CADJPUQ_va-S7BjG6f0a+Wu8fx6jnWjG8kMDVWQ=bj8W443MQmg@mail.gmail.com>
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Chris Murphy <lists@colorremedies.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI/2 all, once again thanky you for taking time to look at this.

So i disabled discard in the mount options yesterday, recreated the
Fedora.qcow file outside of the /home subvolume, and copied it back to
/home.

It "appeared" ok for a while, but today i run scrub on /home again,
and sure enough:

ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 64, gen 0
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 422343614464 on dev /dev/sda3
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 65, gen 0
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 422343618560 on dev /dev/sda3
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 66, gen 0
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 422343630848 on dev /dev/sda3
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 67, gen 0
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 422343634944 on dev /dev/sda3
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 68, gen 0
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 422343639040 on dev /dev/sda3
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 69, gen 0
ago 17 17:05:54 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 422343643136 on dev /dev/sda3
ago 17 17:06:30 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 70, gen 0
ago 17 17:06:30 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 441140600832 on dev /dev/sda3
ago 17 17:06:30 kerberos kernel: BTRFS error (device sda3): bdev
/dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 71, gen 0
ago 17 17:06:30 kerberos kernel: BTRFS error (device sda3): unable to
fixup (regular) error at logical 441140629504 on dev /dev/sda3

root@kerberos:/home/groo# btrfs scrub start -B /home/
scrub done for ae9ae869-720d-4643-b673-6924d09b2fe0
       scrub started at Thu Aug 17 17:05:10 2017 and finished after 00:01:20
       total bytes scrubbed: 37.71GiB with 8 errors
       error details: csum=8
       corrected errors: 0, uncorrectable errors: 8, unverified errors: 0
ERROR: there are uncorrectable errors

this is what smartctl -x /ev/sda shows me:

root@kerberos:/home/groo# smartctl -x /dev/sda
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.12.5-041205-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     Samsung SSD 850 EVO M.2 500GB
Serial Number:    S33DNX0H812686V
LU WWN Device Id: 5 002538 d4130d027
Firmware Version: EMT21B6Q
User Capacity:    500.107.862.016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      M.2
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 17 17:15:44 2017 -03
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                       was never started.
                                       Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                       without error or no self-test has ever
                                       been run.
Total time to complete Offline
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x53) SMART execute Offline immediate.
                                       Auto Offline data collection
on/off support.
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
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 265) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                       SCT Error Recovery Control supported.
                                       SCT Feature Control supported.
                                       SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
 5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
 9 Power_On_Hours          -O--CK   099   099   000    -    1753
12 Power_Cycle_Count       -O--CK   099   099   000    -    395
177 Wear_Leveling_Count     PO--C-   099   099   000    -    7
179 Used_Rsvd_Blk_Cnt_Tot   PO--C-   100   100   010    -    0
181 Program_Fail_Cnt_Total  -O--CK   100   100   010    -    0
182 Erase_Fail_Count_Total  -O--CK   100   100   010    -    0
183 Runtime_Bad_Block       PO--C-   100   100   010    -    0
187 Uncorrectable_Error_Cnt -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O--CK   068   050   000    -    32
195 ECC_Error_Rate          -O-RC-   200   200   000    -    0
199 CRC_Error_Count         -OSRCK   100   100   000    -    0
235 POR_Recovery_Count      -O--C-   099   099   000    -    55
241 Total_LBAs_Written      -O--CK   099   099   000    -    8386128219
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
0x02           SL  R/O      1  Comprehensive SMART error log
0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x13       GPL     R/O      1  SATA NCQ Send and Receive log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1           SL  VS      16  Device vendor specific log
0xa5           SL  VS      16  Device vendor specific log
0xce           SL  VS      16  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      1504         -
# 2  Short offline       Aborted by host               90%       857         -
# 3  Offline             Completed without error       00%       857         -
# 4  Short offline       Completed without error       00%       504         -
# 5  Short offline       Aborted by host               70%         8         -

SMART Selective self-test log data structure revision number 1
SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
   1        0        0  Not_testing
   2        0        0  Not_testing
   3        0        0  Not_testing
   4        0        0  Not_testing
   5        0        0  Not_testing
 255        0    65535  Read_scanning was never started
Selective self-test flags (0x0):
 After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    43 Celsius
Power Cycle Min/Max Temperature:     30/43 Celsius
Lifetime    Min/Max Temperature:     22/50 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        10 minutes
Min/Max recommended Temperature:      0/70 Celsius
Min/Max Temperature Limit:            0/70 Celsius
Temperature History Size (Index):    128 (15)

Index    Estimated Time   Temperature Celsius
 16    2017-08-16 20:00     ?  -
 17    2017-08-16 20:10    33  **************
 18    2017-08-16 20:20    32  *************
 19    2017-08-16 20:30    36  *****************
 20    2017-08-16 20:40    33  **************
 21    2017-08-16 20:50    33  **************
 22    2017-08-16 21:00    34  ***************
 23    2017-08-16 21:10    35  ****************
 24    2017-08-16 21:20    34  ***************
 25    2017-08-16 21:30    34  ***************
 26    2017-08-16 21:40    35  ****************
 27    2017-08-16 21:50    34  ***************
 28    2017-08-16 22:00    34  ***************
 29    2017-08-16 22:10    33  **************
 30    2017-08-16 22:20    33  **************
 31    2017-08-16 22:30    34  ***************
 32    2017-08-16 22:40    35  ****************
 33    2017-08-16 22:50    32  *************
...    ..(  2 skipped).    ..  *************
 36    2017-08-16 23:20    32  *************
 37    2017-08-16 23:30    31  ************
...    ..(  4 skipped).    ..  ************
 42    2017-08-17 00:20    31  ************
 43    2017-08-17 00:30    32  *************
 44    2017-08-17 00:40    32  *************
 45    2017-08-17 00:50    33  **************
 46    2017-08-17 01:00    32  *************
 47    2017-08-17 01:10    32  *************
 48    2017-08-17 01:20    33  **************
 49    2017-08-17 01:30     ?  -
 50    2017-08-17 01:40    32  *************
 51    2017-08-17 01:50    47  ****************************
 52    2017-08-17 02:00    48  *****************************
 53    2017-08-17 02:10    34  ***************
 54    2017-08-17 02:20    32  *************
 55    2017-08-17 02:30    32  *************
 56    2017-08-17 02:40    43  ************************
 57    2017-08-17 02:50    43  ************************
 58    2017-08-17 03:00    33  **************
 59    2017-08-17 03:10    30  ***********
 60    2017-08-17 03:20    36  *****************
 61    2017-08-17 03:30    43  ************************
 62    2017-08-17 03:40    42  ***********************
 63    2017-08-17 03:50    32  *************
 64    2017-08-17 04:00    31  ************
 65    2017-08-17 04:10    36  *****************
 66    2017-08-17 04:20    31  ************
...    ..(  2 skipped).    ..  ************
 69    2017-08-17 04:50    31  ************
 70    2017-08-17 05:00    30  ***********
...    ..( 43 skipped).    ..  ***********
114    2017-08-17 12:20    30  ***********
115    2017-08-17 12:30    31  ************
116    2017-08-17 12:40    31  ************
117    2017-08-17 12:50    31  ************
118    2017-08-17 13:00     ?  -
119    2017-08-17 13:10    35  ****************
120    2017-08-17 13:20    36  *****************
121    2017-08-17 13:30    34  ***************
122    2017-08-17 13:40    32  *************
123    2017-08-17 13:50    36  *****************
124    2017-08-17 14:00     ?  -
125    2017-08-17 14:10    32  *************
126    2017-08-17 14:20    33  **************
127    2017-08-17 14:30    31  ************
  0    2017-08-17 14:40     ?  -
  1    2017-08-17 14:50    31  ************
  2    2017-08-17 15:00    40  *********************
  3    2017-08-17 15:10    33  **************
  4    2017-08-17 15:20    32  *************
  5    2017-08-17 15:30    31  ************
  6    2017-08-17 15:40    31  ************
  7    2017-08-17 15:50    30  ***********
  8    2017-08-17 16:00    30  ***********
  9    2017-08-17 16:10    33  **************
 10    2017-08-17 16:20    31  ************
...    ..(  3 skipped).    ..  ************
 14    2017-08-17 17:00    31  ************
 15    2017-08-17 17:10    43  ************************

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
0x0009  2           17  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           17  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2            0  R_ERR response for host-to-device non-data FIS, non-CRC

is there a way to check if the above logical sectors are the ones
pointing to any of my sparse files? i have 2, fedora.qcow2 and
minishift.img.

thanks for everything so far

| Paulo Dias
| paulo.miguel.dias@gmail.com

Tempora mutantur, nos et mutamur in illis.


On Thu, Aug 17, 2017 at 4:10 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Aug 17, 2017 at 2:04 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>
>> The point being, as I said, unless Samsung's changed policy recently,
>> there's no point in filing Linux related bug reports with them.  All
>> you're likely to get is them putting their fingers in their ears while
>> singing loudly about not supporting Linux.
>
> OK good to know.
>
>
>> Unfortunately, I found all this out /after/ having bought a pair of 1 TB
>> Samsung evo 850s myself (after seeing them recommended here...), while
>> googling, as suggested above, samsung ssd queued trim (tho I actually put
>> in evo 850 since that's what I had), in ordered to see if I could safely
>> mount with discard and not have it hurt performance due to lack of queued-
>> trim support.  Obviously not, so I'm running without discard, and letting
>> the systemd fstrim timer do its thing every week, instead.
>
> I have one of these:
>
> SAMSUNG MZVLV256HCHP-000H1
>
> It came in the HP Spectre laptop I'm using, and I've intentionally
> been using discard mount option to see if things go bad eventually.
> It's been 10 months. Zero problems.
>
>
>
>> But I'd have been rather unlikely to buy samsung if I knew they /refused/
>> to support Linux users because "anyone" can modify the code, that's for
>> sure!
>
> That's silly. Someone's just a bad manager (or a series of them).
> Samsung is a multi-tentacled beast. They clearly have another tentacle
> that supports Linux.
> https://en.wikipedia.org/wiki/F2FS
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
