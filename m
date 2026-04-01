Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22D1377551
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 03:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775013233; cv=none; b=GFZzZLJarnP8IOt7BLlfS4w+GSp5+dddj7cHe/7eFzrf9swsunehbWYc3YQaKBr8GTNyKel16x6EBqNGgHWlA+B/Ctil6JJ3nFoBHiKjZVfM1Y7xpZ5wcf25KKXkc27ufOpIcnrswxsE7siQwg+HO9TeCkfBw2HVrVMkpHapc0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775013233; c=relaxed/simple;
	bh=3qmKi+7NGTPmsMSzwTSl7l4uTJjqFPzwWq1vjBmZtio=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PIC7T0GeD0YJRgQXguOIZq0aIXD+G2QGo7zM4lJOSBQ0uFg04D25m0Z9IMM7p44b6c4XrwBerdi+ioYWnmJ9QcvZ+teGI8OX3ZnhgmUmbCE7mUoqWBznSGrIHi+0F4QGHt/ALcYIA5TOpwxQzSvUUFHl4ygUncUzmKjJ0r46B4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UwecOi1B; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwecOi1B"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35dac556bb2so1766130a91.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 20:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775013230; x=1775618030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BfmezofCFYRgZ5OFemKApUxmmUyvqX/ZDRNGUel5g18=;
        b=UwecOi1BkDsrv7hCzMJqB2BGQHO+1WvQqkufTt5CXODXslXsz+4WtnMUleRJzkh33Z
         +o2rjx5HR2qXZJRupu8+hD//e9iGbtwpwjQrH1w/7Rcryp1R1wZrY3NoYnLhmSsMUxmC
         COsVTUj3/ux6SLUPNOkd+dWm7b2TZTGNqhaOD/f3UTBsfJRIZzDceuBVZ5KaGOR+CWWq
         52Ay+i5IvmSasj4cY+pS7hE4p6Y5dmdNsogDHiN+LUSljN0JAEH3JuPg5oP9teXPNOfe
         umlJU/02wF53yYY1PAeiac+75Kbh71QWNPSgIpAcO5LECd+Crscv3/YklLpH86neyaX3
         seHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775013230; x=1775618030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfmezofCFYRgZ5OFemKApUxmmUyvqX/ZDRNGUel5g18=;
        b=TROGIUgYv2wcRbvBf/G/XCxLz6+xQzVtyVMRfOIvK3t6G1XLtipTvO5z+wVcGj+Of8
         xIj3nmd852XKZiJNHuVFPZS77t2BFg01TEnQOeAuTj+Ey9BLF98uUbrc/SiYP5JO9QLZ
         AJzwrADznDOlQiFSqJnoqzhUZlJBGbGYNxEqrQbASU5jFaZKCS6ubx8YGr3mH/CXrobd
         S70xOiI1mftHwU7PUWAGMNvpgw0OmN0MTPwR/YdxbDiFTXMDENT/0TZ+kWgxLjQTh0bB
         dobvme/ksnKejeI7z498MtYV7qgk6bQ3U1BT6LLNrvbyTO44GuqFWikwoh3dFtwYVTEM
         sLww==
X-Forwarded-Encrypted: i=1; AJvYcCVUQceM3SkpTykR2qr/m7PIZJso4iiVMb/hrbBxsGRt/l85yLH2OBSwzlAhVCsCsvELsdMQf8+2N3J6tg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyN35PteBf70efpS/CNBi2Tk7BazzGiDSwAnLVOA5pycFZC+nyK
	FGhpuQR8OoeX6CVa5ijQr2MPsOcJtUbNCyMGxTZbaEiOZAJUN2WAORluFzFSGfT52Q8=
X-Gm-Gg: ATEYQzy7u9NOLbptJiXwV2Pw3d0MqOtjXGvmq/LtGX3/RBezfhq0DYlDlL96y7m1M+/
	vG8hB2N8OARFA/xDnaiEbLb9ysUPRWJ4w57UfdIkr0BiFjxz/VHhsejwCf6wW+5UD5/uKkd7c8u
	3M6gpEGoJSxWdImIxVeNsDLtAOD5C0keP0+LKL99vvh0R5wOI1bcVZuO/zsCP5cdZKUavrFvCjq
	W53DxpRfbgWzWDYHaCGrC0kHlaC5TKtGqj8GW9nz8giQRwm9CRgCGCenwPSqIqBgijxG/hAyfQ1
	lZzeg5VOlQ6fLulGHvyqPW+dq6+jEr0730PCdqLGZc+RN0vIcpaqD5arXw8t4B7Z8bAp3UOJ1rr
	gYLNYuqIzpQPrjykoEk49/EE0/2TjJDle0YuuZkL9cIoXDx/wTTmxbOGNDUcARZctr4PBjdFvDi
	bPo2PnHH/seRw8IuVQ3KAsMA==
X-Received: by 2002:a17:90b:1350:b0:35c:b02:b5c1 with SMTP id 98e67ed59e1d1-35dc6e2d00dmr1661679a91.2.1775013229891;
        Tue, 31 Mar 2026 20:13:49 -0700 (PDT)
Received: from lgs.. ([2408:8417:e10:5f85:653:6a84:ffc9:685c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76b986ec97sm1659337a12.30.2026.03.31.20.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 20:13:49 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: fix double free in create_space_info() error path
Date: Wed,  1 Apr 2026 11:13:39 +0800
Message-ID: <20260401031339.1418417-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When kobject_init_and_add() fails, btrfs_sysfs_add_space_info_type()
calls kobject_put(&space_info->kobj).

The kobject release callback space_info_release() frees space_info,
but the current error path in create_space_info() then calls
kfree(space_info) again, causing a double free.

Keep the direct kfree(space_info) for the earlier failure path, but
after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
the kobject release callback handle the cleanup.

Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() error paths")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/btrfs/space-info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 3f08e450f796..d7176eb2fcbf 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -311,7 +311,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 
 	ret = btrfs_sysfs_add_space_info_type(space_info);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	list_add(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
-- 
2.43.0

