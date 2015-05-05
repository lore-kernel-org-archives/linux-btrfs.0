Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.com ([74.208.4.200]:52839 "EHLO mout.gmx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761367AbbEEQgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 12:36:11 -0400
Received: from crinkle.gilfillan.org ([68.15.115.197]) by mail.gmx.com
 (mrgmxus002) with ESMTPSA (Nemesis) id 0MRoNT-1Yeqxv0TGL-00T0DB for
 <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 18:36:10 +0200
Message-ID: <5548F177.1040309@linuxmail.org>
Date: Tue, 05 May 2015 11:36:07 -0500
From: Perry Gilfillan <perrye@linuxmail.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: hard lockup while balance was running killed my raid5
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My apologies if this is a double post, but messages from my google mail 
based accounts don't seem to go through, even asking majordomo for help 
got no reply.  If list-owner is reading this, those accounts are still 
subscribed if you want to look into it.


I've been using BTRFS for the better part of a year now without too many 
hiccups, and recovered from those that have happened with minimal fuss 
until now.  I created this raid5 set a few months ago on a collection of 
1TB and 2TB drives, and since then have been swapping in new 3TB drives.

The data is just broadcast recordings, so there's no time pressure, nor 
are there backups...  So I'll sit on the problem for as long it takes to 
see a solution.


My kernel
Linux lightmyfire 4.1.0-0.rc1.git1.1.fc23.x86_64 #1 SMP Sun May 3 
14:26:14 CDT 2015 x86_64 x86_64 x86_64 GNU/Linux

I've got btrfs-progs and btrfs-progs-unstable from git, so I'll use 
which ever might be useful for any further diagnostics.

Since devid 1 & 2 appear to be fully utilized, I set off a balance, the 
system locked up,  and nothing I've read points to a solution yet.

Looking at btrfs-show-super it appears that /dev/sdf5 is the one that is 
causing the transid problem.  The other device supers all show 
generation 291859.  I've tried hiding sdf5 ( wipefs ) with no success, 
so degraded doesn't help.



[root@lightmyfire btrfs-progs-unstable]# ./btrfs fi sh /dev/sda5
Label: 'mythstore-Q-002'  uuid: 8cb46c9e-9633-435f-a965-1afd14c981d6
         Total devices 5 FS bytes used 6.82TiB
         devid    1 size 2.44TiB used 2.44TiB path /dev/sde5
         devid    2 size 2.44TiB used 2.44TiB path /dev/sdc5
         devid    5 size 1.82TiB used 1.79TiB path /dev/sdd1
         devid    6 size 2.44TiB used 1.79TiB path /dev/sda5
         devid    7 size 2.44TiB used 1.79TiB path /dev/sdf5

btrfs-progs v4.0


[root@lightmyfire btrfs-progs-unstable]# mount -o ro,recovery /dev/sda5 
/media/mythstore-q/
mount: wrong fs type, bad option, bad superblock on /dev/sda5,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

[root@lightmyfire btrfs-progs-unstable]# dmesg | tail
[90155.912245] BTRFS info (device sde5): enabling auto recovery
[90155.912250] BTRFS info (device sde5): disk space caching is enabled
[90155.914705] BTRFS (device sde5): parent transid verify failed on 
27198602870784 wanted 291859 found 291431
[90155.916631] BTRFS (device sde5): parent transid verify failed on 
27198602887168 wanted 291859 found 291431
[90155.967480] BTRFS (device sde5): parent transid verify failed on 
27198604001280 wanted 291640 found 291420
[90156.688917] BTRFS (device sde5): bad tree block start 889192477 
27198604001280
[90156.689124] BTRFS: failed to read chunk tree on sde5
[90156.758500] BTRFS: open_ctree failed




superblock: bytenr=65536, device=/dev/sde5
---------------------------------------------------------
csum                    0xaec2d815 [match]
bytenr                  65536
flags                   0x1
magic                   _BHRfS_M [match]
fsid                    8cb46c9e-9633-435f-a965-1afd14c981d6
label                   mythstore-Q-002
generation              291859
root                    26023428292608
sys_array_size          161
chunk_root_generation   291859
root_level              1
chunk_root              27198602870784
chunk_root_level        1
log_root                26023432650752
log_root_transid        0
log_root_level          0
total_bytes             12726740449280
bytes_used              7496508084224
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             5
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0xe1
                         ( MIXED_BACKREF |
                           BIG_METADATA |
                           EXTENDED_IREF |
                           RAID56 )
csum_type               0
csum_size               4
cache_generation        291859
uuid_tree_generation    291859
dev_item.uuid           4d3a8469-8492-4cbe-bba9-dc77c82fe2b5
dev_item.fsid           8cb46c9e-9633-435f-a965-1afd14c981d6 [match]
dev_item.type           0
dev_item.total_bytes    2681585270784
dev_item.bytes_used     2681584222208
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0


superblock: bytenr=65536, device=/dev/sdf5
---------------------------------------------------------
csum                    0x4b5bad00 [match]
bytenr                  65536
flags                   0x1
magic                   _BHRfS_M [match]
fsid                    8cb46c9e-9633-435f-a965-1afd14c981d6
label                   mythstore-Q-002
generation              291431
root                    26096742498304
sys_array_size          161
chunk_root_generation   291431
root_level              1
chunk_root              27198602870784
chunk_root_level        1
log_root                26096751624192
log_root_transid        0
log_root_level          0
total_bytes             12726740449280
bytes_used              7496518389760
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             5
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0xe1
                         ( MIXED_BACKREF |
                           BIG_METADATA |
                           EXTENDED_IREF |
                           RAID56 )
csum_type               0
csum_size               4
cache_generation        291431
uuid_tree_generation    291431
dev_item.uuid           3fc033b6-43f7-4e07-aee3-00ca592615f9
dev_item.fsid           8cb46c9e-9633-435f-a965-1afd14c981d6 [match]
dev_item.type           0
dev_item.total_bytes    2681585737216
dev_item.bytes_used     1964992626688
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          7
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

