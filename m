Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38515 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbbI1WdM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 18:33:12 -0400
Received: by wiclk2 with SMTP id lk2so121501798wic.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 15:33:10 -0700 (PDT)
From: =?UTF-8?q?Gabr=C3=ADel=20Arth=C3=BAr=20P=C3=A9tursson?=
	<gabriel@system.is>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Gabr=C3=ADel=20Arth=C3=BAr=20P=C3=A9tursson?=
	<gabriel@system.is>
Subject: [PATCH] btrfs-progs: add stripes filter
Date: Mon, 28 Sep 2015 22:33:04 +0000
Message-Id: <1443479584-869-1-git-send-email-gabriel@system.is>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1443463025.16163.6.camel@system.is>

---
 Documentation/btrfs-balance.asciidoc |  4 ++++
 cmds-balance.c                       | 24 ++++++++++++++++++++++++
 ioctl.h                              |  6 +++++-
 volumes.h                            |  1 +
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index 6d2fd0c..8663855 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -110,6 +110,10 @@ Process only given number of chunks, after all filters apply. This can be used
 to specifically target a chunk in connection with other filters (drange,
 vrange) or just simply limit the amount of work done by a single balance run.
 
+*stripes*::
+Balances only block groups which have the given number of stripes. The
+parameter is either a range specified as <start..end>, or a single integer.
+
 *soft*::
 Takes no parameters. Only has meaning when converting between profiles.
 When doing convert from one profile to another and soft mode is on,
diff --git a/cmds-balance.c b/cmds-balance.c
index 9af218b..c47f8b7 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -226,6 +226,21 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				return 1;
 			}
 			args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
+		} else if (!strcmp(this_char, "stripes")) {
+			if (!value || !*value) {
+				fprintf(stderr,
+					"the stripes filter requires an argument\n");
+				return 1;
+			}
+			if (parse_u64(value, &args->sstart)) {
+				if (parse_range(value, &args->sstart, &args->send)) {
+					fprintf(stderr, "Invalid stripes argument\n");
+					return 1;
+				}
+			} else {
+				args->send = args->sstart;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_STRIPES;
 		} else {
 			fprintf(stderr, "Unrecognized balance option '%s'\n",
 				this_char);
@@ -262,6 +277,15 @@ static void dump_balance_args(struct btrfs_balance_args *args)
 		       (unsigned long long)args->vend);
 	if (args->flags & BTRFS_BALANCE_ARGS_LIMIT)
 		printf(", limit=%llu", (unsigned long long)args->limit);
+	if (args->flags & BTRFS_BALANCE_ARGS_STRIPES) {
+		if (args->sstart == args->send) {
+			printf(", stripes=%llu", (unsigned long long)args->sstart);
+		} else {
+			printf(", stripes=%llu..%llu",
+			        (unsigned long long)args->sstart,
+			        (unsigned long long)args->send);
+		}
+	}
 
 	printf("\n");
 }
diff --git a/ioctl.h b/ioctl.h
index dff015a..c1f6aec 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -228,7 +228,11 @@ struct btrfs_balance_args {
 	__u64 flags;
 
 	__u64 limit;		/* limit number of processed chunks */
-	__u64 unused[7];
+
+	__u64 sstart;
+	__u64 send;
+
+	__u64 unused[5];
 } __attribute__ ((__packed__));
 
 /* report balance progress to userspace */
diff --git a/volumes.h b/volumes.h
index 4ecb993..a809a78 100644
--- a/volumes.h
+++ b/volumes.h
@@ -136,6 +136,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
+#define BTRFS_BALANCE_ARGS_STRIPES	(1ULL << 6)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
2.5.3

