Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60835 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2HBVtt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 17:49:49 -0400
Date: Thu, 2 Aug 2012 14:49:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120802214946.GB1834@merlins.org>
References: <20120722185848.GA10089@merlins.org>
 <201208022220.08217.Martin@lichtvoll.de>
 <20120802204414.GA1834@merlins.org>
 <201208022321.51795.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201208022321.51795.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 11:21:51PM +0200, Martin Steigerwald wrote:
> > Yep, my du -sh tests do show that ext4 is 2x faster than btrfs.
> > Obviously it's sending IO in a way that either the IO subsystem, linux
> > driver, or drive prefer.
> 
> But only on reads.

Yes. I was focussing on the simple case. SSDs can be slower than hard
drives on writes, and now you're getting into deep firmware magic for
corner cases, so I didn't want to touch that here :)
 
> WTF?
> 
> Hey, did you adapt the size= keyword? It seems fio 2.0.8 can do completely
> without it.

I left it as is:
[global]
ioengine=libaio
direct=1
filename=/dev/sda
size=476940m
bsrange=2k-16k

[zufälliglesen]
rw=randread
runtime=60

[sequentielllesen]
stonewall
rw=read
runtime=60

I just removed it now.

> Okay, one further idea: Remove the bsrange to just test with 4k blocks.

Ok, there you go:
[global]
ioengine=libaio
direct=1
filename=/dev/sda
blocksize=4k
blockalign=4k

[zufälliglesen]
rw=randread
runtime=60

[sequentielllesen]
stonewall
rw=read
runtime=60

gandalfthegreat:~# fio --readonly ./fio.job4
zufälliglesen: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=1
sequentielllesen: (g=1): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=1
2.0.8
Starting 2 processes
Jobs: 1 (f=1): [_R] [66.9% done] [1476K/0K /s] [369 /0  iops] [eta 01m:00s]
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=3614
  read : io=60832KB, bw=1013.7KB/s, iops=253 , runt= 60012msec
    slat (usec): min=4 , max=892 , avg=24.36, stdev=16.05
    clat (usec): min=2 , max=27575 , avg=3915.39, stdev=4990.69
     lat (usec): min=44 , max=27591 , avg=3940.35, stdev=4991.99
    clat percentiles (usec):
     |  1.00th=[   41],  5.00th=[   46], 10.00th=[   51], 20.00th=[   66],
     | 30.00th=[  113], 40.00th=[  163], 50.00th=[  205], 60.00th=[ 4960],
     | 70.00th=[ 5856], 80.00th=[11584], 90.00th=[12480], 95.00th=[12608],
     | 99.00th=[14272], 99.50th=[17280], 99.90th=[18816], 99.95th=[21120],
     | 99.99th=[22912]
    bw (KB/s)  : min=  253, max= 2520, per=100.00%, avg=1014.86, stdev=364.74
    lat (usec) : 4=0.05%, 10=0.01%, 20=0.01%, 50=8.07%, 100=1iiiiiiii9.94%
    lat (usec) : 250=26.26%, 500=2.78%, 750=0.30%, 1000=0.09%
    lat (msec) : 2=0.12%, 4=0.07%, 10=20.75%, 20=21.51%, 50=0.05%
  cpu          : usr=0.31%, sys=0.88%, ctx=15250, majf=0, minf=23
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=15208/w=0/d=0, short=r=0/w=0/d=0
sequentielllesen: (groupid=1, jobs=1): err= 0: pid=3636
  read : io=88468KB, bw=1474.3KB/s, iops=368 , runt= 60009msec
    slat (usec): min=3 , max=340 , avg=16.46, stdev=10.23
    clat (usec): min=1 , max=27356 , avg=2692.99, stdev=4564.76
     lat (usec): min=30 , max=27370 , avg=2709.87, stdev=4566.31
    clat percentiles (usec):
     |  1.00th=[   27],  5.00th=[   29], 10.00th=[   31], 20.00th=[   35],
     | 30.00th=[   47], 40.00th=[   61], 50.00th=[   78], 60.00th=[  107],
     | 70.00th=[  270], 80.00th=[ 5856], 90.00th=[11712], 95.00th=[12608],
     | 99.00th=[16512], 99.50th=[17536], 99.90th=[18816], 99.95th=[19584],
     | 99.99th=[21120]
    bw (KB/s)  : min=  282, max= 5096, per=100.00%, avg=1474.40, stdev=899.36
    lat (usec) : 2=0.05%, 4=0.01%, 20=0.02%, 50=32.45%, 100=24.61%
    lat (usec) : 250=12.52%, 500=1.40%, 750=0.03%, 1000=0.03%
    lat (msec) : 2=0.02%, 4=0.03%, 10=13.95%, 20=14.85%, 50=0.03%
  cpu          : usr=0.33%, sys=0.90%, ctx=22176, majf=0, minf=25
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=22117/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=60832KB, aggrb=1013KB/s, minb=1013KB/s, maxb=1013KB/s, mint=60012msec, maxt=60012msec

Run status group 1 (all jobs):
   READ: io=88468KB, aggrb=1474KB/s, minb=1474KB/s, maxb=1474KB/s, mint=60009msec, maxt=60009msec

Disk stats (read/write):
  sda: ios=54013/1836, merge=291/17, ticks=251660/11052, in_queue=262668, util=99.51%


and the same test with blockalign=512k:
gandalfthegreat:~# fio --readonly ./fio.job4 # blockalign=512k
fio: Any use of blockalign= turns off randommap
zufälliglesen: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=1
sequentielllesen: (g=1): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=1
2.0.8
Starting 2 processes
Jobs: 1 (f=1): [_R] [66.9% done] [4180K/0K /s] [1045 /0  iops] [eta 01m:00s]
zufälliglesen: (groupid=0, jobs=1): err= 0: pid=3679
  read : io=56096KB, bw=957355 B/s, iops=233 , runt= 60001msec
    slat (usec): min=4 , max=344 , avg=27.73, stdev=15.51
    clat (usec): min=2 , max=38954 , avg=4244.27, stdev=5153.32
     lat (usec): min=44 , max=38980 , avg=4272.70, stdev=5154.68
    clat percentiles (usec):
     |  1.00th=[   42],  5.00th=[   46], 10.00th=[   53], 20.00th=[   69],
     | 30.00th=[  120], 40.00th=[  169], 50.00th=[  211], 60.00th=[ 5024],
     | 70.00th=[ 5920], 80.00th=[11584], 90.00th=[12480], 95.00th=[12608],
     | 99.00th=[16768], 99.50th=[17536], 99.90th=[18560], 99.95th=[20096],
     | 99.99th=[37632]
    bw (KB/s)  : min=  263, max= 3133, per=100.00%, avg=935.09, stdev=392.66
    lat (usec) : 4=0.05%, 10=0.03%, 20=0.01%, 50=7.84%, 100=19.12%
    lat (usec) : 250=25.84%, 500=1.61%, 750=0.08%, 1000=0.05%
    lat (msec) : 2=0.06%, 4=0.08%, 10=21.99%, 20=23.17%, 50=0.06%
  cpu          : usr=0.29%, sys=0.94%, ctx=14069, majf=0, minf=25
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=14024/w=0/d=0, short=r=0/w=0/d=0
sequentielllesen: (groupid=1, jobs=1): err= 0: pid=3703
  read : io=99592KB, bw=1659.7KB/s, iops=414 , runt= 60008msec
    slat (usec): min=4 , max=186 , avg=15.83, stdev= 9.95
    clat (usec): min=1 , max=25530 , avg=2390.79, stdev=4340.79
     lat (usec): min=28 , max=25539 , avg=2407.01, stdev=4342.90
    clat percentiles (usec):
     |  1.00th=[   26],  5.00th=[   28], 10.00th=[   30], 20.00th=[   34],
     | 30.00th=[   43], 40.00th=[   57], 50.00th=[   72], 60.00th=[   91],
     | 70.00th=[  155], 80.00th=[ 5152], 90.00th=[11712], 95.00th=[12480],
     | 99.00th=[12992], 99.50th=[16768], 99.90th=[18560], 99.95th=[18816],
     | 99.99th=[21632]
    bw (KB/s)  : min=  269, max= 8465, per=100.00%, avg=1663.84, stdev=1367.82
    lat (usec) : 2=0.01%, 4=0.02%, 20=0.01%, 50=35.42%, 100=26.00%
    lat (usec) : 250=11.29%, 500=1.31%, 750=0.05%, 1000=0.01%
    lat (msec) : 2=0.04%, 4=0.02%, 10=12.55%, 20=13.25%, 50=0.01%
  cpu          : usr=0.31%, sys=0.99%, ctx=24963, majf=0, minf=25
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=24898/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=56096KB, aggrb=934KB/s, minb=934KB/s, maxb=934KB/s, mint=60001msec, maxt=60001msec

Run status group 1 (all jobs):
   READ: io=99592KB, aggrb=1659KB/s, minb=1659KB/s, maxb=1659KB/s, mint=60008msec, maxt=60008msec

Disk stats (read/write):
  sda: ios=55021/1637, merge=72/39, ticks=240896/12080, in_queue=252912, util=99.59%


> > Since I've gotten 2 SSDs to make sure I didn't get one bad one, and that the
> > company is greating great reviews for them, I'm now pretty sure that
> > it's either a problem with a linux driver, which is interesting for us
> > all to debug :)
> 
> Either that or there possible is some firmware update? But then those
> reviews would mention it I bet.
 
So far, there are no firmware updates from mine, I checked right after
unboxing it :)

> > I'll try plugging this SSD in a totally different PC and see what happens.
> > This may say if it's an AHCI/intel sata driver problem.
> 
> Seems we will continue until someone starts to complain here. Maybe
> another list will be more approbiate? But then this thread has it all
> in one ;). Adding a CC with some introductory note might be approbiate.
> Its your problem, so you decide ;). I´d suggest the fio mailing list,
> there are other performance people how may want to chime in.
 
Actually you know the lists and people involved more than me. I'd be
happy if you added a Cc to another list you think is best, and we can
move there.

> Another idea: Is there anything funny in SMART values (smartctl -a
> and possibly even -x)? Well I gather these SSDs are new, but still.


smartctl -a /dev/sda
(snipped)
SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       36
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       7
177 Wear_Leveling_Count     0x0013   099   099   000    Pre-fail  Always       -       9
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   058   040   000    Old_age   Always       -       42
195 Hardware_ECC_Recovered  0x001a   200   200   000    Old_age   Always       -       0
199 UDMA_CRC_Error_Count    0x003e   253   253   000    Old_age   Always       -       0
235 Unknown_Attribute       0x0012   099   099   000    Old_age   Always       -       4
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       433339112


smartctl -x /dev/sda
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.5.0-amd64-preempt-noide-20120410] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG SSD 830 Series
Serial Number:    S0WGNEAC400484
LU WWN Device Id: 5 002538 043584d30
Firmware Version: CXM03B1Q
User Capacity:    512,110,190,592 bytes [512 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ACS-2 revision 2
Local Time is:    Thu Aug  2 14:42:08 2012 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x83)	Offline data collection activity
					is in a Reserved state.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		( 1980) seconds.
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
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  33) minutes.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  9 Power_On_Hours          -O--CK   099   099   000    -    36
 12 Power_Cycle_Count       -O--CK   099   099   000    -    7
177 Wear_Leveling_Count     PO--C-   099   099   000    -    9
179 Used_Rsvd_Blk_Cnt_Tot   PO--C-   100   100   010    -    0
181 Program_Fail_Cnt_Total  -O--CK   100   100   010    -    0
182 Erase_Fail_Count_Total  -O--CK   100   100   010    -    0
183 Runtime_Bad_Block       PO--C-   100   100   010    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O--CK   058   040   000    -    42
195 Hardware_ECC_Recovered  -O-RC-   200   200   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   253   253   000    -    0
235 Unknown_Attribute       -O--C-   099   099   000    -    4
241 Total_LBAs_Written      -O--CK   099   099   000    -    433352008
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
GP/S  Log at address 0x01 has    1 sectors [Summary SMART error log]
GP/S  Log at address 0x02 has    2 sectors [Comprehensive SMART error log]
GP/S  Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART error log]
GP/S  Log at address 0x06 has    1 sectors [SMART self-test log]
GP/S  Log at address 0x07 has    2 sectors [Extended self-test log]
GP/S  Log at address 0x09 has    1 sectors [Selective self-test log]
GP/S  Log at address 0x10 has    1 sectors [NCQ Command Error]
GP/S  Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
(snip)

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%        27         -
# 2  Short offline       Completed without error       00%         8         -

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

Warning: device does not support SCT Commands
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2        49152  R_ERR response for data FIS
0x0003  2        53248  R_ERR response for device-to-host data FIS
0x0004  2        57344  R_ERR response for host-to-device data FIS
0x0005  2         7952  R_ERR response for non-data FIS
0x0006  2         2562  R_ERR response for device-to-host non-data FIS
0x0007  2         4096  R_ERR response for host-to-device non-data FIS
0x0008  2         7952  Device-to-host non-data FIS retries
0x0009  2         7953  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           25  Device-to-host register FISes sent due to a COMRESET
0x000b  2         6145  CRC errors within host-to-device FIS
0x000d  2         7953  Non-CRC errors within host-to-device FIS
0x000f  2         8176  R_ERR response for host-to-device data FIS, CRC
0x0010  2           15  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2        49153  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2        12112  R_ERR response for host-to-device non-data FIS, non-CRC

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
