Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51639 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752138AbdHRWRN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:17:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 5/7] Btrfs: remove BUG() in add_data_reference
Date: Fri, 18 Aug 2017 15:15:22 -0600
Message-Id: <20170818211524.31325-6-bo.li.liu@oracle.com>
In-Reply-To: <20170818211524.31325-1-bo.li.liu@oracle.com>
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we have a helper to report invalid value of extent inline ref
type, we need to quit gracefully instead of throwing out a kernel panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f0bef3c..53fc798 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3774,7 +3774,10 @@ int add_data_references(struct reloc_control *rc,
 			ret = find_data_references(rc, extent_key,
 						   eb, dref, blocks);
 		} else {
-			BUG();
+			ret = -EINVAL;
+			btrfs_err(rc->extent_root->fs_info,
+		     "extent %llu slot %d has an invalid inline ref type",
+			     eb->start, path->slots[0]);
 		}
 		if (ret) {
 			err = ret;
-- 
2.9.4

