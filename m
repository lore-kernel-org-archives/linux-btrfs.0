Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA89C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DD8E21019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfAWRiy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:38:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:38006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbfAWRix (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:38:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D190FB080
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:38:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7A786DA6F5; Wed, 23 Jan 2019 18:38:21 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: merge btrfs_set_lock_blocking_rw with it's caller
Date:   Wed, 23 Jan 2019 18:38:20 +0100
Message-Id: <5c85a32651721e9905f41c14dac4c084a9dd2517.1548264220.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548264220.git.dsterba@suse.com>
References: <cover.1548264220.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The last caller that does not have a fixed value of lock is
btrfs_set_path_blocking, that actually does the same conditional swtich
by the lock type so we can merge the branches together and remove the
helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c   | 13 ++++++++++---
 fs/btrfs/locking.h | 12 ------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a482171fd710..1f2917da89ef 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -45,11 +45,18 @@ noinline void btrfs_set_path_blocking(struct btrfs_path *p)
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
 		if (!p->nodes[i] || !p->locks[i])
 			continue;
-		btrfs_set_lock_blocking_rw(p->nodes[i], p->locks[i]);
-		if (p->locks[i] == BTRFS_READ_LOCK)
+		/*
+		 * If we currently have a spinning reader or writer lock this
+		 * will bump the count of blocking holders and drop the
+		 * spinlock.
+		 */
+		if (p->locks[i] == BTRFS_READ_LOCK) {
+			btrfs_set_lock_blocking_read(p->nodes[i]);
 			p->locks[i] = BTRFS_READ_LOCK_BLOCKING;
-		else if (p->locks[i] == BTRFS_WRITE_LOCK)
+		} else if (p->locks[i] == BTRFS_WRITE_LOCK) {
+			btrfs_set_lock_blocking_write(p->nodes[i]);
 			p->locks[i] = BTRFS_WRITE_LOCK_BLOCKING;
+		}
 	}
 }
 
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 84ea6ed60047..595014f64830 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -39,16 +39,4 @@ static inline void btrfs_tree_unlock_rw(struct extent_buffer *eb, int rw)
 		BUG();
 }
 
-/*
- * If we currently have a spinning reader or writer lock (indicated by the rw
- * flag) this will bump the count of blocking holders and drop the spinlock.
- */
-static inline void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
-{
-	if (rw == BTRFS_WRITE_LOCK)
-		btrfs_set_lock_blocking_write(eb);
-	else if (rw == BTRFS_READ_LOCK)
-		btrfs_set_lock_blocking_read(eb);
-}
-
 #endif
-- 
2.20.1

