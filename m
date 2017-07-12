Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40822 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbdGLWTH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:19:07 -0400
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, dsterba@suse.cz, jeffm@suse.com,
        linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: [PATCH v3 09/13] btrfs: add a node counter to each of the rbtrees
Date: Wed, 12 Jul 2017 16:20:07 -0600
Message-Id: <20170712222011.26705-3-enadolski@suse.com>
In-Reply-To: <20170712222011.26705-1-enadolski@suse.com>
References: <20170712222011.26705-1-enadolski@suse.com>
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
index 1edb107..2e452264 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -136,9 +136,10 @@ struct prelim_ref {
 
 struct preftree {
 	struct rb_root root;
+	unsigned int count;
 };
 
-#define PREFTREE_INIT	{ .root = RB_ROOT }
+#define PREFTREE_INIT	{ .root = RB_ROOT, .count = 0 }
 
 struct preftrees {
 	struct preftree direct;    /* BTRFS_SHARED_[DATA|BLOCK]_REF_KEY */
@@ -248,6 +249,7 @@ static void prelim_ref_insert(struct preftree *preftree,
 		}
 	}
 
+	preftree->count++;
 	rb_link_node(&newref->rbnode, parent, p);
 	rb_insert_color(&newref->rbnode, root);
 }
@@ -265,6 +267,7 @@ static void prelim_release(struct preftree *preftree)
 		free_pref(ref);
 
 	preftree->root = RB_ROOT;
+	preftree->count = 0;
 }
 
 /*
@@ -607,6 +610,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 
 		rb_erase(&ref->rbnode, &preftrees->indirect.root);
+		preftrees->indirect.count--;
 
 		if (ref->count == 0) {
 			free_pref(ref);
-- 
2.10.2

