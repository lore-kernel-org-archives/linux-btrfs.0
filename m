Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4549 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751752AbbDIEgV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 00:36:21 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t394ZBtm019912
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Apr 2015 12:35:11 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/9] btrfs: Fix no_space on dd and rm loop
Date: Thu, 9 Apr 2015 12:34:35 +0800
Message-ID: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

This is v2 of resend-fix-no-space.

Most of them are send in single patch, I resend them in patchset
to make it easy to access.

Notice that "Btrfs: fix find_free_dev_extent() malfunction in case
device tree has hole" from Forrest Liu in:
  https://patchwork.kernel.org/patch/5800231/
is also need to fix all known no_space bug.

Changelog v1->v2:
1: Rebased on top of v4.0-rc7
2: Fixed a lock problem reported by:
   'Tsutomu Itoh' <t-itoh@jp.fujitsu.com>
3: Add Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
   to [PATCH 2/9] btrfs:

Tested by busy dd and rm loop script in 2000 times.
I'll add xfstests for this case later.

This is available at fix_no_space branch on my tree:
  git://github.com/zhaoleidd/btrfs.git
It is also included in integration-for-chris branch in above tree.

Thanks
Zhaolei

Zhao Lei (9):
  btrfs: fix condition of commit transaction
  btrfs: Fix tail space processing in find_free_dev_extent()
  btrfs: Adjust commit-transaction condition to avoid NO_SPACE more
  btrfs: Set relative data on clear btrfs_block_group_cache->pinned
  btrfs: add WARN_ON() to check is space_info op current
  btrfs: Fix NO_SPACE bug caused by delayed-iput
  btrfs: Support busy loop of write and delete
  btrfs: wait for delayed iputs on no space
  btrfs: cleanup unused alloc_chunk varible

 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     |  3 ++-
 fs/btrfs/extent-tree.c | 66 +++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/inode.c       |  4 +++
 fs/btrfs/volumes.c     | 24 +++++++++---------
 5 files changed, 72 insertions(+), 26 deletions(-)

-- 
1.8.5.1

