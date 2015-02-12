Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58221 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755806AbbBLOuD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 09:50:03 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t1CEiDdK003696
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 06:50:02 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1sgvt7888a-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 06:50:02 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add metadump_v2 support to the kernel
Date: Thu, 12 Feb 2015 09:49:59 -0500
Message-ID: <1423752599-17850-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For newly restored metadumps we can actually mount the fs and use it properly
except that the data obviously doesn't match properly.  To get around this make
us skip csum validation if the metadump_v2 flag is set on the fs, this will
allow us to reproduce balance issues with metadumps.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.h | 1 +
 fs/btrfs/inode.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1675602..bc16147 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -356,6 +356,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
+#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
 
 #define BTRFS_BACKREF_REV_MAX		256
 #define BTRFS_BACKREF_REV_SHIFT		56
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4564975..70d0af8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3039,6 +3039,10 @@ static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
 		return 0;
 
+	if (btrfs_super_flags(root->fs_info->super_copy) &
+	    BTRFS_SUPER_FLAG_METADUMP_V2)
+		return 0;
+
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
 	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
 		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM,
-- 
1.8.3.1

