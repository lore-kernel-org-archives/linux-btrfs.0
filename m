Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619134;
	b=P6xtote29x/tkgkKj/huuhOGRQy74uCZK6/dfQcU8YxX3o+LuL6fyTp3IOxGPrOvGmnj
	 q+MAtPPcrqYaMEJtYCgDAy2XAcNpx2vCEIecnXxNsXHgCa3Bkm1IR0ld9Q3Y16JqxP+Vw
	 7TxIj+dPzL88C5cHSFDe3V81HEFZxL/HlIenUsj5/ZeuITBsUNXFqCUXnhzPCTaMz+/PT
	 TDs29qMcS5u84eqvpoCy1MpYkRFNRk7cjELSrWvOfRZTNC3Q+nUidhCxzHXtIWTYydPPl
	 l+fs2/GsJPWTUWACd1okS3o59RP6RW+PhKKQoc1Heln7KXmSftsfRytgGMEoZz7uUeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619134;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=95N5XUSmi8V5EgrETcjFPeTXuNDtWcrbPsbBrx8wDzg=;
	b=nN3tNXdSlnaMXKRLeTZt3D6igV2fBYz2XOV21IbuaceQBXr8VFZdjAZ7leyWbCwR22wC
	 OOKT/QHEk3dr1tGgnG8m31Fg8ujRkltiatbjkxt02Ki/s09Lf15maIAefy/kAk6BEhxt3
	 Ztmj4SgMY6EXmuChpG2La1IMBMC5vrc2R6f2Qtx3cDZHmPFJzzUlbVbhqSubB96eKoOTy
	 OH3wFQU5s1qGtPsZ184ymfDvbP/15Dpm9WIMBGZZiuZL+TBQpSYRfdVzTNO4u19mrnHww
	 QZZvyrn6mKr7T2gE7IfvwtxkK3s5B/ue5V0ral8Mw+7uCu7cqu3SifXuqgF3ZUy7QIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vu1INfGh;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20160606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:05:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20160606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vu1INfGh
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb606491faso31563625e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 07:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795619132; x=1796223932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=95N5XUSmi8V5EgrETcjFPeTXuNDtWcrbPsbBrx8wDzg=;
        b=vu1INfGhY986Bq/CxuzUdQpQ0TE7qGALqsg01sSqW1ylxJ4yJqWrl1PYxidoO4rXjD
         w9XoYu3hSmByYGC5+C2FPGkA717tm1Cs7yjkCD3VIaSqRpNO3zRrOSaFsOTuSXKsA9Vo
         qP44fGb4Yzn7uDz1qUZv/GmlcpUwhDr7zTUJxdY30xrHh/KaFcCrtxDdTpfVJD7B7M7i
         S/O9FPbspfQ322JhiU+F1saJ+xfAaZyVBBs9d7F9sJHESJG8EdudtE9YXHhOhF0rq4iL
         IJWbH+y2Vp5irHuQS31D48/evWbmFYwDtjcPZAz1UZmw99mGy2anMqNqEcXn1lfD/wsn
         Arfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795619132; x=1796223932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=95N5XUSmi8V5EgrETcjFPeTXuNDtWcrbPsbBrx8wDzg=;
        b=bMo359MgL9OAeT31/hUmXnUa5DtkLFgCA6Os5iPPFbJJWqZR/lX2meuldjYGlgXj5p
         U/xOgqtJ9ywIjc3eI5QfRqv4Z53nB+MgjM++/Akl0mLP/2aicBFSZfu+90BYm+CUaLJy
         OXIE5brC6qvAQag0sUN6Tkesoaqw2L3YzkUXIAlZ4RBgiwXCH9E1HeYgiQnDuo3ZQyEg
         kni8EcW5+p9Wxx1DYid60hd/5Nfa9tDPmv0ho6VTkZQpGGM5nlv2ZD69USrS0/ljQmxx
         APnDZiA4kJP7O5gAr9yeAy2MgSwJ8MZY4Xkwu1t9WJqfGw+i79ir53OxrGMK0TUVQ9nA
         5Brw==
X-Gm-Message-State: APuU4Z8a1/KZUOMfbZllmBHrC2MSQfTSbzgCeCI4mAll6M8Np1nG9tlT
	kWoyEYcdKiHmTY1vadi8TaL1p8lZb8oO2s4/XzIVnbexfnBEXHYXdEcU
X-Gm-Gg: AZFdTZd9jLZdRMa6hTG3S8zFYTWl+xGRWng7e4IBzOLRFQgCklF1aPCuMSxmo9hScAn
	kNOjNk8JJyM8cL14x2Wv6eAB+mspRvuk3L6r9MvsKVX32ha4wpnYvG0hHR47U17/rQFhJDjvCDD
	eVAaS37DO+wE8kkvoOJYxpfBGCGfW5P1+riAwcbeITr1vVFOsX2z0eL1Eqa0mhn0eGgVLUc6+W1
	5U3oy9ElqiwWX/q4Cg7Ry6Fvcdiie1nDT+2lqaA/hWD8sm5QfkzNFmkEikOQsXogLnp70O2rcJe
	Dnb5ADpMFc2P7NfMMIj3fgIOSKMbuY57R+HcAOOhJaPFYi7izI+o5niawU/yglLz+5xBRKK99qw
	KO+X8Gvx2yUnRSzdz5ftG5piPLCtPBic/lwFl6KcfwY7fG/44sqGzL7T+hpid5gtfQ9eRwoUop6
	eBcOeFfbQ17hUdp2ZGGgnOFm8KSTqeKYdmEeO0gy/19W/+ZT4QhUyLm37D+ZjllZwkMci21GVYr
	3/qXoYaed61x2aO44D+YPQ6isxTSo92T7LfOia/FtPW/gRp79weoK+6p5QxjytazieyE4VapSFb
	VXTb9Enc+NsUxHvrDs7nhkgzD69CZqdv7qycubWoQP2GLm5mUdHdVVKlAv6fnWlyEbYZxrud+Oc
	GJzykwv6a0O9+GVmi5SYr83syo/S2566EUMa/C2lbU/mq3W2BNrw=
X-Received: by 2002:a05:600c:8b11:b0:4bb:6871:8f21 with SMTP id 5b1f17b1804b1-4bb88822346mr374302965e9.23.1795619132401;
        Wed, 25 Nov 2026 07:05:32 -0800 (PST)
Received: from archlinux ([39.39.175.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm581728885e9.12.2026.11.25.07.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:05:32 -0800 (PST)
From: Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
	Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
Subject: [PATCH 2/2] btrfs: tests: initialize fs_info->nodesize_bits in dummy fs_info
Date: Wed, 25 Nov 2026 20:05:18 +0500
Message-ID: <20261125150518.113966-3-abdullahzulfiqar580@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125150518.113966-1-abdullahzulfiqar580@gmail.com>
References: <20261125150518.113966-1-abdullahzulfiqar580@gmail.com>
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

Commit f2cb97ee964a ("btrfs: index buffer_tree using node size") added
fs_info->nodesize_bits, initialized it in open_ctree(), and updated
alloc_test_extent_buffer() and buffer_tree lookups to index by
(start >> fs_info->nodesize_bits), but missed initializing
nodesize_bits in btrfs_alloc_dummy_fs_info().

As a result, fs_info->nodesize_bits remains 0 throughout all Btrfs
selftests, causing buffer_tree entries to be indexed by raw byte
offsets instead of node indices and any shift by nodesize_bits to
evaluate as zero.

Initialize fs_info->nodesize_bits = ilog2(nodesize) alongside nodesize
in btrfs_alloc_dummy_fs_info().

Fixes: f2cb97ee964a ("btrfs: index buffer_tree using node size")
Signed-off-by: Abdullah Zulfiqar <abdullahzulfiqar580@gmail.com>
---
 fs/btrfs/tests/btrfs-tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index cebc9a17b..c96fcd4de 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -138,6 +138,7 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
 	btrfs_init_fs_info(fs_info);
 
 	fs_info->nodesize = nodesize;
+	fs_info->nodesize_bits = ilog2(nodesize);
 	fs_info->sectorsize = sectorsize;
 	fs_info->sectorsize_bits = ilog2(sectorsize);
 
-- 
2.56.1

