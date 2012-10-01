Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64239 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab2JAULx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2012 16:11:53 -0400
Received: by bkcjk13 with SMTP id jk13so5179865bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 13:11:51 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clmason@fusionio.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BTRFS-PROGS][PATCH] pretty_sizes() returns incorrect values
Date: Mon,  1 Oct 2012 22:11:27 +0200
Message-Id: <1349122287-6078-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

pretty_sizes() returns incorrect values if the argument is < 1024.

pretty_sizes(0) -> 0.00		OK
pretty_sizes(102) -> 0.10	WRONG
pretty_sizes(1023) -> 1.00	WRONG
pretty_sizes(1024) -> 1.00KB	OK

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 utils.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/utils.c b/utils.c
index aade9e2..04c3e82 100644
--- a/utils.c
+++ b/utils.c
@@ -1097,25 +1097,27 @@ char *pretty_sizes(u64 size)
 {
 	int num_divs = 0;
         int pretty_len = 16;
-	u64 last_size = size;
-	u64 fract_size = size;
 	float fraction;
 	char *pretty;
 
-	while(size > 0) {
-		fract_size = last_size;
-		last_size = size;
-		size /= 1024;
-		num_divs++;
-	}
-	if (num_divs == 0)
-		num_divs = 1;
-	if (num_divs > ARRAY_SIZE(size_strs))
-		return NULL;
+	if( size < 1024 ){
+		fraction = size;
+		num_divs = 0;
+	} else {
+		u64 last_size = size;
+		num_divs = 0;
+		while(size >= 1024){
+			last_size = size;
+			size /= 1024;
+			num_divs ++;
+		}
 
-	fraction = (float)fract_size / 1024;
+		if (num_divs > ARRAY_SIZE(size_strs))
+			return NULL;
+		fraction = (float)last_size / 1024;
+	}
 	pretty = malloc(pretty_len);
-	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs-1]);
+	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs]);
 	return pretty;
 }
 
-- 
1.7.10.4

