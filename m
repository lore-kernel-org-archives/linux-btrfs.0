Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871F16DEB1
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 13:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663294; cv=none; b=m+BoBHywX/Ad8hROt17CLUMAWgDDeybhdvgD05XKrGqU+mOm4MPRcC0TAqZy8tYeAnZzp+HrN0WkjSVGfXiS+NFGm8asiMIBbLi+tvKeqjvYjp+QPRTFm158aHiqBdGDEHO9DyP/mdleS41WCbyMac0kBWD8zRJHB3Oyw3sJhYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663294; c=relaxed/simple;
	bh=i0ZdYmCdZbUlwDnPfgBk9FOwu3PxFpceMJwH6g+46TM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sOYKs2sS/Ra+dMOuUUJaVe0DHAbNa9VYZHnNi3kYkSfjF16yCFDpn39wcS2oUanyVUOJ7ScPG2uuvy/XfENsHGl/M4zSgkUY3LNfIc7AHmzCOxEvXZ45inzGKi/motROOYqN6DlXJR58sVvGL5GhFhDRO7Gv6rp6bqo0qCnLjSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G2zBt5x2; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2zBt5x2"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a422090b2fso6807496a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 06:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663291; x=1788268091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Sr4tozUsBGdiPqfTFjv9kV2GfHMHU8SpDNwsFMVNdI=;
        b=G2zBt5x2wAuRWepTqT3D05wHOJB4MYXxGVdpRciGVh/rhzRa/I+Em1JBONkNNPuCIk
         9DkLX911oHS2TscVgGuQi6NtBbXck8/wpBHKAH295wHiWaAEA+JcQ/YW3nGpgjKGRw+9
         gTGgI5SL+8o5urD+BoJrRnBBD+DbCI13/Hv2cZvxobC79oony7usrpcGhuzmKSqCVCwB
         eStM3nlnmZ3rO/LoPn0LkB2Afqi9njkZuXqzHRWmtuQS2S0c6zXM7+1Mr1B1ICoA4qJI
         GFQE+RqtP7+Yh9KwIQlRj3yv8Ibn6h5yN4dIBrNicZzvEY7MZKYz6xiwcgcK06Oo+qp2
         mp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663291; x=1788268091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Sr4tozUsBGdiPqfTFjv9kV2GfHMHU8SpDNwsFMVNdI=;
        b=YRXUYNBy0Ga0PGz0RFqp4MUtC3xd9vd9zMB17Dh4zSy7gGlr+2XHtYgTHrGEQlmQ1e
         auT6i8FCRaQaLVmL/aapGFa1sliXy0RveJUHx2FJIIDjMUUQ0xCDpb6SpLdAPsuAuDie
         vBO/J+3aTFOX9jKlCuww7g1VXxxhl/he0YrL5FLTlBtuylggcU3wNf0tZNVN0x7cDIbZ
         Ynp99JqFvcbF8rvZdIcR3lOjEiLeomkzi5hwB+dcN47gj5V8KJaq+tonHKs0QGpP07Mr
         c5fthUxaQYoXDfXJ+p2Qf9zJDMMUWTSLETYsCiHyIwCDO6G/LFM99Y44bpdvDVe/csZt
         qkpA==
X-Forwarded-Encrypted: i=1; AHgh+RpCmy4hpv2j81qaldxalzgdK44x925MlX18qPCZIgFoXKDY9EzSt8lhtoSSYFgRCeSC1QlvkGsJtngcDA==@vger.kernel.org
X-Gm-Message-State: AFuF++mRmaZgYPvPA38IGjzokqV0/k/HtfR1zGhjGSKskMB9AOSd0+Ud
	ZcM+J/Y3RXcVHLwXvwthipBQbBNxGJ5YpP1A26IZ0VTe+0S5QeYZXDZ3
X-Gm-Gg: AR+sD10Zt5/QmKsECGaYsn2nxXHdFN8SYR71kGQIsCZsWjlQnzJEZhOZUiOcrz3RJ7b
	7Y/DaZKXNe0tgr8xzNc1UxM4gZTEPrZ2x54r/jh0RXHx1gK+3vdm1Tk+Lg7qr6B34kIXczZ5zUg
	uYAcwvzcfDGgGbXSA9FGIe+9p/aMWeEBBcj5nB2Zmhv9edILXZeW7CpIEtKc3bU+OQPGk0eqMOY
	gSUnRMOqVQbH+DDULMzblcS+dbc8hVVtJzQLtTqqa7CLe3Uk1sv99UPYBo2kCPlQA38sE0fO5oc
	1euYXuaj6XbhKMJzoLnzolxKJJvdrnMo9U5qtyERngPK1k2BXbKHI3kn8poEwI+W71ZLPSq5lGG
	SV4XxHmu9OSD4dCWdb5C4NalLfdiBVng8VQk3qOzzwol5ypTAhrabAACQMmYzPwdD6a1jDXXPJM
	BYZUm7EQlfQX1FZMkV3flZJLoM1B5qbJAONA/uChGmYDWCz3CvK6i6ncPql4Tp/4+h0Wg=
X-Received: by 2002:a17:906:c147:b0:c20:88a6:8210 with SMTP id a640c23a62f3a-c24e5d07914mr799790266b.9.1787663290653;
        Tue, 25 Aug 2026 06:08:10 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d6f203acsm796317866b.24.2026.08.25.06.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:08:09 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v4 0/6] btrfs: add per-inode compression levels in xattrs
Date: Tue, 25 Aug 2026 15:07:39 +0200
Message-ID: <20260825130745.229008-1-koray.fra@gmail.com>
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

Changes in this v4:
* remove the single patch for the bug, as per [2]
* reduce code duplication by putting the level parsing logic after the
  algorithm type logic, using a level_pos variable to indicate the
  position of the ':' instead of having the same exact code for each
  algo.
* add btrfs_compress_typelevel2str() helper
* fix btrfs.compression not being preserved when *any* chattr operation
  gets executed changed

[1]: https://lore.kernel.org/linux-btrfs/DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com
[2]: https://lore.kernel.org/linux-btrfs/DKLRY9Q5SEI3.VUDASVYPW9MY@gmail.com
[3]: https://github.com/kdave/btrfs-progs/pull/1152


koraynilay (6):
  btrfs: export btrfs_match_compress_type(), move it to compression.h
  btrfs: also validate compression levels in
    btrfs_compress_is_valid_type()
  btrfs: add per-inode compression levels in xattrs
  btrfs: support inheritance for per-inode compression levels
  btrfs: add btrfs_compress_typelevel2str() helper
  btrfs: preserve btrfs.compression when setting inode flags

 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/compression.c | 55 +++++++++++++++++++++++++++++--
 fs/btrfs/compression.h |  5 ++-
 fs/btrfs/inode.c       | 10 ++++++
 fs/btrfs/ioctl.c       | 13 +++++++-
 fs/btrfs/props.c       | 73 +++++++++++++++++++++++++++++-------------
 fs/btrfs/props.h       |  9 ++++++
 fs/btrfs/super.c       |  8 -----
 8 files changed, 139 insertions(+), 35 deletions(-)


base-commit: 818bebeb63dd6bf5f4e07e145f6cdbace520a34c
-- 
2.55.0

