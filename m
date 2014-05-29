Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60110 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbaE2BlJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 21:41:09 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4T1f7hm031261
	for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 09:41:07 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: Improve the parse_size() error message.
Date: Thu, 29 May 2014 09:42:11 +0800
Message-ID: <1401327731-15769-1-git-send-email-quwenruo@cn.fujitsu.com>
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
 utils.c | 56 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/utils.c b/utils.c
index 392c5cf..499f08f 100644
--- a/utils.c
+++ b/utils.c
@@ -1612,18 +1612,45 @@ scan_again:
 
 u64 parse_size(char *s)
 {
-	int i;
 	char c;
+	char *endptr;
 	u64 mult = 1;
+	long long int signed_ret;
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
+	signed_ret = strtoll(s, &endptr, 10);
+	if (endptr == s) {
+		fprintf(stderr, "ERROR: Size value '%s' is invalid\n", s);
+		exit(1);
+	}
+	if (endptr[0] && endptr[1]) {
+		fprintf(stderr, "ERROR: Illegal suffix contains character '%c' in wrong position\n",
+			endptr[1]);
+		exit(1);
+	}
+	if (signed_ret <= 0) {
+		fprintf(stderr,
+			"ERROR: Size value '%s' is less equal than 0\n", s);
+		exit(1);
+	}
+	/* strtoll returns LLONG_MAX when overflow, if this happens,
+	 * need to call strtoull to get the real size */
+	if (errno == ERANGE && signed_ret == LLONG_MAX) {
+		ret = strtoull(s, NULL, 10);
+		if (errno == ERANGE && ret == ULLONG_MAX) {
+			fprintf(stderr,
+				"ERROR: Size value '%s' is too large for u64\n",
+				s);
+			exit(1);
+		}
+	} else
+		ret = signed_ret;
+	if (endptr[0]) {
+		c = tolower(endptr[0]);
 		switch (c) {
 		case 'e':
 			mult *= 1024;
@@ -1646,18 +1673,13 @@ u64 parse_size(char *s)
 		case 'b':
 			break;
 		default:
-			fprintf(stderr, "ERROR: Unknown size descriptor "
-				"'%c'\n", c);
+			fprintf(stderr, "ERROR: Unknown size descriptor '%c'\n", c);
 			exit(1);
 		}
 	}
-	if (s[i] && s[i+1]) {
-		fprintf(stderr, "ERROR: Illegal suffix contains "
-			"character '%c' in wrong position\n",
-			s[i+1]);
-		exit(51);
-	}
-	return strtoull(s, NULL, 10) * mult;
+
+	ret *= mult;
+	return ret;
 }
 
 int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
-- 
1.9.3

