Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9013E3D5237
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263903; cv=none; b=SIAyZUbZrag8uAXJdgevYQqPiEVsTTuAKdQQ6UkpqWl1kkYMpbakwDe37MQ1iSpJ1FeSX3l8ZmfUiXRgn+RRbK2gHDXgL5SyafKjZgcX6uOEBdEoXxd/zuzLP4EXWyvGFaRb5BhODEl7lUX2BytbJMBtfOhGagDELidDZSWC+8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263903; c=relaxed/simple;
	bh=ACg4sO86UZKkSH7rJR8L356TbfbtR4wdJnyovKGYhcM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hse4HYyeu4RmFiGfMJwQEPuQEYdH5TSOoSOE7xW8bfu3rXi70xP8sUOZA8fbnFBSy7DVIPXuuMJa8jv1TVuat7tKKf5j2rIcBNSRzJJs/pHi0uVRc07ms/BfC0IoVCp7i/yqn3AVTkDYMokUleJNs8nggIvfisniCyXmw1GWU1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vQqWc5Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vQqWc5Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAE7C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263903;
	bh=ACg4sO86UZKkSH7rJR8L356TbfbtR4wdJnyovKGYhcM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vQqWc5Zi2pYrnS4Y3ZECxd39oDCSl6pIJHOfWp776gDabnHQnvUxPX61S1Zm6dJXl
	 jOdrfD9Lj0TqJifhStqcnP4ytpu1krJ3QayVBXB+7Nk1wu5zAZ+D+nd1WeX+0Em9+s
	 5c2EuY7+qYfASKJi+Sk6vO/8E8+K/rl4H/PiqJ50U/KiM8ieph7ULaeowgTElZp72D
	 FPcFDesOiU7MNTxnaW5fkS3r/eTIeJxGMLvPTZIoxG10VndFQHVOnyzB0OpeyiT90I
	 t+opVOYSD6JoO6I23by8xba12241OuaxTvqQ6CqQC2KX8iZnj3jTaoAWzvyXDNRYyK
	 spGRotPwdVHOA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs: remove unnecessary ctl argument from __btrfs_write_out_cache()
Date: Wed, 15 Apr 2026 15:38:11 +0100
Message-ID: <3b6afd9f4a23ff9f32767b95ba088951682d5d90.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776263553.git.fdmanana@suse.com>
References: <cover.1776263553.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We can get the free space control structure from the given block group,
so there is no need to pass it as an argument.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b595ed793bda..bc39551ec6d5 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1367,10 +1367,10 @@ int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
  * or an errno if it was not.
  */
 static int __btrfs_write_out_cache(struct inode *inode,
-				   struct btrfs_free_space_ctl *ctl,
 				   struct btrfs_block_group *block_group,
 				   struct btrfs_trans_handle *trans)
 {
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_io_ctl *io_ctl = &block_group->io_ctl;
 	struct extent_state *cached_state = NULL;
 	LIST_HEAD(bitmap_list);
@@ -1516,7 +1516,6 @@ int btrfs_write_out_cache(struct btrfs_trans_handle *trans,
 			  struct btrfs_path *path)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct inode *inode;
 	int ret = 0;
 
@@ -1531,7 +1530,7 @@ int btrfs_write_out_cache(struct btrfs_trans_handle *trans,
 	if (IS_ERR(inode))
 		return 0;
 
-	ret = __btrfs_write_out_cache(inode, ctl, block_group, trans);
+	ret = __btrfs_write_out_cache(inode, block_group, trans);
 	if (ret) {
 		btrfs_debug(fs_info,
 	  "failed to write free space cache for block group %llu error %d",
-- 
2.47.2

