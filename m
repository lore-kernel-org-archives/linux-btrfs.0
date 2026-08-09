Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C54A2DA74C
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 01:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786240286; cv=none; b=aZasG4eGtc+XqBa0tnmHZbzXcmLK+Ta1jCwx0z50uWwMMu8CcV3tnz36+U2SA6UfEDmtvq31Ts13Or2z9T2LiYVk6I9Lo7L1YY51x+LHdy8+w/NXrcOQiuA5wyWMDkYoxGor+I8rNtmb4fnwQ5HiGacHEqztJffiSX6R/Ossx/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786240286; c=relaxed/simple;
	bh=912VjhlCNegwD97I1y/9SNrr+A+1/kjLHkGDswMydgg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VH+z4cd3uqswDf5z9IR80N6ObIP6pf8irdV7f5hKK+6t9fncKf47X0RGfRVMTAeO+JAAZu/dY2fQH4pYz2Bw7gnT10HOrMVG2vFbUxZn4s7X1fGlaKLyY6R3bNFTPqzJaiK1vU2mFtJQxBq16tZ+3GU67RqIiRZlrwkj1dH6Nr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ooqzEjFD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ooqzEjFD"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f84023916so623843f8f.3
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 18:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786240283; x=1786845083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AEnQm2n1tGfgzID9F13MMV7nmKzPjynyJ4WJ6ewxepI=;
        b=ooqzEjFD0qpbVtgQtsN7/fBZEpE53PQkLG/L9atSwHc2OEeHHK7eXHvG8JucrSacpb
         m7VkxCx1Co08G7EtdS2VyYwA8+GXFa+3Fnhhv0Qghqdl75uNSm7eFecL/3K8lXgaSyab
         sIi1cCVPVboOCocI3eq5Rh44HhhH13Wv982Fby1NZQW3XmrJiXsKMeI++lBqV4FHypZu
         JHBN2XZZ23wu10F2lrlMaSniMgx5MIBAZk/LGPQUbCDvQZrVFoCEVUjPbN9tBghUKTRt
         gZBiCVZWzSJXk3M5yWHCVZ/alf3XRr1lM84d/NQIUK/jHeqQa8+4bVrPzEgMkBK6BRzy
         6AwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786240283; x=1786845083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AEnQm2n1tGfgzID9F13MMV7nmKzPjynyJ4WJ6ewxepI=;
        b=s/meLPvynZv+yU685N1euqLVYeohPEqb751MkLvD3fOSbd1qS2DRYsmUrmvOaaFldu
         miADhJlxA9mg9ulTm3s90OqzF8u1DlZ6Dqs/sTcoSmDWbsVa+/aoDqa06YBgfBr13W0U
         chlHoI3luH84XxDRKJDUXARLQHPL4XWaxVr0Ut2O8MfRzQTqPZEOBHRa7efVyZZTli1E
         6HNv1I2pMn8EeJBGhLLFcwM/PyqzsZDz73+19wj9N32AEcDzpa9LWhcpwJJAQFFbEy5L
         yju7IgRJUNmYxxkCv5VYI2mcOSqs1uw13caL1KiJOTNvdx1wIaq2xF9MqTtTBGVFXOgl
         Dumw==
X-Forwarded-Encrypted: i=1; AHgh+RqZq2YtaP550xFgefO5o+31jhY+xNqU+hT7N84J/hc40QsTYNxKeA9hiikODcNWJnFUbNYpBhnXnz3FGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLAYJGy5xYeV+JEIp06DsJuFxIem2uAWgw7IAujlPyiQnSY8Vk
	g3rdsW/qITEXtQ3hLTU8j9uLhQbUIKYZxcOMeBbcQu/AHZUjpR+uKUCD
X-Gm-Gg: AR+sD10ezmukmPOSHoj7ZIR6f3dvMyOnPgS6zngecWDRZHkDsV7mKIzE4dp2iap5x3n
	qtzXxC8mMWBOXvHNTY1XyXb+XngJtvjjZ1RT0UF1XX79DZusTeQOY79JMefIMzPKi+KTTXmwkwo
	XnLLkEQkPEdNsAy150bpcUNq73oMjHmxX8/hysTBCYYXZeapY4GsMyNWvfX2ildBCfAxD5CyEKE
	pfbRw/jzvXHVY1HVC3c2lxgp2DNC2cZK04y9jppc87/pwzIoFgvofJ9AkeMA6Gw2AOxLydnUua7
	gvIqifMugmFb+UyKVkbimGZyKYJKk7tDtdM3EPPnN9if2Rcqq0Sd1fTRh5eNNveDrc+Cjj+xev0
	uGB0mC/7dTcjhKFiZjeMWMbEh9oieyBG76H8YZMp0gxkyPoxCbcq0H3rqP+gqcBQwmpcyVgT2OR
	q3H2zysPQ+Rv2r8d0eGlf9IuJJzFinroFDnYftqTc5ITNFv3mRsU281rM=
X-Received: by 2002:a05:6000:2c0d:b0:47f:6f9e:1e82 with SMTP id ffacd0b85a97d-47fec4f11cbmr51063701f8f.9.1786240283225;
        Sat, 08 Aug 2026 18:51:23 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f90f8sm17155676f8f.26.2026.08.08.18.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 18:51:22 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 0/4] btrfs: add per-inode compression levels in xattrs
Date: Sun,  9 Aug 2026 03:50:50 +0200
Message-ID: <20260809015054.779137-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add per-inode compression levels using
btrfs property set /path/to/file compression "algo:level", using the
same syntax as the compress mount option
If set on folders, all new children will inherit the setting, while
already existing children will be unaffected.

This patch series also fixes a small "bug": before, when setting
btrfs.compression, it would keep the mount option level, even if the
algo was different (!!), so with e.g. compress=zstd:15 and
btrfs.compression=zlib the data gets compressed at zlib:9 (because it
would still get clamped at the right range); now if the level isn't
explicitly set it will use the default level for the algo.

I also wanna thank Zygo for helping me by explaining stuff and for
noticing this "bug".

koraynilay (4):
  btrfs: export btrfs_match_compress_type(), move it to compression.h
  btrfs: also validate compression levels in
    btrfs_compress_is_valid_type()
  btrfs: add per-inode compression levels in xattrs
  btrfs: support inheritance for per-inode compression levels

 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/compression.c | 28 ++++++++++++++++++---
 fs/btrfs/compression.h |  3 ++-
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/props.c       | 57 +++++++++++++++++++++++++++++++++---------
 fs/btrfs/super.c       |  8 ------
 6 files changed, 75 insertions(+), 24 deletions(-)


base-commit: a59f57e2aa127c5354168d2ec4bac920df1be4f4
-- 
2.55.0

