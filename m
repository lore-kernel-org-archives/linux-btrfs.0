Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:32560 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbeHFEmU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Aug 2018 00:42:20 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E244AAC010A
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 11:35:25 +0900 (JST)
Subject: Re: [PATCH 2/3] btrfs-progs: ins: logical-resolve: Print message when
 path cannot be resolved
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
 <a5545edbef2d2b1800a5ea83d9c14773b5b1fbe7.1532501096.git.misono.tomohiro@jp.fujitsu.com>
 <20180803150653.GA3218@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <00f506d1-f549-a682-1d38-a41ec5633313@jp.fujitsu.com>
Date: Mon, 6 Aug 2018 11:34:55 +0900
MIME-Version: 1.0
In-Reply-To: <20180803150653.GA3218@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/04 0:06, David Sterba wrote:
> On Wed, Jul 25, 2018 at 05:20:17PM +0900, Misono Tomohiro wrote:
>> Since BTRFS_IOC_INO_PATHS requires fd of subvolume,
> 
> Does it? AFAICS btrfs_ioctl_ino_to_path gets root that's the containing
> subvolume of the path given by the user.

It is reverse; it returns all paths of given inode number in given subvolume fd.

> 
>> logical-resolve
>> cannot find the path when mount point is not FS_TREE
>> (because the subvolume path cannot be opened).
> 
> Sorry, I don't understand what's the problem here. What you write sounds
> like there's a reproducer. If yes, please post it.

Sure. If mountpoint is FS_TREE, everything is ok:

$ mkfs.btrfs -fq $DEV
$ mount $DEV /mnt

// create snapshot and hardlink
$ btrfs sub create /mnt/sub
$ dd if=/dev/urandom of=/mnt/sub/file bs=1k count=1000
$ btrfs sub snap /mnt/sub /mnt/snap
$ ln /mnt/sub/file /mnt/sub/file2
$ tree --inodes /mnt
/mnt
|-- [    256]  snap
|   `-- [    257]  file
`-- [    256]  sub
    |-- [    257]  file
    `-- [    257]  file2

inode-resolve returns all paths of given inode number in given subvolume:
(it calls IOC_INO_PATHS)
$ btrfs ins inode-resolve 257 /mnt/sub
/mnt/sub/file
/mnt/sub/file2

$ btrfs ins inode-resolve 257 /mnt/snap
/mnt/snap/file

logical-resolve returns all paths containing given logical address in fs:
(it calls IOC_INO_PATHS after IOC_LOGICAL_INO)
$ filefrag -v /mnt/sub/file
Filesystem type is: 9123683e
File size of /mnt/sub/file is 1024000 (250 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..     249:       3392..      3641:    250:             last,shared,eof
/mnt/sub/file: 1 extent found
$ btrfs ins logical-resolve $((3392*4096)) /mnt
/mnt/snap/file
/mnt/sub/file
/mnt/sub/file2


However, when mountpoint is not FS_TREE, above logical-resolve fails:

$ umount /mnt
$ mount -o subvol=sub $DEV /mnt
$ btrfs ins logical-resolve $((3392*4096)) /mnt
ERROR: cannot access '/mnt/snap': No such file or directory

The reasons are
(1) btrfs_list_path_for_root() returns paths from FS_TREE
(2) subvolume path cannot be opened and therefore cannot call IOC_INO_PATHS

(1) may be fixed for mounted subvolume, but if a subvolume is not accessible at all,
there is no way to call IOC_INO_PATHS.
To solve this, we need to pass arbitrary treeid just like INO_LOOKUP ioctl.

Thanks,
Misono

