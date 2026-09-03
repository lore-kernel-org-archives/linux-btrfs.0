Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99A032B130
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451239; cv=none; b=F0i5wRSVlPDHNSDyqWmMXsSDEi7H4MclCSwO9QKZDuSwNoQKTW0xy5I6VYQd0m7f4hPtGmGy7jlOEYNL8CANgUnfUpmgGLShIEAOegiJGbLqTxigMfKQofPSod/n3hPyTB4a4i78nZPKYVk1NSl0+m3fWKVsdMb7LSvIhhlNqBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451239; c=relaxed/simple;
	bh=I1q4TgxrQ3gyxNbRT2rjwE1CeU/lhdwiYHBQu2HPUWk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDn5V/+RGzQFlxS6sJfoQ6uXjRigqZ8srkmz6ZrbDECMqVjCe7gVr9vBAKWHsKY2g3Lb+HB2sWd/awST9rkW+NNxr+xDniG98ImUUmeglB2XGhVVjcF9695T6X4Dvc+8CvnucexlYRJx1Z957BizDmmmsX55HF7pjsGYWO4PKSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuvP8BFY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuvP8BFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBC91F000E9
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451237;
	bh=S6b2yNrI4Zd61DPZzKg81IDJyw1c+4+ip/BkNFK687U=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=KuvP8BFYjAbCHyBo41YXuP1uFLo6c9D/RoGwkJBrv/A8P/3IyL7/ApmZxCLhjuYBv
	 eCOgKKHDD05MrO/pqZpni1BeZWbtJEqBbYd2zcjsKVB10xmnL98VH5ufksKQf/Sgzh
	 +Zd/DdyG9lX2GeO1pTgymTILtgnfCChGdydDJdurMZOoc5VPTkeQJYByqUZtIOP6AK
	 raol3yjVmgPgNGRSEfOnWbH+u/XUeQUpYEF3LzV3vRqPlmTl3NS+U9gtsMuSqe969w
	 EtwDqwKOHMyjNsgj6I8cionqOwMIyqWZAySsmI7dAtbLWM41ZeP4XWQt7Rs6TGYk+4
	 N1iA//U3jJb1Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/3] btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
Date: Thu,  3 Sep 2026 17:00:31 +0100
Message-ID: <33ecf167852424f777a0ae9048444da7fbd1ff0d.1788451065.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1788451065.git.fdmanana@suse.com>
References: <cover.1788451065.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When btrfs_log_all_parents() returns without doing any work (because all
parent directories were already logged), it returns 1, which is propagated
up the fsync call chain up to btrfs_log_dentry_safe(), and that causes
btrfs_sync_file() to trigger am unnecessary transaction commit.

This all happens because the call to btrfs_search_slot() in
btrfs_log_all_parents() always returns 1, as there can not be any inode
ref keys with an offset 0 (an invalid inode number), so if the while loop
below it does not do any work because all parent directories were already
logged, the 'ret' variable remains with a value of 1, which is then
returned up the call chain to btrfs_sync_file().

Fix this by setting 'ret' to 0 after the call to btrfs_search_slot().

Fixes: 0f24ea456ae1 ("btrfs: tracepoints: add trace event for btrfs_log_all_parents()")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7ba7b6098aa5..a00094604e54 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7286,6 +7286,22 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
+	/*
+	 * There can't be an inode ref key with offset 0 because inode numbers
+	 * start at BTRFS_FIRST_FREE_OBJECTID.
+	 */
+	if (WARN_ON_ONCE(ret == 0)) {
+		btrfs_err(trans->fs_info,
+		  "found inode ref key with offset 0 for root %llu inode %llu",
+			  btrfs_root_id(root), ino);
+		ret = BTRFS_LOG_FORCE_COMMIT;
+		goto out;
+	}
+	/*
+	 * Set to 0 so that in case we don't do any work below, we won't return
+	 * 1 and trigger an unnecessary transaction commit.
+	 */
+	ret = 0;
 
 	while (true) {
 		struct extent_buffer *leaf = path->nodes[0];
-- 
2.47.2

