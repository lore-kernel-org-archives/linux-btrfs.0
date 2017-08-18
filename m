Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51636 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdHRWRN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:17:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 3/7] Btrfs: remove BUG() in btrfs_extent_inline_ref_size
Date: Fri, 18 Aug 2017 15:15:20 -0600
Message-Id: <20170818211524.31325-4-bo.li.liu@oracle.com>
In-Reply-To: <20170818211524.31325-1-bo.li.liu@oracle.com>
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that btrfs_get_extent_inline_ref_type() can report if type is a
valid one and all callers can gracefully deal with that, we don't need
to crash here.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 714e779..38b0735 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1799,7 +1799,6 @@ static inline u32 btrfs_extent_inline_ref_size(int type)
 	if (type == BTRFS_EXTENT_DATA_REF_KEY)
 		return sizeof(struct btrfs_extent_data_ref) +
 		       offsetof(struct btrfs_extent_inline_ref, offset);
-	BUG();
 	return 0;
 }
 
-- 
2.9.4

