Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34281 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753656AbcLSLFn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 06:05:43 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 3/3 v2] btrfs: consolidate auto defrag kick off policies
Date: Mon, 19 Dec 2016 19:09:06 +0800
Message-Id: <20161219110906.12979-1-anand.jain@oracle.com>
In-Reply-To: <20161206044309.3450-4-anand.jain@oracle.com>
References: <20161206044309.3450-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now writes smaller than 64k for non compressed extents and 16k
for compressed extents inside eof are considered as candidate
for auto defrag, put them together at a place.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: pass value of small write, and current num_bytes.
    fix sign-off.

 fs/btrfs/inode.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 79f073e94f2d..d09c8276fef5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -388,6 +388,15 @@ static inline int inode_need_compress(struct inode *inode)
 	return 0;
 }
 
+static inline void inode_should_defrag(struct inode *inode,
+		u64 start, u64 end, u64 num_bytes, u64 small_write)
+{
+	/* If this is a small write inside eof, kick off a defrag */
+	if (num_bytes < small_write &&
+	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
+		btrfs_add_inode_defrag(NULL, inode);
+}
+
 /*
  * we create compressed extents in two phases.  The first
  * phase compresses a range of pages that have already been
@@ -429,10 +438,7 @@ static noinline void compress_file_range(struct inode *inode,
 	int compress_type = root->fs_info->compress_type;
 	int redirty = 0;
 
-	/* if this is a small write inside eof, kick off a defrag */
-	if ((end - start + 1) < SZ_16K &&
-	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
-		btrfs_add_inode_defrag(NULL, inode);
+	inode_should_defrag(inode, start, end, end - start + 1, SZ_16K);
 
 	actual_end = min_t(u64, isize, end + 1);
 again:
@@ -960,10 +966,7 @@ static noinline int cow_file_range(struct inode *inode,
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 
-	/* if this is a small write inside eof, kick off defrag */
-	if (num_bytes < SZ_64K &&
-	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
-		btrfs_add_inode_defrag(NULL, inode);
+	inode_should_defrag(inode, start, end, num_bytes, SZ_64K);
 
 	if (start == 0) {
 		/* lets try to make an inline extent */
-- 
2.10.0

