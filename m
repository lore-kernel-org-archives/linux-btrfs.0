Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ED04E2376
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450212; cv=none; b=oor4KkV9UKzGj37KAedaf0hmpuXfmYKXP9s73e674A9WfNqzMicMSHRBU6Dagj7iuNIwI0OLC1ts/5qf7A6Rdda5HN06g5M0xS6QOkf/OjFwS32hLxlAhJMVypSoukBqkg37/NW0B1hE1JGJG0oVFIrWXzy3yPXw80NbC9/B3vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450212; c=relaxed/simple;
	bh=I1q4TgxrQ3gyxNbRT2rjwE1CeU/lhdwiYHBQu2HPUWk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfN61nX+b367AISwCAV/eKzRHhv9wOtYcFBpY5x7AI1/YU3S/b91fQNPmEg4FZGO6tCWWhLkeANItKdUwxtjfE2Xw9q8+k292R6BDYVhjO4WexTq1sprU2qarvGAdlQkJjpXUP5fcGdTfoQQWZM/Mo+afUhAf18nBlezPM2vAac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDAhFm7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDAhFm7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8515D1F00A3D
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450211;
	bh=S6b2yNrI4Zd61DPZzKg81IDJyw1c+4+ip/BkNFK687U=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=jDAhFm7aHvOqejYp4qjZRPWnR8WLFtmky8nzehtC90qepkzZ3rTa+grrwl7mJA8kd
	 Gmp88APv5RXsD4RfyKPClMP8F87sd2PEcEwtiBFllLi866j2Xgt5KbIT2tg1MvPq07
	 k8+pT3SHnenLT8x/LvUj+FAYx/o04diZ40iZFD77nSBFEu1bAMJ+u800VjQ+mEIpdj
	 FYbf2uB3SevE2j8LSinudVbv+66piSqKGcyLXqM87L218VFeqdQr7ddSwDu3UT++oC
	 tzDHLT0UzFPQIkpZQI2dZnLXZnOBbRERMlOQXaXQjVKa5b0Ioo/ToHK713AcNRccnm
	 s+Fp+W2B9WB6Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
Date: Thu,  3 Sep 2026 16:43:06 +0100
Message-ID: <51cfd2533bd6cc9711981c1650b6ab6b268ab4bf.1788449622.git.fdmanana@suse.com>
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

