Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43036 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752583AbbBZDVg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 22:21:36 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1Q3KgrV027281
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2015 11:20:42 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/1] btrfs: Fix NO_SPACE bug caused by delayed-iput
Date: Thu, 26 Feb 2015 11:20:22 +0800
Message-ID: <1424920823-12176-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

It is the last patch to fix following write fail case:
while true; do
  write a file to 75% fs size
  delete above file
  sync or sleep
done

Above issue is caused by several reason, and fixed in following patch
respectively:
 Btrfs: fix find_free_dev_extent() malfunction in case device tree has hole
  from Forrest Liu <forrestl@synology.com>
 btrfs: Fix out-of-space bug
  merged into v4.0-rc1
 btrfs: fix condition of commit transaction
 btrfs: Fix tail space processing in find_free_dev_extent()
 btrfs: Adjust commit-transaction condition to avoid NO_SPACE more
 btrfs: Fix NO_SPACE bug caused by delayed-iput
  this patch

These patchs reduced fail-rate step by step, from 50 fails in 20 * 200
loops, to 0 fails now.
And now we can add a test case to xfstests for above action.

Zhao Lei (1):
  btrfs: Fix NO_SPACE bug caused by delayed-iput

 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/disk-io.c     | 3 ++-
 fs/btrfs/inode.c       | 4 ++++
 fs/btrfs/transaction.c | 6 +++++-
 4 files changed, 12 insertions(+), 2 deletions(-)

-- 
1.8.5.1

