Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:36550 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755092AbdGVLPI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 07:15:08 -0400
Subject: Re: How to detect "orphaned" subvolume attachment point in snapshot?
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <9d5e5337-8b67-cce0-f85b-431639afaf48@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <53a80f27-52f1-a132-2afe-863fb3d16474@mendix.com>
Date: Sat, 22 Jul 2017 13:15:06 +0200
MIME-Version: 1.0
In-Reply-To: <9d5e5337-8b67-cce0-f85b-431639afaf48@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/22/2017 09:58 AM, Andrei Borzenkov wrote:
> Here is structure of snapshots in openSUSE; all snapshots of root volume
> are created under /.snapshots subvolume:
> 
> linux-gtrk:/host/home/src/python-btrfs/examples # sudo mount -o
> ro,subvol=/ /dev/sda3 /mnt
> linux-gtrk:/host/home/src/python-btrfs/examples #
> ./show_directory_contents.py /mnt/
> directory /mnt/@ tree 257 inum 256
> inode generation 6 transid 315 size 72 nbytes 0 block_group 0 mode 40755
> nlink 1 uid 0 gid 0 rdev 0 flags 0x0(none)
> inode ref index 0 name utf-8 ..
> ...
> dir item list hash 1921786525 size 1
>     dir item location (258 ROOT_ITEM -1) type DIR name utf-8 .snapshots
> ...
> linux-gtrk:/host/home/src/python-btrfs/examples #
> ./show_directory_contents.py /mnt/@/.snapshots/251/snapshot/
> directory /mnt/@/.snapshots/251/snapshot/ tree 774 inum 256
> inode generation 6 transid 15867 size 164 nbytes 0 block_group 0 mode
> 40755 nlink 1 uid 0 gid 0 rdev 0 flags 0x0(none)
> inode ref index 0 name utf-8 ..
> ...
> dir item list hash 1921786525 size 1
>     dir item location (258 ROOT_ITEM -1) type DIR name utf-8 .snapshots
> ...
> linux-gtrk:/host/home/src/python-btrfs/examples #
> 
> Note that both directory items in /mnt/@ and
> /mnt/@/.snapshots/251/snapshot store the same tree ID for .snapshots
> item - 258. This causes grub2 btrfs driver loop - when it comes to
> /mnt/@/.snapshots/251/snapshot and looks for .snapshots it jumps back to
> /mnt/@/.snapshots tree.
> 
> I see that in Linux kernel somehow distinguishes between both of them; I
> am not sure how it actually does it though.
> 
> What on-disk information should we check to find out "orphaned" snapshot
> directory?

The information is not stored in the subvolume that contains the
"attachment point". So you cannot get the info at that location.

If it was, that would mean that when creating a snapshot, some process
would need to walk the entire directory structure and change all the
locations in the tree that looked like if there was another nested
subvolume placed there before.

In tree 1, the tree of trees, there's information about root 258:

-# btrfs inspect-internal dump-tree -t 1 /dev/[...]/blaat
[...]
item 19 key (258 ROOT_ITEM 0) itemoff 12635 itemsize 439
     root data bytenr 21397504 level 0 dirid 256 refs 1 gen 11 lastsnap 0
    flags 0x0(none)
    uuid d7fe436b-35b5-9b4e-805d-20b9294a55d0
    ctransid 11 otransid 9 stransid 0 rtransid 0
item 20 key (258 ROOT_BACKREF 257) itemoff 12616 itemsize 19
    root backref key dirid 256 sequence 2 name b

I think the ROOT_BACKREF says that the only location where the contents
of the nested subvolume should really be shown is when it's looked at
via the "attachment point" in tree 257, directory 256, index 2 in the
directory with name b.

When looking at it via the VFS, you get a special inode 2 number when
looking at it in a place that does not match the BACKREF again:

-# stat b
  File: b
  Size: 0         	Blocks: 0          IO Block: 4096   directory
Device: 55h/85d	Inode: 2           Links: 1
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2017-07-22 13:08:59.217456707 +0200
Modify: 2017-07-22 13:08:59.217456707 +0200
Change: 2017-07-22 13:08:59.217456707 +0200
 Birth: -

I don't have all structures of the root tree yet in python-btrfs it
seems. Would be nice to create an example script that does a pretty
printed version of tree 1.

-- 
Hans van Kranenburg
