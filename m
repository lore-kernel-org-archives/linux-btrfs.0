Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33575 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753689AbdHUQbh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 12:31:37 -0400
Received: by mail-oi0-f47.google.com with SMTP id f11so160360041oic.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:31:37 -0700 (PDT)
MIME-Version: 1.0
From: Robert LeBlanc <robert@leblancnet.us>
Date: Mon, 21 Aug 2017 10:31:34 -0600
Message-ID: <CAANLjFrM9TsxoL_WdeSLZt-7hn2zXKo=Qi0mVw9p=oWSCPxLqA@mail.gmail.com>
Subject: Re: Btrfs Raid5 issue.
To: quwenruo.btrfs@gmx.com, linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="001a113cc43e30a13805574603ef"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a113cc43e30a13805574603ef
Content-Type: text/plain; charset="UTF-8"

Qu,

Sorry, I'm not on the list (I was for a few years about three years ago).

I looked at the backup roots like you mentioned.

# ./btrfs inspect dump-super -f /dev/bcache0
superblock: bytenr=65536, device=/dev/bcache0
---------------------------------------------------------
csum_type               0 (crc32c)
csum_size               4
csum                    0x45302c8f [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    fef29f0a-dc4c-4cc4-b524-914e6630803c
label                   kvm-btrfs
generation              1620386
root                    5310022877184
sys_array_size          161
chunk_root_generation   1620164
root_level              1
chunk_root              4725030256640
chunk_root_level        1
log_root                2876047507456
log_root_transid        0
log_root_level          0
total_bytes             8998588280832
bytes_used              3625869234176
sectorsize              4096
nodesize                16384
leafsize (deprecated)           16384
stripesize              4096
root_dir                6
num_devices             3
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x1e1
                        ( MIXED_BACKREF |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          RAID56 |
                          SKINNY_METADATA )
cache_generation        1620386
uuid_tree_generation    42
dev_item.uuid           cb56a9b7-8d67-4ae8-8cb0-076b0b93f9c4
dev_item.fsid           fef29f0a-dc4c-4cc4-b524-914e6630803c [match]
dev_item.type           0
dev_item.total_bytes    2998998654976
dev_item.bytes_used     2295693574144
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          2
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 4725030256640)
                length 67108864 owner 2 stripe_len 65536 type
SYSTEM|RAID5
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 3 sub_stripes 1
                        stripe 0 devid 1 offset 2185232384
                        dev_uuid e273c794-b231-4d86-9a38-53a6d2fa8643
                        stripe 1 devid 3 offset 1195075698688
                        dev_uuid 120d6a05-b0bc-46c8-a87e-ca4fe5008d09
                        stripe 2 devid 2 offset 41340108800
                        dev_uuid cb56a9b7-8d67-4ae8-8cb0-076b0b93f9c4
backup_roots[4]:
        backup 0:
                backup_tree_root:       5309879451648   gen: 1620384    level: 1
                backup_chunk_root:      4725030256640   gen: 1620164    level: 1
                backup_extent_root:     5309910958080   gen: 1620385    level: 2
                backup_fs_root:         3658468147200   gen: 1618016    level: 1
                backup_dev_root:        5309904224256   gen: 1620384    level: 1
                backup_csum_root:       5309910532096   gen: 1620385    level: 3
                backup_total_bytes:     8998588280832
                backup_bytes_used:      3625871646720
                backup_num_devices:     3

        backup 1:
                backup_tree_root:       5309780492288   gen: 1620385    level: 1
                backup_chunk_root:      4725030256640   gen: 1620164    level: 1
                backup_extent_root:     5309659037696   gen: 1620385    level: 2
                backup_fs_root:         0       gen: 0  level: 0
                backup_dev_root:        5309872275456   gen: 1620385    level: 1
                backup_csum_root:       5309674536960   gen: 1620385    level: 3
                backup_total_bytes:     8998588280832
                backup_bytes_used:      3625869234176
                backup_num_devices:     3

        backup 2:
                backup_tree_root:       5310022877184   gen: 1620386    level: 1
                backup_chunk_root:      4725030256640   gen: 1620164    level: 1
                backup_extent_root:     2876048949248   gen: 1620387    level: 2
                backup_fs_root:         3658468147200   gen: 1618016    level: 1
                backup_dev_root:        5309872275456   gen: 1620385    level: 1
                backup_csum_root:       5310042259456   gen: 1620386    level: 3
                backup_total_bytes:     8998588280832
                backup_bytes_used:      3625869250560
                backup_num_devices:     3

        backup 3:
                backup_tree_root:       5309771448320   gen: 1620383    level: 1
                backup_chunk_root:      4725030256640   gen: 1620164    level: 1
                backup_extent_root:     5309779804160   gen: 1620384    level: 2
                backup_fs_root:         3658468147200   gen: 1618016    level: 1
                backup_dev_root:        5309848158208   gen: 1620383    level: 1
                backup_csum_root:       5309848846336   gen: 1620384    level: 3
                backup_total_bytes:     8998588280832
                backup_bytes_used:      3625871904768
                backup_num_devices:     3

I did a check on each on and the output is attached, but nothing seemed clean.

This got me to thinking, maybe I can try to mount one of these
backuproots. So I went searching and found
https://btrfs.wiki.kernel.org/index.php/Mount_options and tried the
'usebackuproot' but it doesn't seem to have an argument about which
one to use. I'm not sure if it thinks that the first one is good and
just keeps trying that and never tries a backup one as the dmesg is
the same.

I noticed on that page that there is a 'nologreplay' mount option so I
tried it with degraded and it requires ro, but the volume mounted and
I can "see" things on the volume.

So with this nologreplay option, if I do a btrfs send of the subvolume
that I'm interested in (I don't think it was being written to at the
time of failure), would it copy (send) over the corruption as well. I
do have an older snapshot of that subvolume and I could make a rw snap
of that and rsync if needed. In any case, I feel that btrfs has given
me more options than may have otherwise been available. What are your
or others suggestions about moving forward?

Thanks,
Robert
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

--001a113cc43e30a13805574603ef
Content-Type: application/x-xz; name="btrfs_check.txt.xz"
Content-Disposition: attachment; filename="btrfs_check.txt.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j6mddx1f0

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
ZmbCscRn+wIAAAAABFla
--001a113cc43e30a13805574603ef--
