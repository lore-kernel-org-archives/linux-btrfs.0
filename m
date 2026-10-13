Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F7F51EE15
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910781; cv=none; b=Yn9CdIwSFpXxUR6VJ5Ip+QpcvZPGlQ2lNtE1SYYqhazgG10YkjJPtj7CbCBYAoaZiSdhYNMBjoS7cCXK5zcf+GfVjS/Kp/8L5CLQxenUpL3bjmdewXaejHJynpbRQwHZFPvJ1/HrsuPKce50P3gcLCJZs4k/4pIWd/X/vhMdbd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910781; c=relaxed/simple;
	bh=h6CXJZo9Vwj70i6vdxooA+iQg8SJO8aX8A8AC5aNWoA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MfJy+kBu2emG4oK2LTdJjZWW9D6Gvc5GHK5Uj7PkTltVVmIK+esL3wFN6FKr/1KLT79/GUERVLGR7WodRjSsCvoGtnlyRw59ND19+FFGs2fTi5eSrOm3njRDDzsMA5hCfVhbkCqINxRhOCCYZGbPEUjgiHly+FAQcREhP5RgeQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ycz4CujT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ycz4CujT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029CA1F000FF
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791910779;
	bh=AbCQXGkftOzzy7vBtApdux6/y1V1jgl/27IJoaZNnrg=;
	h=From:To:Subject:Date;
	b=Ycz4CujTf8CcCfJoIZd34ToBZY6+QqbhS/DPlAOH7AD6nrJtmzBujIuLfCIl9sk3O
	 HzYD6rBA7EXPAFrvLty6kgbdLyZdLyCyXgIK4c8y4rpDruY2J9Jwyf8B13mtEg9UDa
	 8G92wa3k+M/P3BL3/rRSktMPidwi5/8gHyiccjeGnL0oKA29R5/ZBTLruXptr3i/u9
	 Zg+Y3jgoMTaFlaux2Tlgu7QRV3yl3MmDllSt26QyrvegQCVgOjKbLzKostQZ6VLus9
	 DEL+0nBgfQXRJCcYmAjBqRmY1+qRajmFv4DwyBH/zf9G0IlkLL4oSEqqdGrFXcC04O
	 SaYd048OapPkw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: defrag: prevent inode truncated to zero from not being defragged again
Date: Tue, 13 Oct 2026 17:59:33 +0100
Message-ID: <a010e1306817aa6aaf248bbdce7fc37ce9147a72.1791910727.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we add an inode to autodefrag and the inode is truncated to an i_size
of zero before it's picked by autodefrag (run by the cleaner kthread),
we exit btrfs_run_defrag_inode() leaving the BTRFS_INODE_IN_DEFRAG flag
set in the inode, which prevents the inode from being auto defragged in
the future until it's evicted, loaded again and small writes happen to
it again.

Fix this by clearing BTRFS_INODE_IN_DEFRAG before we check if the current
offset is at or beyond the inode's i_size.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7010d714cfe1..cbc532b49c67 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -242,13 +242,22 @@ static int btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 		goto cleanup;
 	}
 
+	/*
+	 * Clear the flag right away. On the first iteration (cur == 0) if the
+	 * inode happened to have been truncated to 0 after it was added to
+	 * autodefrag and before we were called, then we need to clear the flag,
+	 * otherwise if writes are done to the inode we won't be able to add it
+	 * to autodefrag again (unless the inode is evicted, loaded again, and
+	 * small writes to it happen again).
+	 */
+	clear_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
+
 	if (cur >= i_size_read(&inode->vfs_inode)) {
 		iput(&inode->vfs_inode);
 		goto cleanup;
 	}
 
 	/* Do a chunk of defrag */
-	clear_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
 	memset(&range, 0, sizeof(range));
 	range.len = (u64)-1;
 	range.start = cur;
-- 
2.53.0

