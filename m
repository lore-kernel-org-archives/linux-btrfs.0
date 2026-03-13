Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13E387596
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 09:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773393582; cv=none; b=rEK2ACur3l3orWDHQYX6RavJFjVcb3zAeK7kLwbBFrtmHjM2xcYZKV1yxZ/9QRvmi625w0Womh74BShgo1mHtklLR+6RuGydc92V5xs0adyx5CS5CW5AonUzC20VmH94G6+lPCFT+yxo9ijzPwvQMa+rc9EmMYa2PCNzdyKifbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773393582; c=relaxed/simple;
	bh=YJuSrbjARIOdYMlVeLWTE7xW+S/hIuwwlFLQf1y9p8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meXpPXEtCVe5yI+rHjeU2If5JAIJ/kYLAd4F/alFPau6pdvKII5nBCivRMPDXUYQC1HCBvBc1f4BdqAoN+hzufRb+sBKSx1a0UDPaZ5duF9H8OYBiqdOUJ2K9MHovITrG5hDjPXa/Hmx9QkPUb3vFHm9CdsPuQ+ZogLX7CZNYY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7RZ4Xu5; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7RZ4Xu5"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aea68839a5so15467825ad.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 02:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773393581; x=1773998381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOqN0/VOdn2bG6rSPthTbsXJSa4+FCEX9zx281dEFuU=;
        b=F7RZ4Xu5kew1SV4ps8/GGE4HH4nbryFr+N7h5d22LS64w9LXyWTnch+1cBmzHKZSL/
         /58lrgceP2MJRCVQSQmR8Kj9ZuxuAcbMeWYBM5vtG7LCqO7LaeFN0Sbs+iuG4djGLmQ5
         nbgSnEhjX19dYiCWj0U6m4kNSIdJW3l60HJ+ra8FoHiFJhenJnEH6s9BIpVn+8m3l+oR
         NLwyAWnRqKOWfk+kw1MLk9/plVFZ2xaEq2AsAh39REIKYEIbExzzGJlaa3MCRmyPCGv5
         fPmLnoDiZDj4sncd6KME/wa7b+kzYeHecE1+xnjhOPCOoGm6IkQ8PxbZc758T+do6C2h
         D0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773393581; x=1773998381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BOqN0/VOdn2bG6rSPthTbsXJSa4+FCEX9zx281dEFuU=;
        b=bc2e61VoCLBJCIo4OJ9j2LNcyGvNFncAPEDgOadXijEStfc86MZ4cHBnuBNyQt0mOs
         w7rdNNzYyB88imJ/xsCNGKGk7EXiorgfowVdw60wMZkk9IIsJ/7bn8+jVPR87PGdxY0B
         2GwDHrB60VNxcQIXwO7IWq7+JXAQ1rh3uG2j7Zhy69bZTv5zRgyPjxsCThHtRd675e2p
         2VKVLyodxiltGVYDh1f1xBfxnS0cp2l4kbc5zwBfGWrfhsar/hoA+rL7xBwtObsXItct
         cYrlTcKz4GNly0TkOkY2X9jt2kVPTw5cnXq7dIEd4UNModb41aZ9oEtMNFmgKX1Ve+Fj
         ZnsA==
X-Forwarded-Encrypted: i=1; AJvYcCXMb2D2pvFI4PJqt0+Z2P9vTsKz3FrWeuwk5dJL3FtYuFQg6martcpjhO4zA3EKSTHEjssyk/o5JU4vKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2frphiPTd33DJc6CEA5gGib6Fy1W4mx+oRyDMmGfac8R+J4Ly
	lmS1lLLNPle9OJg+LqsxfVzmc+rqgs+kJZrbydrTJqyMtetYUQL28h7z
X-Gm-Gg: ATEYQzxTheALWEMC//5rC1g9V8+ZVm/+djExziedPrH7WjtGXaZi+Ozd9Qv4SaGdHF4
	XugZjo4QgcxvyoRRZPnqepbAYUShEnAFxUXD9EP9XinRVOsO+hSSefn9iGm83Bi7xzieGUMBHgK
	cqol9X7iO57MdBFu/+PnhSHYvalCFiW4SFgSZW8PGjQPWxriS7bZ1Q5ivI842qnq6NKYSLVUG+O
	AHrUpqU0aCDRAw0Xg1hpy7NBYizW67KY2+pnsaGewWvXD4k0OjprAB6ejkmFUMm9BW6DWmEBgEb
	v/zl5hWW+RtjtpKsLm7QBhtz2FFniy9C3Cldw8YtwBQiEPUaxuW34fA5A4iU/hZRh07BH0XH4/q
	Vl7DHJU2kWLIn3HJAJdz0AykDj7LOk+fK84rW2KQMRdXM5TKwOQQHBGv8dlIuaI0MOPRFN35L6c
	ztbAc9q84UgXwlTfHX9aDQWjV8W0PLJ/NiaR5KCrRBYYA5tARzmS0JLpvzs/8IcuRUdQP1o80=
X-Received: by 2002:a17:903:947:b0:2af:7d24:2a93 with SMTP id d9443c01a7336-2af7d242cc4mr1201175ad.8.1773393580835;
        Fri, 13 Mar 2026 02:19:40 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ee1d8sm16742135ad.55.2026.03.13.02.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 02:19:40 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com
Cc: wqu@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2 2/2] btrfs: revalidate cached tree blocks on the uptodate path
Date: Fri, 13 Mar 2026 17:19:24 +0800
Message-ID: <20260313091924.570554-3-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260313091924.570554-1-gality369@gmail.com>
References: <20260313091924.570554-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

read_extent_buffer_pages_nowait() returns immediately when an extent
buffer is already marked EXTENT_BUFFER_UPTODATE. On that cache-hit path,
the caller supplied btrfs_tree_parent_check is not re-run.

This can let read_tree_root_path() accept a cached tree block whose
actual header level does not match the expected level derived from the
root item. In particular, if root_item.level is corrupted while the
actual root block was already cached and validated earlier with a
different expected level, the later read hits the cached uptodate path,
skips re-validation, and builds an inconsistent btrfs_root.

That inconsistent root can later lead to a null-ptr-deref in
handle_indirect_tree_backref(), because backref walking uses
root->root_item.level while btrfs_search_slot() fills path->nodes[]
according to the cached commit_root's actual level.

Fix this by re-validating cached extent buffers against the supplied
btrfs_tree_parent_check on the EXTENT_BUFFER_UPTODATE path, and make
read_tree_root_path() pass its check to btrfs_buffer_uptodate().

This makes cache hits and fresh reads follow the same tree-parent
verification rules, and turns the corruption into a read failure instead
of constructing an inconsistent root object.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/disk-io.c   |  6 ++++--
 fs/btrfs/extent_io.c | 12 +++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8773f1f7ea46..9a8c06c0adc2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1054,8 +1054,10 @@ static struct btrfs_root *read_tree_root_path(struct btrfs_root *tree_root,
 		root->node = NULL;
 		goto fail;
 	}
-	if (unlikely(!btrfs_buffer_uptodate(root->node, generation, false, NULL))) {
-		ret = -EIO;
+	ret = btrfs_buffer_uptodate(root->node, generation, false, &check);
+	if (unlikely(ret <= 0)) {
+		if (ret == 0)
+			ret = -EIO;
 		goto fail;
 	}
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 93eed1d3716c..1324449e892d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3828,8 +3828,13 @@ int read_extent_buffer_pages_nowait(struct extent_buffer *eb, int mirror_num,
 {
 	struct btrfs_bio *bbio;
 
-	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags)) {
+		int ret = btrfs_buffer_uptodate(eb, 0, true, check);
+
+		if (unlikely(ret < 0))
+			return ret;
 		return 0;
+	}
 
 	/*
 	 * We could have had EXTENT_BUFFER_UPTODATE cleared by the write
@@ -3850,7 +3855,12 @@ int read_extent_buffer_pages_nowait(struct extent_buffer *eb, int mirror_num,
 	 * will now be set, and we shouldn't read it in again.
 	 */
 	if (unlikely(test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))) {
+		int ret;
+
 		clear_extent_buffer_reading(eb);
+		ret = btrfs_buffer_uptodate(eb, 0, true, check);
+		if (unlikely(ret < 0))
+			return ret;
 		return 0;
 	}
 
-- 
2.43.0

