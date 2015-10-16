Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbbJPQTB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:19:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 81117AAC8
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:18:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/8] btrfs-progs: cleanup and comment parse_range
Date: Fri, 16 Oct 2015 18:17:49 +0200
Message-Id: <4d4646c4a4938b58e4c5bd0ab57361b0261d202b.1445011409.git.dsterba@suse.com>
In-Reply-To: <cover.1445011409.git.dsterba@suse.com>
References: <cover.1445011409.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simplify a check and unindent some code.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 63 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 9af218bbfa51..798b533aa7d6 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -88,43 +88,54 @@ static int parse_u64(const char *str, u64 *result)
 	return 0;
 }
 
+/*
+ * Parse range that's missing some part that can be implicit:
+ * a..b	- exact range, a can be equal to b
+ * a..	- implicitly unbounded maximum (end == (u64)-1)
+ * ..b	- implicitly starting at 0
+ * a	- invalid; unclear semantics, use parse_u64 instead
+ *
+ * Returned values are u64, value validation and interpretation should be done
+ * by the caller.
+ */
 static int parse_range(const char *range, u64 *start, u64 *end)
 {
 	char *dots;
+	const char *rest;
+	int skipped = 0;
 
 	dots = strstr(range, "..");
-	if (dots) {
-		const char *rest = dots + 2;
-		int skipped = 0;
-
-		*dots = 0;
+	if (!dots)
+		return 1;
 
-		if (!*rest) {
-			*end = (u64)-1;
-			skipped++;
-		} else {
-			if (parse_u64(rest, end))
-				return 1;
-		}
-		if (dots == range) {
-			*start = 0;
-			skipped++;
-		} else {
-			if (parse_u64(range, start))
-				return 1;
-		}
+	rest = dots + 2;
+	*dots = 0;
 
-		if (*start >= *end) {
-			fprintf(stderr, "Range %llu..%llu doesn't make "
-				"sense\n", (unsigned long long)*start,
-				(unsigned long long)*end);
+	if (!*rest) {
+		*end = (u64)-1;
+		skipped++;
+	} else {
+		if (parse_u64(rest, end))
 			return 1;
-		}
+	}
+	if (dots == range) {
+		*start = 0;
+		skipped++;
+	} else {
+		if (parse_u64(range, start))
+			return 1;
+	}
 
-		if (skipped <= 1)
-			return 0;
+	if (*start >= *end) {
+		fprintf(stderr, "Range %llu..%llu doesn't make "
+			"sense\n", (unsigned long long)*start,
+			(unsigned long long)*end);
+		return 1;
 	}
 
+	if (skipped <= 1)
+		return 0;
+
 	return 1;
 }
 
-- 
2.6.1

