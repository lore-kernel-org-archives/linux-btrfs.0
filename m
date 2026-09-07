Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146CA395ACC
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811581; cv=none; b=MstktFmlMuv9QCFnudn/Pm5xDJaSqrXV+5gT7NdwO3GC+TZxqSljMtxMgGWTb9VD/Ybr2JAdrFW5uT/kJ/+nCw+MD9BEPKPX2rAsocssvxnIdwqHsc5KLJtBtz/jDt43YAulNi7XTW3BoZkPFOn5pht8pSQyK2WVMAZorbkaOgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811581; c=relaxed/simple;
	bh=CqL4TS3yN6p43OMMfp87PhA+iYPCQDlqgxf2JKgSXXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jptHFFWxsnZec8mnlsEx+Z0TP0ObJTfSdK0zcpVyszBdmcWTeIZWEMD4xxPw/vr73N+eOZ24/D4pFtSTckAT+VxPwG47EqeIiJNQcg7aHtBO//Zbtk5Yltch3ynSZB3G8mECk5Y4ITUKtveqIez0seVqaGx27dIIssPC9UqTcn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jALzFkah; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jALzFkah"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49d0b98d6d0so19267425e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811577; x=1789416377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6HgmCB+qq50rCrf1C352IJJl5YGb1V61XvHqTc+4M1A=;
        b=jALzFkahOHeThc6HdYllq83B+jqIJp/PgI3XgKLvlL5TgNBFq75MBFtd4HcwqKLE6N
         QAQfdnAzhJExMeylupvKI0tKvmup7yMdVafgp2tao8BQbEmXqAb7VS9JPrmGaPvRj0HL
         lUOwqpZRpuEQ0aaeYW4tj1FPs9YW/KHQ4CBnnGOyQ9bUcmzxF9DNNQWbUb0V+lnOurEY
         VMHsF1m/Z5YIHeil9tw4uK5byFCAOXvV05MROk0enPOmhDeD3Mqn2mwlczPOeXSi9pQZ
         adiiHhYaXUFBru9wqNXEag2IUZNPsWlZQEGd7bPy/puT46CqPHOBDH1PXar6z7zjhMsI
         SkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811577; x=1789416377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6HgmCB+qq50rCrf1C352IJJl5YGb1V61XvHqTc+4M1A=;
        b=WFdCv3F6SIJrEZqRIixvz7WNhjyXlRsDGRA/SLltN7uS5rqYIS/ESPHvf9cZOy/o/J
         w16GA49m/1ujnIN3jVO2/hOrVKwMHT/4qoyLTm+UfeornV2g7wsdgphk1ic01p5VvLrr
         GoCMz39D0UoxF3REB9e/gS5p44aSGKcduGApSnZgkVV8PEUUW7NhGUI449ecGHK9ZORG
         MBP8zLF65pV1dKqmC6qE6hiDOoaP+U3T1o77izwq7WBz23uCGwctARAYXPEDzWAt1i3M
         EdZl4MFuWenks1cQWTQ/umZQAq6fuHVC+Q01w5FfXhV+aDKOTLxemIjEbi4ecm2yt8Co
         5ZmA==
X-Forwarded-Encrypted: i=1; AKwUvBx4kTKbAn2KTGf0Tsfyvt335vDgBMDNqjxgeXYvEHLa7N1iCEbhE7d323iQp/sYV7VjTiWiBPQl0VpVrA==@vger.kernel.org
X-Gm-Message-State: AFuF++nnzkOq9VyFWZzuwYZ6PVzKJe1myTuA/WGhz0UciPPqEjieb6Qk
	fIRhI46eqvxZGFxIqgQmMEeHNijvbf2Xx6VedPuVHYbm9vCqLTcKt3o3
X-Gm-Gg: AYBFou3MJsy/siC0wah2tzdAdfSx1uyQcx+67UTxh2Q8i884nMQ/l0ZA+OUvaw5+ml+
	1SS40HpHlCUpKtwyn3KLbcv6kIyuZaVbhgkjEiiY85NY5bw8iTpcDz4rGHfySxCsLwnsxrERvFu
	kpsiCKnrWr61FPYI4dFMgJ7zmOIScZLT2UKJo45HGYo1WyniMKfguBQjTUS1hvU1Avrv0JzRjcc
	PK1AytBW/otnc+xlZPwenKg8GU7jq7N6osO6yDBfmS6dMo45/M3yDJ2s1NEscHAd0AN22Q+mU87
	K0nqkw8TF4ynU0DPrVNaCoY3wiIdXfotQSDJV6oXUWeMqR3xV+Kpfs2QjEExezm7XXtjPeMrK9G
	vQLmBcD4Bi7ZZYO/UGOXMWBFdxRrPecNlE3WbRyyHTdXH1+aglIUQFAqTlqhhOeGcwJ7zKTwMtj
	04/HFn7pUDAsF8tiQj2HnqcWZ/f/XOsqPO0hLHWHBOh7T5h+aFu4qEjeBfJMrVo1mHsw==
X-Received: by 2002:a05:600c:a01:b0:499:7219:122f with SMTP id 5b1f17b1804b1-49cf8222d53mr244767525e9.4.1788811576761;
        Mon, 07 Sep 2026 13:06:16 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm431050225e9.4.2026.09.07.13.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:06:16 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v5 0/6] btrfs: add per-inode compression levels in xattrs
Date: Mon,  7 Sep 2026 22:05:12 +0200
Message-ID: <20260907200518.428277-1-koray.fra@gmail.com>
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

Changes in this v5:
* this is exactly the same patch series as v4, but with merge conflicts
  caused by Commit e8a0095c7df170 ("btrfs: preserve the compression
  property when other inode flags change") fixed

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
 fs/btrfs/ioctl.c       | 27 ++++++++--------
 fs/btrfs/props.c       | 73 +++++++++++++++++++++++++++++-------------
 fs/btrfs/props.h       |  9 ++++++
 fs/btrfs/super.c       |  8 -----
 8 files changed, 141 insertions(+), 47 deletions(-)


base-commit: 966bb86e7420c64f20edaac5ea096da9b16dc458
-- 
2.55.0

