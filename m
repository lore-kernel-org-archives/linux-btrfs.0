Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:59396 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163530AbeCBCKE (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 1 Mar 2018 21:10:04 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs: Show more accurate max_inline
Date: Fri,  2 Mar 2018 10:09:48 +0800
Message-Id: <20180302020948.24816-3-wqu@suse.com>
In-Reply-To: <20180302020948.24816-1-wqu@suse.com>
References: <20180302020948.24816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs shows max_inline option into kernel message, but for
max_inline=4096, btrfs won't really inline 4096 bytes inline data if
it's not compressed.

Since we have unified the behavior and now BTRFS_MAX_INLINE_DATA_SIZE()
should handle most of the condition check, just limit
fs_info->max_inline to BTRFS_MAX_INLINE_DATA_SIZE(), so we could have
more accurate max_inline output.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3a4dce153645..6685016bc0ec 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -618,8 +618,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 
 				if (info->max_inline) {
 					info->max_inline = min_t(u64,
-						info->max_inline,
-						info->sectorsize);
+					info->max_inline,
+					BTRFS_MAX_INLINE_DATA_SIZE(info));
 				}
 				btrfs_info(info, "max_inline at %llu",
 					   info->max_inline);
-- 
2.16.2

