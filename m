Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10426C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBEBB206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfCMPqB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:46:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:60776 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfCMPqA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:46:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8644DB117
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:45:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4679ADA875; Wed, 13 Mar 2019 16:47:15 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 7/9] btrfs: add assertion helpers for extent buffer write lock counters
Date:   Wed, 13 Mar 2019 16:47:15 +0100
Message-Id: <6a524add91073009c459ba97bbc7facd5ae700e1.1552489554.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552489554.git.dsterba@suse.com>
References: <cover.1552489554.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The write_locks are a simple counter to track locking balance and used
to assert tree locks.  Add helpers to make it conditionally work only in
DEBUG builds.  Will be used in followup patches.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index e88a0a3d286f..ebde1d943e55 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -56,6 +56,21 @@ static void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
 	BUG_ON(!atomic_read(&eb->read_locks));
 }
 
+static void btrfs_assert_tree_write_locks_get(struct extent_buffer *eb)
+{
+	atomic_inc(&eb->write_locks);
+}
+
+static void btrfs_assert_tree_write_locks_put(struct extent_buffer *eb)
+{
+	atomic_dec(&eb->write_locks);
+}
+
+void btrfs_assert_tree_locked(struct extent_buffer *eb)
+{
+	BUG_ON(!atomic_read(&eb->write_locks));
+}
+
 #else
 static void btrfs_assert_spinning_writers_get(struct extent_buffer *eb) { }
 static void btrfs_assert_spinning_writers_put(struct extent_buffer *eb) { }
@@ -65,6 +80,9 @@ static void btrfs_assert_spinning_readers_get(struct extent_buffer *eb) { }
 static void btrfs_assert_tree_read_locked(struct extent_buffer *eb) { }
 static void btrfs_assert_tree_read_locks_get(struct extent_buffer *eb) { }
 static void btrfs_assert_tree_read_locks_put(struct extent_buffer *eb) { }
+void btrfs_assert_tree_locked(struct extent_buffer *eb) { }
+static void btrfs_assert_tree_write_locks_get(struct extent_buffer *eb) { }
+static void btrfs_assert_tree_write_locks_put(struct extent_buffer *eb) { }
 #endif
 
 void btrfs_set_lock_blocking_read(struct extent_buffer *eb)
@@ -320,8 +338,3 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
 		write_unlock(&eb->lock);
 	}
 }
-
-void btrfs_assert_tree_locked(struct extent_buffer *eb)
-{
-	BUG_ON(!atomic_read(&eb->write_locks));
-}
-- 
2.20.1

