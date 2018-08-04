Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4400 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbeHDPLv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 11:11:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id E84C34B6ADE4
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 21:11:03 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] some trivial cleanup about btrfs_delete_subvolume
Date: Sat, 4 Aug 2018 21:10:52 +0800
Message-ID: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During I am working on the online undelete of subvolume, I found something
in the btrfs_delete_subvolume need to be clean or fix. So, the patchset
is mostly about the callee or itself of btrfs_delete_subvolume.

Patch 1,3-5 some trivial cleanup
Patch 2 fix a problem about qgroup_free_meta_prealloc() in
btrfs_subvolume_reserve_metadata()

Lu Fengqi (5):
  btrfs: simplify the send_in_progress check in btrfs_delete_subvolume()
  btrfs: use a separate variable to store the num_bytes of the
    qgroup_reserve
  btrfs: switch update_size to bool in both of btrfs_block_rsv_migrate
    and btrfs_rsv_add_bytes
  btrfs: remove a useless return statement in btrfs_block_rsv_add
  btrfs: Remove root parameter from btrfs_insert_dir_item

 fs/btrfs/ctree.h         |  5 ++---
 fs/btrfs/delayed-inode.c |  4 ++--
 fs/btrfs/dir-item.c      |  8 ++++----
 fs/btrfs/extent-tree.c   | 36 ++++++++++++++++--------------------
 fs/btrfs/file.c          |  4 ++--
 fs/btrfs/inode.c         | 20 +++++++++-----------
 fs/btrfs/ioctl.c         |  3 +--
 fs/btrfs/relocation.c    |  2 +-
 fs/btrfs/transaction.c   |  7 +++----
 9 files changed, 40 insertions(+), 49 deletions(-)

-- 
2.18.0



