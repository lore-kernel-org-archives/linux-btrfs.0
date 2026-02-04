Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75458421EEE
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770220336; cv=none; b=Mtr8uGRTcxSqjPnRLzntj5ClYrEC3HgIz9DI7i2bdjY+O2/445QkFOeMSbXolRcScBrwY8RWQd2pI9o5pkfElCV0I6XXBI197SQeLdNYcWloee/pnEMrtozATYRpM65ZYztVvce6n1vQfaol9wj7z6aKvmTHL5KQhLcfwMlLYOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770220336; c=relaxed/simple;
	bh=pTe3jMwy5kE0hc1683N0I75wu2P5WbLOs7dYyuPXh04=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uig9/FPn/MjUudXYqNB3XRznMzBdjx3f1A2dxs1hbRudPgaReT8YK/XS6wU8TM0/ZRYgDKoLRNR0Pfxzkld72GzHW/TbkduqUdYAwrncG3C5KtJUuKNa5mERMGk6OYbtyVNvTxVdr+uRrGLTEf9E1ToDHWW5MJB+IC6FGDtpnio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sr4wCgO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sr4wCgO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9479C116C6
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770220336;
	bh=pTe3jMwy5kE0hc1683N0I75wu2P5WbLOs7dYyuPXh04=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sr4wCgO5vttxowCixvaMYMfQJpqno33Ud/3132babmIVeJCDy1cufIgJTuJMxCpmq
	 7vfIRFEpqUYjJntHx7ibLR8DVF+YQ0U9ZVca8vc/S790FflHYaL4dUDN95epBUWG7P
	 6f+o3Fc4448SD8URble1WTjFLcckC14EZzT8nEUgBLqhkeJHGgxsTMEK10aF2urHXp
	 s1MRH0hb8QvoSVgfK9EWubz+sfJPKtbZ1plDH7VUcSGxpL/tYj8ADvcbwW88y3iupZ
	 A6ZYLxQCY02B/81Pdr+z5BZ+i6q6uqLo0ZyVDbo6Cg4cc2tSw2fh2/fOYIKrfIaj74
	 TlvgOynU2Tvag==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/7] btrfs: pass transaction handle to write_all_supers()
Date: Wed,  4 Feb 2026 15:52:00 +0000
Message-ID: <a8b87224639b596f080adb56b6a0ccf55ed4ed5d.1770212626.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1770212626.git.fdmanana@suse.com>
References: <cover.1770212626.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are holding a transaction In every context we call write_all_supers(),
so pass the transaction handle instead of fs_info to it. This will allow
us to abort the transaction in write_all_supers() instead of calling
btrfs_handle_fs_error() in a later patch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c     | 3 ++-
 fs/btrfs/disk-io.h     | 2 +-
 fs/btrfs/transaction.c | 2 +-
 fs/btrfs/tree-log.c    | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b9eb38072191..6454cbbcaa88 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4019,8 +4019,9 @@ int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
 	return min_tolerated;
 }
 
-int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
+int write_all_supers(struct btrfs_trans_handle *trans, int max_mirrors)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct list_head *head;
 	struct btrfs_device *dev;
 	struct btrfs_super_block *sb;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 5320da83d0cf..081a6860861c 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -58,7 +58,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info);
 int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 			 const struct btrfs_super_block *sb, int mirror_num);
 int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount);
-int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
+int write_all_supers(struct btrfs_trans_handle *trans, int max_mirrors);
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 					const struct btrfs_key *key);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 463238ca8a4d..08f691661874 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2557,7 +2557,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
-	ret = write_all_supers(fs_info, 0);
+	ret = write_all_supers(trans, 0);
 	/*
 	 * the super is written, we can safely allow the tree-loggers
 	 * to go about their business
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e1bd03ebfd98..ed5704e0a92c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3569,7 +3569,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_start);
 	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_root_level);
-	ret = write_all_supers(fs_info, 1);
+	ret = write_all_supers(trans, 1);
 	mutex_unlock(&fs_info->tree_log_mutex);
 	if (unlikely(ret)) {
 		btrfs_set_log_full_commit(trans);
-- 
2.47.2

