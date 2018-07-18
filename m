Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726180AbeGRHWU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:20 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 1640148029E5
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:45:58 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 00/19] qgroup unused parameter cleanup
Date: Wed, 18 Jul 2018 14:45:23 +0800
Message-ID: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction handler can provide fs_info, so we can fetch fs_info or
quota_root(indirectly) from trans. Just remove the redundant parameter
from qgroup functions.

No functional change.

Lu Fengqi (19):
  btrfs: qgroup: Drop quota_root parameter from add_qgroup_relation_item
  btrfs: qgroup: Drop quota_root parameter from del_qgroup_relation_item
  btrfs: qgroup: Drop quota_root parameter from del_qgroup_item
  btrfs: qgroup: Drop root parameter from update_qgroup_limit_item
  btrfs: qgroup: Drop root parameter from update_qgroup_info_item
  btrfs: qgroup: Drop quota_root and fs_info parameters from
    update_qgroup_status_item
  btrfs: qgroup: Drop fs_info parameter from btrfs_add_qgroup_relation
  btrfs: qgroup: Drop fs_info parameter from __del_qgroup_relation
  btrfs: qgroup: Drop fs_info parameter from btrfs_del_qgroup_relation
  btrfs: qgroup: Drop fs_info parameter from btrfs_create_qgroup
  btrfs: qgroup: Drop fs_info parameter from btrfs_remove_qgroup
  btrfs: qgroup: Drop fs_info parameter from btrfs_limit_qgroup
  btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_trace_extent
  btrfs: qgroup: Drop fs_info parameter from
    btrfs_qgroup_trace_leaf_items
  btrfs: qgroup: Drop root parameter from btrfs_qgroup_trace_subtree
  btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_account_extent
  btrfs: qgroup: Drop fs_info parameter from btrfs_run_qgroups
  btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_inherit
  btrfs: qgroup: Drop fs_info parameter from qgroup_rescan_leaf

 fs/btrfs/extent-tree.c        |   4 +-
 fs/btrfs/ioctl.c              |  18 ++--
 fs/btrfs/qgroup.c             | 163 +++++++++++++++++-----------------
 fs/btrfs/qgroup.h             |  40 ++++-----
 fs/btrfs/relocation.c         |   5 +-
 fs/btrfs/tests/qgroup-tests.c |  24 ++---
 fs/btrfs/transaction.c        |   5 +-
 fs/btrfs/tree-log.c           |   2 +-
 8 files changed, 123 insertions(+), 138 deletions(-)

-- 
2.18.0



