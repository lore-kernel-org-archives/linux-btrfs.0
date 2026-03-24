Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F61E40823C
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 18:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774378368; cv=none; b=AMC8+ybV1pnF7+pYusKHNAhW+6IYabTPmPw8mqWLtFAp6mgZHfRq9g5PP1u2D0m8qdJtesyMKxfreSqUCm6cZENANg5BSqVaQF90Dkamg5lzsopB/64NQe5K9w12XEpQwzCg69g9b3gAvwDz3lj2AxpRWdzzysnsU0Ts+S/c31o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774378368; c=relaxed/simple;
	bh=YvdGtLyR4jvWotyhAL4QO3VeghkZ04xMqo04Boh/rk0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NK30/jrTnGjF60tjtEzsRruaJBMLyFCCDnghZbPRsa9uRBlXkwYGIvIcai7YrofV4OTerBz7MW4TJeDFAJwbXe6ec8ROVznt78taFozxH5Opp5vr7U1d5FODEt4fGS/w3JPvTdmkfQ1LpZwE0TVSeoFTmTsAjrPlNS7yVvQA3YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qwhto89k; arc=none smtp.client-ip=74.125.224.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qwhto89k"
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-64edb56b70cso1016128d50.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 11:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774378363; x=1774983163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PB76OtMfswJevJOFpftd3/dMIj2COiUSBEPrQVJwkfg=;
        b=Qwhto89kyNG2533m3t1Ar8HUGQkoJ63fYQnSkm/32P83KiZGDp1DH4gcTKoJTYsoVe
         12IPY5z3BTexLuXWRwS86xLPfwniaGqfV9UwqvrFlRLMARNLu2OdchAiBQgovAx8YKd7
         w70cvxReM0e2joTLxOe/d5Um9V+Gt001d8AWKq0aQJDnPEoN8SDFcsg+Lt7pTYJ41Whx
         6U0zY7//sK/KQDUe9MEGjil53rolhbvxDqDurFHwvvjy1AYxO7Rpy50gZMLhDetwgO/v
         GeqA91GPIwAJd+WIcdUPq6aDv4EBAzteKINkvOrGvgXoERV+CbUHwbjccJdxDtyhrIlv
         xF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774378363; x=1774983163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PB76OtMfswJevJOFpftd3/dMIj2COiUSBEPrQVJwkfg=;
        b=o0yo7TC8wHtGrpCOqJjR+KWes0AQYSLXN53qzOcpe5pyqUlRW1fGBe30yLKeYa7Ruw
         bqV/B0LsWfZFy86btriW5FiDmnlsG5ijTkndzhDrzQaahfyKVlVSuhwxlNN/T2W7kqpT
         a13/9kB0NCVw9f4wV9usELV2CwTa+G8MTtQ5EiVPi64DxjUcMAZ8mlzUDOG1msvmdG5D
         oDcxLw5k54fuz3P+uNVtmyIjXflMfZghzGBwMR+u9r6W7LjeFGnEeZshMJ7qUzq1cfLb
         6XuIbnGWGvV6y8nSFSCpLVNBtXp9Rf835Y4wrdZWGtF3X/mFbyGm/+apl7Te+GZpWOHT
         R/wg==
X-Gm-Message-State: AOJu0YztpB+nRTEmaEle6t1cdrTUCapZ64epc7ny4rVvkGPZlYpiM7ft
	xhxvZxJ4YsQOALIK3f3Gakolw9qBBMyoDEqjNHvDfUl/8Y9i5Nqud6pasw1m3Y2I
X-Gm-Gg: ATEYQzw1ar980FgPiJh7Ue9VuYHqDyOvSQNtMFyFSMAL20MNv5c6xx6lKQLJjr3Lcwl
	pTeCK7Jb3S6NpwCXKnAEeQhF3xB3M2uismXge/cf8DzaCn2d78k1M6cLzo5rodrLb6ruIESIy1+
	vIC0Tp3AAl8gQljEmW7WVYc6FxmfVh7K7wxrPHRw1F+WEhh/vAmySIYSYJqYznJ8fG2or2dOZFX
	fcklv0uClsJEccbLR+rgp3aXH1pVSP6TmUEvPEGe+/HlviiZnyfXz9WidZzeoVRU3R5p5871URo
	HI8ngfZRtVPjD3dXLcIpvLv9TV0WRT2RFX3PI1Ae9f9sn2znRbsllIdih9FhK0Rl/YsoUHfbHDO
	6V2w3JxRGinagRwuBPzPmBPF5ZCBBok4m+AbSByU6gc2T9dEXUiEKeLAFPcDG5raZu3fVr56nZu
	x4Fua0JiAoDQxCPytq
X-Received: by 2002:a05:690e:d8a:b0:64e:e2ac:eebd with SMTP id 956f58d0204a3-64ee609d822mr683132d50.32.1774378363424;
        Tue, 24 Mar 2026 11:52:43 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64ee0fe98cbsm755110d50.10.2026.03.24.11.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 11:52:43 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs-progs: check: recognize verity item keys in original mode
Date: Tue, 24 Mar 2026 11:52:39 -0700
Message-ID: <77723ae3c51bb05723123a15b869cdee921727e2.1774378180.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4e88bb6e ("btrfs-progs: enhance detection on unknown inode keys")
added stricter validation for inode keys in the original mode checker,
flagging unknown key types as errors. However, it did not add cases for
BTRFS_VERITY_DESC_ITEM_KEY (36) and BTRFS_VERITY_MERKLE_ITEM_KEY (37),
causing any filesystem with fs-verity enabled files to fail the check
with:

  ERROR: unknown key (257 36 0) found in leaf 30621696

Add the missing switch cases so that verity metadata items are
recognized and silently skipped during the check, matching the behavior
of lowmem mode which already handles them.

Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 check/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/check/main.c b/check/main.c
index c96969fd..4fdd8867 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1895,6 +1895,9 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 		case BTRFS_XATTR_ITEM_KEY:
 			ret = process_xattr_item(eb, i, &key, active_node);
 			break;
+		case BTRFS_VERITY_DESC_ITEM_KEY:
+		case BTRFS_VERITY_MERKLE_ITEM_KEY:
+			break;
 		default:
 			error("unknown key (%llu %u %llu) found in leaf %llu",
 			      key.objectid, key.type, key.offset, eb->start);
-- 
2.52.0

