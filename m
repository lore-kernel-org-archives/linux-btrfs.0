Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36468 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760072Ab2J2Rwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 13:52:45 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2229913eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 10:52:44 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 2/4] parse_size(): replace atoll() with strtoull()
Date: Mon, 29 Oct 2012 18:53:18 +0100
Message-Id: <1351533200-5703-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351533200-5703-1-git-send-email-kreijack@inwind.it>
References: <1351533200-5703-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the function atoll with strtoull(); Check that the suffix for the
parse_size() input is of only one character.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/utils.c b/utils.c
index 705be7b..aa2e574 100644
--- a/utils.c
+++ b/utils.c
@@ -31,6 +31,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <mntent.h>
+#include <ctype.h>
 #include <linux/loop.h>
 #include <linux/major.h>
 #include <linux/kdev_t.h>
@@ -1222,12 +1223,18 @@ scan_again:
 
 u64 parse_size(char *s)
 {
-	int len = strlen(s);
+	int i;
 	char c;
 	u64 mult = 1;
 
-	if (!isdigit(s[len - 1])) {
-		c = tolower(s[len - 1]);
+	for (i=0 ; s[i] && isdigit(s[i]) ; i++) ;
+	if (!i) {
+		fprintf(stderr, "ERROR: size value is empty\n");
+		exit(50);
+	}
+
+	if (s[i]) {
+		c = tolower(s[i]);
 		switch (c) {
 		case 'g':
 			mult *= 1024;
@@ -1238,11 +1245,17 @@ u64 parse_size(char *s)
 		case 'b':
 			break;
 		default:
-			fprintf(stderr, "Unknown size descriptor %c\n", c);
+			fprintf(stderr, "ERROR: Unknown size descriptor "
+				"'%c'\n", c);
 			exit(1);
 		}
-		s[len - 1] = '\0';
 	}
-	return atoll(s) * mult;
+	if (s[i] && s[i+1]) {
+		fprintf(stderr, "ERROR: Illegal suffix contains "
+			"character '%c' in wrong position\n",
+			s[i+1]);
+		exit(51);
+	}
+	return strtoull(s, NULL, 10) * mult;
 }
 
-- 
1.7.10.4

