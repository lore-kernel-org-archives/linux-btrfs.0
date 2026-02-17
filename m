Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9473EBF10
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771352851; cv=none; b=Yc2dlA2mnNsU5zcDybQw+kwHYjgNpGT8N3i+rxvMGfNQoC3JPDpaxHQQ+HBm+eT/d2jEvw+zqxo/GsfRiKMkW1AzVtTZbZ72wUfz82qbFV6eyGxvZfw4DMVMf7PBkCAM5WjPZDBp52v0AtC7VxIH1IruTke0051FoQCXPtG36ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771352851; c=relaxed/simple;
	bh=6X7s5YN3ZI8CfsuntZyAg4lwBXJlRyPzWS7NenQDcmY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRHrZY8ZSYLJZHc6Iz5y9CFROwoznPc+JW5dJisjRRq8fSfCz+kYQX++LxcH8iT2G0us1FgW6pb58pRarS8Cyz26Y6mwSNevIEWp2oX5IkIi23LUss2zHIeJpBHKCMsRV4LDbsJgJPuJR4+4wxofkwCUBsIDiJxQtbB/U41VBTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T79FTs2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T79FTs2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40E3C19421
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2026 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771352851;
	bh=6X7s5YN3ZI8CfsuntZyAg4lwBXJlRyPzWS7NenQDcmY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=T79FTs2PV3p5Z8+eSdFis9zfh+69VuOF+KZrOXGjV8aK9M8Iut7yGthcZsrdubpUK
	 D4WhEz612bp+LaeeNWUn59LH2nmKzi30xwsWxBHcZcMwhjB4YXoCkMgXa6VX19aCyR
	 eSm4XjyfgqHpoB0nyvbUCiP8MGHw+XF5zy0kwYL/x4pWBNv+WVFyvgo6sDgofplTIb
	 MLTnF6rFbabilzO0tgvH392+14YML5thMfPKUKPHyUQaUDXCXA6zBsZMsQon74dXn2
	 szeAcDYxH3z7Y536KtCZpjs2/YsBPj6KfCOpJV+WhEz8S3STkklJ3n6R5WpNVexTIK
	 T1r9Pb035+iEQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: pass a btrfs inode to tree-log.c:fill_inode_item()
Date: Tue, 17 Feb 2026 18:27:26 +0000
Message-ID: <131f3d1b331ce607010688d27e840e4db84e9d51.1771350720.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1771350720.git.fdmanana@suse.com>
References: <cover.1771350720.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

All internal functions should be given a btrfs_inode for consistency and
not a vfs inode. So pass a btrfs_inode instead of a vfs inode.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 48 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 504b2cb84857..6f75857b0196 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4613,10 +4613,11 @@ static int truncate_inode_items(struct btrfs_trans_handle *trans,
 static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct extent_buffer *leaf,
 			    struct btrfs_inode_item *item,
-			    struct inode *inode, bool log_inode_only,
+			    struct btrfs_inode *inode, bool log_inode_only,
 			    u64 logged_isize)
 {
-	u64 gen = BTRFS_I(inode)->generation;
+	struct inode *vfs_inode = &inode->vfs_inode;
+	u64 gen = inode->generation;
 	u64 flags;
 
 	if (log_inode_only) {
@@ -4631,33 +4632,33 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 		 * and one can set it to 0 since that only happens on eviction
 		 * and we are holding a ref on the inode.
 		 */
-		ASSERT(data_race(BTRFS_I(inode)->logged_trans) > 0);
-		if (data_race(BTRFS_I(inode)->logged_trans) < trans->transid)
+		ASSERT(data_race(inode->logged_trans) > 0);
+		if (data_race(inode->logged_trans) < trans->transid)
 			gen = 0;
 
 		btrfs_set_inode_size(leaf, item, logged_isize);
 	} else {
-		btrfs_set_inode_size(leaf, item, inode->i_size);
+		btrfs_set_inode_size(leaf, item, vfs_inode->i_size);
 	}
 
 	btrfs_set_inode_generation(leaf, item, gen);
 
-	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
-	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
-	btrfs_set_inode_mode(leaf, item, inode->i_mode);
-	btrfs_set_inode_nlink(leaf, item, inode->i_nlink);
+	btrfs_set_inode_uid(leaf, item, i_uid_read(vfs_inode));
+	btrfs_set_inode_gid(leaf, item, i_gid_read(vfs_inode));
+	btrfs_set_inode_mode(leaf, item, vfs_inode->i_mode);
+	btrfs_set_inode_nlink(leaf, item, vfs_inode->i_nlink);
 
-	btrfs_set_timespec_sec(leaf, &item->atime, inode_get_atime_sec(inode));
-	btrfs_set_timespec_nsec(leaf, &item->atime, inode_get_atime_nsec(inode));
+	btrfs_set_timespec_sec(leaf, &item->atime, inode_get_atime_sec(vfs_inode));
+	btrfs_set_timespec_nsec(leaf, &item->atime, inode_get_atime_nsec(vfs_inode));
 
-	btrfs_set_timespec_sec(leaf, &item->mtime, inode_get_mtime_sec(inode));
-	btrfs_set_timespec_nsec(leaf, &item->mtime, inode_get_mtime_nsec(inode));
+	btrfs_set_timespec_sec(leaf, &item->mtime, inode_get_mtime_sec(vfs_inode));
+	btrfs_set_timespec_nsec(leaf, &item->mtime, inode_get_mtime_nsec(vfs_inode));
 
-	btrfs_set_timespec_sec(leaf, &item->ctime, inode_get_ctime_sec(inode));
-	btrfs_set_timespec_nsec(leaf, &item->ctime, inode_get_ctime_nsec(inode));
+	btrfs_set_timespec_sec(leaf, &item->ctime, inode_get_ctime_sec(vfs_inode));
+	btrfs_set_timespec_nsec(leaf, &item->ctime, inode_get_ctime_nsec(vfs_inode));
 
-	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
-	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
+	btrfs_set_timespec_sec(leaf, &item->otime, inode->i_otime_sec);
+	btrfs_set_timespec_nsec(leaf, &item->otime, inode->i_otime_nsec);
 
 	/*
 	 * We do not need to set the nbytes field, in fact during a fast fsync
@@ -4668,11 +4669,10 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	 * inode item in subvolume tree as needed (see overwrite_item()).
 	 */
 
-	btrfs_set_inode_sequence(leaf, item, inode_peek_iversion(inode));
+	btrfs_set_inode_sequence(leaf, item, inode_peek_iversion(vfs_inode));
 	btrfs_set_inode_transid(leaf, item, trans->transid);
-	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
-	flags = btrfs_inode_combine_flags(BTRFS_I(inode)->flags,
-					  BTRFS_I(inode)->ro_flags);
+	btrfs_set_inode_rdev(leaf, item, vfs_inode->i_rdev);
+	flags = btrfs_inode_combine_flags(inode->flags, inode->ro_flags);
 	btrfs_set_inode_flags(leaf, item, flags);
 	btrfs_set_inode_block_group(leaf, item, 0);
 }
@@ -4719,8 +4719,7 @@ static int log_inode_item(struct btrfs_trans_handle *trans,
 		return ret;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_inode_item);
-	fill_inode_item(trans, path->nodes[0], inode_item, &inode->vfs_inode,
-			false, 0);
+	fill_inode_item(trans, path->nodes[0], inode_item, inode, false, 0);
 	btrfs_release_path(path);
 	return 0;
 }
@@ -4989,8 +4988,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			inode_item = btrfs_item_ptr(dst_path->nodes[0], dst_slot,
 						    struct btrfs_inode_item);
 			fill_inode_item(trans, dst_path->nodes[0], inode_item,
-					&inode->vfs_inode,
-					inode_only == LOG_INODE_EXISTS,
+					inode, inode_only == LOG_INODE_EXISTS,
 					logged_isize);
 		} else {
 			copy_extent_buffer(dst_path->nodes[0], src, dst_offset,
-- 
2.47.2

