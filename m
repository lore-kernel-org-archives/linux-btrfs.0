Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B55A3B27E1;
	Wed, 25 Mar 2026 10:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774433911; cv=none; b=UJm9/9TdKiBijbWSjF/f9NRTzctdjBLYYiaSjA9K/R3T3bY5/MV/R5WSPz93SaXNHY7tyu75NZK/sSwz92jzVpU/T7sAD99N3TJzkBnFaRW3ZfAMN9SOG0rgwHW/9UZmiwcd/Wvbiidtt04Ze2qF7KB4QfgSWTkwqJKmAQ46v84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774433911; c=relaxed/simple;
	bh=bpZFT3salaiFZC+jj4lXcOErGa026Bzt0UzUhLGGNkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HJeaEDIpJ2jZtmgKEgqvPdfbQvIHIkwSZDf5prz3sxtG89VRYE4LjUYJ3ymOfIuuKe5EJBrOd3Tjc9JtM0ka1pWVRUMl3l5Lr+pSi68P1xQFqa0ZJOskgDaK32qHUFIzCSGC965GEY8WxQWDn9vkCeZxiI0cf/iD4Kht9gE7dcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=gxY+xIBU; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="gxY+xIBU"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1774433901; bh=bpZFT3salaiFZC+jj4lXcOErGa026Bzt0UzUhLGGNkQ=;
	h=From:To:Cc:Subject:Date;
	b=gxY+xIBUk73cTs8CL+LerPdV7cMGTkDp9l3p/Dtot/UxjNIdA0GLQxbsU1o1ol1EI
	 tg8p2geZGZUnN61tOYrCmcHM+VFDOJU7EdIlD5hini34L16fCMFu+f6FpSWh+SC9Cr
	 jeqbhyHQQSHajZO2e8R+Cl8TkPaT1Qe8jTwBRHyk=
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	robbieko <robbieko@synology.com>
Subject: [PATCH] btrfs: fix incorrect return value after crossing leaf boundary in lookup_extent_data_ref
Date: Wed, 25 Mar 2026 18:18:15 +0800
Message-ID: <20260325101818.3474340-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
Content-Type: text/plain

After commit 1618aa3c2e01 ("btrfs: simplify return variables in
lookup_extent_data_ref()"), the err and ret variables were merged into
a single ret variable. However, when btrfs_next_leaf() returns 0
(success), ret is overwritten from -ENOENT to 0. If the first key in
the next leaf does not match (different objectid or type), the function
returns 0 instead of -ENOENT, making the caller believe the lookup
succeeded when it did not. This can lead to operations on the wrong
extent tree item, potentially causing extent tree corruption.

Fix this by returning -ENOENT directly when the key does not match,
instead of relying on the ret variable.

Fixes: 1618aa3c2e01 ("btrfs: simplify return variables in lookup_extent_data_ref()")
Signed-off-by: robbieko <robbieko@synology.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 85ee5c79759d..098e64106d02 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -495,7 +495,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		if (key.objectid != bytenr ||
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
-			return ret;
+			return -ENOENT;
 
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
