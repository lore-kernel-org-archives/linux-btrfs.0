Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365154F96A6
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783265; cv=none; b=OdlSP5D4aOUEM7ufNPYmegQPesXUu50JEccSEbHJ5GrN8qfLeZj16TIwZv3QTO2OM8/izBKbNHxicyYk+fAOovSUkKL/FUqOm46fHEJYEl7EmG6oFgNj9DsVnXprHTsIz//4/UcM+6upQTlTIEZnCkaczbJhQ9cgZyu6f6R6PQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783265; c=relaxed/simple;
	bh=+6zF/jsNLHDiCjdFL1Olih+D1oe8ZEzhryI8bZQO6E0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPFZS81IfkIQvkSebhJFiwwxFVmrgOGxOg1U5Rb+zf0LSmODpNhP5Z3JUDsIepMAEsOG7m7UxCq0SuAU5VtD3gPIV+qTsf5sFg7AjwG+D5Eki0bhByjVoITKsG5Z0hwLztn2kWC2ZZmokquaAlVLpCpthNHrl019PJRjPlAGJTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RswME6Hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RswME6Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F71F00899
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790783261;
	bh=lwuIYGgdzKAf2dasZCWq+DeY4dHqwevIxSXdJ/XTRVM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=RswME6Hj3w2D+Cahbieu8wwfvxvXaEA4i6SRDqegWjvKLO0e0sps1NIyCLT8fX1Ug
	 mN0jLq0CuVSVUY/ufWy9qB8arhhyeykgTVji2r0DKrLW5ScAMZ3HegfvOou/tEuMAz
	 bK/H//uEDLJvhWoUVF0no/NSTPIIHu7Wt7+aYhWd2OArAZXeEL1CEticirrZy+LZpx
	 mPbc1UFCVyulIX+N5UH/OtKkLu2nt4paQGZ/f7lRGgCrFDywDVnX9XDOWvRENaM7Ho
	 FwJ7slLze18KTfWDg2cz3HqfaNG+iXyDPk42SP5McHSLEQZATr1UuT4s+AO696X7D6
	 ir7LKijRH/6SQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: remove fs_info argument from btrfs_block_rsv_refill()
Date: Wed, 30 Sep 2026 16:47:35 +0100
Message-ID: <129231bd9d3e6c4a12b01a212a56b1d455ea04b5.1790783086.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790783086.git.fdmanana@suse.com>
References: <cover.1790783086.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The fs_info argument is not used, so remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-rsv.c  |  3 +--
 fs/btrfs/block-rsv.h  |  3 +--
 fs/btrfs/inode.c      |  4 ++--
 fs/btrfs/relocation.c | 11 ++++-------
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index ecbf66d6cc73..55e84ff0932e 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -238,8 +238,7 @@ int btrfs_block_rsv_check(struct btrfs_block_rsv *block_rsv, int min_percent)
 	return ret;
 }
 
-int btrfs_block_rsv_refill(struct btrfs_fs_info *fs_info,
-			   struct btrfs_block_rsv *block_rsv, u64 num_bytes,
+int btrfs_block_rsv_refill(struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			   enum btrfs_reserve_flush_enum flush)
 {
 	int ret = -ENOSPC;
diff --git a/fs/btrfs/block-rsv.h b/fs/btrfs/block-rsv.h
index 992272a01964..39b8928e1559 100644
--- a/fs/btrfs/block-rsv.h
+++ b/fs/btrfs/block-rsv.h
@@ -72,8 +72,7 @@ void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
 int btrfs_block_rsv_add(struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_check(struct btrfs_block_rsv *block_rsv, int min_percent);
-int btrfs_block_rsv_refill(struct btrfs_fs_info *fs_info,
-			   struct btrfs_block_rsv *block_rsv, u64 num_bytes,
+int btrfs_block_rsv_refill(struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			   enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 			    struct btrfs_block_rsv *dst_rsv, u64 num_bytes,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2a32072849cb..343b6402bb35 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5595,10 +5595,10 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 	 * if we fail to make this reservation we can re-try without the
 	 * delayed_refs_extra so we can make some forward progress.
 	 */
-	ret = btrfs_block_rsv_refill(fs_info, rsv, rsv->size + delayed_refs_extra,
+	ret = btrfs_block_rsv_refill(rsv, rsv->size + delayed_refs_extra,
 				     BTRFS_RESERVE_FLUSH_EVICT);
 	if (ret) {
-		ret = btrfs_block_rsv_refill(fs_info, rsv, rsv->size,
+		ret = btrfs_block_rsv_refill(rsv, rsv->size,
 					     BTRFS_RESERVE_FLUSH_EVICT);
 		if (ret) {
 			btrfs_warn(fs_info,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b7de08c7e9e2..65cb9dcf0aac 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1675,8 +1675,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	memset(&next_key, 0, sizeof(next_key));
 
 	while (1) {
-		ret = btrfs_block_rsv_refill(fs_info, rc->block_rsv,
-					     min_reserved,
+		ret = btrfs_block_rsv_refill(rc->block_rsv, min_reserved,
 					     BTRFS_RESERVE_FLUSH_LIMIT);
 		if (ret)
 			goto out;
@@ -2274,7 +2273,7 @@ static int refill_metadata_space(struct btrfs_trans_handle *trans,
 	 * If we get an enospc just kick back -EAGAIN so we know to drop the
 	 * transaction and try to refill when we can flush all the things.
 	 */
-	ret = btrfs_block_rsv_refill(fs_info, rc->block_rsv, num_bytes,
+	ret = btrfs_block_rsv_refill(rc->block_rsv, num_bytes,
 				     BTRFS_RESERVE_FLUSH_LIMIT);
 	if (ret) {
 		u64 tmp = fs_info->nodesize * RELOCATION_RESERVED_NODES;
@@ -3584,8 +3583,7 @@ int prepare_to_relocate(struct reloc_control *rc)
 	rc->reserved_bytes = 0;
 	rc->block_rsv->size = rc->extent_root->fs_info->nodesize *
 			      RELOCATION_RESERVED_NODES;
-	ret = btrfs_block_rsv_refill(rc->extent_root->fs_info,
-				     rc->block_rsv, rc->block_rsv->size,
+	ret = btrfs_block_rsv_refill(rc->block_rsv, rc->block_rsv->size,
 				     BTRFS_RESERVE_FLUSH_ALL);
 	if (ret)
 		return ret;
@@ -3637,8 +3635,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 
 	while (1) {
 		rc->reserved_bytes = 0;
-		ret = btrfs_block_rsv_refill(fs_info, rc->block_rsv,
-					     rc->block_rsv->size,
+		ret = btrfs_block_rsv_refill(rc->block_rsv, rc->block_rsv->size,
 					     BTRFS_RESERVE_FLUSH_ALL);
 		if (ret) {
 			err = ret;
-- 
2.47.2

