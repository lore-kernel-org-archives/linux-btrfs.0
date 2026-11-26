Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795717479;
	b=Mqe0uH4vtz0wumiAE5W1H/xzsvrgZpgm9ZAne+4tmrBQnop1oNjjzGkf1myiE7ecyGBF
	 1MuyRjLPvVQJm4WGeI9xFPXLEwJNjOa+T84qyabnDt3PsB/gLsQJYcpWmiBebAO343+0N
	 XsWZgmuf6JL/SKMXchaiVBxU80etquPTTIM0qTUZ0jeC/Gn/54koPeuWVv1SSjY8D9zQU
	 lk2Hnl/u/IaukB3/qAs1Cv+Zw7vKtNsjHL2PqIPYrlP147X4rSW5R7BbyAUsP7OKgBYm3
	 M5HjWeMj6bswHMPIN+1w1DcTmHBv3QPBbp0oC/x3QeyOdq4GnZBHMFpO/nD1oqZQTaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795717479;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TGhM2wqKBcfsRUNvkDFm50QhpTKN1v+as8ONrzlB2PY=;
	b=OQRGNQ0a6qE9kBPQ7bhpgScwBb3E5STNmth3dNYTpeSGIb+IGzbRzTd6N9RUQZf7Yk4l
	 vOw28peQwTBoMWBYrcesNjFsszt/FikQ8A7SYRHP1Qaim5uTGnlhpwG69ML9J0Ij97hc0
	 EY8fwQTUi6gQgoHhsZvSDSHhp++QqPUOTNJYJah3f21/KABy/sK34EX7bd0EiGoUD9vZQ
	 3q5eRjZ9i8vBIZzSQsp14SKe/r8Y+aMFJIJtDPs92B7jHaxKuqYGdXZjCCzuHUlWng1dA
	 zKV8DtEw1D9lhLZFQl6vS/8pxVBXgL7jEY65eoDRPdM6clYxKFpGSxjVajoqb1P0HTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XreYpQBL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784F9606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XreYpQBL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC071F000C6
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795717479;
	bh=TGhM2wqKBcfsRUNvkDFm50QhpTKN1v+as8ONrzlB2PY=;
	h=From:To:Subject:Date;
	b=XreYpQBLqbOLfTQumPgUibeVaJxRmXmNY379Dlgfwl8N/mDo68hoY3kzcLgsUy9kB
	 LeRt4dZpJ1aqHYZkxvPGAa4bCRwtN3+6TCszBy75oVDlcJpL8th5PvXykLLMPxxFXz
	 GPZgtiYBCLma3FLZJKttqyyBlfPSctPMW5rPRSFG+qNpwvU2FwSc8i+RSOFrX2AVLk
	 LBuVFCyL2p2IXGdQ+cU1rq72rt0TbwFpgL1iibZkWE3Fjj5TA+goQHRi1UQ4XOQRQv
	 521ngxvNaVvuCN0IRfjR/mQsGgfLYL0i1WwWjghOjNqtSWpxocLX5+REX1KKjmh0Es
	 nORyMLRcT7dfg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix inconsistent state after failure to delete orphan in finish_verity()
Date: Thu, 26 Nov 2026 18:24:36 +0000
Message-ID: <11a351167825b335d04c258000331108b0e8b02a.1795717416.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

From: Filipe Manana <fdmanana@suse.com>

If del_orphan() fails we remove the BTRFS_INODE_RO_VERITY flag from the
inode but only in memory (in the btrfs_inode structure), while we
previously persisted it in the delayed inode when we successfully called
btrfs_update_inode(), and we return from finish_verity() without setting
the COMPAT_RO_VERITY bit in the super block.

This means that after we release the transaction handle, someone can
commit the transaction and we persist an inode on disk that has the
BTRFS_INODE_RO_VERITY flag set but we don't have COMPAT_RO_VERITY set in
the super block.

Fix this by aborting the transaction if del_orphan() fails.

Fixes: c349b233d6ab ("fsverity: Set S_VERITY only after rollback is no longer possible")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/verity.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index cdd63af14c0d..8bd9f141f2f6 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -567,8 +567,10 @@ static int finish_verity(struct btrfs_inode *inode, const void *desc,
 	if (ret)
 		goto end_trans;
 	ret = del_orphan(trans, inode);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		goto end_trans;
+	}
 	/* Now that rollback is no longer possible, set S_VERITY. */
 	btrfs_sync_inode_flags_to_i_flags(inode);
 	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
-- 
2.53.0

