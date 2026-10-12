Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F74C4F62
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 19:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832069; cv=none; b=k8vlz+Llg6dhdtGrUCNkqFdpubydn90GKMMnu40wBQ75QCgzutjoWQO2u96KTIMwiB7wOzsXKSkBZK9PnpfBrRBxUnxQ6MPQ8lewW7R8qJB+qkN06bUuxWGolv/oFpx3oIDvTnrmw8usve0guP22tBZ0e+7fpUer2aT6ksGPjs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832069; c=relaxed/simple;
	bh=xO+7BNscxtGg13ia0PhVshHjYQV3JHM12ELsJ8oZxrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iqWZuiefTZtSK8AytWcNoVTEdlN2abvTpi1lMwqdVSfbKjtckhH36elXYvaVJoB8iP4lCeY4INKwohAWbZAvQk05Uy1aKSACJGusmsPNaxsfBHO5MbNAK7LQvQeheXNokWTK006eQnvpFx/cBnTFxg+kK7kDLk+eWx9FLA+G3RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEhxZiMS; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEhxZiMS"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a02718da81so17028715e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791832066; x=1792436866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YrzC3KsGSyUCmEJo7hl7MckIk2oHkQ0xqb55Qf+LydA=;
        b=jEhxZiMSdNPXpfFlxXyCRtF/PDlwuMzcF/3MJmZWOEK5GQo+DPkw+oVCNE/LHG/XXI
         VUErJqPHnhnliFA+PSTWAHED8lG71ghDoUaGBcGn8l1LWscrQL+vooBYlLO4ZLTMXM1l
         2K8doWwrFzRgVvN2C+hxHLYNzvz7MG4Z7CXqmez+KXjXE7gfJsfYAgGDV4H26brjO/DV
         iwB6xM0M9f7+3A6D6HCGZP+YKKuLg8BFKf9qfxa2hLViep7XRVzx39vQ/d7cn1wWb7Nu
         adg5yRpQBP8UZ40t5Sgt7Mko7PW+/lhkAIzNYylJAoaAYmUayIGB5VVBtkgfdcVQAzRr
         T9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791832066; x=1792436866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YrzC3KsGSyUCmEJo7hl7MckIk2oHkQ0xqb55Qf+LydA=;
        b=Mr140nkrXFuIA3fx9Yp+y85QA1TTdGNaoWspvJ8SOUD3oIb+Tyyda4Rx9t3xh+rGZz
         JQ4WK83NjK2tQAM6XIzSuht+UI59wjrnRapySlK0S+ltFqkyhqK//jGpw7NnKYB4bIHf
         g/evhJ63muCrOczHrwz9cfWW0240PuYcgKQiSGnXdIDE+uCEeR7nTvlYn2f7yjBOmnaQ
         xcj/NbWJO6rsyNgHQ7uaJws9pzNmy7Ks1kfZ4NwFQDgSfgPIfaDW+oWxtFm0r1SF4toZ
         zFaHIYU+6myw1b4WBhcPYzkdrlhmQUxxMukjZ67m6++bYh226Nsv56LPtKwFyGMXUbRA
         1xAA==
X-Forwarded-Encrypted: i=1; AKwUvBwsSpZ0NrgrDRcoHRq5cQ6pyMuNHiABWF24kIgJqzUCfm8A5JGSMeW8+gnncKxcMzf+VRx/l8g7touC3A==@vger.kernel.org
X-Gm-Message-State: AFq9FYIw9xhIV7FqqomEsoIzECRBHtJj10S7qu9WD8uIraYNkLg0msyK
	UyqNA6F0A0OKkYw1gYJhXU1bVDbiTkybWFjOgW1C3SLEk7ppjJXKScbn
X-Gm-Gg: AYBFou13ASm/bIRW0Nn/NLrZd+dmPsCRUdATGDu5qryWOVQzFvaH4ZwAfQ948ramGR+
	zSvjXpKQAXcQ9Ey00Qin9ezmMSZzsCtqddEI2Et/V+dPYygnfqwYkLyKtZA0ym/nC26/5Dj46MY
	N9AwSQWTKnl4nlzHdsqgIteflBP0gpmVMRIG+8oOvXEaPZGM0mLvN87vedfjJPR/aQvgpMlnZB3
	k1wyiE3iYwrUrodDPRnjMJzKQSD63QivuO2BSnxAHY04EAc6BUAhxnx2DS/kSmP2NvrkvukqqW9
	V1dOcwK15KBU/gPO8T81hcUUzWMG/B0lvUuLwXdX34IqdRLkffhvKPX+iH9MOzJL7hX4JzkNP1E
	bytq4Ktqnhu1JA5kq3wvNjAwcExN6kLFRc4QnnPWYzKfLd6at4T0Uz3MYuTjixrp3bn5h0vP8f2
	QiBpDh033ya+nV0N2AvhWvToc3XTWmA2ySmLCtOhVJ8a8OVPT+Kk5WId5eLWBM/1ba+A==
X-Received: by 2002:a05:600c:3e8c:b0:49e:6861:50f7 with SMTP id 5b1f17b1804b1-4a18e49d251mr187892875e9.5.1791832065500;
        Mon, 12 Oct 2026 12:07:45 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a195002123sm299461215e9.1.2026.10.12.12.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 12:07:44 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 0/6] btrfs: add per-inode compression levels in xattrs
Date: Mon, 12 Oct 2026 21:07:25 +0200
Message-ID: <20261012190731.951056-1-koray.fra@gmail.com>
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


base-commit: 101ce2445ccd1561a7c3589ff022982a1e4821b8
-- 
2.55.0

