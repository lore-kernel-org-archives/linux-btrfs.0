Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735267;
	b=usK/xxdL26hNZ1AQXhVME1MMOEA32S/Gg9kta7nqtz88v5b7MREXmltdTzG0nD+966tO
	 HDx/p+c+QHxQiji8q7DXivIfIBNI0a4lTdQlAilEOU5VviZoDTP1/tg7o5sJPFlLLxPaz
	 G/QOQUb+Z3V/Npd2J9klmOO/7bn3p7x3N+jNv7Tqq8vsZmqNT512BgcBrMDqD9/Qxz3WX
	 i3UVxjGR9IKUH8D2OeMutsVg3l73gY2OhqMi8XfhK8aO3lFkRWt18zm5pce6MCtU4QqWN
	 /pKzalKi3FZNlhuYqYW+ryrixTcGX9/k3P3ySCUUvob7K9ezADQU5EHYYcq9bhuJdqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735267;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lwXO2pWBwZVoIcWPUyFVU4SxkexRrdvPa4wf3Lt54a8=;
	b=oR/Re4otQvUGrNDDPlY0HA37JDO/CeWMyDTWnnS0oDyqQKN42EXgjYLeOAXhNUf9QB8n
	 uIYC1vKMBUkSAiNVqhyerms5QEkxv6JZ0M47fAdu4zyIPfxvZGXWdYQJKcm8MsDNXDmOc
	 /8jgtndUv/bO14f4YpC2vtZ1+eHx1MKK4ADswd2iD++Ac76rQq/WbJ0mw7CWDW6ng8lxW
	 uRe0TeSqoQ41oG4J3f+KeZTh0iik8nmup+cJT22k2OPBrlsZ9hn7jfwLryEaUE2zReQb+
	 IKR15uRw87xXHD5P+i+8jmif8C2nXHmBiJ3wxPGal39l+Qy1B9x4JHrvmcTUDPc65sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbLvWv0J;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EE9606A326
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 19:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11EE9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbLvWv0J
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso45943205e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 11:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735265; x=1794340065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lwXO2pWBwZVoIcWPUyFVU4SxkexRrdvPa4wf3Lt54a8=;
        b=dbLvWv0Jsor1CLTOFzLesSWl+Xl0S4KoZ3tWas/6ci8jvkLo2XPD2wN7BJenj2iEaB
         YSgNYyrQdQW/rW/KUBh7Hd7gZ+gWjIr3LFPnQxDkvZjOrEVPQRw+X3KNuaPsET2cvZUF
         WnMv69r935Yb8BjSkusnjm2EGoudI21lph4zHecOLDZ7vzq6eusTvxT96aQL8raL65E+
         E+Unk0HNVU45ilfOBsixkkn1mbvvFmeh0GczjCUcx0jpWCtPVi7397cIFZBxZV75HLP7
         eKGy6Iq+D3kyy/WZRwY/p6teSE32hbY5DAAa+ML1iCXDjybawHeghbW0cV10HGf+rm+2
         Fa5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735265; x=1794340065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lwXO2pWBwZVoIcWPUyFVU4SxkexRrdvPa4wf3Lt54a8=;
        b=jAAv75RF2n6CmvSXz9Wbt4NnhVSm/DXEyKSSK4UCfD3q0I5MzE/+E45ki9ELXxKtKI
         zc0aWrmxD7rkybv2sng5/Ug1lKCy9plZmyufG8EuaiMQ42/fTtNGq3WtauQ32dah4pnx
         hz0dQMbrzKDO9N//7eeYQj4uJ6GjJqS2QNzwLdhQf+es+SmMHLAodwlUKD/S4k+aO1os
         C6hwAxzTvyDEaM0OO0zgd/fqBNRWvsSlklIbKfrHkGnbzDLp+D6s32VhF1l5TQuTiqW4
         OD6Ymz11C5TJ/NF/mNcrCm3GtqCVhWYYz7NmiNdgVWXLVUY7YcsF2zkiCX/W0qUbJRE/
         ujnQ==
X-Forwarded-Encrypted: i=1; AKwUvBzno8VnJvxV0mIPef9QLBSfDMKjPpdr2LX5vE4ujyWGy2q0B4RByBzg5/UtaTFOxMJsdjKw6Nkg/3XT8w==@vger.kernel.org
X-Gm-Message-State: APuU4Z9LtWk2TPHa2luGm6k2RcmBVWI1Oxigs23h5LzdlHaER7unzgHi
	KtvyZbakj2kSbOBsgnamrbofVq1fZqoeLIhjfe4Yw5iOGKeKLlpkw6YR
X-Gm-Gg: AYBFou0p79QusS22MCWYxVwsxymxAEkKmeOTPWi1PV0wMRtHMfzmZcWzP/fWIb6iOXJ
	oaW8qA67QMScPZo/FSLsBQvqRtks8jmAMdK2vtI9i8OxeuVnFL2QEGFBb65th7y8A00eTgo5Uv4
	ZHQOn4yZl6ZvKBSfwTXQiYY6xLXhFQhAje5lnj6oang2Rzg2/7DdelbCq4jXffzLO9P88MEfrT/
	JBWx2269gbJSQNc0N8eEELfnUTzVDJ4gEFlYv/w7G5G5+Jy2J2k71zFgi5+QJKFnZR5Z2f558nt
	vPNHFvDixHNmEdztEJFw+EpkmwF6v9PJ/kNTfMWy5eLtpCn9gmVitp3NAzfIQP8upMTrNOkxkYn
	6pyQ8R7HyTMh2pOusyMzCNh4WjeQjsGDeywHkiyEQC3XSGBIWMd0+7WN3un3h8wVLepulWKEbV1
	c2xNNFstlg8EZ/sBlJsUSasoGCAfx8p44ml4LqJ0mNIDiO5MMIqRZCFdj52+oP3Qt+7/OGIFFS4
	ANU08FZwtlDHoFAcqHj+uAY2wA79G3Zh8ul0tFjWwjRUX4BQKkyHmCnenRxpqnDwFdQLovCxmB5
	RPNm2w7r/5mjAewJ7B8OrR+o
X-Received: by 2002:a05:600c:4715:b0:4a3:598e:e7a8 with SMTP id 5b1f17b1804b1-4ac150b28bamr330926945e9.4.1793735265118;
        Tue, 03 Nov 2026 11:47:45 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a879f401sm76832035e9.5.2026.11.03.11.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:47:44 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 0/6] btrfs: add per-inode compression levels in xattrs
Date: Tue,  3 Nov 2026 20:47:28 +0100
Message-ID: <20261103194734.598182-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Add per-inode compression levels using
btrfs property set /path/to/file compression "algo:level", using the
same syntax as the compress mount option.
If set on folders, all new children will inherit the setting, while
already existing children will be unaffected.

This patch series also fixes a small bug: before, when setting
btrfs.compression, it would keep the mount option level, even if the
algo was different (!!), so with e.g. compress=zstd:15 and
btrfs.compression=zlib the data gets compressed at zlib:9 (because it
would still get clamped at the right range).
After this patch series, if the user doesn't specify a level (e.g.
"zstd") btrfs inherits the level from the mount option, while if instead
the user specifies a level it will use that (e.g. "zstd:0" would use the
default for the algorithm, and "zstd:10" would of course use level 10).

I also want to thank Zygo for helping me by explaining stuff and for
noticing this bug.

Now, there is the question of having a fix for the bug as a separate
patch to be backported or not, and there are 3 possibilities for that
(original email listing them[1]):

- Option 1:
  don't have a specific patch to be backported, keep the current
  behaviour on older kernels.

  This is the option I personally prefer[2].
  
  Pros:
  * documentation[3] can be made clear about this behaviour, telling users
    that kernels < 7.X will "support" cross-algo level specification,
    while >= 7.X won't and will only inherit the level if the algorithm is
    the same
  * won't break any existing use-case
  
  Cons:
  * new users on older kernels will encounter this bug

- Option 2:
  have a specific patch to be backported that keeps the current behaviour,
  but only if the compress= algo is the same as the btrfs.compression one,
  if they aren't, use the default for the btrfs.compression algo (e.g.
  compress=zstd:15 and btrfs.compression=zlib would compress at zlib:3
  instead of clamp(zlib, 15) = 9).
  
  Pros:
  * fixes the cross-algo bug without breaking setups that rely on level
    inheritance in a way that makes sense
  
  Cons:
  * documentation has to mention that the behaviour might be the bugged
    one or this one, depending on if the kernel has this bugfix patch
  * may break some weird use-cases, but no one should really expect the
    level to be inherited if the algorithm is different
  
- Option 3:
  have a specific patch to be backported that fixes the behaviour
  entirely, using the default level in all btrfs.compression cases, since
  levels wouldn't be supported.
  Equivalent of setting algo:0 after this patch series gets applied.
  
  Pros:
  * very simple code fix, 2 lines of compress_level = 0, while option 2
    would need an additional if to check the compress type against the
    fs_info one
  
  Cons:
  * documentation has to mention that the behaviour might be the bugged
    one or this one, depending on if the kernel has this bugfix patch
  * breaks all use-cases relying on level inheritance from the mount
    option to the xattr

Changes in v4:
* remove the single patch for the bug, as per [2]
* reduce code duplication by putting the level parsing logic after the
  algorithm type logic, using a level_pos variable to indicate the
  position of the ':' instead of having the same exact code for each
  algo.
* add btrfs_compress_typelevel2str() helper
* fix btrfs.compression not being preserved when *any* chattr operation
  gets executed

Changes in v5:
* this is exactly the same patch series as v4, but with merge conflicts
  caused by Commit e8a0095c7df170 ("btrfs: preserve the compression
  property when other inode flags change") fixed

Changes in v6:
* switch from kmemdup_nul() to a stack-based buffer to avoid a possible
  deadlock spotted by sashiko[4], and because it's cleaner, so also move
  the BTRFS_COMPRESS_PROP_MAX_LEN definition to patch 2/6 instead of
  later in the series

[1]: https://lore.kernel.org/linux-btrfs/DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com
[2]: https://lore.kernel.org/linux-btrfs/DKLRY9Q5SEI3.VUDASVYPW9MY@gmail.com
[3]: https://github.com/kdave/btrfs-progs/pull/1152
[4]: https://sashiko.dev/#/patchset/20260907200518.428277-1-koray.fra%40gmail.com?part=3

koraynilay (6):
  btrfs: export btrfs_match_compress_type(), move it to compression.h
  btrfs: also validate compression levels in
    btrfs_compress_is_valid_type()
  btrfs: add per-inode compression levels in xattrs
  btrfs: support inheritance for per-inode compression levels
  btrfs: add btrfs_compress_typelevel2str() helper
  btrfs: preserve btrfs.compression when setting inode flags

 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/compression.c | 55 ++++++++++++++++++++++++++++++++++---
 fs/btrfs/compression.h |  5 +++-
 fs/btrfs/inode.c       | 10 +++++++
 fs/btrfs/ioctl.c       | 27 ++++++++++---------
 fs/btrfs/props.c       | 61 ++++++++++++++++++++++++++++++------------
 fs/btrfs/props.h       |  9 +++++++
 fs/btrfs/super.c       |  8 ------
 8 files changed, 134 insertions(+), 42 deletions(-)


base-commit: 6255426d70f2755968bb5436ae7b43dae742ac38
prerequisite-patch-id: dc4e24d82d513b8e80e171875a73d397d7ec0762
-- 
2.56.0

