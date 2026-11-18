Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021423;
	b=W+MJu3+7/Ej6k4gPRnD7XjylhXFoP/EX3ZStPC3vANSypRXnrCaDmfvkpadQa6wmzZp9
	 ny+SHxZZb4DR0YyUdPn6kuP3hyd+xy+KA1RsyX7KMHY+uPro6gYqKOmcse9KHUNO65Yad
	 96Xpj0sW5+N3eFaKflCFK15NTyJ5UBCdVoMHeysrTagCk+xRpajD6cDaKSgl3S9ngHVJ1
	 lWAleSNeSdWRbrlSIB/yjr1b4gJ/2YZjrypd2arzQ0kSouWLKk8qlqP4eBkTGtgwhC4Dw
	 sunTjmdLe8EVrGF61x8JtC+qL0eG6r5+hq8n6ZY4JJiSBfmW3eA7kNH/sOsALK1Qjxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UaVcyNlEXvHCvSegf7DdOWk+AJHnO+R6lg7onpWBTLM=;
	b=ukPr1nDhDfjRzD5Vdro1Fp/Jy09v8zfLTGg/kH2RW6lOgkNgEknLptS50R+RS/eNzh4a
	 /yI9yvpcPIiiLM6+yBpYUdS3KnqGpyD6GH2mzGHlKCYXdgR4ewBMCPgmvmdHf8+ffSRqu
	 xXznBgGoIZdbr58meYQO8Huupt1gUEA9G1AA9m5mZAvwbmpuZYiRncY/c54FHk/MMJwDo
	 6b094hBYm1/Tmtn4IadEmH1JoS+prP4CpMukxC39OhUFVznFxkuVP95uIliBoSKZDhd07
	 6dQarVBH9Ag5xRVkatHtM7Cz4sNfAg7AhRTpuCrWh9/maGrUBx5AGbRCEg5HatfDPiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mOwwJznX;
	arc=none smtp.remote-ip=209.85.210.49
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20E60A260D
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 17:03:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B20E60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mOwwJznX
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-8490a7d6696so697031a34.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 09:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795021422; x=1795626222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UaVcyNlEXvHCvSegf7DdOWk+AJHnO+R6lg7onpWBTLM=;
        b=mOwwJznXdq/mL9a1/tRYiu+9aHrPlamFRSWHPx0O36q9m1DP0sFU3+p9VaXqjV9+Jc
         MHRPPQyaH6plbzz+MRt03IENGzTCFWtIU2eB6RDCK/vXwdZ3FIYebVbtzwU68gaL+/YL
         svImR0bmonJzBwIrCZkIeL2mFLfBOb0UYMwLIM3rpOA9Rx0s1aEgxxJziWKfhhCyP6h5
         geqrqUdZrc7VGULz5CGgt6SNcvKLjmcItUpgyqAgUBH5zB+tze7iTqdDztLygklSMQsv
         CDA8M9ne2KsRlZRTbIJYPmcmkdYmXliMxsuKVjRfHlL7z45p5d8Bv8061oC7JWLDorFM
         JKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021422; x=1795626222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UaVcyNlEXvHCvSegf7DdOWk+AJHnO+R6lg7onpWBTLM=;
        b=T+sEYyuBOa8HhrUCbYvTn2UVcVvt+zaFYyG7acWNZqEOgsPIslC8WwK/t6QLPCbhnp
         vRQOteMQHma+62e34v1bNtOaZ2AuaR4CDcBQXUMmCNoqhmBSDjhwufAH11kw5XSvsYVT
         dMw4/r/ZZpsBMsdgLvAeir7TkyLq0e95JTVtQkF1NxgAxs7hieWSDo6ZfvMzbdlkMMw0
         csQIst7eMR42yXiaoqmy6T0o9EOlF34bENvSZXAojQ9JAaKqZxyvpUWBwJgjx4oU1pKq
         ZSjPJ1dWVqVivwntW0GmC1ZZnaHQ8lxXC4BzZiokB+vxeUacQrdOWKAnhf+BQVAkFVtS
         OH7A==
X-Forwarded-Encrypted: i=1; AL+hErGPtOno3nLCHJ5R50ecvh3ISSLS4yYV/nqmHzwV05/d6ccmAoKJavoRLISmOgf8h2t0d7KMuyzJVlUEUw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9ms47Z0SCoFhkKQKMPjm4/Hc6yzzKvtBmqlTHeSilgsCF/sSKy
	lUvh6bKbRHoUgDkUj0NKLJwkfkGBIdSkz5Ltsg56wMTsr+9L3oPyQdC6GDHe448G7YY=
X-Gm-Gg: AYBFou3NHhDtbsArQwiaJ+czvFRz6vahnGG37B6HnAoRRKFLKqAzv3WM3j2Kl7aJt1s
	aNCnHWB85GrgTZ1wmKsDw6jf39p2pkHHm3l+l7IRknZpk0MkYXB4M3KFTb0hrBbpiKGC1uXsno1
	t/9Tc+czWsn+Hf9/uHZldQADOMibQmwq2e+XMNthfH4kJSuiP2skqvcEd671y6UqRB4JXNydjIU
	AkWwUitVI2u+za43rpmblq12yEnA9izzmXCFLF4qfspApRfoXnjIkp38D2etSRa7u/gdhTF/jnl
	FCu43FjSUWGFzLvowzY2L2HRHaI9ZztmFa4kRmoS+nvEartAV0whKEwFrC04AMj0cqYAv+ALgU+
	h99Mnei16V/TgmxAgx5K7augR3Y5lv8taVJqhoKTL+UT0K+1s35bwHb3DI8DLUP5/GAW7wHJfFs
	nQ06KGPgMR7f5nDQOSJG+pG2sKjjzPRPgsIFoOWQLlFjPxgF9kFDtNuIFRpe1yy7cBeFnAr+ZL5
	6VsB5A6y6mXHJIDgS5Smqd1q/BKsvTARLYQQ2ET34Fu5cStMrGS8YESHAnvxzzlxilE62rDqkRc
	5CXTaLcUDUA2SMNcL8VxWvc=
X-Received: by 2002:a05:6830:2696:b0:862:aca4:1158 with SMTP id 46e09a7af769-862f0861aafmr2972784a34.22.1795021419554;
        Wed, 18 Nov 2026 09:03:39 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:15::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f01d474esm2486617a34.4.2026.11.18.09.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:03:39 -0800 (PST)
From: Vlad Poenaru <vlad.wing@gmail.com>
To: dsterba@suse.com,
	linux-btrfs@vger.kernel.org
Cc: mason@kernel.org,
	osandov@osandov.com,
	josef@toxicpanda.com,
	fdmanana@suse.com,
	boris@bur.io,
	quwenruo.btrfs@gmx.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: fix bytes_may_use underflow after a failed tree block allocation
Date: Wed, 18 Nov 2026 09:03:32 -0800
Message-ID: <20261118170332.992625-1-vlad.wing@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When btrfs_alloc_tree_block() fails after btrfs_reserve_extent() has
succeeded, its error path gives the block back to the block reserve,
although the block has already left bytes_may_use. Each such failure
leaves bytes_may_use a block short, and it underflows and warns in
space-info.h when the global block reserve is released at unmount, or
earlier.

  btrfs_alloc_tree_block()
  |- btrfs_use_block_rsv()
  |- btrfs_reserve_extent()
  |  \- btrfs_add_reserved_bytes()  <- bytes_may_use -= blocksize
  |- btrfs_init_new_buffer()
  |  \- alloc_extent_buffer()       <- fails with -ENOMEM
  |- btrfs_free_reserved_extent()   <- bytes_reserved -= blocksize
  \- btrfs_unuse_block_rsv()        <- block rsv += blocksize again

Since commit 19d7f65f032f ("btrfs: convert the buffer_radix to an
xarray") in 6.16, alloc_extent_buffer() can fail this way under memory
cgroup pressure, because fs_info->buffer_tree is memcg-accounted.

Return without giving the block back once btrfs_reserve_extent() has
succeeded.

Fixes: 67b7859e9bfa ("btrfs: handle ENOMEM in btrfs_alloc_tree_block")
Cc: stable@vger.kernel.org # 6.16+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>
---
v2:
- Shorter changelog, built around a call trace (Qu Wenruo).
- Dropped the code comment (Boris Burkov).

The code is v1's apart from the removed comment, so v1's testing stands:
its reproducer leaves bytes_may_use below the global reserve without the
fix and not with it, and fstests btrfs/002, btrfs/220, generic/475 and
generic/476 pass.

v1, with the reproducer:
https://lore.kernel.org/all/20261113170926.1468850-1-vlad.wing@gmail.com/
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3c..8d4c66bf850bc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5433,6 +5433,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	free_extent_buffer(buf);
 out_free_reserved:
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, false);
+	return ERR_PTR(ret);
 out_unuse:
 	btrfs_unuse_block_rsv(fs_info, block_rsv, blocksize);
 	return ERR_PTR(ret);
