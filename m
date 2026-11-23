Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432957;
	b=q0eCjwv1yEWmmsHTvioSGGvS3n/EdK8rf0Gs8ACm4mTSIgMgAJ1gnMQKAWYleNRh0vF+
	 dDTwZ2WCDJbc8YhPM7YxkIOsU+4trOKWduji0WUSgbLsGN5L6/MpKvHCqlBIN2UqYLGCN
	 M5p7pnZKX+10em0FAMIYQG3N3yqvocys4oENW3oRq7CxlMLXN/FZz4auu5dZmte6YPsM8
	 r02BfXszPmlL4pRlj1fAQUAbxx8zzojQNnawvje2S2N8l7ogNFbHujJLtYORKtjtQJiD2
	 wgLQs+zWWDPc2DqGxC7EJQftKL/coUheRc6WrTLh0fIEiQRPetmNLcEfc3IBVs/jh2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432957;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L1Y2g0RFrQlTXhwIcFLP7FwdMndcFzlRuBVCkXrVXk8=;
	b=teNOFYsXPqT+Vn7TWqQa78w9loBBv1LeV6lNZrLWdTE0OVGM1x9c4RCH8yfJhPcsH9/S
	 HktjLg+zVUFbE050VLavyiRmaetksplpPB9AHfgzjRsTUUePEIAsvIaYYjrJsnwRJJHK8
	 3mY/PXg4MeS6+T204Dj4rx2Q+aDRjTQSx5hEZhE5nRk1NKTqhegbE2UjSMkLKpJvPbH6B
	 5bKZ16TQGyEpNF3MJwYwK51Olknx28XGjfjKW/hy7L39wuHdJLI5Juq92V59L3AYvjK5s
	 /EEPGlgQGszQMHfruul+V7kRNCDy11d/mggz1p0LgbI8IVp/M2rk+BOAN8K4tGNRnbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iENhzqZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E6606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iENhzqZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230491F000D1
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432956;
	bh=L1Y2g0RFrQlTXhwIcFLP7FwdMndcFzlRuBVCkXrVXk8=;
	h=From:To:Subject:Date;
	b=iENhzqZjv2RDZCUwu1Wt88PWjLaB4c0NntynjdiQ81ot/Nbx2XR3fzxmDk6fQgVM3
	 +wSsiSj1B4AvSDXfX15+kU8GZS24dhJUK+w8oxS8yVrYpqC54SG2vUHr9c+nxa7b3Q
	 9CYbalYphpT64jmDKHieJl3GgK2tWVoGLhPuDE2U6hbhdI+UpRfSDGQ8a5A+XRM/+x
	 wV98wCcbE5uEypMJ9qtBsorenvTmr4GNgaHOyDmiJAkVLgN0QRY96RC4b34MIIyAiz
	 QN4+G4QFygLN4g2Ee/MoIfbmi27VsfIQlPy+6icBIGFc362uehR6ptNmVlQWZu/R4d
	 yNR1veaIr3vZQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix race between setting attributes and writeback with compress attempt
Date: Mon, 23 Nov 2026 11:22:32 +0000
Message-ID: <1a3e3bed8b8bb64943745a02167b68c3f41d38e0.1795376976.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When setting attributes (FS_IOC_SETFLAGS ioctl) we grab the inode's flags
into a local variable, make changes to the flags in the local variable and
then later assing the variable to the inode's flags member. This is all
done without any locking and therefore can race with a writeback that
attempts to compress data but falls back to uncompressed write since the
data is found incompressible, in which cases it sets the flag
BTRFS_INODE_NOCOMPRESS in the inode, also without any locking - this
happens in compress_file_range() under the 'mark_incompressible' label.
This leaves a time window where one task undoes what the other did:

  CPU 0 (ioctl)                   CPU 1 (Writeback)
  -------------                   -----------------
  btrfs_fileattr_set()
    inode_flags = inode->flags;
                                  compress_file_range()
                                    inode->flags |= BTRFS_INODE_NOCOMPRESS;
    inode->flags = inode_flags;

Fix this by doing the updates while under the protection of the inode's
spinlock.

Link: https://sashiko.dev/#/bug/linux-249f973b-6e85-4fe0-80d5-5b42e7be3e22
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c |  5 +++-
 fs/btrfs/ioctl.c | 60 ++++++++++++++++++++++++++----------------------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40dd87276cc9..e81622595f93 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -976,8 +976,11 @@ static void compress_file_range(struct btrfs_work *work)
 	return;
 
 mark_incompressible:
-	if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) && !inode->prop_compress)
+	if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) && !inode->prop_compress) {
+		spin_lock(&inode->lock);
 		inode->flags |= BTRFS_INODE_NOCOMPRESS;
+		spin_unlock(&inode->lock);
+	}
 cleanup_and_bail_uncompressed:
 	ret = add_async_extent(async_chunk, start, end - start + 1, NULL);
 	BUG_ON(ret);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4271f7a6d48a..d10b43d3a001 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -289,6 +289,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	int ret;
 	const char *comp = NULL;
 	u32 inode_flags;
+	bool need_set_prop = false;
 	bool prop_set = false;
 
 	if (btrfs_root_readonly(root))
@@ -307,6 +308,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	if (ret)
 		return ret;
 
+	spin_lock(&inode->lock);
 	inode_flags = inode->flags;
 	if (fsflags & FS_SYNC_FL)
 		inode_flags |= BTRFS_INODE_SYNC;
@@ -330,13 +332,8 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 		inode_flags &= ~BTRFS_INODE_NOATIME;
 
 	/* If coming from FS_IOC_FSSETXATTR then skip unconverted flags */
-	if (!fa->flags_valid) {
-		/* 1 item for the inode */
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+	if (!fa->flags_valid)
 		goto update_flags;
-	}
 
 	if (fsflags & FS_DIRSYNC_FL)
 		inode_flags |= BTRFS_INODE_DIRSYNC;
@@ -380,13 +377,8 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	 * flags and the compression property if FS_COMPR_FL or FS_NOCOMP_FL
 	 * changes.
 	 */
-	if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL))) {
-		/* 1 item for the inode */
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+	if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL)))
 		goto update_flags;
-	}
 
 	/*
 	 * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
@@ -399,8 +391,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	} else if (fsflags & FS_COMPR_FL) {
 		enum btrfs_compression_type comp_type;
 
-		if (IS_SWAPFILE(&inode->vfs_inode))
+		if (IS_SWAPFILE(&inode->vfs_inode)) {
+			spin_unlock(&inode->lock);
 			return -ETXTBSY;
+		}
 
 		inode_flags |= BTRFS_INODE_COMPRESS;
 		inode_flags &= ~BTRFS_INODE_NOCOMPRESS;
@@ -426,30 +420,40 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 		inode_flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
+	need_set_prop = true;
+
+update_flags:
+	inode->flags = inode_flags;
+	spin_unlock(&inode->lock);
+
 	/*
 	 * 1 for inode item
 	 * 1 for property
 	 */
-	trans = btrfs_start_transaction(root, 2);
+	trans = btrfs_start_transaction(root, need_set_prop ? 2 : 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	if (comp) {
-		ret = btrfs_set_prop(trans, inode, "btrfs.compression",
-				     comp, strlen(comp), 0);
-		if (ret)
-			goto out_end_trans;
-		prop_set = true;
-	} else {
-		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL, 0, 0);
-		prop_set = (ret == 0);
-		/* If ret == -ENODATA ignore and proceed to update inode item. */
-		if (ret && ret != -ENODATA)
-			goto out_end_trans;
+	if (need_set_prop) {
+		if (comp) {
+			ret = btrfs_set_prop(trans, inode, "btrfs.compression",
+					     comp, strlen(comp), 0);
+			if (ret)
+				goto out_end_trans;
+			prop_set = true;
+		} else {
+			ret = btrfs_set_prop(trans, inode, "btrfs.compression",
+					     NULL, 0, 0);
+			prop_set = (ret == 0);
+			/*
+			 * If ret == -ENODATA ignore and proceed to update inode
+			 * item.
+			 */
+			if (ret && ret != -ENODATA)
+				goto out_end_trans;
+		}
 	}
 
-update_flags:
-	inode->flags = inode_flags;
 	btrfs_update_inode_mapping_flags(inode);
 	btrfs_sync_inode_flags_to_i_flags(inode);
 	inode_inc_iversion(&inode->vfs_inode);
-- 
2.53.0

