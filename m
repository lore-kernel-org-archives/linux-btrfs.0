Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37816 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbcF0XDo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 19:03:44 -0400
Received: by mail-wm0-f41.google.com with SMTP id a66so3006518wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 16:03:43 -0700 (PDT)
Received: from system (dslb-094-217-100-036.094.217.pools.vodafone-ip.de. [94.217.100.36])
        by smtp.gmail.com with ESMTPSA id kc8sm2871856wjb.0.2016.06.27.16.03.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2016 16:03:40 -0700 (PDT)
Date: Tue, 28 Jun 2016 01:03:39 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160628010339.7fcddf5e@system>
In-Reply-To: <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
	<20160628002602.022258bf@system>
	<CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Jun 2016 16:55:07 -0600, Chris Murphy
<lists@colorremedies.com> wrote :

> On Mon, Jun 27, 2016 at 4:26 PM, Saint Germain <saintger@gmail.com>
> wrote:
> 
> >>
> >
> > Thanks for your help.
> >
> > Ok here is the log from the mounting, and including btrfs replace
> > (btrfs replace start -f /dev/sda1 /dev/sdd1 /home):
> >
> > BTRFS info (device sdb1): disk space caching is enabled
> > BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12,
> > flush 7928, corrupt 1705631, gen 1335 BTRFS info (device sdb1):
> > bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14220, gen 24
> 
> Eek. So sdb has 11+ million write errors, flush errors, read errors,
> and over 1 million corruptions. It's dying or dead.
> 
> And sda has a dozen thousand+ corruptions. This isn't a good
> combination, as you have two devices with problems and raid5 only
> protects you from one device with problems.
> 
> You were in the process of replacing sda, which is good, but it may
> not be enough...
> 
> 
> > BTRFS info (device sdb1): dev_replace from /dev/sda1 (devid 1)
> > to /dev/sdd1 started scrub_handle_errored_block: 166 callbacks
> > suppressed BTRFS warning (device sdb1): checksum error at logical
> > 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode
> > 3434831, offset 479232, length 4096, links 1 (path:
> > user/.local/share/zeitgeist/activity.sqlite-wal)
> > btrfs_dev_stat_print_on_error: 166 callbacks suppressed BTRFS error
> > (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt
> > 14221, gen 24 scrub_handle_errored_block: 166 callbacks suppressed
> > BTRFS error (device sdb1): unable to fixup (regular) error at
> > logical 93445255168 on dev /dev/sda1
> 
> Shoot. You have a lot of these. It looks suspiciously like you're
> hitting a case list regulars are only just starting to understand
> (somewhat) where it's possible to have a legit corrupt sector that
> Btrfs detects during scrub as wrong, fixes it from parity, but then
> occasionally wrongly overwrites the parity with bad parity. This
> doesn't cause an immediately recognizable problem. But if the volume
> becomes degraded later, Btrfs must use parity to reconstruct
> on-the-fly and if it hits one of these bad parities, the
> reconstruction is bad, and ends up causing lots of these checksum
> errors. We can tell it's not metadata corruption because a.) there's a
> file listed as being affected and b.) the file system doesn't fail and
> go read only. But still it means those files are likely toast...
> 
> 
> [...snip many instances of checksum errors...]
> 
> > BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush
> > 0, corrupt 16217, gen 24 ata2.00: exception Emask 0x0 SAct 0x4000
> > SErr 0x0 action 0x0 ata2.00: irq_stat 0x40000008
> > ata2.00: failed command: READ FPDMA QUEUED
> > ata2.00: cmd 60/08:70:08:d8:70/00:00:0f:00:00/40 tag 14 ncq 4096 in
> >          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media
> > error) <F> ata2.00: status: { DRDY ERR }
> > ata2.00: error: { UNC }
> > ata2.00: configured for UDMA/133
> > sd 1:0:0:0: [sdb] tag#14 FAILED Result: hostbyte=DID_OK
> > driverbyte=DRIVER_SENSE sd 1:0:0:0: [sdb] tag#14 Sense Key : Medium
> > Error [current] [descriptor] sd 1:0:0:0: [sdb] tag#14 Add. Sense:
> > Unrecovered read error - auto reallocate failed sd 1:0:0:0: [sdb]
> > tag#14 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
> > blk_update_request: I/O error, dev sdb, sector 259053576
> 
> OK yeah so bad sector on sdb. So you have two failures because sda is
> already giving you trouble while being replaced and on top of it you
> now get a 2nd (partial) failure via bad sectors.
> 
> So rather urgently I think you need to copy things off this volume if
> you don't already have a backup so you can save as much as possible.
> Don't write to the drives. You might even consider 'mount -o
> remount,ro' to avoid anything writing to the volume. Copy the most
> important data first, triage time.
> 
> While that happens you can safely collect some more information:
> 
> btrfs fi us <mp>
> smartctl -x <dev>   ## for both drives
> 

Ok thanks I will begin to make an image with dd.
Do you recommend to use sda or sdb ?

In the meantime here are the info requested:

btrfs fi us /home
Overall:
    Device size:                   3.63TiB
    Device allocated:              2.76TiB
    Device unallocated:          888.51GiB
    Device missing:                  0.00B
    Used:                          2.62TiB
    Free (estimated):            517.56GiB      (min: 517.56GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:1.38TiB, Used:1.31TiB
   /dev/sda1       1.38TiB
   /dev/sdb1       1.38TiB

Metadata,RAID1: Size:5.00GiB, Used:3.15GiB
   /dev/sda1       5.00GiB
   /dev/sdb1       5.00GiB

System,RAID1: Size:64.00MiB, Used:216.00KiB
   /dev/sda1      64.00MiB
   /dev/sdb1      64.00MiB

Unallocated:
   /dev/sda1     444.26GiB
   /dev/sdb1     444.26GiB

root@system:/# smartctl -x /dev/sda
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     ST2000LM003 HN-M201RAD
Serial Number:    S377J9DGB01499
LU WWN Device Id: 5 0004cf 2111fa028
Firmware Version: 2BE10001
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Jun 28 00:59:36 2016 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM level is:     254 (maximum performance), recommended: 254
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      (  38)	The self-test routine was interrupted
					by the host with a hard or soft reset.
Total time to complete Offline 
data collection: 		(23100) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 385) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    0
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   091   090   025    -    2993
  4 Start_Stop_Count        -O--CK   100   100   000    -    661
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    1379
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    349
191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   060   047   000    -    40 (Min/Max 18/53)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    2
223 Load_Retry_Count        -O--CK   100   100   000    -    1
225 Load_Cycle_Count        -O--CK   099   099   000    -    10744
241 Total_LBAs_Written      -O--CK   095   094   000    -    7981553
242 Total_LBAs_Read         -O--CK   098   094   000    -    4015781
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
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xc0-0xdf  GPL,SL  VS      16  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Offline             Interrupted (host reset)      60%      1372         -
# 2  Short captive       Self-test routine in progress 60%      1372         -
# 3  Offline             Interrupted (host reset)      60%      1372         -
# 4  Short captive       Self-test routine in progress 60%      1372         -

SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Interrupted [60% left] (0-65535)
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
Current Temperature:                    40 Celsius
Power Cycle Min/Max Temperature:     23/45 Celsius
Lifetime    Min/Max Temperature:     18/53 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (60)

Index    Estimated Time   Temperature Celsius
  61    2016-06-27 14:20    40  *********************
  62    2016-06-27 14:25    37  ******************
  63    2016-06-27 14:30    37  ******************
  64    2016-06-27 14:35    37  ******************
  65    2016-06-27 14:40    38  *******************
  66    2016-06-27 14:45    38  *******************
  67    2016-06-27 14:50    39  ********************
  68    2016-06-27 14:55    40  *********************
  69    2016-06-27 15:00    40  *********************
  70    2016-06-27 15:05    41  **********************
  71    2016-06-27 15:10    41  **********************
  72    2016-06-27 15:15    26  *******
  73    2016-06-27 15:20    28  *********
  74    2016-06-27 15:25    30  ***********
  75    2016-06-27 15:30    32  *************
  76    2016-06-27 15:35    34  ***************
  77    2016-06-27 15:40    34  ***************
  78    2016-06-27 15:45    35  ****************
  79    2016-06-27 15:50    36  *****************
  80    2016-06-27 15:55    37  ******************
  81    2016-06-27 16:00    38  *******************
  82    2016-06-27 16:05    39  ********************
  83    2016-06-27 16:10    26  *******
  84    2016-06-27 16:15    29  **********
  85    2016-06-27 16:20    30  ***********
  86    2016-06-27 16:25    32  *************
  87    2016-06-27 16:30    35  ****************
  88    2016-06-27 16:35    37  ******************
  89    2016-06-27 16:40    39  ********************
  90    2016-06-27 16:45    41  **********************
  91    2016-06-27 16:50    43  ************************
  92    2016-06-27 16:55    45  **************************
  93    2016-06-27 17:00    46  ***************************
  94    2016-06-27 17:05    47  ****************************
  95    2016-06-27 17:10    47  ****************************
  96    2016-06-27 17:15    48  *****************************
  97    2016-06-27 17:20    48  *****************************
  98    2016-06-27 17:25    48  *****************************
  99    2016-06-27 17:30    49  ******************************
 ...    ..(  3 skipped).    ..  ******************************
 103    2016-06-27 17:50    49  ******************************
 104    2016-06-27 17:55    44  *************************
 105    2016-06-27 18:00    43  ************************
 106    2016-06-27 18:05    42  ***********************
 107    2016-06-27 18:10    44  *************************
 108    2016-06-27 18:15    45  **************************
 109    2016-06-27 18:20    45  **************************
 110    2016-06-27 18:25    44  *************************
 111    2016-06-27 18:30    41  **********************
 112    2016-06-27 18:35    40  *********************
 113    2016-06-27 18:40    39  ********************
 114    2016-06-27 18:45    39  ********************
 115    2016-06-27 18:50    38  *******************
 ...    ..(  2 skipped).    ..  *******************
 118    2016-06-27 19:05    38  *******************
 119    2016-06-27 19:10    41  **********************
 120    2016-06-27 19:15    43  ************************
 121    2016-06-27 19:20    43  ************************
 122    2016-06-27 19:25    40  *********************
 123    2016-06-27 19:30    39  ********************
 124    2016-06-27 19:35    39  ********************
 125    2016-06-27 19:40    39  ********************
 126    2016-06-27 19:45    40  *********************
 ...    ..(  5 skipped).    ..  *********************
   4    2016-06-27 20:15    40  *********************
   5    2016-06-27 20:20    39  ********************
 ...    ..(  3 skipped).    ..  ********************
   9    2016-06-27 20:40    39  ********************
  10    2016-06-27 20:45    38  *******************
  11    2016-06-27 20:50    38  *******************
  12    2016-06-27 20:55    41  **********************
  13    2016-06-27 21:00    44  *************************
  14    2016-06-27 21:05    44  *************************
  15    2016-06-27 21:10    41  **********************
  16    2016-06-27 21:15    40  *********************
  17    2016-06-27 21:20    40  *********************
  18    2016-06-27 21:25    43  ************************
  19    2016-06-27 21:30    43  ************************
  20    2016-06-27 21:35    27  ********
  21    2016-06-27 21:40    29  **********
  22    2016-06-27 21:45    30  ***********
  23    2016-06-27 21:50    34  ***************
  24    2016-06-27 21:55    35  ****************
  25    2016-06-27 22:00    36  *****************
  26    2016-06-27 22:05    36  *****************
  27    2016-06-27 22:10    37  ******************
 ...    ..(  3 skipped).    ..  ******************
  31    2016-06-27 22:30    37  ******************
  32    2016-06-27 22:35    38  *******************
  33    2016-06-27 22:40    38  *******************
  34    2016-06-27 22:45    41  **********************
  35    2016-06-27 22:50    43  ************************
  36    2016-06-27 22:55    41  **********************
  37    2016-06-27 23:00    39  ********************
  38    2016-06-27 23:05    39  ********************
  39    2016-06-27 23:10    39  ********************
  40    2016-06-27 23:15    40  *********************
  41    2016-06-27 23:20    43  ************************
  42    2016-06-27 23:25    44  *************************
  43    2016-06-27 23:30    45  **************************
  44    2016-06-27 23:35    42  ***********************
  45    2016-06-27 23:40    40  *********************
  46    2016-06-27 23:45    39  ********************
  47    2016-06-27 23:50    39  ********************
  48    2016-06-27 23:55    38  *******************
 ...    ..(  2 skipped).    ..  *******************
  51    2016-06-28 00:10    38  *******************
  52    2016-06-28 00:15    41  **********************
  53    2016-06-28 00:20    43  ************************
  54    2016-06-28 00:25    44  *************************
  55    2016-06-28 00:30    41  **********************
  56    2016-06-28 00:35    40  *********************
 ...    ..(  3 skipped).    ..  *********************
  60    2016-06-28 00:55    40  *********************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP/SMART Log 0x04) not supported

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
0x0009  4            5  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            5  Device-to-host register FISes sent due to a COMRESET
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

root@system:/# smartctl -x /dev/sdb
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     ST2000LM003 HN-M201RAD
Serial Number:    S377J9CGB01582
LU WWN Device Id: 5 0004cf 211210d5b
Firmware Version: 2BE10001
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Jun 28 00:59:37 2016 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM level is:     254 (maximum performance), recommended: 254
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      ( 121)	The previous self-test completed having
					the read element of the test failed.
Total time to complete Offline 
data collection: 		(21420) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 357) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    28
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   092   083   025    -    2678
  4 Start_Stop_Count        -O--CK   100   100   000    -    575
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    1391
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    371
191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   061   047   000    -    39 (Min/Max 19/53)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   100   100   000    -    1
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    3
223 Load_Retry_Count        -O--CK   100   100   000    -    1
225 Load_Cycle_Count        -O--CK   099   099   000    -    13957
241 Total_LBAs_Written      -O--CK   096   094   000    -    6153920
242 Total_LBAs_Read         -O--CK   097   094   000    -    4873960
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
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xc0-0xdf  GPL,SL  VS      16  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
Device Error Count: 28 (device log contains only the most recent 8 errors)
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

Error 28 [3] occurred at disk power-on lifetime: 1390 hours (57 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:21.275  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d8 08 40 08     00:00:21.279  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d8 00 40 08     00:00:21.279  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d7 f8 40 08     00:00:21.279  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d7 f0 40 08     00:00:21.279  READ FPDMA QUEUED

Error 27 [2] occurred at disk power-on lifetime: 1390 hours (57 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 05 80 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 06 60 00 00 0f 70 d7 28 40 08     00:00:21.275  READ FPDMA QUEUED
  60 00 00 06 60 00 00 0f 70 d7 28 40 08     00:00:21.276  READ FPDMA QUEUED
  60 00 00 07 00 00 00 0f 70 d0 28 40 08     00:00:21.276  READ FPDMA QUEUED
  60 00 00 0a 00 00 00 0f 70 c6 28 40 08     00:00:21.276  READ FPDMA QUEUED
  60 00 00 0a 00 00 00 0f 70 bc 28 40 08     00:00:21.276  READ FPDMA QUEUED

Error 26 [1] occurred at disk power-on lifetime: 1390 hours (57 days + 22 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:19.046  READ FPDMA QUEUED
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:19.051  READ FPDMA QUEUED
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     00:00:19.051  FLUSH CACHE EXT
  61 00 00 00 08 00 00 20 00 08 00 40 08     00:00:19.051  WRITE FPDMA QUEUED
  61 00 00 00 08 00 00 00 02 08 00 40 08     00:00:19.051  WRITE FPDMA QUEUED

Error 25 [0] occurred at disk power-on lifetime: 1388 hours (57 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:11.810  READ FPDMA QUEUED
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:11.816  READ FPDMA QUEUED
  60 00 00 00 08 00 00 07 9c d9 20 40 08     00:00:11.811  READ FPDMA QUEUED
  60 00 00 00 08 00 00 3e 60 1a 90 40 08     00:00:11.811  READ FPDMA QUEUED
  60 00 00 00 08 00 00 07 9c 68 f0 40 08     00:00:11.811  READ FPDMA QUEUED

Error 24 [7] occurred at disk power-on lifetime: 1387 hours (57 days + 19 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:09.010  READ FPDMA QUEUED
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:09.066  READ FPDMA QUEUED
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     00:00:09.051  FLUSH CACHE EXT
  61 00 00 00 08 00 00 20 00 08 00 40 08     00:00:09.051  WRITE FPDMA QUEUED
  61 00 00 00 08 00 00 00 02 08 00 40 08     00:00:09.051  WRITE FPDMA QUEUED

Error 23 [6] occurred at disk power-on lifetime: 1385 hours (57 days + 17 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:01.685  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d8 08 40 08     00:00:01.688  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d8 00 40 08     00:00:01.688  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d7 f8 40 08     00:00:01.688  READ FPDMA QUEUED
  60 00 10 00 08 00 00 0f 70 d7 f0 40 08     00:00:01.688  READ FPDMA QUEUED

Error 22 [5] occurred at disk power-on lifetime: 1385 hours (57 days + 17 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 05 80 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 06 60 00 00 0f 70 d7 28 40 08     00:00:01.685  READ FPDMA QUEUED
  60 00 00 06 60 00 00 0f 70 d7 28 40 08     00:00:01.685  READ FPDMA QUEUED
  60 00 00 08 00 00 00 0f 70 cf 28 40 08     00:00:01.685  READ FPDMA QUEUED
  60 00 00 05 00 00 00 0f 70 ca 28 40 08     00:00:01.685  READ FPDMA QUEUED
  60 00 00 07 00 00 00 0f 70 c3 28 40 08     00:00:01.685  READ FPDMA QUEUED

Error 21 [4] occurred at disk power-on lifetime: 1384 hours (57 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 0f 70 d8 08 40 08     00:00:23.754  READ FPDMA QUEUED
  60 00 00 00 08 00 00 0f 70 db 30 40 08     00:00:23.774  READ FPDMA QUEUED
  60 00 00 00 08 00 00 0f 70 d8 30 40 08     00:00:23.774  READ FPDMA QUEUED
  60 00 00 00 08 00 00 0f 70 d9 30 40 08     00:00:23.774  READ FPDMA QUEUED
  60 00 00 00 08 00 00 0f 70 da 30 40 08     00:00:23.774  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short captive       Completed: read failure       90%      1384         259053576
# 2  Short captive       Completed: read failure       90%      1384         259053576

SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Completed_read_failure [90% left] (0-65535)
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
Current Temperature:                    38 Celsius
Power Cycle Min/Max Temperature:     23/42 Celsius
Lifetime    Min/Max Temperature:     19/53 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (17)

Index    Estimated Time   Temperature Celsius
  18    2016-06-27 14:20    38  *******************
  19    2016-06-27 14:25    36  *****************
 ...    ..( 17 skipped).    ..  *****************
  37    2016-06-27 15:55    36  *****************
  38    2016-06-27 16:00    35  ****************
  39    2016-06-27 16:05    36  *****************
  40    2016-06-27 16:10    35  ****************
  41    2016-06-27 16:15    35  ****************
  42    2016-06-27 16:20    32  *************
  43    2016-06-27 16:25    33  **************
  44    2016-06-27 16:30    34  ***************
  45    2016-06-27 16:35    34  ***************
  46    2016-06-27 16:40    35  ****************
  47    2016-06-27 16:45    27  ********
  48    2016-06-27 16:50    29  **********
  49    2016-06-27 16:55    30  ***********
  50    2016-06-27 17:00    34  ***************
  51    2016-06-27 17:05    37  ******************
  52    2016-06-27 17:10    39  ********************
  53    2016-06-27 17:15    40  *********************
  54    2016-06-27 17:20    41  **********************
  55    2016-06-27 17:25    42  ***********************
  56    2016-06-27 17:30    42  ***********************
  57    2016-06-27 17:35    43  ************************
  58    2016-06-27 17:40    43  ************************
  59    2016-06-27 17:45    44  *************************
  60    2016-06-27 17:50    44  *************************
  61    2016-06-27 17:55    44  *************************
  62    2016-06-27 18:00    41  **********************
  63    2016-06-27 18:05    40  *********************
  64    2016-06-27 18:10    39  ********************
  65    2016-06-27 18:15    41  **********************
  66    2016-06-27 18:20    42  ***********************
  67    2016-06-27 18:25    43  ************************
  68    2016-06-27 18:30    43  ************************
  69    2016-06-27 18:35    38  *******************
  70    2016-06-27 18:40    37  ******************
  71    2016-06-27 18:45    36  *****************
 ...    ..(  2 skipped).    ..  *****************
  74    2016-06-27 19:00    36  *****************
  75    2016-06-27 19:05    35  ****************
  76    2016-06-27 19:10    36  *****************
  77    2016-06-27 19:15    40  *********************
  78    2016-06-27 19:20    41  **********************
  79    2016-06-27 19:25    41  **********************
  80    2016-06-27 19:30    38  *******************
  81    2016-06-27 19:35    37  ******************
  82    2016-06-27 19:40    37  ******************
  83    2016-06-27 19:45    37  ******************
  84    2016-06-27 19:50    38  *******************
 ...    ..(  4 skipped).    ..  *******************
  89    2016-06-27 20:15    38  *******************
  90    2016-06-27 20:20    37  ******************
  91    2016-06-27 20:25    38  *******************
  92    2016-06-27 20:30    37  ******************
 ...    ..(  2 skipped).    ..  ******************
  95    2016-06-27 20:45    37  ******************
  96    2016-06-27 20:50    36  *****************
  97    2016-06-27 20:55    39  ********************
  98    2016-06-27 21:00    41  **********************
  99    2016-06-27 21:05    42  ***********************
 100    2016-06-27 21:10    42  ***********************
 101    2016-06-27 21:15    39  ********************
 102    2016-06-27 21:20    38  *******************
 103    2016-06-27 21:25    39  ********************
 104    2016-06-27 21:30    41  **********************
 105    2016-06-27 21:35    39  ********************
 106    2016-06-27 21:40    27  ********
 107    2016-06-27 21:45    36  *****************
 108    2016-06-27 21:50    35  ****************
 109    2016-06-27 21:55    34  ***************
 110    2016-06-27 22:00    34  ***************
 111    2016-06-27 22:05    35  ****************
 ...    ..(  2 skipped).    ..  ****************
 114    2016-06-27 22:20    35  ****************
 115    2016-06-27 22:25    36  *****************
 ...    ..(  4 skipped).    ..  *****************
 120    2016-06-27 22:50    36  *****************
 121    2016-06-27 22:55    37  ******************
 122    2016-06-27 23:00    39  ********************
 123    2016-06-27 23:05    37  ******************
 124    2016-06-27 23:10    37  ******************
 125    2016-06-27 23:15    38  *******************
 ...    ..(  2 skipped).    ..  *******************
   0    2016-06-27 23:30    38  *******************
   1    2016-06-27 23:35    39  ********************
   2    2016-06-27 23:40    39  ********************
   3    2016-06-27 23:45    38  *******************
   4    2016-06-27 23:50    37  ******************
   5    2016-06-27 23:55    37  ******************
   6    2016-06-28 00:00    37  ******************
   7    2016-06-28 00:05    36  *****************
   8    2016-06-28 00:10    36  *****************
   9    2016-06-28 00:15    36  *****************
  10    2016-06-28 00:20    37  ******************
  11    2016-06-28 00:25    37  ******************
  12    2016-06-28 00:30    38  *******************
  13    2016-06-28 00:35    38  *******************
  14    2016-06-28 00:40    37  ******************
  15    2016-06-28 00:45    42  ***********************
  16    2016-06-28 00:50    42  ***********************
  17    2016-06-28 00:55    39  ********************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP/SMART Log 0x04) not supported

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
0x0009  4            6  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            5  Device-to-host register FISes sent due to a COMRESET
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
0x8e06  4        82711  Vendor specific
0x8e07  4     36347773  Vendor specific
0x8e08  4          144  Vendor specific
0x8e09  4        43703  Vendor specific
0x8e0a  4      2848493  Vendor specific
0x8e0b  4       193920  Vendor specific
0x8e0c  4     10284463  Vendor specific
0x8e0d  4        74795  Vendor specific
0x8e0e  4       935421  Vendor specific
0x8e0f  4    131112960  Vendor specific
0x8e10  4      3741684  Vendor specific
0x8e11  4            7  Vendor specific
