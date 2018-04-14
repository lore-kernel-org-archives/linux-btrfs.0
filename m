Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:30243 "EHLO
        smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbeDNNq2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 09:46:28 -0400
Subject: Re: remounted ro during operation, unmountable since
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
 <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
From: Timo Nentwig <btrfs@nentwig.biz>
Message-ID: <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>
Date: Sat, 14 Apr 2018 15:45:11 +0200
MIME-Version: 1.0
In-Reply-To: <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/14/2018 11:42 AM, Qu Wenruo wrote:
> And the work load when the RO happens is also helpful.
> (Well, the dmesg of RO happens would be the best though)
Surprisingly nothing special AFAIR. It's a private, mostly idle machine. 
Probably "just" browsing with chrome.
I didn't notice the remount right away as there were no obvious 
failures. And even then I kept it running for a couple more hours/a day 
or so.

I had a glance at dmesg but don't remember anything specific (think the 
usual "---- [cut here] ---" + dump of registers, but I'm not even sure 
about that). Sorry.

Actually the same thing happened just a few days earlier and after a 
reboot (and maybe fsck) it was back up and good. Was optimistic it would 
go the same way this time as well :) In general I had to hard-reset (+ 
fsck) a couple of times in recent times. Except for the SSD it's an 
all-new machine that I'm still OC/stress-testing. But not when that 
particular event happened.
> Despite above salvage method, please also considering provide the
> following data, as your case is pretty special and may help us to catch
> a long hidden bug.
If only I had know I would have saved dmesg! :)
Sure, I'd be happy to help. If you need any more information just let me 
know.
> 1) Extent tree dump
>     Need above 2 patches applied first.
>
>     # btrfs inspect dump-tree -t extent /dev/sda2 &> \
>       /tmp/extent_tree_dump
>     If above dump is too large, "grep -C20 166030671872" of the output is
>     also good enough.

I'll send you a link to the full dump directly.

     key (162020040704 EXTENT_ITEM 4096) block 130834812928 (31942093) 
gen 1627950
     key (162032852992 EXTENT_ITEM 16384) block 130834829312 (31942097) 
gen 1627950
     key (162058788864 EXTENT_ITEM 126976) block 166896513024 (40746219) 
gen 1627103
     key (162067652608 EXTENT_ITEM 122880) block 181095837696 (44212851) 
gen 1626650
     key (162074021888 EXTENT_ITEM 126976) block 181095841792 (44212852) 
gen 1626650
     key (162080391168 EXTENT_ITEM 126976) block 181095845888 (44212853) 
gen 1626650
     key (162086768640 EXTENT_ITEM 126976) block 140649435136 (34338241) 
gen 1697624
     key (162541010944 EXTENT_ITEM 1052672) block 141310992384 
(34499754) gen 1626990
     key (162557276160 EXTENT_ITEM 118784) block 130641969152 (31895012) 
gen 1627722
     key (162677518336 EXTENT_ITEM 122880) block 140914860032 (34403042) 
gen 1626930
     key (162678145024 EXTENT_ITEM 122880) block 140343918592 (34263652) 
gen 1626743
     key (162682937344 EXTENT_ITEM 122880) block 181095866368 (44212858) 
gen 1626650
     key (162692177920 EXTENT_ITEM 118784) block 130621235200 (31889950) 
gen 1627194
     key (162698711040 EXTENT_ITEM 28672) block 130621198336 (31889941) 
gen 1627194
     key (162699722752 EXTENT_ITEM 4096) block 180581654528 (44087318) 
gen 1675166
     key (162702168064 EXTENT_ITEM 4096) block 131325329408 (32061848) 
gen 1626697
     key (162702237696 EXTENT_ITEM 8192) block 181116600320 (44217920) 
gen 1626654
     key (162707652608 EXTENT_ITEM 49152) block 181095890944 (44212864) 
gen 1626650
     key (162710052864 EXTENT_ITEM 1859584) block 140858179584 
(34389204) gen 1626926
     key (162735849472 EXTENT_ITEM 32768) block 140858195968 (34389208) 
gen 1626926
     key (162793705472 EXTENT_ITEM 4096) block 166030671872 (40534832) 
gen 1702074
     key (162858274816 EXTENT_ITEM 21327872) block 140301692928 
(34253343) gen 1626728
     key (162881642496 EXTENT_ITEM 73728) block 130903351296 (31958826) 
gen 1626665
     key (162884112384 EXTENT_ITEM 53248) block 130903355392 (31958827) 
gen 1626665
     key (162884964352 EXTENT_ITEM 4096) block 130903359488 (31958828) 
gen 1626665
leaf 181087133696 items 51 free space 17 generation 1626650 owner 
EXTENT_TREE
leaf 181087133696 flags 0x1(WRITTEN) backref revision 1
fs uuid 22e778f7-2499-4379-99d2-cdd399d1cc6e
chunk uuid bee8ad15-e128-45f1-a3d7-e2fda17806ce
     item 0 key (161456054272 EXTENT_ITEM 4096) itemoff 3942 itemsize 53
         refs 1 gen 1626650 flags DATA
         extent data backref root 5 objectid 89243202 offset 0 count 1
     item 1 key (161456058368 EXTENT_ITEM 4096) itemoff 3889 itemsize 53
         refs 1 gen 1626650 flags DATA
         extent data backref root 5 objectid 89243208 offset 0 count 1
     item 2 key (161456062464 EXTENT_ITEM 4096) itemoff 3836 itemsize 53
         refs 1 gen 1626650 flags DATA
         extent data backref root 5 objectid 89243192 offset 0 count 1
     item 3 key (161456066560 EXTENT_ITEM 4096) itemoff 3783 itemsize 53
         refs 1 gen 1626650 flags DATA
         extent data backref root 5 objectid 89243198 offset 0 count 1
--
         refs 1 gen 1626665 flags DATA
         extent data backref root 5 objectid 32187101 offset 655360 count 1
     item 35 key (162793402368 EXTENT_ITEM 20480) itemoff 2087 itemsize 53
         refs 1 gen 1626665 flags DATA
         extent data backref root 5 objectid 32187104 offset 0 count 1
     item 36 key (162793422848 EXTENT_ITEM 110592) itemoff 2034 itemsize 53
         refs 1 gen 1626665 flags DATA
         extent data backref root 5 objectid 32187107 offset 0 count 1
     item 37 key (162793533440 EXTENT_ITEM 118784) itemoff 1981 itemsize 53
         refs 1 gen 1626665 flags DATA
         extent data backref root 5 objectid 32187110 offset 0 count 1
     item 38 key (162793656320 EXTENT_ITEM 4096) itemoff 1928 itemsize 53
         refs 1 gen 1626665 flags DATA
         extent data backref root 5 objectid 32187112 offset 0 count 1
     item 39 key (162793664512 EXTENT_ITEM 20480) itemoff 1875 itemsize 53
         refs 1 gen 1626665 flags DATA
         extent data backref root 5 objectid 32187115 offset 0 count 1
     item 40 key (162793684992 EXTENT_ITEM 20480) itemoff 1822 itemsize 53
         refs 1 gen 1626665 flags DATA
         extent data backref root 5 objectid 32187119 offset 0 count 1
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf 166030671872 items 60 free space 95 generation 1705980 owner TREE_LOG
leaf 166030671872 flags 0x1(WRITTEN) backref revision 1
fs uuid 22e778f7-2499-4379-99d2-cdd399d1cc6e
chunk uuid bee8ad15-e128-45f1-a3d7-e2fda17806ce
     item 0 key (46475 DIR_ITEM 2335543231) itemoff 3955 itemsize 40
         location key (1973554 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002443.sst
     item 1 key (46475 DIR_ITEM 2338985614) itemoff 3915 itemsize 40
         location key (1972743 INODE_ITEM 0) type FILE
         transid 1705436 data_len 0 name_len 10
         name: 001638.sst
     item 2 key (46475 DIR_ITEM 2339658528) itemoff 3875 itemsize 40
         location key (1973225 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 002115.sst
     item 3 key (46475 DIR_ITEM 2341002938) itemoff 3835 itemsize 40
         location key (311255 INODE_ITEM 0) type FILE
         transid 1640128 data_len 0 name_len 10
         name: 000500.sst
     item 4 key (46475 DIR_ITEM 2344385674) itemoff 3795 itemsize 40
         location key (1945180 INODE_ITEM 0) type FILE
--
         refs 1 gen 1697626 flags DATA
         extent data backref root 448 objectid 672641 offset 939524096 
count 1
     item 10 key (165604331520 EXTENT_ITEM 10088448) itemoff 3412 
itemsize 53
         refs 1 gen 1626620 flags DATA
         extent data backref root 5 objectid 48964469 offset 10264576 
count 1
     item 11 key (165663883264 EXTENT_ITEM 9146368) itemoff 3359 itemsize 53
         refs 1 gen 1626614 flags DATA
         extent data backref root 5 objectid 42160317 offset 0 count 1
     item 12 key (165708148736 EXTENT_ITEM 9912320) itemoff 3306 itemsize 53
         refs 1 gen 1626620 flags DATA
         extent data backref root 5 objectid 48964469 offset 20353024 
count 1
     item 13 key (165735571456 EXTENT_ITEM 25378816) itemoff 3253 
itemsize 53
         refs 1 gen 1626613 flags DATA
         extent data backref root 5 objectid 1905 offset 83456000 count 1
     item 14 key (165760950272 EXTENT_ITEM 134217728) itemoff 3200 
itemsize 53
         refs 1 gen 1697627 flags DATA
         extent data backref root 448 objectid 672641 offset 1073741824 
count 1
     item 15 key (165978742784 EXTENT_ITEM 13717504) itemoff 3147 
itemsize 53
         refs 1 gen 1626614 flags DATA
         extent data backref root 5 objectid 42160317 offset 9146368 count 1
     item 16 key (166030671872 EXTENT_ITEM 4096) itemoff 3096 itemsize 51
         refs 1 gen 1702074 flags TREE_BLOCK
         tree block key (162793705472 EXTENT_ITEM 4096) level 0
         tree block backref root 2
     item 17 key (166030671872 BLOCK_GROUP_ITEM 1073741824) itemoff 3072 
itemsize 24
         block group used 96915456 chunk_objectid 256 flags METADATA
     item 18 key (166030696448 EXTENT_ITEM 4096) itemoff 3021 itemsize 51
         refs 1 gen 1705980 flags TREE_BLOCK
         tree block key (EXTENT_CSUM EXTENT_CSUM 137702375424) level 0
         tree block backref root 7
     item 19 key (166030766080 EXTENT_ITEM 4096) itemoff 2970 itemsize 51
         refs 1 gen 1705985 flags TREE_BLOCK
         tree block key (138697830400 EXTENT_ITEM 24576) level 0
         tree block backref root 2
     item 20 key (166030770176 EXTENT_ITEM 4096) itemoff 2919 itemsize 51
         refs 1 gen 1705985 flags TREE_BLOCK
         tree block key (EXTENT_CSUM EXTENT_CSUM 138697756672) level 0
         tree block backref root 7
     item 21 key (166030778368 EXTENT_ITEM 4096) itemoff 2868 itemsize 51
         refs 1 gen 1705985 flags TREE_BLOCK
         tree block key (138729590784 EXTENT_ITEM 225280) level 0
         tree block backref root 2
     item 22 key (166030802944 EXTENT_ITEM 4096) itemoff 2817 itemsize 51
         refs 1 gen 1705985 flags TREE_BLOCK
         tree block key (140492824576 EXTENT_ITEM 4096) level 0
> 2) super block dump
>     # btrfs inspect dump-super -f /dev/sda2
superblock: bytenr=65536, device=/dev/sda2
---------------------------------------------------------
csum_type        0 (crc32c)
csum_size        4
csum            0xef0068ba [match]
bytenr            65536
flags            0x1
             ( WRITTEN )
magic            _BHRfS_M [match]
fsid            22e778f7-2499-4379-99d2-cdd399d1cc6e
label            830
generation        1706541
root            167104118784
sys_array_size        97
chunk_root_generation    1702072
root_level        1
chunk_root        186120536064
chunk_root_level    1
log_root        180056702976
log_root_transid    0
log_root_level        0
total_bytes        63879249920
bytes_used        36929691648
sectorsize        4096
nodesize        4096
leafsize (deprecated)        4096
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x59
             ( MIXED_BACKREF |
               COMPRESS_LZO |
               COMPRESS_ZSTD |
               EXTENDED_IREF )
cache_generation    1706541
uuid_tree_generation    1706541
dev_item.uuid        12f20294-7a53-4ba2-a2ca-09e91a365ff2
dev_item.fsid        22e778f7-2499-4379-99d2-cdd399d1cc6e [match]
dev_item.type        0
dev_item.total_bytes    63879249920
dev_item.bytes_used    63325601792
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0
sys_chunk_array[2048]:
     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 186120536064)
         length 33554432 owner 2 stripe_len 65536 type SYSTEM
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 1 sub_stripes 1
             stripe 0 devid 1 offset 1048576
             dev_uuid 12f20294-7a53-4ba2-a2ca-09e91a365ff2
backup_roots[4]:
     backup 0:
         backup_tree_root:    167104118784    gen: 1706541    level: 1
         backup_chunk_root:    186120536064    gen: 1702072    level: 1
         backup_extent_root:    167103516672    gen: 1706541 level: 3
         backup_fs_root:        167103123456    gen: 1706541 level: 3
         backup_dev_root:    130644881408    gen: 1705305    level: 1
         backup_csum_root:    167103152128    gen: 1706541    level: 3
         backup_total_bytes:    63879249920
         backup_bytes_used:    36929691648
         backup_num_devices:    1

     backup 1:
         backup_tree_root:    167100444672    gen: 1706538    level: 1
         backup_chunk_root:    186120536064    gen: 1702072    level: 1
         backup_extent_root:    167099588608    gen: 1706538 level: 3
         backup_fs_root:        167099183104    gen: 1706538 level: 3
         backup_dev_root:    130644881408    gen: 1705305    level: 1
         backup_csum_root:    167099199488    gen: 1706538    level: 3
         backup_total_bytes:    63879249920
         backup_bytes_used:    36929826816
         backup_num_devices:    1

     backup 2:
         backup_tree_root:    167101612032    gen: 1706539    level: 1
         backup_chunk_root:    186120536064    gen: 1702072    level: 1
         backup_extent_root:    167100915712    gen: 1706539 level: 3
         backup_fs_root:        167101820928    gen: 1706540 level: 3
         backup_dev_root:    130644881408    gen: 1705305    level: 1
         backup_csum_root:    167101845504    gen: 1706540    level: 3
         backup_total_bytes:    63879249920
         backup_bytes_used:    36929593344
         backup_num_devices:    1

     backup 3:
         backup_tree_root:    167102959616    gen: 1706540    level: 1
         backup_chunk_root:    186120536064    gen: 1702072    level: 1
         backup_extent_root:    167102296064    gen: 1706540 level: 3
         backup_fs_root:        167101820928    gen: 1706540 level: 3
         backup_dev_root:    130644881408    gen: 1705305    level: 1
         backup_csum_root:    167101845504    gen: 1706540    level: 3
         backup_total_bytes:    63879249920
         backup_bytes_used:    36929810432
         backup_num_devices:    1

> 3) Extra hardware info about your sda
>     Things like SMART and hardware model would also help here.
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.15.15-1-ARCH] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     SAMSUNG SSD 830 Series
Serial Number:    S0VXNYABC10154
LU WWN Device Id: 5 002538 043584d30
Firmware Version: CXM01B1Q
User Capacity:    64,023,257,088 bytes [64.0 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Apr 14 14:22:22 2018 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x83)    Offline data collection activity
                     is in a Reserved state.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (  17)    The self-test routine was 
aborted by
                     the host.
Total time to complete Offline
data collection:         (  300) seconds.
Offline data collection
capabilities:              (0x5b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     No Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      (   5) minutes.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  
WHEN_FAILED RAW_VALUE
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
Always       -       0
   9 Power_On_Hours          0x0032   095   095   000    Old_age 
Always       -       21508
  12 Power_Cycle_Count       0x0032   092   092   000    Old_age 
Always       -       7390
177 Wear_Leveling_Count     0x0013   001   001   000    Pre-fail 
Always       -       3779
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail 
Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age 
Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age 
Always       -       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail 
Always       -       0
187 Uncorrectable_Error_Cnt 0x0032   100   100   000    Old_age 
Always       -       0
190 Airflow_Temperature_Cel 0x0032   070   056   000    Old_age 
Always       -       30
195 ECC_Error_Rate          0x001a   200   200   000    Old_age 
Always       -       0
199 CRC_Error_Count         0x003e   253   253   000    Old_age 
Always       -       0
235 POR_Recovery_Count      0x0012   099   099   000    Old_age 
Always       -       153
241 Total_LBAs_Written      0x0032   099   099   000    Old_age 
Always       -       43256578423

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Aborted by host               10% 21291         -
# 2  Short offline       Completed without error       00% 21291         -
# 3  Short offline       Completed without error       00% 20933         -

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

> 4) The mount option of /dev/sda2

/dev/sda2    /    btrfs compress=zstd,discard,autodefrag,subvol=/       
0       0

And if that matters (AFAIK subvolume mount options have no effect anyway):

/dev/sda2    /var/lib/postgres       btrfs 
compress=zstd,discard,nodatacow,subvol=var/lib/postgres 0       0
/dev/sda2       /var/cache              btrfs 
compress=off,discard,subvol=var/cache                   0       0
/dev/sda2       /var/tmp                btrfs 
compress=zstd,discard,subvol=var/tmp            0       0

> Thanks,
> Qu

Got a couple of these:
We seem to be looping a lot on /mnt/sda2/var/lib/postgres/data/.., do 
you want to keep going on ? (y/N/a): y

Is this something I need to be worried about? Postgres did at least 
start up.


Thanks a lot for your help!
Timo
