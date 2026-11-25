Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610586;
	b=f1hyLuxbezZTNCe+yA2N96dSoRfXiGSGLuZZrSkB/LoqRXh0pHlVY95dA9s+8mDqQVLm
	 63zuOEnnsd8L7gSWaKAQM0fHIoPt9gjV1Meo69tfRPvOg/D631lz6n28eYxMPVBDfWC4E
	 WDbUYiQ9GiLrvuJUVpuaaPtfzSeIyx7k8cu6RwTm2KfKDUirHY6zy+4z07kcM6G3RCc0z
	 h65hkacfjJM3H9bYrqpRaMNpdQdHnyPPWa3dMJewXblEUnZF/ncam/peqQmFnJWqCLWLo
	 lI79HwLGuR/o1fjpInjYya6MO99TUynDrr3EspKnagamgouVCduhzFk9B4ry2efOuCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=C49vS/Al7l33SYN7twzz9Qk/hUst+FFoZ0xVaRrzVNI=;
	b=nGTOVnCkmRHx+s2ksbjvy/HaE+0IX+H25ZD1H0WN3MnE2XnkkzyRpwObyk6BcKbX1MIt
	 HCA3up0pq4SdHTxEOSGMvfzZwCicBKsFlGlzr6YYdxJc/vUKaw0JJc5BDFQpHq69X9en1
	 EB563FQE8qz5s8NUC8nwyoh56Md7M8tsj0k979f4ivuBJ9qJgqYSzAZRnmClaa6W1SaKo
	 Q/ucglguK+sDKEm8W5fwaPnvGzpoWvnp+0po7y0RV7cNOKibXKuq5Wg8Ydnlk8V17DDTJ
	 Eb+0lDfsk1XYZ9s50vyr1WLzIY3Js0Q57iOycQNmV74me8GIlvBs50UoKVsHIq2cPDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NNIjwBhl;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5420606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 12:43:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5420606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NNIjwBhl
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb6057b333so26984645e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 04:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795610584; x=1796215384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C49vS/Al7l33SYN7twzz9Qk/hUst+FFoZ0xVaRrzVNI=;
        b=NNIjwBhlLXTaYDVhdYbJis1bo12mjuU+a8HLt+No2+iQp7iedz4fw/SEA8kr9LBXKS
         cFEDLoOn2y5DvG88WdDRbyicdGDEPGCNDE7cLLBp+9GYAU/ZTJREn7cRjGQUmpb8CfiG
         XOC7LijilJ5LDNZ1bdoTgG/f7+UZ8Og72ry4vOtb2iLQCBicQa/Bkw8/plkZa+gE+gw7
         KDULnfXzGTuRzKqiGp+XpLyDCcXpai9jYhRIY0HhzEepxjS98atOkOHYC/BmA9LVIfL4
         hqbYTwHW5LJ2AyGX9KiNWNFgPxJCodEX4hGAM+4NN9nJ/c+X+z3bFfaxBKwGfIexxeUT
         zUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610584; x=1796215384;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C49vS/Al7l33SYN7twzz9Qk/hUst+FFoZ0xVaRrzVNI=;
        b=YGnz4v7/EW+nubkY7/3dj2h1Uv0chFCfNOaqIzidRhqH/23tuMQVJ/bOpNfaheCPxW
         akVPC5GnqX28xbSCh6K4FmZuWEfs+t8HPanFof46hE7TPwWN8uZnpASoQ6q0FDrtErl+
         3eeK4H5eEWyTTpmR/YmEI47+pW0P7wgX0PUumXj5+LFcab/wnJ3fzsvFkhx/U4BV3141
         T3I7b4jB5NkA7nCiPRJh+3rbmRyaJXJKG5ABvvpBWD/UYfdyZoiX7EhIj+dW/lTNpawS
         CuZeRnbtd3ajwu8o/Idipbk1z77SF5GsTX6C5WrylUEZfiWsle4+oq/amI6C91OUv46E
         Buhw==
X-Forwarded-Encrypted: i=1; AL+hErE6adVIs8TKdfbLoJI3w8PPbWZwyVFdQ+fSKt0h6Mpkq30vw41WyA9TMW+AYsEimfkH2Un7PJHK7eil8Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z8Scr5IW+8uBSq3OFN1gH7lXdofOc9my3NR5hosYo49KvwAoEPw
	LhVd2JBBs/lrY0MwgagyREq9cF/026CMlfbQ1uvS59hylV8Hqo5HK0GI
X-Gm-Gg: AZFdTZdvFfNEpdoQmtcT5dI6FSNNKa5BAx04+DXFTuuCZ1SYtN3vprLibvkLPamc53l
	qVxE75MOQayhYmEVyNOJhue/xtC+P/oBxQr5P7LNIEI2ixSRTnevWU5r3BTDOIzMjfUJ123HdJx
	EPF7/0TN44WgsjBnbY78eE1HIkd+05hkjrWKedhawq9TbzTEVOzNoffXY0WFRw4Fcn2wVmnlLuZ
	evUBC/nNmq4bVnH13eBcYbS1Twn0EDScq1E91ndNCU5k37dqre/8P/iNWBnfPchTkPtEG08WLOu
	vRc0pn9CzaQLSgpvQH87JZO56GtV4Plh4ZLXOMIkm4Veg64fk0+ggROEdiPz0cfF2v/01qokBqz
	EOCdrLpc4c25y8s/50ZR8kE/mSALonTQ/teDl8eWfWWq9fmwc7nNw1PSEoAcAj326/CMcs/dm7e
	64llwc6B8KT5alYn+PXuzLtPWspNVeEmeqnAmxrRcq46Qs17GOefsmF1+3GoOrg1i15/bmNOc9G
	dZgGBwyD4/0TgZrXEpB8g5noV7JVeQA+Ohc0yhcO2sJGE1Sbx0i/Rm2RI3HE03kUWfQlPwGPohC
	pYwg4KGojC7cHKg82zmpOUqGODATnMHtFvRVL5VF8NNdw9tAu15POKeHrUPnz7DtgTFq01cYV0l
	qeMwBIaJRM2PchaumR3oERKdl2pZIFeAquSP7hn6Xoao15kg67qDq8MmyngwaUZi+rl0HHuoYf0
	tuWirYNVXpJbTq6LNoMiTfe+20RN++Z/8DuGEIvKdOust/zR8hU2HtNw==
X-Received: by 2002:a05:600c:c4a2:b0:4a3:59c9:a744 with SMTP id 5b1f17b1804b1-4bb88807d87mr369579305e9.7.1795610584125;
        Wed, 25 Nov 2026 04:43:04 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-7575-e1e3-dbaf-96fb.ipv6.o2.cz. [2a00:1028:8388:a84e:7575:e1e3:dbaf:96fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442995sm536486045e9.2.2026.11.25.04.43.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 04:43:03 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: u-boot@lists.u-boot-project.org
Cc: Tom Rini <trini@konsulko.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	linux-btrfs@vger.kernel.org,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 1/6] fs: btrfs: Avoid a 64-bit modulo in __btrfs_devread()
Date: Wed, 25 Nov 2026 13:42:54 +0100
Message-ID: <20261125124259.95636-2-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 32-bit PowerPC, GCC turns the u64 '%' in __btrfs_devread() into a
call to __umoddi3(), which U-Boot's private libgcc does not provide.

The shift by log2blksz on the line above already requires a power-of-two
block size, so take the offset within the block with a mask.

Suggested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Marek Behún <kabel@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Tom Rini <trini@konsulko.com>
---
 fs/btrfs/compat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compat.h b/fs/btrfs/compat.h
index 4596b9d1dd3..e6784884835 100644
--- a/fs/btrfs/compat.h
+++ b/fs/btrfs/compat.h
@@ -60,7 +60,7 @@ static inline int __btrfs_devread(struct blk_desc *desc,
 	int ret;
 
 	sector = offset >> desc->log2blksz;
-	byte_offset = offset % desc->blksz;
+	byte_offset = offset & (desc->blksz - 1);
 
 	/* fs_devread() return 0 for error, >0 for success */
 	ret = fs_devread(desc, part, sector, byte_offset, size, buf);
-- 
2.54.0 (Apple Git-157)

