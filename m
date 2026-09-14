Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11463AA9D8
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 19:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789414831; cv=none; b=FPAJSqUwTrcf36Oxhjh2nSRnEH8vaWnhDah/eZwSGnPznj4AaxRB5re0HFngXSIKUKHAxNG9QrjFrr/j/ipA6ByjihoJOVP1dpR0Vv6OFrimBSmbJRo7adZcuSeu05qRLQvy5qVTakIMRiqR5f/h9rROBL2MowOh0Gqbpd2mw0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789414831; c=relaxed/simple;
	bh=Xx8hjFh1Lv2CnnSJc/9f3OoCNhu2yAbzPkFT0s5oibA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKNOV9yf9MnU1tKziVUQznKg+Q9VnrcnYIb7+iSYM4unmEWWE8Rtcc2QLcIgZ1Mvww7hRMIDXpcMCB9anHFAyO+cicq6psDUK2MQRNJJR+NiAL5fnDkLG5cay7mEGA1qdfjYiOj6ptWBvfXDd/p4K1D5QyUCv5pn+VnanWFdykg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZ1WdsKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZ1WdsKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFDD1F000FF
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 19:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789414827;
	bh=UmT3OcW0SOm0RT9cPbm4PbBa26t0HVXaNVWFQ3iJ7hM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DZ1WdsKgZp+C9ZFwZVVo2TWKC4fDgE0YqQAr7YQ9cipEC/QSDZSWePy/YCvEgRtzH
	 F4dKow6meH4ZlFGQ4bvCCu/HyZSM5w8vOCu8vjmM1SIpGM2QUQN+RTnsz3panze/9u
	 mrD+BJbbllwYC73ay0eqyCxnb/rQTL80SIj38ZfwI6r29lBTfaUiFXTCdilbegilM9
	 yxl+j9UbtA7ZD3mxzYSqWRWmUwBrpPKMwKl8rCXo5BZF2dR/2HRyx+vBRDUP3P0zEt
	 feqLcIV5geXIgWC8zz25lrKvjGZeKa1az8N3OUsJqVU/Ay+71IlfYQzj+nf5DyP1VU
	 m/q8kZ2UcU4cA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: fix creation of compressed inline extents that don't save space
Date: Mon, 14 Sep 2026 20:40:21 +0100
Message-ID: <db49ecd42bbdfb15a6e103d1e65da94cb7409543.1789414631.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
References: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If the compressed data of an inline extent is larger than or equals to the
size of the uncompressed data, we are still allowing the creation of the
compressed inline extent, which does not result in any benefits, quite the
contrary as we waste metadata space and have to decompress when reading.

This is a recent regression introduced in commit 3eaf5f082c4c ("btrfs:
extract inlined creation into a dedicated delalloc helper").

It happens because we are passing the block size to btrfs_compress_bio(),
so we don't get -E2BIG from the compression code anymore, but we can not
pass i_size either, because if i_size is smaller than sector size, we
end up never creating lzo compressed inline extent for such small i_size
values. So refuse the compressed result at run_delalloc_inline() if
its size is not smaller than the uncompressesed size (i_size).

Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
Reported-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V3: Fix being unable to create lzo compressed inline extents when the
    data size (i_size) is smaller than the sector size (caught by
    sashiko again).

V2: Check first if we can create an inline extent otherwise a too large
    i_size would create a lot of work just to be discarded later.

 fs/btrfs/inode.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85a7c561cf8..2b4387db937e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2339,12 +2339,27 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
 		}
+		/*
+		 * We need to pass blocksize and not i_size, otherwise we can't
+		 * create compressed inline extents for data smaller than sector
+		 * size with lzo.
+		 */
 		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
 			cb = NULL;
 			/* Just fall back to non-compressed case. */
 		} else {
 			compressed_size = cb->bbio.bio.bi_iter.bi_size;
+			/*
+			 * If we did not save space, it's pointless and wasteful
+			 * to have an inline compressed extent, so fallback to
+			 * an uncompressed inline extent.
+			 */
+			if (compressed_size >= i_size) {
+				cleanup_compressed_bio(cb);
+				cb = NULL;
+				compressed_size = 0;
+			}
 		}
 	}
 	if (!can_cow_file_range_inline(inode, 0, i_size, compressed_size)) {
-- 
2.47.2

