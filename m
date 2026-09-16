Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D94309EF9
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570965; cv=none; b=o4idL9NRaiQnvru6khPJFsZr+VminMJjR0965byKxBNZAxVAhxnVTllhJeEu6Dl9q/YqFFVeo9u8ztCvKwJQcLDxiw01ibkHNFI1LQUf4we5nuj7qK+nnNwBkrSXz+qjzC88uI/0Z/GbhqyB/3TLrHmt2WdbA+mS8nO/TYkP7Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570965; c=relaxed/simple;
	bh=zmB+SpsoD4dwGDsMmmvOEu9R4f2pBPVZ4w1v69pZq4w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PLI0LpbV32fE8kKe3hzbSORjR8DjGRxXosYFL9lyV7A0+GVapxmKXYxYEcMdxnhYtjf89shqwsExFopWtIvrGerrKQTlyYiGo/j6d3lSiOYxW4IlWvbBVAf3lL4KxP2YefNtWN7XxYV48sJreucdV9Dm0EpIVfK2NxpUorHXkzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiYizV53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiYizV53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863FC1F000FF
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789570964;
	bh=AW3SR0x3dyTQ/zk1ydL3ScOwbiExPglC22KxSdvDY/c=;
	h=From:To:Subject:Date;
	b=PiYizV53iU3w17NrfVMR7Ozu7IVNtahr2V6LmGF28Ztfrlpjzsw5dVfVWHWdDvik3
	 y4d97RhutsUdhqAhesVD1gacuEk3zCE1GWtcTbElaAer3WBYUfk9TmCmQCAj5Vg7xy
	 Ovmwb9BhTrqVuuHjmTJxvRAoSruZqpgN4xhao0K4ezvg1cqZ42Ypi7Krl66NA0H4Pn
	 ZmOhipkxaIxFlS+3lUXy8LKB+p8vC42u024h2OO4bhA2YbKTgzlwwotj4xHmZ7D9Gr
	 vYr7CO+1+8hpjYzromrSTIpVz6Z4Jm8uN55oBu7dPPul1WhZDjYhE3GWzP0eliyI/O
	 Bo0pJi1e5bgTw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: abort transaction on failure to update inode for hole punching and reflinking
Date: Wed, 16 Sep 2026 16:02:40 +0100
Message-ID: <5eaff5e851684919160420f975c26574d05d4c44.1789570705.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we fail to update the inode we error out without aborting the
transaction, which can result in a persistent inconsistency if after
the failure the transaction is committed, as we have dropped file
extent items from a range and either punched a hole or insert a new file
extent item for that range (for reflinks).

So add the missing transaction abort.

Fixes: 2aaa66558172 ("Btrfs: add hole punching")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 20e15dc30bfb..f978c6524aa0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2509,8 +2509,10 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 					      inode_set_ctime_current(&inode->vfs_inode));
 
 		ret = btrfs_update_inode(trans, inode);
-		if (ret)
+		if (unlikely(ret)) {
+			btrfs_abort_transaction(trans, ret);
 			break;
+		}
 
 		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
-- 
2.47.2

