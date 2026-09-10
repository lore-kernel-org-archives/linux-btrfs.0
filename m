Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CCA379C38
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059055; cv=none; b=RTmcejVPMQi0V9VA819cnp3IEW4X2WsFaMIH4/SS4TeYlRr/diXFQzDs4oNkFHwHMDO1BatcgoF5WHAHucV9nz1iKMuiZvOONOwbRLI3JXB7R7T/dpsvJ68ncMLL/QRjFSEIPKaHinMNuuLwBav0AUzCNykJcOy2nqZd338LErI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059055; c=relaxed/simple;
	bh=/SAYzV3chLHvXPcO5hTMbzZskndzrnHMLlWWEKKXGtk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UUX6TTgrwhr5xvSoAqT6x7vqFv/L0Plj2AdPTb7CPoOQ9In2uyQ9rPGTU1nZB0u4hPQP8DHSmrVWbfTvb/75HUeae8jKdzYyy9FqtSZQFt+vWwQr+xhOyE0zm3dPausN9NlL9+7iVX//XS5tMMaFgsyTwOgn/fX0VDLowJxbxZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlg/nJnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlg/nJnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A096E1F000FF
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789059053;
	bh=MIwdk8GpvNjXWFI402wmkOFklgliTfz1u11TbApNZjI=;
	h=From:To:Subject:Date;
	b=mlg/nJnvKSJ1huMqfgPlEEIeAX+3G9WcS5us34DjxXhnRxHvtMqVQwLhOCrcGrFEA
	 TH7lVMFQsAI6mCAXRP08jb1yTbIEKOh6lmY24kPSYV2ws7G2NZZfiF4tM3fg87u10V
	 57a/0EeBQTdIsHzkGsm/EASxDgbweltav3rMF/sRT/wS6cIClfidalz0wTZ9x0vfgN
	 dubMS+DxijHJezVHf/WuBMl8Jd0Dyz5++8+r54seEvxBvMFAuvz2X29qDr0HKIMXcI
	 L5ZabCdl33VkvXuuinK7vLm+8ntTHSvUZJrSy4yVxpHbCyEStxaWY1rzzK95y7lAi6
	 CbFxapYtZCwKA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: fix error message regarding free space extent items
Date: Thu, 10 Sep 2026 17:50:50 +0100
Message-ID: <bfefcaf172db8da00666b85907b965603c22d821.1789059038.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The error message mentions a free space info item, but we are processing a
free space extent item, so fix the message.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 63eea0852ceb..857ded43c3b9 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2348,7 +2348,7 @@ static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key
 
 	if (unlikely(btrfs_item_size(leaf, slot) != 0)) {
 		generic_err(leaf, slot,
-			    "invalid item size for free space info, has %u expect 0",
+			    "invalid item size for free space extent, has %u expect 0",
 			    btrfs_item_size(leaf, slot));
 		return -EUCLEAN;
 	}
-- 
2.47.2

