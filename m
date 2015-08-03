Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:33250 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbbHCOnm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 10:43:42 -0400
Received: by ykoo205 with SMTP id o205so21881435yko.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 07:43:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
	<pan$73c92$81fb65b9$3c60e540$cb422e6a@cox.net>
Date: Mon, 3 Aug 2015 10:43:41 -0400
Message-ID: <CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Sonic <sonicsmith@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 1:17 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> The first thing you need to do in terms of trying to recover, is restore
> the superblock on the damaged device.  Since btrfs keeps multiple copies
> (up to three, once the filesystem is large enough, as yours is) per
> device, that's actually relatively easy.  Use...
>
> btrfs rescue super-recover

Not sure how to tell if there is a superblock issue:
===============================
btrfs-show-super -f /dev/sdc
superblock: bytenr=65536, device=/dev/sdc
---------------------------------------------------------
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527267057664
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
                chunk length 16777216 owner 2 type SYSTEM|RAID0 num_stripes 2
                        stripe 0 devid 2 offset 1048576
                        stripe 1 devid 1 offset 20971520
backup_roots[4]:
        backup 0:
                backup_tree_root:       1517037699072   gen: 9025       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     576585728       gen: 9025       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       1517028753408   gen: 9025       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038625824768
                backup_num_devices:     2

        backup 1:
                backup_tree_root:       1517167755264   gen: 9026       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     1517167771648   gen: 9026       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       2503711637504   gen: 9026       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038625824768
                backup_num_devices:     2

        backup 2:
                backup_tree_root:       980877312       gen: 9023       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     1026768896      gen: 9023       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       1790377984      gen: 9023       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038617616384
                backup_num_devices:     2

        backup 3:
                backup_tree_root:       1960509440      gen: 9024       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     1960525824      gen: 9024       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       2106736640      gen: 9024       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038617616384
                backup_num_devices:     2

btrfs-show-super -f /dev/sde
superblock: bytenr=65536, device=/dev/sde
---------------------------------------------------------
csum                    0x9634c164 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    09024c28-7932-4ddb-960d-becc1ea839e5
label                   terrafirm
generation              9026
root                    1517167755264
sys_array_size          129
chunk_root_generation   8957
root_level              1
chunk_root              20971520
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             8001574060032
bytes_used              7038625824768
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             2
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x21
                        ( MIXED_BACKREF |
                          BIG_METADATA )
csum_type               0
csum_size               4
cache_generation        9026
uuid_tree_generation    9026
dev_item.uuid           d63b1c46-b5a2-49ae-861f-804b2f97f427
dev_item.fsid           09024c28-7932-4ddb-960d-becc1ea839e5 [match]
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527250280448
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          2
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
                chunk length 16777216 owner 2 type SYSTEM|RAID0 num_stripes 2
                        stripe 0 devid 2 offset 1048576
                        stripe 1 devid 1 offset 20971520
backup_roots[4]:
        backup 0:
                backup_tree_root:       1517037699072   gen: 9025       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     576585728       gen: 9025       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       1517028753408   gen: 9025       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038625824768
                backup_num_devices:     2

        backup 1:
                backup_tree_root:       1517167755264   gen: 9026       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     1517167771648   gen: 9026       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       2503711637504   gen: 9026       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038625824768
                backup_num_devices:     2

        backup 2:
                backup_tree_root:       980877312       gen: 9023       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     1026768896      gen: 9023       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       1790377984      gen: 9023       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038617616384
                backup_num_devices:     2

        backup 3:
                backup_tree_root:       1960509440      gen: 9024       level: 1
                backup_chunk_root:      20971520        gen: 8957       level: 1
                backup_extent_root:     1960525824      gen: 9024       level: 2
                backup_fs_root:         2056568832      gen: 1106       level: 0
                backup_dev_root:        52576256        gen: 9021       level: 1
                backup_csum_root:       2106736640      gen: 9024       level: 3
                backup_total_bytes:     8001574060032
                backup_bytes_used:      7038617616384
                backup_num_devices:     2

btrfs-show-super -a /dev/sdc
superblock: bytenr=65536, device=/dev/sdc
---------------------------------------------------------
csum                    0x510e90f6 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    09024c28-7932-4ddb-960d-becc1ea839e5
label                   terrafirm
generation              9026
root                    1517167755264
sys_array_size          129
chunk_root_generation   8957
root_level              1
chunk_root              20971520
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             8001574060032
bytes_used              7038625824768
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             2
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x21
                        ( MIXED_BACKREF |
                          BIG_METADATA )
csum_type               0
csum_size               4
cache_generation        9026
uuid_tree_generation    9026
dev_item.uuid           224c95e6-d71b-494a-a4f6-cc72a84f1e89
dev_item.fsid           09024c28-7932-4ddb-960d-becc1ea839e5 [match]
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527267057664
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

superblock: bytenr=67108864, device=/dev/sdc
---------------------------------------------------------
csum                    0xf16fb838 [match]
bytenr                  67108864
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    09024c28-7932-4ddb-960d-becc1ea839e5
label                   terrafirm
generation              9026
root                    1517167755264
sys_array_size          129
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527267057664
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

superblock: bytenr=274877906944, device=/dev/sdc
---------------------------------------------------------
csum                    0x0ce8ee09 [match]
bytenr                  274877906944
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    09024c28-7932-4ddb-960d-becc1ea839e5
label                   terrafirm
generation              9026
root                    1517167755264
sys_array_size          129
chunk_root_generation   8957
root_level              1
chunk_root              20971520
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             8001574060032
bytes_used              7038625824768
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             2
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x21
                        ( MIXED_BACKREF |
                          BIG_METADATA )
csum_type               0
csum_size               4
cache_generation        9026
uuid_tree_generation    9026
dev_item.uuid           224c95e6-d71b-494a-a4f6-cc72a84f1e89
dev_item.fsid           09024c28-7932-4ddb-960d-becc1ea839e5 [match]
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527267057664
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

btrfs-show-super -a /dev/sde
superblock: bytenr=65536, device=/dev/sde
---------------------------------------------------------
csum                    0x9634c164 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    09024c28-7932-4ddb-960d-becc1ea839e5
label                   terrafirm
generation              9026
root                    1517167755264
sys_array_size          129
chunk_root_generation   8957
root_level              1
chunk_root              20971520
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             8001574060032
bytes_used              7038625824768
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             2
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x21
                        ( MIXED_BACKREF |
                          BIG_METADATA )
csum_type               0
csum_size               4
cache_generation        9026
uuid_tree_generation    9026
dev_item.uuid           d63b1c46-b5a2-49ae-861f-804b2f97f427
dev_item.fsid           09024c28-7932-4ddb-960d-becc1ea839e5 [match]
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527250280448
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          2
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

superblock: bytenr=67108864, device=/dev/sde
---------------------------------------------------------
csum                    0x3655e9aa [match]
bytenr                  67108864
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    09024c28-7932-4ddb-960d-becc1ea839e5
label                   terrafirm
generation              9026
root                    1517167755264
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527250280448
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          2
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

superblock: bytenr=274877906944, device=/dev/sde
---------------------------------------------------------
csum                    0xcbd2bf9b [match]
bytenr                  274877906944
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    09024c28-7932-4ddb-960d-becc1ea839e5
label                   terrafirm
generation              9026
root                    1517167755264
sys_array_size          129
chunk_root_generation   8957
root_level              1
chunk_root              20971520
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             8001574060032
bytes_used              7038625824768
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             2
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x21
                        ( MIXED_BACKREF |
                          BIG_METADATA )
csum_type               0
csum_size               4
cache_generation        9026
uuid_tree_generation    9026
dev_item.uuid           d63b1c46-b5a2-49ae-861f-804b2f97f427
dev_item.fsid           09024c28-7932-4ddb-960d-becc1ea839e5 [match]
dev_item.type           0
dev_item.total_bytes    4000787030016
dev_item.bytes_used     3527250280448
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          2
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
===============================

There's some difference between the output of /dev/sdc and /dev/sde
but they may be completely normal.
How does one determine from the above whether or not a superblock is bad?

Is "btrfs rescue super-recover" safe to run? IOW, will it ask before
doing anything possibly destructive (assuming I don't give it a -y)?

Chris
