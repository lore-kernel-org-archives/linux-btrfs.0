Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C54C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A35020811
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfDWLmL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 07:42:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:44342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfDWLmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 07:42:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DEE60AC43
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2019 11:42:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Simplify snapshot exclusion code
Date:   Tue, 23 Apr 2019 14:42:06 +0300
Message-Id: <20190423114207.7899-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

BTRFS sports a mechanism to provide exclusion when a snapshot is about
to be created. This is implemented via btrfs_start_write_no_snapshotting
et al. Currently the implementation of that mechanism is some perverse
amalgamation of a percpu variable, an explicit waitqueue, an atomic_t
variable and an implicit wait bit on said atomic_t via wait_var_event
family of API. And for good measure there is a memory barrier thrown in
the mix...

Astute reader should have concluded by now that it's bordering on
impossible to prove whether this scheme works. What's worse - all of
this is required to achieve something really simple - ensure certain
operations cannot run during snapshot creation. Let's simplify this by
relying on a single atomic_t used as a boolean flag. This commit changes
only the implementation and not the semantics of the existing mechanism.

Now, if the atomic is 1 (snapshot is in progress) callers of
btrfs_start_write_no_snapshotting will get a ret val of 0 that should be
handled accordingly.

btrfs_wait_for_snapshot_creation OTOH will block until snapshotting is
in progress and return when current snapshot in progress is finished and
will acquire the right to create a snapshot.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 20 +++++---------------
 fs/btrfs/ioctl.c       |  9 ++-------
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8f2b7b29c3fd..d9e2e35700fd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11333,25 +11333,15 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
  */
 void btrfs_end_write_no_snapshotting(struct btrfs_root *root)
 {
-	percpu_counter_dec(&root->subv_writers->counter);
-	cond_wake_up(&root->subv_writers->wait);
+	ASSERT(atomic_read(&root->will_be_snapshotted) == 1);
+	if (atomic_dec_and_test(&root->will_be_snapshotted))
+		wake_up_var(&root->will_be_snapshotted);
 }
 
 int btrfs_start_write_no_snapshotting(struct btrfs_root *root)
 {
-	if (atomic_read(&root->will_be_snapshotted))
-		return 0;
-
-	percpu_counter_inc(&root->subv_writers->counter);
-	/*
-	 * Make sure counter is updated before we check for snapshot creation.
-	 */
-	smp_mb();
-	if (atomic_read(&root->will_be_snapshotted)) {
-		btrfs_end_write_no_snapshotting(root);
-		return 0;
-	}
-	return 1;
+	ASSERT(atomic_read(&root->will_be_snapshotted) >= 0);
+	return atomic_add_unless(&root->will_be_snapshotted, 1, 1);
 }
 
 void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8774d4be7c97..f9f66c8a5dad 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -794,11 +794,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	 * possible. This is to avoid later writeback (running dealloc) to
 	 * fallback to COW mode and unexpectedly fail with ENOSPC.
 	 */
-	atomic_inc(&root->will_be_snapshotted);
-	smp_mb__after_atomic();
-	/* wait for no snapshot writes */
-	wait_event(root->subv_writers->wait,
-		   percpu_counter_sum(&root->subv_writers->counter) == 0);
+	btrfs_wait_for_snapshot_creation(root);
 
 	ret = btrfs_start_delalloc_snapshot(root);
 	if (ret)
@@ -878,8 +874,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 dec_and_free:
 	if (snapshot_force_cow)
 		atomic_dec(&root->snapshot_force_cow);
-	if (atomic_dec_and_test(&root->will_be_snapshotted))
-		wake_up_var(&root->will_be_snapshotted);
+	btrfs_end_write_no_snapshotting(root);
 free_pending:
 	kfree(pending_snapshot->root_item);
 	btrfs_free_path(pending_snapshot->path);
-- 
2.17.1

