Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DCB457E6D
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789407387; cv=none; b=aKCrL689wWpr8TuFcHhnsx4OzkXkILeme4ERre8KTZiH7ishXNmDqyT3USTgxKPJDdsIbZh2nL/twx39kiTH9KSGf5LJonGSJ95XZAEW+1Vp3wpurPRDvE5kvZKDe8hjB2oxXekpi3IyhEbd7bUA+t9KiyoNhk2E7pvomNd2H/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789407387; c=relaxed/simple;
	bh=2Eqn772vQsdhNQSxmPsTyPPstxuEhQqjBQj5HW7AXJc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cjfdFbvFqnZyUDdfNg8Z2+6ms4ZVAlj3v+3yuJpsHqoDUVIpt5Kp6lBLavlpRMu/FaXgkbblWLfsqAtPalQrD+KcwAM5jWS1nkd2l+O9p71hZQjOWB55+1iPhBTO6w77TMFLCKavahatPeJlZNiEZwxZyQIunPe2bco02QsiGrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1SBTTHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1SBTTHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC01F000FF
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789407386;
	bh=3mNlz7j1rQyEnqPTfZwbuGBpPRYLGhKknGq1Cv+T7lo=;
	h=From:To:Subject:Date;
	b=b1SBTTHFSCysuLP0G+f3NzUqH4882MJKt9hA6CatLM2gdYr0BbC1dJ5Nv2PnS8aXS
	 u0kgtDiZ4LDj+PZchfzzn9OtGeIncDYe3YpOiiqKAIbzDnBUW0Ct6CHJZFcVMsnQal
	 0JLSG+78EFAEgCuFwSVOEyttNpvqplb21z1HuzjxMuENvmVFhqGPNu57U5Bxkc3Rqp
	 nF2TUH1tCl+qIx5G/jw5jmLk1stLMLpdKExRv5styLMcU/1qH6hEu86zdh9HNOxkqD
	 OmEh3/4qZReogFu38pASE5ao0Ju+8BYE7z2+i7o66m9ER9/D2X61jfk2aJvocSnnZS
	 0cxTr5O51LEQg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix creation of compressed inline extents that don't save space
Date: Mon, 14 Sep 2026 18:36:10 +0100
Message-ID: <721d8fd2c73095d06cbdbfa714a6dfac9c488953.1789407346.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
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

This is a recent regression and happens because we are passing the block
size to btrfs_compress_bio() instead of the inode's i_size. So unless the
compressed size is greater than or equals to the block size, we allow the
creation of compressed inline extents that waste metadata space.

Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
Reported-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85a7c561cf8..420d78b55bba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2339,7 +2339,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
 		}
-		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
+		cb = btrfs_compress_bio(inode, 0, i_size, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
 			cb = NULL;
 			/* Just fall back to non-compressed case. */
-- 
2.47.2

