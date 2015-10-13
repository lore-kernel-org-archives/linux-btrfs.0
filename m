Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbbJMPnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 11:43:47 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 51D25ACA0
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 15:43:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/7] btrfs-progs: balance: enhance the limit fiter with range
Date: Tue, 13 Oct 2015 17:42:37 +0200
Message-Id: <97da57b00a505d6501e2325fa3ab2802c7a461f4.1444750808.git.dsterba@suse.com>
In-Reply-To: <cover.1444750808.git.dsterba@suse.com>
References: <cover.1444750808.git.dsterba@suse.com>
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
 cmds-balance.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 1eadba417abc..7aaf33d03630 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -301,12 +301,24 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 					"the limit filter requires an argument\n");
 				return 1;
 			}
-			if (parse_u64(value, &args->limit)) {
-				fprintf(stderr, "Invalid limit argument: %s\n",
-				       value);
-				return 1;
+			/*
+			 * Try to parse the range first. A single value is not
+			 * a valid range
+			 */
+			if (parse_range_u32(value, &args->limit_min,
+					    &args->limit_max) == 0) {
+				args->flags &= ~BTRFS_BALANCE_ARGS_LIMIT;
+				args->flags |= BTRFS_BALANCE_ARGS_LIMITS;
+			} else {
+				if (parse_u64(value, &args->limit)) {
+					fprintf(stderr,
+						"Invalid limit argument: %s\n",
+					       value);
+					return 1;
+				}
+				args->flags &= ~BTRFS_BALANCE_ARGS_LIMITS;
+				args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
 			}
-			args->flags |= BTRFS_BALANCE_ARGS_LIMIT;
 		} else {
 			fprintf(stderr, "Unrecognized balance option '%s'\n",
 				this_char);
-- 
2.6.1

