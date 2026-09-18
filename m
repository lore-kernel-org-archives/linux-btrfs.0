Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57D4EE84B
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734505; cv=none; b=ExE9A2+mNRSyhgGfu8x54XHxEQdNxMafN6DcuTfdD8eE0I+jsB7oraUX2mcXIZf/Cf+ggyopnEsd0tkvnKIs6iSNjW393I8R/Bd5MKYRXmPdF0+2mLgAYFABCXROf/zjA/+F0YFRbkytG/uwL55EmTdSJfSZc+jLI+913grkX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734505; c=relaxed/simple;
	bh=t7oGdPujS0zH8ve6IdBvqHjSk8AWX9/uNCifeuG6KJI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPWyk84uT1Bcg/tgFWA1ecT9lxzI4fMuIBKxfUTGqD+7Eh4PegzTwM2kL5EASdBfZOllm7hirbNjAn5DHgrMsJVrg3IXxYhJ2ZjgE0cTctu8Z/QcmIuAebzd+O453SbuGz6Tj7s3O0dv+znsZ/wmeYYtVJVaL0OoT/GX6vk+xvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lY2KBgnm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lY2KBgnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41621F0089C
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 12:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789734502;
	bh=DPOfza9k5iMtHjekpHFqvWC7U2VNgk8Xh2kPctYPHLI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=lY2KBgnmX3BAZZ+2r5nVJaJ3Fq2XRY6zlPCTpzkuH+MRNzX/scTSYz9zr8vCbcvRK
	 M+0cx9f1D6x+VSJbhPVWnj1Ncp+mF+r9+az86WGUiNF0hs82qJLym7UOLpAnwNsOyG
	 w0ozHHc6eX8nGY1wswGNeNYZ7iNfw+00Z9Nie9MyzA9WIqhIvhRm6lDSp4wO02uNIy
	 dBPG6+QF7iyMADK3g3S8FPaiS/wElCKR1htxdmdJ7owpFIv5FucwSa+zeIbEg7KjgW
	 AJPI+wBLI+sqvGN4qy5fzeYQINDsX9YQ6xb5pFm+nqEm7W7RZTUbPjAKo8Z3A/fn9v
	 Y88qdgqhcT7LA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: assert reloc mutex is held in record_root_in_trans()
Date: Fri, 18 Sep 2026 13:28:11 +0100
Message-ID: <3fb8cf7a662a1612840b482754429fd3f5f3aaf2.1789734247.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1789734239.git.fdmanana@suse.com>
References: <cover.1789734239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The fs_info->reloc_mutex is supposed to be held when record_root_in_trans()
is called and we mention that in a comment inside the function. Add a
lockdep assertion to check the lock is held.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 13203ea9e116..0a3913b61f16 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -413,6 +413,8 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 
+	lockdep_assert_held(&fs_info->reloc_mutex);
+
 	if ((test_bit(BTRFS_ROOT_SHAREABLE, &root->state) &&
 	    btrfs_get_root_last_trans(root) < trans->transid) || force) {
 		WARN_ON(!force && root->commit_root != root->node);
-- 
2.47.2

