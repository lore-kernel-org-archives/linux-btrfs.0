Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50812 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757838Ab2EPQvJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:51:09 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id 6978F240
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:51:08 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [RESEND PATCH] Btrfs: set ioprio of scrub readahead to idle
Date: Wed, 16 May 2012 18:51:08 +0200
Message-Id: <382895a74683dfed53d33dcbf1341ecf34e0019a.1337185546.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reduce ioprio class of scrub readahead threads to idle priority.
This setting is fixed. This priority has shown the best performance
during all measurements.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h |    3 +++
 fs/btrfs/reada.c |    5 +++++
 2 files changed, 8 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ec42a24..e6f772d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -173,6 +173,9 @@ static int btrfs_csum_sizes[] = { 4, 0 };
 #define BTRFS_FT_XATTR		8
 #define BTRFS_FT_MAX		9
 
+/* ioprio of readahead is set to idle */
+#define BTRFS_IOPRIO_READA (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0))
+
 /*
  * The key defines the order in the tree, and so it also defines (optimal)
  * block layout.
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index ac5d010..48a4882 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -718,13 +718,18 @@ static void reada_start_machine_worker(struct btrfs_work *work)
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
1.7.10.2

