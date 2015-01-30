Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760099AbbA3JXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 04:23:03 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0U9MFpk028831
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2015 17:22:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v5 0/9] btrfs: Fix freeze/sysfs deadlock in better method.
Date: Fri, 30 Jan 2015 17:20:45 +0800
Message-ID: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset to solve the previous found freeze/sysfs deadlock.

Unlike previous pending_changes, which uses transaction commits to
ensure mount option doesn't change during transaction.
This idea is great in concept, but will introduce extra and somewhat
duplicated ro/freeze check, and the original synchronized behavior is
also changed.

[Per-transaction mount option]
This patch use the RCU-like concept, which will copy the mount_opt from
fs_info into btrfs_transaction, and each btrfs_test_opt() for specific
mount option bit(SPACE_CACHE/INODE_MAP_CACHE) should be changed to
btrfs_test_trans_opt().
So mount option during transaction won't be changed, and also, no extra
read_only or freeze check is needed, the commit routine is also
untouched.

[Use VFS protect for sysfs change]
The 6th patch will introduce a new help function sb_want_write() to
claim write permission to a superblock.
With this, we are able to do write protection like mnt_want_write() but
only needs to ensure that the superblock is writeable.
This also keeps the same synchronized behavior using ioctl, which will
block on frozen fs until it is unfrozen.

Changelog:
v1:
   Only use cheap freeze check to avoid deadlock.
v2:
   Fix the never changed pending_changes bug and handle transaction in
   btrfs_freeze()
   Revert sysfs only functions.
v3:
   Add atomic mount option change and per-trans mount option.
   Revert all pending changes functions.
v4:
   Add mnt_want_write() in sysfs handler.
v5:
   Change VFS helper name to sb_want_write() and sb_drop_write().
   Fix a free-n-use bug where sysfs can start a transaction but
   transaction thread is freed before btrfs sysfs interfaces.

Qu Wenruo (9):
  Revert "btrfs: add support for processing pending changes" related    
    commits
  btrfs: Make btrfs_parse_options() parse mount option in a atomic way
  btrfs: Introduce per-transaction mount_opt to keep mount option    
    consistent during transaction.
  btrfs: Use btrfs_test_trans_opt() to handle SPACE_CACHE if it's under 
       transaction protect.
  btrfs: Use btrfs_test_trans_opt() to handle INODE_CACHE if it's under 
       transaction protect.
  vfs: Add sb_want_write() function to get vfsmount from a given sb.
  btrfs: Move btrfs_sysfs_remove_one(fs_info) before transcation thread 
       cleanup.
  btrfs: Use sb_want_write() to protect label change.
  btrfs: Use sb_want_write() to protect sysfs feature change.

 fs/btrfs/ctree.h            |  64 +++-----------------
 fs/btrfs/disk-io.c          |  14 ++---
 fs/btrfs/extent-tree.c      |   2 +-
 fs/btrfs/free-space-cache.c |   2 +-
 fs/btrfs/inode-map.c        |   5 +-
 fs/btrfs/super.c            | 139 ++++++++++++++++++++------------------------
 fs/btrfs/sysfs.c            |  56 ++++++++++++------
 fs/btrfs/transaction.c      |  43 ++------------
 fs/btrfs/transaction.h      |   6 +-
 fs/namespace.c              |  36 ++++++++++++
 include/linux/mount.h       |   2 +
 11 files changed, 169 insertions(+), 200 deletions(-)

-- 
2.2.2

