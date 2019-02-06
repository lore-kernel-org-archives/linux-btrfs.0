Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D08C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 20:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7EBA217F9
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 20:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="w2KmYaDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfBFUqY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 15:46:24 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33594 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfBFUqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 15:46:23 -0500
Received: by mail-qt1-f196.google.com with SMTP id l11so9571415qtp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2019 12:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=MvygrytBItGCUCr8/3gIF0MVxHAT3tEFvJD9erNds7M=;
        b=w2KmYaDP+8LT8X9YLCIBr6Eswg+laFyFA+BROSSh9zS5lh7j4kVH7Aajg+TvLBMjfF
         2LIfB9dH0l7Jh1FxlGGFcRjz1sIakBNOnmgpwiZfwsePTlEFzbOENOjJGrDgbO/vlD3c
         arIqlDl4KOq//2BHrHFvAN2vYVDR94n/fO76cg1UQAoe8Z0trMvsaVutw5hMpQb4deED
         SwSlrn6DjneNRfewXMr0/bXRGfNNctV5HpzXSJcMNjl9VLKluuV/3w90AqKCNmGvIGWV
         YFVNa8pL0YrP0Ud6adLqS3OuBlG+NQxDtx4Ha4xW8NSGweqZOg7LHDeeFUeySG3TLrdN
         KvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=MvygrytBItGCUCr8/3gIF0MVxHAT3tEFvJD9erNds7M=;
        b=YMtZcxf/VeQWWM1uwvxgRn1Qqre1NW+Rxj/9cescLKfcZktAcICuPug/OLVHolpWYU
         SVVX8SNCoD85Ce+OPFdUK0bFkHJY7FnFuTkcWj9ctj7bdfkV6sZAFUad6SJmQ7LV10p7
         j3ufQmMwkt2gZ8oD1cgCGJHUmnntVdCC1bPE5IMCDtqWft4oZWMcwCKpD2xrzhF3NAi3
         ekapRriV8hM0AFhw2iw8fliX50iq8N+G5nBwAjzSI23JlditJbhqdxRkI0NnwnSt2+gQ
         ny4+BmgoxwEasVEWL+OzBX0yV95zOzS7t1/63lI6sxq1u2/B7Qe+rcQrLDrs0E1++TYf
         w6uQ==
X-Gm-Message-State: AHQUAub+cdYWomoAN06WDND7dGLkjZkAjkWHnoaWTn4BeTd+D+dKWGXW
        6Ln+J8uaBxV6by8Y8EJogO6jx/i0PAE=
X-Google-Smtp-Source: AHgI3IYzbtOtGh7q0Y2O573lkbPcjo6mV44MIbX7BnwLVbjbopkURkY/8Y48YOblCwSuKbs//bY57Q==
X-Received: by 2002:ac8:257b:: with SMTP id 56mr9063474qtn.209.1549485981843;
        Wed, 06 Feb 2019 12:46:21 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id q2sm14446425qkc.68.2019.02.06.12.46.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 12:46:20 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/2] btrfs: save drop_progress if we drop refs at all
Date:   Wed,  6 Feb 2019 15:46:15 -0500
Message-Id: <20190206204615.5862-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190206204615.5862-1-josef@toxicpanda.com>
References: <20190206204615.5862-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Previously we only updated the drop_progress key if we were in the
DROP_REFERENCE stage of snapshot deletion.  This is because the
UPDATE_BACKREF stage checks the flags of the blocks it's converting to
FULL_BACKREF, so if we go over a block we processed before it doesn't
matter, we just don't do anything.

The problem is in do_walk_down() we will go ahead and drop the roots
reference to any blocks that we know we won't need to walk into.

Given subvolume A and snapshot B.  The root of B points to all of the
nodes that belong to A, so all of those nodes have a refcnt > 1.  If B
did not modify those blocks it'll hit this condition in do_walk_down

if (!wc->update_ref ||
    generation <= root->root_key.offset)
	goto skip;

and in "goto skip" we simply do a btrfs_free_extent() for that bytenr
that we point at.

Now assume we modified some data in B, and then took a snapshot of B and
call it C.  C points to all the nodes in B, making every node the root
of B points to have a refcnt > 1.  This assumes the root level is 2 or
higher.

We delete snapshot B, which does the above work in do_walk_down,
free'ing our ref for nodes we share with A that we didn't modify.  Now
we hit a node we _did_ modify, thus we own.  We need to walk down into
this node and we set wc->stage == UPDATE_BACKREF.  We walk down to level
0 which we also own because we modified data.  We can't walk any further
down and thus now need to walk up and start the next part of the
deletion.  Now walk_up_proc is supposed to put us back into
DROP_REFERENCE, but there's an exception to this

if (level < wc->shared_level)
	goto out;

we are at level == 0, and our shared_level == 1.  We skip out of this
one and go up to level 1.  Since path->slots[1] < nritems we
path->slots[1]++ and break out of walk_up_tree to stop our transaction
and loop back around.  Now in btrfs_drop_snapshot we have this snippet

if (wc->stage == DROP_REFERENCE) {
	level = wc->level;
	btrfs_node_key(path->nodes[level],
		       &root_item->drop_progress,
		       path->slots[level]);
	root_item->drop_level = level;
}

our stage == UPDATE_BACKREF still, so we don't update the drop_progress
key.  This is a problem because we would have done btrfs_free_extent()
for the nodes leading up to our current position.  If we crash or
unmount here and go to remount we'll start over where we were before and
try to free our ref for blocks we've already freed, and thus abort()
out.

Fix this by keeping track of the last place we dropped a reference for
our block in do_walk_down.  Then if wc->stage == UPDATE_BACKREF we know
we'll start over from a place we meant to, and otherwise things continue
to work as they did before.

I have a complicated reproducer for this problem, without this patch
we'll fail to fsck the fs when replaying the log writes log.  With this
patch we can replay the whole log without any fsck or mount failures.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f40d6086c947..53fd4626660c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8765,6 +8765,8 @@ struct walk_control {
 	u64 refs[BTRFS_MAX_LEVEL];
 	u64 flags[BTRFS_MAX_LEVEL];
 	struct btrfs_key update_progress;
+	struct btrfs_key drop_progress;
+	int drop_level;
 	int stage;
 	int level;
 	int shared_level;
@@ -9148,6 +9150,16 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 					     ret);
 			}
 		}
+
+		/*
+		 * We need to update the next key in our walk control so we can
+		 * update the drop_progress key accordingly.  We don't care if
+		 * find_next_key doesn't find a key because that means we're at
+		 * the end and are going to clean up now.
+		 */
+		wc->drop_level = level;
+		find_next_key(path, level, &wc->drop_progress);
+
 		ret = btrfs_free_extent(trans, root, bytenr, fs_info->nodesize,
 					parent, root->root_key.objectid,
 					level - 1, 0);
@@ -9499,12 +9511,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		}
 
 		if (wc->stage == DROP_REFERENCE) {
-			level = wc->level;
-			btrfs_node_key(path->nodes[level],
-				       &root_item->drop_progress,
-				       path->slots[level]);
-			root_item->drop_level = level;
-		}
+			wc->drop_level = wc->level;
+			btrfs_node_key_to_cpu(path->nodes[wc->drop_level],
+					      &wc->drop_progress,
+					      path->slots[wc->drop_level]);
+		}
+		btrfs_cpu_key_to_disk(&root_item->drop_progress,
+				      &wc->drop_progress);
+		root_item->drop_level = wc->drop_level;
 
 		BUG_ON(wc->level == 0);
 		if (btrfs_should_end_transaction(trans) ||
-- 
2.14.3

