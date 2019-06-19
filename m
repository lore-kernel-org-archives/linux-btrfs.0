Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A49BC31E49
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 14:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 602D720679
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 14:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfFSOEp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:04:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730164AbfFSOEo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jun 2019 10:04:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93FF6ADE6
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2019 14:04:43 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs-progs: check: Remove duplicated and commented functions
Date:   Wed, 19 Jun 2019 17:04:40 +0300
Message-Id: <20190619140440.5550-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190619140440.5550-1-nborisov@suse.com>
References: <20190619140440.5550-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 756105181e57 ("btrfs-progs: check: supplement extent backref
list with rbtree") changed the backref implementation to use rb tree
and also commented the old implementations. It's been almost 2 years
since that change and it's unlikely the old version will ever be used,
so just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c | 69 ----------------------------------------------------
 1 file changed, 69 deletions(-)

diff --git a/check/main.c b/check/main.c
index 731c21d364d7..05ba9819c58e 100644
--- a/check/main.c
+++ b/check/main.c
@@ -4385,36 +4385,6 @@ static int check_block(struct btrfs_root *root,
 	return ret;
 }
 
-#if 0
-static struct tree_backref *find_tree_backref(struct extent_record *rec,
-						u64 parent, u64 root)
-{
-	struct list_head *cur = rec->backrefs.next;
-	struct extent_backref *node;
-	struct tree_backref *back;
-
-	while (cur != &rec->backrefs) {
-		node = to_extent_backref(cur);
-		cur = cur->next;
-		if (node->is_data)
-			continue;
-		back = to_tree_backref(node);
-		if (parent > 0) {
-			if (!node->full_backref)
-				continue;
-			if (parent == back->parent)
-				return back;
-		} else {
-			if (node->full_backref)
-				continue;
-			if (back->root == root)
-				return back;
-		}
-	}
-	return NULL;
-}
-#endif
-
 static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 						u64 parent, u64 root)
 {
@@ -4434,45 +4404,6 @@ static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 	return ref;
 }
 
-#if 0
-static struct data_backref *find_data_backref(struct extent_record *rec,
-						u64 parent, u64 root,
-						u64 owner, u64 offset,
-						int found_ref,
-						u64 disk_bytenr, u64 bytes)
-{
-	struct list_head *cur = rec->backrefs.next;
-	struct extent_backref *node;
-	struct data_backref *back;
-
-	while (cur != &rec->backrefs) {
-		node = to_extent_backref(cur);
-		cur = cur->next;
-		if (!node->is_data)
-			continue;
-		back = to_data_backref(node);
-		if (parent > 0) {
-			if (!node->full_backref)
-				continue;
-			if (parent == back->parent)
-				return back;
-		} else {
-			if (node->full_backref)
-				continue;
-			if (back->root == root && back->owner == owner &&
-			    back->offset == offset) {
-				if (found_ref && node->found_ref &&
-				    (back->bytes != bytes ||
-				    back->disk_bytenr != disk_bytenr))
-					continue;
-				return back;
-			}
-		}
-	}
-	return NULL;
-}
-#endif
-
 static struct data_backref *alloc_data_backref(struct extent_record *rec,
 						u64 parent, u64 root,
 						u64 owner, u64 offset,
-- 
2.17.1

