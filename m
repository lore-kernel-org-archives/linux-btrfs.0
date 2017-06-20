Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751122AbdFTQGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 12:06:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 524FDAAC5
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 16:06:05 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 09/13] btrfs: add a node counter to each of the rbtrees
Date: Tue, 20 Jun 2017 10:06:49 -0600
Message-Id: <20170620160653.19907-10-enadolski@suse.com>
In-Reply-To: <20170620160653.19907-1-enadolski@suse.com>
References: <20170620160653.19907-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch adds counters to each of the rbtrees so that we can tell
how large they are growing for a given workload.  These counters
will be exported by tracepoints in the next patch.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index daae7b6..4018393 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -141,9 +141,10 @@ struct prelim_ref {
 
 struct preftree {
 	struct rb_root root;
+	unsigned int count;
 };
 
-#define PREFTREE_INIT	{ .root = RB_ROOT }
+#define PREFTREE_INIT	{ .root = RB_ROOT, .count = 0 }
 
 struct preftrees {
 	struct preftree direct;    /* BTRFS_SHARED_[DATA|BLOCK]_REF_KEY */
@@ -252,6 +253,7 @@ static void prelim_ref_insert(struct preftree *preftree,
 		}
 	}
 
+	preftree->count++;
 	rb_link_node(&newref->rbnode, parent, p);
 	rb_insert_color(&newref->rbnode, root);
 }
@@ -269,6 +271,7 @@ static void prelim_release(struct preftree *preftree)
 		release_pref(ref);
 
 	preftree->root = RB_ROOT;
+	preftree->count = 0;
 }
 
 /*
@@ -604,6 +607,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 
 		rb_erase(&ref->rbnode, &preftrees->indirect.root);
+		preftrees->indirect.count--;
 
 		if (ref->count == 0) {
 			release_pref(ref);
-- 
2.10.2

