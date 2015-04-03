Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11951 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbbDCMNk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 08:13:40 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t33CCXwn020598
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 20:12:33 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/9] btrfs: Fix no_space on dd and rm loop
Date: Fri, 3 Apr 2015 20:11:55 +0800
Message-ID: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

I resend this patch set with some changes:
1: Move a cleanup patch for btrfs_check_data_free_space() into
2: Rebased on top of v4.0-rc5
3: Fixed a lock problem reported by:
   'Tsutomu Itoh' <t-itoh@jp.fujitsu.com>

Tested by busy dd and rm loop script in 2000 times.
Confirmed having-problem in v4.0-rc5 and no-problem on top of
this patchset.

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
 fs/btrfs/disk-io.c     |  5 ++++-
 fs/btrfs/extent-tree.c | 60 ++++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/transaction.c |  6 ++++-
 fs/btrfs/volumes.c     | 24 +++++++++++---------
 5 files changed, 69 insertions(+), 27 deletions(-)

-- 
1.8.5.1

