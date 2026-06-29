Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5820C40D585
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 00:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782692709; cv=none; b=WYoDtRX1JNbw6/4nm3eibLOSyHaMR7vBfYrdvO4aStq6YdMYXl3L7Pb61+r7cqdJmf8xcDXgZQID+cNs2V3erBzSzVaOsWXGQJJjy70C8/ADaYpcJj721b3iXNls5sS7YafxBJsVHOqa75+weTZJL89hYCFIM07u0mWzaMlWfls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782692709; c=relaxed/simple;
	bh=Mo2yl8h22iAeedEefGbsjzYeGACnksm2mu1kISAkWFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aIbIDYLXtvf692Kg+XiR88MR0L6RiGzLtDvNW0nqLR3e+ri82UctdG4qdnsggyH/pkUE8UvX0iY3rZj7QLL4ueA353Ud9SJ88hVmhOOHxRC8bDTXM+TLOtpv+ukfUx71j3CjMdD14xlAxT7MD6MHsIQEp0QGiBplX0Bh55z3U2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJZx5x9R; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJZx5x9R"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c80879c36eso15140735ad.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 17:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782692707; x=1783297507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P41Rhb2N/xDdm2LPMemS4Ju4/6Yg9XM5U4XcDkcrBgw=;
        b=iJZx5x9R2W36VUEOdBJ1wc4r4JxHUWtFXV/V3L24TWa1Vxo6cg9c46Vy9onhTS3+6K
         PTSCAZpK6YieODaIW5pFPuG2MXWNI5BHbBRRysadBRA/f/C2vfnXoaQcWOehFJ3ian+U
         lzWkywus0z7baDc96USL+Hi0qkcku4bSef11BISx5S5jL3cNj6PBL8TTfraaJJHHnHhL
         nMXvi8o8Xwbc6dQ1G/PDEm3wv4vLsUb+goAPKIvvQ4S43LaK+3Pewo5Fzf5EzNpKSnun
         PQsT2rch8oCOE4NVFhiOT0JleVy7tlWHwy74/dNL3F4TTr0oMBS4N8DO4A2VM+Qf5jjs
         uEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782692707; x=1783297507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P41Rhb2N/xDdm2LPMemS4Ju4/6Yg9XM5U4XcDkcrBgw=;
        b=HL4gzbUBOWDWJ5iyOVgTb5o+/gnKWXnUmjHgCiwof74U9FHyjan8gpwEBJ6e5aqdPu
         xPBcUWT+ebOnlOSkzlhBeUIJBCZPklFjrk3iQeGzDPCNtc39kFafW+n5Hs8IXC0Y8kvX
         /9CWYREEWE4mtcTwjlAz8BxLl6jscC0DletMdBgMCvtxVhfxKJxaS8rXpBO0dfsHpXLI
         q4S1gEIipU7XI3MllfnqUNhSFrAsbDyoapAowPsYV5HsoWCyCukoklMiwVIvmBzK9/EK
         kxM3zGMfqJOwZl+L9puzYY+hJ8/CbUkifl6W6Z0xmXBpOuaQXqpbXOlTOv2T31EFJPRy
         0yjQ==
X-Gm-Message-State: AOJu0YxYjOYOTcZI1A+maRzepuRCdoUrwc0G5fBOmDFjaMfkv2R+kRYM
	uGgTqbxtYWVc+AG9PRGixVfG3vyihuB33mCaAfchE4u3ZBr6+PpSANIbXN0HQg==
X-Gm-Gg: AfdE7cngqf0tointR6otBNtwIUsgYA7MPs7U9NCtDk/l0BHdP1ju8/cfjijz7LudJ0d
	lD/NGV9McHKcW2esbD0i/oGfTY8E1eNi9gfJbQ1Apyx3krCKjcQCAYIZcSm4XPhTYHfJEP5wCX6
	s5E397OcX2B6kgqA5XuwsF/h6Za3GS8SOwqjTO0nlHTzrKJV3O1mqJV60hMlFw+6bGrX6Bv8tFl
	RIOUoDKDItGfpZWFyjE4yCzj5d7YhiRrqpOSVlI8Bh4qAUlvVYimpzWjm+huXFESR5AfP2FjlX6
	Cql95mLuaa6dLz+NcVaOBsJz8D5dLQoJ2Dr27cfYygFdUImdPYZL0X4rBPOivadA6TWjFXDEkAL
	jG5l1Fu80wYQZiurP7Lbg1hC+ghO/dyE00m63b3JCXtwPzUw869kXY1GK2YHs3QAw2lnHZHeZNx
	iAGyOL1AMkWpZU8VmTlpTrEob2IVymtkUkDeRmcQx03dHz3hIgmC+6aE+AoZdJPNJ8LdxfwJcrj
	aZvC30x3w==
X-Received: by 2002:a17:902:cf0f:b0:2bd:73f4:8e4f with SMTP id d9443c01a7336-2c7fca76990mr108263835ad.0.1782692707529;
        Sun, 28 Jun 2026 17:25:07 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c9e67a5d0dsm17093135ad.1.2026.06.28.17.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 17:25:06 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] btrfs: compression: allocate buckets with workspace
Date: Sun, 28 Jun 2026 17:25:05 -0700
Message-ID: <20260629002505.1552238-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert 3 allocations into one. Simplifies code slightly.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 fs/btrfs/compression.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ffb6b52863a7..da6749ff5924 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -650,11 +650,11 @@ struct heuristic_ws {
 	/* Partial copy of input data */
 	u8 *sample;
 	u32 sample_size;
-	/* Buckets store counters for each byte value */
-	struct bucket_item *bucket;
 	/* Sorting buffer */
 	struct bucket_item *bucket_b;
 	struct list_head list;
+	/* Buckets store counters for each byte value */
+	struct bucket_item bucket[];
 };
 
 static void free_heuristic_ws(struct list_head *ws)
@@ -664,8 +664,6 @@ static void free_heuristic_ws(struct list_head *ws)
 	workspace = list_entry(ws, struct heuristic_ws, list);
 
 	kvfree(workspace->sample);
-	kfree(workspace->bucket);
-	kfree(workspace->bucket_b);
 	kfree(workspace);
 }
 
@@ -673,22 +671,16 @@ static struct list_head *alloc_heuristic_ws(struct btrfs_fs_info *fs_info)
 {
 	struct heuristic_ws *ws;
 
-	ws = kzalloc_obj(*ws);
+	ws = kzalloc(struct_size(ws, bucket, BUCKET_SIZE * 2), GFP_KERNEL);
 	if (!ws)
 		return ERR_PTR(-ENOMEM);
 
+	ws->bucket_b = ws->bucket + BUCKET_SIZE;
+
 	ws->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
 	if (!ws->sample)
 		goto fail;
 
-	ws->bucket = kzalloc_objs(*ws->bucket, BUCKET_SIZE);
-	if (!ws->bucket)
-		goto fail;
-
-	ws->bucket_b = kzalloc_objs(*ws->bucket_b, BUCKET_SIZE);
-	if (!ws->bucket_b)
-		goto fail;
-
 	INIT_LIST_HEAD(&ws->list);
 	return &ws->list;
 fail:
-- 
2.54.0

