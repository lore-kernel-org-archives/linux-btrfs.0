Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE25329E5D
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 02:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156525; cv=none; b=mRQPFvHV7JU/MFlgTbOyjL79oo9UXYjgjBEgYvngj0xqZ8dH2TWDzmrnBPzVo6KaJke9vb1ocwnuc3ApOL/JH/qLLHwkh85UqdshFc34+HTOM0LInaxGua5b1nAJJvjr26EmS/4jIXMcN0NqavticuoTEdJ6+o8Oux6ofSV9bhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156525; c=relaxed/simple;
	bh=QiayysKdbIS1dVj22EVt9QfEasK3UIDYnmvk223hZhA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FK0DNFrVLuk+Rn2xAiOD3ZDLFaju0e0e/SqBJ/5BVi71hbfFc1ldip1gzMtkq6RljiynnETqG1nQdIxmMhNeFJ3xToU+ZuUE946Lb81znzgAsgvZ2kQrbL70g022Jfd9KvL7YVqgYbO2TGUIAGSnqODT3TafUN6EzToSefXvLqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bh7gAtSm; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bh7gAtSm"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-472326ca506so49945f8f.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 19:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786156514; x=1786761314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K+cwp7DUftRSD9otPGjKHQg3+nevH5xipxe862j6GG0=;
        b=Bh7gAtSm2d/HyiWoM3OUxEk/W9RNPPtGxwIkydRFolPvj4OCfxkKits7nFN+YZ6J6D
         Znqg787retOUhQsUFZqJdOV/Yq82YsODj/DXymNQq+d3iCfMC11ph+HmKHDLqP7O0PFO
         8q44OJLD3AfIrRtZ7SVJf8DREuz7UdoNxHYptxZCFla8Wy7M5nXxWTnV7wvIKwS1/ycW
         76Q6lWnMiRhJcgu/SLTxtur/q3Ln0070klmFYJMU5Xq8qZo0fjKVzg3clC8JYU/qj+e0
         oUzPQNPQKNcVN061aPiYPwdBi/NYiZW5VAPJkRkkjDdgikhyjsKb/AMq111+TjtxdmkJ
         kbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786156514; x=1786761314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K+cwp7DUftRSD9otPGjKHQg3+nevH5xipxe862j6GG0=;
        b=My1xsb1Z9LEh/Njd+Lc9attAtqnpdjtLw1v+KvrwaENaHJWkbZBs6SQIdIH5pEqoxz
         WWSdp74e3DyeEcLL3iBddQM/9ZjMt5K2TyPUEOteBgPm+evKBy1l9omD2WGxuzpaD/gG
         bsv4UdH9F0bOPmRE8X9vAQddf0Zi/6WwNyaHB5Cwlx/2LOMrWhkLyV8GhAaOEw86p8zk
         XU8TZ4kAQaQUDfOG51bdmpFVXqvrNjwmg4c32xaaELWvhAmBjNsHQvmlndNhgUW37Zij
         tLLyTf9zf3GIjr78+gCjpUq8cSY87yFTUhzzH6EQSBrcz0pQP2LS2Lx6e4R5ePNkpIja
         60iA==
X-Gm-Message-State: AOJu0YzK2RT5Ep7dmNP+BLNfzCtrVYzGhr+Tl+bEcYbl99bD3a4drFF8
	RfSZUJB93WBkKrqnNP77SU5Zmvwa2D2n0B+iF2k7dT5iqkfbEgm0Wng+EXUmgYAJsh8=
X-Gm-Gg: AR+sD13NhvGzTWZ76kHMEK1MkO239kgbsdRL0hScIpraU7J+1iFQ0Yjn5Hzypbuab8r
	Msn+TDmmVJyNjaLi503j9XpLUq5g3cwkQ2+A+lIXYpev2jYzSPvpaZmfBzhxp/mV5xnzafSXYlv
	+f86k5sjTEmb4ng3AmfZ9SeO1z+goo5RjwK4gR9FNLGiETnEo+vcLPFGQ33F62f/xDtkvAyIDxv
	7fVjgiginME1FHmEmmcEGmAuqCNun843cpG3x/8xKIf7qmOpdSkmKsWI9Bnj6ccftoNifdb7hiH
	SgTZQwu10Ily2OL5X2U/0SDFaEiwNNVabh97KYWXqtVAPaUwGV0HRNeTPhdJCr22nOmT4WiwMqq
	fIcR87GC2bnAq7a60rTuVqVNKEo1OCAGrznjA7hrbsLT4Fq5Q6o5BrNOYBcBMpLF/Kng1fB/wgs
	cAEFthrAXb7VCUwobmn15OxeYT99X2Or0hm6jQm1mv3WppyaA+UKzfyy8=
X-Received: by 2002:a5d:5541:0:b0:47a:b86f:3ed1 with SMTP id ffacd0b85a97d-47fec62bacamr33943485f8f.21.1786156513609;
        Fri, 07 Aug 2026 19:35:13 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800214557esm10571244f8f.2.2026.08.07.19.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 19:35:12 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
Date: Sat,  8 Aug 2026 04:34:55 +0200
Message-ID: <20260808023459.1494928-1-koray.fra@gmail.com>
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

This patch series keeps a legacy small "bug": when setting
btrfs.compression, it keeps the mount option level, even if the algo is
different (!!), so with e.g. compress=zstd:15 and btrfs.compression=zlib
the data gets compressed at zlib:9 (because it still gets clamped at the
right range). This way the behaviour of chattr +c is also unchanged.

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
 fs/btrfs/inode.c       | 14 +++++++++++
 fs/btrfs/props.c       | 57 +++++++++++++++++++++++++++++++++---------
 fs/btrfs/super.c       |  8 ------
 6 files changed, 87 insertions(+), 24 deletions(-)


base-commit: a59f57e2aa127c5354168d2ec4bac920df1be4f4
-- 
2.55.0

