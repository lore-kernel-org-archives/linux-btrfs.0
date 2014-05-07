Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaEGPiD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 11:38:03 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Ilya Dryomov <idryomov@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] btrfs-progs: balance filter: add limit of processed chunks
Date: Wed,  7 May 2014 17:38:00 +0200
Message-Id: <1399477080-15846-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add more control to the balance behaviour.

Usage filter may not be finegrained enough and can lead to moving too
many chunks at once. Another example use is in connection with
drange+devid or vrange filters that allow to work with a specific chunk
or even with a chunk on a given device.

The limit filter applies last, the value of 0 means no limiting.

CC: Ilya Dryomov <idryomov@gmail.com>
CC: Hugo Mills <hugo@carfax.org.uk>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-balance.c | 14 ++++++++++++++
 ioctl.h        |  4 +++-
 volumes.h      |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 8a743ecabd33..5de51bd463c4 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -218,6 +218,18 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 			args->flags |= BTRFS_BALANCE_ARGS_CONVERT;
 		} else if (!strcmp(this_char, "soft")) {
 			args->flags |= BTRFS_BALANCE_ARGS_SOFT;
+		} else if (!strcmp(this_char, "limit")) {
+			if (!value || !*value) {
+				fprintf(stderr,
+					"the limit filter requires an argument\n");
+				return 1;
+			}
+			if (parse_u64(value, &args->limit)) {
+				fprintf(stderr, "Invalid limit argument: %s\n",
+				       value);
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
 		} else {
 			fprintf(stderr, "Unrecognized balance option '%s'\n",
 				this_char);
@@ -252,6 +264,8 @@ static void dump_balance_args(struct btrfs_balance_args *args)
 		printf(", vrange=%llu..%llu",
 		       (unsigned long long)args->vstart,
 		       (unsigned long long)args->vend);
+	if (args->flags & BTRFS_BALANCE_ARGS_LIMIT)
+		printf(", limit=%llu", (unsigned long long)args->limit);
 
 	printf("\n");
 }
diff --git a/ioctl.h b/ioctl.h
index 9627e8d1bac6..f0fc06086c3e 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -194,7 +194,9 @@ struct btrfs_balance_args {
 
 	__u64 flags;
 
-	__u64 unused[8];
+	__u64 limit;
+
+	__u64 unused[7];
 } __attribute__ ((__packed__));
 
 struct btrfs_balance_progress {
diff --git a/volumes.h b/volumes.h
index b1ff3d04f931..8405aef2cc0a 100644
--- a/volumes.h
+++ b/volumes.h
@@ -130,6 +130,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
+#define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
-- 
1.9.0

