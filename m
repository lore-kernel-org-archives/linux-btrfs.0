Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96743E51D4
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967358; cv=none; b=cTIVvGTw+DesjLqjvWexJ9kK8ZOj1QTt76NayV7j0RBWEg81nXDFusktKZFwuyO7Nx2LiMp5dkVygheQ/Xnj3hwOaLeVE+V9KoQrd/yZ7qNS3tMsOOkmKt5al3ser786MYtGM/U2+Yr2hoiajJ7R4W3QWI04M2MYF6+WgsppTHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967358; c=relaxed/simple;
	bh=PVUQY6aK4BxvrrUFNqzsjCa+1z+ijISWXom3h30Zh98=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/8lmejxxzi7mK5afbY+0ESpknHObng6TLvFwumkSBWICSSDq89/Nalhcpa3+iX5zuHW7x/rMfM/sUCt6E1C1gaRW34dVdOS6H5Fn9CliTBtla5mow5NfEpx5EZ/UlY5cYR7ibUPMhPycsKqV2ZikZJgN6CC5COsjMrGr2SAUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nI4I7EAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nI4I7EAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4985C1F000FF
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967356;
	bh=YwfCV59i6Z8UoYiP6oIJ1Tf7RFu8XKkf/lbY7Qwejdo=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=nI4I7EAM1QI+KrlvE5kwSvH9l55zCzcQOtSUiqNHk6B31lbGlpWR2jPG7topHot3J
	 D7qwdC3Nb6Y8c+V5y9jflLQXVVSSdB9TgDGYWrsyLUKDybGnYCb/Ipx0c3+p7EiHiL
	 UnKMQ3eGEXWlhhfhGMNRQKMdQYdrZiy/lKnxUMDy5CKEVIylv/tRWgT6CJKKukwwg9
	 l71ufxMHbTXIFVzDU52pEJnZa0IEcUJY4GQ6sSjvXtMzNnzMDQXApaNnCQBXkQDQ3I
	 P8ZC8FeBdFpWE4StlUJOkAust7m9cA+jdGNk/TdNCitBgYN/96gLRUYlZ8XrX+PwXP
	 bBIRCkvk18s0Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: abort transaction on qgroup failures in create_pending_snapshot()
Date: Fri,  2 Oct 2026 19:55:46 +0100
Message-ID: <2709bf35200a66c31d1523ab2bd76def4ffbdeeb.1790967259.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790967259.git.fdmanana@suse.com>
References: <cover.1790967259.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we get an error when calling one of the qgroup functions, we jump to
the 'fail' label without aborting the transaction. This is not a bug as up
the call chain (transaction commit path), we will end up aborting the
transaction. However having the explicit transaction abort in
create_pending_snapshot() allows us to get a stack trace and log message
that tells us exactly where we failed, useful for troubleshooting, and
also adds consistency since in that function we abort the transaction in
every other error path.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index da4ffa7bda00..fcbcb4a208be 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1920,14 +1920,21 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * To co-operate with that hack, we do hack again.
 	 * Or snapshot will be greatly slowed down by a subtree qgroup rescan
 	 */
-	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL)
+	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL) {
 		ret = qgroup_account_snapshot(trans, root, parent_root,
 					      pending->inherit, objectid);
-	else if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
+		if (unlikely(ret < 0)) {
+			btrfs_abort_transaction(trans, ret);
+			goto fail;
+		}
+	} else if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE) {
 		ret = btrfs_qgroup_inherit(trans, btrfs_root_id(root), objectid,
 					   btrfs_root_id(parent_root), pending->inherit);
-	if (unlikely(ret < 0))
-		goto fail;
+		if (unlikely(ret < 0)) {
+			btrfs_abort_transaction(trans, ret);
+			goto fail;
+		}
+	}
 
 	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
 				    parent_inode, &key, BTRFS_FT_DIR, index, NULL);
-- 
2.47.2

