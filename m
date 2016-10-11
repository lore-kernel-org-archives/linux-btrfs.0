Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35451 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753773AbcJKQTL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 12:19:11 -0400
Received: by mail-io0-f170.google.com with SMTP id i202so29924561ioi.2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 09:19:10 -0700 (PDT)
From: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
To: "'Chris Murphy'" <lists@colorremedies.com>
Cc: "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com> <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com> <5e8501d223d7$715a9bb0$540fd310$@com> <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com>
In-Reply-To: <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com>
Subject: RE: raid6 file system in a bad state
Date: Tue, 11 Oct 2016 11:10:55 -0500
Message-ID: <5e8601d223da$0cbf6c00$263e4400$@com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> 
> Bad superblocks can't be a good thing and would only cause confusion.
> I'd think that a known bad superblock would be ignored at mount time
> and even by btrfs-find-root, or maybe even replaced like any other kind
> of known bad metadata where good copies are available.
> 
> btrfs-show-super -f /dev/sda
> btrfs-show-super -f /dev/sdh
> 
> 
> Find out what the difference is between good and bad supers.
> 
root@castor:~# btrfs-show-super -f /dev/sda
superblock: bytenr=65536, device=/dev/sda
---------------------------------------------------------
csum_type               0 (crc32c)
csum_size               4
csum                    0x45278835 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    73ed01df-fb2a-4b27-b6fc-12a57da934bd
label
generation              161562
root                    5752616386560
sys_array_size          354
chunk_root_generation   156893
root_level              1
chunk_root              20971520
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             18003557892096
bytes_used              7107627130880
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             6
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0xe1
                        ( MIXED_BACKREF |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          RAID56 )
cache_generation        161562
uuid_tree_generation    161562
dev_item.uuid           08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
dev_item.fsid           73ed01df-fb2a-4b27-b6fc-12a57da934bd [match]
dev_item.type           0
dev_item.total_bytes    3000592982016
dev_item.bytes_used     1800957198336
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
                chunk length 4194304 owner 2 stripe_len 65536
                type SYSTEM num_stripes 1
                        stripe 0 devid 1 offset 0
                        dev uuid: 08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
        item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
                chunk length 11010048 owner 2 stripe_len 65536
                type SYSTEM|RAID6 num_stripes 6
                        stripe 0 devid 6 offset 1048576
                        dev uuid: 390a1fd8-cc6c-40e7-b0b5-88ca7dcbcc32
                        stripe 1 devid 5 offset 1048576
                        dev uuid: 2df974c5-9dde-4062-81e9-c6eeee13db62
                        stripe 2 devid 4 offset 1048576
                        dev uuid: dce3d159-721d-4859-9955-37a03769bb0d
                        stripe 3 devid 3 offset 1048576
                        dev uuid: 6f7142db-824c-4791-a5b2-d6ce11c81c8f
                        stripe 4 devid 2 offset 1048576
                        dev uuid: dc8760f1-2c54-4134-a9a7-a0ac2b7a9f1c
                        stripe 5 devid 1 offset 20971520
                        dev uuid: 08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
backup_roots[4]:
        backup 0:
                backup_tree_root:       5752437456896   gen: 161561     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     5752385224704   gen: 161561     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        5752437587968   gen: 161561     level: 1
                backup_csum_root:       5752389615616   gen: 161561     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7112579833856
                backup_num_devices:     6

        backup 1:
                backup_tree_root:       5752616386560   gen: 161562     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     5752649416704   gen: 161563     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        5752616501248   gen: 161562     level: 1
                backup_csum_root:       5752650203136   gen: 161563     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7107602407424
                backup_num_devices:     6

        backup 2:
                backup_tree_root:       5752112103424   gen: 161559     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     5752207409152   gen: 161560     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        5752113463296   gen: 161559     level: 1
                backup_csum_root:       5752205492224   gen: 161560     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7112514002944
                backup_num_devices:     6

        backup 3:
                backup_tree_root:       5752298307584   gen: 161560     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     5752385224704   gen: 161561     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        5752299978752   gen: 161560     level: 1
                backup_csum_root:       5752389615616   gen: 161561     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7112542425088
                backup_num_devices:     6


root@castor:~# btrfs-show-super -f /dev/sdh
superblock: bytenr=65536, device=/dev/sdh
---------------------------------------------------------
csum_type               0 (crc32c)
csum_size               4
csum                    0x0f7dfe09 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    73ed01df-fb2a-4b27-b6fc-12a57da934bd
label
generation              161474
root                    4844272943104
sys_array_size          354
chunk_root_generation   156893
root_level              1
chunk_root              20971520
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             18003557892096
bytes_used              7110395990016
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             6
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0xe1
                        ( MIXED_BACKREF |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          RAID56 )
cache_generation        161474
uuid_tree_generation    161474
dev_item.uuid           dc8760f1-2c54-4134-a9a7-a0ac2b7a9f1c
dev_item.fsid           73ed01df-fb2a-4b27-b6fc-12a57da934bd [match]
dev_item.type           0
dev_item.total_bytes    3000592982016
dev_item.bytes_used     1800936226816
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          2
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
                chunk length 4194304 owner 2 stripe_len 65536
                type SYSTEM num_stripes 1
                        stripe 0 devid 1 offset 0
                        dev uuid: 08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
        item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
                chunk length 11010048 owner 2 stripe_len 65536
                type SYSTEM|RAID6 num_stripes 6
                        stripe 0 devid 6 offset 1048576
                        dev uuid: 390a1fd8-cc6c-40e7-b0b5-88ca7dcbcc32
                        stripe 1 devid 5 offset 1048576
                        dev uuid: 2df974c5-9dde-4062-81e9-c6eeee13db62
                        stripe 2 devid 4 offset 1048576
                        dev uuid: dce3d159-721d-4859-9955-37a03769bb0d
                        stripe 3 devid 3 offset 1048576
                        dev uuid: 6f7142db-824c-4791-a5b2-d6ce11c81c8f
                        stripe 4 devid 2 offset 1048576
                        dev uuid: dc8760f1-2c54-4134-a9a7-a0ac2b7a9f1c
                        stripe 5 devid 1 offset 20971520
                        dev uuid: 08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
backup_roots[4]:
        backup 0:
                backup_tree_root:       4844253364224   gen: 161473     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     4844248121344   gen: 161473     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        1411186688      gen: 156893     level: 1
                backup_csum_root:       4844247793664   gen: 161473     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7110380077056
                backup_num_devices:     6

        backup 1:
                backup_tree_root:       4844272943104   gen: 161474     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     4844268240896   gen: 161474     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        1411186688      gen: 156893     level: 1
                backup_csum_root:       4844254216192   gen: 161474     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7110395990016
                backup_num_devices:     6

        backup 2:
                backup_tree_root:       4844252168192   gen: 161471     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     4844242698240   gen: 161471     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        1411186688      gen: 156893     level: 1
                backup_csum_root:       4844241764352   gen: 161471     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7110343888896
                backup_num_devices:     6

        backup 3:
                backup_tree_root:       4844263358464   gen: 161472     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
                backup_extent_root:     4844261965824   gen: 161472     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
                backup_dev_root:        1411186688      gen: 156893     level: 1
                backup_csum_root:       4844261801984   gen: 161472     level: 3
                backup_total_bytes:     18003557892096
                backup_bytes_used:      7110370037760
                backup_num_devices:     6


root@castor:~# btrfs-show-super -f /dev/sda > sda
root@castor:~# btrfs-show-super -f /dev/sdh > sdh
root@castor:~# diff -u sda sdh
--- sda 2016-10-11 11:09:42.853170807 -0500
+++ sdh 2016-10-11 11:09:46.469082028 -0500
@@ -1,16 +1,16 @@
-superblock: bytenr=65536, device=/dev/sda
+superblock: bytenr=65536, device=/dev/sdh
 ---------------------------------------------------------
 csum_type              0 (crc32c)
 csum_size              4
-csum                   0x45278835 [match]
+csum                   0x0f7dfe09 [match]
 bytenr                 65536
 flags                  0x1
                        ( WRITTEN )
 magic                  _BHRfS_M [match]
 fsid                   73ed01df-fb2a-4b27-b6fc-12a57da934bd
 label
-generation             161562
-root                   5752616386560
+generation             161474
+root                   4844272943104
 sys_array_size         354
 chunk_root_generation  156893
 root_level             1
@@ -20,7 +20,7 @@
 log_root_transid       0
 log_root_level         0
 total_bytes            18003557892096
-bytes_used             7107627130880
+bytes_used             7110395990016
 sectorsize             4096
 nodesize               16384
 leafsize               16384
@@ -34,17 +34,17 @@
                          BIG_METADATA |
                          EXTENDED_IREF |
                          RAID56 )
-cache_generation       161562
-uuid_tree_generation   161562
-dev_item.uuid          08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
+cache_generation       161474
+uuid_tree_generation   161474
+dev_item.uuid          dc8760f1-2c54-4134-a9a7-a0ac2b7a9f1c
 dev_item.fsid          73ed01df-fb2a-4b27-b6fc-12a57da934bd [match]
 dev_item.type          0
 dev_item.total_bytes   3000592982016
-dev_item.bytes_used    1800957198336
+dev_item.bytes_used    1800936226816
 dev_item.io_align      4096
 dev_item.io_width      4096
 dev_item.sector_size   4096
-dev_item.devid         1
+dev_item.devid         2
 dev_item.dev_group     0
 dev_item.seek_speed    0
 dev_item.bandwidth     0
@@ -72,47 +72,47 @@
                        dev uuid: 08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
 backup_roots[4]:
        backup 0:
-               backup_tree_root:       5752437456896   gen: 161561     level: 1
+               backup_tree_root:       4844253364224   gen: 161473     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
-               backup_extent_root:     5752385224704   gen: 161561     level: 2
+               backup_extent_root:     4844248121344   gen: 161473     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
-               backup_dev_root:        5752437587968   gen: 161561     level: 1
-               backup_csum_root:       5752389615616   gen: 161561     level: 3
+               backup_dev_root:        1411186688      gen: 156893     level: 1
+               backup_csum_root:       4844247793664   gen: 161473     level: 3
                backup_total_bytes:     18003557892096
-               backup_bytes_used:      7112579833856
+               backup_bytes_used:      7110380077056
                backup_num_devices:     6

        backup 1:
-               backup_tree_root:       5752616386560   gen: 161562     level: 1
+               backup_tree_root:       4844272943104   gen: 161474     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
-               backup_extent_root:     5752649416704   gen: 161563     level: 2
+               backup_extent_root:     4844268240896   gen: 161474     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
-               backup_dev_root:        5752616501248   gen: 161562     level: 1
-               backup_csum_root:       5752650203136   gen: 161563     level: 3
+               backup_dev_root:        1411186688      gen: 156893     level: 1
+               backup_csum_root:       4844254216192   gen: 161474     level: 3
                backup_total_bytes:     18003557892096
-               backup_bytes_used:      7107602407424
+               backup_bytes_used:      7110395990016
                backup_num_devices:     6

        backup 2:
-               backup_tree_root:       5752112103424   gen: 161559     level: 1
+               backup_tree_root:       4844252168192   gen: 161471     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
-               backup_extent_root:     5752207409152   gen: 161560     level: 2
+               backup_extent_root:     4844242698240   gen: 161471     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
-               backup_dev_root:        5752113463296   gen: 161559     level: 1
-               backup_csum_root:       5752205492224   gen: 161560     level: 3
+               backup_dev_root:        1411186688      gen: 156893     level: 1
+               backup_csum_root:       4844241764352   gen: 161471     level: 3
                backup_total_bytes:     18003557892096
-               backup_bytes_used:      7112514002944
+               backup_bytes_used:      7110343888896
                backup_num_devices:     6

        backup 3:
-               backup_tree_root:       5752298307584   gen: 161560     level: 1
+               backup_tree_root:       4844263358464   gen: 161472     level: 1
                backup_chunk_root:      20971520        gen: 156893     level: 1
-               backup_extent_root:     5752385224704   gen: 161561     level: 2
+               backup_extent_root:     4844261965824   gen: 161472     level: 2
                backup_fs_root:         124387328       gen: 74008      level: 0
-               backup_dev_root:        5752299978752   gen: 161560     level: 1
-               backup_csum_root:       5752389615616   gen: 161561     level: 3
+               backup_dev_root:        1411186688      gen: 156893     level: 1
+               backup_csum_root:       4844261801984   gen: 161472     level: 3
                backup_total_bytes:     18003557892096
-               backup_bytes_used:      7112542425088
+               backup_bytes_used:      7110370037760
                backup_num_devices:     6




