Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43019 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753422AbaFSClQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 22:41:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J2fDt9024051
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:41:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/7] random bugfixes
Date: Thu, 19 Jun 2014 10:42:48 +0800
Message-ID: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a random bugfix patchset. patch 0001, 0005, 0006, 0007 is new patch,
patch 0002 is the third version of broken free space cache fix patch,
patch 0003, 0004 is old ones which are not merged.

We can pull this patchset from the URL

  https://github.com/miaoxie/linux-btrfs.git for-Chris

Thanks
Miao
---
Miao Xie (5):
  Btrfs: make free space cache write out functions more readable
  Btrfs: fix broken free space cache after the system crashed
  Btrfs: use bio_endio_nodec instead of open code
  Btrfs: fix deadlock when mounting a degraded fs
  Btrfs: fix wrong error handle when the device is missing or is not writeable

Qu Wenruo (1):
  btrfs: Skip scrubbing removed chunks to avoid -ENOENT.

Wang Shilong (1):
  Btrfs: fix NULL pointer crash when running balance and scrub concurrently

 fs/btrfs/ctree.h            |  13 ++-
 fs/btrfs/extent-tree.c      | 143 ++++++++++++++++++++++++++-------
 fs/btrfs/extent_map.c       |   2 +
 fs/btrfs/extent_map.h       |   1 +
 fs/btrfs/free-space-cache.c | 192 +++++++++++++++++++++++++++++---------------
 fs/btrfs/inode.c            |  41 +++++++---
 fs/btrfs/scrub.c            |  19 +++--
 fs/btrfs/volumes.c          |  36 +++++----
 fs/btrfs/volumes.h          |   3 +
 9 files changed, 313 insertions(+), 137 deletions(-)

-- 
1.9.3

