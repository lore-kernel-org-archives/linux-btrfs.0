Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF127368D51
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 12:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780488344; cv=none; b=oxf0vPfsgAZ8cnu3o+qJE47NhZE/dNghOVh9FT2QmDAjV+iY2ephlocrBZzHIHu0YkH1i/tQWbi0GwvIgAZsm0N8AAQ7toSURycdv2ovW3jvvDon8CBcE03W22CNwi/sSpNClUHwON+hZMHxLrN7pjllZ5lgp0hXjTMip91SBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780488344; c=relaxed/simple;
	bh=7NFsRasn8T3zyLqanO3jDYeY1SxFMHq38Y43WYMOIKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YqKl0ncWeAcmojqs8OMVBOlo9JsrRqLwHju5Y8JsEuOZAvoJ3ZIfsOQd1zxkqyXKeRIF5sZ1+QnVtloefg/w1g6JNF2xCx2+OqPwS45XGj43/qEXjRcyChtlNoxubwmgty6mVXcOL5MXWhTRjX78lrFK69ZJ0gv3y6z/zRZJyFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dfgql663; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dfgql663"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84230ab8857so1867842b3a.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jun 2026 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780488342; x=1781093142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BJkVFTFP++6lvX7D98bQzjb1G5a2yBkaBl1RBWQ2FC0=;
        b=Dfgql663KVmlo/CTqeAvHOG3Prd9bvglz4QdktZWDx0DJZjP7lY1GGVlF1vjEF0gNT
         sTdoIq5ttWrNE3tUCdwewgVtTIAXVEPF8xbDE1R18e8duLLeFhfqqmNzMO3XjDuGGHYY
         1WYEHrg3Y6u8RCCjNLU4krYXdxzc/HTCpkZjssJvWjucv+cv7J3HSIlLuLcGqbdpAF3V
         rx9m6Q16Dajil0BRXuRwBf1v+0tmKsFla0ozxQ2Dn1RvaUvfifX2sXElEdm0S1i44nL4
         zP3hFxdgKroCcry4RtBk8zqxfQ7l3ZNKJt592qCge5QIMS8x0kRhhDUaFxWL6uO5w7sv
         mwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780488342; x=1781093142;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJkVFTFP++6lvX7D98bQzjb1G5a2yBkaBl1RBWQ2FC0=;
        b=GZ44Xu3WTV4pfsa1dfpgSCWMraegqRHVOJlHheK7h87Ys7wHmEwia99/yLsZHMEg3U
         D2pexbkFRcn4n02LAHSXCfL18Y8FY8tzvWwwiDvrXRaUgUjRbw1mPSe6Sr1saj3tt804
         SyCv0bdD9R00fQ9F4q+jlqemuBt88WsVo/OhGkzflgOa6rJJjE9hKNfOZZwcjm3YO9VP
         pHhPVyKAHnNvBfoknBRQiPgm0Px17Byqp52QnsjlOPf/sAvfwGSrWGTd0X28XkIKBtnq
         LhX1gC/CT3layonXKN+4oq55dyPppRPvurThRq61bn2KTseRs3pWKc702Gc5CHXkkC1j
         VnIw==
X-Forwarded-Encrypted: i=1; AFNElJ9qs8UX0MsU+13vkbt4qlJHzQvqTzDG6X3UYOqBYfa0T5zwk1gb52W7jv9Ss6vwhN906LFfQmnZX6HA+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMhH/k/1S6W0ggCJ55PQ04/jAuAmS6TZbFalyaHcjRjxFIuy3E
	aWYsR2XbPnqaqV/TBRerf6HcnudWh25jQ6S+DoIGSYfBavBRevaWGwUs
X-Gm-Gg: Acq92OHlKTUnE3fi4UdnmFwmzoY3gmFnBrfFMWKG99hj+HOmxw01x9y1QL5j4T/TYjM
	376QmQIvU4oiP2WPPs5u+SJOrbixSpLKN0PstAcuSXZtmg07sS8eAL5ELSwGSlyc/rX2/mUrEt1
	rBsZcp3ElmfmkpnkHv0LpWetJ7Ctpknchn7/YIVr8E4skHAy5icDIryFw7rmMNtFvo31kNURXyZ
	V00dxlai99xNsfV0uZFpevrfZvzB9banUm02rdETDw799Vp+yimJzasG6By6YwXcjZ9TstdQs7T
	FtKA84bVPQOm44fMZqjRMLJWKx7xyfMGbldoy5ZdHssk8QEFetPexgKjhuayAAs1F/ViuvsIzTC
	QgGacbcK+RiuS7mntQq93z8sH4FXVZ56dHWNrNcLKfAFH+0jRK+/VDeq7J2m9GpJfscby9TNK3c
	ec73QEG1ZqkZuSU0kAeibImV/QeJ9UDB8=
X-Received: by 2002:a05:6a00:3288:b0:82c:ebae:3cb with SMTP id d2e1a72fcca58-84284f0d090mr2886891b3a.43.1780488341967;
        Wed, 03 Jun 2026 05:05:41 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282372868sm3230422b3a.17.2026.06.03.05.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 05:05:41 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] btrfs: fix inline reflink deadlock at non-zero offset
Date: Wed,  3 Jun 2026 20:04:43 +0800
Message-ID: <20260603120443.1394044-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clone_copy_inline_extent() can copy an inline extent into a page of the
destination inode before starting a transaction. If that page is beyond
EOF, writeback started by a transaction commit with flushoncommit can
invalidate the folio and block on the same extent range lock held by the
reflink task, while the reflink task waits to start a transaction.

The copy_to_page path already updates i_size after copy_inline_to_page(),
so writeback no longer treats the copied page as beyond EOF. However,
clone_copy_inline_extent() has an earlier new_key->offset > 0 path that
also calls copy_inline_to_page() and then goes to out, where it starts a
transaction. That path still leaves i_size unchanged before starting the
transaction.

Update i_size after a successful copy_inline_to_page() in the early
non-zero offset path as well, matching the existing copy_to_page path.

Fixes: 05a5a7621ce66 ("Btrfs: implement full reflink support for inline extents")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/btrfs/reflink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 49865a463780..5722cccb53eb 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -185,6 +185,8 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
 	if (new_key->offset > 0) {
 		ret = copy_inline_to_page(inode, new_key->offset,
 					  inline_data, size, datal, comp_type);
+		if (ret == 0 && new_key->offset + datal > i_size_read(&inode->vfs_inode))
+			i_size_write(&inode->vfs_inode, new_key->offset + datal);
 		goto out;
 	}
 
-- 
2.43.0

