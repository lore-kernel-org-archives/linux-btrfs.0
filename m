Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:24272 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] Btrfs: leave critical region in btrfs_find_all_roots as soon as possible
Date: Wed, 27 Jun 2012 19:24:57 +0200
Message-Id: <1340817899-16343-6-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When delayed refs exist, btrfs_find_all_roots used to hold the delayed ref
mutex way longer than actually required. We ought to drop it immediately
after we're done collecting all the delayed refs.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index cf0df90..a383c18 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -839,6 +839,7 @@ again:
 			}
 			ret = __add_delayed_refs(head, delayed_ref_seq,
 						 &prefs_delayed);
+			mutex_unlock(&head->mutex);
 			if (ret) {
 				spin_unlock(&delayed_refs->lock);
 				goto out;
@@ -932,8 +933,6 @@ again:
 	}
 
 out:
-	if (head)
-		mutex_unlock(&head->mutex);
 	btrfs_free_path(path);
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-- 
1.7.3.4

