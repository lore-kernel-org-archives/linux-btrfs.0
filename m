Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbbJMPnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 11:43:51 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Gabr=C3=ADel=20Arth=C3=BAr=20P=C3=A9tursson?=
	<gabriel@system.is>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 7/7] btrfs-progs: balance: add stripes filter
Date: Tue, 13 Oct 2015 17:42:40 +0200
Message-Id: <0d304408d62f90be68b319ee1d3799f8c283503b.1444750808.git.dsterba@suse.com>
In-Reply-To: <cover.1444750808.git.dsterba@suse.com>
References: <cover.1444750808.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gabríel Arthúr Pétursson <gabriel@system.is>

Add new balance filter 'stripes=<range>' to process only chunks that are
spread accross given number of chunks.

The range must be specified with both values, but they can be the same
to denote exact number of stripes.

Signed-off-by: Gabríel Arthúr Pétursson <gabriel@system.is>
[ reworked a bit to use the range helpers, dropped the single value
  for stripes ]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-balance.asciidoc |  4 ++++
 cmds-balance.c                       | 17 +++++++++++++++++
 ioctl.h                              |  4 +++-
 volumes.h                            |  1 +
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index 61517461ca90..6bb9fffdf188 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -114,6 +114,10 @@ The argument may be a single value or a range. The single value *N* means *at
 most N chunks*, equivalent to *..N* range syntax. Kernels prior to 4.4 accept
 only the single value format.
 
+*stripes*::
+Balances only block groups which have the given number of stripes. The
+parameter is a range specified as <start..end>.
+
 *soft*::
 Takes no parameters. Only has meaning when converting between profiles.
 When doing convert from one profile to another and soft mode is on,
diff --git a/cmds-balance.c b/cmds-balance.c
index 7aaf33d03630..a958e584eeb5 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -319,6 +319,19 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				args->flags &= ~BTRFS_BALANCE_ARGS_LIMITS;
 				args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
 			}
+			args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
+		} else if (!strcmp(this_char, "stripes")) {
+			if (!value || !*value) {
+				fprintf(stderr,
+					"the stripes filter requires an argument\n");
+				return 1;
+			}
+			if (parse_range_u32(value, &args->stripes_min,
+					    &args->stripes_max)) {
+				fprintf(stderr, "Invalid stripes argument\n");
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_STRIPES;
 		} else {
 			fprintf(stderr, "Unrecognized balance option '%s'\n",
 				this_char);
@@ -359,6 +372,10 @@ static void dump_balance_args(struct btrfs_balance_args *args)
 		printf(", limit=");
 		print_range_u32(args->limit_min, args->limit_max);
 	}
+	if (args->flags & BTRFS_BALANCE_ARGS_STRIPES) {
+		printf(", stripes=");
+		print_range_u32(args->stripes_min, args->stripes_max);
+	}
 
 	printf("\n");
 }
diff --git a/ioctl.h b/ioctl.h
index ff7a1a0610a1..50f9e1485a30 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -239,7 +239,9 @@ struct btrfs_balance_args {
 			__u32 limit_max;
 		};
 	};
-	__u64 unused[7];
+	__u32 stripes_min;
+	__u32 stripes_max;
+	__u64 unused[6];
 } __attribute__ ((__packed__));
 
 /* report balance progress to userspace */
diff --git a/volumes.h b/volumes.h
index cb6f5752cdda..150ea7f31659 100644
--- a/volumes.h
+++ b/volumes.h
@@ -137,6 +137,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
 #define BTRFS_BALANCE_ARGS_LIMITS	(1ULL << 6)
+#define BTRFS_BALANCE_ARGS_STRIPES	(1ULL << 7)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
2.6.1

