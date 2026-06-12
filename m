Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272142773C3
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781276439; cv=none; b=cRcU1tisiSeQp63PpR3CNwn7sHbNteNi31G+2W+kKYWsAFovatd/zuo2+1E/hzxxcw6kzgSRcyc07DRcpdBkMxRAHsr3MbLaoZwkMqI3V6n2PzuZtCbIZqXZJbwVLzp6BI2DPhwiZDzOC3Rn4FgcyNSXJ/FIxp8HBVc4AZJ8Xmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781276439; c=relaxed/simple;
	bh=6B1FPgq4l2oEAXsfLVMhJ7GrB1yBLuXaX4wZ6OSIfdU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=omuJyZomYO3lInT5APFSpWFY1PnF3BOxQ2CbU3Ib5H9VBmqzI4S8XyPG2+fgJz8YZiG+49J7czeHa4erTxeVkJ1fGKiakMm/1k5CG8t+CaprfVFIr6HUeJ2WsHF36xIiGFA6NY1zELTQJNL4FVUnO8xIj9oj50ax5x5X0Ifo80s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGOPgumm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGOPgumm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6376E1F000E9
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781276437;
	bh=2F4W6knxGFD8+46y1c/T0iDK2+3cjsizZSe2n6slY20=;
	h=From:To:Subject:Date;
	b=UGOPgummqKF1X8k2sbM3WD5TOW9j8xsHKewVXhWa4+dZrKtUk/4kVXBVIlloOuWfl
	 589DiATrPm32zHL2HQz+/ixNcaNn1KQeVpkR4iP5U7NOnmTnZhVhIFpIHkRG0LvaB9
	 GOnEe3nyM7BjTJRaw+GJvl8X40L3HV2M7vbBJCnbSY4CnD1SDXbXjkBWzkTpMSCKNZ
	 6/qfjRcxJC/9Ub+IAKZE97/Yh21DlxowMU0N9DJGwklt7a5jDSSkze28E9jw0YG2AU
	 PT4zTwkqz+PLlLXmfa2xALN9E0WVVgl+TnoUKki5OIUd616lsyQRTOYJ40KWtWRxfG
	 lmDFIYJNcfQKA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix copy_remapped_data() to not allocate more memory than intended
Date: Fri, 12 Jun 2026 16:00:35 +0100
Message-ID: <c7e85e62aa6ce8b00509a8534e8ecd93cf1fd773.1781276386.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The loop intends to copy the data in chunks up to 1M but we allocate the
pages array for the entire length and don't cap it to 1M. Fix this by
computing 'nr_pages' using 'copy_len' instead of 'length'.

While at it, also make 'nr_pages' and 'copy_len' const, as they never
change, to make the code more clear.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/relocation.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 00993505c9c3..e1dd9939f4f1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4109,10 +4109,10 @@ static int copy_remapped_data(struct btrfs_fs_info *fs_info, u64 old_addr,
 			      u64 new_addr, u64 length)
 {
 	int ret;
-	u64 copy_len = min_t(u64, length, SZ_1M);
+	const u64 copy_len = min_t(u64, length, SZ_1M);
 	struct page **pages;
 	struct reloc_io_private priv;
-	unsigned int nr_pages = DIV_ROUND_UP(length, PAGE_SIZE);
+	const unsigned int nr_pages = DIV_ROUND_UP(copy_len, PAGE_SIZE);
 
 	pages = kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
 	if (!pages)
-- 
2.47.2

