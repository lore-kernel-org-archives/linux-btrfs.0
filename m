Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51513 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751149AbaKZCpZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 21:45:25 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQ2j7kC012896
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 10:45:07 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: convert: fix unable to rollback case with removed empty block groups
Date: Wed, 26 Nov 2014 10:43:41 +0800
Message-ID: <1416969821-2729-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1416969821-2729-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1416969821-2729-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run fstests: btrfs/012 will fail with message:
	unable to do rollback

It is because the rollback function checks sequentially each piece of space
to map to a certain block group. If some piece doesn't, rollback refuses to continue.

After kernel commit:
	commit 47ab2a6c689913db23ccae38349714edf8365e0a
	Btrfs: remove empty block groups automatically

Empty block groups are removed, so there are possible gaps:

	|--block group 1--|	|--block group 2--|
			     ^
			     |
			    gap

So the piece of space of the gap belongs to a removed empty block group,
and rollback should detect this case, and feel free to continue.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-convert.c | 13 +++++++++++--
 volumes.c       |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a544fc6..504c7b3 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2368,8 +2368,17 @@ static int may_rollback(struct btrfs_root *root)
 	while (1) {
 		ret = btrfs_map_block(&info->mapping_tree, WRITE, bytenr,
 				      &length, &multi, 0, NULL);
-		if (ret)
+		if (ret) {
+			if (ret == -ENOENT) {
+				/* removed block group at the tail */
+				if (length == (u64)-1)
+					break;
+
+				/* removed block group in the middle */
+				goto next;
+			}
 			goto fail;
+		}
 
 		num_stripes = multi->num_stripes;
 		physical = multi->stripes[0].physical;
@@ -2377,7 +2386,7 @@ static int may_rollback(struct btrfs_root *root)
 
 		if (num_stripes != 1 || physical != bytenr)
 			goto fail;
-
+next:
 		bytenr += length;
 		if (bytenr >= total_bytes)
 			break;
diff --git a/volumes.c b/volumes.c
index a1fd162..a988cdb 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1318,10 +1318,12 @@ again:
 	ce = search_cache_extent(&map_tree->cache_tree, logical);
 	if (!ce) {
 		kfree(multi);
+		*length = (u64)-1;
 		return -ENOENT;
 	}
 	if (ce->start > logical) {
 		kfree(multi);
+		*length = ce->start - logical;
 		return -ENOENT;
 	}
 
-- 
1.8.1.4

