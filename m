Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC2F32F757
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773776833; cv=none; b=Ul7tsBv6OqUQhHDWfqVpFeZvOqQSQMNufHO/fNPwosrtkko+nHa85BBPngTorTmV5YPaRglqBz9YtfdHcdpVevqAzdfvVtpQa4cDhKNPggBJ8Gcg2ZtUCJjHTTHT5pwbNoA4RCURWYQ+r++LeGeCdPgz27tuMMvlGSFYvL8koDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773776833; c=relaxed/simple;
	bh=sIqB7QKvlIJv7719kn8nAb9tZs5paCtle+qDZlnLwsk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+rNO50BPpkHFDqBW3wIrh0LvsX8eJUfExDJiPHeLysw+v5SSVMqZaEN+uqEWsu7h+sxw+t77FC3HBi0kAJcSvFig7F0e+erbQvoY2B7LytbQhndtLNG0xJJzhKmtOIa7X+Y+SkRKuvpRHQa5duLKSc0TaFcmYXVlNdplq4anaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqcOe++s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqcOe++s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A98C4CEF7
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773776833;
	bh=sIqB7QKvlIJv7719kn8nAb9tZs5paCtle+qDZlnLwsk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sqcOe++seUz8DMuCDSg3F2jTZnxqgWwNK8q+Rni/GcBy3OBF0IN2pfYrsKVqoP7VX
	 8Zcc9BpyE0iOwxxs6mmZma2bLmeAYxEnYXLHll5Cp9f0saRDa4ISAPlq36F46Rmkg2
	 9RNdh9bOwS1/GW0ISnl5bbm/CPrpCPfuALy8HIsz24H7y1pe1u2XKPnnz4jIMYvmad
	 JuY5OvEz52Qk6tf6ddPnLblZ/IRP6ohpWpc0fgNbLf3NF0QH/fEMcHgQWAnFXZ7xEn
	 arrXsemPoVqd7vwaiyIWwAM1VjI4ZWMqNl5jm0hEGeDfIx1a2cpWhV+gqq52iAnqJN
	 cq6vxp3gWvz6Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: unexport btrfs_qgroup_reserve_meta()
Date: Tue, 17 Mar 2026 19:47:03 +0000
Message-ID: <de05b20a2b71e313beab28cc6fc07caa10556666.1773776356.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773776354.git.fdmanana@suse.com>
References: <cover.1773776354.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's only one caller outside qgroup.c of btrfs_qgroup_reserve_meta()
and we have btrfs_qgroup_reserve_meta_prealloc() is a wrapper around
that function. Make that caller use btrfs_qgroup_reserve_meta_prealloc()
and unexport btrfs_qgroup_reserve_meta(), simplifying the external API.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/delayed-inode.c | 3 +--
 fs/btrfs/qgroup.c        | 4 ++--
 fs/btrfs/qgroup.h        | 2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 56ff8afe9a22..09795439b9fb 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -596,8 +596,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
-		ret = btrfs_qgroup_reserve_meta(root, num_bytes,
-					  BTRFS_QGROUP_RSV_META_PREALLOC, true);
+		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true, true);
 		if (ret < 0)
 			return ret;
 		ret = btrfs_block_rsv_add(fs_info, dst_rsv, num_bytes,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 702338580601..0bf3ebc1ffb7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4489,8 +4489,8 @@ static int sub_root_meta_rsv(struct btrfs_root *root, int num_bytes,
 	return num_bytes;
 }
 
-int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-			      enum btrfs_qgroup_rsv_type type, bool enforce)
+static int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+				     enum btrfs_qgroup_rsv_type type, bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 1c568fc9544e..80dd2dacd56d 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -392,8 +392,6 @@ int btrfs_qgroup_release_data(struct btrfs_inode *inode, u64 start, u64 len, u64
 int btrfs_qgroup_free_data(struct btrfs_inode *inode,
 			   struct extent_changeset *reserved, u64 start,
 			   u64 len, u64 *freed);
-int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-			      enum btrfs_qgroup_rsv_type type, bool enforce);
 int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root, int num_bytes,
 				       bool enforce, bool noflush);
 /* Pre-allocated meta reservation can be freed at need */
-- 
2.47.2

