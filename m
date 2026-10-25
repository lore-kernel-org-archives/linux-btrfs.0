Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951393;
	b=NZoLq3LQL6L66GmwCZx7746MY73w+oIEjy54ZVsuTI4md9cvujeewTb0xQsLjR2bfphp
	 xpE4BnOf2Xp65qg8N4gCLX0EowVmYar4HVNAQCeu/6YHEJIwsW86ZoZaFQHa/r7B1HA4R
	 4ds47uWlQIxUhFiRTD9R8K3zB6R97/vxcCjJr9OsYRQvV33enMC13i/fwYX/dh+9qBxkc
	 3pCHguOX0JSRWMrhFNJGE4VRsl5Ly9JTaxnoRgv/F7EzoXnnIPylh/KxnExF+xNirlD1O
	 OtRl5hlJsyQgi+zn73flvG9L16MhT9mfgq8iJ8si6M0TYiP1ddlhWodw+E/kQpyapyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VG1kakSy/ebeV5Fcb7mxyA3cU1SZU5ucHZy7SeqjczM=;
	b=wUULt/ow75JljPnjWyDRFznGOK/XLvXpBz3j0uL157eX8ccRQDwmvCQA6UxzNZYsJuNy
	 lcWHKeodV/EJ2iGUDprOIRzSgwtanRoQkSoLxNb9/UdEWlJy7AZCg3v9X4cvSLLoj6TUP
	 t69r3CRc4VXiWD4w7TCSJjqmtnCW9yDS3Qi4woJf+w7BisvMISVdAykzCCD52QgKs/u6v
	 HoHTq/IOLA5aaC7pAWH8Kikw0zQQM6WjeVmGE3XJ/+KE/J8bLtxRt+5dHXZxyLLpLmde7
	 z8niVMWsjo2W2dWDX2OI3ddc1PoSx3WfkvhFQFfydg6ir+F7CTBmMKWITZmz7zEdC7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QJzyqzmN;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5F606A32C
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 18:03:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38F5F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QJzyqzmN
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-354ba08cfd1so4251085eec.1
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 11:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792951392; x=1793556192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VG1kakSy/ebeV5Fcb7mxyA3cU1SZU5ucHZy7SeqjczM=;
        b=QJzyqzmNSSDEj/DOGlwGG+4c7WgmcTkkbyWvUHwvOjDPxGmVDYZUkHuYJmeNxB4Xqx
         kmphu4T4TTx7qVzj+/JBEmCUOYRhpXX6kQRGEgfUJn1ICoY6sxMaoAih/bFPJpl3xzHT
         4OmKGdY4WEHqyMLIzXAko3Z9zUhVUKtcqLx7aJQkm1dHi8WqKvldaPviiDLtZJwI9+wP
         TLQbYb6wTRs+Api6ghoi+guDvptaThK3pK1S1Rmu0IrpvDEifFLmCtJq7rUFkZ4OxCgw
         gnL+AKpyj+IYHfqlFgecU0orKweeCrCyTWotJHsj6oUCvhAnTF1Xs0Xe3sUGe1ev9MAd
         EZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792951392; x=1793556192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VG1kakSy/ebeV5Fcb7mxyA3cU1SZU5ucHZy7SeqjczM=;
        b=zvirtdUTLcE4yTRiZ5TnoolnYrF77MTZcwspk/Xm98GMlm5rsKq0aQiIDF6nyUFQvZ
         U6BxlTx78iHhKFvko8dvnlXKQ/gNqvcSAj4fa7qJy/DIrjbGgvGg5E2UMD4Je3X0MR/t
         UfBpI71HWq0jz0/a3cC3kLmfTHmmR6nrk+Zg4j2V/U8ZOVOe+jUQ6vOMlLcgCIFIOZBB
         pvbqBK0TNZvC2j8tDE1H3bviw0exmzVT0EQSpWJ9EbpG2p37boZgL+UzXMwAv0p5OWFc
         6mY9h/l44tgjyTBqI/eU+I2aG1WTkrlNPbHYffZweTXm05CnSY6u0JbkWSGXlDViuq70
         aDRw==
X-Forwarded-Encrypted: i=1; AKwUvBwbOEKxnJVey5w1NZXZv+MLa6D6gDMNLvyGJeFl7scaUwn1msM4P4TEz8TvXhLAt898tbTJV/B75xrSQg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL3sJxvNS63koscUtMnWLpMdheyp9M8zrfIyuFAQX/4BHXRlKhe
	7+OkQyVA8hbuCtdbwnMGwHhY+om9woHLkn7yHnwsiKYMAsX3yZKdtZwI
X-Gm-Gg: AYBFou0a4eE8L9In5TPuLcOKQJ5IZaSJ12UmszmEQFIaqDp5/NArU5IjX255giQ4cpW
	fQD1+scgmizwVdYM0QlRR67kItmaMxRzPYo8cGkEObfcW93rCEm7tRM/ZG8ouPb1t72SAwmbQHh
	KX2hpGOP6bd6auvUz8GSmfuqoLaUUai5ZgMMMlvd3aKcA46EPn2L/Ae6JXfBUb8J5gIIXGufBwj
	3TtgPYAwVjuNQBwZwfHLFf/S3DBxBvJklJieDKjPK7KZ3aQqO2X/pmGRHpq3H05ehQ2w2cfvgD3
	X/isq4AVcErxOcZFRm9pJROn7dkIKvchgfWvcMgeACN1Ewp8vkcgVJcyaQNORLLo/OZukmHRZrC
	GdYfPv1unSaGko2We1a7+TbyIcmkCQtKFhxkEuENt1nPsCh/1dHJJr4+/CIBp5J59MZtmeD1itZ
	UK4myqdXmq2NK41NCqWAPMNYCyjChxM/SSGTDcFTIgiiNb1MifPsq1lY/wrOAnHpc6+ftI/zYN7
	NTzfF6D5/m5O8jNUk/OH0OhVDF1hwIeuVngolVpwzFW6Jtp8FXQvb0e6T0GFXGMTV/iV7+dvAUI
	IfTo8g8joghczgFHr5Nz
X-Received: by 2002:a05:7300:ccb0:b0:366:4c26:2968 with SMTP id 5a478bee46e88-369e84e560emr7285982eec.26.1792951391990;
        Sun, 25 Oct 2026 11:03:11 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8db7b23sm24657672eec.19.2026.10.25.11.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:03:11 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cheng Yongkang <teel4res@gmail.com>
Subject: [PATCH] btrfs: return an error for unrepaired RAID56 scrub sectors
Date: Sun, 25 Oct 2026 11:03:04 -0700
Message-Id: <20261025180304.349254-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
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

scrub_raid56_parity_stripe() returns the leftover value of
scrub_find_fill_first_stripe() (0 or 1) when it detects unrepaired
sectors in a data stripe.  Scrub callers only treat negative values as
errors, so the unrepaired state is masked as success and P/Q
regeneration is skipped; a device replace can then copy corrupted data.

Return -EIO so the unrepaired sectors are reported and the corrupt
stripe is not treated as healthy.

The masked-success behavior was reproduced 3/3 times: baseline scrub
returned 0 with "finished ... status: 0", left P/Q unregenerated, and a
device replace copied corruption.  With this change scrub returns -EIO
and the replace is canceled; healthy RAID1/RAID5 scrub still succeeds.

Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 479c0e0..ba2e27c 100644
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
2.34.1

