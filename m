Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663AbbJPQTR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:19:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A2EBCAABE
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:19:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/8] btrfs-progs: extend balance args to take min/max limit filter
Date: Fri, 16 Oct 2015 18:18:05 +0200
Message-Id: <04557a28dc8ed2784351f26e132d40fbc16d11e1.1445011409.git.dsterba@suse.com>
In-Reply-To: <cover.1445011409.git.dsterba@suse.com>
References: <cover.1445011409.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the overlapping limit and [limit_min, limit_max] members to the
balance args. The min/max values are interpreted iff the corresponding
flag BTRFS_BALANCE_ARGS_LIMITS is set.

Note that the values are only 32bit, but this should be enough for the
foreseeable future.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-balance.asciidoc |  4 ++++
 cmds-balance.c                       |  4 ++++
 ioctl.h                              | 13 ++++++++++++-
 volumes.h                            |  1 +
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index 6d2fd0c36086..61517461ca90 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -109,6 +109,10 @@ parameters.
 Process only given number of chunks, after all filters apply. This can be used
 to specifically target a chunk in connection with other filters (drange,
 vrange) or just simply limit the amount of work done by a single balance run.
++
+The argument may be a single value or a range. The single value *N* means *at
+most N chunks*, equivalent to *..N* range syntax. Kernels prior to 4.4 accept
+only the single value format.
 
 *soft*::
 Takes no parameters. Only has meaning when converting between profiles.
diff --git a/cmds-balance.c b/cmds-balance.c
index 3166d7a73ba2..148039bdc503 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -345,6 +345,10 @@ static void dump_balance_args(struct btrfs_balance_args *args)
 		       (unsigned long long)args->vend);
 	if (args->flags & BTRFS_BALANCE_ARGS_LIMIT)
 		printf(", limit=%llu", (unsigned long long)args->limit);
+	if (args->flags & BTRFS_BALANCE_ARGS_LIMITS) {
+		printf(", limit=");
+		print_range_u32(args->limit_min, args->limit_max);
+	}
 
 	printf("\n");
 }
diff --git a/ioctl.h b/ioctl.h
index dff015a52b43..ff7a1a0610a1 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -227,7 +227,18 @@ struct btrfs_balance_args {
 
 	__u64 flags;
 
-	__u64 limit;		/* limit number of processed chunks */
+	/*
+	 * BTRFS_BALANCE_ARGS_LIMIT with value 'limit'
+	 * BTRFS_BALANCE_ARGS_LIMITS - the extend version can use minimum and
+	 * maximum
+	 */
+	union {
+		__u64 limit;		/* limit number of processed chunks */
+		struct {
+			__u32 limit_min;
+			__u32 limit_max;
+		};
+	};
 	__u64 unused[7];
 } __attribute__ ((__packed__));
 
diff --git a/volumes.h b/volumes.h
index 4ecb99314a0c..cb6f5752cdda 100644
--- a/volumes.h
+++ b/volumes.h
@@ -136,6 +136,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
+#define BTRFS_BALANCE_ARGS_LIMITS	(1ULL << 6)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
2.6.1

