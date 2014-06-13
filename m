Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5101 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777AbaFMCy6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 22:54:58 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3] btrfs-progs: Improve the parse_size() error message.
Date: Fri, 13 Jun 2014 10:55:57 +0800
Message-ID: <1402628157-22320-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using parse_size(), even non-numeric value is passed, it will only
give error message "ERROR: size value is empty", which is quite
confusing for end users.

This patch will introduce more meaningful error message for the
following new cases
1) Invalid size string (non-numeric string)
2) Minus size value (like "-1K")

Also this patch will take full use of endptr returned by strtoll() to
reduce unneeded loop.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changlog:
v2:
   Remove uneeded return value
   Avoid abuse of goto
v3:
   Don't reparse size twice
   Better u64 overflow check
---
 utils.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 16 deletions(-)

diff --git a/utils.c b/utils.c
index 392c5cf..eab3a1b 100644
--- a/utils.c
+++ b/utils.c
@@ -1610,20 +1610,53 @@ scan_again:
 	return 0;
 }
 
-u64 parse_size(char *s)
+/* A not-so-good version fls64. No fascinating optimization since
+ * no one except parse_size use it */
+static int fls64(u64 x)
 {
 	int i;
+
+	for (i = 0; i <64; i++)
+		if (x << i & (1UL << 63))
+			return 64 - i;
+	return 64 - i;
+}
+
+u64 parse_size(char *s)
+{
 	char c;
+	char *endptr;
 	u64 mult = 1;
+	u64 ret;
 
-	for (i = 0; s && s[i] && isdigit(s[i]); i++) ;
-	if (!i) {
-		fprintf(stderr, "ERROR: size value is empty\n");
-		exit(50);
+	if (!s) {
+		fprintf(stderr, "ERROR: Size value is empty\n");
+		exit(1);
 	}
-
-	if (s[i]) {
-		c = tolower(s[i]);
+	if (s[0] == '-') {
+		fprintf(stderr,
+			"ERROR: Size value '%s' is less equal than 0\n", s);
+		exit(1);
+	}
+	ret = strtoull(s, &endptr, 10);
+	if (endptr == s) {
+		fprintf(stderr, "ERROR: Size value '%s' is invalid\n", s);
+		exit(1);
+	}
+	if (endptr[0] && endptr[1]) {
+		fprintf(stderr, "ERROR: Illegal suffix contains character '%c' in wrong position\n",
+			endptr[1]);
+		exit(1);
+	}
+	/* strtoll returns LLONG_MAX when overflow, if this happens,
+	 * need to call strtoull to get the real size */
+	if (errno == ERANGE && ret == ULLONG_MAX) {
+		fprintf(stderr,
+			"ERROR: Size value '%s' is too large for u64\n", s);
+		exit(1);
+	}
+	if (endptr[0]) {
+		c = tolower(endptr[0]);
 		switch (c) {
 		case 'e':
 			mult *= 1024;
@@ -1646,18 +1679,19 @@ u64 parse_size(char *s)
 		case 'b':
 			break;
 		default:
-			fprintf(stderr, "ERROR: Unknown size descriptor "
-				"'%c'\n", c);
+			fprintf(stderr, "ERROR: Unknown size descriptor '%c'\n",
+				c);
 			exit(1);
 		}
 	}
-	if (s[i] && s[i+1]) {
-		fprintf(stderr, "ERROR: Illegal suffix contains "
-			"character '%c' in wrong position\n",
-			s[i+1]);
-		exit(51);
+	/* Check whether ret * mult overflow */
+	if (fls64(ret) + fls64(mult) - 1 > 64) {
+		fprintf(stderr,
+			"ERROR: Size value '%s' is too large for u64\n", s);
+		exit(1);
 	}
-	return strtoull(s, NULL, 10) * mult;
+	ret *= mult;
+	return ret;
 }
 
 int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
-- 
2.0.0

