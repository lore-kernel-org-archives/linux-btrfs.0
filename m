Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33494 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbbI3Dus (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 23:50:48 -0400
Received: by pacex6 with SMTP id ex6so26195486pac.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 20:50:48 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v4 3/9] Btrfs: add helpers for read-only compat bits
Date: Tue, 29 Sep 2015 20:50:32 -0700
Message-Id: <31369105dd95b7a287c11bb426c7b0057512a3db.1443583874.git.osandov@osandov.com>
In-Reply-To: <cover.1443583874.git.osandov@osandov.com>
References: <cover.1443583874.git.osandov@osandov.com>
In-Reply-To: <cover.1443583874.git.osandov@osandov.com>
References: <cover.1443583874.git.osandov@osandov.com>
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
index 938efe33be80..42c41dc68cbb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4100,6 +4100,30 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
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
 
@@ -4110,6 +4134,64 @@ static inline int __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
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
2.6.0

