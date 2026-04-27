Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB5D308F1D
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 10:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285101; cv=none; b=uCxc4BQGprGagtnkyDept1pL5BGNuhrFAwmGoM1FkUfJyjHMym762rscbQlOfSXaHXG7qk0oq6JbInETstdF/SDKon9XP1ogOofNYhRyOfYfnNa68Utv5EPK8yA4t5BFcz2rwt4z3RBOIXEO4Pn39kL0JznBLxzq5QEFFBc3wu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285101; c=relaxed/simple;
	bh=y5eMbo5n5jiGI1RoTsWff0dMmyLPJ63/dFJTHRBvX/w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBeztRfu6jmP4/a/FwDLuvkyXsC7ndXY4oz9TWvIuMJVjs5VYCkVZe2ZKD9fEDWfZzF2hGsh9EOgWFgRAZlLp9LmfDIxallqp9SrpqMHOiePmchRPU/nzCJoFFPDwLJrKGZFkL7hOC9FtNlMK5ycnKnQeVnnAfgJ00mWqmoliL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bj12zV7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bj12zV7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050A8C19425
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 10:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285101;
	bh=y5eMbo5n5jiGI1RoTsWff0dMmyLPJ63/dFJTHRBvX/w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bj12zV7giZvx5TG91N2YbUbGdy79VlaWCptCQkZzSVRXvl3LoC6IJGG0UxZgV5RJp
	 FWlNus0oG2NIkG+2+PyyOBKLtwbRQFFnh+z0dnts+tjXKwo+9sXgByTcOkXJNI+P+0
	 vzoEedpYmwRtQIFCUV4x15qE2OCg6jd/yr/lraW9NKSpfES85u/3yA3G47LyOV9Han
	 El8PxbrnhM/kU+8g/sAtN0PsZr2VZ/xCiucKTPSRmVRj6eyoy1pqk5Hi1T+HI0TTpG
	 zHACLct1BYXcVg8y5lpNr80iY/iRCsFtnvNV95AXlJqRQ5/Q7QHo92xe6qD2wcaiKg
	 KfCVdeV9v2+Xg==
From: Anand Jain <asj@kernel.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: derive f_fsid from on-disk fsuuid and dev_t
Date: Mon, 27 Apr 2026 18:18:04 +0800
Message-ID: <1420378f88b69562c4c77fe72bc7286408d995d2.1777281686.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777281686.git.asj@kernel.org>
References: <cover.1777281686.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

f_fsid depends on fs_devices->fsid and subvol root id.

For cloned devices either same as the source or dynamical generated
at mount won't suite because tools like fanotify and ima depends on it.

Switch to a stable derivation using the persistent on-disk fsuuid +
root id + devt of the block device for the single device filesystem
when temp_fsid is active.
This is consistent as long as the device remains unchanged/replace
(excludes btrfs device replace secnario for now).

Signed-off-by: Anand Jain <asj@kernel.org>
---
 fs/btrfs/super.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a63ad6bd89f6..00eff951917c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1732,12 +1732,13 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 total_free_data = 0;
 	u64 total_free_meta = 0;
 	u32 bits = fs_info->sectorsize_bits;
-	__be32 *fsid = (__be32 *)fs_info->fs_devices->fsid;
+	__be32 *fsid;
 	unsigned factor = 1;
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
 	int mixed = 0;
+	__kernel_fsid_t f_fsid;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
 		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
@@ -1818,14 +1819,38 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bsize = fs_info->sectorsize;
 	buf->f_namelen = BTRFS_NAME_LEN;
 
-	/* We treat it as constant endianness (it doesn't matter _which_)
-	   because we want the fsid to come out the same whether mounted
-	   on a big-endian or little-endian host */
-	buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
-	buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
+	/*
+	 * fs_devices->fsid is dynamically generated when temp_fsid is active
+	 * to support cloned filesystems. Use the original on-disk fsid instead,
+	 * as it remains consistent across mount cycles.
+	 */
+	if (fs_info->fs_devices->temp_fsid)
+		fsid = (__be32 *)fs_info->super_copy->fsid;
+	else
+		fsid = (__be32 *)fs_info->fs_devices->fsid;
+
+	/*
+	 * We treat it as constant endianness (it doesn't matter _which_)
+	 * because we want the fsid to come out the same whether mounted
+	 * on a big-endian or little-endian host.
+	 */
+	f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
+	f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
+
 	/* Mask in the root object ID too, to disambiguate subvols */
-	buf->f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
-	buf->f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
+	f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
+	f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
+
+	/* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
+	if (fs_info->fs_devices->total_devices == 1) {
+		__kernel_fsid_t dev_fsid = \
+	u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));
+
+		f_fsid.val[0] ^= dev_fsid.val[1];
+		f_fsid.val[1] ^= dev_fsid.val[0];
+	}
+
+	memcpy(&buf->f_fsid, &f_fsid, sizeof(f_fsid));
 
 	return 0;
 }
-- 
2.43.0

