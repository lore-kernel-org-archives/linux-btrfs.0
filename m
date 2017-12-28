Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45919 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753464AbdL1P2N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 10:28:13 -0500
Received: by mail-wr0-f193.google.com with SMTP id o15so7274206wrf.12
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Dec 2017 07:28:12 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH] Btrfs: replace raid56 stripe bubble sort with insert sort
Date: Thu, 28 Dec 2017 18:28:04 +0300
Message-Id: <20171228152804.4645-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Insert sort are generaly perform better then bubble sort,
by have less iterations on avarage.
That version also try place element to right position
instead of raw swap.

I'm not sure how many stripes per bio raid56,
btrfs try to store (and try to sort).

So, that a bit shorter just in the name of a great justice.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/volumes.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 98bc2433a920..7195fc8c49b1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5317,29 +5317,24 @@ static inline int parity_smaller(u64 a, u64 b)
 	return a > b;
 }
 
-/* Bubble-sort the stripe set to put the parity/syndrome stripes last */
+/* Insertion-sort the stripe set to put the parity/syndrome stripes last */
 static void sort_parity_stripes(struct btrfs_bio *bbio, int num_stripes)
 {
 	struct btrfs_bio_stripe s;
-	int i;
+	int i, j;
 	u64 l;
-	int again = 1;
 
-	while (again) {
-		again = 0;
-		for (i = 0; i < num_stripes - 1; i++) {
-			if (parity_smaller(bbio->raid_map[i],
-					   bbio->raid_map[i+1])) {
-				s = bbio->stripes[i];
-				l = bbio->raid_map[i];
-				bbio->stripes[i] = bbio->stripes[i+1];
-				bbio->raid_map[i] = bbio->raid_map[i+1];
-				bbio->stripes[i+1] = s;
-				bbio->raid_map[i+1] = l;
-
-				again = 1;
-			}
+	for (i = 1; i < num_stripes; i++) {
+		s = bbio->stripes[i];
+		l = bbio->raid_map[i];
+		for (j = i - 1; j >= 0; j--) {
+			if (!parity_smaller(bbio->raid_map[j], l))
+				break;
+			bbio->stripes[j+1]  = bbio->stripes[j];
+			bbio->raid_map[j+1] = bbio->raid_map[j];
 		}
+		bbio->stripes[j+1]  = s;
+		bbio->raid_map[j+1] = l;
 	}
 }
 
-- 
2.15.1
