Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA3733F5A3
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 02:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775011223; cv=none; b=YNwzHy/9WM/Wf6YGQhy4QRLwSCVz8usq34IvHUY+DDLLahz5K7/YvOp93sDnWUh9NmhfxrgsCDFJ3inBkNFHGWd9wZVLC613W2SqtCQWXPLKOYebt1Zf6BgJlacwWRFpNw0JEAj5vdP9pz5DYkXAHsEww3Oy29vVHwXJcuzCeao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775011223; c=relaxed/simple;
	bh=iH8I2UG9Ru9X9r7Tzmndkj3VYipT+AVnI4VvyE3QJmQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bNUx6cAvwiaZva0RcZiH5QyGwA1VXgLtZKaGi0PUWN9GW2Yp5g1wvxh5Jw8VIz4mtR4E1QIMGqhJ7HGrHCpWqIAM5Vcx3qef0235Q1CF69pvrlcugffSWQ7Wk/+ceA3yssCFrhtXtLn6F2QL6uNz4FUDZpqCv2WAMcdgPwVMh6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J/Td/IJb; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/Td/IJb"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35d9923eec5so2455399a91.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 19:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775011208; x=1775616008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8sqDz/uMBZqTZGt94qEp7iRvQSh0/+1DFsjzVilUkuY=;
        b=J/Td/IJb5ZETj5vG2ySHIyOTMRXPPZcW48g+IJV3gy6LJMcZ7b2ytTWmyT10nVYM5W
         x+dmlC+WeGAp/u38kNiv9ZJFNs+Sx8gt2e9atLhTyEJuQ9AShLJiRt4I4mlOL9EfqoCh
         WapL22Hdmr9zAjdv1aABug5k92aN9LFI+98N4CQC1x2So0DUTwAVhh7h/O25n4M1odMf
         OO+mOFSmUWcy62AJZEICQoHDSdauf/mmH2dkaNMJA8Ky7s8CU1GnkJ+IrFYEz8ecYGQr
         YkgYcGCn3JICl5SitdaOIIeED/57hpJaI6aVT4EUA9UPnZpKj1rgu6sDuE4uVrTgCYh6
         U/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775011208; x=1775616008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8sqDz/uMBZqTZGt94qEp7iRvQSh0/+1DFsjzVilUkuY=;
        b=Ifch+ZE9hoDJpEnrasZpmcEcFqVDzGVBX48sRG8GZ7yBjoLY52X+NVGhGktqH+vgAR
         M1VjVOcoAYvTW2lsXF0QrRoqitJtrTZTW0zdrEw3ymAXa2SJ7rhOdBKAhITJj92lpL/J
         Mdr0u3gqQXtZ0IoVf5RV1m4FyPDiYDB0LIy4fCWdh+YLBE2Nu/QlSsFZwzzX7UPO5H0D
         bLE0Ad1XYtf8vXloTU+KiEBAt4x5KQkG28v/A6rYuWDUUMQj7N6qklo2M+Nh6WGHQg0Y
         wdDDy84uoQS4QzcR//igQyTCz4TknsnECnXNiAmRAwQbmtDxBWnooKiUdvTVFZ3U4TfH
         Zg9g==
X-Gm-Message-State: AOJu0YzCaTwXLUM995GBCHBt0nzA27eCqYVsT5CjLwtS31vI4wsQ8VNO
	l4WJhUsxB9fdslO7on78vqZeEGqTPHdPnjxv8aG+VrHtI6O/d1EtvwK3
X-Gm-Gg: ATEYQzwsTWeHyXhsG+N0Rqzb3nToAGZkjrUGpWpviG1H9yrbakxb9cunNuBVSokFHnL
	PAmq5ywuZR2DTzKFTkhrKg3d2RTL7uQhuJjJ2UzsQT0fxid36kza5YfNNHfiwqw5kiJ2DMEh1H4
	Mivtl+4dBEPkfbRafyg/40TxSxz01bIlI6ISkNu/rr8vrkp5YoqRhHHyXGRVf23gNSoMTU0HmcE
	izp757lag+QOvzIUWgOhV4ijYcomqMeSJZ7/pTOu4lOpspIbwWTb9+XLESK6X+6itA6Ww1EwLJO
	SP+LR9R1SsfbXiUuC2cHBPHil88zESHCDZGfGYEHVcHQxDes8lFrazohjMGdTNbyl0o/5Y/RLYo
	Dct91JfXzeG1LU6E+gMkfq23r8Fyki7Z4FW2fP2N5kbq/6GyC3eS7jswFWWd3Gsgrd8MRlGzMTw
	yW7s1yvPIpE3/cA8hHhQ==
X-Received: by 2002:a17:90b:3f44:b0:354:a57c:65db with SMTP id 98e67ed59e1d1-35dc6f0128amr1367339a91.20.1775011208412;
        Tue, 31 Mar 2026 19:40:08 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe668b24sm3099011a91.8.2026.03.31.19.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 19:40:08 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH] btrfs: annotate lockless read of defrag_bytes in should_nocow()
Date: Wed,  1 Apr 2026 10:21:53 +0800
Message-Id: <20260401022153.743576-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

should_nocow() reads inode->defrag_bytes without holding inode->lock,
while btrfs_set_delalloc_extent() and btrfs_clear_delalloc_extent()
update it under that spinlock.

This is a data race.  The read is a quick check used to decide whether
to fall back to COW for a NOCOW inode: if defrag_bytes is non-zero and
the range is tagged EXTENT_DEFRAG, we force COW so that defragmentation
can rewrite the extent.  Reading a stale value is harmless because:

  - A missed increment may skip COW once, but the defrag pass will
    redo the extent later.
  - A stale non-zero may force an unnecessary COW, which is a minor
    efficiency loss, not a correctness issue.

On 64-bit platforms an aligned u64 load is naturally atomic so tearing
cannot happen.  On 32-bit platforms u64 may tear, but we only test for
zero vs non-zero, so the heuristic stays correct regardless.

Add READ_ONCE() to prevent the compiler from caching or splitting the
load and to document the intentional lock-free pattern.

Fixes: 47059d930f0e ("Btrfs: make defragment work with nodatacow option")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a6da98435ef7..afc5d75d2dcb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2420,7 +2420,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 static bool should_nocow(struct btrfs_inode *inode, u64 start, u64 end)
 {
 	if (inode->flags & (BTRFS_INODE_NODATACOW | BTRFS_INODE_PREALLOC)) {
-		if (inode->defrag_bytes &&
+		if (READ_ONCE(inode->defrag_bytes) &&
 		    btrfs_test_range_bit_exists(&inode->io_tree, start, end, EXTENT_DEFRAG))
 			return false;
 		return true;
-- 
2.34.1

