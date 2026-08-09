Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8A0379C5D
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301657; cv=none; b=ofnaX7dt55QCHWBGV55yswnxGSgGxx6h4BiM3JRhzdGFkQPfknDqQgt9A6ebAEeOo8bT//x6YuFYGBRW2dx4+ofDabXqSrHjzIDRJ1UioebHlUtBsJQ7ahnc8Tt41CkuAABf0MVE6bpvsneXndplGXht9KDt4kkqQS8igLSfViM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301657; c=relaxed/simple;
	bh=5tNf7nxXcXBhePkjHDGdlk4AatSElXMLN3LsMlK8n40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FJsajtraqZleHxCNjjdw6WjGIkURPMFsX8ob9/LXWq9tIh++c8w+d85+9LV4eIEnKS8I1PCFxVgWrZtlFN009AYc8CmgeHmO6AyhdzqMVc4fwGJP6RjP696cq03WLbDK7PY8lEJtMpCTkXBFoQZifyxgZkBvsc08hjAUEE6CsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ctEAaHRJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctEAaHRJ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954df200ddso7594475e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 11:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786301654; x=1786906454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dPkN5PQaW8LrHUqFiETO/7JTWr+MlXqL2OfXSue6fwU=;
        b=ctEAaHRJTuS8YsEi9ehYcZPcEld3jqeBUK5RNz2B0DZo3dfm/CIH5ScycotytElUmL
         LlnDWpHSrGv5Wp0DBnCDhSJgZTwPfHlBOMkdl/Zi4NmpSE1TeaA+Dyd7ErbysyG+ebtm
         Vfjnf6ufIdhakNqS64i4rpJ48Qw2cDFLCPIzdA7hqzD5JFn+smiLbWNT8xQajXOAaYdF
         u467cotXOjQ1UPwDICCOGrrhv9z3T5i9NkS3acjErfJ7KTWMyzorpVl2o84Hksw2Xtj2
         gfLyqMTApVJHbgHdGXzMhxjEetESU9Dz272dA2nw912PXpO23hvH7CBk6PI8ECG2jlZL
         eBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786301654; x=1786906454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dPkN5PQaW8LrHUqFiETO/7JTWr+MlXqL2OfXSue6fwU=;
        b=SGbASMEdu5Hix7IiWczasLDjuAeuYa7P8WlzRfhRqjmvYDKLn9ixXKqMF9QJM4cFXM
         QHXFBBXjPfYV3QOWy+Y8psyqPm5N3hxAFKpa+D13F5kCxJhTHtk+j500ridFp27AYU6h
         OdvipkQD9P1JvcBSS7H6sHrg7pq9V1TozdTtdmUKYwon2Mjsd6XM9cuywaSzv2pRv6GL
         kkeJA727By1bcnpCardb3J1K/0xMga0s+p5zi2TsxzPVV34u3oTnpy0VTiZI5MByLwKy
         LvdLAPFi//HzLPSMkGvK96/D5AZWV7bEYp7ZTxtQuRI6SBnMZLIf7JQ/8nkdsD+uMpWh
         WMFA==
X-Forwarded-Encrypted: i=1; AHgh+RpKEaqfnDnr7g5Sl0XXdvwZNU7BSjwSHC/o2roZ7gCv5T3ZjbZaEMMd23dM2rcCbmysn1dVJcLdglDDtw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6QE6awAKn6GG1Jan9K6pCkRJP1omvZV9nKVXCaUDofIPTqM8D
	1O3YmL7PXjR4oL3EJMTdrzf4uDMDs1qnym0/83ezK2+q+BqEwF2dYnEq
X-Gm-Gg: AR+sD13Gw8+0m0n4RLTxHTUU7hldiIG71YcHSJKZOUMelgJ8cjSGsaXSABvW9BqXofv
	dlE/ovrgLjdwq4Kc5LWLSJk+EkN9n/hEkQ5PVz7klao3G9Ib5N0hGqVOcxKhiuSwuK0lCC5ZwCH
	nPViV1Kw57teNSVpmoQ5A2CE4PRCHX8tzFGyPo7ZFPfkKxRYBF7C3W31ELqlEvh4hxTAO3/GnEw
	TWl97yddy3vW6GfI3fRzzmo3kM5j1RAmutFqxYPNN64cjXFDyJ06nhiGSx0P4qlhayQxnUSmPUx
	ztxPGk17keEtpsvV5C+MrcPMos4xc32MQmvtuYlCIiwX3VMqfBFP1yO8dSF7QLPJTZqxbCBZOoF
	LuAxBJKi/iTLGsK7PvPODOvXPuyaDu7RGqjT+ETRFgMg7RUsqyrNN1B7fDDZMW+glp77wUC28Ut
	B8zTFbq1F+/GDvcQa47fGhycGibc3o6DCC1Hl5w7O7govNywY84ynk941ZFniZWW0iqw==
X-Received: by 2002:a7b:cd19:0:b0:495:4bf3:2150 with SMTP id 5b1f17b1804b1-4994e7af664mr387152725e9.8.1786301653569;
        Sun, 09 Aug 2026 11:54:13 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542851d6sm374482055e9.12.2026.08.09.11.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 11:54:12 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 0/5] btrfs: add per-inode compression levels in xattrs
Date: Sun,  9 Aug 2026 20:52:58 +0200
Message-ID: <20260809185303.600071-1-koray.fra@gmail.com>
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
same syntax as the compress mount option.
If set on folders, all new children will inherit the setting, while
already existing children will be unaffected.

This patch series also fixes a small bug: before, when setting
btrfs.compression, it would keep the mount option level, even if the
algo was different (!!), so with e.g. compress=zstd:15 and
btrfs.compression=zlib the data gets compressed at zlib:9 (because it
would still get clamped at the right range); now if the level isn't
explicitly set it will use the default level for the algo.

I also wanna thank Zygo for helping me by explaining stuff and for
noticing this bug.

Changes in this v3:
* the first patch contains only the bugfix for the mentioned bug, so it
  can be backported to older kernels if needed;
* fix a bisection and compilation error.

koraynilay (5):
  btrfs: fix -o compress= level getting inherited by compression xattr
    property
  btrfs: export btrfs_match_compress_type(), move it to compression.h
  btrfs: also validate compression levels in
    btrfs_compress_is_valid_type()
  btrfs: add per-inode compression levels in xattrs
  btrfs: support inheritance for per-inode compression levels

 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/compression.c | 35 ++++++++++++++++++++--
 fs/btrfs/compression.h |  3 +-
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/props.c       | 66 ++++++++++++++++++++++++++++++++++--------
 fs/btrfs/super.c       |  8 -----
 6 files changed, 91 insertions(+), 24 deletions(-)


base-commit: a13307e97d5c54b65720bb71fa379960ded1e51a
-- 
2.55.0

