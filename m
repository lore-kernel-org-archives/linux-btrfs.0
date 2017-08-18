Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39337 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752167AbdHRWRN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:17:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 4/7] Btrfs: remove BUG() in print_extent_item
Date: Fri, 18 Aug 2017 15:15:21 -0600
Message-Id: <20170818211524.31325-5-bo.li.liu@oracle.com>
In-Reply-To: <20170818211524.31325-1-bo.li.liu@oracle.com>
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_print_leaf() is used in btrfs_get_extent_inline_ref_type, so
here we really want to print the invalid value of ref type instead of
causing a kernel panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/print-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fcae61e..0e52e47 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -121,7 +121,10 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 			       offset, btrfs_shared_data_ref_count(eb, sref));
 			break;
 		default:
-			BUG();
+			btrfs_err(eb->fs_info,
+				  "extent %llu has invalid ref type %d\n",
+				  eb->start, type);
+			return;
 		}
 		ptr += btrfs_extent_inline_ref_size(type);
 	}
-- 
2.9.4

