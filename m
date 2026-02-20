Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C4C2AD3D
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2026 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771587022; cv=none; b=Nz3ENVSZvImzwocktje44nRPIs421z0Ix7oFqARnIPjGQ3l5/zAglh3G8kZ1K9P2cGXlRNfgsz+ETO6Ee9Cm3C7s/z9axv4z/TRVoCjIg4tvVbHwDMUbr5F8M2dPQ+k2m1sRrj8d9hhssFPJVg1jZLxwEIdxwdw/ISAfLxvKBp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771587022; c=relaxed/simple;
	bh=DIkLSTXckAwhE3quikJ/nwLdfEwCGPOOQnBawKioQ5I=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=hXNquRVrz4RyEyVZRFmF5MMtCHOhQWei4wSQDWdyul8ophAf/WBTyMIv28q5KHgS0GBrfDpykozcHXUeItVJPX1N5h8ubuX+GNPWWBMARIAeI81ezN9DwKymEdd4yMSqaKd4mjta9CLSJfiNwSw22DY6Y0YqenrZUREa0roC8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=BLb+wWCx; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="BLb+wWCx"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id E6743304624;
	Fri, 20 Feb 2026 11:30:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1771587016;
	bh=BTsKLxnrN0bPp8OMfzGfvkal20dUU+TxMBadTcEL41k=;
	h=From:To:Cc:Subject:Date;
	b=BLb+wWCxR6K1QuVqM8+4hLV8ej6BiaI7i0Gy4m1K4s4KOy3JhAL60ph39v//FJitv
	 OfQOpYpP8SWOs+KOXcuc076J2TJi5Yhv7wb11kS9lrUfwZ+3DOhK1hSGHRgT346P/9
	 WX8vfFG7PEqMJ4gaoJsKwM2jowlLYR9YIWX+1amo=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org,
	wqu@suse.com
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: fix chunk offset error message in check_dev_extent_item()
Date: Fri, 20 Feb 2026 11:30:06 +0000
Message-ID: <20260220113013.30254-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a copy-paste bug in an error message in check_dev_extent_item():
we're reporting an incorrect offset, but actually printing the objectid.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index ac4c4573ee39..133510f99fc5 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1899,7 +1899,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 				 sectorsize))) {
 		generic_err(leaf, slot,
 			    "invalid dev extent chunk offset, has %llu not aligned to %u",
-			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    btrfs_dev_extent_chunk_offset(leaf, de),
 			    sectorsize);
 		return -EUCLEAN;
 	}
-- 
2.52.0

