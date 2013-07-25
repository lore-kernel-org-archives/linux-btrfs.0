Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab3GYLWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 07:22:49 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6PBMlhd027098
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 19:22:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 0/6] reduce the lock contention when reading pages
Date: Thu, 25 Jul 2013 19:22:31 +0800
Message-Id: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying this patchset, we had to do extent state operation by
the block size when reading pages because we need cache the checksum value
of each block into the extent state, it was inefficient and increased the lock
contenttion of extent state. Besides that, the acquisition of the extent map
during the page read was also inefficient, we searched it every time we dealt
with a page.

In fact, if we don't cache the checksum into the extent state, we can batch
those extent state operation to reduce the time of the operations and the lock
contention. Patch 3-5 do this work.

Besides that, the acquisition of the extent map during the page read was also
inefficient, we searched it every time we dealt with a page. In fact, it is
very likely that the extent map objects are the same one. So we can cache
the extent map object to reduce its search time and the lock contention
of the extent map tree. Patch 6 does this work.

I tested this patchset by sysbench on my SSD, it makes the performance of
the random read be faster by ~7%. The lock contention is reduced by ~97%.

Miao Xie (6):
  Btrfs: remove unnecessary argument of bio_readpage_error()
  Btrfs: add branch prediction hints in the read page end IO function
  Btrfs: don't cache the csum value into the extent state tree
  Btrfs: batch the extent state operation in the end io handle of the read page
  Btrfs: batch the extent state operation when reading pages
  Btrfs: cache the extent map struct when reading several pages

 fs/btrfs/btrfs_inode.h |  21 +++
 fs/btrfs/ctree.h       |   4 +-
 fs/btrfs/disk-io.c     |   5 +-
 fs/btrfs/extent_io.c   | 392 ++++++++++++++++++++++++++++++-------------------
 fs/btrfs/extent_io.h   |  10 +-
 fs/btrfs/file-item.c   |  81 ++++++----
 fs/btrfs/inode.c       |  85 +++++------
 fs/btrfs/volumes.h     |   7 +
 8 files changed, 370 insertions(+), 235 deletions(-)

-- 
1.8.1.4

