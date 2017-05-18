Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755042AbdERDjH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:07 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 02/32] btrfs-progs: Introduce sectorsize nodesize and stripesize members for btrfs_fs_info
Date: Thu, 18 May 2017 11:38:27 +0800
Message-ID: <20170518033857.15002-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like what we do in kernel, since we will not support different
leaf/node/stripe size per tree, there is no need to store these block
sizes in btrfs_root.

This patch will introduce these block size members into btrfs_fs_info
structure, allowing us to convert such usage in later patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 chunk-recover.c | 3 +++
 ctree.h         | 4 ++++
 disk-io.c       | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/chunk-recover.c b/chunk-recover.c
index cf8b3184..1a880038 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1475,6 +1475,9 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	}
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+	fs_info->sectorsize = btrfs_super_sectorsize(disk_super);
+	fs_info->nodesize = btrfs_super_nodesize(disk_super);
+	fs_info->stripesize = btrfs_super_stripesize(disk_super);
 
 	ret = btrfs_check_fs_compatibility(disk_super, OPEN_CTREE_WRITES);
 	if (ret)
diff --git a/ctree.h b/ctree.h
index c457a8dc..78956a4f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1147,6 +1147,10 @@ struct btrfs_fs_info {
 	struct cache_tree *fsck_extent_cache;
 	struct cache_tree *corrupt_blocks;
 
+	/* Cached block sizes */
+	u32 nodesize;
+	u32 sectorsize;
+	u32 stripesize;
 };
 
 /*
diff --git a/disk-io.c b/disk-io.c
index 838d5cd4..bfdac5ab 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1327,6 +1327,9 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+	fs_info->sectorsize = btrfs_super_sectorsize(disk_super);
+	fs_info->nodesize = btrfs_super_nodesize(disk_super);
+	fs_info->stripesize = btrfs_super_stripesize(disk_super);
 
 	ret = btrfs_check_fs_compatibility(fs_info->super_copy, flags);
 	if (ret)
-- 
2.13.0



