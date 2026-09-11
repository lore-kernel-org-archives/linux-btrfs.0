Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E53A188596
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 03:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789097635; cv=none; b=WCuEuFMeefZEwfBIha8DK0YkbFVeSopHL6IpPiymnsQTWK3DBfSo1h2Ss5xs1SGAeN8MQoyr5Hd12VDuEBF8o2NgyK2buhzgAq88/ZdlH/V0z2Ke53BU92PYc8DcrGMB9KuMNqLJkXVJrEOYZDTzjA/NGCq8f+Bs0hbg2lWFPRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789097635; c=relaxed/simple;
	bh=xO+7BNscxtGg13ia0PhVshHjYQV3JHM12ELsJ8oZxrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LTOKt179/QRO5ffprSVvOxEX4SNDiGHxZspfPr/cvRUpxfB6wL81w5OjbCeombzoszAHiJkwn8+cbyLBg7x1ZY+lrrloELnOC1FxZ7l+tmsJm30CmCRaNXCsVNhB8x68nawBcmGVR0AvpC+B7bLRPicQNLgwWKrgXFArOiXe4Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KW0L6k2p; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KW0L6k2p"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so5103405e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 20:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789097632; x=1789702432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YrzC3KsGSyUCmEJo7hl7MckIk2oHkQ0xqb55Qf+LydA=;
        b=KW0L6k2pUQ4orxBZQ1HWB2GrLNhN5U2uXU5vVBcGCE8SC5dETATczbzxHMHC47TJuY
         zE8wxT79YwE5J8zMbXasIL7IYxTYUqjF1zwukPoiurTOkFZCCaa3CdiQRqWWyvlVIANx
         Ree/XgAZ64Ccq1AVCSQP3kiOfxbMdJ8nICZv1J59pwT1hbPn25DsIQwMMcP4jWQFy78M
         fXnbegvyYVu1D8q7S9mMWnWHwcu/JE+rEAWqw0l/8fqqp7o0/leJH1rdhbfzc+rLQL6z
         l5uPnPrFB5aq7mRPUW0qiFJ4UG4YyoXPQIcYqBo0hjFRgYpe88WLHtZWfZZ//+wPilz/
         Dy1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097632; x=1789702432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YrzC3KsGSyUCmEJo7hl7MckIk2oHkQ0xqb55Qf+LydA=;
        b=c4E5Dstn+EyTFy1KGEscDlV05s8l62NSzSs4OiB8w6r8rJHRsqHw93QvTaBdmMpP8+
         SQLlwTB4qBmzUivS/Oyuyf0xTkHe089JKF1YjCV0/TbpqxC1SjbFCu54DfIsjW9G9inV
         59eou/DEjAL1VzTtHWlUTxlYjEROkkgArkAQrKes+GTu6mQd9emCj6kAyz4XXLHipZBY
         oNxUVmi2jRUuDFNZUc7Aa8TgS7Wnt+qDchzzgSHzZyy0yudp9La1tKbGUJR03xt0cMAs
         GfK5ahISkDiFr7Ky652i3hBRs71aAJS3UlUsYgvwBVrqsA6dwTzr5b5ye7yaLG1pFRH4
         nHTg==
X-Forwarded-Encrypted: i=1; AKwUvBzJZvQ1YTuvpPqYKr4FdHt41DizuQL6vGb213Qe5rGZkLlqCA2R8TAv4VHpxmypyD7Jq/kTXOE+L2c7Rg==@vger.kernel.org
X-Gm-Message-State: AFuF++kLyQlx9RC9Zjfodnjoj3rJaCmrjBUt705dzU9Y3YzCMceYOD4Q
	EI8cfe+bTB120/Bf9816pTYNTMJUNm6VhZlmWFjbsDmfUubVoWDx+0zS
X-Gm-Gg: AYBFou2AWAQLJWOR/qvugqtllaP7W11xbLsUZAdk700J+EqjTAeMr2K9fi9/gILv/6S
	E8arrC4sUy9CyBdlnm7x0oOkkV7GINB5kEvee6rW6Gokex0cEC4yb+nrM+R1WOOov4WSCkLLG8E
	iwRnCqlXIbly56F5311esYT2USUXufAlCPMpN9zI1ogZgvOELHUPGqN0IK3rJxqgFNwuWx4K3HL
	4y2U5I/i55BM/SSLQWs5pBZqtL5SJo7OZsDkN6BjeWrM8tBNQMzS8p9IUgji6SDMyAY1OHvOkSj
	LW9ncOQ6qF2gmz12TZdAmxKzOiWGioAQTl+G7MxdSgbWC06p1mw1JMKR41AqVLDD9ypFmJPPSsY
	mX5OvhNNOE+w2NeO9UHqToJBJXNKepDuGlTspIuHZFsWfvJ6c2yZpWRIJ7xd+OfWlETR3h9MkwU
	vbJ+5sqwQykU9M3Bz3ffBADYiyUwjqIUPjtY5ZlxJl7kGuTJETwb3hQUzCGQ+CjTtACA==
X-Received: by 2002:a05:600c:8b5b:b0:49c:fc6c:be1b with SMTP id 5b1f17b1804b1-49e619d5301mr23891785e9.33.1789097631608;
        Thu, 10 Sep 2026 20:33:51 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ac42b9sm38935095e9.6.2026.09.10.20.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 20:33:50 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 0/6] btrfs: add per-inode compression levels in xattrs
Date: Fri, 11 Sep 2026 05:33:30 +0200
Message-ID: <20260911033336.957102-1-koray.fra@gmail.com>
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

