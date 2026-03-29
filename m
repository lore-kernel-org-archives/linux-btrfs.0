Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDD2126C02
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 06:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774766064; cv=none; b=H0doXuDEAV3GGzG+8jZK6Y0uLKcv4XAlg6W5geqLj4K9HCznGk4DI24iGaRvu1YxmO2MKcQTBsVckwzOnvMFULDntQJca77TKwZJfmTOq4N4+5W5ap/JCNUsMy1rwByTdfWxG1MHQLk2UCVd1CU/VTdC+9CLFpa1Ke+8SUwn0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774766064; c=relaxed/simple;
	bh=qmDqVlJTtHX2UvgMvpy35WRzf+vIyk9h1ORwpXK56Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aJUzB/3jwvUb8cvyt98WLSVXaR2A7OEe7YE5HtbgXBwkAUFblYWQYqQ99GCDGsDScP/6eK5qG4H+eHdBb76BCf+o5X1iCHjYkJuIv8UIR9lpR5mJ/2WGOExKYNZ473a0pXmLOF/iNFDfpORdMBK2fMO6tnSiaA6/RLZDJcuqZEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i0YsgTui; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0YsgTui"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48704db565eso46421175e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 23:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774766061; x=1775370861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=drDeu/ST4zwjbt4ZeNi/3en+8OlkBURHTvmUi4yDDBA=;
        b=i0YsgTuiUQk6KZE4fUeIFTwmWjfrfFdBOLwGuL98H6VpLEbIrZt2EPHwdS6XzI0ojN
         vlEXFerfpMXPXNRdR3j3janwKJBcYdyEF+Fm+J/Zl0UTzbMantMNLpDDgRywVBdV3t+0
         LdSUtz+/D9sXCl+qIGuKlO8wF8jHSGYCGXZ6kxrXi2NPRy7U38Pv4qcZ3chq6qob0VhO
         9OigCgSIHdHBt+S7V2SaR2VZBVonve2tKslSXiU/JA7UJq28oYfF/IDG/+QKilLtb57J
         SD0I0qDF63b1Ifs+5O61h5snjwat8rIgr7pDmyWfR7XPNEBg9smiMSpdunTm9uaRt50R
         tmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774766061; x=1775370861;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drDeu/ST4zwjbt4ZeNi/3en+8OlkBURHTvmUi4yDDBA=;
        b=IfnmTspunv8iRcPxs5BiFh/9L0FMucBOyqkvZzYZwtjshGj1fbX76W1hbsWjsd8hpU
         ictNRxf4G8Pw0+yGpYpYRgSjFfG79OfQ2/kA3MDLasMydy4vaumx7uOMPLgUH8wPodIX
         A0Cvrpad1dRYV1gPiWJ9sZVP4eY+I9O0SfhJ1mdDgHS4CbcHq0gqPUDOdCjvvvb5iyDV
         RjOx6aLR0oUF1sKQJ3eJnm5IZF7xXcueVA+DXiJSS/U5/rVfxGOsiAO5/fP3KFuLLusc
         3PR8yA8iQQO3HKaMGEHV0SbQWSCQBxkNyPTcu5utSg7DwiYLvsvoG296oaxXNWT/8BWc
         vS+A==
X-Gm-Message-State: AOJu0YzcE7Mdb0YlEOFM+mvw6gasBuwLiRBx70uD5ZvljR56PGM6OO1R
	i3w20q0HkmnnkDN5SikTOadUOYa46NTFW4YMd+gaiULlaklHalZpUuJeAnqTPdsFjNc=
X-Gm-Gg: ATEYQzwOIMO5twFp5mPCVGRJ1auDXzeDdSHfr2V0Wt8zDA+QsL89VBXuBgM/znefTUw
	blWt5YpjFkcpHg/jn+lZJATFPUQ3THlaYUx+p80vd0adhuv12kn8jEhOLF32dCSIJ2cOBor9Is/
	HHE8fvxCk+XE22w4uXKAig0hBMCjAV+4QpejNHy1WsTDXh0BY3BWcUtPrfRZbi1TGXowcu3+PXK
	S991LEJVYkysjh8XQlqb0JvQpWXZ302S0vgXVw9zbWqaSabox23/iMXaqQq2i36qTwGOZcrn8Jt
	N7vHcrL+uwhDID+rlAxUDRqmL0EGTRpkBrg9F/+plstZo8RppFWdCUx7h/pJCj6Va0+IZ+m90UY
	j+rUR+gDsNW+lf4WzDZwUnNl1JonGullF03GA1G/oom10Okeua/ChIiwSofnojCcmsTJd2uAOS6
	Kwdx3JDHpvcjzvJhHacaQx+Mb1Q85rKNf6
X-Received: by 2002:a05:600c:19cc:b0:487:300:d9ca with SMTP id 5b1f17b1804b1-48727ee9ea9mr123607555e9.31.1774766060543;
        Sat, 28 Mar 2026 23:34:20 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4873062ec9bsm91500505e9.7.2026.03.28.23.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 23:34:20 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	clm@fb.com,
	linux-kernel@vger.kernel.org,
	Teng Liu <27rabbitlt@gmail.com>
Subject: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree() error
Date: Sun, 29 Mar 2026 08:31:17 +0200
Message-ID: <20260329063417.642647-1-27rabbitlt@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When open_ctree() fails during btrfs_read_chunk_tree(), readahead BIOs
submitted by readahead_tree_node_children() may still be in flight. The
error path frees fs_info without waiting for these BIOs to complete.
When a readahead BIO later completes, btrfs_simple_end_io() calls
btrfs_bio_counter_dec() which accesses the already-freed
fs_info->dev_replace.bio_counter, causing a use-after-free.

This can be triggered by connecting a USB drive with a corrupted btrfs
filesystem (e.g. chunk tree destroyed by a partial format), where the
slow USB device keeps readahead BIOs in flight long enough for the
error path to free fs_info before they complete. It can be reproduced
on qemu with a properly corrupted btrfs img.

  BTRFS error (device sda): failed to read chunk tree: -2
  BTRFS error (device sda): open_ctree failed: -2
  BUG: unable to handle page fault for address: ffff89322ceb3000
  RIP: 0010:percpu_counter_add_batch+0xe/0xb0
   btrfs_bio_counter_sub+0x22/0x60
   btrfs_simple_end_io+0x32/0x90
   blk_update_request+0x12b/0x480
   scsi_end_request+0x26/0x1b0
   scsi_io_completion+0x50/0x790

Fix this by waiting for the bio_counter to reach zero in the error path
before stopping workers, so all in-flight BIOs have completed their
callbacks before fs_info is freed. The bio_counter is already
initialized in init_mount_fs_info() so this wait is safe for all error
paths reaching the fail_sb_buffer label.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
Reported-by: AHN SEOK-YOUNG
Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
---
 fs/btrfs/disk-io.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 01f2dbb69..61e6b8dca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3723,6 +3723,18 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
 fail_sb_buffer:
+	/*
+	 * Wait for in-flight readahead BIOs before stopping workers.
+	 * Readahead BIOs from btrfs_read_chunk_tree() (via
+	 * readahead_tree_node_children) may still be in flight on slow
+	 * devices (e.g. USB). Their completion callbacks
+	 * (btrfs_simple_end_io) access fs_info->dev_replace.bio_counter
+	 * which would be destroyed later, causing a use-after-free.
+	 * The bio_counter was already initialized in init_mount_fs_info()
+	 * so this wait is safe for all error paths reaching this label.
+	 */
+	wait_event(fs_info->dev_replace.replace_wait,
+		   percpu_counter_sum(&fs_info->dev_replace.bio_counter) == 0);
 	btrfs_stop_all_workers(fs_info);
 	btrfs_free_block_groups(fs_info);
 fail_alloc:
-- 
2.53.0

