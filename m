From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: set ioprio of scrub readahead to idle
Date: Mon,  6 Feb 2012 17:15:28 +0100
Message-ID: <1328544928-31919-1-git-send-email-sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reduce ioprio class of scrub readahead threads to idle priority.
This setting is fixed. This priority has shown the best performance
during all measurements.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h |    3 +++
 fs/btrfs/reada.c |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3c2cbf7..b1f27fb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -165,6 +165,9 @@ static int btrfs_csum_sizes[] = { 4, 0 };
 #define BTRFS_FT_XATTR		8
 #define BTRFS_FT_MAX		9
 
+/* ioprio of readahead is set to idle */
+#define BTRFS_IOPRIO_READA (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0))
+
 /*
  * The key defines the order in the tree, and so it also defines (optimal)
  * block layout.
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 2373b39..b35ce3a 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -708,13 +708,18 @@ static void reada_start_machine_worker(struct btrfs_work *work)
 {
 	struct reada_machine_work *rmw;
 	struct btrfs_fs_info *fs_info;
+	int old_ioprio;
 
 	rmw = container_of(work, struct reada_machine_work, work);
 	fs_info = rmw->fs_info;
 
 	kfree(rmw);
 
+	old_ioprio = IOPRIO_PRIO_VALUE(task_nice_ioclass(current),
+				       task_nice_ioprio(current));
+	set_task_ioprio(current, BTRFS_IOPRIO_READA);
 	__reada_start_machine(fs_info);
+	set_task_ioprio(current, old_ioprio);
 }
 
 static void __reada_start_machine(struct btrfs_fs_info *fs_info)
-- 
1.7.3.4

