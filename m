Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35546 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbcLLBl6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 20:41:58 -0500
Received: by mail-yw0-f194.google.com with SMTP id b66so6557762ywh.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 17:41:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKinxcWE2RWdb2GG+cX7Sp1LHyx5LNKJ--EAqWVD2HTwpyJ7eQ@mail.gmail.com>
References: <CAKinxcV8tPF_y5HoU_DVy88rfHaGwzFrzQjSiQCcFM71H+a+Gw@mail.gmail.com>
 <CAJCQCtQ1az+PeyAw=7nTasajqNskttiF1LoTQ_UJEeLc_LhkNw@mail.gmail.com> <CAKinxcWE2RWdb2GG+cX7Sp1LHyx5LNKJ--EAqWVD2HTwpyJ7eQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Dec 2016 18:41:56 -0700
Message-ID: <CAJCQCtRRJgNvyVQ=g_GVdqOwv1Y=OrMksE7uabta__ww3ET0=w@mail.gmail.com>
Subject: Re: How to get back a deleted sub-volume.
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 11, 2016 at 5:56 PM, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
> Chris, for all the time you helped so far I have to really appologize
> I've led you a stray ... so, reson the subvolumes were deleted is
> nothing to do with btrfs it self, I'm using "Rockstor" to ease
> managment tasks. This tool / environment / distribution treats a
> singular btrfs FS as a "pool" ( something in line of zfs :/ ) and when
> one removes a pool from the system it will actually go and delete
> subvolumes from FS before unmounting it and removing reference of it
> from it's DB (yes a bit shiet I know). so I'm not blaming anybody here
> for disapearing subvolumes, it's just me commig back to belive in man
> kind to get kicked in the gonads by mankind stupidity.
>
> ALSO by importing the fs to their "solution" is just actually mounting
> and walking the tree of subvolumes to to create all the references in
> local DB (for rockstor of course, still nothing to do with btrfs
> functionality). To be able to ïmport" I've had to remove before
> mentioned snpshots becouse imports script was timing out.
>
> So for a single subvolume (called physically "share") I was left with
> no snapshots (removed by me to make import not time out) and then this
> subvolume was removed when I was trying to remove a fs (pool) from a
> running system.
>
> I've polled both disks (2 disk fs raid1) and I'm trying to rescue as
> much data as I can.
>
> The question is, why suddenly when I removed the snapshots and
> (someone else removed) the subvolume, there is such a great gap in
> generations of FS (over 200 generations missing) and the most recent
> generation that actually can me touched by btrfs restore is over a
> month old.
>
> How to over come that ?

Well it depends on how long it was from the time of the snapshots
being deleted to the time the file system was unmounted. If it wasn't
that long it might be possible to find a root from 'btrfs insp-in
dump-s -fa <dev>' (or btrfs-show-super with older progs) to see if you
can use any of the backup roots. Once so much time goes by, the no
longer used metadata for generations has their roots deleted and all
of the blocks used for both metadata and data are subject to being
overwritten. So my expectation is that there's too much time between
delete and umount, so there's nothing in the current file system that
points to the old generations.

It might be the metadata and data still exist. It's not entirely a
shot in the dark to find it.

First, try to find the oldest chunk tree you can with btrfs-show-super
-fa (btrfs insp dump-s -fa) and look in the backup roots list for the
chunk tree:

backup_roots[4]:
    backup 0:
        backup_tree_root:    21037056    gen: 7    level: 0
        backup_chunk_root:    147456    gen: 6    level: 0
        backup_extent_root:    21053440    gen: 7    level: 0
        backup_fs_root:        4194304    gen: 4    level: 0
        backup_dev_root:    20987904    gen: 6    level: 0
        backup_csum_root:    21069824    gen: 7    level: 0
        backup_total_bytes:    268435456000
        backup_bytes_used:    393216
        backup_num_devices:    1

    backup 1:
        backup_tree_root:    21086208    gen: 8    level: 0
        backup_chunk_root:    147456    gen: 6    level: 0
        backup_extent_root:    21102592    gen: 8    level: 0
        backup_fs_root:        4194304    gen: 4    level: 0
        backup_dev_root:    20987904    gen: 6    level: 0
        backup_csum_root:    21118976    gen: 8    level: 0
        backup_total_bytes:    268435456000
        backup_bytes_used:    393216
        backup_num_devices:    1

    backup 2:
        backup_tree_root:    21069824    gen: 9    level: 0
        backup_chunk_root:    147456    gen: 6    level: 0
        backup_extent_root:    21053440    gen: 9    level: 0
        backup_fs_root:        21004288    gen: 9    level: 0
        backup_dev_root:    21135360    gen: 9    level: 0
        backup_csum_root:    21037056    gen: 9    level: 0
        backup_total_bytes:    268435456000
        backup_bytes_used:    487424
        backup_num_devices:    1

    backup 3:
        backup_tree_root:    21151744    gen: 10    level: 0
        backup_chunk_root:    147456    gen: 6    level: 0
        backup_extent_root:    21168128    gen: 10    level: 0
        backup_fs_root:        21004288    gen: 9    level: 0
        backup_dev_root:    21135360    gen: 9    level: 0
        backup_csum_root:    21184512    gen: 10    level: 0
        backup_total_bytes:    268435456000
        backup_bytes_used:    487424
        backup_num_devices:    1

IN this case, all of the chunk roots are the same generation - so it's
no help really.

Second, list the chunk tree using either -t 3 for the current one, or
you can plug in the bytenr for an older backup chunk root if
available.

[root@f25h ~]# btrfs-debug-tree -t 3 /dev/mapper/vg-test2
btrfs-progs v4.8.5
chunk tree
leaf 147456 items 5 free space 15740 generation 6 owner 3
fs uuid 6cfaa40b-92f0-44e8-a06c-7e39d38e6446
chunk uuid a971b4ef-64fe-496d-adff-9f96734a2949
    item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
        devid 1 total_bytes 268435456000 bytes_used 1094713344
        io_align 4096 io_width 4096 sector_size 4096 type 0
        generation 0 start_offset 0 dev_group 0
        seek_speed 0 bandwidth 0
        uuid 75573b53-f192-404f-b5f4-21f61feed32d
        fsid 6cfaa40b-92f0-44e8-a06c-7e39d38e6446
    item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 16105 itemsize 80
        length 4194304 owner 2 stripe_len 65536 type SYSTEM
        io_align 4096 io_width 4096 sector_size 4096
        num_stripes 1 sub_stripes 0
            stripe 0 devid 1 offset 0
            dev_uuid 75573b53-f192-404f-b5f4-21f61feed32d
    item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 16025 itemsize 80
        length 8388608 owner 2 stripe_len 65536 type METADATA
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 1 sub_stripes 0
            stripe 0 devid 1 offset 4194304
            dev_uuid 75573b53-f192-404f-b5f4-21f61feed32d
    item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 15945 itemsize 80
        length 8388608 owner 2 stripe_len 65536 type DATA
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 1 sub_stripes 0
            stripe 0 devid 1 offset 12582912
            dev_uuid 75573b53-f192-404f-b5f4-21f61feed32d
    item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15865 itemsize 80
        length 1073741824 owner 2 stripe_len 65536 type METADATA
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 1 sub_stripes 1
            stripe 0 devid 1 offset 20971520
            dev_uuid 75573b53-f192-404f-b5f4-21f61feed32d
total bytes 268435456000
bytes used 487424
uuid 6cfaa40b-92f0-44e8-a06c-7e39d38e6446


So in this example, it's item 2 and item 4 (type METADATA). What you
care about is the offset and the length for each of them. Any
reference for your data is most likely in these areas (unless so many
snapshots were deleted that it also resulted in a metadata chunk being
deleted in which case it's going to take a lot longer to find it).

You'll need to search those blocks (these are bytes not sectors so you
have to convert them) and you'll have to search for leaves that
contains the generation you're after. This is really tedious to do
manually, you'll want to automate it by writing some code but honestly
I can't help with that, maybe someone else on the list has an idea.
But basically what you're looking for is something that does what
btrfs-debug-tree does, but will just read the entire metadata chunks
you point it to, rather than it following only the valid active tree.
You want every leaf, even old deleted ones, to be turned into some
kind of human readable output like what btrfs-debug-tree gives.

Ideally you'd find an old tree root that has the generation you want.
This is a tree root


[root@f25h ~]# btrfs-debug-tree -b 21151744 /dev/mapper/vg-test2
btrfs-progs v4.8.5
leaf 21151744 items 13 free space 12844 generation 10 owner 1
fs uuid 6cfaa40b-92f0-44e8-a06c-7e39d38e6446
chunk uuid a971b4ef-64fe-496d-adff-9f96734a2949
    item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
        generation 10 root_dirid 0 bytenr 21168128 level 0 refs 1
        lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
        uuid 00000000-0000-0000-0000-000000000000
        drop key (0 UNKNOWN.0 0) level 0
    item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
        generation 9 root_dirid 0 bytenr 21135360 level 0 refs 1
        lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
        uuid 00000000-0000-0000-0000-000000000000
        drop key (0 UNKNOWN.0 0) level 0
    item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
        inode ref index 0 namelen 7 name: default
    item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
        generation 9 root_dirid 256 bytenr 21004288 level 0 refs 1
        lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
        uuid 00000000-0000-0000-0000-000000000000
        ctransid 9 otransid 0 stransid 0 rtransid 0
        drop key (0 UNKNOWN.0 0) level 0
    item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14789 itemsize 160
        inode generation 3 transid 0 size 0 nbytes 16384
        block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
        sequence 0 flags 0x0(none)
        atime 1481503752.0 (2016-12-11 17:49:12)
        ctime 1481503752.0 (2016-12-11 17:49:12)
        mtime 1481503752.0 (2016-12-11 17:49:12)
        otime 1481503752.0 (2016-12-11 17:49:12)
    item 5 key (ROOT_TREE_DIR INODE_REF 6) itemoff 14777 itemsize 12
        inode ref index 0 namelen 2 name: ..
    item 6 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 14740 itemsize 37
        location key (FS_TREE ROOT_ITEM -1) type DIR
        transid 0 data_len 0 name_len 7
        name: default
    item 7 key (CSUM_TREE ROOT_ITEM 0) itemoff 14301 itemsize 439
        generation 10 root_dirid 0 bytenr 21184512 level 0 refs 1
        lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
        uuid 00000000-0000-0000-0000-000000000000
        drop key (0 UNKNOWN.0 0) level 0
    item 8 key (UUID_TREE ROOT_ITEM 0) itemoff 13862 itemsize 439
        generation 7 root_dirid 0 bytenr 21020672 level 0 refs 1
        lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
        uuid 86c465ab-e661-d34e-a3e0-bc7534db8b92
        drop key (0 UNKNOWN.0 0) level 0
    item 9 key (256 INODE_ITEM 0) itemoff 13702 itemsize 160
        inode generation 10 transid 10 size 262144 nbytes 1310720
        block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
        sequence 27 flags 0x5(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
        atime 0.0 (1969-12-31 17:00:00)
        ctime 1481504170.772155917 (2016-12-11 17:56:10)
        mtime 0.0 (1969-12-31 17:00:00)
        otime 0.0 (1969-12-31 17:00:00)
    item 10 key (256 EXTENT_DATA 0) itemoff 13649 itemsize 53
        generation 10 type 1 (regular)
        extent data disk byte 13369344 nr 262144
        extent data offset 0 nr 262144 ram 262144
        extent compression 0 (none)
    item 11 key (FREE_SPACE UNTYPED 20971520) itemoff 13608 itemsize 41
        location key (256 INODE_ITEM 0)
        cache generation 10 entries 5 bitmaps 0
    item 12 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 13169 itemsize 439
        generation 4 root_dirid 256 bytenr 4358144 level 0 refs 1
        lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
        uuid 00000000-0000-0000-0000-000000000000
        drop key (0 UNKNOWN.0 0) level 0


IF the whole thing is intact like this one, then you can use btrfs
restore -t to point to this tree root and it'll use it even though
it's deleted.

Anyway, it's a lot of work. But it's no more work than what Btrfs
developers are doing every day.



-- 
Chris Murphy
