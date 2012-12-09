Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40732 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab2LIAiz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Dec 2012 19:38:55 -0500
Received: by mail-gh0-f174.google.com with SMTP id g15so303429ghb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Dec 2012 16:38:54 -0800 (PST)
Date: Sat, 8 Dec 2012 18:38:50 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help with corrupt filesystem: __btrfs_free_extent:5236: IO
 failure
Message-ID: <20121209003849.GB31750@lintop>
References: <20121208161653.GA31750@lintop>
 <F0BF473A-0D76-4CCF-9DDC-A7C8EB8DB211@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <F0BF473A-0D76-4CCF-9DDC-A7C8EB8DB211@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Chris,

Below is some more info.

On Sat, Dec 08, 2012 at 02:21:04PM -0700, Chris Murphy wrote:
> 
> On Dec 8, 2012, at 9:16 AM, Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
> 
> >  When the machine came back up the sdc errors had stopped
> > but there were numerous 'btrfs checksum failed sdc fixing' type
> > messages which seemed to indicate btrfs was successfully rebuilding my
> > RAID 1 array as it encountered bad blocks on sdc.
> 
> No, if they were bad sectors (persistent read failure) you'd have
> seen read errors in dmesg, but none such error is in what you
> posted. I think the bad checksums after reboot implies the data or
> checksum were corrupted on write, a function of a hardware problem.

Immediately after the first reboot these are the messages I saw in dmesg.

[    3.386271] Btrfs loaded
[    3.392176] device label btrfs_pool devid 2 transid 96972 /dev/sdd2
[    3.399156] device label btrfs_pool devid 1 transid 96897 /dev/sdc3
[    3.437061] firewire_ohci 0000:06:03.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, qui
[    3.488484] device label btrfs_pool devid 1 transid 96897 /dev/sdc3
[    3.502959] btrfs: disk space caching is enabled
[    3.577789] btrfs: bdev /dev/sdc3 errs: wr 410377, rd 173846, flush 0, corrupt 0, gen 0
[    3.577793] btrfs: bdev /dev/sdd2 errs: wr 177, rd 0, flush 0, corrupt 0, gen 0
[    3.938151] firewire_core 0000:06:03.0: created device fw0: GUID 0090270001c00939, S400
[    9.915678] parent transid verify failed on 1101193216 wanted 96925 found 96500
[    9.925659] btrfs read error corrected: ino 1 off 1101193216 (dev /dev/sdc3 sector 2150768)
[   17.664302] parent transid verify failed on 1095725056 wanted 96924 found 96500
[   17.669861] btrfs read error corrected: ino 1 off 1095725056 (dev /dev/sdc3 sector 2140088)
[   17.670192] parent transid verify failed on 1056108544 wanted 96924 found 96500
[   17.672760] btrfs read error corrected: ino 1 off 1056108544 (dev /dev/sdc3 sector 2062712)
[   17.675243] parent transid verify failed on 1061355520 wanted 96924 found 96498
[   17.684690] btrfs read error corrected: ino 1 off 1061355520 (dev /dev/sdc3 sector 2072960)
[   17.798637] device label btrfs_pool devid 1 transid 96897 /dev/sdc3
[   17.827087] btrfs: disk space caching is enabled
[   17.876022] btrfs: bdev /dev/sdc3 errs: wr 410377, rd 173846, flush 0, corrupt 0, gen 0
[   17.876028] btrfs: bdev /dev/sdd2 errs: wr 177, rd 0, flush 0, corrupt 0, gen 0
[   32.232573] device label btrfs_pool devid 1 transid 96897 /dev/sdc3
[   32.250119] btrfs: disk space caching is enabled
[   32.276328] parent transid verify failed on 3726622720 wanted 96972 found 96730
[   32.277115] btrfs read error corrected: ino 1 off 3726622720 (dev /dev/sdc3 sector 7278560)
[   32.284802] parent transid verify failed on 3726655488 wanted 96972 found 96730
[   32.285309] btrfs read error corrected: ino 1 off 3726655488 (dev /dev/sdc3 sector 7278624)
[   32.285497] parent transid verify failed on 3726696448 wanted 96972 found 96730
[   32.285753] btrfs read error corrected: ino 1 off 3726696448 (dev /dev/sdc3 sector 7278704)
[   32.290307] parent transid verify failed on 3678056448 wanted 96972 found 96731
[   32.298403] btrfs read error corrected: ino 1 off 3678056448 (dev /dev/sdc3 sector 7183704)
[   32.298707] parent transid verify failed on 3726684160 wanted 96972 found 96730
[   32.299045] btrfs read error corrected: ino 1 off 3726684160 (dev /dev/sdc3 sector 7278680)
[   32.302766] parent transid verify failed on 3680645120 wanted 96972 found 96731
[   32.305553] btrfs read error corrected: ino 1 off 3680645120 (dev /dev/sdc3 sector 7188760)
[   32.310331] parent transid verify failed on 3728547840 wanted 96972 found 96730
[   32.320597] btrfs read error corrected: ino 1 off 3728547840 (dev /dev/sdc3 sector 7282320)
[   32.328104] parent transid verify failed on 3725254656 wanted 96971 found 96730
[   32.333314] btrfs read error corrected: ino 1 off 3725254656 (dev /dev/sdc3 sector 7275888)
[   32.334974] parent transid verify failed on 3726692352 wanted 96972 found 96730
[   32.335301] btrfs read error corrected: ino 1 off 3726692352 (dev /dev/sdc3 sector 7278696)
[   32.335307] btrfs: bdev /dev/sdc3 errs: wr 410377, rd 173846, flush 0, corrupt 0, gen 0
[   32.335313] btrfs: bdev /dev/sdd2 errs: wr 177, rd 0, flush 0, corrupt 0, gen 0
[   32.386651] parent transid verify failed on 3718213632 wanted 96971 found 96730
[   32.396118] btrfs read error corrected: ino 1 off 3718213632 (dev /dev/sdc3 sector 7262136)
[   37.286099] verify_parent_transid: 454 callbacks suppressed
[   37.286104] parent transid verify failed on 3189469184 wanted 96966 found 96673
[   37.287096] repair_io_failure: 454 callbacks suppressed
[   37.287100] btrfs read error corrected: ino 1 off 3189469184 (dev /dev/sdc3 sector 6229432)
[   37.287534] parent transid verify failed on 3407593472 wanted 96967 found 96702
[   37.287804] btrfs read error corrected: ino 1 off 3407593472 (dev /dev/sdc3 sector 6655456)
[   37.299699] parent transid verify failed on 3381628928 wanted 96967 found 96699
[   37.300535] btrfs read error corrected: ino 1 off 3381628928 (dev /dev/sdc3 sector 6604744)
[   37.311824] parent transid verify failed on 2871615488 wanted 96964 found 96634
[   37.313070] btrfs read error corrected: ino 1 off 2871615488 (dev /dev/sdc3 sector 5608624)
[   37.325408] parent transid verify failed on 3174629376 wanted 96966 found 96670
[   37.326726] btrfs read error corrected: ino 1 off 3174629376 (dev /dev/sdc3 sector 6200448)
[   37.346944] parent transid verify failed on 3127439360 wanted 96965 found 96662
[   37.349875] btrfs read error corrected: ino 1 off 3127439360 (dev /dev/sdc3 sector 6108280)
[   37.357928] parent transid verify failed on 3560812544 wanted 96970 found 96719
[   37.359168] btrfs read error corrected: ino 1 off 3560812544 (dev /dev/sdc3 sector 6954712)
[   37.359618] parent transid verify failed on 3290255360 wanted 96966 found 96682
[   37.359893] btrfs read error corrected: ino 1 off 3290255360 (dev /dev/sdc3 sector 6426280)
[   37.359907] parent transid verify failed on 3290259456 wanted 96966 found 96682
[   37.360161] btrfs read error corrected: ino 1 off 3290259456 (dev /dev/sdc3 sector 6426288)
[   37.388267] parent transid verify failed on 2822504448 wanted 96964 found 96623
[   37.396333] btrfs read error corrected: ino 1 off 2822504448 (dev /dev/sdc3 sector 5512704)
[   42.308245] verify_parent_transid: 509 callbacks suppressed
[   42.308250] parent transid verify failed on 3129597952 wanted 96965 found 96662
...snip...
[   63.318516] btrfs csum failed ino 284609 off 0 csum 3241965377 private 360485910
[   63.318548] btrfs csum failed ino 284609 off 4096 csum 3783011097 private 4078720777
[   63.318569] btrfs csum failed ino 284609 off 8192 csum 2745078496 private 3037842836
[   63.318586] repair_io_failure: 38 callbacks suppressed
[   63.318591] btrfs read error corrected: ino 1 off 3436023808 (dev /dev/sdc3 sector 6710984)
[   63.411299] btrfs csum failed ino 284609 off 0 csum 3241965377 private 360485910
[   63.411323] btrfs csum failed ino 284609 off 4096 csum 3783011097 private 4078720777
[   63.411336] btrfs csum failed ino 284609 off 8192 csum 2745078496 private 3037842836
[   63.508221] btrfs read error corrected: ino 284609 off 0 (dev /dev/sdc3 sector 2167584)
[   63.508389] btrfs read error corrected: ino 284609 off 4096 (dev /dev/sdc3 sector 2167592)
[   63.508535] btrfs read error corrected: ino 284609 off 8192 (dev /dev/sdc3 sector 2167600)
[   64.159541] verify_parent_transid: 40 callbacks suppressed
[   64.159546] parent transid verify failed on 841203712 wanted 96900 found 96475
[   64.167657] btrfs read error corrected: ino 1 off 841203712 (dev /dev/sdc3 sector 1642976)
[   64.175117] parent transid verify failed on 820383744 wanted 96899 found 96896
[   64.184580] btrfs read error corrected: ino 1 off 820383744 (dev /dev/sdc3 sector 1602312)
[   64.191534] parent transid verify failed on 834121728 wanted 96899 found 96472
[   64.249667] btrfs read error corrected: ino 1 off 834121728 (dev /dev/sdc3 sector 1629144)
[   64.499721] btrfs: csum mismatch on free space cache
[   64.499736] btrfs: failed to load free space cache for block group 29360128
[   65.279873] parent transid verify failed on 3556302848 wanted 96970 found 96722
[   66.881896] btrfs: space cache generation (92611) does not match inode (96972)
[   66.881909] btrfs: failed to load free space cache for block group 3250585600
[   67.880469] btrfs read error corrected: ino 1 off 3556302848 (dev /dev/sdc3 sector 6945904)
[   68.078913] btrfs csum failed ino 287608 off 806912 csum 965782046 private 1951468806
[   68.078950] btrfs csum failed ino 287608 off 811008 csum 2212338187 private 539691807
[   68.079692] btrfs csum failed ino 287608 off 806912 csum 965782046 private 1951468806
[   68.079751] btrfs csum failed ino 287608 off 811008 csum 2212338187 private 539691807
[   68.099894] btrfs read error corrected: ino 287608 off 806912 (dev /dev/sdc3 sector 3144128)
[   68.100134] btrfs read error corrected: ino 287608 off 811008 (dev /dev/sdc3 sector 3144136)
[   68.347866] parent transid verify failed on 1056452608 wanted 96916 found 96490
[   69.062780] parent transid verify failed on 3430797312 wanted 96968 found 96706
[   69.161559] parent transid verify failed on 3245637632 wanted 96966 found 96677
[   69.179370] parent transid verify failed on 3383848960 wanted 96967 found 96699
[   69.195543] parent transid verify failed on 3676991488 wanted 96970 found 96729
...snip...
[  145.299195] btrfs: csum mismatch on free space cache
[  145.299210] btrfs: failed to load free space cache for block group 433821057024
[  146.016546] btrfs: space cache generation (93318) does not match inode (96971)
[  146.016561] btrfs: failed to load free space cache for block group 434894798848
[  147.776472] verify_parent_transid: 92 callbacks suppressed
[  147.776477] parent transid verify failed on 2456469504 wanted 96936 found 96540
[  147.786087] repair_io_failure: 92 callbacks suppressed
[  147.786090] btrfs read error corrected: ino 1 off 2456469504 (dev /dev/sdc3 sector 4797792)
[  147.921253] parent transid verify failed on 3371769856 wanted 96967 found 96699
[  147.929470] btrfs read error corrected: ino 1 off 3371769856 (dev /dev/sdc3 sector 6585488)
[  147.929675] parent transid verify failed on 3371773952 wanted 96967 found 96699
[  147.930559] btrfs read error corrected: ino 1 off 3371773952 (dev /dev/sdc3 sector 6585496)
[  148.022309] parent transid verify failed on 3526729728 wanted 96969 found 96718
[  148.030034] btrfs read error corrected: ino 1 off 3526729728 (dev /dev/sdc3 sector 6888144)
[  148.030306] parent transid verify failed on 3526733824 wanted 96969 found 96718
[  148.030669] btrfs read error corrected: ino 1 off 3526733824 (dev /dev/sdc3 sector 6888152)
[  148.061423] parent transid verify failed on 3087200256 wanted 96965 found 96659
[  148.067303] btrfs read error corrected: ino 1 off 3087200256 (dev /dev/sdc3 sector 6029688)
[  148.112779] parent transid verify failed on 3524685824 wanted 96969 found 96718
[  148.118259] btrfs read error corrected: ino 1 off 3524685824 (dev /dev/sdc3 sector 6884152)
[  148.120654] parent transid verify failed on 2666045440 wanted 96962 found 96577
[  148.128039] parent transid verify failed on 3160895488 wanted 96966 found 96669
[  148.128089] btrfs read error corrected: ino 1 off 2666045440 (dev /dev/sdc3 sector 5207120)
[  148.134407] btrfs read error corrected: ino 1 off 3160895488 (dev /dev/sdc3 sector 6173624)
[  148.138319] btrfs csum failed ino 314693 off 0 csum 241179414 private 1978611799
[  148.152986] btrfs read error corrected: ino 314693 off 0 (dev /dev/sdc3 sector 240432760)
[  148.158064] parent transid verify failed on 3658862592 wanted 96970 found 96729
[  148.221016] btrfs csum failed ino 314693 off 20480 csum 2367515231 private 896174729
[  148.221050] btrfs csum failed ino 314693 off 24576 csum 1731868577 private 3450230768
[  148.226009] btrfs csum failed ino 314693 off 20480 csum 2367515231 private 896174729
[  148.226065] btrfs csum failed ino 314693 off 24576 csum 1731868577 private 3450230768
[  148.228311] btrfs csum failed ino 315299 off 0 csum 2850563942 private 1761819742
...snip...
[  168.775840] btrfs_readpage_end_io_hook: 265 callbacks suppressed
[  168.775843] btrfs csum failed ino 315227 off 4358144 csum 364006799 private 3032684437
[  168.781561] btrfs csum failed ino 315227 off 4366336 csum 425290729 private 2772363141
[  168.796790] btrfs csum failed ino 315228 off 782336 csum 2566472073 private 107177059
[  168.797099] btrfs csum failed ino 315228 off 790528 csum 2566472073 private 118026065
[  168.797130] btrfs csum failed ino 315228 off 794624 csum 2566472073 private 1296739918
[  168.797157] btrfs csum failed ino 315228 off 798720 csum 2566472073 private 817355111
[  168.797183] btrfs csum failed ino 315228 off 802816 csum 2566472073 private 1619688620
[  168.797208] btrfs csum failed ino 315228 off 806912 csum 2566472073 private 3001657401
[  168.797229] btrfs csum failed ino 315228 off 811008 csum 2566472073 private 2602659134
[  168.797248] btrfs csum failed ino 315228 off 815104 csum 2566472073 private 3127012703
[  173.478943] repair_io_failure: 295 callbacks suppressed
[  173.478948] btrfs read error corrected: ino 315228 off 4079616 (dev /dev/sdc3 sector 225899080)
[  173.525072] btrfs read error corrected: ino 315227 off 3088384 (dev /dev/sdc3 sector 1426179104)

These types of errors continued for a 15+ minutes mostly "btrfs read
error corrected" and "parent transid verify failed".  After running
the smartctl checks on the drives I thought the "read error corrected
messages" were promising so I thought doing a scrub would be safe.
After starting the scrub I got some different types of messages in
dmesg which I can post if people are interested but here is the
summary:

# btrfs scrub status /
scrub status for 5517b4f7-f962-4e67-a4a0-df96c6ced151
 scrub started at Wed Dec  5 21:24:18 2012 and was aborted after 6152 seconds
 total bytes scrubbed: 1.88TB with 20483 errors
 error details: verify=19900 csum=583
 corrected errors: 20483, uncorrectable errors: 0, unverified errors: 0

> sdc and sdd are on the same or different controllers? If it's the
> same, sounds like bad/loose cable to sdc, or the interface on sdc
> itself is failing.

Both drives are connected to the same controller:

00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6 port SATA AHCI Controller (rev 02)

I can try replacing the cables and checking the connections.

> >  At this point I
> > thought it would be a good idea to help the process along so I started
> > a 'btrfs scrub start /' and went off to bed to let it churn through my
> > ~3TB of data.
> 
> I think you should have been more curious why these errors were
> happening in the first place, rather than expecting they're benign
> enough a file system can fix the problem. Why not check the cables?
> Run smartctl -a on the two drives? 

The initial errors led me to the following:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625922

The reports there made me think a reboot would be safe and would
likely "fix" the errors reported by /dev/sdc.  The reports also seemed
to indicate that in most cases RAID would need to rebuild to fix the
blocks.  So I decided it was worth a reboot to see if it would indeed
fix the errors, and indeed it did make those particular errors go
away.

The first thing I did after the reboot was run 'smartctl -a' on the
two drives, but I did not think to check the cables.  Here are the
results:

# smartctl -a /dev/sdc
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-3.6.8-2.fc17.x86_64] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda (SATA 3Gb/s, 4K Sectors)
Device Model:     ST3000DM001-9YN166
Serial Number:    Z1F0GDLM
LU WWN Device Id: 5 000c50 03f98c161
Firmware Version: CC9D
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sat Dec  8 17:46:25 2012 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

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
data collection:   (  584) seconds.
Offline data collection
capabilities:     (0x73) SMART execute Offline immediate.
     Auto Offline data collection on/off support.
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
recommended polling time:   (   1) minutes.
Extended self-test routine
recommended polling time:   ( 336) minutes.
Conveyance self-test routine
recommended polling time:   (   2) minutes.
SCT capabilities:         (0x3081) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   120   099   006    Pre-fail  Always       -       236344312
  3 Spin_Up_Time            0x0003   093   092   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       308
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   075   060   030    Pre-fail  Always       -       30556471
  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       1088
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       306
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   070   046   045    Old_age   Always       -       30 (Min/Max 30/30)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       35
193 Load_Cycle_Count        0x0032   097   097   000    Old_age   Always       -       6862
194 Temperature_Celsius     0x0022   030   054   000    Old_age   Always       -       30 (0 20 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       23
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       127182571570177
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       75351619674140
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       142694546538785

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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


# smartctl -a /dev/sdd
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-3.6.8-2.fc17.x86_64] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda (SATA 3Gb/s, 4K Sectors)
Device Model:     ST3000DM001-9YN166
Serial Number:    Z1F0G5RL
LU WWN Device Id: 5 000c50 03fa39ca4
Firmware Version: CC9D
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sat Dec  8 17:49:01 2012 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

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
data collection:   (  575) seconds.
Offline data collection
capabilities:     (0x73) SMART execute Offline immediate.
     Auto Offline data collection on/off support.
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
recommended polling time:   (   1) minutes.
Extended self-test routine
recommended polling time:   ( 335) minutes.
Conveyance self-test routine
recommended polling time:   (   2) minutes.
SCT capabilities:         (0x3081) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail  Always       -       135843240
  3 Spin_Up_Time            0x0003   093   092   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       306
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   075   060   030    Pre-fail  Always       -       31157819
  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       1086
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       306
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   069   061   045    Old_age   Always       -       31 (Min/Max 31/32)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       35
193 Load_Cycle_Count        0x0032   097   097   000    Old_age   Always       -       7690
194 Temperature_Celsius     0x0022   031   040   000    Old_age   Always       -       31 (0 17 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       4
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       195708774777851
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       76150355105316
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       170296887048265

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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

> > So am I screwed?  I suppose since the drives do mount read only I
> > should be able to copy all of the salvageable data to some new drives.
> > Is this my only option?
> 
> Your next step depends on whether you have a backup of the data or
> not, and it sounds like you're playing with an experimental file
> system without a backup. If that's true and the data is important
> I'd block copy each disk independently to new disks, before you do
> anything else.

There are no backups, but I'm not a complete idiot and well understood
the risks when I set this up.  All of the data can be scrapped but if
I can salvage it I would like to try to keep some of it around.  Is it
a bad idea to try to rsync some of it to separate drives while the
filesystem is mounted read only?  I'm not sure I'm willing to buy two
more 3TB drives to do the independent block copies you suggest to save
all of the data.

Thanks,
Shawn
