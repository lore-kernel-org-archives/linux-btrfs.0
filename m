Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48008 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932648AbcLGVhf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 16:37:35 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/6] btrfs dax IO
Date: Wed,  7 Dec 2016 13:45:04 -0800
Message-Id: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a prelimanary patch set to add dax support for btrfs, with
this we can do normal read/write to dax files and can mmap dax files
to userspace so that applications have the ability to access
persistent memory directly.

Please note that currently this is limited to nocow, i.e. all dax
inodes do not have COW behaviour.

COW:   	    	     	no
mutliple device:	no
clone/reflink:		no
snapshot:		no
compression:		no
checksum:		no

Right now snapshot is disabled while mounting with -odax, but snapshot
can be created without -odax, and writing to a dax file in snapshot
will get -EIO.

Clone/reflink is dealt with as same as snapshot, -EIO will be returned
when writing to shared extents.

This has adopted the latest iomap framework for dax read/write
and dax mmap.

With kernel command option "memmap=", I've had the whole patch set
tested with fstests, except those issues caused by failure of creating
snapshot/reflink and requirement for mutliple device, fstests said OK.

To test it, simply use kernel cmd option "memmap=", mkfs.btrfs and
mount -odax, then you're ready to go run anything upon dax-version
btrfs.

Liu Bo (6):
  Btrfs: add mount option for dax
  Btrfs: set single device limit for dax usecase
  Btrfs: refactor btrfs_file_write_iter
  Btrfs: add DAX support for nocow btrfs
  Btrfs: add mmap_sem to avoid race between page faults and
    truncate/hole_punch
  Btrfs: add tracepoint for btrfs_get_blocks_dax_fault

 fs/btrfs/Kconfig             |   1 +
 fs/btrfs/btrfs_inode.h       |   7 +
 fs/btrfs/ctree.h             |   6 +
 fs/btrfs/file.c              | 342 +++++++++++++++++++-----
 fs/btrfs/inode.c             | 599 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ioctl.c             |  26 +-
 fs/btrfs/super.c             |  47 +++-
 include/trace/events/btrfs.h | 106 ++++++++
 8 files changed, 1048 insertions(+), 86 deletions(-)

-- 
2.5.5

