Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20852381AEF
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443855; cv=none; b=DjmfoIyTUKgG82uZa6C5qZw2WzTTcCQ8761UMHjNa17BA+QW8xqDnA+skxZVIjR9wMKI58hZYzcgZru8rCXSzG9lHncfAxn+kOvB82k7ehtv9mxzr39FgcRHq35gE8Y0mPXpnEQAe1YYThWVyollsVlRkriUrOkRrXJsA89NSD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443855; c=relaxed/simple;
	bh=xO+7BNscxtGg13ia0PhVshHjYQV3JHM12ELsJ8oZxrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z+j4xf8MSG9TT/2PnNZqcFT/wD+ycYw29Lea3qRqT5HEqtInoz9WO8eFax037XYG+/MyHSJjODUklX31VElxJUN7r7aiYoK4CF9V1phbzXa6/UX/ctk9E2Cg68LETJyR9MhAnBnZezOQjSmuOAy8luoSJ4P0fCdCTe/DkJXfDLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lJBhzswZ; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJBhzswZ"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-488811c9ebaso755302f8f.2
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 10:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790443843; x=1791048643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YrzC3KsGSyUCmEJo7hl7MckIk2oHkQ0xqb55Qf+LydA=;
        b=lJBhzswZxP9zK+Y5gtY6HnK+XPFnRgETfWFvJP3dwZR1bWG5zTuKq/ObpxoW7MIPtY
         kXYGIETGTv31xaOK5FROd/hAC+lgUXl/hvCS/dFvkuRwP7xUV4FBmej8veCZcF1MYAey
         /Vj1qGZdu5lhJ9+SMZwTlzNjEScUBY1ARAaCPuPBwjiMjvZ5R3L0dP9/sCw/5JQSlwxd
         ds5b/gYIw1qfCWbe5XdnD4PZt9qwHR4KTxzef8rclKqRqmntk2pLPZxEp5RjqZ0zemWf
         mUzfH6JQaMadVlLmAndH4FtYX78a84yeBmtajWLYRS8ekRCVCfAw7EbY9EPERL9dQyW3
         5ggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790443843; x=1791048643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YrzC3KsGSyUCmEJo7hl7MckIk2oHkQ0xqb55Qf+LydA=;
        b=fvEHMBGqObVZ+TMJAOrblIedBidG9ssFjdMHH0wkxCs8Zoh38CtwMjAO3OMHDFhEWl
         TgSUIGilKby83R+oVwLyRlNEIA2ZFBbzC9a0HgXJ7AUjaWhxwQcwHnPbISIn9zsbkAEn
         TJgP6TRMcHF+IHKEZm9ao0z8mVtFzKHxGr8L3XK/yrGaUkSFKNv2fDquv5G7UyQwH8tL
         iT2b2yctksh+pUU4fxOhTDM9KfaC0Z00GUU6jalEBbElAW2+4qyqnyIYi6Lt4XhGzgy9
         i20nNkTi/PnZV06Pyc3NDMiuwF0lDhu9Kbl3hvAgN98Jvvgex1Ac/Kfm85byyQZqcoQk
         Shnw==
X-Forwarded-Encrypted: i=1; AKwUvBz/GX4/3MT34gbDX1gQcjqu7IzwoUGXxxocYTyNtyjIPvRrxmMSRTYvZf+L9ic2lgHW9w8D/iLKWtZu5w==@vger.kernel.org
X-Gm-Message-State: AFq9FYKU/fAmcWJKaBQoyZKgDUMx7JL1gu4x9/73CsJ/W65N2b0Bx8PO
	8vZhvjpcVrg2QeuhtVbVzi32bEi7yoVeJlDuNhZGpXtauhqcwlI5zEal
X-Gm-Gg: AYBFou0mvqCGIbQulUFUQf2Pe32KhT0XPuxmlv2BdS0PTEs+T+wHL1Ebgo7wKXfICkI
	jkoGLDDaExO0IRGvQHYmI2kDsnfI+v7FUFSJjktLbIGp3vMEgaISzQYDpHBGOSBnAMJ5mqX3GWA
	8/dWE20qLanjncjzmumJUpYICactZLNBd2O/7OGnKFSAsA5KBiUIdGzDc/QUQjVfMbA+HjzIuyW
	kZb+7VYJct6clCpgzhfujBZHmSbk7/5DADqTk4fjPJ0NiVh3MFpWcwyX455oRUiVZkAtr5FuBbv
	YaVCEdSc3xGnA26AYr6jPikdt9E7gKV4AX/zQH3Iw65mto2lK7BG1NKnVrEvLGwvOCAjM9EsJqp
	Rd3uaHDTo7iNdk9DlLyVykRaiHDFlnmhcMpnXI6Ms+gA5b7KQyx7MOF+PZH2iySXXyG9AHGReoe
	Ey1KKOMyYEDzD8XK9s6iyqN7Z+cmPbVPkO2My+EcKcWKyhmc6VMb6+cXD7pyT9RBL6swIsXt570
	Gw+
X-Received: by 2002:a05:6000:402a:b0:488:89ed:4430 with SMTP id ffacd0b85a97d-48889ed459dmr2818067f8f.33.1790443842475;
        Sat, 26 Sep 2026 10:30:42 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a84221bsm15255859f8f.36.2026.09.26.10.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:30:41 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 0/6] btrfs: add per-inode compression levels in xattrs
Date: Sat, 26 Sep 2026 19:29:30 +0200
Message-ID: <20260926172936.337085-1-koray.fra@gmail.com>
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

