Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35046 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbINGE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 02:04:28 -0400
Received: by pacfv12 with SMTP id fv12so136693450pac.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2015 23:04:28 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 3/9] Btrfs: add helpers for read-only compat bits
Date: Sun, 13 Sep 2015 23:04:10 -0700
Message-Id: <4167525d3a97fec0fecf1e8c42e74ffde68ed70f.1442209006.git.osandov@osandov.com>
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
References: <cover.1442209006.git.osandov@osandov.com>
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
References: <cover.1442209006.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We're finally going to add one of these for the free space tree, so
let's add the same nice helpers that we have for the incompat bits.
While we're add it, also add helpers to clear the bits.

Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index aac314e14188..83d760378c3c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4103,6 +4103,30 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
 	}
 }
 
+#define btrfs_clear_fs_incompat(__fs_info, opt) \
+	__btrfs_clear_fs_incompat((__fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
+
+static inline void __btrfs_clear_fs_incompat(struct btrfs_fs_info *fs_info,
+					     u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = fs_info->super_copy;
+	features = btrfs_super_incompat_flags(disk_super);
+	if (features & flag) {
+		spin_lock(&fs_info->super_lock);
+		features = btrfs_super_incompat_flags(disk_super);
+		if (features & flag) {
+			features &= ~flag;
+			btrfs_set_super_incompat_flags(disk_super, features);
+			btrfs_info(fs_info, "clearing %llu feature flag",
+					 flag);
+		}
+		spin_unlock(&fs_info->super_lock);
+	}
+}
+
 #define btrfs_fs_incompat(fs_info, opt) \
 	__btrfs_fs_incompat((fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
 
@@ -4113,6 +4137,64 @@ static inline int __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
 	return !!(btrfs_super_incompat_flags(disk_super) & flag);
 }
 
+#define btrfs_set_fs_compat_ro(__fs_info, opt) \
+	__btrfs_set_fs_compat_ro((__fs_info), BTRFS_FEATURE_COMPAT_RO_##opt)
+
+static inline void __btrfs_set_fs_compat_ro(struct btrfs_fs_info *fs_info,
+					    u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = fs_info->super_copy;
+	features = btrfs_super_compat_ro_flags(disk_super);
+	if (!(features & flag)) {
+		spin_lock(&fs_info->super_lock);
+		features = btrfs_super_compat_ro_flags(disk_super);
+		if (!(features & flag)) {
+			features |= flag;
+			btrfs_set_super_compat_ro_flags(disk_super, features);
+			btrfs_info(fs_info, "setting %llu ro feature flag",
+				   flag);
+		}
+		spin_unlock(&fs_info->super_lock);
+	}
+}
+
+#define btrfs_clear_fs_compat_ro(__fs_info, opt) \
+	__btrfs_clear_fs_compat_ro((__fs_info), BTRFS_FEATURE_COMPAT_RO_##opt)
+
+static inline void __btrfs_clear_fs_compat_ro(struct btrfs_fs_info *fs_info,
+					      u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = fs_info->super_copy;
+	features = btrfs_super_compat_ro_flags(disk_super);
+	if (features & flag) {
+		spin_lock(&fs_info->super_lock);
+		features = btrfs_super_compat_ro_flags(disk_super);
+		if (features & flag) {
+			features &= ~flag;
+			btrfs_set_super_compat_ro_flags(disk_super, features);
+			btrfs_info(fs_info, "clearing %llu ro feature flag",
+				   flag);
+		}
+		spin_unlock(&fs_info->super_lock);
+	}
+}
+
+#define btrfs_fs_compat_ro(fs_info, opt) \
+	__btrfs_fs_compat_ro((fs_info), BTRFS_FEATURE_COMPAT_RO_##opt)
+
+static inline int __btrfs_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	disk_super = fs_info->super_copy;
+	return !!(btrfs_super_compat_ro_flags(disk_super) & flag);
+}
+
 /*
  * Call btrfs_abort_transaction as early as possible when an error condition is
  * detected, that way the exact line number is reported.
-- 
2.5.2

