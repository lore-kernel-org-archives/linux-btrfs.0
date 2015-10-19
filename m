Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33772 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbJSIjI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 04:39:08 -0400
Received: by wijp11 with SMTP id p11so88751018wij.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 01:39:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Oct 2015 10:39:06 +0200
Message-ID: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
Subject: Btrfs/RAID5 became unmountable after SATA cable fault
From: "Janos Toth F." <toth.f.janos@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was in the middle of replacing the drives of my NAS one-by-one (I
wished to move to bigger and faster storage at the end), so I used one
more SATA drive + SATA cable than usual. Unfortunately, the extra
cable turned out to be faulty and it looks like it caused some heavy
damage to the file system.

There was no "devive replace" running at the moment or the disaster.
The first round already got finished hours ago and I planned to start
the next one before going to sleep. So, it was a full RAID-5 setup in
normal state. But one of the active, mounted devices was the first
replacment HDD and it was hanging on the spare SATA cable.

I tried to save some file to my mounted samba share and I realized the
file system because read-only. I rebooted the machine and saw that my
/data can't be mounted.
According to SmartmonTools, one of the drives was suffering from SATA
communication errors.

I tried some tirivial recovery methods and I tried to search the
mailing list archives but I didn't really find a solution. I wonder if
somebody can help with this.

Should I run "btrfs rescue chunk-recover /dev/sda"?

Here are some raw details:

# uname -a
Linux F17a_NAS 4.2.3-gentoo #2 SMP Sun Oct 18 17:56:45 CEST 2015
x86_64 AMD E-350 Processor AuthenticAMD GNU/Linux

# btrfs --version
btrfs-progs v4.2.2

# btrfs check /dev/sda
checksum verify failed on 21102592 found 295F0086 wanted 00000000
checksum verify failed on 21102592 found 295F0086 wanted 00000000
checksum verify failed on 21102592 found 99D0FC26 wanted B08FFCA0
checksum verify failed on 21102592 found 99D0FC26 wanted B08FFCA0
bytenr mismatch, want=21102592, have=65536
Couldn't read chunk root
Couldn't open file system

# mount /dev/sda /data -o ro,recovery
mount: wrong fs type, bad option, bad superblock on /dev/sda, ...

# cat /proc/kmsg
<6>[ 1902.033164] BTRFS info (device sdb): enabling auto recovery
<6>[ 1902.033184] BTRFS info (device sdb): disk space caching is enabled
<6>[ 1902.033191] BTRFS: has skinny extents
<3>[ 1902.034931] BTRFS (device sdb): bad tree block start 0 21102592
<3>[ 1902.051259] BTRFS (device sdb): parent transid verify failed on
21147648 wanted 101748 found 101124
<3>[ 1902.111807] BTRFS (device sdb): parent transid verify failed on
44613632 wanted 101770 found 101233
<3>[ 1902.126529] BTRFS (device sdb): parent transid verify failed on
40595456 wanted 101767 found 101232
<6>[ 1902.164667] BTRFS: bdev /dev/sda errs: wr 858, rd 8057, flush
280, corrupt 0, gen 0
<3>[ 1902.165929] BTRFS (device sdb): parent transid verify failed on
44617728 wanted 101770 found 101233
<3>[ 1902.166975] BTRFS (device sdb): parent transid verify failed on
44621824 wanted 101770 found 101233
<3>[ 1902.271296] BTRFS (device sdb): parent transid verify failed on
38621184 wanted 101765 found 101223
<3>[ 1902.380526] BTRFS (device sdb): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[ 1902.381510] BTRFS (device sdb): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[ 1902.381549] BTRFS: Failed to read block groups: -5
<3>[ 1902.394835] BTRFS: open_ctree failed
<6>[ 1911.202254] BTRFS info (device sdb): enabling auto recovery
<6>[ 1911.202270] BTRFS info (device sdb): disk space caching is enabled
<6>[ 1911.202275] BTRFS: has skinny extents
<3>[ 1911.203611] BTRFS (device sdb): bad tree block start 0 21102592
<3>[ 1911.204803] BTRFS (device sdb): parent transid verify failed on
21147648 wanted 101748 found 101124
<3>[ 1911.246384] BTRFS (device sdb): parent transid verify failed on
44613632 wanted 101770 found 101233
<3>[ 1911.248729] BTRFS (device sdb): parent transid verify failed on
40595456 wanted 101767 found 101232
<6>[ 1911.251658] BTRFS: bdev /dev/sda errs: wr 858, rd 8057, flush
280, corrupt 0, gen 0
<3>[ 1911.252485] BTRFS (device sdb): parent transid verify failed on
44617728 wanted 101770 found 101233
<3>[ 1911.253542] BTRFS (device sdb): parent transid verify failed on
44621824 wanted 101770 found 101233
<3>[ 1911.278414] BTRFS (device sdb): parent transid verify failed on
38621184 wanted 101765 found 101223
<3>[ 1911.283950] BTRFS (device sdb): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[ 1911.284835] BTRFS (device sdb): parent transid verify failed on
38719488 wanted 101765 found 101223
<3>[ 1911.284873] BTRFS: Failed to read block groups: -5
<3>[ 1911.298783] BTRFS: open_ctree failed


# btrfs-show-super /dev/sda
superblock: bytenr=65536, device=/dev/sda
---------------------------------------------------------
csum                    0xe8789014 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    2bba7cff-b4bf-4554-bee4-66f69c761ec4
label
generation              101480
root                    37892096
sys_array_size          258
chunk_root_generation   101124
root_level              2
chunk_root              21147648
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             6001196802048
bytes_used              3593129504768
sectorsize              4096
nodesize                4096
leafsize                4096
stripesize              4096
root_dir                6
num_devices             3
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x381
                        ( MIXED_BACKREF |
                          RAID56 |
                          SKINNY_METADATA |
                          NO_HOLES )
csum_type               0
csum_size               4
cache_generation        101480
uuid_tree_generation    101480
dev_item.uuid           330c9c98-4140-497a-814f-ac76a5b07172
dev_item.fsid           2bba7cff-b4bf-4554-bee4-66f69c761ec4 [match]
dev_item.type           0
dev_item.total_bytes    2000398934016
dev_item.bytes_used     1809263362048
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          2
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0


# btrfs-show-super /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum                    0x177aae67 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    2bba7cff-b4bf-4554-bee4-66f69c761ec4
label
generation              101770
root                    44650496
sys_array_size          258
chunk_root_generation   101748
root_level              2
chunk_root              21102592
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             6001196802048
bytes_used              3533993762816
sectorsize              4096
nodesize                4096
leafsize                4096
stripesize              4096
root_dir                6
num_devices             3
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x381
                        ( MIXED_BACKREF |
                          RAID56 |
                          SKINNY_METADATA |
                          NO_HOLES )
csum_type               0
csum_size               4
cache_generation        101770
uuid_tree_generation    101770
dev_item.uuid           f14b343e-b701-47f2-a652-e52a47be42b2
dev_item.fsid           2bba7cff-b4bf-4554-bee4-66f69c761ec4 [match]
dev_item.type           0
dev_item.total_bytes    2000398934016
dev_item.bytes_used     1815705812992
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          3
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0


# btrfs-show-super /dev/sdc
superblock: bytenr=65536, device=/dev/sdc
---------------------------------------------------------
csum                    0xa06026f3 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    2bba7cff-b4bf-4554-bee4-66f69c761ec4
label
generation              101770
root                    44650496
sys_array_size          258
chunk_root_generation   101748
root_level              2
chunk_root              21102592
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             6001196802048
bytes_used              3533993762816
sectorsize              4096
nodesize                4096
leafsize                4096
stripesize              4096
root_dir                6
num_devices             3
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x381
                        ( MIXED_BACKREF |
                          RAID56 |
                          SKINNY_METADATA |
                          NO_HOLES )
csum_type               0
csum_size               4
cache_generation        101770
uuid_tree_generation    101770
dev_item.uuid           4dadced6-392f-4d57-920c-ee8fbebbd608
dev_item.fsid           2bba7cff-b4bf-4554-bee4-66f69c761ec4 [match]
dev_item.type           0
dev_item.total_bytes    2000398934016
dev_item.bytes_used     1815726784512
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0


# smartctl -a /dev/sda
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.2.3-gentoo] (local build)
...
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       16

This was a new drive and this counter didn't move before I thouched
the cables again in order to prepare for the next "device replace"
round.
I checked the SMART data several times before, during and after the
first round of "device replace" to make sure the new drive didn't came
as faulty from the factory/reseller... I sure these two (unmountable
filesystem and this SATA cable error counter) are directly related.

I threw away these SATA cables because another one of this "batch" (a
four-pack I picked up somewhere, sometime...) proved to be faulty as
well (although that one didn't cause any practical harm, other than
making a Windows PC hanging and the CRC error counter of the SSD
rising).


I am not really happy that Btrfs in RAID5 mode wasn't a little more
fault tolerant towards "disk" faults. Although it might still be
saved, right? Right? :)


Thank you for your answers in advance!
