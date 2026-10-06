Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99813921DB;
	Tue,  6 Oct 2026 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791322729; cv=none; b=VuywxvNYNc/3Fydjby3yzc6g4x2NbWuQhTCd+GZlzYASVgmDh9RAhyTnjJ8Ld70n3bz6X/nAhDHIOyt8JLyRsl4gopZocpvbfbho6xHnDT/C5/nwrf1CLuSM8oP+9jmrryE/q/Uagwu7W/yxN2PIoAUn8I406Jwie5oKF095iFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791322729; c=relaxed/simple;
	bh=sLVYMQ3a+JCcJqtqkuSzgc7Dv/99jDYczIj2qFb2Bws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc9o4DL+ha3nhaMMNfATlQoWvSOxaDo7PIvgtQR3TZBXEzdVNV/c/Sg6ZWP2GyNbh6wmBIULZnThGdhGs+Nooizd28u2xvLHQBffSCQDr0oWNl4EOgt7wtCawn9XDIxdJ5DvYRosc9zuDsxbhigYhTO1t7hQACJFKNA5M/UPtcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajaPjFq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajaPjFq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403411F0089C;
	Tue,  6 Oct 2026 21:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791322727;
	bh=u5jL38FIPqgUMtJ7q9hBSTn4S/uCbRxrlnTcbfQynSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajaPjFq47zfK7YPEwdT08LmMkmO2GXcWy+oQMxHcW4lLQ47SW12FpHewvCQFzqZSD
	 vp1Jc/D+8Q41yPur3bd2TyMHIi/I80VNnISzbIAOcbkDMam1nqQDEEbAR7kFW1HusB
	 meezoXUNIzMghkTwaFc1WE4v2pOZLdVWoeywUs/jVgFFLukYclXh1vMQALpbFRSamV
	 6so2HpqTs7CKX0SI+KMAGWvHtcDMwCYcmQ7evr/a4p6DElxl4Si+ft9/AUPrsXjsAS
	 f4GSTHqYiTbjPJvKPv3alyb0XltRbqamJ27N/u7SKqig6hL5iB2qoPU6flMWzrlZfa
	 Nmemc0ar9Ze6Q==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: fsverity@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 1/2] fs,fsverity: reject size changes on fsverity files in setattr_prepare
Date: Tue,  6 Oct 2026 23:38:14 +0200
Message-ID: <20261006213815.47194-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261006213815.47194-1-ebiggers@kernel.org>
References: <20261006213815.47194-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit e9734653c523c744f03333ece6ae7a315187f05c upstream.

Add the check to reject truncates of fsverity files directly to
setattr_prepare instead of requiring the file system to handle it.
Besides removing boilerplate code, this also fixes the complete lack of
such check in btrfs.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://lore.kernel.org/r/20260128152630.627409-2-hch@lst.de
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/attr.c                | 12 +++++++++++-
 fs/ext4/inode.c          |  4 ----
 fs/f2fs/file.c           |  4 ----
 fs/verity/open.c         |  8 --------
 include/linux/fsverity.h | 25 -------------------------
 5 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index a8ae5f6d9b16..c2302fc4b333 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -173,7 +173,17 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
 	 * ATTR_FORCE.
 	 */
 	if (ia_valid & ATTR_SIZE) {
-		int error = inode_newsize_ok(inode, attr->ia_size);
+		int error;
+
+		/*
+		 * Verity files are immutable, so deny truncates.  This isn't
+		 * covered by the open-time check because sys_truncate() takes a
+		 * path, not an open file.
+		 */
+		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
+			return -EPERM;
+
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dea6d27e5028..9ff2958509ed 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5484,10 +5484,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (error)
 		return error;
 
-	error = fsverity_prepare_setattr(dentry, attr);
-	if (error)
-		return error;
-
 	if (is_quota_modification(idmap, inode, attr)) {
 		error = dquot_initialize(inode);
 		if (error)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7125117b6322..c1cd6dadabfe 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1065,10 +1065,6 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (err)
 		return err;
 
-	err = fsverity_prepare_setattr(dentry, attr);
-	if (err)
-		return err;
-
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 6c31a871b84b..5342a8e1f781 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -393,14 +393,6 @@ int __fsverity_file_open(struct inode *inode, struct file *filp)
 }
 EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
-int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
-{
-	if (attr->ia_valid & ATTR_SIZE)
-		return -EPERM;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__fsverity_prepare_setattr);
-
 void __fsverity_cleanup_inode(struct inode *inode)
 {
 	fsverity_free_info(inode->i_verity_info);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 1eb7eae580be..139a6f5c6217 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -149,7 +149,6 @@ int fsverity_get_digest(struct inode *inode,
 /* open.c */
 
 int __fsverity_file_open(struct inode *inode, struct file *filp);
-int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void __fsverity_cleanup_inode(struct inode *inode);
 
 /**
@@ -214,12 +213,6 @@ static inline int __fsverity_file_open(struct inode *inode, struct file *filp)
 	return -EOPNOTSUPP;
 }
 
-static inline int __fsverity_prepare_setattr(struct dentry *dentry,
-					     struct iattr *attr)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline void fsverity_cleanup_inode(struct inode *inode)
 {
 }
@@ -301,22 +294,4 @@ static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/**
- * fsverity_prepare_setattr() - prepare to change a verity inode's attributes
- * @dentry: dentry through which the inode is being changed
- * @attr: attributes to change
- *
- * Verity files are immutable, so deny truncates.  This isn't covered by the
- * open-time check because sys_truncate() takes a path, not a file descriptor.
- *
- * Return: 0 on success, -errno on failure
- */
-static inline int fsverity_prepare_setattr(struct dentry *dentry,
-					   struct iattr *attr)
-{
-	if (IS_VERITY(d_inode(dentry)))
-		return __fsverity_prepare_setattr(dentry, attr);
-	return 0;
-}
-
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.56.0

