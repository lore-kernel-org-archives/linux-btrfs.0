Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35628 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdFGBAE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:04 -0400
Received: by mail-wr0-f196.google.com with SMTP id g76so11546681wrd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:03 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 1/7] Btrfs: __compare_inode_defrag decrease max compare count
Date: Wed,  7 Jun 2017 03:58:38 +0300
Message-Id: <20170607005844.2078-2-nefelim4ag@gmail.com>
In-Reply-To: <20170607005844.2078-1-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In worst case code do 4 comparison,
just add some new checks to switch check branch faster
now in worst case code do 3 comparison

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/file.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index da1096eb1..39efda26c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -71,16 +71,17 @@ struct inode_defrag {
 static int __compare_inode_defrag(struct inode_defrag *defrag1,
 				  struct inode_defrag *defrag2)
 {
-	if (defrag1->root > defrag2->root)
-		return 1;
-	else if (defrag1->root < defrag2->root)
+	if (defrag1->root != defrag2->root) {
+		if (defrag1->root > defrag2->root)
+			return 1;
 		return -1;
-	else if (defrag1->ino > defrag2->ino)
-		return 1;
-	else if (defrag1->ino < defrag2->ino)
+	}
+	if (defrag1->ino != defrag2->ino) {
+		if (defrag1->ino > defrag2->ino)
+			return 1;
 		return -1;
-	else
-		return 0;
+	}
+	return 0;
 }
 
 /* pop a record for an inode into the defrag tree.  The lock
-- 
2.13.0

