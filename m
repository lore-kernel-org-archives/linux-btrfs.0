Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAB13812FE;
	Tue, 14 Jul 2026 03:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783999768; cv=none; b=q1A6aiKwSoKpvU6FS/XdirZD9pGExs8qP9ab+1BYfwehW5F4zxacJqHlODyNBx3IkCGfQXZWUVfY3V7KLGDsbVLZC+tsMMMI77BTxG5cEPvcOxboIObZ4YYcsuLcoFaTrsIOwKAijecvdDaCq80jvaTYRzP9pSgK4DV+4w3qp3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783999768; c=relaxed/simple;
	bh=Ybb0lo/pQie1JRy4DnkGKEXpzXEG/DqyvhyLUo2loIE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=XukK9sRAFgNZl+TsFMO/W/Zm12yln1HZ9kNU5M77YYcGKrnfo2f1DwOsCMg0B3W9uVkomv1yz62PfMWxYlWHP73l5a/UEVrqXJmNTVET5N24MmOBiCbhLoA6g4PhSih2DPBpp0rSFwck4TOdZ8mYa24sDbjQaSehDC40sP8Zo1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=xuFK0id7; arc=none smtp.client-ip=203.205.221.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="xuFK0id7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783999755; bh=x3YFPqYulkzGRS7IgpvrQmkvKvQcBY/dmHArhbt5OI4=;
	h=From:To:Cc:Subject:Date;
	b=xuFK0id7DMwosCnjQzwLtB6PcllvuWZLLQR9xR3GOrh4Oib8xt/CZuuLZrwlEKGMB
	 zvT2FDnDhHeYutbzs5FVm9HzlvBVov5mW50uirRwj7Zkfq8Mvuh7+kgsJHAODmi2Kr
	 kEGtcJbSEHAIMx6fM4mVjtcvcnxvx4VcTev8wm8I=
Received: from ikun ([221.176.157.250])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 74B93286; Tue, 14 Jul 2026 11:29:11 +0800
X-QQ-mid: xmsmtpt1783999751t0wfz2fy0
Message-ID: <tencent_860054603C488A379E3D21126EA610D63108@qq.com>
X-QQ-XMAILINFO: MpYZqmNm/7vMjHZFhA1jjMTVnmzJGsaWhB2/E/6C4EevcVcW9JITgXyqTPH0SG
	 3K/gMAbpuTxY8uqRQ2snNf6tAA10m+F0i3TgXfgNHcj92Rc/cm80kg0vtlhBeP2YTWCgtYkRAu2U
	 nEVwMj+kz6Q3Gw02xfDn0Occ+EQz1mmHAqyE7eMqRAFDBnUGnK0RGMVtbeWfeZ9/f/tamEhnqjDq
	 2f7kny298ejGJBowP650XyI1nFieGR7n86HC+/DItUx0JBZnF9SqV9GeJPYSEC/WgjtNAaZ0f5uV
	 fTn/CBSamoIBFbj6EPOaKbog95scdHgQKgZsMgWcQDvbisi57Q3h8zsdLEOOF+QEMlBNQMjccByQ
	 pY5Y3Xn3ZDDcrDmV1xbfIpHyksBfbkDMtALHKSog6mG+IYt4t6C27AMSfhWVJQFy5refL/mAoJd2
	 9RAdWEZdf1+8DBZza8QSW9MXGRHorZx73QUQ+tkk13+n6R0y/Nx4ibmKlu6VqIj75Lws0/UG0Iuy
	 7+ezK+CNmwgSjPYAUWRBAIjwTo3D7Yb6VGDhs7tjkaXU6V7OTgxTKmiAcZZ6TIgDqqytVA8k7Tet
	 +zlCR1Nla5WQ8Xn1xMB014hog89NPpgs8xPYLOb83wXToED5GrhUxYLIqrZK7hTakyUt7dEzt3Qo
	 13JW1+sHkaXBET/9EK0GWCUG9wTm1LAgxPcN69P8x4THHqZl+7IsGQmENJZdMfSTTqkITgcbVtut
	 SVEDl0hhE+1f1Sv+2KqhUoKm8ycfOO57fHnUTYlbKXKTTeUdDsUSOG5l0ADtrenocksrxKpmkvYa
	 wDsUa3KeUtKq30KvPohd76TI8030Or6q8YyX0wGCpylB0X8nzf+TThokTyl4mAI6lZKXkB0AGq3Q
	 qZjJWdDYR69augOBszOnmJPZYNKQfYw9bdPAVDnSre3nXllWL7HT8hxMwL5+b2e+csIK/sbmRFoE
	 xpkGAHnarrYPs+IA6+VUDvqTy2of8ZRpEgBQ04o/iGKXHEeau01lnW4gBM0p9PDfEyZFldPlr0uK
	 hiq2ski/BjSpryngd+oX0Z0fBn4VeL9xYz7f15e1BDIl85wt4M
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	naohiro.aota@wdc.com,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: zoned: fix missing chunk metadata reservation
Date: Tue, 14 Jul 2026 11:29:08 +0800
X-OQ-MSGID: <20260714032908.595-1-3497809730@qq.com>
X-Mailer: git-send-email 2.52.0.windows.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

reserve_chunk_space() stores the return value of
btrfs_zoned_activate_one_bg() in ret. The helper can return 1 after
successfully activating a block group, but ret is later used to decide
whether to reserve metadata for chunk tree updates.

As a result, successful activation skips btrfs_block_rsv_add() and leaves
trans->chunk_bytes_reserved unchanged. Use a separate variable for the
activation result so positive success does not affect the later
reservation.

Fixes: b6a98021e401 ("btrfs: zoned: activate necessary block group")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/block-group.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ab76a5173272..00540b96c163 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4532,12 +4532,14 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		if (IS_ERR(bg)) {
 			ret = PTR_ERR(bg);
 		} else {
+			int activate_ret;
+
 			/*
 			 * We have a new chunk. We also need to activate it for
 			 * zoned filesystem.
 			 */
-			ret = btrfs_zoned_activate_one_bg(info, true);
-			if (ret < 0)
+			activate_ret = btrfs_zoned_activate_one_bg(info, true);
+			if (activate_ret < 0)
 				return;
 
 			/*

base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.52.0.windows.1

