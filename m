Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f170.google.com ([209.85.214.170]:42608 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbeH1DwX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:52:23 -0400
Received: by mail-pl1-f170.google.com with SMTP id g23-v6so306951plq.9
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:03:29 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>, kernel-team@fb.com
Subject: [RFC PATCH v2 0/6] Btrfs: stop abusing current->journal_info for direct I/O
Date: Mon, 27 Aug 2018 17:03:13 -0700
Message-Id: <cover.1535414064.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This is a different approach from v1 [1] of this series to stop abusing
current->journal_info in Btrfs. This approach unifies everything to use
iocb->private instead of map_bh->b_private. Patches 1 and 5 pass the
iocb to a couple of callbacks which need it. Patches 2 and 3 migrates
the users of b_private to use iocb->private, and patch 4 gets rid of the
b_private handling in the direct I/O code. Patch 6 cleans up Btrfs.

I'm not convinced that this is cleaner that my first approach, but it at
least avoids growing the argument list to do_blockdev_direct_IO(), which
was Al's complaint of v1.

Thanks!

1: https://www.spinics.net/lists/linux-btrfs/msg77859.html

Omar Sandoval (6):
  fs: pass iocb to direct I/O get_block()
  ext4: use iocb->private instead of bh->b_private
  ocfs2: use iocb->private instead of bh->b_private
  fs: stop propagating bh->b_private for direct I/O
  fs: pass iocb to direct I/O submit_io()
  Btrfs: stop abusing current->journal_info in btrfs_direct_IO()

 fs/affs/file.c      |  9 ++++++-
 fs/btrfs/inode.c    | 36 +++++++------------------
 fs/direct-io.c      | 23 +++++++---------
 fs/ext2/inode.c     |  9 ++++++-
 fs/ext4/ext4.h      |  2 --
 fs/ext4/inode.c     | 40 ++++++++++++++++------------
 fs/f2fs/data.c      |  5 ++--
 fs/fat/inode.c      |  9 ++++++-
 fs/gfs2/aops.c      |  5 ++--
 fs/hfs/inode.c      |  9 ++++++-
 fs/hfsplus/inode.c  |  9 ++++++-
 fs/jfs/inode.c      |  9 ++++++-
 fs/nilfs2/inode.c   |  9 ++++++-
 fs/ocfs2/aops.c     | 39 ++++++++++++++-------------
 fs/ocfs2/aops.h     | 64 ++++++++++++++++++++++++++++++---------------
 fs/reiserfs/inode.c |  4 +--
 fs/udf/inode.c      |  9 ++++++-
 include/linux/fs.h  | 17 ++++++------
 18 files changed, 187 insertions(+), 120 deletions(-)

-- 
2.18.0
