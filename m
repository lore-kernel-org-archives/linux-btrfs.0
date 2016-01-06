Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21268 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbcAFLCU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 06:02:20 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 76E9D41890EC
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2016 19:02:01 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs: delete no_used argument in btrfs_copy_from_user
Date: Wed, 6 Jan 2016 19:00:18 +0800
Message-ID: <795abda08582e64b59eecd050c96a2f3639767ec.1452078012.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
References: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

size_t write_bytes is not necessary for btrfs_copy_from_user(),
delete it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/file.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 11fd981..e4f287c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -406,8 +406,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 /* simple helper to fault in pages and copy.  This should go away
  * and be replaced with calls into generic code.
  */
-static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
-					 size_t write_bytes,
+static noinline int btrfs_copy_from_user(loff_t pos, size_t write_bytes,
 					 struct page **prepared_pages,
 					 struct iov_iter *i)
 {
@@ -1575,8 +1574,7 @@ again:
 			ret = 0;
 		}
 
-		copied = btrfs_copy_from_user(pos, num_pages,
-					   write_bytes, pages, i);
+		copied = btrfs_copy_from_user(pos, write_bytes, pages, i);
 
 		/*
 		 * if we have trouble faulting in the pages, fall
-- 
1.8.5.1



