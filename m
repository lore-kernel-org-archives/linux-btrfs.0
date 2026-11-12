Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794515559;
	b=O8uHVh5JlC/f3awUiDjl5oRxzxKZsDHvfazd79A+3k0k6qM/eMm8wMw5/sQ/JySBxaiX
	 +WqNNbTWvVSAueqTUxH7huuukaRY/BMkeJsXJAF7LZI+oB1ARz0v79qYQxY6ZZpdQJlBs
	 A9Vg3lYJA6tQKhu0yUNWZ1xTgc5mtTvmIWcu5xfz+ks8gkTihBxeUC22zl2CWpj/X2VHE
	 5Ed86fWfhHXFZoOyH9QYTHj3PoO1iAS5g0o2cnakfhFKAiz8TyAbf1MvD6X9MQHwi6PnX
	 C80ymtgwqh0PBH9ZCcAbvWmaU5Bg3woEA/oOi5VCZEi/wSxoagfZfJYkETRYKIOJH0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794515559;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NdYY1Vjz8VrlrRLxTJZR7Qna/ZoG8DVk/ueF1oJdnWU=;
	b=X1SWDoa6QlWG86BVYKNnnVl0bL+TMiu3Hhy7H2isf38gakNJPfLf8RsbwD0z3/dgUiXw
	 gl1EeoHDypkHoqGauqddfOwxMuG8lOq2HW58EeqRW7FGx24xesJcK0h+Nl5Y1h3jTtec1
	 q/8W/0aAmpQu9ts5bvhskDUbktNbeQU/L080j+95T4c4ZBluCQLCKvVA1LeDNN9VeZGCR
	 rxaS36/n2Q+zBG/UNW2tfr4fMS2zh3iGkKr7O3DKcZbFJvR+ichF2t5O2ej7+5sFj5GdN
	 aK6u148sTE3BMyciAz9Kz9NCauvXzKbqgJtPahg0y1FMB7hFPKn3EyW/+SVQSUAsY6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OOvkigqh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D719606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 20:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OOvkigqh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92B11F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 20:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794515559;
	bh=NdYY1Vjz8VrlrRLxTJZR7Qna/ZoG8DVk/ueF1oJdnWU=;
	h=From:To:Subject:Date;
	b=OOvkigqhENTt6womvqCZrx8xw6Flmw35wlZC4pf46X/fTwNQhMWd32Q65g6Wrztfc
	 jMPvU/91sX7jfTvYxARzYaXrhYTnkmUhGX8GFo4y6kN2Da5eXeyIs5iNkuXOW3vxKU
	 CRq/BAGlpW3DC38THDMZWXnowOa3X6CNeOOPLAEwjq0/395XxKcAuZy0Sah/yD5G4+
	 f+ydS0XmN1QNL6n1oq5NpAgFO/hMkFuhyjkZD8Xw1LDJOlnkx9s8U2X9cKeU9TYG6c
	 AQXT3jVYTnL7OtgPsmTSgMUxdIMThrDYf4HDtJBGGNEoyu5crirhToiFKjv9pSZlx1
	 36Vvl4ee2bt8g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix double release of space when cloning compressed inline extent
Date: Thu, 12 Nov 2026 20:32:25 +0000
Message-ID: <74b6b5edcf6a3c1105cc660809c2e4c8a9049b4d.1794515528.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In copy_inline_to_page(), if we fail to decompress the inline extent, we
jump to the out_unlock label and release the reserved data and metadata
space with a call to btrfs_delalloc_release_space(). However we leave the
range in the inode's io_tree maked as delalloc, which was set by
btrfs_reset_extent_delalloc(), and that means when someone later clears
the delalloc range, using EXTENT_DO_ACCOUNTING (like
btrfs_reset_extent_delalloc() does), it will release again the space.

This does not happen for uncompressed inline extents, because after the
call to btrfs_reset_extent_delalloc() we can't get any other errors.

Link: https://sashiko.dev/#/bug/linux-52478dd4-bd10-48de-baba-a527b38b64aa
Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline extents")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/reflink.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 5154db82ef3e..ecef21773027 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -120,8 +120,21 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
 		ret = btrfs_decompress(comp_type, data_start, folio,
 				       offset_in_folio(folio, file_offset),
 				       inline_size, datal);
-		if (ret)
+		if (ret) {
+			/*
+			 * btrfs_reset_extent_delalloc() set the range as
+			 * delalloc, so clear it, otherwise we will free the
+			 * reserved data and metadata space twice, once below by
+			 * btrfs_delalloc_release_space() and once again when
+			 * someone else clears the delalloc range with
+			 * EXTENT_DO_ACCOUNTING (like
+			 * btrfs_reset_extent_delalloc() does).
+			 */
+			btrfs_clear_extent_bit(&inode->io_tree, file_offset,
+					       range_end, EXTENT_DELALLOC |
+					       EXTENT_DELALLOC_NEW, NULL);
 			goto out_unlock;
+		}
 		flush_dcache_folio(folio);
 	}
 
-- 
2.53.0

