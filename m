Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909277;
	b=XCQQUpUXvrRJG9dWCnwAlI8LljRz7c8ZHlu9z4iZfSIHz/jBNGeg8mXVmxEvlyPMKD2f
	 eWlQAnAJGOBARHgIVPclQ2VaobErnBi0KBKMUnBcuL2SV67b635efcqtYX5mNKQIOROLe
	 uA9K2jocBFJ/qQxJQBjYMwlZC9FwtUt7SiHknuZ+AZ+blTN6D3VDT332EErpX8N5G2p9P
	 G3JNTriHmmktPcrEvh22Qhonv68FuYeRi7J0yUmE8EcKwk8+Fdw7tQNzq4lvjCdGWjHFH
	 mH0KA5/RofslF4arvEqreXrPwEipLy1coPmtYuVYMoRGksJtDdYMLy9HGglpKMV4GPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909277;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=CIYj7mr9kkZ33MgbZrq9VVFS0XbGsGUXAcD33wj52qM=;
	b=ss3x6FeppO74I54caS8Sxn1XwKuHUI9RJA6rWyPWz/zt7V3ly96qWZKm4BOgl7KTg5rO
	 yazIRuB2u3M2CHUjQA2aACmlJsxWhiUQnhj9/nxURJwm3lxlESphXk1S5UKxp/+jNeYS3
	 u8ZgDt2HX7cO1rIUV3hwk+qV4gAVx1YHUW9lc/6Yugy7qEsRDRcv88inQw7zjXddvgBGy
	 Wz0KHTtmWbvLhvMH2GqF5Z4RayBnNY8b8C5C/fFP29O65J8fEftahyesRDyKxX73/wYMt
	 g3y+/PH90GW4qMB6rbYi0pV2Nkf3uy9xFCu9I4QX/7Cwub2/zxqJoDbVyGzMadILVmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkfkFRDp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656BD6082BDD;
	Thu,  5 Nov 2026 20:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkfkFRDp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C371F008A4;
	Thu,  5 Nov 2026 20:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793909277;
	bh=CIYj7mr9kkZ33MgbZrq9VVFS0XbGsGUXAcD33wj52qM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BkfkFRDpouLa6J7C3wI4X7xrJx2Fc5K6YDWrUdKLW6oRWm69MOsRD4UIF/UMCaurs
	 21cvjUVcYi+duF0SLulAM4PtsTPIwk79D349eqSnAGAeAd+olgE+6D4blLBtAyPhSr
	 /t3xYaK+iHfQ4fRjZ3dfBz06AeouiEOLoROCe0k1TO2ggCeWqq/x6HZ6BItjQ93yei
	 JQxPcF9qCIueT6Lo69WI4BDIhvrjZbWXnop6+FUhYArKbGJieecoEeJ2pAweJnuPIl
	 x1ptUDmh5wHbTeAjGGidI0EAxAUTC+piGR+tfqWDxyTG4OStNqJBVeoggQyboOPcWv
	 FEERP7SgOykAw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 05 Nov 2026 15:07:44 -0500
Subject: [PATCH 3/4] btrfs: honor FMODE_NOCMTIME in fallocate
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-delegts-btrfs-v1-3-a42a2b93cdc2@kernel.org>
References: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
In-Reply-To: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chuck Lever <cel@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9295; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=YSlV+TtS6dmaUe4vdgugX6q2PQ2Qh7UqKXwk/Or7qnM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7OIaXI4d6UCHAUR76d7VmXMDOxZFPbgFb0rdV
 ZeWIVX4ESKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauziGgAKCRAADmhBGVaC
 FdgVD/oDfzGGxilbZXnnwSv4DLsujwziBfr6MbLVu4ERcC1l/WnoGqxTJ/G1zhpH0ggaRxAUiHY
 qYudxpwGALFyzrchWXgHyRUy0NJa0EkBS8XWKyIxhzn4ls5znIn7Ci75g+lcRDKzBZJdFQOAI1K
 Ci2t31za6xVYIjsVyXF/ZT5V36XSIdtNbRQpQdDh/RNBMMYSbP8zwORmSXY8OdbaQidpUhkx1ST
 KWYKPdwVK1WWclZrQ2c/I6fo7+YQy/25st9XDPVAn2V6NmbO4CGhp8FsoUmMQmR7Foq8SM+8snG
 64kJa7x5y1VaUOZttUoGTesKrw/tkAQuDM2s4TF7Nwh7L2CnCvpb0mwmSpm8gnfy7d3RTvVA0kz
 NqI6RjMzEQChJRfsXiaiijLt0tOdgSzlOcMYTPYH15TmyRLsDDuTZza+ki3vhVE4WgKvShDq9W0
 zj68bK6FP8auNDSmSNiYZJnD/TDWaqKACNHkUYDXMYB0jXQ4PaAKlX5yNlX181dWyxQ4pFBeQch
 H8UCQhftxrrudyyPNu2Bel++VpuZKseLyk4e8HozcKYIADko28TwWqvRRcTJdVLQAq6WWwjjJBt
 3U8uAC42yRKxnhlqDSsCymtHKrZCa9j3xV4+EBSccQ9gFBoDjIkrlMUiykq0eFFp7zuSlrWtlW3
 YxQGvA7kpq7Owig==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

btrfs_fallocate() calls file_modified(), which skips the c/mtime update
for FMODE_NOCMTIME files. But the helpers that btrfs_fallocate() calls
update the times anyway:

- btrfs_prealloc_file_range() sets ctime. Its
  insert_prealloc_file_extent() tells btrfs_replace_file_extents() to
  update c/mtime.
- btrfs_fallocate_update_isize() sets ctime.

btrfs_zero_range() also calls these helpers. nfsd sets FMODE_NOCMTIME
while a client holds delegated timestamps. Thus an ALLOCATE from the
holder advances the server's ctime, and the times that the holder
returns cannot move it back.

Pass an update_times flag from btrfs_fallocate() to these helpers. Set
the flag from btrfs_should_update_cmtime(). Relocation still updates the
times.

btrfs_fallocate_update_isize() never incremented i_version. When a size
extension stayed within existing preallocation, only the ctime update
changed the NFS change attribute. Increment i_version unconditionally
there, as btrfs_prealloc_file_range() does.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  3 ++-
 fs/btrfs/file.c        | 32 +++++++++++++++++++++-----------
 fs/btrfs/inode.c       | 12 +++++++-----
 fs/btrfs/relocation.c  |  2 +-
 4 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0782f917fccc..fbcf8ca05fb7 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -595,7 +595,8 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info);
 int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			      u64 start, u64 num_bytes, u64 min_size,
-			      loff_t actual_len, u64 *alloc_hint);
+			      loff_t actual_len, u64 *alloc_hint,
+			      bool update_times);
 int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_folio,
 			     u64 start, u64 end, struct writeback_control *wbc);
 void btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index eab20cc6e18e..6ff494846aea 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2836,7 +2836,8 @@ static int add_falloc_range(struct list_head *head, u64 start, u64 len)
 
 static int btrfs_fallocate_update_isize(struct inode *inode,
 					const u64 end,
-					const int mode)
+					const int mode,
+					bool update_times)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -2860,7 +2861,9 @@ static int btrfs_fallocate_update_isize(struct inode *inode,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	inode_set_ctime_current(inode);
+	inode_inc_iversion(inode);
+	if (update_times)
+		inode_set_ctime_current(inode);
 	i_size_write(inode, end);
 	btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode), 0);
 	ret = btrfs_update_inode(trans, BTRFS_I(inode));
@@ -2901,7 +2904,8 @@ static int btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
 static int btrfs_zero_range(struct inode *inode,
 			    loff_t offset,
 			    loff_t len,
-			    const int mode)
+			    const int mode,
+			    bool update_times)
 {
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct extent_map *em;
@@ -2942,7 +2946,7 @@ static int btrfs_zero_range(struct inode *inode,
 			 */
 			btrfs_free_extent_map(em);
 			ret = btrfs_fallocate_update_isize(inode, offset + len,
-							   mode);
+							   mode, update_times);
 			goto out;
 		}
 		/*
@@ -2968,7 +2972,7 @@ static int btrfs_zero_range(struct inode *inode,
 		if (em->flags & EXTENT_FLAG_PREALLOC) {
 			btrfs_free_extent_map(em);
 			ret = btrfs_fallocate_update_isize(inode, offset + len,
-							   mode);
+							   mode, update_times);
 			goto out;
 		}
 		if (len < sectorsize && em->disk_bytenr != EXTENT_MAP_HOLE) {
@@ -2978,7 +2982,8 @@ static int btrfs_zero_range(struct inode *inode,
 			if (!ret)
 				ret = btrfs_fallocate_update_isize(inode,
 								   offset + len,
-								   mode);
+								   mode,
+								   update_times);
 			return ret;
 		}
 		btrfs_free_extent_map(em);
@@ -3056,7 +3061,8 @@ static int btrfs_zero_range(struct inode *inode,
 		ret = btrfs_prealloc_file_range(inode, mode, alloc_start,
 						alloc_end - alloc_start,
 						fs_info->sectorsize,
-						offset + len, &alloc_hint);
+						offset + len, &alloc_hint,
+						update_times);
 		btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				    &cached_state);
 		/* btrfs_prealloc_file_range releases reserved space on error */
@@ -3065,7 +3071,8 @@ static int btrfs_zero_range(struct inode *inode,
 			goto out;
 		}
 	}
-	ret = btrfs_fallocate_update_isize(inode, offset + len, mode);
+	ret = btrfs_fallocate_update_isize(inode, offset + len, mode,
+					   update_times);
  out:
 	if (ret && space_reserved)
 		btrfs_free_reserved_data_space(BTRFS_I(inode), data_reserved,
@@ -3096,6 +3103,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	u64 qgroup_reserved = 0;
 	struct extent_map *em;
 	int blocksize = BTRFS_I(inode)->root->fs_info->sectorsize;
+	const bool update_times = btrfs_should_update_cmtime(file);
 	int ret;
 
 	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
@@ -3167,7 +3175,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 		goto out;
 
 	if (mode & FALLOC_FL_ZERO_RANGE) {
-		ret = btrfs_zero_range(inode, offset, len, mode);
+		ret = btrfs_zero_range(inode, offset, len, mode, update_times);
 		btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
 		return ret;
 	}
@@ -3232,7 +3240,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 			ret = btrfs_prealloc_file_range(inode, mode,
 					range->start,
 					range->len, blocksize,
-					offset + len, &alloc_hint);
+					offset + len, &alloc_hint,
+					update_times);
 			/*
 			 * btrfs_prealloc_file_range() releases space even
 			 * if it returns an error.
@@ -3260,7 +3269,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 	 * We didn't need to allocate any more space, but we still extended the
 	 * size of the file so we need to update i_size and the inode item.
 	 */
-	ret = btrfs_fallocate_update_isize(inode, actual_end, mode);
+	ret = btrfs_fallocate_update_isize(inode, actual_end, mode,
+					   update_times);
 out_unlock:
 	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 			    &cached_state);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a6ce83a94fe6..1a6bd5025274 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9100,7 +9100,7 @@ static int btrfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 static struct btrfs_trans_handle *insert_prealloc_file_extent(
 				       struct btrfs_inode *inode,
 				       struct btrfs_key *ins,
-				       u64 file_offset)
+				       u64 file_offset, bool update_times)
 {
 	struct btrfs_file_extent_item stack_fi;
 	struct btrfs_replace_extent_info extent_info;
@@ -9143,7 +9143,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 
 	ret = btrfs_replace_file_extents(inode, path, file_offset,
 				     file_offset + len - 1, &extent_info,
-				     true, &trans);
+				     update_times, &trans);
 	btrfs_free_path(path);
 	if (ret)
 		goto free_qgroup;
@@ -9165,7 +9165,8 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			      u64 start, u64 num_bytes, u64 min_size,
-			      loff_t actual_len, u64 *alloc_hint)
+			      loff_t actual_len, u64 *alloc_hint,
+			      bool update_times)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
 	struct btrfs_trans_handle *trans;
@@ -9206,7 +9207,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		last_alloc = ins.offset;
 		trans = insert_prealloc_file_extent(BTRFS_I(inode), &ins,
-						    cur_offset);
+						    cur_offset, update_times);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
@@ -9246,7 +9247,8 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 		*alloc_hint = ins.objectid + ins.offset;
 
 		inode_inc_iversion(inode);
-		inode_set_ctime_current(inode);
+		if (update_times)
+			inode_set_ctime_current(inode);
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    (actual_len > inode->i_size) &&
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b2ac5b836b21..9af207446848 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2834,7 +2834,7 @@ static noinline_for_stack int prealloc_file_extent_cluster(struct reloc_control
 		num_bytes = end + 1 - start;
 		ret = btrfs_prealloc_file_range(&inode->vfs_inode, 0, start,
 						num_bytes, num_bytes,
-						end + 1, &alloc_hint);
+						end + 1, &alloc_hint, true);
 		cur_offset = end + 1;
 		btrfs_unlock_extent(&inode->io_tree, start, end, &cached_state);
 		if (ret)

-- 
2.56.0

