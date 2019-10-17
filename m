Return-Path: <SRS0=AqV7=YK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1DCECE58D
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 19:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E3B21925
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 19:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436525AbfJQTio (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:38:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:41334 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727148AbfJQTio (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Oct 2019 15:38:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DDE4EAFAE;
        Thu, 17 Oct 2019 19:38:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1285CDA808; Thu, 17 Oct 2019 21:38:54 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/5] btrfs: merge blocking_writers branches in btrfs_tree_read_lock
Date:   Thu, 17 Oct 2019 21:38:53 +0200
Message-Id: <34b22773d57982a1fafc635f7568d44c510ec354.1571340084.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1571340084.git.dsterba@suse.com>
References: <cover.1571340084.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are two ifs that use eb::blocking_writers. As this is a variable
modified inside and outside of locks, we could minimize number of
accesses to avoid problems with getting different results at different
times.

The access here is locked so this can only race with btrfs_tree_unlock
that sets blocking_writers to 0 without lock and unsets the lock owner.

The first branch is taken only if the same thread already holds the
lock, the second if checks for blocking writers. Here we'd either unlock
and wait, or proceed. Both are valid states of the locking protocol.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 93146b495276..c84c650e56c7 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -128,20 +128,21 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 	read_lock(&eb->lock);
 	BUG_ON(eb->blocking_writers == 0 &&
 	       current->pid == eb->lock_owner);
-	if (eb->blocking_writers && current->pid == eb->lock_owner) {
-		/*
-		 * This extent is already write-locked by our thread. We allow
-		 * an additional read lock to be added because it's for the same
-		 * thread. btrfs_find_all_roots() depends on this as it may be
-		 * called on a partly (write-)locked tree.
-		 */
-		BUG_ON(eb->lock_nested);
-		eb->lock_nested = true;
-		read_unlock(&eb->lock);
-		trace_btrfs_tree_read_lock(eb, start_ns);
-		return;
-	}
 	if (eb->blocking_writers) {
+		if (current->pid == eb->lock_owner) {
+			/*
+			 * This extent is already write-locked by our thread.
+			 * We allow an additional read lock to be added because
+			 * it's for the same thread. btrfs_find_all_roots()
+			 * depends on this as it may be called on a partly
+			 * (write-)locked tree.
+			 */
+			BUG_ON(eb->lock_nested);
+			eb->lock_nested = true;
+			read_unlock(&eb->lock);
+			trace_btrfs_tree_read_lock(eb, start_ns);
+			return;
+		}
 		read_unlock(&eb->lock);
 		wait_event(eb->write_lock_wq,
 			   eb->blocking_writers == 0);
-- 
2.23.0

