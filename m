Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C486E364923
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 06:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063184; cv=none; b=c+5CGZ+j7xBVfK2ZZLB2OWNJm1miSGbKxHPzE65H2jvMTU5HZDxV4uwzKEmsRfLmELpNcz+1iH37E7vld148bpTmATsv2nCXr4Dm0Gh+GApRiHDqJEboHZg8eypCJTgz6fL2vfLhUNyctE/mOEwFWn69Xr8nE6WSD+yAowQNGEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063184; c=relaxed/simple;
	bh=X7CUHLiVSg9js1yegm2BHaa4RSX/hslALKB2PRbIOoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FxO7hsPsX2WP1XMSB9wg6j32QKuQiE2+5UmCYWlcwkAMdXWIGV84dyq3zaqAUTHZRpB7nHzh7HD6XjdcGABhcc/4utAA3M6cu08DqYAbFbbIzI9Un8t/0Z5zkRhXpy+gM4G7MBfGE8ydcdvc35U7yMxGdJgOV5ms3AsoRfechBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=TyFRq7pH; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="TyFRq7pH"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776063181; bh=X7CUHLiVSg9js1yegm2BHaa4RSX/hslALKB2PRbIOoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyFRq7pHFHAemZIn0HOAE1OEjt+F5sn1E9vVU0Ya957Z7W4RGfB+D5s0E9eQQq70/
	 Wr6QBPXJQu3Cw17qs6/QmIDghs++QvedWt5vzw4BeXFH3QlntH56c93VSy3Q6FNlcP
	 CUIBcXtvd33ccvuYzTWBfTr11f+Aif3tr7cdE1yE=
To: linux-btrfs@vger.kernel.org
Cc: robbieko <robbieko@synology.com>
Subject: [PATCH 3/6] btrfs: fix wrong min_objectid in btrfs_previous_item() call
Date: Mon, 13 Apr 2026 14:52:34 +0800
Message-ID: <20260413065249.2320122-4-robbieko@synology.com>
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

When found_start > start and slot == 0, btrfs_previous_item() is called
with min_objectid=start to find the previous stripe extent. However, the
previous stripe extent we are looking for has objectid < start (it starts
before our deletion range), so passing start as min_objectid prevents
finding it.

Fix by passing 0 as min_objectid to allow finding any preceding stripe
extent regardless of its objectid.

Signed-off-by: robbieko <robbieko@synology.com>
---
 fs/btrfs/raid-stripe-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index d35efe74aa1b..2f41cec637d4 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -138,7 +138,7 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
 		 */
 		if (found_start > start) {
 			if (slot == 0) {
-				ret = btrfs_previous_item(stripe_root, path, start,
+				ret = btrfs_previous_item(stripe_root, path, 0,
 							  BTRFS_RAID_STRIPE_KEY);
 				if (ret) {
 					if (ret > 0)
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
