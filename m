Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752813AbdGYUvC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:51:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F374FAEC1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:51:00 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 5/7] btrfs-progs: backref: add list_first_pref helper
Date: Tue, 25 Jul 2017 16:51:36 -0400
Message-Id: <20170725205138.28376-5-jeffm@suse.com>
In-Reply-To: <20170725205138.28376-1-jeffm@suse.com>
References: <20170725205138.28376-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

---
 backref.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/backref.c b/backref.c
index ac1b506..be3376a 100644
--- a/backref.c
+++ b/backref.c
@@ -130,6 +130,11 @@ struct __prelim_ref {
 	u64 wanted_disk_byte;
 };
 
+static struct __prelim_ref *list_first_pref(struct list_head *head)
+{
+	return list_first_entry(head, struct __prelim_ref, list);
+}
+
 struct pref_state {
 	struct list_head pending;
 };
@@ -804,8 +809,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	__merge_refs(&prefstate, 2);
 
 	while (!list_empty(&prefstate.pending)) {
-		ref = list_first_entry(&prefstate.pending,
-				       struct __prelim_ref, list);
+		ref = list_first_pref(&prefstate.pending);
 		WARN_ON(ref->count < 0);
 		if (roots && ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
@@ -857,8 +861,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 out:
 	btrfs_free_path(path);
 	while (!list_empty(&prefstate.pending)) {
-		ref = list_first_entry(&prefstate.pending,
-				       struct __prelim_ref, list);
+		ref = list_first_pref(&prefstate.pending);
 		list_del(&ref->list);
 		kfree(ref);
 	}
-- 
2.11.0

