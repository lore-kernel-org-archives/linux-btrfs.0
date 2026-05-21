Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4185334DB46
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779366602; cv=none; b=sAL6ZKo4Ux1LoG2PbZcyqwJw2SmxvNtrdah3TO7DU6C4dOpX3WwVhi4ld+9mXj4r+2K9pFhgnQUNOaXlpIrAHRhrfw77uWTJTeaHGOAfg5VBJAzAqfuE5xc2KRkDsGND1+MFDbOlePJz3Hw9ovC/LToHPkJZLxfhkBh9/VBm68s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779366602; c=relaxed/simple;
	bh=hP2QHObYV/AGwyrFZlEGl3ZzwoELcoz/pASe9Ez5DuY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RPP3iFx+03eAfYEQevko4ofElkfctLfbEGbBKwvlmp3UfPByheaoLa6njGA/L5F73oAe6HVX5Z8RxRxh+zHEBzTUvnOm4/wH9JAJfZKboZdCcm9U4CnY+bahSyp1bK58iEOtDXqByna3GkXf5v4ug7LePxBN8C9qtmJG5TkCB3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WibCPUm9; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WibCPUm9"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82faf871346so4709067b3a.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 05:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779366600; x=1779971400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aA7WgIDiCQ5x0h8SvcBCCp0yTYb+FeSe1qj3JxGxTdw=;
        b=WibCPUm9d3zn9NztJSiiLtURVXI2vBr3aFkq8gHoAwU2wXxPeFdxe7oWxIMKTQhYQd
         DMEjPiqdYK9zLQHl4HzlIdAQGMDJj4YKazZpOZTTQu+de1DY00zCPZNxZa+dgCAuLYqF
         UTJIfwiTbczvDGC7TNZh6lIjHd1civ1ZCTesfoVnxW9mdOjVxxBUUcsZ6+VMuh9uW7Wb
         6r+2IL0t/W2p7hKX6Q3eBZczxS/6yWkP+BAiGiFUkIY7rABX0tCFawTpn0gEHwnj6k/N
         h913co5h84jp/l+vCaoDbdLErZm+CETR/YR53eSrMGEH2Bg2ns8128yG9V3LQsd2KPay
         TNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779366600; x=1779971400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aA7WgIDiCQ5x0h8SvcBCCp0yTYb+FeSe1qj3JxGxTdw=;
        b=TXLJ5Xp+ovniT/Ri6g4tmYkFzP3/GbtKzKwhy3SvaMTUxG6/57sORWPhGMJ7szXZBF
         lOaSSKaf4iTt0ioTB/S9xFKeJd4/sNvzovfGW1owzL4RGM7V/UY7b6zMzAOEorYPULbO
         VnmghrufXrh6/VgV8tYKDq4x8XdeEHKSd74R71+aTGpWiMf3UPxf4zkiJFnAGmWiFly2
         lP3znf0mfIy/EBHqr/tpDs3LYtp4wqMLR9aGLvMgKv1n31mgZ8InDuV895bqCy7x0IGX
         BXFjVRrE6uNDiNoDp4LypJJFbEQyNSZzmGoQfYfal+1xWtMe2GtcvXm6Xoa9kAzzCkjv
         fLAw==
X-Gm-Message-State: AOJu0Ywzh21XJ6WetQ+2ogpcVMpyxFI4QGi5TyYH7EL/dB4XbvcpO3IF
	XWIcWMHE14iodtDoyoqgSfLKb6f1zPibkItIA43BSvWF3zZ0oZV+ECWQx0/KPKJv3lET00bQ
X-Gm-Gg: Acq92OHC+uxFtOBFtYKlsk+s4PqVq1EWIX/6ERjkcAx7HRu6WXy/LIfdXVgiy0cwFMq
	dGvAd7P/0sIlyKa3TgTfJsx3u13KrvNg4PrB95WYqzN7t1Ct2pxJJWeAUYUxj1oTlDR4Heo4CF7
	+wQN2ghEIF9Tpt1RTHuArJodyMK1B0BU9SxHUwJt/v9NCsFNGViCdTaa1244p1xEoO/UEFZUD+z
	OWhxI4VXGsw0ESWAh6qflDuZHNKCgVc1ybZuT0aXPMHvB+g4P83ZJhHyjxUX+gss0TM4dpXonM0
	EnPyHAm2l0GZQg/vd3AVtqkxeO0wJs5lo55918+2qtb4vD2eIEva+Uuh2XpQBObCoUgEDdhTCx0
	btR25sFu7qRuYeR0gVfIgdspXm2dLPia8YAUVitEHc5mVT6noOiuVu6ErcdG0n1PMQ/adkfgTpM
	HIi+n6CsVT9sNoEQLDYb7XjEm1v/EBFXuMiyCh5oYT+8Rx9vf7oEh9yg==
X-Received: by 2002:a05:6a00:6018:b0:82f:5051:f024 with SMTP id d2e1a72fcca58-8414adf6980mr3151339b3a.27.1779366600533;
        Thu, 21 May 2026 05:30:00 -0700 (PDT)
Received: from Collin-Windows.taila26705.ts.net ([104.28.163.94])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154a000bcsm1026374b3a.16.2026.05.21.05.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 05:30:00 -0700 (PDT)
From: KangNing Liao <lkangn.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	eadavis@qq.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: protect sb_write_pointer() with invalidate lock
Date: Thu, 21 May 2026 20:29:45 +0800
Message-ID: <20260521122945.524890-1-lkangn.kernel@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sb_write_pointer() reads the super block from the block device page cache
using read_cache_page_gfp(). This has the same race with BLKBSZSET as the
one fixed by commit 3f29d661e568 ("btrfs: sync read disk super and set
block size").

Take the mapping invalidate lock around read_cache_page_gfp() to
serialize the read against block size changes.

Signed-off-by: KangNing Liao <lkangn.kernel@gmail.com>
---
 fs/btrfs/zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 16dd87aa06f2..5f75cf0e14b9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -131,8 +131,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
 
+			filemap_invalidate_lock(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			filemap_invalidate_unlock(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.54.0

