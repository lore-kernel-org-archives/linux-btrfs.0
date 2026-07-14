Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A216C3DD523
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784013059; cv=none; b=oAdsZqOCNAcEVQ+chRKPZftq2WVvNp7VZDTbvOxerQXp+y6Zm9eObtO5ZrNjT1fkEFitR1Bt+CAYlGBhUnxIC7caw363NCYP6foqWYHioPNeKy05iqKIQOKZr+7sc3vIE2txXjEu5P5W+t1Hd/p6387bP++ZVdGUdgZ9wGYqv6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784013059; c=relaxed/simple;
	bh=3EpYSZdglM9uMM9UNZN2Sb6Hl5n0KYaJohBNLrcZLAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SZjBRmsyK7HMg/lAB5ENva3t2kcL57rdmpmxTEzZvyG9BLlCylx0/7rU007tcvrfnbAvoHgwQylSfUzHYpoVunn58ALyguNyOsB73IcTMJ+4mUdlToJlYPnCMTBEYq6wtG+29fgvyd4Nyfh+OS3LkzJbUPlT/BbA95Bo0GG6ZVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=MJnnuJUq; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="MJnnuJUq"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8f0e5e36912so30000836d6.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 00:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1784013056; x=1784617856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pmblTb+Aw5bk825UZTwA8Gbxpnmr5LndhwgKr3cl2yE=;
        b=MJnnuJUqph2XUXfF06oXMjKt0vlEvhXoQhkq8Fjfhvq1rrzEPwJDvSNd9lUzUFuAIr
         xGYg+YhM2LiwEP5YkFf3FU1HpNjYFOg1rcjNvS+08IZ0zmY7sPhJyOsZjPgJWVYAVr5m
         mteHVXnTffNqPoKM0OvFaAn3tBgGEo74A63cAfO+Zl22Ojf6TfAmAeQUNrCnxne6WLyG
         oY67kCPT2nlZQRYqLzvKyQnaHaFu+E/IZuLtLl1kV3f8fJtDFwvyCWAxnknsoGMchzzs
         GjWyge4MLXeqoOvg/7ODUw2rWRxnP2VR88a8t55rfvWNZQBFafaj7UF19hQRtxNLWThb
         bCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784013056; x=1784617856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pmblTb+Aw5bk825UZTwA8Gbxpnmr5LndhwgKr3cl2yE=;
        b=qkt46eUrYH3yabY8wNFHMDZQrjtv55MzJeUw3r5BOFB7z59QDPNFSWlRmydXrUNZGP
         hIO0Zjq3yKnOozVIqsJkF6s5VninhO/cFv1dvMueljrIzFCuJlR8bTaQTOyhM4ajUZ6U
         6IwdD+NcN49SwXPpsJk4GaiDDZh5bqQAyhn5BsZs8HyF5nsgYiFn8++LDiF1LZqmDLxf
         IZVdyVC8LRpA238i9+QwXL06x9NBH8jnwRPhH9jo026zxugDefjv12kAF3kgF5naMH/p
         EJ/htWFiyIU6vie8hLvfCPVLq2feOgfAnz8RPlQ/spcyv93RY9JePOc6lQ3StG3ST7W3
         ZdPw==
X-Forwarded-Encrypted: i=1; AHgh+RoivzGZj/IHM01EwKSknnD/KxLwLEj5uF6idJsZlr1tI4SdjCHiZhgjp/zT/QlrFdQfb5JHJYturpAhdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ekaxYiJpVBkhXgq69iid5hHaqwN66U9Xvqm/8NTvXBaMby/8
	lIx64BURdNAthnzXPfwtxfJB1ktKoFu5DMpNlo7l66DPbMw8/1cVgCIk/MDudU6mzdY=
X-Gm-Gg: AfdE7cm0I2aXkdbeviXtFBUbXpBe+YP18BlUFXB23ZzF5qqh+PD/aDsvs2GW1g8lXnL
	1/mmiJeYjz9eN0j0awC2pVEiJnIXDkRJH632tyZB2CFUMi/3qnLS3d5LupM49lp8x+C60HVjToP
	G3dQTVU63/M83yq3QhdxWZxHEXeXKK9EKbYHtVn+avRlDGjJziOOfdKU+CGwV6ec8hjEUo6h+ph
	8QRhYwJVdCHLSaMhUte3YWmfW1KkY+0XPHoQyjWa5eYc75eF82IbbHxXlDO384CTC7YPvRyorCc
	rN0CQmND3h0sPYbNXF9tD1jiSofLqvHPTAFR3WPOHApxSG2SdHz/Ga15LvpfAOqJ3w+naxY3GV6
	xMkOyRK8miX0eQShqlbJ0nZhhf7IbXRAmIe9cDu7NeQb6cHUclQOs13/93VqLEePh0Q0mMezuwR
	0HatYta57yfgMgJUJviQ==
X-Received: by 2002:a05:620a:461e:b0:92e:f33f:f45b with SMTP id af79cd13be357-93083ddfed2mr219179485a.84.1784013056527;
        Tue, 14 Jul 2026 00:10:56 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-92ee5bb3542sm1322488585a.20.2026.07.14.00.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 00:10:56 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: Chris Mason <clm@fb.com>
Cc: David Lee <david.lee@trailofbits.com>,
	David Sterba <dsterba@suse.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: lzo: reject inline extents without both headers
Date: Tue, 14 Jul 2026 07:10:52 +0000
Message-ID: <20260714071054.1715464-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inline Btrfs LZO payload shorter than two LZO headers.

Fix the validation or lifetime rule at the vulnerable boundary so malformed
or racing input cannot reach the faulting path.

Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
---
Trail of Bits has a reproducer for this bug demonstrating Kernel Panic which can be shared further if needed.

fs/btrfs/lzo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -552,7 +552,8 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	size_t max_segment_len = workspace_buf_length(fs_info);
 	int ret;
 
-	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2))
+	if (unlikely(srclen < LZO_LEN * 2 ||
+		     srclen > max_segment_len + LZO_LEN * 2))
 		return -EUCLEAN;
 
 	in_len = get_unaligned_le32(data_in);

