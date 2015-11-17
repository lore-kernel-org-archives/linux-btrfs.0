Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:50468
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbKQL3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Nov 2015 06:29:34 -0500
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: [PATCH] Fix balance regression in 4.4-rc
Message-ID: <564B0F9C.6060707@googlemail.com>
Date: Tue, 17 Nov 2015 12:29:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a regression in 4.4-rc since commit bc3094673f22
(btrfs: extend balance filter usage to take minimum and maximum) in that
existing (non-ranged) balance with -dusage=x no longer works; all chunks
are skipped.

After staring at the code for a while and wondering why a non-ranged
balance would even need min and max thresholds (..which then were not
set correctly, leading to the bug) I realized that the only problem
was the fact that the filter functions were named wrong, thanks to
patching copypasta. Simply renaming both functions lets the existing
btrfs-progs call balance with -dusage=x and now the non-ranged filter
function is invoked, properly using only a single chunk limit.

Signed-off-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Fixes: bc3094673f22 ("btrfs: extend balance filter usage to take minimum and maximum")
---
--- linux-4.1.13/fs/btrfs/volumes.c	2015-11-16 22:34:27.475045363 +0100
+++ linux-4.1.13-filters/fs/btrfs/volumes.c	2015-11-17 12:08:41.308898665 +0100
@@ -3189,7 +3189,7 @@
 	return 1;
 }
 
-static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 			      struct btrfs_balance_args *bargs)
 {
 	struct btrfs_block_group_cache *cache;
@@ -3222,7 +3222,7 @@
 	return ret;
 }
 
-static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info,
+static int chunk_usage_filter(struct btrfs_fs_info *fs_info,
 		u64 chunk_offset, struct btrfs_balance_args *bargs)
 {
 	struct btrfs_block_group_cache *cache;
