Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6B217659
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 05:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783230409; cv=none; b=iE8OtYwzodyaExhpGAmJR0lkKEMtocYAl5eiMSwzzyZwgUysecF/xfbm630OQYV9aD+Ug5ydjJLlhJmd2pk49FD56/SwVhwXOfqhuqBsnWfJ5rMe0AliUasiT4UO1VbC7qKxP0dy+CjWGSJmpc0dn6sMafLqCpGpDkAYdfte4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783230409; c=relaxed/simple;
	bh=LdQzW9q6mYF9eTtMq3lwa3ru+V+0PbtPFXH2DUppvUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JwcPyrbNfericgNPLC7wbQZ2fFIvVqMeYQyQnAT1My9Q9gGax7VA/cWbc2C3phQOCgIytlzxkC90WKAgFLqw3yFx5Cbzq/BRmEaQd4RNEa3f8id00LiVpC8vOrB7VJ9Dra/zTPwp1VHgdiOoju8faBptF2GV6MWaLJ4A4RGBma0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O1q1Ksgq; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1q1Ksgq"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e501244f5so79489385a.1
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jul 2026 22:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783230407; x=1783835207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ne+Bd1M34ZDKXIA9MnfvNkgBhE8gWUH0Qf5ovBjn7nc=;
        b=O1q1Ksgq4QrbpHWLlt0Z93Yt4Y0/5qn+LzVpDKfIEBjtXkX5yTGUxI4AUNBJzHN1+Y
         xMLMZwrDGTbIrqhLOnUB71cBb2go6nKQhEjvsxVlFMsy1T7OeOiFhs5mHuY92U3fbfww
         ZnOnJyjWDBM4ykA5ZpwG81t6Vjv+vXYGgZnINtzg1xDJpVJuWVGnEpin/SSLIH5OCEec
         iZQfpqzUEE92CBBU+AdvYAlOWYZxsufw4r7q4P9NkjtxrmjGNxrMTSkLbB3g69yZjjbp
         6CIAgetDlrXL9E/9/ApTZmIdxyyV11nWYNXxpTo1NbrwNlTgm/tJEd+VM+1euLsQF9f5
         PAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783230407; x=1783835207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ne+Bd1M34ZDKXIA9MnfvNkgBhE8gWUH0Qf5ovBjn7nc=;
        b=pNtZh2fKBcStbc8u34J8UHtPalcW1xipH+C74Bu4WbSmJD3Fvt3BI6mdzh1Dd8Tdgk
         caqm0MlD5340ELjUSUvZw3RssmJ8MIqDBNon56ACFv9+n6NkuUG54v6jrSMJL0Lw/ubr
         LDwoJkzks4zawYjSvo704tg5YQM6ediGmpNQR9X4cYgxa9BH04d+rs9Z+u+Gn6zuH6l3
         7q+y+mXLxMeao56PT7RlgVPU9kDq5fZjxWwJX5E8myusnDmRXzjtNKRucvhVMq80ztnU
         4UxYXyWoQiI3lmtWPISClCuomyAP1MEVGLRairLGU++OeBvRsu9O98iH+0WyLnULu0fo
         Au/Q==
X-Gm-Message-State: AOJu0YzLJ7y5JU1+z/yGUe7RThiodnUZKD4utzIyh3SFm5w0EqhIn9y/
	RVI53B+H+IHaTIlE2DXz1gBasUnTxctJr9ZhSKVfZfMVlGat/5LPYFgR+abC5Q==
X-Gm-Gg: AfdE7clSbqt3A3qLeST7cbgxDYdf5gUGZGLKyhKy+zyDweYDBR/r4zEZabAT5ANX/i+
	ysXoEjsnZc3W0O1A1uYmD8i2C9YwlRHtQEUM15A2vesZoBn2umOk2LN2L6vF2LlarNItA5AEnJW
	fWlgaPsKrqpEpl5T7Ij+KDs3TACLNiIJVzIAUZb6dVAujqt3Ma9E1CVSMcvIEKbiemr5ihvkNss
	59nc0CKHlvfHNSq2R8mbDe1NNeLk4qa64ktUbfRhzsbNRV5iPHwJldY5neHXJ1LfFAAVie47JP3
	/qcLhidXASCazHoM5ovCTVUgmkLSkiTfZs4FHRfHFx67K0OQI+p7Z/Jx5rk+JCwUMlSKAnu4mPP
	E/koDrC4qk8g/luf+75ngpRzsytM5prIOQFWLxwmF6W2Eh2zjYnEkR+TuFNT525kvAMhFaWHLKV
	ql2nwTqNaVvfbFxyf5wwUrAAjqu7F6CPSDOcZY/FUrBA==
X-Received: by 2002:a05:620a:458c:b0:926:e8e6:36b2 with SMTP id af79cd13be357-92e9a3cdf2amr726767585a.32.1783230407025;
        Sat, 04 Jul 2026 22:46:47 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90b9db95sm580898185a.14.2026.07.04.22.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 22:46:46 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	clm@fb.com,
	dsterba@suse.com,
	fdmanana@suse.com,
	jbacik@fb.com,
	wqu@suse.com,
	stable@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH v2] btrfs: fix extent map leak in NOCOW direct I/O write
Date: Sun,  5 Jul 2026 01:46:35 -0400
Message-ID: <20260705054637.80584-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_dio_iomap_begin() calls btrfs_get_extent(), which returns an
extent map reference that must be dropped on all exit paths.

For direct writes into a NOCOW range, btrfs_get_blocks_direct_write()
keeps using that extent map and asks btrfs_create_dio_extent() to
allocate the ordered extent. If that fails, for example because
btrfs_alloc_ordered_extent() fails, the function returns the error
without dropping the input extent map. The PREALLOC path avoided this by
dropping the input extent map before replacing it with the newly
created one.

Check the error from btrfs_create_dio_extent() before replacing the
map and drop the input extent map on failure.

Fixes: 5f9a8a51d8b9 ("Btrfs: add semaphore to synchronize direct IO writes with fsync")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
Changes since v1:
- Add a comment explaining the returned @em2 pointer.
- Use @em2 to decide whether to replace the old extent map and assert
  that this only happens for PREALLOC writes.

 fs/btrfs/direct-io.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..19a1259b3b2f 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -281,17 +281,24 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, start,
 					      &file_extent, type);
 		btrfs_dec_nocow_writers(bg);
-		if (type == BTRFS_ORDERED_PREALLOC) {
-			btrfs_free_extent_map(em);
-			*map = em2;
-			em = em2;
-		}
-
 		if (IS_ERR(em2)) {
 			ret = PTR_ERR(em2);
+			btrfs_free_extent_map(em);
+			*map = NULL;
 			goto out;
 		}
 
+		/*
+		 * True NOCOW writes don't need to create a new extent map,
+		 * while PREALLOC writes must replace the existing one.
+		 */
+		if (em2) {
+			ASSERT(type == BTRFS_ORDERED_PREALLOC);
+			btrfs_free_extent_map(em);
+			*map = em2;
+			em = em2;
+		}
+
 		dio_data->nocow_done = true;
 	} else {
 		/* Our caller expects us to free the input extent map. */
-- 
2.43.0
