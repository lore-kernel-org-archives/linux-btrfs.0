From: Tejun Heo <tj@kernel.org>
Subject: [RFC PATCHSET] btrfs: Simplify extent_buffer locking
Date: Thu, 24 Mar 2011 18:43:05 +0100
Message-ID: <1300988588-13986-1-git-send-email-tj@kernel.org>
To: chris.mason@oracle.com, peterz@infradead.org, mingo@redhat.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is split patchset of the RFC patches[1] to simplify btrfs
locking and contains the following three patches.

 0001-btrfs-Cleanup-extent_buffer-lockdep-code.patch
 0002-btrfs-Use-separate-lockdep-class-keys-for-different-.patch
 0003-btrfs-Simplify-extent_buffer-locking.patch

For more info, please read the patch description on 0003 and the
following two threads.

 http://thread.gmane.org/gmane.comp.file-systems.btrfs/9658
 http://thread.gmane.org/gmane.linux.kernel/1116910

0001 and 0002 improve lockdep key assigning such that extent_buffer
locks get different keys depending on the type (objectid) of the
btrfs_root they belong to.  I think this should provide enough lockdep
annotation resolution to avoid spurious triggering but after applying
this patchset, btrfs triggers several different locking dependency
warnings.

I've followed a couple of them and, to my untrained eyes, they seem to
indicate genuine locking order problems in btrfs which were hidden
till now because the custom locking was invisible to lockdep.

Anyways, so, it seems locking fixes or at least lockdep annotation
improvements will be needed.  Chris, how do you want to proceed?

Thanks.

 fs/btrfs/Makefile      |    2 
 fs/btrfs/ctree.c       |   16 +--
 fs/btrfs/disk-io.c     |  105 ++++++++++++++--------
 fs/btrfs/disk-io.h     |   21 ++--
 fs/btrfs/extent-tree.c |    2 
 fs/btrfs/extent_io.c   |    3 
 fs/btrfs/extent_io.h   |   12 --
 fs/btrfs/locking.c     |  233 -------------------------------------------------
 fs/btrfs/locking.h     |   65 +++++++++++--
 fs/btrfs/volumes.c     |    2 
 10 files changed, 154 insertions(+), 307 deletions(-)

--
tejun

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/9658
