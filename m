Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDCC4DD6E4
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864440; cv=none; b=gSD7EnbCEe48buXPHrRNroLSM2B3Yqw3n1MVXSOIcQt2tOYDuIIcszKxZ0SduDOd3iYgmMwpX3h0cFUaDIrIlm1MpMRUdYC8eSv8flp9ZFBp4k5VbsV0s02rEgIMPtXCSBM41bR8giCYThn5444yegZf7vrH+QWNnb7BmVt4UJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864440; c=relaxed/simple;
	bh=dpgyI/frrG/kEzxKVmDD5jyCchbaHNtG3BvqSVkd+ng=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P//cVnZmk4k49BbJp2dmcqxyX6FDDU1VZ5wgyvj+9UBYaoRgIBt36BktwT8MFbEaqczeGdYZUuAArA1L5Rll//lQrqbAaSXARw1Ad4U2SkXEORrYGfyCs9gAouZA1jGDX8XU5141H8x60s4Z+UsuoHB+F0cGJ4b78j4nKvytJm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhimSa4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhimSa4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B14AC2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864440;
	bh=dpgyI/frrG/kEzxKVmDD5jyCchbaHNtG3BvqSVkd+ng=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qhimSa4vTzVj3V0Aek26zgycqPwtQZ2p6PY/CxUAoCuXmx4Wqkpi1x/8WEPKMAwA0
	 Nr/WT1Q/uF/tOG3NwjW5/y/WFeth5aR0QzxnMCw/GYvYZx0CHRhjMf9+6Zb9pxTFJ2
	 Qeczx0TIVOhUap2Q4Mh1YuqAaNMYNTJzCa6R2ThKyzLUKwrMghICrpGMW7Trh7vi1e
	 gvK7oNxuVLNMT4n2oXGFL9hTP0Jw1hY9UZ42OA4KVeKuPlbm2fBcftvY98mAfGqDpW
	 hdiATeInNp/ZDavhYchit+mi56nv+onOU8SOcWRQEo3/D0j5QlwG8R99gNCU/79n0p
	 VIAdNAQXUapmw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/28] btrfs: remove redundant writeback error check during fsync
Date: Fri, 15 May 2026 18:00:08 +0100
Message-ID: <ebdfea00379d6cad89df73ac624fdc2393cede83.1778776707.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we can skip logging the inode during fsync, we check for writeback
errors in the inode's mapping by calling filemap_check_wb_err() and then
jump to the 'out_release_extents' label, which in turn jumps to the 'out'
label under which we check again for a writeback error by calling
file_check_and_advance_wb_err(). So the filemap_check_wb_err() ends up
being redundant. This happens since commit 333427a505be ("btrfs: minimal
conversion to errseq_t writeback error reporting on fsync").

Remove the filemap_check_wb_err() call.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 42914c9785e5..f77ccef837b9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1688,14 +1688,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		 * reason, it's no longer relevant.
 		 */
 		clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
-		/*
-		 * An ordered extent might have started before and completed
-		 * already with io errors, in which case the inode was not
-		 * updated and we end up here. So check the inode's mapping
-		 * for any errors that might have happened since we last
-		 * checked called fsync.
-		 */
-		ret = filemap_check_wb_err(inode->vfs_inode.i_mapping, file->f_wb_err);
 		goto out_release_extents;
 	}
 
@@ -1811,6 +1803,10 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	ASSERT(list_empty(&ctx.list));
 	ASSERT(list_empty(&ctx.conflict_inodes));
 	ASSERT(ret <= 0, "ret=%d", ret);
+	/*
+	 * Ordered extents might have started and completed before this fsync,
+	 * so check for any io errors and advance the writeback error sequence.
+	 */
 	err = file_check_and_advance_wb_err(file);
 	if (!ret)
 		ret = err;
-- 
2.47.2

