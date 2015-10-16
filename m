Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665AbbJPQTV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 12:19:21 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E2E4EAABE
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2015 16:19:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 7/8] btrfs-progs: balance: enhance the limit fiter with range
Date: Fri, 16 Oct 2015 18:18:09 +0200
Message-Id: <11f6aeccaa3e2432807b3985eda10743d1531a92.1445011409.git.dsterba@suse.com>
In-Reply-To: <cover.1445011409.git.dsterba@suse.com>
References: <cover.1445011409.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can do more with the balance filer. Enhance it so we can specify also
the minimum number of block groups to process. The 'limit' filter now
accepts a range (a..b, can be partial) and needs kernel support.

The 'limit=value' filter is equivalent to 'limit=..value' but works on
older kernels as well.

The min/max values are 32bit, unlike the single-value limit which is
64bit.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-balance.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 148039bdc503..05d48651b0b7 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -304,11 +304,19 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				return 1;
 			}
 			if (parse_u64(value, &args->limit)) {
-				fprintf(stderr, "Invalid limit argument: %s\n",
-				       value);
-				return 1;
+				if (parse_range_u32(value, &args->limit_min,
+							&args->limit_max)) {
+					fprintf(stderr,
+						"Invalid limit argument: %s\n",
+					       value);
+					return 1;
+				}
+				args->flags &= ~BTRFS_BALANCE_ARGS_LIMIT;
+				args->flags |= BTRFS_BALANCE_ARGS_LIMITS;
+			} else {
+				args->flags &= ~BTRFS_BALANCE_ARGS_LIMITS;
+				args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
 			}
-			args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
 		} else {
 			fprintf(stderr, "Unrecognized balance option '%s'\n",
 				this_char);
-- 
2.6.1

