Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34534 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbcAXCs6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 21:48:58 -0500
Received: by mail-lb0-f181.google.com with SMTP id cl12so58720085lbc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 18:48:57 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 24 Jan 2016 03:48:56 +0100
Message-ID: <CAPmG0jbyd43cLxomzJzjw=1U7JYWE98yP+KbDg5ve6XE8TfxOw@mail.gmail.com>
Subject: bad metadata [5198686912512, 5198686916608) crossing stripe boundary
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

btrfs-progs: fsck: Fix a false alert where extent record has wrong metadata flag
https://github.com/kdave/btrfs-progs/commit/b08a740d7b797d870cbc3691b1291290d0815998

This false alerts (  bad extent [X, Y), type mismatch with chunk ),
about 2.5 million on one of my filesystems aren't reported anymore
(kernel v4.4, tools v4.4)

However, now there are about 50 of these:

bad metadata [5198714765312, 5198714769408) crossing stripe boundary
( ... )

Some calculations (I am trying to understand what is wrong):

5198686916608 - 5198686912512 = 4096
5198686912512 / 0x10000 = 79325667
5198686916608 / 0x10000 = 79325667,0625

It looks like the call to this function is based on wrong flags (I
just did quick scan of the code in cmds-check.c etc):
static inline int check_crossing_stripes(u64 start, u64 len)
{
return (start / BTRFS_STRIPE_LEN) !=
      ((start + len - 1) / BTRFS_STRIPE_LEN);
}

Is there really an error or could this also be a false positive ?

I found this:
https://github.com/kdave/btrfs-progs/commit/595c57d2f4dd3199aacb23b4c68d6aff49f97d29

in relation to 'crossing stripe boundary', but it seems fixing it is
not possible. The fs is about 1.5 years old I believe, it is not an
ext4-converted one. See info below.

scrub is OK and there are no other errors reported by btrfs check
other than those 'crossing stripe boundary' ones. The fs is a clone
with a few hundred (older) snapshots.

# btrfs-show-super /dev/sdh
superblock: bytenr=65536, device=/dev/sdh
---------------------------------------------------------
csum                    0x1f70c171 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    f5652e53-8e20-4ffc-8463-b618871cdfce
label                   bak
generation              43204
root                    7402793697280
sys_array_size          258
chunk_root_generation   43123
root_level              2
chunk_root              7403982553088
chunk_root_level        2
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             6001196802048
bytes_used              4501868240896
sectorsize              4096
nodesize                4096
leafsize                4096
stripesize              4096
root_dir                6
num_devices             3
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x41
                        ( MIXED_BACKREF |
                          EXTENDED_IREF )
csum_type               0
csum_size               4
cache_generation        43204
uuid_tree_generation    43204
dev_item.uuid           3daf44f9-489f-4342-a2cd-188b80151fea
dev_item.fsid           f5652e53-8e20-4ffc-8463-b618871cdfce [match]
dev_item.type           0
dev_item.total_bytes    2000398934016
dev_item.bytes_used     1634310553600
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0

# btrfs de  us /local/bak
/dev/sde, ID: 2
   Device size:             1.82TiB
   Data,single:             1.50TiB
   Metadata,RAID1:          2.00GiB
   Unallocated:           322.02GiB

/dev/sdg, ID: 4
   Device size:             1.82TiB
   Data,single:             1.18TiB
   Metadata,RAID1:         10.00GiB
   System,RAID1:           64.00MiB
   Unallocated:           641.95GiB

/dev/sdh, ID: 1
   Device size:             1.82TiB
   Data,single:             1.48TiB
   Metadata,RAID1:          8.00GiB
   System,RAID1:           64.00MiB
   Unallocated:           340.95GiB


# btrfs fi us /local/bak
Overall:
    Device size:                   5.46TiB
    Device allocated:              4.18TiB
    Device unallocated:            1.27TiB
    Device missing:                  0.00B
    Used:                          4.10TiB
    Free (estimated):              1.35TiB      (min: 732.50GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:4.16TiB, Used:4.08TiB
   /dev/sde        1.50TiB
   /dev/sdg        1.18TiB
   /dev/sdh        1.48TiB

Metadata,RAID1: Size:10.00GiB, Used:8.73GiB
   /dev/sde        2.00GiB
   /dev/sdg       10.00GiB
   /dev/sdh        8.00GiB

System,RAID1: Size:64.00MiB, Used:580.00KiB
   /dev/sdg       64.00MiB
   /dev/sdh       64.00MiB

Unallocated:
   /dev/sde      322.02GiB
   /dev/sdg      641.95GiB
   /dev/sdh      340.95GiB
