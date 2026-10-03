Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01A648F018
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791046814; cv=none; b=H56zcHJcJPDb0JDmY5rs5M69sG3Z/5riLQv8fyNRElk/f1ve1JW7evJcvOAerFpEJ+2BvANt7fc0syHH3UVSteLxc9RLuMNsrH2eXKZ7vdqqMu/WKenEXhV7BDlzFwTx2jwT5bS+zd7hc94i6qypXrbI6V0viQFCKpqJCTYd6rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791046814; c=relaxed/simple;
	bh=3qfSGQgisTOrgaoBbI1xZuXRjSv7ruuY27cdZqEbhPI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUTICsxzO88+NhS1eLjD+a77YgBuPMmqHqKwvfwXS9jc0sJ8W6gUeNyYCX0BWxSDSrvLPKRfov96IGvDdcyf1cgYFo78rqYN7OzwBteleKw8i+Yi+Ml/PxhPHuv0kK7oz8cZrQ46IGhUx1nT7ZPgFWUVJd3CmLthGEhsATpr3jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wu4coGes; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wu4coGes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F1F1F0089D
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791046813;
	bh=S584aFPMwSO6xilcxk/cLjddJRfzEoKxJURNACWY0Lk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Wu4coGesgfrIfOE/NsDRtNrB+8QzEF032Oe6skKFwDF1TTqQM9pboXeH/2dBPV6F9
	 V0TSc2A2KAT4TgeJGMb185XlWTCYHBiXuDUKa28Btk4M4aUsCx0HxYpEmWi1j0k1Ze
	 MnlEa43PHQ7W84nI3Apvb/v8yPb/yYQMwQHz2T44ZKNoLd5TpimeaeHEeX/Zf89RNy
	 AEWKmY1FUnsCq0II7La8WefdjegrZXyNSSH9UpQVL1tVgJ/CGOt/SOP4JByNSthvAq
	 WY8//HzS8e5bAr1SMXGyYbpQ0Z4vGN60z7RVpjaaYDqJop+gVB8Me0NvM4BkFcO8xN
	 9LVzJUGZhRavg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/6] btrfs: abort transaction on qgroup failures in create_pending_snapshot()
Date: Sat,  3 Oct 2026 18:00:04 +0100
Message-ID: <e09eefcdd2d6aecf0dc4e2a786b46789f6f66efb.1791046651.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1791046651.git.fdmanana@suse.com>
References: <cover.1791046651.git.fdmanana@suse.com>
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

Reviewed-by: Qu Wenruo <wqu@suse.com>
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

