Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbbJMPnd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 11:43:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9D79AABCC
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 15:43:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/7] btrfs-progs: extend parse_range API to accept a relaxed range
Date: Tue, 13 Oct 2015 17:42:23 +0200
Message-Id: <7edb64ff3707c11e1deaa2556db16f788fbc9011.1444750808.git.dsterba@suse.com>
In-Reply-To: <cover.1444750808.git.dsterba@suse.com>
References: <cover.1444750808.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some cases we want to accept a range of type [a..a]. Add a new
function to do the 'a < b' check for the caller and use it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 798b533aa7d6..62bee3cc78b6 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -126,9 +126,10 @@ static int parse_range(const char *range, u64 *start, u64 *end)
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
@@ -139,6 +140,25 @@ static int parse_range(const char *range, u64 *start, u64 *end)
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
@@ -196,7 +216,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				       "an argument\n");
 				return 1;
 			}
-			if (parse_range(value, &args->pstart, &args->pend)) {
+			if (parse_range_strict(value, &args->pstart, &args->pend)) {
 				fprintf(stderr, "Invalid drange argument\n");
 				return 1;
 			}
@@ -207,7 +227,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
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

