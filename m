Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43146 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaEERkX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 13:40:23 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMp-0007aj-Uj
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 17:07:52 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.82)
	(envelope-from <hugo@carfax.org.uk>)
	id 1WhMMp-0002Pg-I0
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 18:07:51 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs check: Fix wrong level access
Date: Mon,  5 May 2014 18:07:49 +0100
Message-Id: <1399309671-9240-2-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
References: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's no reason to assume that the bad key order is in a leaf block,
so accessing level 0 of the path is going to be an error if it's actually
a node block that's bad.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-check.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d195e7a..fc84ad8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2418,6 +2418,7 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_key k1, k2;
 	int i;
+	int level;
 	int ret;
 
 	if (status != BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
@@ -2435,9 +2436,10 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -EIO;
 
-	path->lowest_level = btrfs_header_level(buf);
+	level = btrfs_header_level(buf);
+	path->lowest_level = level;
 	path->skip_check_block = 1;
-	if (btrfs_header_level(buf))
+	if (level)
 		btrfs_node_key_to_cpu(buf, &k1, 0);
 	else
 		btrfs_item_key_to_cpu(buf, &k1, 0);
@@ -2448,9 +2450,9 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 		return -EIO;
 	}
 
-	buf = path->nodes[0];
+	buf = path->nodes[level];
 	for (i = 0; i < btrfs_header_nritems(buf) - 1; i++) {
-		if (btrfs_header_level(buf)) {
+		if (level) {
 			btrfs_node_key_to_cpu(buf, &k1, i);
 			btrfs_node_key_to_cpu(buf, &k2, i + 1);
 		} else {
-- 
1.9.2

