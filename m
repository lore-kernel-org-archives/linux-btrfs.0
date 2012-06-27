Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:12975 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/7] Btrfs: support root level changes in __resolve_indirect_ref
Date: Wed, 27 Jun 2012 19:24:54 +0200
Message-Id: <1340817899-16343-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the tree mod log, we can have a tree that's two levels high, but
btrfs_search_old_slot may still return a path with the tree root at level
one instead. __resolve_indirect_ref must care for this and accept parents in
a lower level than expected.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7301cdb..cf0df90 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -301,10 +301,14 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 
 	eb = path->nodes[level];
-	if (!eb) {
-		WARN_ON(1);
-		ret = 1;
-		goto out;
+	while (!eb) {
+		if (!level) {
+			WARN_ON(1);
+			ret = 1;
+			goto out;
+		}
+		level--;
+		eb = path->nodes[level];
 	}
 
 	ret = add_all_parents(root, path, parents, level, &ref->key_for_search,
-- 
1.7.3.4

