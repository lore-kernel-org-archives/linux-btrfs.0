Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45834 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946509AbdEZB1O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:27:14 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q1RDqQ003048
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1RDdx031348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:13 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1RDv4013237
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] Btrfs: add sanity check of extent item in scrub
Date: Thu, 25 May 2017 18:26:31 -0600
Message-Id: <20170526002631.8546-7-bo.li.liu@oracle.com>
In-Reply-To: <20170526002631.8546-1-bo.li.liu@oracle.com>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently scrub only verify checksum of both metadata and data and
couldn't detect an invalid extent_item.

This adds sanity check for extent item, now it can check if
extent_inline_ref_type is valid.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b0251eb..e87b752 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3058,6 +3058,39 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 	return ret < 0 ? ret : 0;
 }
 
+static int check_extent_item(struct extent_buffer *l, int slot,
+			     struct btrfs_extent_item *ei, int key_type)
+{
+	unsigned long ptr;
+	unsigned long end;
+	struct btrfs_extent_inline_ref *iref;
+	u64 flags = btrfs_extent_flags(l, ei);
+	int is_data = !!(flags & BTRFS_EXTENT_FLAG_DATA);
+	int type;
+
+	ptr = (unsigned long)(ei + 1);
+	if (!is_data &&
+	    key_type != BTRFS_METADATA_ITEM_KEY)
+		ptr += sizeof(struct btrfs_tree_block_info);
+	end = (unsigned long)ei +
+		btrfs_item_size_nr(l, slot);
+
+	while (1) {
+		if (ptr >= end) {
+			WARN_ON(ptr > end);
+			break;
+		}
+
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		type = btrfs_get_extent_inline_ref_type(l, iref, is_data);
+		if (type < 0)
+			return type;
+
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+	return 0;
+}
+
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct map_lookup *map,
 					   struct btrfs_device *scrub_dev,
@@ -3318,6 +3351,16 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				goto next;
 			}
 
+			/* sanity check for extent inline ref type */
+			if (check_extent_item(l, slot, extent, key.type)) {
+				btrfs_err(fs_info,
+					  "scrub: extent %llu(0x%llx) has an invalid extent inline ref type, ignored.",
+					  key.objectid, key.objectid);
+				spin_lock(&sctx->stat_lock);
+				sctx->stat.uncorrectable_errors++;
+				spin_unlock(&sctx->stat_lock);
+				goto next;
+			}
 again:
 			extent_logical = key.objectid;
 			extent_len = bytes;
-- 
2.9.4

