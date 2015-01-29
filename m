Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61879 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761822AbbA2CZy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 21:25:54 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0T2PCAd026216
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 10:25:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND v4 0/8] Fix freeze/sysfs deadlock in better method.
Date: Thu, 29 Jan 2015 10:24:33 +0800
Message-ID: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
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
The 6th patch will introduce a new help function get_vfsmount_sb() to
get a vfsmount from a sb, with this vfsmount, we can use vfs level
mnt_want_write() to do a comprehensive protection other than the cheap
ro/freeze check.

Changelog:
v1:
   Only use cheap freeze check to avoid deadlock.
v2:
   Fix the never changed pending_changes bug and handle transaction in
   btrfs_freeze()
v3:
   Add atomic mount option change and per-trans mount option.
v4:
   Add mnt_want_write() in sysfs handler.

Qu Wenruo (8):
  Revert "btrfs: add support for processing pending changes" related    
    commits
  btrfs: Make btrfs_parse_options() parse mount option in a atomic way
  btrfs: Introduce per-transaction mount_opt to keep mount option    
    consistent during transaction.
  btrfs: Use btrfs_test_trans_opt() to handle SPACE_CACHE if it's under 
       transaction protect.
  btrfs: Use btrfs_test_trans_opt() to handle INODE_CACHE if it's under 
       transaction protect.
  vfs: Add get_vfsmount_sb() function to get vfsmount from a given sb.
  btrfs: Use mnt_want_write() to protect label change.
  btrfs: Use mnt_want_write() to protect sysfs feature change.

 fs/btrfs/ctree.h            |  64 +++-------------------
 fs/btrfs/disk-io.c          |   6 ---
 fs/btrfs/extent-tree.c      |   2 +-
 fs/btrfs/free-space-cache.c |   2 +-
 fs/btrfs/inode-map.c        |   5 +-
 fs/btrfs/super.c            | 129 ++++++++++++++++++++++----------------------
 fs/btrfs/sysfs.c            |  73 ++++++++++++++++++-------
 fs/btrfs/transaction.c      |  43 ++-------------
 fs/btrfs/transaction.h      |   6 ++-
 fs/namespace.c              |  25 +++++++++
 include/linux/mount.h       |   1 +
 11 files changed, 167 insertions(+), 189 deletions(-)

-- 
2.2.2

