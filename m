Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C95222585
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399447; cv=none; b=n/fxyMmQ++lG/7d3RrK7yK8iVkoNSQAbpphH3z5ceHTEHD3QA6uTDWfEs7AAgu4hfIHTwL6/MrfWpT7t1D/xd0+8qTN9iNKFzfXxUI8kEKIZVDSjoVQTx16XerJ07as+vPuiPSUL5/IYMb9tL7rNyWzSV3J37OqZXKrzX54Vtx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399447; c=relaxed/simple;
	bh=JLF9UZfXxMEmFArZnVwjL4KjhH5VxvRV1eSsRU9KZpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSWLbn6mnAZwYKQyfnIS5dJ4uVlsmWvDBukABfkOvN1yIN0GnpERaClH2kAh4efYThNNMii3hsH6Hf7wGtT2vb4U7tZ4YHcWTYEY9BGUe3FBje1JfUgjzg7ko2tOj325ycqaR3UlueA6g7iTVdigmW8cvekcraUSoETeEkpL1gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gh80qZks; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gh80qZks"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a8fba3f769so27811655ad.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 17:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774399443; x=1775004243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdSSlv0LVdyZD0+zj1U8PtUbtcqZsX166xUNgywcviU=;
        b=gh80qZks7xtAwFuN6XKzbKCQUPazOHz1wNDGGLqup+WrcOFLvwabb/J4esK//kgJmW
         JPG5IGJh3T+THqAO5M9Dz+zBrBwCR2KHvFNjkGa+E0o+M2DsD1BpNYGgSBDB0rQREJPf
         /qbRspZaQeENQ32nMEME0ZuHrPgsqFtX0SomCeJU0KUb+15gW+p9GJK5Y5tqUx7vm9vW
         pqAtcx/zzFxMC60F9BN+0fFOc8WpUTmGJj7SFfZHYK2EmD28M/rJkTpn2IIMhGp7cwiM
         5FdpmioH5rdprtmEOP9hLxvs2AnSsN/3xe3cQxvS/X+QxUPyKWuoWp6SyyB/K3EslEN9
         4reQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774399443; x=1775004243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KdSSlv0LVdyZD0+zj1U8PtUbtcqZsX166xUNgywcviU=;
        b=i5L/OiZ+7qVelZ42ME8xFJK4rbv5kTXK1YyjoaKjZe4BmrI09KqnItlKyUhWvTXdSN
         0MPPFI5Ui0yy2fy6IxMXiu6adSycN357OGL1vDrqdS1Oz5mBizosM2gZ21UWaPpbgCcR
         isJoQlyM9VBknEaWyHzeH8W26wPbLFFKJpdqfCZ2n5fvADZKGeErjlx03L3Qw44GEq1V
         3zv3qdw/nIY8rn2Q/02cch6/EXczPxpiCxdO+76ed2AIZRBfjHP4phE8nmEUCQrMv2P+
         Xzg0GhLs3sPq+AAuqrtcmTpDmGVPRoMf0THKbQqXbi6w5O7D1qgIxLL+/kqm52jXwDuS
         FOgw==
X-Gm-Message-State: AOJu0Yzmx0SmjLZtVH1+affy0z1XNLtofNGdaYbT0mI4aeweqvlLSZJS
	DHqqlrImQV+rTSFKzX4sXroWjJHBynuvOM2TaIy26oPh1E9DzDql68jk
X-Gm-Gg: ATEYQzxrH75rSduIEq9btF+vH12IDVjaf9SvHYhv077mtvsH45GgoR03Z7zPAzHwR3Z
	PnE5LJIDVKmojOlPZ0KpQk+1m6pjBsQvO+GVwi/TGpCclTeXlQb0v9vsDM8eTjZh98X+sQIfv+q
	MUOa6GjoWS9f4cYiXXUigIiaYdvOTVZbyCjCjyvUdtDwrwHdX45Z5d8L2qnJR0zCIxK7RGd4zwD
	vBVfxnyoNoCU+qw7x/GpOKPEeudAqPgMhu/rt09HRc4tXBkrWU/pvc9OiJZZBTyNHa+bn/lQC6w
	ZxoZhbgwJb/+PFTNZhGgRCDpyjWhiGQnMG/CyrXEBpj4UTpwyZshqDEunv7W+m/uT4sbQJOU6v6
	7mpeBubpvM6VTFnh8ArHe/jUPHbo5Z1lTqAe1Kau4G4OCvcF7TfJ6/aOFin8YfTV+3PSy/PEArX
	Uf9WadYvmuYDCt2kxlUcS5HqRwhn6sYilKUUPTzMMC7J9DXsrwsh3dDMWVNM1maXlIOPkXpF0=
X-Received: by 2002:a17:903:3c30:b0:2b0:5fa0:3afa with SMTP id d9443c01a7336-2b0b0af58a4mr15324275ad.27.1774399443065;
        Tue, 24 Mar 2026 17:44:03 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836554acsm207457015ad.51.2026.03.24.17.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 17:44:02 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	idryomov@gmail.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v3 3/4] btrfs: balance: fix null-ptr-deref in btrfs_may_alloc_data_chunk
Date: Wed, 25 Mar 2026 08:43:38 +0800
Message-ID: <20260325004339.2323838-4-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325004339.2323838-1-gality369@gmail.com>
References: <20260325004339.2323838-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Running btrfs balance can trigger a null-ptr-deref before relocating a
data chunk when metadata corruption leaves a chunk in the chunk tree
without a corresponding block group in the in-memory cache:

  KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
  RIP: 0010:btrfs_may_alloc_data_chunk+0x40/0x1c0 fs/btrfs/volumes.c:3601
  Call Trace:
    __btrfs_balance fs/btrfs/volumes.c:4217 [inline]
    btrfs_balance+0x2516/0x42b0 fs/btrfs/volumes.c:4604
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    ...

[CAUSE]
__btrfs_balance() iterates the on-disk chunk tree and passes the chunk
logical bytenr to btrfs_may_alloc_data_chunk() before relocating a data
chunk. That helper then queries the in-memory block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_type = cache->flags;   /* cache may be NULL */

A corrupt image can contain a chunk item whose matching block group
item is missing, so no block group is ever inserted into the cache. In
that case btrfs_lookup_block_group() returns NULL.

The code only guards this with ASSERT(cache), which becomes a no-op when
CONFIG_BTRFS_ASSERT is disabled. The subsequent dereference of
cache->flags therefore crashes the kernel.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in
btrfs_may_alloc_data_chunk(). If the lookup fails, emit a btrfs_err()
message identifying the affected bytenr and return -EUCLEAN to report
filesystem corruption instead of dereferencing NULL.

The caller already treats negative returns from
btrfs_may_alloc_data_chunk() as fatal errors, so balance aborts cleanly
and reports the corruption to userspace.

Fixes: a6f93c71d412 ("Btrfs: avoid losing data raid profile when deleting a device")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/volumes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 65df8652d760..e89eb5c1dbc5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3597,7 +3597,12 @@ static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
 	u64 chunk_type;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
-	ASSERT(cache);
+	if (!cache) {
+		btrfs_err(fs_info,
+			  "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_type = cache->flags;
 	btrfs_put_block_group(cache);
 
-- 
2.43.0

