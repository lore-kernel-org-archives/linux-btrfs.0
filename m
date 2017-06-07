Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35633 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdFGBAF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:05 -0400
Received: by mail-wr0-f196.google.com with SMTP id g76so11546712wrd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:04 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 2/7] Btrfs: backref_comp decrease max compare count
Date: Wed,  7 Jun 2017 03:58:39 +0300
Message-Id: <20170607005844.2078-3-nefelim4ag@gmail.com>
In-Reply-To: <20170607005844.2078-1-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In worst case code do 6 comparison,
just add some new checks to switch check branch faster
now in worst case code do 4 comparison

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe9306..fa024642a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2249,20 +2249,23 @@ struct new_sa_defrag_extent {
 static int backref_comp(struct sa_defrag_extent_backref *b1,
 			struct sa_defrag_extent_backref *b2)
 {
-	if (b1->root_id < b2->root_id)
-		return -1;
-	else if (b1->root_id > b2->root_id)
+	if (b1->root_id != b2->root_id) {
+		if (b1->root_id < b2->root_id)
+			return -1;
 		return 1;
+	}
 
-	if (b1->inum < b2->inum)
-		return -1;
-	else if (b1->inum > b2->inum)
+	if (b1->inum != b2->inum) {
+		if (b1->inum < b2->inum)
+			return -1;
 		return 1;
+	}
 
-	if (b1->file_pos < b2->file_pos)
-		return -1;
-	else if (b1->file_pos > b2->file_pos)
+	if (b1->file_pos != b2->file_pos) {
+		if (b1->file_pos < b2->file_pos)
+			return -1;
 		return 1;
+	}
 
 	/*
 	 * [------------------------------] ===> (a range of space)
-- 
2.13.0

