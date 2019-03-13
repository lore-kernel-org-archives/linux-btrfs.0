Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BC2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD58206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfCMPqG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:46:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:60808 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfCMPqF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:46:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1166FB118
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:46:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D9494DA875; Wed, 13 Mar 2019 16:47:19 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 9/9] btrfs: switch extent_buffer::lock_nested to bool
Date:   Wed, 13 Mar 2019 16:47:19 +0100
Message-Id: <2ae7b54e7fdafaf752aaffeec1487e0dcac3c824.1552489554.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552489554.git.dsterba@suse.com>
References: <cover.1552489554.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The member is tracking simple status of the lock, we can use bool for
that and make some room for further space reduction in the structure.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 2 +-
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/locking.c   | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a9ae476c7502..388466b8cde9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4670,7 +4670,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->blocking_readers, 0);
 	atomic_set(&eb->blocking_writers, 0);
-	eb->lock_nested = 0;
+	eb->lock_nested = false;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b2640db8821e..0f2aa7e5adc1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -148,7 +148,7 @@ struct extent_buffer {
 
 	atomic_t blocking_writers;
 	atomic_t blocking_readers;
-	short lock_nested;
+	bool lock_nested;
 	/* >= 0 if eb belongs to a log tree, -1 otherwise */
 	short log_index;
 
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index e595e6541770..1b65b7ba9df8 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -172,7 +172,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 		 * called on a partly (write-)locked tree.
 		 */
 		BUG_ON(eb->lock_nested);
-		eb->lock_nested = 1;
+		eb->lock_nested = true;
 		read_unlock(&eb->lock);
 		return;
 	}
@@ -261,7 +261,7 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb)
 	 * field only matters to the lock owner.
 	 */
 	if (eb->lock_nested && current->pid == eb->lock_owner) {
-		eb->lock_nested = 0;
+		eb->lock_nested = false;
 		return;
 	}
 	btrfs_assert_tree_read_locked(eb);
@@ -282,7 +282,7 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
 	 * field only matters to the lock owner.
 	 */
 	if (eb->lock_nested && current->pid == eb->lock_owner) {
-		eb->lock_nested = 0;
+		eb->lock_nested = false;
 		return;
 	}
 	btrfs_assert_tree_read_locked(eb);
-- 
2.20.1

