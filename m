Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbbJPQTI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:19:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0AD20AABE
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:19:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/8] btrfs-progs: extend parse_range API to accept a relaxed range
Date: Fri, 16 Oct 2015 18:17:56 +0200
Message-Id: <54102d7fe0b51fa62d88650dd1e9a845d0c86a49.1445011409.git.dsterba@suse.com>
In-Reply-To: <cover.1445011409.git.dsterba@suse.com>
References: <cover.1445011409.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some cases we want to accept a range of type [a..a]. Add a new
function to do the 'a < b' check for the caller and use it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 0a1bf0cd0699..1fd8d2018b7a 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -128,9 +128,10 @@ static int parse_range(const char *range, u64 *start, u64 *end)
 			return 1;
 	}
 
-	if (*start >= *end) {
-		fprintf(stderr, "Range %llu..%llu doesn't make "
-			"sense\n", (unsigned long long)*start,
+	if (*start > *end) {
+		fprintf(stderr,
+			"ERROR: range %llu..%llu doesn't make sense\n",
+			(unsigned long long)*start,
 			(unsigned long long)*end);
 		return 1;
 	}
@@ -141,6 +142,25 @@ static int parse_range(const char *range, u64 *start, u64 *end)
 	return 1;
 }
 
+/*
+ * Parse range and check if start < end
+ */
+static int parse_range_strict(const char *range, u64 *start, u64 *end)
+{
+	if (parse_range(range, start, end) == 0) {
+		if (*start >= *end) {
+			fprintf(stderr,
+				"ERROR: range %llu..%llu not allowed\n",
+				(unsigned long long)*start,
+				(unsigned long long)*end);
+			return 1;
+		}
+		return 0;
+	}
+
+	return 1;
+}
+
 static int parse_filters(char *filters, struct btrfs_balance_args *args)
 {
 	char *this_char;
@@ -198,7 +218,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				       "an argument\n");
 				return 1;
 			}
-			if (parse_range(value, &args->pstart, &args->pend)) {
+			if (parse_range_strict(value, &args->pstart, &args->pend)) {
 				fprintf(stderr, "Invalid drange argument\n");
 				return 1;
 			}
@@ -209,7 +229,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				       "an argument\n");
 				return 1;
 			}
-			if (parse_range(value, &args->vstart, &args->vend)) {
+			if (parse_range_strict(value, &args->vstart, &args->vend)) {
 				fprintf(stderr, "Invalid vrange argument\n");
 				return 1;
 			}
-- 
2.6.1

