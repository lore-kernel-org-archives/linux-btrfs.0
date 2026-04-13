Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF60392C57
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 06:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063186; cv=none; b=W+qPdZPWDMLa3V5nBCYtx7t7+j9FhGVWSfpODp3RhO8MelpUd16pXJ/UwHOAsi+5ozitxSzy7qoyW+igzsy/y9IR7AT2xS659H9WOiO7/lCVQAsGH374AFLka9yz1YHLGMNE2jsHw5GQ8wD1AIpi/GYfcpZUdLUCgJaR2Lf5I/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063186; c=relaxed/simple;
	bh=BIoIL+5cQKyZ0i/aifos+3FU8G2CcskqMlLGdX2k/Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQs7ETCDQGRhuFan8yw3fxfJG8NeAivVYma8bFlEyoD33eb4hzEQxMhSMII8CicIdetGl9Q0HUC3JY4OqgffDxdPXiOypYFGXyWWe+0lK63nfRTmFw/XLX9WvGvr9oIK697xJNKJbmJ3Ep1VfeYsyvWyKrEixGBLAEVQcIYnng0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=dNpGPJQe; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="dNpGPJQe"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776063182; bh=BIoIL+5cQKyZ0i/aifos+3FU8G2CcskqMlLGdX2k/Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNpGPJQes2mAwz+i7OgKWHIUOUMEvT6wihWxk7lNYssbPf0uVzzYJ1uFaEQkybLL1
	 QXVx+2d5fJ9N7Fglrwtt4zQFZ7tB14fqB2Os4UDz9Qb5vktrF6U+bKA4iMoOi73ii1
	 l+WFptslemX7qXFe2HAvNaAbSPlwlydE/NJoHRUU=
To: linux-btrfs@vger.kernel.org
Cc: robbieko <robbieko@synology.com>
Subject: [PATCH 5/6] btrfs: handle -EAGAIN from btrfs_duplicate_item and refresh stale leaf pointer
Date: Mon, 13 Apr 2026 14:52:36 +0800
Message-ID: <20260413065249.2320122-6-robbieko@synology.com>
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

In the 'punch a hole' case of btrfs_delete_raid_extent(),
btrfs_duplicate_item() can return -EAGAIN when the leaf needs to be
split and the path becomes invalid. The old code treats any error as
fatal and breaks out of the loop.

Additionally, btrfs_duplicate_item() may trigger setup_leaf_for_split()
which can reallocate the leaf node. The code continues using the old
leaf pointer, leading to use-after-free or stale data access.

Fix both issues by:
- Handling -EAGAIN specifically: release the path and retry the loop.
- Refreshing leaf = path->nodes[0] after successful duplication.

Signed-off-by: robbieko <robbieko@synology.com>
---
 fs/btrfs/raid-stripe-tree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 5909ad35a1b0..1e8392a6c5a4 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -194,9 +194,19 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 
 			/* The "right" item. */
 			ret = btrfs_duplicate_item(trans, stripe_root, path, &newkey);
+			if (ret == -EAGAIN) {
+				btrfs_release_path(path);
+				continue;
+			}
 			if (ret)
 				break;
 
+			/*
+			 * btrfs_duplicate_item() may have triggered a leaf
+			 * split via setup_leaf_for_split(), so we must refresh
+			 * our leaf pointer from the path.
+			 */
+			leaf = path->nodes[0];
 			item_size = btrfs_item_size(leaf, path->slots[0]);
 			extent = btrfs_item_ptr(leaf, path->slots[0],
 						struct btrfs_stripe_extent);
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
