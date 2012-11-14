Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:44197 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422641Ab2KNVUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 16:20:21 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout1.freenet.de with esmtpa (ID lutz.euler@freenet.de) (port 25) (Exim 4.76 #1)
	id 1TYkNf-0001de-9y
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:20:19 +0100
Received: from localhost ([::1]:47502 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.76 #1)
	id 1TYkNf-000068-5M
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:20:19 +0100
Received: from [195.4.92.16] (port=45582 helo=6.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.76 #1)
	id 1TYkLB-000733-T1
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:17:45 +0100
Received: from p548fd96b.dip.t-dialin.net ([84.143.217.107]:57111 helo=lutz)
	by 6.mx.freenet.de with esmtpsa (ID lutz.euler@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1TYkLB-0002Py-Mr
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:17:45 +0100
Received: from lutz by lutz with local (Exim 4.74)
	(envelope-from <lutz.euler@freenet.de>)
	id 1TYkL5-0001xu-MG
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:17:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20644.2675.653732.24816@localhost.localdomain>
Date: Wed, 14 Nov 2012 22:17:39 +0100
From: lutz.euler@freenet.de (Lutz Euler)
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: really fix trim 0 bytes after a device delete
References: <20644.2272.57892.435731@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 2cac13e41bf5b99ffc426bd28dfd2248df1dfa67, "fix trim 0 bytes after
a device delete", said:
  A user reported a bug of btrfs's trim, that is we will trim 0 bytes
  after a device delete.
The commit didn't attack the root of the problem so did not fix the bug
except for a special case.

For block discard, btrfs_trim_fs directly compares the range passed in
against the filesystem's objectids. The former is bounded by the sum of
the sizes of the devices of the filesystem, the latter is a completely
unrelated set of intervals of 64-bit integers. The bug reported occurred
as the smallest objectid was larger than the sum of the device sizes.
The previous commit only fixes the case where the smallest objectid is
nonzero and the largest objectid less than the sum of the device sizes,
but it would still trim too little if the largest objectid is larger
than that and nothing in the reported situation.

The current mapping between the given range and the objectids is thus
clearly broken, so, to fix the bug and as a first step towards a
complete solution, simply ignore the range parameter's start and length
fields and always trim the whole filesystem. (While this makes it
impossible to only partly trim a filesystem, due to the broken mapping
this often didn't work anyway.)

Reported-by: Lutz Euler <lutz.euler@freenet.de>
Signed-off-by: Lutz Euler <lutz.euler@freenet.de>
---
 fs/btrfs/extent-tree.c |   55 +++++++++++++++++++++--------------------------
 1 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..9c2bb59 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8092,44 +8092,39 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
-	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	int ret = 0;
 
 	/*
-	 * try to trim all FS space, our block group may start from non-zero.
+	 * The range passed in is a subinterval of the interval from 0
+	 * to the sum of the sizes of the devices of the filesystem.
+	 * The objectid's used in the filesystem can span any set of
+	 * subintervals of the interval from 0 to (u64)-1. As there is
+	 * neither a simple nor an agreed upon mapping between these
+	 * two ranges we ignore the range parameter's start and len
+	 * fields and always trim the whole filesystem (that is, only
+	 * the free space in allocated chunks).
 	 */
-	if (range->len == total_bytes)
-		cache = btrfs_lookup_first_block_group(fs_info, range->start);
-	else
-		cache = btrfs_lookup_block_group(fs_info, range->start);
+	cache = btrfs_lookup_first_block_group(fs_info, 0);
 
 	while (cache) {
-		if (cache->key.objectid >= (range->start + range->len)) {
-			btrfs_put_block_group(cache);
-			break;
-		}
-
-		start = max(range->start, cache->key.objectid);
-		end = min(range->start + range->len,
-				cache->key.objectid + cache->key.offset);
+		start = cache->key.objectid;
+		end = cache->key.objectid + cache->key.offset;
 
-		if (end - start >= range->minlen) {
-			if (!block_group_cache_done(cache)) {
-				ret = cache_block_group(cache, NULL, root, 0);
-				if (!ret)
-					wait_block_group_cache_done(cache);
-			}
-			ret = btrfs_trim_block_group(cache,
-						     &group_trimmed,
-						     start,
-						     end,
-						     range->minlen);
+		if (!block_group_cache_done(cache)) {
+			ret = cache_block_group(cache, NULL, root, 0);
+			if (!ret)
+				wait_block_group_cache_done(cache);
+		}
+		ret = btrfs_trim_block_group(cache,
+					     &group_trimmed,
+					     start,
+					     end,
+					     range->minlen);
 
-			trimmed += group_trimmed;
-			if (ret) {
-				btrfs_put_block_group(cache);
-				break;
-			}
+		trimmed += group_trimmed;
+		if (ret) {
+			btrfs_put_block_group(cache);
+			break;
 		}
 
 		cache = next_block_group(fs_info->tree_root, cache);
-- 
1.7.4.1

