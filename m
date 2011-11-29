From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at
 /build/buildd/linux-3.2.0/fs/btrfs/extent-tree.c:4816!
Date: Tue, 29 Nov 2011 10:12:56 -0500
Message-ID: <20111129151256.GJ24338@shiny>
References: <4ED437CE.3060909@kittilsen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Karl Mardoff Kittilsen <karl@kittilsen.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED437CE.3060909@kittilsen.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 02:39:26AM +0100, Karl Mardoff Kittilsen wrote:
> Hi!
> 
> Sending a mail on this issue, as advised on IRC.
> 
> My /home file system fails to mount and the kernel seem to freeze
> and I need to do the Alt+SysRq RSNEIUB routine to boot it safely.
> The corruption happened on a 3.2-rc<something> kernel and Ubuntu
> 11.10, but I am now running on Ubuntu 12.04 with the 3.2.0-2-generic
> kernel to see if that helped, it did not.
> btrfsck from the latest btrfs-tools returns:
> 
> karl@karl-precise:~/git/btrfs-progs$ sudo ./btrfsck /dev/md0
> ref mismatch on [2176962560 8192] extent item 480, found 1
> Incorrect local backref count on 2176970752 root 5 owner 2101705
> offset 368640 found 1 wanted 3925868545
> backpointer mismatch on [2176970752 4096]

So the crashes below were because we tried to free one of these extents.
You have two extents whose reference counts are way off.

Unfortunately this is stored on disk, so different kernels aren't going
to fix it (yet).  One of the extents is in a file with inode number
2101705, and the other is in a btree block (2176962560).

I'll be able to fix this soon, but we can also make a patch that changes
those BUG_ONs to just deal with the mismatch.  The worst case here would
be leaking those two extents, about 12K of data.

-chris
