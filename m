Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35994 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751484AbdFGBAI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:08 -0400
Received: by mail-wr0-f195.google.com with SMTP id e23so10418262wre.3
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:08 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 6/7] Btrfs: __tree_mod_log_insert decrease max compare count
Date: Wed,  7 Jun 2017 03:58:43 +0300
Message-Id: <20170607005844.2078-7-nefelim4ag@gmail.com>
In-Reply-To: <20170607005844.2078-1-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In worst case code do 4 comparison,
just add some new checks to switch check branch faster
now in worst case code do 3 comparison

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/ctree.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a3a75f1de..318379531 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -460,15 +460,17 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
 	while (*new) {
 		cur = rb_entry(*new, struct tree_mod_elem, node);
 		parent = *new;
-		if (cur->logical < tm->logical)
-			new = &((*new)->rb_left);
-		else if (cur->logical > tm->logical)
-			new = &((*new)->rb_right);
-		else if (cur->seq < tm->seq)
-			new = &((*new)->rb_left);
-		else if (cur->seq > tm->seq)
-			new = &((*new)->rb_right);
-		else
+		if (cur->logical != tm->logical) {
+			if (cur->logical < tm->logical)
+				new = &((*new)->rb_left);
+			else
+				new = &((*new)->rb_right);
+		} else if (cur->seq != tm->seq) {
+			if (cur->seq < tm->seq)
+				new = &((*new)->rb_left);
+			else
+				new = &((*new)->rb_right);
+		} else
 			return -EEXIST;
 	}
 
-- 
2.13.0

