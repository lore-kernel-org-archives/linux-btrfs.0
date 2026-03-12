Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94BC18C02E
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 00:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773275618; cv=none; b=ikCjqWws4Vxb0s4N7cbkCLNVRXHH7O+Elc0LugJMXK9+aRIiwKy1EMX74W3L/uIG88oexUSOqu+QV/HU5eaQ9PNPdGziByBNskhNE0RYD3IonGTFR11VpaaeO6bIiT30gHZdP5GwBBSFFtd+14SB6L0yWYwel5ZwaArzUhyjECM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773275618; c=relaxed/simple;
	bh=rlXgGPi79iuqIa4T040/mkkayzLRWUozFZ+5dSvCmEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uVbtjr8EM51+9CLvwdPiuK3rQ4LZEF0PrJFXxToH5Susdx0i6GAlw0V16b7tWrgOXSpqW6IFsGDKSGHQknMTaZJ6kRpBubKrNRyANoySnvv3RRYwoGty2xPdKGHNIsSnkynqy+YE2Uviq1otK3UffS809Ex+YsCtOwRfFv20NJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fzr5yFDa; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fzr5yFDa"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-359832fc558so337589a91.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 17:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773275616; x=1773880416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UoyhBT4g1K3SSISK7YtfbEu12sJRfL2vQA3y/hZ0QA8=;
        b=Fzr5yFDapO98H2XRajb4SvfliG5hnL7yT/nKw9zQIycBsV03MaiG83uAbsx9IgLDG+
         lOaPEOUEVwxHBNoJjIfhMgi9x4N/BvHxOVf/8r/k0U6y2ZYwOjwoZrheTMif8cloNzkC
         zPfimlK7Q8AK3qmofVN7vqhT9RkXgAs52nKNZrk/KYSpKwfuwiyR23vbO3VLmKJPVa+Q
         xeJRk8OV8uTN1zDBBJTgjihsrtg/RbS1218ZDhXhNfpG2xOwrs+7CNQ5G2f6EOs0YtXT
         XM6+Vx5bTvW3IxiqINvLTaBsDPKQgVdRQhr6CW22jYw2TnrGvVUUJKewFNhfbQ3DlJlq
         dzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773275616; x=1773880416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoyhBT4g1K3SSISK7YtfbEu12sJRfL2vQA3y/hZ0QA8=;
        b=JIBu30Br67niKA8SAdgf3Ob4n63i8sQaOvKhpCQ4hv0Ygr9jlg4DMMhQmrBJvDwQ4y
         gSDNMzySXl+xxJ8+XXGsl1veBlc/nFHhR0asWGd/dqmvSsiE0gajLBwWSzTC0YsVJDIv
         6R3GrxrnQ5vUZ4LE3CCd66FpHWm5feaRcFg8f/QX3sqeG+KM+ubkrFPh6Iwo4BjQrEmi
         vW2wjZRiRNdhgf9wB1ZJ9VQMjoclr7QNA8/zMlOe2tOfdT98g1gbmM0MXp3zX45aWws4
         5yu9aKUWyjCFgoGjbIhviLNqV6E4HRBokgAVTrHql7NCRm6diNOGsC8FP8AJG+nPna6Q
         BjFQ==
X-Gm-Message-State: AOJu0Yx3JyBCyhF7aBvVvFrfvW9q+UhHlaNuKThwgN07P50+3kI/O+hj
	f+YfUcmPsLfuLbM3aecqk4IhzpkzUvSAWZONzgj6ihHxM3u1cgvFAJOS
X-Gm-Gg: ATEYQzza/JicaeJutP8PHqMqGMLkFxOtmMmWD9WaAbq6zCvFgPUcL0Vv6kcE9HC+4E4
	Tdsa3S80+zzed30afNEzRT/E/HLMlSV0BxNVHOCPkVVbLIMKaUwJhhPyxcvwa7vEG4490077Nm5
	7w1IVfqfd4BjBGAi8vx5zAcTCIoScuT+huGyLZxLLArpJMaVCTfQWIeKZDtyh1M8tIwTJB9+hup
	BpZagTSupsjthfF7ykjr245+RFVpAInFwIriTKM4JgstdOeBqIBab51XAHCBhcuGkp+oZF1jG0f
	t6/74eDEfsHsdeXoIXkBmGeHckewqkVhrkPZoPKTWoTrnbvQAZweNwLanKXoPCDqnI0oXLvDQIV
	BmroDmtekJ1MraeBMNsrYkgmnhlJb90I8nlUjreYj95r9bF23bChZ2tIppcZHiUPbgtUteEgHE1
	0gzw9/1VOw5edcL1FoKWRPeFJE2pK9iUxZWycd16QESJoeomV410PcZVJHMAGxOldhyc04qA==
X-Received: by 2002:a17:90b:4ac7:b0:33e:2d0f:479b with SMTP id 98e67ed59e1d1-35a011c8f8amr3978396a91.6.1773275616144;
        Wed, 11 Mar 2026 17:33:36 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359fc97356dsm4467411a91.8.2026.03.11.17.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 17:33:35 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2] btrfs: tree-checker: fix misleading root drop_level error message
Date: Thu, 12 Mar 2026 08:33:21 +0800
Message-ID: <20260312003321.3019495-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix tree-checker error message to report "invalid root drop_level"
instead of the misleading "invalid root level".

Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
[CHANGELOG]
v2:
- Split out the error message fix from the previous patch, as requested
  during review.
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1e052c3303b3..a8c568b10432 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1256,7 +1256,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	}
 	if (unlikely(btrfs_root_drop_level(&ri) >= BTRFS_MAX_LEVEL)) {
 		generic_err(leaf, slot,
-			    "invalid root level, have %u expect [0, %u]",
+			    "invalid root drop_level, have %u expect [0, %u]",
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
-- 
2.43.0

