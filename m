Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53244 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754777AbbAWJdr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 04:33:47 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <miaoxie@huawei.com>
Subject: [PATCH RFC v3 0/5] mount options consistent enhancement
Date: Fri, 23 Jan 2015 17:31:40 +0800
Message-ID: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset to solve the previous found deadlock and enhance mount options
consistence.

Unlike previous pending_changes, which uses transaction commits to
ensure mount option doesn't change during transaction.
This patch use the RCU-like concept, which will copy the mount_opt from
fs_info into btrfs_transaction, and each btrfs_test_opt() for specific
mount option bit(SPACE_CACHE/INODE_MAP_CACHE) should be changed to
btrfs_test_trans_opt().
So mount option during transaction won't be changed, and also, no extra
read_only or freeze check is needed, the commit routine is also
untouched.

Qu Wenruo (5):
  Revert "btrfs: add support for processing pending changes" related    
    commits
  btrfs: Make btrfs_parse_options() parse mount option in a atomic way
  btrfs: Introduce per-transaction mount_opt to keep mount option    
    consistent during transaction.
  btrfs: Use btrfs_test_trans_opt() to handle SPACE_CACHE if it's under 
       transaction protect.
  btrfs: Use btrfs_test_trans_opt() to handle INODE_CACHE if it's under 
       transaction protect.

 fs/btrfs/ctree.h            |  64 +++-------------------
 fs/btrfs/disk-io.c          |   6 ---
 fs/btrfs/extent-tree.c      |   2 +-
 fs/btrfs/free-space-cache.c |   2 +-
 fs/btrfs/inode-map.c        |   5 +-
 fs/btrfs/super.c            | 129 ++++++++++++++++++++++----------------------
 fs/btrfs/sysfs.c            |  34 +++++++-----
 fs/btrfs/transaction.c      |  43 ++-------------
 fs/btrfs/transaction.h      |   6 ++-
 9 files changed, 107 insertions(+), 184 deletions(-)

-- 
2.2.2

