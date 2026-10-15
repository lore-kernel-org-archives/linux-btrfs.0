Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BC449F129
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086542; cv=none; b=otoZhAXxjPKejLeGCXIY/8JwYgdkRarMLVHVLp7GpR4+WCpj7hGJUtSB6MNxXIegdufx7c1ENVoCrtIdQ0lpVux3QgNQfX0ZoPN6ylXnDOBS/E9jnsJSbmR4oi0JYK3VP0+iJChf67WWaAyykCIrDBCllxz8n8fUto069dEWric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086542; c=relaxed/simple;
	bh=yu6f92WJpA35/EhqyWwcAuXp/+Zwk4sy897K0IWGrds=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=a9a0MZiyvPlXg2+YldaMb9pd6UZ9tcI2RzgS+1B9LSw7vMDUoEDXXzyLXvbE8pitkRB6RXSuXn1QtIOgt3Wb8UheWe8FeV/rhDnvnN9f31xjSR9Ooc4zg4WKcX5oH7wiNg42247408MhQbMWfSg9i2/daswnt/dEqd+JFAKp07I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQwH8o60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQwH8o60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617091F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792086534;
	bh=jaPlX2wPe0vNs76sfMZMoXjeU5SncJ/bthEgtQbK9p4=;
	h=From:To:Subject:Date;
	b=dQwH8o60VVJduUhoI4hYYVz4nOg44x78Q3Ew9MFzr56zQT4HGex6bb4fizGGK7Ubb
	 nZ70qbkuocxV93dh/PadzQ5X5qMLJ1vhyR+qPllSknR5EbhlNVCrMchcLR2d7lZjxH
	 r7hjjZ9OpPj7t+QiXdlG1XRkYXKIxhT13eDwzxrCVux1Feaz7fZhACGkzPC04FzScg
	 VV4fhAvGbbG2dVw55aDnVOxFdDEmC96bVlVRciRV4QfysEVL6S+denP1mSKM4BLVx2
	 e/nUkpmruYf9CAQRjXIt7tEWP+aVR9FjmyW8hWaF2S+x3ydt8VB5rVQWlLmW2xAyUn
	 ztR2NVomAxN8A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: scrub: fix lost error return value when scrubbing raid56 parity stripe
Date: Thu, 15 Oct 2026 18:48:52 +0100
Message-ID: <ce83d31f7e25d1f3953fb84cdb3e379aee1864d9.1792086517.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we findnd errors we are returning the value of 'ret', which has a value
of 0 from some previous function call that succeeded, instead of returning
an -EIO error. Fix this by returning -EIO instead of 'ret'.

Fixes: fab0c0f03cfd ("btrfs: introduce BTRFS_PATH_AUTO_RELEASE() helper")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 479c0e037015..ba2e27cc5351 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2250,7 +2250,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 "scrub: unrepaired sectors detected, full stripe %llu data stripe %u errors %*pbl",
 				  full_stripe_start, i, stripe->nr_sectors,
 				  &error);
-			return ret;
+			return -EIO;
 		}
 		bitmap_or(&extent_bitmap, &extent_bitmap, &has_extent,
 			  stripe->nr_sectors);
-- 
2.53.0

