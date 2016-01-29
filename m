Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674AbcA2Sef (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 13:34:35 -0500
Date: Fri, 29 Jan 2016 19:34:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs: sysfs: introduce helper for syncing bits with
 sysfs files
Message-ID: <20160129183422.GE31992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1453400624.git.dsterba@suse.com>
 <444e75169872f668eb890f19ec1f32dfc632e704.1453400624.git.dsterba@suse.com>
 <CAL3q7H5W=Eo64kDY38-sm58ZyHVJ3efNJ3ypJ1w_d8B4nDi-Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5W=Eo64kDY38-sm58ZyHVJ3efNJ3ypJ1w_d8B4nDi-Cg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 01:55:31PM +0000, Filipe Manana wrote:
> Did you try to run all xfstests with this?
> 
> I'm getting very often lots of warnings in btrfs tests 060 to 074:

Could you please test the attached patch in your testing setup? I was
not able to trigger the crashes with btrfs/060 062 063, running hundreds
of times with concurrent "find /sys/fs/btrfs -exec cat '{}' \;" in a
tight loop.

Out of all approaches how update the sysfs files, the one based on
workques looks best to me. The allocation context is safe wrt internal
sysfs allocations with GFP_KERNEL.

----------------------------8<-------------------------------
From: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: sysfs: update features from a workqueue

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 37 +++++++++++++++++++++++++++++++------
 fs/btrfs/sysfs.h |  7 +++++++
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 539e7b5e3f86..ced2570fdf6a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -782,12 +782,7 @@ failure:
 	return error;
 }
 
-
-/*
- * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
- * values in superblock. Call after any changes to incompat/compat_ro flags
- */
-void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
+static void btrfs_sysfs_do_feature_update(struct btrfs_fs_info *fs_info,
 		u64 bit, enum btrfs_feature_set set)
 {
 	struct btrfs_fs_devices *fs_devs;
@@ -815,6 +810,36 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
 }
 
+static void btrfs_sysfs_feature_update_callback(struct work_struct *work)
+{
+	struct btrfs_feature_update *bfu = container_of(work,
+			struct btrfs_feature_update, work);
+
+	btrfs_sysfs_do_feature_update(bfu->fs_info, bfu->bit, bfu->set);
+	kfree(bfu);
+}
+
+/*
+ * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
+ * values in superblock. Call after any changes to incompat/compat_ro flags
+ */
+void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
+		u64 bit, enum btrfs_feature_set set)
+{
+	struct btrfs_feature_update *bfu;
+
+	bfu = kmalloc(sizeof(*bfu), GFP_NOFS);
+	if (!bfu)
+		return;
+
+	INIT_WORK(&bfu->work, btrfs_sysfs_feature_update_callback);
+	bfu->fs_info = fs_info;
+	bfu->bit = bit;
+	bfu->set = set;
+
+	schedule_work(&bfu->work);
+}
+
 static int btrfs_init_debugfs(void)
 {
 #ifdef CONFIG_DEBUG_FS
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index d7da1a4c2f6c..d9772f2e5c9a 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -93,4 +93,11 @@ void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 		u64 bit, enum btrfs_feature_set set);
 
+struct btrfs_feature_update {
+	struct work_struct work;
+	struct btrfs_fs_info *fs_info;
+	u64 bit;
+	enum btrfs_feature_set set;
+};
+
 #endif /* _BTRFS_SYSFS_H_ */
-- 
1.8.4.5

