Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517293;
	b=lBwbfwiRzWfAPXoGlaCH52XH0q7VGER1eB1h5OwuTDju/31ZKA/rzhFtRpNeOnyGhGwh
	 8rsZGOO6sWfad77ou1zZi2IlFxf0P0BaAqnHm0FZt+UagLe7c285AbCXaCV3KWFJnE7YT
	 9F7SWAoutCG8pVjin2eq25cUX+axsr6a+W/Tiujg/n6YdKt2QPCCVZiAPvMy7ssuKpYbl
	 zcuYAimTvT6lD1Nwdt0dVy1Hv74385nZgdEQzHJNBfNt1g4ChOoeTUEOJ/lWKKBIHV1nU
	 wZ7zuy3M3TpOYWGZ/fOVPiVt56DsKQqomajcJEmoIEFlik5vB28euyMmzFPNr7vRmuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517293;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Yk9QxCaKNnBQ8oh8luvc3kRXvhxo2lpzgt6RtHaF6AU=;
	b=WFzTOdI+73GJkYzG+ArYEuilFhNmPIFxLvQAhe0/U7rbmfG+vuN0ueXbnZcr7DIU4Y4k
	 qAmh4a54PI2aFiP8p6TYneO9081SYJKNzGZLZ+evgprfIWA7vuhqAExCjNxqUI+FZpyV0
	 bNFHbAjrQMLWfW3UBJQSLYKQykLOP/mneTVqbLwjk1i7i8yWPEwKna1AqsqTEV9BUuyQ0
	 2Vf3Yi4KL9MR4dWgZpyUm644Wy8vtVLibgp+NF7nQjEsslliaStb9bu9DL9GQhEf3Prpi
	 GtCL5s2TSbdNJY/31/attNdx3JaRfuP1LdaPQyAcix7TerzKRrAUQfBcvKiKX9j8F0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zCK6ZVLc;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1F606A324
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 07:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91F1F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zCK6ZVLc
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-15dd124bbe7so1975211c88.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 00:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793517292; x=1794122092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yk9QxCaKNnBQ8oh8luvc3kRXvhxo2lpzgt6RtHaF6AU=;
        b=zCK6ZVLcD2RVVaUGjof5FMJeAPYSBuqRExRpEv+YsiVBt5YL0uVzAcFm1siDT2UAuX
         U9DeI4VlWnSS1YHwr/reN87PTHmFd5nzPtJh4MT1U+AIaVlnaKvH+kBr4V425LXe/LT/
         2/UQXH+6Qp6+1ZY7Grc8SglkFyhc8mFjA+coTGhTMy4A+M2lScY8p4C4r5TBLMMno2kz
         +K3bje89mIlAOyJSYCYR4AHtYqGyG40UYhQmO3hKxui/D8KzI4o5J/hy8G43lwmKZebN
         x3WsVMNph2MSV+DrRtlWmNdRN57ZJiS76HzCodu9OSUY+poMjBDC5FbHG0qsR7DJrqLQ
         +xCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793517292; x=1794122092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yk9QxCaKNnBQ8oh8luvc3kRXvhxo2lpzgt6RtHaF6AU=;
        b=1+wx+SpTpXNlGDmlR1Q/Pi6DGYP2C0CmtDBA+7cIhPT8uhDbotrt7PxAPuo5L65DMr
         vabp66RuD6VPKVLKbAwaHOE6eszUal1TZB6xaiYJr8yOEy2eKIPDtIOZRhP4o11qFZF0
         02RY8DEUpJlUcREU3rZ5EG0CpM2rrkVfXira3chJno8nSO47a3zE772gjqW/m2OcGg3t
         GtEhSvKV8PEYnjO1w3J9WSRw4iE30UyDyA7z/DR4eRlyMTemZ+y60fzmMK0S6NQ7iwjO
         hFlr+uDAyB7FWeC/1LCpYy9ea70LMqBoqYSRj1Sg/K+QGk9EMbn+wYo15qD1DitOS3+v
         WYEg==
X-Forwarded-Encrypted: i=1; AKwUvByf7p7oybxvl+aN+DdZhSSsUUfWLfgE0vnnV3vSNPzxKkGRQEcw9+xjlOrf8R92D+bgAI4Rx1CVQCX4nQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLFZT0fUIQdsXtC6rCYUkM2uCK98YxNtjM/E6KlknNwb/9eqUvz
	u0vnm6BQE2pH3wAgalIkMat681C14Y7xmZn8gEnIsYOghStC0EGbAJKm
X-Gm-Gg: AYBFou1tAWHY8AKfuSzjbmgK4t5VlQLSLIc0ToGmAEa8F8SuhrHw/pduuEebucdhflR
	7Mkg5ZLTB5VSPiQRY5SCUcHvKDGE/1j5JpxtDX1EcZJ2EGtVT0U/qlBDF0CLb1MMZTvMcDsswzj
	ZJ26FjidhIJkJy5VZGkYfOrCv8I5zm+w9UQwnv2MeC4NeQv/F0oDEA/ZuRPx5Vn7uh1kM8SyCQ7
	zk5g041z+iMFLjSjAJoXwI1KIVtktaFmFlGkwOr/P+TrscU1HU4uIZ6cNlR47jOIHGZFxhyiXp6
	xNdYic/ltNUEltnALFHN/UIniGTSOGcsJSQnLsCGtCmpajGiNY5/0ycJ+MHK9q4TINcpfyyjSR5
	GHNz4I/6Qloq2x/dRt2/hXbLsKpJsFFo1S62zrQnKI8Fh7/ZkayWJl3CDXUswO4R1J29rI75koC
	SOE2GS52PEakV7U44SiokMByPWHv6CTwpBPavPi2NmMb1vojijjsWl/360i1QiUyuX9b9OX3yB3
	kSMGtb4STatMITRQ9q4X3VZw2RKy8+s29Yjitm0pfIbX7U4DQTRRapNH/tm1HvdQUbfVPkfePPp
	brUFA9rynH1aK7RwFPQ3BH/XnmJF2LhgAhfyFy/5WRpcCpUJdzwKtVwXJeKRQu/7iP31
X-Received: by 2002:a05:7022:f116:b0:187:7514:47f4 with SMTP id a92af1059eb24-1ac5d1cec2amr8941445c88.46.1793517291435;
        Sun, 01 Nov 2026 00:14:51 -0700 (PDT)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac193b8179sm25123406c88.11.2026.11.01.00.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 00:14:50 -0700 (PDT)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cheng Yongkang <teel4res@gmail.com>
Subject: [PATCH v2] btrfs: handle zero num_stripes in btrfs_chunk_item_size()
Date: Sun,  1 Nov 2026 00:14:44 -0700
Message-Id: <20261101071444.1853699-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
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

validate_sys_chunk_array() calls btrfs_chunk_item_size() with the
on-disk num_stripes before btrfs_check_chunk_valid() has checked the
chunk. With CONFIG_BTRFS_ASSERT=y, a zero-stripe system chunk trips
ASSERT(num_stripes) instead of being rejected:

  assertion failed: num_stripes, in fs/btrfs/volumes.h:714
  kernel BUG at fs/btrfs/volumes.h:714!
  RIP: 0010:btrfs_validate_super+0x3ce7/0x4210
  Call Trace:
   open_ctree
   btrfs_get_tree
   vfs_get_tree
   do_new_mount

Drop the assertion and compute the size as the chunk header plus
num_stripes stripes. The size is unchanged for num_stripes > 0, and a
zero-stripe chunk now reaches btrfs_check_chunk_valid(), which rejects
it, so the mount fails with -EINVAL.

Tested on btrfs for-next d1dca33127ef with CONFIG_BTRFS_ASSERT=y and
KASAN, using a crafted image whose system chunk array contains a
zero-stripe chunk: without this change, mounting it hits the assertion
above; with it, both read-only and read-write mounts fail with EINVAL
("invalid chunk num_stripes, have 0"). Mounting, writing, reading back
and unmounting a normal filesystem, and btrfs check on it, still pass.

Suggested-by: Qu Wenruo <wqu@suse.com>
Link: https://lore.kernel.org/linux-btrfs/d2ee0cc1-674e-4447-88da-d346122a43a4@suse.com/
Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
---
Changes in v2:
- Fix btrfs_chunk_item_size() as Qu suggested and drop the early
  zero-stripe check from disk-io.c, along with the comment Filipe
  reviewed.

v1: https://lore.kernel.org/linux-btrfs/179328314071.648427.12527832319954042748@gmail.com/

 fs/btrfs/volumes.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d5fe5cba0..891bc2432 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -711,9 +711,8 @@ static inline enum btrfs_map_op btrfs_op(const struct bio *bio)
 
 static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 {
-	ASSERT(num_stripes);
-	return sizeof(struct btrfs_chunk) +
-		sizeof(struct btrfs_stripe) * (num_stripes - 1);
+	return offsetof(struct btrfs_chunk, stripe) +
+		sizeof(struct btrfs_stripe) * num_stripes;
 }
 
 /*

base-commit: d1dca33127efacd86ac550aa86352f8ea9f29a5a
-- 
2.34.1

