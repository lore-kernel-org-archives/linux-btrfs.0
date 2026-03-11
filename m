Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B893DB64F
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 11:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773227818; cv=none; b=cAXUDipA9Pq+eVrUHTj6j2OJR/r4re6QlcXq9Q9q9hpw+SNOvVeACAKamQiSKeTaD1KKofIluiKdi7O02DD+XD0iY7jUBPojdrLjklj1fzXgOMnnZpofk0kiikOGOnolq7stboPGzZa/M6ni16Y5EsxmdAVe+N1zRvICWmKih70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773227818; c=relaxed/simple;
	bh=XGc+lIXpLzI2z16a5YWNBgyGUBvdtMG5A/UDFPfkdCc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fsy7iCKPJul7SwnB3YNaaXkuJK5ub8pYV7Dz5CEcreKjDIcmTi7QJpxb5M3hK9MIJYYndrlSxtybqjX5HishtBeOIlowF49MAN56Cn9aHIhJ3wsbYRwrbD4BvCYSwkFd3iQ/gvojuE1Jr+alPthQpGMU69o9XOEm+nR82zaZWks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GdufyU/W; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GdufyU/W"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ad4d639db3so62307405ad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 04:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773227814; x=1773832614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MA1vNBIvj0q/vs+HsgjgV9EFaAZZQznWpheg8h1fwT4=;
        b=GdufyU/WZGfonyXhK13ghoa4Rew5s+6x8pVpTJYZ+6KQASZQANtKJdZhB7fGz2UcNN
         u64KZh9zYVmVBNcFUm68kygpo3ICOf6aaenaXPURRMUp7Dl7dMroev88yp5rpynG2tf3
         ASzI2B2gASihyjIBURcsEOo+6tHGypr7ykmfuLplC0+qAyhPVk1I/r1R1HolcZJVGSVX
         bghfARQBqeMu2WVBHrm4G0wxcnWTg0pMqQV4TYJ6/LNiBOcopWF/FWwgz6YIy0UjXA4X
         XRNAsFx94JRGxlhSm9aEw1KH+QVHOTJUcP/BC83lsJ1zLTDBSCfKZcKG6TJIEbGmH3Y+
         hKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773227814; x=1773832614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MA1vNBIvj0q/vs+HsgjgV9EFaAZZQznWpheg8h1fwT4=;
        b=w3N8shI5yutus7dFxPLUA7c0SIh+A6FiJ4JsroswpEKiFhjpgqeJzfNGzTVA2c1pMX
         XhHZJcJLnhsy+AA0QcZ/7NHRqTKqDI5ggFZ/GjG3t8mM0qZyh4TpGuUxURkBISDxhwGy
         RvL/5YqU2uy3rkgG12yEpYTyTf9GWn2UogbgfmCFOghKadOMhu7Me8tx/8YwK/fKnuW6
         t1kzCuieLHan9cIqhKYG2TTYzyQylZqoMFJSQQMXd7yyAsuBfOJgLIx4SwhI+YJCuAPJ
         HNJ59Z/sg8g9oT3Ge2an8mFQZntAZiwL80u3i2L7FU/rHDTnFt5ExufE7j/djB6/rJhq
         efDA==
X-Gm-Message-State: AOJu0Yy2iTQuvCGsRHtFjlv0d+rumD6+Bp521f6hGyF+KMJU208BrIfe
	SKpQbd0TRoxDqaoM2QxLTlKMPwc6aU+o8+GNbEsfUlWDdPdKyga4msEL
X-Gm-Gg: ATEYQzzFE+JxChYlWhFkTy0/ijOx1bDAtoiKyRmbnxghxv738s9KjCAbrhJGhdQdy6m
	0rKie5L9rPJ3uoEtoqB3HTRhdyarWSRKbtE0sBCGVh3lJ98H2LKiY8l8J9zFIl7ezZD7UsXvadd
	geV0bInCrH4YLUWWJEd+xE2e6eWtDubgGn9tjbKyiRo9YCejco8G8+ZH3GOiTpBLE9bFq0ZOSRY
	xJ4rOpjuTXJfxFrxkwT+lZCwPgRMmo66ZszKBPdpV5gVgnXI5XQUzKb1oDLgEedYrokBvq7fqcE
	IvqP4+uV4oB0nUqJNiacQAD/4KtskVczUfVN8UFTkkBabtvENnSZa3CasbJeUkUXCIDmQn4TgmC
	6nmngtBC2dFaZ3CAGhe6NTiLT7vY7j9uk99ZjnVRyAPxQlD20uM8s54wwnY6iy+9ZxmFx1iB4rS
	HDsdugSVaj49nwjw4Oq0XEo+nibWg/Mdof5cuQARRBbL4ejkpyRJCEMD0BAIoCJ6avQA85/g==
X-Received: by 2002:a17:903:2bce:b0:2ae:44f4:1678 with SMTP id d9443c01a7336-2aeae9698d7mr22224785ad.57.1773227814088;
        Wed, 11 Mar 2026 04:16:54 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae247cbesm22377015ad.29.2026.03.11.04.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 04:16:53 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: reject root items with drop_progress and zero drop_level
Date: Wed, 11 Mar 2026 19:16:32 +0800
Message-ID: <20260311111632.2836293-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
When recovering relocation at mount time, merge_reloc_root() and
btrfs_drop_snapshot() both use BUG_ON(level == 0) to guard against
an impossible state: a non-zero drop_progress combined with a zero
drop_level in a root_item, which can be triggered:

------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:1545!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 283 ... Tainted: 6.18.0+ #16 PREEMPT(voluntary) 
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
RIP: 0010:merge_reloc_root+0x1266/0x1650 fs/btrfs/relocation.c:1545
Code: ffff0000 00004589 d7e9acfa ffffe8a1 79bafebe 02000000
Call Trace:
 merge_reloc_roots+0x295/0x890 fs/btrfs/relocation.c:1861
 btrfs_recover_relocation+0xd6e/0x11d0 fs/btrfs/relocation.c:4195
 btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
 open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
 btrfs_fill_super fs/btrfs/super.c:987 [inline]
 btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
 btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 ...
RIP: 0033:0x7f969c9a8fde
Code: 0f1f4000 48c7c2b0 fffffff7 d8648902 b8ffffff ffc3660f
---[ end trace 0000000000000000 ]---

[CAUSE]
A non-zero drop_progress.objectid means an interrupted
btrfs_drop_snapshot() left a resume point on disk, and in that case
drop_level must be greater than 0 because the checkpoint is only
saved at internal node levels.

Although this invariant is enforced when the kernel writes the root
item, it is not validated when the root item is read back from disk.
That allows on-disk corruption to provide an invalid state with
drop_progress.objectid != 0 and drop_level == 0.

When relocation recovery later processes such a root item,
merge_reloc_root() reads drop_level and hits BUG_ON(level == 0). The
same invalid metadata can also trigger the corresponding BUG_ON() in
btrfs_drop_snapshot().

[FIX]
Fix this by validating the root_item invariant in tree-checker when
reading root items from disk: if drop_progress.objectid is non-zero,
drop_level must also be non-zero. Reject such malformed metadata with
-EUCLEAN before it reaches merge_reloc_root() or btrfs_drop_snapshot()
and triggers the BUG_ON.

Also fix the related tree-checker error message to report
"invalid root drop_level" instead of the misleading "invalid root level".

The bug is reproducible on 7.0.0-rc2-next-20260310 with our dynamic
metadata fuzzing tool that corrupts btrfs metadata at runtime. After
the fix, the same corruption is correctly rejected by tree-checker
and the BUG_ON is no longer triggered.

Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
Reproduction (v6.18, x86_64, KASAN)
===================================
The PoC is relatively large, so it is provided separately through google drive:
https://drive.google.com/drive/folders/1Rto3DUtjUTOg3bjFeH5G2Kl8Li6OuzsG

To reproduce the issue:
  1. Build the ublk helper program from the ublk codebase, which is
	 used to provide the runtime corruption capability:
	  g++ -std=c++20 -fcoroutines -O2 -o standalone_replay \
      standalone_replay_btrfs.cpp targets/ublksrv_tgt.cpp \
      -I. -Iinclude -Itargets/include \
      -L./lib/.libs -lublksrv -luring -lpthread
  2. Attach the crafted image through ublk:
      ./standalone_replay add -t loop -f /path/to/image
  3. Mount the image:
	  mount -o loop /path/to/image /mnt
This reliably reproduces the bug.
---
 fs/btrfs/tree-checker.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index dd274f67ad7f..a8c568b10432 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1256,10 +1256,27 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	}
 	if (unlikely(btrfs_root_drop_level(&ri) >= BTRFS_MAX_LEVEL)) {
 		generic_err(leaf, slot,
-			    "invalid root level, have %u expect [0, %u]",
+			    "invalid root drop_level, have %u expect [0, %u]",
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
+	/*
+	 * If drop_progress.objectid is non-zero, a btrfs_drop_snapshot() was
+	 * interrupted and the resume point was recorded in drop_progress and
+	 * drop_level.  In that case drop_level must be >= 1: level 0 is the
+	 * leaf level and drop_snapshot never saves a checkpoint there (it
+	 * only records checkpoints at internal node levels in DROP_REFERENCE
+	 * stage).  A zero drop_level combined with a non-zero drop_progress
+	 * objectid indicates on-disk corruption and would cause a BUG_ON in
+	 * merge_reloc_root() and btrfs_drop_snapshot() at mount time.
+	 */
+	if (unlikely(btrfs_disk_key_objectid(&ri.drop_progress) != 0 &&
+		     btrfs_root_drop_level(&ri) == 0)) {
+		generic_err(leaf, slot,
+			    "invalid root drop_level 0 with non-zero drop_progress objectid %llu",
+			    btrfs_disk_key_objectid(&ri.drop_progress));
+		return -EUCLEAN;
+	}
 
 	/* Flags check */
 	if (unlikely(btrfs_root_flags(&ri) & ~valid_root_flags)) {
-- 
2.43.0

