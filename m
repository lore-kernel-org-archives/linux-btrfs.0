Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793686235;
	b=FkDbHW1RwmxDkHgnjnofPhtpz2F0F9rH3D0L7bborQsXJ7wYjQ9feD2UMBkfnjYWPnib
	 Jcqxy3mnxUahw5Xc+1eE+FFb5oIQn5lDrH5Zz4d2inSu4K9ubOKO81kBJoq4FC5TmKf9l
	 4nGYrZyu5eMbOnSiaQcPHgkVQOLqflQROcBrwpDhanUjjnNpXujAxLZW1jAWR11tChv1n
	 R4kfwfJwzjWRA6hTiV4T2xOqhVpAZ9D88Qt7rWzqw4qtlFvDMhcP8n33KQ8dS1sFAbJGf
	 MME4bRYGCnQTULdvfl3OhR8wCwouqnXv2tK3Fn2nINDn3+ozsi8urESGHGEb4d1QIsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793686235;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D7f/7cfhMuxRUvMF2+7Ngeja0NaB7eB5cH8ZEWQf8hE=;
	b=i4eyKxJfP6SbJW3tqIroNljI9XOqZcz0+QN9X/yveXVbkceYq7lXh2UGZCjKlqICbFtj
	 w5tDFgcC2yh6xlJ/U/wmDEshAZJfWf/jcfl8gwnNRG+jMe6evIix5vYi75JfE89HvGHsZ
	 fSoPoZm09prccLqZ8Bi5VOqKFlZy91XnO70PKf9Pt7kH8EL9qy++8f1eU8fHkvNSWI7QP
	 er8/gIIe/BZvjFvDBWTovlzExGmhcsy4j9IhRDY2/34J0t8/LTcyHZ1aBNauDqhhf43yb
	 CQuZX1+eb1JBQcGJoVKwkPAaHGOeSYDI13OgqCmL3aY5GxmOKvo9xWyYZrLkFyJQxkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=OB+8CPCL;
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE00C606A335
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 06:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE00C606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=OB+8CPCL
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91befe703c4so37052606d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 22:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793686234; x=1794291034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D7f/7cfhMuxRUvMF2+7Ngeja0NaB7eB5cH8ZEWQf8hE=;
        b=OB+8CPCL3Zw1NNu/20+ZOMwJ8pRismzLJcCVuJHPrrEM8/rSrzdl2OEG5XJnhPn6M2
         5sBiNPt1EmI0dRmbugAnbvxmTDjyTSn1y5uKaQz30Cft5UYRyf9FSmkt2K5IBP6EEy9L
         Qy0j/GCRQsFo/BHB5zhZDkPNlP38OG7B9UMegjs6DClNJx/PshbxLkic3jRDs6jwOK6e
         fjJMxzDN3iCAoz6t0cP/DR+sb90MR5WRVXCAMV20r/VJdigErUpOhhrYK79osR6u8t1Y
         toAZtS+WaVD9gN+PiIOYbbAtZ/RGcIgXBflCFU5kzrLEEMLtdpHDOjgrUN/YjJq5/SVm
         UKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686234; x=1794291034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D7f/7cfhMuxRUvMF2+7Ngeja0NaB7eB5cH8ZEWQf8hE=;
        b=Wyq7L2vRs8NefUxUUahWV6J15Z0Xjo7dMKgxzxhl3QxZjsfjtSlQZWcIqwD/rDG3Zh
         ySJr8ODO2OvMn3ezh2baTHQV0dmfCsIEeypZOji+QpK1noDFpaXTEYnM+vP7ony4morN
         HIYATijWYg3X8Alwl69V+SMqQIzLbjtRnOPnnB/jbDZQORCzIs2zDF7ZopVe8r1HNzEo
         YHUi/jUynd91nkrPoHN0eePeXaDBKArZziWJk1/KBFsH0FO2s+pfJElY/N2i3XPjQu77
         eZp649hXycLOC2UrooiM9l/uAWFc5I1nCjC9hHkTupca4DfrSd028sRJVQzOHjr3fRms
         buUw==
X-Forwarded-Encrypted: i=1; AKwUvBzVoPEfv0ggQ3MNGVN5wipRPOtPKbaXBl94ZX0t5u2yFxu9N9MzodlnIbocodDPbvfoRhm09TeUKkwhrA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/oe/qkQiY3nnWBuYKjc3rwbZWIhIfe5N6dbKJ+Ul62kwIFuB25
	gEQLWeo8l5bVL3yK1Agr2Jnd9X9LdnqtCi+UvSomnP1sLox5MpUwZUBtrbhBxFtKnQ==
X-Gm-Gg: AYBFou1hoqKvWLVcuApTnGkXE1gRo3C7N1aqKF+3mIgt7wkpOCgJyvLM81mCob2zYjK
	Ko5MLNrWHtoq6fV1vbb5PIUBLAPsH+FDMlRVroqGbmpJHY5wnDdixk35+Zdkps6qUnOWzGBpA2Z
	mzaOw3LUmHtfGqbV7zhByL1X4bLeP6J5yqVDz8lx+NiNvxMVEGh0zK3/0Ur3ElY4fVzljYlfOlk
	6Asi46hk1HtTFsL7WIs1zOwEggaBDcVGqT12ns7qaieEyYC/RKmUv6RalOLBZ0FQd/4NX3E9otl
	Gvl0/1qyLzuQPihZiI2izNtkr25BLdRnEc4MlDVvaAaW+Q9KyyxnENMLQFjCTDCP58fnRhDJOkO
	Rq1zstYsGZSyMoAnkAiSqS8qRM1BWs4iQv7EtGhb9/FsQdvqS0FRl10AdqU9yYjbV/9bwzS9ZLE
	aYDgiJCERWSwpV6dzh0NshdZ7cmkziRYpkJltbvY6eeiUVky9+hbtlnY2D9wO/lhFLQhbA0/IcN
	yKvk11PgE1PzIVZAQnwyStWSB6ttQPAvoyGczeI2W5mWwvzncP0lFD4mI5Pu54S6v3ZaUXZkMxS
	KqpRFwoyFoFiF/0yaujD+gin7k8MtwkSxFef2yBoKcc=
X-Received: by 2002:a05:6214:ace:b0:91c:7a68:2ab3 with SMTP id 6a1803df08f44-91ca4bb34camr203741326d6.37.1793686233610;
        Mon, 02 Nov 2026 22:10:33 -0800 (PST)
Received: from localhost.localdomain ([2600:1011:b1ae:f075:aa26:e161:414d:7ec7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca807d8fasm109173076d6.41.2026.11.02.22.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:10:33 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: wqu@suse.com,
	boris@bur.io,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: tree-checker: reject extent owner ref without simple quota
Date: Mon,  2 Nov 2026 23:10:21 -0700
Message-ID: <20261103061021.2213691-3-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103061021.2213691-1-smish149@asu.edu>
References: <20261103061021.2213691-1-smish149@asu.edu>
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

[BUG]
An extent item can contain an owner ref.  The owner ref is correct only
when the super block has the SIMPLE_QUOTA bit.  If the bit is not set,
check_extent_item() gives a WARN_ON() and then accepts the leaf :

	case BTRFS_EXTENT_OWNER_REF_KEY:
		WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
		break;

For all other incorrect inline refs, check_extent_item() returns
-EUCLEAN.  After the tree-checker accepts the leaf, a free of the extent
calls btrfs_get_extent_inline_ref_type().  This function ASSERT()s the
SIMPLE_QUOTA bit.

On a kernel with CONFIG_BTRFS_ASSERT=y, a free of such an extent gives :

  WARNING: fs/btrfs/tree-checker.c:1782 at __btrfs_check_leaf
  assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA),
  in fs/btrfs/extent-tree.c:354
  kernel BUG at fs/btrfs/extent-tree.c:354!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:btrfs_get_extent_inline_ref_type.cold
  (fs/btrfs/extent-tree.c:354)
  Call Trace:
   lookup_inline_extent_backref (fs/btrfs/extent-tree.c:919)
   lookup_extent_backref (fs/btrfs/extent-tree.c:1100)
   __btrfs_free_extent.isra.0 (fs/btrfs/extent-tree.c:3319)
   __btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2134)
   btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2246)
   btrfs_commit_transaction (fs/btrfs/transaction.c:2278)
   ksys_sync (fs/sync.c:104)

Without CONFIG_BTRFS_ASSERT, the kernel gives only the WARN_ON().  Then
btrfs continues to use the owner ref.

[CAUSE]
I made a crafted image : an owner ref, no SIMPLE_QUOTA bit, and no quota
tree.  I removed the file of the extent.  At the next commit, btrfs
frees the extent and gives the BUG above.

For an owner ref without the SIMPLE_QUOTA bit, the tree-checker gives a
WARN_ON() and keeps the leaf.  For all other inline ref types, it
rejects the leaf.  Two sources can put owner refs without the
SIMPLE_QUOTA bit on a disk : a damaged or crafted image, and a kernel
without commit f2363e6fcc79 ("btrfs: fix transaction atomicity bug when
enabling simple quotas").

[FIX]
Reject the leaf with -EUCLEAN, as for all other incorrect inline refs.
Then btrfs finds the problem when it reads the leaf, and the ASSERT() is
not reached.

Link: https://syzkaller.appspot.com/bug?extid=d7d1fc7e21835ca19219
Link: https://syzkaller.appspot.com/bug?extid=4983e68a6d77180bfe33
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/tree-checker.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index bb86c30a2..f021ac14b 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1779,7 +1779,11 @@ static int check_extent_item(struct extent_buffer *leaf,
 			inline_refs += btrfs_shared_data_ref_count(leaf, sref);
 			break;
 		case BTRFS_EXTENT_OWNER_REF_KEY:
-			WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
+			if (unlikely(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA))) {
+				extent_err(leaf, slot,
+					   "extent owner ref without simple quota");
+				return -EUCLEAN;
+			}
 			break;
 		default:
 			extent_err(leaf, slot, "unknown inline ref type: %u",
-- 
2.54.0

