Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C874A384F
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438437; cv=none; b=OT2bOg/h3JYqH3ZVCPicOEcu0t42x5hAkOGGybDFEAoMk3WiBFx0WqimlgkoJRpZLvzr2drRAMehbnKeBjEZncitHwhtD87FHJOkBRQviKMS0jm28qgFSPHmNzd06djEtr9ynJyuU/gbWf7RmvG1QKom5uZpFLGLe1zaZskPK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438437; c=relaxed/simple;
	bh=AYp75dxR79bQg5bV76931ipAckjfgggfB5IoCJe+kzQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tfSARTpnNO3HXipm8OsQWQYgUfA7jirDt6Fup8tY9HxNZRbgacGehsbZLyZgHUODoXiVR0mkADD4Fpkcz3ZgqI2cSHMza3ri68dwParwh33KVhfqEIwdfyTz7wqpNHP6vvwrd90zC59f/ifBaGL6W61lBv3KlJq+xHZs9Ib9Jtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DushnQmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DushnQmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4E01F000E9
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 12:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788438434;
	bh=/Ba4ySno5uwPJOY4iABSv+B7sXo96H5Jlyep/O2UZAI=;
	h=From:To:Subject:Date;
	b=DushnQmtmng24C7Fg1p8utZdQw2jmIZMpj38i6BC+U2uVw1450GSICPOYKTbpcTri
	 85j6IeT58oZ7IBWXgi0fk3whXEVX2te3Um++hupdtSZ+aEpb4R7W1MjGh58UQ6Tfd1
	 5X9HtzlpYK6P9TfGCfzIPGO96GE4Q9CcQt5Yf6n5LdcIk6izYVJ2WbRLUZyjHmxwxi
	 E9nm2Y9ETOjejQ8VCbnj9hbiN8ZXHBUn7i9Axpg+aKxIwU7uXKBvPPD8IS19Y3AE8i
	 hpP7fCZDLb5+fN6jFJGocJzQYhP8hek6FU2M6wIJfCplWej8HdbUc27b/XcPoJzf37
	 3qbZnAVMxYapw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
Date: Thu,  3 Sep 2026 13:27:10 +0100
Message-ID: <8efdd4a651d579b37ad7929f613fc3bf8598bae1.1788438374.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
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
 fs/btrfs/tree-log.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7ba7b6098aa5..0b9518a04272 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7286,6 +7286,16 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
+	/*
+	 * There can't be an inode ref key with offset 0 because inode numbers
+	 * start at BTRFS_FIRST_FREE_OBJECTID.
+	 */
+	ASSERT(ret > 0);
+	/*
+	 * Set to 0 so that in case we don't do any work below, we won't return
+	 * 1 and trigger an unnecessary transaction commit.
+	 */
+	ret = 0;
 
 	while (true) {
 		struct extent_buffer *leaf = path->nodes[0];
-- 
2.47.2

