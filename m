Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D0F4E56DC
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450213; cv=none; b=NFXshSBrbHSNBosWmkokvN81HCWURPz+IFlCyCSj+Ee8tXznHTRN7xFbBA8PvQrQDFN7PCewJJg0mS50RA3hujhWD0EC7Uzrj2r8ECmdrbyWrTNhIXRVcOPrLNpoPx3iVDSqoBgEioH7BGaPGqQVn4KC+osH4aORJTpqofyrCwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450213; c=relaxed/simple;
	bh=2prFQa0psj1aXlhcmwUn2vjNLZMuRpBaVHux1S6d7bw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYFIF8V9vIdTW2X5JsnbGPf4Ff7t01aZ81TAnQ6nHBPi9vAvEXKk0oICTMdaldnR4Cbq4rtY08zHpMNAhE7HZuQ8Av4Wcr62diNZ8WAkiP4EO2JakciI7dVsBp7Y/7lfDxnYuKtTCC0zSj/1bHB8wfA/bPuaHI+/jiELam8Uzhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsELN1Rg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsELN1Rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704BE1F00AC4
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450211;
	bh=AEuANMb4eRoROJ4fKWYFNIfX5oF6SeszmCXWJPpr1Wo=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=KsELN1Rg0mfQaj4PAamaP0RnvrsVpug7/YhNdIY+Hz11Ny57H2qqxJAkbuFzfYe+f
	 CpQUp68epHEwdsJ7yTGppsweY4Q4O1IyKHGtxaX+LZG4hMNd6S5ztUPAQHjhTjb13v
	 zPwxCOS4T/fB0mKUJQvgTn02HJ0lwmUJoJlpBhxGl8NqIgygvsjBAUX9UedIYnF7yL
	 3HsQECJwwvnqPj9Z0iXcQfXTq3VGul9aZXtMaYTQwaQEPht4+ubPJlOnc63b62197t
	 PCi9f8d2Q+bf5u/JM6pjgfqmCB24/X8VP1j2gHtx7E70AsU7KGbORbDTx0FNMqRabU
	 dPkDZgXwNOjhA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: tree-checker: validate key offset for inode ref keys
Date: Thu,  3 Sep 2026 16:43:07 +0100
Message-ID: <824df0d36c542ca47218695d3a0f2d070149969a.1788449622.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1788449622.git.fdmanana@suse.com>
References: <cover.1788449622.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

For a subvolume tree, the offset of an inode ref key corresponds to an
inode number, and that must always be within the range:

  [ BTRFS_FIRST_FREE_OBJECTID (256), BTRFS_LAST_FREE_OBJECTID (-256) ]

Add a check for that in check_inode_ref(). Sashiko had complained about
such check missing in another unrelated patch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0ce91396b517..baddde54dfab 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1909,6 +1909,16 @@ static int check_inode_ref(struct extent_buffer *leaf,
 		return -EUCLEAN;
 	}
 
+	if (unlikely(btrfs_is_fstree(btrfs_header_owner(leaf) &&
+	     (key->offset < BTRFS_FIRST_FREE_OBJECTID ||
+	      key->offset > BTRFS_LAST_FREE_OBJECTID)))) {
+		inode_ref_err(leaf, slot,
+			      "invalid offset for ref key, have %llu expect [%llu, %lld]",
+			      key->offset, BTRFS_FIRST_FREE_OBJECTID,
+			      BTRFS_LAST_FREE_OBJECTID);
+		return -EUCLEAN;
+	}
+
 	ptr = btrfs_item_ptr_offset(leaf, slot);
 	end = ptr + btrfs_item_size(leaf, slot);
 	while (ptr < end) {
-- 
2.47.2

