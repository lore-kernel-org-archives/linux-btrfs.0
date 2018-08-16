Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:43645 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbeHQAIS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 20:08:18 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/2] address lock contention of btree root
Date: Fri, 17 Aug 2018 05:07:23 +0800
Message-Id: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The lock contention on btree nodes (esp. root node) is apparently a
bottleneck when there're multiple readers and writers concurrently
trying to access them.  Unfortunately this is by design and it's not
easy to fix it unless with some complex changes, however, there is
still some room.

With a stable workload based on fsmark which has 16 threads creating
1,600K files, we could see that a good amount of overhead comes from
switching path between spinning mode and blocking mode in
btrfs_search_slot().

Patch 1 provides more details about the overhead and test results from
fsmark and dbench.
Patch 2 kills leave_spinning due to the behaviour change from patch 1.

Liu Bo (2):
  Btrfs: kill btrfs_clear_path_blocking
  Btrfs: kill leave_spinning

 fs/btrfs/backref.c            |  3 --
 fs/btrfs/ctree.c              | 73 +++++--------------------------------------
 fs/btrfs/ctree.h              |  3 --
 fs/btrfs/delayed-inode.c      |  7 -----
 fs/btrfs/dir-item.c           |  1 -
 fs/btrfs/export.c             |  1 -
 fs/btrfs/extent-tree.c        |  7 -----
 fs/btrfs/extent_io.c          |  1 -
 fs/btrfs/file-item.c          |  4 ---
 fs/btrfs/free-space-tree.c    |  2 --
 fs/btrfs/inode-item.c         |  6 ----
 fs/btrfs/inode.c              |  8 -----
 fs/btrfs/ioctl.c              |  3 --
 fs/btrfs/qgroup.c             |  2 --
 fs/btrfs/super.c              |  2 --
 fs/btrfs/tests/qgroup-tests.c |  4 ---
 16 files changed, 7 insertions(+), 120 deletions(-)

-- 
1.8.3.1
