Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9091522301
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 02:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777428884; cv=none; b=hX35qAbNCjgnQ8QCqk1hB2k4sbqKWs7OprADNpawaF8DDQ1MYwNUqAgK9IW0od8kKeaErU+f7hnTCYI16fFrBzjg3XsTZ1bwl7f56tj6poI5IIGLmVri3sbeFYu7u8nHjWuw00UZ4J42S6i5JV9EZmx4a7CoI2MH3hQOiMOUAeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777428884; c=relaxed/simple;
	bh=RCQuawf9W4BkMWuEpUBM78NKZ3RafUVOwbTGY+A4MdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eC23syiSLrzAAKfpCYWtU6P4iLYltmW1Cr93NYofvBUe+jh7sX35bZFHJsz1OO7J+A0iImdVlYAtlw9/It4alBcd0i4GzNf5GT/ZWyEqVp0Be0scdeRO3D4zcfkuDelHtPKNBzHaPqrFIm7wS4JBtzaOrsBaI+iNCp1NfCRSEZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=GryqGFKi; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="GryqGFKi"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4g518V2mWszJDnVCJ;
	Wed, 29 Apr 2026 10:14:34 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1777428874; bh=RCQuawf9W4BkMWuEpUBM78NKZ3RafUVOwbTGY+A4MdQ=;
	h=From:To:Cc:Subject:Date;
	b=GryqGFKiypgFXglZWpgswdXLdDLCDWHv0NCyDj9FKAQnkrTdTvQM1QHJjdDFhr6kb
	 hhpn9nTBAyWR+23owi/Mov8b4iFJvL4oISDMWgzS7YiU8HQR6TWga2EvvjB4bhJ8/3
	 0SzhRjB8WGOiGeNpPNCml30XJqMO68x6mXWrjqJg=
From: Dave Chen <davechen@synology.com>
To: linux-btrfs@vger.kernel.org,
	dsterba@suse.com
Cc: cccheng@synology.com,
	Dave Chen <davechen@synology.com>
Subject: [PATCH] btrfs: fix fill_holes() to merge a new hole with both adjacent items
Date: Wed, 29 Apr 2026 10:13:51 +0800
Message-ID: <20260429021351.596972-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

fill_holes() currently merges a punched hole with either the previous
or the next file extent item, but never both in the same call.  When
holes are punched in a non-sequential order this leaves consecutive
hole items in the file extent tree that should have been collapsed
into a single one.

For example:

  fallocate -p -o 4K  -l 4K ${FILE}
  fallocate -p -o 12K -l 4K ${FILE}
  fallocate -p -o 8K  -l 4K ${FILE}

After the third punch the [4K, 8K) and [12K, 16K) holes become
adjacent to the new [8K, 12K) hole, but fill_holes() merges only one
side and leaves two separate hole items ([4K, 12K) and [12K, 16K))
instead of the expected single [4K, 16K) hole item.

Fix this by checking both path->slots[0] - 1 and path->slots[0] in one
pass:

  - If only the previous slot is mergeable, extend it forward as
    before.
  - If only the next slot is mergeable, extend it backward and update
    its key offset as before.
  - If both are mergeable, extend the previous item to cover the new
    hole plus the next item, and remove the redundant next item with
    btrfs_del_items().

Because the merge path may now delete an item, switch the initial
btrfs_search_slot() call from a plain lookup (ins_len = 0) to a
search-for-deletion (ins_len = -1), so the leaf is prepared for a
possible item removal.

Fixes: 2aaa66558172 ("Btrfs: add hole punching")
Signed-off-by: Dave Chen <davechen@synology.com>
---
 fs/btrfs/file.c | 48 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cf1cb5c4db757..84450452d2347 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2093,6 +2093,10 @@ static int fill_holes(struct btrfs_trans_handle *trans,
 	struct btrfs_file_extent_item *fi;
 	struct extent_map *hole_em;
 	struct btrfs_key key;
+	int modify_slot = -1;
+	int del_slot = -1;
+	bool update_offset = false;
+	u64 num_bytes = 0;
 	int ret;
 
 	if (btrfs_fs_incompat(fs_info, NO_HOLES))
@@ -2102,7 +2106,7 @@ static int fill_holes(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = offset;
 
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret <= 0) {
 		/*
 		 * We should have dropped this offset, so if we find it then
@@ -2115,33 +2119,43 @@ static int fill_holes(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	if (hole_mergeable(inode, leaf, path->slots[0] - 1, offset, end)) {
-		u64 num_bytes;
-
-		path->slots[0]--;
-		fi = btrfs_item_ptr(leaf, path->slots[0],
+		fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
 				    struct btrfs_file_extent_item);
 		num_bytes = btrfs_file_extent_num_bytes(leaf, fi) +
 			end - offset;
-		btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
-		btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
-		btrfs_set_file_extent_offset(leaf, fi, 0);
-		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
-		goto out;
+		modify_slot = path->slots[0] - 1;
 	}
-
 	if (hole_mergeable(inode, leaf, path->slots[0], offset, end)) {
-		u64 num_bytes;
-
-		key.offset = offset;
-		btrfs_set_item_key_safe(trans, path, &key);
 		fi = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_file_extent_item);
-		num_bytes = btrfs_file_extent_num_bytes(leaf, fi) + end -
-			offset;
+		if (modify_slot != -1) {
+			num_bytes += btrfs_file_extent_num_bytes(leaf, fi);
+			del_slot = path->slots[0];
+		} else {
+			num_bytes = btrfs_file_extent_num_bytes(leaf, fi) +
+				end - offset;
+			modify_slot = path->slots[0];
+			update_offset = true;
+		}
+	}
+	if (modify_slot >= 0) {
+		fi = btrfs_item_ptr(leaf, modify_slot,
+				    struct btrfs_file_extent_item);
 		btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
 		btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
+		if (update_offset) {
+			key.offset = offset;
+			btrfs_set_item_key_safe(trans, path, &key);
+		}
 		btrfs_set_file_extent_offset(leaf, fi, 0);
 		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
+		if (del_slot >= 0) {
+			ret = btrfs_del_items(trans, root, path, del_slot, 1);
+			if (ret) {
+				btrfs_release_path(path);
+				return ret;
+			}
+		}
 		goto out;
 	}
 	btrfs_release_path(path);
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
