Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65449 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726688AbeHAFQE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D1B674B6ADE8
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:37 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/7] Some unused parameter cleanup
Date: Wed, 1 Aug 2018 11:32:24 +0800
Message-ID: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

PATCH 1-2 remove all unused fs_info parameter from delayed-inode.c
PATCH 3-5 remove all unused fs_info parameter from root-tree.c
PATCH 6-7 some cleanup for btrfs_unlink_subvol

Lu Fengqi (7):
  btrfs: Remove fs_info from btrfs_insert_delayed_dir_index
  btrfs: Remove fs_info from btrfs_delete_delayed_dir_index
  btrfs: Remove fs_info from btrfs_del_root
  btrfs: Remove fs_info from btrfs_del_root_ref
  btrfs: Remove fs_info from btrfs_add_root_ref
  btrfs: Remove root parameter from btrfs_unlink_subvol
  btrfs: Remove redundant btrfs_release_path from btrfs_unlink_subvol

 fs/btrfs/ctree.h           | 16 +++++++--------
 fs/btrfs/delayed-inode.c   | 10 ++++------
 fs/btrfs/delayed-inode.h   |  2 --
 fs/btrfs/dir-item.c        |  4 ++--
 fs/btrfs/extent-tree.c     |  2 +-
 fs/btrfs/free-space-tree.c |  2 +-
 fs/btrfs/inode.c           | 41 +++++++++++++++-----------------------
 fs/btrfs/ioctl.c           |  3 +--
 fs/btrfs/qgroup.c          |  2 +-
 fs/btrfs/root-tree.c       | 22 ++++++++++----------
 fs/btrfs/transaction.c     |  2 +-
 11 files changed, 44 insertions(+), 62 deletions(-)

-- 
2.18.0



