Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE09C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB80206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfCMPp4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:45:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:60754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfCMPpz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:45:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C91E4B117
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:45:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8B1B0DA875; Wed, 13 Mar 2019 16:47:10 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 5/9] btrfs: add assertion helpers for extent buffer read lock counters
Date:   Wed, 13 Mar 2019 16:47:10 +0100
Message-Id: <65c1bd09c13b8d082bda7f6ea0038934b3e78a3c.1552489554.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552489554.git.dsterba@suse.com>
References: <cover.1552489554.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The read_locks are a simple counter to track locking balance and used to
assert tree locks.  Add helpers to make it conditionally work only in
DEBUG builds.  Will be used in followup patches.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index ce9dc985ce05..947c66c01e34 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -12,8 +12,6 @@
 #include "extent_io.h"
 #include "locking.h"
 
-static void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
-
 #ifdef CONFIG_BTRFS_DEBUG
 static void btrfs_assert_spinning_writers_get(struct extent_buffer *eb)
 {
@@ -43,12 +41,30 @@ static void btrfs_assert_spinning_readers_put(struct extent_buffer *eb)
 	atomic_dec(&eb->spinning_readers);
 }
 
+static void btrfs_assert_tree_read_locks_get(struct extent_buffer *eb)
+{
+	atomic_inc(&eb->read_locks);
+}
+
+static void btrfs_assert_tree_read_locks_put(struct extent_buffer *eb)
+{
+	atomic_dec(&eb->read_locks);
+}
+
+static void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
+{
+	BUG_ON(!atomic_read(&eb->read_locks));
+}
+
 #else
 static void btrfs_assert_spinning_writers_get(struct extent_buffer *eb) { }
 static void btrfs_assert_spinning_writers_put(struct extent_buffer *eb) { }
 static void btrfs_assert_no_spinning_writers(struct extent_buffer *eb) { }
 static void btrfs_assert_spinning_readers_put(struct extent_buffer *eb) { }
 static void btrfs_assert_spinning_readers_get(struct extent_buffer *eb) { }
+static void btrfs_assert_tree_read_locked(struct extent_buffer *eb) { }
+static void btrfs_assert_tree_read_locks_get(struct extent_buffer *eb) { }
+static void btrfs_assert_tree_read_locks_put(struct extent_buffer *eb) { }
 #endif
 
 void btrfs_set_lock_blocking_read(struct extent_buffer *eb)
@@ -309,8 +325,3 @@ void btrfs_assert_tree_locked(struct extent_buffer *eb)
 {
 	BUG_ON(!atomic_read(&eb->write_locks));
 }
-
-static void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
-{
-	BUG_ON(!atomic_read(&eb->read_locks));
-}
-- 
2.20.1

