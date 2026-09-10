Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F81B1BD9C9
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058796; cv=none; b=TRujbasZ4obt6LwJ3Ob1i+l1qs+fyAKWMn2ckodYA3gEEXOC9ooQqVS5b+TzxXt5Mmg50H/1KeRrp6hdnnaISovW7j5G9FqTgYB8zk/RlJuVx8I3FEMckCX6VcqvEnVeX9p8vagU7X8keKBtxMv4yUBBhde8Fid1Hlmd3UwHKuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058796; c=relaxed/simple;
	bh=U0q0fn4214sZqTmnqJigp+hLHq3i90HzWBkLXmQCq9o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tZctRup19nKc+XePrclrsN+5RfAr7SKRhKttATJq02aONPL/VQJRZZc03C5vzn6Ed1C4ImMjackY8/SaI1pB/SyNjqk1L/mbopUz8VKBxqL6ymlfftMoiTkMO/jCb+A6rl7gj1Nxh/K5TOm2ATNjhvEiZt7HnTuL+Rqd9TlzWY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsfaINBD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsfaINBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F2D1F000FF
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789058792;
	bh=8q7vf076ToQdUuqh+5ctCfVut0oLV4qDDfaxt8dajYY=;
	h=From:To:Subject:Date;
	b=EsfaINBD7DI0Iry8xtV5gmkN9SvUgQSVGeHmp8VzVClBYzQMfxIZ1ilmK2YYYsbky
	 cPxOItou0lyzafXnb3rmWbnA3qLnqr3DJjmruJZ1dSwcwRCXyZjsJZQ9NCSX2sav07
	 NDMhFNn4Hg063r0+rhTlRkDpwh3Cm0qp9f8xEHqWS0dMgnJrR1WkXsj2OA0o37njJA
	 eVm8qrQMveD+WbPe56ugSDybKRilCaFK/o/IDWKHNs+n6Rijr6fXNm4jV4AFf++RJn
	 bryohklGILrs7F8dq4YS9qjExUueVg75uKHNFBI/UQcYG8uFfUjPTpzVsE6/+8BOAM
	 yG1p7BAP3H2KQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: print dev extent offset in error message
Date: Thu, 10 Sep 2026 17:46:29 +0100
Message-ID: <dcbc7e433e05fc137227f08015bfde547b7c1f6f.1789058730.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If a dev extent's offset is not sector size aligned, the error message is
printing the dev extent's objectid instead of the offset. This is a copy
paste error, as before this check we check the objectid field.

Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 401fd40ec7b2..63eea0852ceb 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2171,7 +2171,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 				 sectorsize))) {
 		generic_err(leaf, slot,
 			    "invalid dev extent chunk offset, has %llu not aligned to %u",
-			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    btrfs_dev_extent_chunk_offset(leaf, de),
 			    sectorsize);
 		return -EUCLEAN;
 	}
-- 
2.47.2

