Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793986391;
	b=QLpARtuj6csgKS85aPd8rlTv+DpiR3W5PhmfmcsYFD/dNsovI8x/1hdQsCuZjI+LJX30
	 xGaU0gjb3IhV0JZNz9NuR2QCoCBIA+o92XZEvKfgFg4XWFQfoSG7U6WZIdrHB23kTQO9p
	 aUjiwaD7YFLxlWeBr03zTQkgaaYi+BO8CwqzKtrF4H2KHxAPTrhs9TrOQlWO3qvVWpiOI
	 3VUfGNCABnFlA67Lamcc9E0XSsgVY1rqGp6YD1ObVv5DRhTC98jSslhXe8d2cEzjWYfK9
	 sdC+Xkm+ZbqihOQdWGQPzB/uopQRIzUknb4D9TFLZvW2M9MLmkoRAI43cTZjudnkqKw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793986391;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cjTq7uySt7Rsv4iF42M6aoE6IA0xv74EAK545jm0SjY=;
	b=Uo7vXkN2PhdRwnR198lnK2Vs8KNaLxAKk3MEK/WctwbyAVoiWSnejNod4hjhv058w3BD
	 dE/xQpfBq72UXvZNpZfyja/s6JVbjW5SE6Dz758W0U5flOiAEBwHvBqIUOuk5t75XluUm
	 YMJ0DZ+IackH8vzVqolWE5q4CYRr3A9blghPfwO7zYq/RjCK2yInn8K5+TX32Pv6AXNYd
	 zMt9/nWR4tV6tfKDGuRDvWeqGdanexvYaAk7pSGmhny8haYY3hrFxr1SDLioQYSqNgn4Q
	 nla+sKK232Y6oq28Z3IG6OX/84BSAVL6ZijSthRMePOPoyKK1tzQ7LjZEcUQm5Up/Ag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xzs7Dl3F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF488606A326;
	Fri,  6 Nov 2026 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xzs7Dl3F
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793986390;
	b=J75dkUB0L8iCX8nt1Gktmh3THe8VS39miStJx1679b3DuHnXJoz9bMfTsF/0ljiLYKl1
	 vo8DDD10pwYbDJgSMrcvIhKaq0e8CFCU4LUIbk1ouB4D2x/Blmn28q+Voh5dnKecz5ejl
	 3BCoodJCMKo0KeE18oS/enQcDvYiv8Dls7GgXfBNwbM9t+pACUWFUoxjSxNSNK4iE/+dR
	 DpBcSAzOGlil8gTvIets6fuShhjNzYw9EQkn+FQQ5h0Ugvr8rlwGafH0Rt5eqs8EhTX7D
	 A/uU2PLyM/k5ENY//NY7z/0WC22iExuWz0YXv4Mguxscvmpb7qFU5vyTFf5nLi4fmgQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793986390;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cjTq7uySt7Rsv4iF42M6aoE6IA0xv74EAK545jm0SjY=;
	b=gRSqb/DH1jRQGBwTfZSmocE0TIjQzaFFVSz4zJj+WsnKJbpTgCeAKFDdWccLNt0LWh1f
	 zjN8lIgKVuIdm9rJJoW3ihQAxbypRIFrGqEL1H6TDe3W+va4Ch5gIbUWT3RPPAQtJbyj4
	 Ci1nf8HKRWMIbj0HSAt6UCW4YEUFpjR+g8W0Adt/12J+Vqxt77EJSiOaEAKqzhjWsqZqv
	 fjbVvOC6E8uA1VzhN4G5BSAHarKOildoIN8pMXcBU640GXtlmI3qfJkMp130o3HsqI9Kk
	 2XJLutAXHQFCbVO2odDsryqTDH+fgfM0mVZvS/npuNQgGG3bCDDPrsB6jg7ijFG+6qQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 36AB61F008A2;
	Fri,  6 Nov 2026 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793986390;
	bh=cjTq7uySt7Rsv4iF42M6aoE6IA0xv74EAK545jm0SjY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Xzs7Dl3Fd1TBw7hWdl6TK5um9aZQlAkKU5Q6AP+fW341qQHRMOhGcGP3Ud3GVKkM7
	 q2RVjuu84wvSCdGlNFRrGq4gOR9P4Vf0CMY+rPDCbvGWZewNw6f+MaW275IHxnqaGl
	 FvarqvMCIvloJoYkhyt/qcVF5eJEfgjTthXZnGRuNpgXbxl/DtE4mYv7dYJ/BBv6iP
	 7oJkckC+Pmz66f5N4A2+hj9d9sAPqtVnBVwfJjWj6JU2rc+JVyBTpFFcrhnscMq+X+
	 VlvLhxieDrZ4pcz2G9O6qGBtmzeNXXVI8q4oFof5Esu6Ye9e7Ryn9yHvqxpJvkZRkH
	 01olyz4tG+aww==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9D80745E04;
	Fri,  6 Nov 2026 17:33:09 +0000 (UTC)
From: Mark Korenberg via B4 Relay <devnull+socketpair.gmail.com@kernel.org>
Date: Fri, 06 Nov 2026 22:33:09 +0500
Subject: [PATCH v2 1/2] btrfs: tag tree block repair writes with REQ_META
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-btrfs-sb-read-req-meta-v2-1-71c1afaf5c67@gmail.com>
References: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
In-Reply-To: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Korenberg <socketpair@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793986388; l=1104;
 i=socketpair@gmail.com; s=20260603; h=from:subject:message-id;
 bh=YFyzH7lKR5afoL8KflpNwQVQtbrBLsyNhI5jTu4GvOI=;
 b=LRjo3+UMw8+Uy8gjTh53YtHvFCNT6N7/7K8GFHXitnuoTtAc8J97WHxEfKWx/uQ4POZDzrunT
 9u5k2VJl7DlB9efjzve4JIDeZSrmVrWTIPKnyRH5FqZAdDrsaZTQCcG
X-Developer-Key: i=socketpair@gmail.com; a=ed25519;
 pk=2iAMjWhs7kA9X8ccetT2YVX8dvniXua2okQogw3Don8=
X-Endpoint-Received: by B4 Relay for socketpair@gmail.com/20260603 with
 auth_id=806
X-Original-From: Mark Korenberg <socketpair@gmail.com>
Reply-To: socketpair@gmail.com
Content-Transfer-Encoding: 7bit

From: Mark Korenberg <socketpair@gmail.com>

When a tree block read finds a bad copy, btrfs_repair_eb_io_failure()
rewrites it from a good one through btrfs_repair_bbio_failure().  That
rewrite is a plain REQ_OP_WRITE | REQ_SYNC, while the read that found
the bad copy and all other tree block writes carry REQ_META.

Tag it with REQ_META when the bbio belongs to the btree inode.

Signed-off-by: Mark Korenberg <socketpair@gmail.com>
---
 fs/btrfs/bio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2e12a6d7e16f..efbce4d549ff 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -951,7 +951,8 @@ int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *or
 	}
 
 	repair_bio = bio_alloc(smap.dev->bdev, max(1, length >> PAGE_SHIFT),
-			       REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
+			       REQ_OP_WRITE | REQ_SYNC |
+			       (is_data_inode(inode) ? 0 : REQ_META), GFP_NOFS);
 	repair_bio->bi_iter.bi_sector = smap.physical >> SECTOR_SHIFT;
 	while (cur < length) {
 		struct page *page = bio_iter_page(&bbio->bio, iter);

-- 
2.56.0


