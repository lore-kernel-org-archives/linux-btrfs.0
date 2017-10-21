Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47614 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932136AbdJUQtL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Oct 2017 12:49:11 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Sat, 21 Oct 2017 18:49:01 +0200
Message-Id: <20171021164901.11529-1-kilobyte@angband.pl>
Subject: [PATCH] btrfs: avoid misleading talk about "compression level 0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Many compressors do assign a meaning to level 0: either null compression or
the lowest possible level.  This differs from our "unset thus default".
Thus, let's not unnecessarily confuse users.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f9d4522336db..144fabfbd246 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -551,7 +551,9 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			      compress_force != saved_compress_force)) ||
 			    (!btrfs_test_opt(info, COMPRESS) &&
 			     no_compress == 1)) {
-				btrfs_info(info, "%s %s compression, level %d",
+				btrfs_printk(info, info->compress_level ?
+					   KERN_INFO"%s %s compression, level %d" :
+					   KERN_INFO"%s %s compression",
 					   (compress_force) ? "force" : "use",
 					   compress_type, info->compress_level);
 			}
-- 
2.15.0.rc1

