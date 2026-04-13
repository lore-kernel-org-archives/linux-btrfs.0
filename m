Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D691A389E08
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063183; cv=none; b=mNwAObiHvqr+5k4RYahmb1JwLgwqV/3dO5AvA+XadcnzAjTyjdfnLmi474NRNsbj4GxMr2QPGbzQE6PmFIxkEZMuR56DKkygpxZ/o+Y3FWoZcKWaC9v1wGFcXCC0yXWu+1uV87SYtA7p57tTljndHSAKxhhyrBiN8SzPkenu6sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063183; c=relaxed/simple;
	bh=03xg7AwkuLI4uZHHBqyJ91Z5rTCX4uBt2m23ENSNUvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4dCWPwFTqLHgBjE7S7aGlz132EgntmT+NW+sp0QbGtNy4wBrJAwCYL6lx5s5yHqBz7s6QNmoFFWJchmDgl6V1xTwrO5+1wvDM3bM+YGbtYhyqHny6EHVn5bj5FsJi+xgL/lEDGsBpM9aheKsasF7/WqQO0xBeGsayC0v/jGjqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=rWvoDpUK; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="rWvoDpUK"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776063180; bh=03xg7AwkuLI4uZHHBqyJ91Z5rTCX4uBt2m23ENSNUvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWvoDpUKPPf3Hfixyo5LBK5MfTrSCndJEKMSK4VOKWPYbndJhbGzKgUiLIF9wJJ1/
	 DO30RoUrruJqFULlWFdHv/VnTR5q7GQM3SnC8CyprUNh9rzacfepafkDYUFqa6E5Mr
	 Enn6QtWhLQHA12aYKEklo2gbDsuVQWpgggHSUxcI=
To: linux-btrfs@vger.kernel.org
Cc: robbieko <robbieko@synology.com>
Subject: [PATCH 2/6] btrfs: fix raid stripe search missing entries at leaf boundaries
Date: Mon, 13 Apr 2026 14:52:33 +0800
Message-ID: <20260413065249.2320122-3-robbieko@synology.com>
In-Reply-To: <20260413065249.2320122-1-robbieko@synology.com>
References: <20260413065249.2320122-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
Content-Type: text/plain

In btrfs_delete_raid_extent(), the search key uses offset=0. When the
target stripe entry is the first item on a leaf, btrfs_search_slot()
may land on the previous leaf and decrementing the slot from nritems
still points to the wrong entry, causing the stripe extent to be
silently missed.

Fix this by searching with offset=(u64)-1 instead. Since no real stripe
entry has this offset, btrfs_search_slot() always returns 1 with the
slot pointing past the last matching objectid entry. Then unconditionally
decrement the slot with a proper slots[0]==0 early-exit check to handle
the case where no matching entry exists.

Signed-off-by: robbieko <robbieko@synology.com>
---
 fs/btrfs/raid-stripe-tree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 5c519e161331..d35efe74aa1b 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -98,14 +98,26 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 	while (1) {
 		key.objectid = start;
 		key.type = BTRFS_RAID_STRIPE_KEY;
-		key.offset = 0;
+		key.offset = (u64)-1;
 
 		ret = btrfs_search_slot(trans, stripe_root, &key, path, -1, 1);
 		if (ret < 0)
 			break;
 
-		if (path->slots[0] == btrfs_header_nritems(path->nodes[0]))
-			path->slots[0]--;
+		/*
+		 * Search with offset=(u64)-1 ensures we land on the correct
+		 * leaf even when the target entry is the first item on a leaf.
+		 * Since no real entry has offset=(u64)-1, ret is always 1 and
+		 * slot points past the last entry with objectid==start (or
+		 * past the end of the leaf if that entry is the last item).
+		 * Back up one slot to find the actual entry.
+		 */
+		if (path->slots[0] == 0) {
+			/* No entry with objectid <= start exists. */
+			ret = 0;
+			break;
+		}
+		path->slots[0]--;
 
 		leaf = path->nodes[0];
 		slot = path->slots[0];
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
