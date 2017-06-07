Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33970 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdFGBAG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:06 -0400
Received: by mail-wr0-f193.google.com with SMTP id u101so9096086wrc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:05 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 3/7] Btrfs: ref_node_cmp decrease max compare count
Date: Wed,  7 Jun 2017 03:58:40 +0300
Message-Id: <20170607005844.2078-4-nefelim4ag@gmail.com>
In-Reply-To: <20170607005844.2078-1-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In worst case code do 8 comparison,
just add some new checks to switch check branch faster
now in worst case code do 5 comparison

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/backref.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 24865da63..2e4709e0c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -120,25 +120,29 @@ static void ref_root_free(struct ref_root *ref_tree)
  */
 static int ref_node_cmp(struct ref_node *a, struct ref_node *b)
 {
-	if (a->root_id < b->root_id)
-		return -1;
-	else if (a->root_id > b->root_id)
+	if (a->root_id != b->root_id) {
+		if (a->root_id < b->root_id)
+			return -1;
 		return 1;
+	}
 
-	if (a->object_id < b->object_id)
-		return -1;
-	else if (a->object_id > b->object_id)
+	if (a->object_id != b->object_id) {
+		if (a->object_id < b->object_id)
+			return -1;
 		return 1;
+	}
 
-	if (a->offset < b->offset)
-		return -1;
-	else if (a->offset > b->offset)
+	if (a->offset != b->offset) {
+		if (a->offset < b->offset)
+			return -1;
 		return 1;
+	}
 
-	if (a->parent < b->parent)
-		return -1;
-	else if (a->parent > b->parent)
+	if (a->parent != b->parent) {
+		if (a->parent < b->parent)
+			return -1;
 		return 1;
+	}
 
 	return 0;
 }
-- 
2.13.0

