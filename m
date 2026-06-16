Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D9169AD2
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 18:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635047; cv=none; b=PHFIkPwsO2Lcfs80Dr3TGQpkdyFeeuvbkXR9FvrVo/eLPMH47Eyargms+IRxXt+X6bUMtlOSwEFgNcleaQ4m9oy4uTegVbNRHwb/jFbjPmJ33s5sQswpQGm+jjlvov3iF5+VsOU3QCZV4lIAWaLPvoiZIBtzm+X4moWtdnBP2Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635047; c=relaxed/simple;
	bh=ejmFBffkKe1R3bCghSNjvyIwEDLJLVylQrtjqJnKXro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=khUYtQkyYgdctdffixiuGzb9p/Xyhh9IGNqaBK/JEiSVx4YbBc/R3qoatnvNJPbPP0wfMavKKheE7v3mqtWIRgsiGvCJ6g9TJGCWKVi1vW9gdiAV+h5qtp4wuz92b+/B3gHn4kGPeThohvguW6xapM73eKlka982CXDSorb2u5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ne/wMBiS; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ne/wMBiS"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490a76757e5so35708145e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 11:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781635045; x=1782239845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=baklvRGWLgPjW38+j2LPDJbIHJ5nLEi2OySijHIzepg=;
        b=Ne/wMBiSe+d1Gf+wi9yMxp3TkvPIPt89dXjcFXmBL9d0bXM66qQEwty9OIpTWo+4ZG
         iC1UkYnKwr2Z1AFx8cNPQwY7iCUg2Ox0z3mB0ef1+b2l3qtUeMgnW7U7eEicksBA3fNu
         v9iiLkGERP4R9AxQt8OZJOHBbbt/6wc1vmK4YM0AVoAV5A56zXxCYgd1e3n1qLHwehud
         s6SVz7dHPGVnVBnngE8xp2jUzw/rbxolG5iGP3OkBLr0XsxM2AbwsDDMMCUCxdSoSf6J
         Tt0N/yyX4Xazy0gdx8fRhVes+dymem93cxkGyaLOvJsrZET9xG4dMH84tCM4BaswAZVF
         Pkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781635045; x=1782239845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baklvRGWLgPjW38+j2LPDJbIHJ5nLEi2OySijHIzepg=;
        b=CbyPXdej6Nm4mpEw5RQXThwfVnAGpPL/yMu75CTthx2MK/d2UmpBZdNAjH6H8gCZ2G
         0NDRO8giWVkyAMN9OMgR067PQYs1ab0jsDYuw5cZhgGTtbCGsn3RLNS/9aLsVpKVJMRL
         h98uUfanNrFUsZiils4ye/kMvtZ+nizdBJkk9TdAZ+zipshW+VPEpxyH8TB7EpJ/6+3M
         tiWn0+L7Dz7LgC+qLcFRv9ZR26nArfpo062VYyRjX/meKH/rL0YMpP63FIYFftNqaifR
         6MeELP6JZPVYAIGYiLij8znB0uT0wHawQt2NTiQaeqUjiC54P7MSGzs5dnsrEp5yj8ym
         kEzA==
X-Gm-Message-State: AOJu0YySXTM+Gltfaluo8j8CbfqpCtF4g7Zh3c7vSJN0CV17qk1C5xDK
	U9wtsU4MLDAh/ksld52aN7f3Yvhai8cZBVZj/MfKJHBH293ZR9Wl/kEPN4qb5ue0
X-Gm-Gg: Acq92OHhLoFq9NihCWtXIoxGvbkYkjq+FFfijzQGcEu58IKdVmrZWJ3n+Ylc4EdrfqA
	Adf/ha/uopClF7XgE6dpl5tWCcbV2PFkCIN2orvjccSMQvsAED1MrDy+c/SjZ3V9GOFz2R6jRrm
	QTbTNAbyuDgI3QuljABhkH3qm9SKfCwXIgzkqERLy5wmBA4nZhRkwCQDUUgg/r1fxOZFEUPdLfd
	mH/pRZYx4/6iYJ0IUSaOfqqJ9DcBuPwCwT7sPy9HEGlkkZGTCL/8ui72toXs1EPoiYLPeomi+9m
	W0xZ2AldYMrsqhQ8fXUImg9OUmAXoKFgBwvcP0GCLwNeQWJN8p5yu0mgmc0SMoJbaPydmRpMZh7
	LdU8hP1z2pnT5E2jr4XO+9V0CF4QUg2yJRJjB9c8HQ7i2a4M7RR3A7VfOMZdDFfafdiXu/MCmGf
	O2UOnhOnaIVVJoqX6hsovk2KZlkmfU3IN67g+3GpSFZY2yvx+MrpTbLVljzwLSygbKddOZxfwF2
	qijXTW2jBc/Jt5G88Z2Aa2t0lDkCu/5nNgqtA0cy7knQhkWzIf8lAWxl/eE9wUI8JKa
X-Received: by 2002:a05:600c:8a1b:20b0:48e:7854:1608 with SMTP id 5b1f17b1804b1-492333ecc7fmr9086945e9.25.1781635044599;
        Tue, 16 Jun 2026 11:37:24 -0700 (PDT)
Received: from arch.lan (2a01-11df-420d-6500-8cc5-1367-c707-b36e.na.ipv6.supernova.orange.pl. [2a01:11df:420d:6500:8cc5:1367:c707:b36e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa9f2c0sm117895375e9.15.2026.06.16.11.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 11:37:24 -0700 (PDT)
From: Mateusz Poliwczak <mpoliwczak34@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mateusz Poliwczak <mpoliwczak34@gmail.com>
Subject: [PATCH] btrfs: emit BTRFS_SEND_C_FILEATTR during full mode
Date: Tue, 16 Jun 2026 20:37:20 +0200
Message-ID: <20260616183721.1400225-1-mpoliwczak34@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently BTRFS_SEND_C_FILEATTR is only emmited during incremental
mode when fileattr change between snapshots. This change makes sure
we also emit BTRFS_SEND_C_FILEATTR when sending the full snapshot.
---
 fs/btrfs/send.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3ae480c7474b..effbe7ac1a81 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6575,8 +6575,10 @@ static int finish_inode_if_needed(struct send_ctx *sctx, bool at_end)
 
 	if (!sctx->parent_root || sctx->cur_inode_new) {
 		need_chown = true;
-		if (!S_ISLNK(sctx->cur_inode_mode))
+		if (!S_ISLNK(sctx->cur_inode_mode)) {
 			need_chmod = true;
+			need_fileattr = true;
+		}
 		if (sctx->cur_inode_next_write_offset == sctx->cur_inode_size)
 			need_truncate = false;
 	} else {
-- 
2.54.0

