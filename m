Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A17391517
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063185; cv=none; b=NSbEc8uXIyboQ6YydRhD5nkn2G7H8BO0sRuOYgO7sbPfOJ/WZF9enA3CIVoJZFcN6nkNNVbJ10uuE+6kIoi2v7qo/jxe5CLpcBr+mODvUqC8lb2PkGjhRNJhUA68vuvDJgpMne5pp8TOzVl+JwUMdosrt7uqVXfB6QyRv3X9H30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063185; c=relaxed/simple;
	bh=7TxY/xlAIvXUDVHu+sW5jBSssB+It8ln+LmHZ056YdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Van7ekhPrHngYa1JBjiQ/xVuva+3pEjFp6/1lrlHWW1l9eIIao9W1U1IGoFBHrn/xOAsEKYJMURJd5NuQ+JRoJjrmOtA2s8dHD8GQclx6y7y1PORsAm+c3elokBEU2PM+Bli7ZoHFfWqLq8E5Gg7CN8d2MRBYB+6FfH5mu1VS7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=gTo6auqn; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="gTo6auqn"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776063174; bh=7TxY/xlAIvXUDVHu+sW5jBSssB+It8ln+LmHZ056YdQ=;
	h=From:To:Cc:Subject:Date;
	b=gTo6auqnz64o+oNqSF9zKj7Xiac98iwhkgq/ia5f+JwbksAbN9XwrVKYLWTif8QAG
	 k2DArHn3nSMNAigPEl78ByDNxtkL5/zVdkown4P/+YRWpgFGWN9EBBLjA2xd2jzPcu
	 5lWl+6TJcZcvhiiBNIsvzQZHqL/GcZl1SkxrK+ME=
To: linux-btrfs@vger.kernel.org
Cc: robbieko <robbieko@synology.com>
Subject: [PATCH 0/6] btrfs: fix multiple bugs in raid-stripe-tree deletion path
Date: Mon, 13 Apr 2026 14:52:31 +0800
Message-ID: <20260413065249.2320122-1-robbieko@synology.com>
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

This series fixes six bugs in fs/btrfs/raid-stripe-tree.c, all within the
stripe extent deletion and partial deletion code paths.

Patch 1 fixes btrfs_partially_delete_raid_extent() failing to copy the
devid when rebuilding a truncated stripe extent, resulting in zeroed-out
devids and corrupted stripe mappings.

Patch 2 fixes btrfs_delete_raid_extent() using offset=0 for the search
key, which can miss entries when the target is the first item on a leaf.
Changed to offset=(u64)-1 with proper boundary handling.

Patch 3 fixes btrfs_previous_item() being called with min_objectid=start,
which prevents finding the preceding stripe extent whose objectid is less
than start.

Patch 4 replaces an ASSERT(found_start <= start) with proper error
handling that returns -ENOENT, avoiding kernel panics on unexpected
B-tree states.

Patch 5 handles -EAGAIN from btrfs_duplicate_item() in the punch-a-hole
case and refreshes the stale leaf pointer after a potential leaf split.

Patch 6 adds return value checking for all three call sites of
btrfs_partially_delete_raid_extent() to avoid silently losing errors.

robbieko (6):
  btrfs: copy devid in btrfs_partially_delete_raid_extent()
  btrfs: fix raid stripe search missing entries at leaf boundaries
  btrfs: fix wrong min_objectid in btrfs_previous_item() call
  btrfs: replace ASSERT with proper error handling in stripe lookup
    fallback
  btrfs: handle -EAGAIN from btrfs_duplicate_item and refresh stale leaf
    pointer
  btrfs: check return value of btrfs_partially_delete_raid_extent()

 fs/btrfs/raid-stripe-tree.c | 57 +++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 12 deletions(-)

-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
