From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Fri, 08 Apr 2011 16:44:37 +0800
Message-ID: <4D9ECAF5.50108@cn.fujitsu.com>
References: <20110402121946.6bf27f80@sf.home>	<4D96EE76.5040208@cn.fujitsu.com>	<20110402134132.0391f4fd@sf.home>	<4D9708E0.6030206@cn.fujitsu.com> <20110402155545.2159043a@sf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sergei Trofimovich <slyich@gmail.com>,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110402155545.2159043a@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>


When a btrfs disk is created by mixed data & metadata option, it will have no
pure data or pure metadata space info.

In btrfs's for-linus branch, commit 78b1ea13838039cd88afdd62519b40b344d6c920
(Btrfs: fix OOPS of empty filesystem after balance) initializes space infos at
the very beginning.  The problem is this initialization does not take the mixed
case into account, which will cause btrfs will easily get into ENOSPC in mixed
case.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f619c3c..1b47ae4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8781,23 +8781,38 @@ out:
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *space_info;
+	struct btrfs_super_block *disk_super;
+	u64 features;
+	u64 flags;
+	int mixed = 0;
 	int ret;
 
-	ret = update_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM, 0, 0,
-								 &space_info);
-	if (ret)
-		return ret;
+	disk_super = &fs_info->super_copy;
+	if (!btrfs_super_root(disk_super))
+		return 1;
 
-	ret = update_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA, 0, 0,
-								 &space_info);
-	if (ret)
-		return ret;
+	features = btrfs_super_incompat_flags(disk_super);
+	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+		mixed = 1;
 
-	ret = update_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA, 0, 0,
-								 &space_info);
+	flags = BTRFS_BLOCK_GROUP_SYSTEM;
+	ret = update_space_info(fs_info, flags, 0, 0, &space_info);
 	if (ret)
-		return ret;
+		goto out;
 
+	if (mixed) {
+		flags = BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA;
+		ret = update_space_info(fs_info, flags, 0, 0, &space_info);
+	} else {
+		flags = BTRFS_BLOCK_GROUP_METADATA;
+		ret = update_space_info(fs_info, flags, 0, 0, &space_info);
+		if (ret)
+			goto out;
+
+		flags = BTRFS_BLOCK_GROUP_DATA;
+		ret = update_space_info(fs_info, flags, 0, 0, &space_info);
+	}
+out:
 	return ret;
 }
 
-- 
1.6.5.2
