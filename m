Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44451 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbaKUT7p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 14:59:45 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 0/4] add support for a lazytime mount option
Date: Fri, 21 Nov 2014 14:59:20 -0500
Message-Id: <1416599964-21892-1-git-send-email-tytso@mit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an updated version of what had originally been an
ext4-specific patch which significantly improves performance by lazily
writing timestamp updates (and in particular, mtime updates) to disk.
The in-memory timestamps are always correct, but they are only written
to disk when required for correctness.

This provides a huge performance boost for ext4 due to how it handles
journalling, but it's valuable for all file systems running on flash
storage or drive-managed SMR disks by reducing the metadata write
load.  So upon request, I've moved the functionality to the VFS layer.
Once the /sbin/mount program adds support for MS_LAZYTIME, all file
systems should be able to benefit from this optimization.

There is still an ext4-specific optimization, which may be applicable
for other file systems which store more than one inode in a block, but
it will require file system specific code.  It is purely optional,
however.

Please note the changes to update_time() and the new write_time() inode
operations functions, which impact btrfs and xfs.  The changes are
fairly simple, but I would appreciate confirmation from the btrfs and
xfs teams that I got things right.   Thanks!!

Theodore Ts'o (4):
  fs: split update_time() into update_time() and write_time()
  vfs: add support for a lazytime mount option
  vfs: don't let the dirty time inodes get more than a day stale
  ext4: add support for a lazytime mount option

 fs/btrfs/inode.c        | 10 ++++++
 fs/ext4/inode.c         | 46 +++++++++++++++++++++++++-
 fs/ext4/super.c         |  9 +++++
 fs/fs-writeback.c       | 39 +++++++++++++++++++++-
 fs/inode.c              | 88 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/proc_namespace.c     |  1 +
 fs/sync.c               |  7 ++++
 fs/xfs/xfs_iops.c       | 39 +++++++++-------------
 include/linux/fs.h      |  5 +++
 include/uapi/linux/fs.h |  1 +
 10 files changed, 209 insertions(+), 36 deletions(-)

-- 
2.1.0

