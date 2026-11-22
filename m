Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306158;
	b=GXyJpN+0zeqKz9aBxDEFtuGQ0GaxRYgO06XsFm96Gf9F91d/Gs+X/AlHZi0Auy3nqlGE
	 lREPtDHI9iy3O3ig7rSQJAeOiF3pGklXGtmraf457GJ2MtoO17Js74i2WBadYxPzSvgiM
	 3LVLZs3Nw+RhoXoT9SiWC7QcT035glaPjcSfMhDMlfxuX16fvAJtQU4YY8brNfLfRgWjs
	 kFsCmPzegmFMZ2zOnKh4dSyX4w3nK+gcy273YIPI+b3b8kyBpT54VKHkAIKWFHacpl88L
	 EQW3I7PJYQrYr6YLPDjZL52sR8jSWb1wk7Su1SpPXoXTq18vIvlKpiGpwSATsGa84uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306158;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wuIfjVDdbbuTmvTelKExo9c7hp2tNniNJlVtcSgr9dU=;
	b=if0szyzrwcdBfy+I6v1UCqBRaxpnGmkPR5msjl9MnFBu6AahMpzHxAwW2mt82JvXOM9/
	 3zJ/ykSYNWl5yvT5DBhHvoHU1cO/3LyDE/prWFa2vIg2jo6VKldnq2X032NghOi88cFfq
	 5pMr6P4AsblN0uHZ3TYocmI9DKPrF+xJi3vYnsZ2sjAR40e9g2rwvjLlTWygCjtUuGsPJ
	 FytmWLtgRA4uPABr8bMxRUfMmQzo+MKo3Goy2xtOr0+k4gheinh4JXJxKDnsgPOX5JaZY
	 A3NodGG5TOePJioczyUBQyuj8ZR9Xsh253BpOVBzvW8raLnaIyqA9VLF8S8KrTfbmtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ke0adVzA;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28576606A68E
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 00:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28576606A68E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ke0adVzA
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso14726975e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 16:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795306156; x=1795910956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wuIfjVDdbbuTmvTelKExo9c7hp2tNniNJlVtcSgr9dU=;
        b=Ke0adVzAuvcuscMYT41cdy5mVczskCfO7lJKzRpJkOdHctJ5FDbm89v6qRmxzJVF5h
         DeGsqFGvjpica2rv9dyZ+oM7zqgcVJ++K2Iz+cY+n74i8xh1LQ5bQtO2oJOurMVHPxhM
         nwkdv1RRbGyw2hnumVO9XMfigirakAXkAIUqyV5FyWSfWUBm2Zx5PBcm518r3IXQBrUv
         wVvsDJ21IOoT7O10XpR2FAjg+rhdUe0RrGy07KYuaP8Ilv5kMRaxzlDqhsEQN67gLp8b
         dcH0oFIb3WOAofgckkGJGWychagXzR9r/m9jaG9lCjngrcD4JDT7xM+aHf8I7zCxN4iK
         E9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306156; x=1795910956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wuIfjVDdbbuTmvTelKExo9c7hp2tNniNJlVtcSgr9dU=;
        b=I2nan5lpxPElO+kv1OfJArSaVfh9FAh8Dp3/6/mUf/J6P31umwOuCMcEFY+PfflBvR
         Gq/7y674i3oj2BGU+pqLJGyZkpbnukhyYSllHu9DFL4t8Expbxz9g4LKwc32oyNK7NG+
         kkWZb1OAKS7VAw+p/c4roO/Tpq/oimizfztnFi6UXzpIjm7M4uSiDaRGKk7YIP2BTfup
         ZShpBNpB/Hhsu/UJ9gigTT3Y3KUygmj5qLLofMWJYakcC1XoXxaUJPJYx5HfabaxbVq2
         XmxezM4Q9L45VHdmaNpPVGh9pb5FPM8qgenPn61bJA/q3cGtcsNJtWSC50/XzndX1Xst
         bXsA==
X-Forwarded-Encrypted: i=1; AL+hErFXBv6GDWva2jD/NfBIR2jgF5MHv2iCTQ/25S6xDRXxBXPmyVSzsE4rOyaBkihUKGuVx1YiqImD5y9Now==@vger.kernel.org
X-Gm-Message-State: APuU4Z+AAInjQxw0HzGPrST9z9mRUiGZyulElFUxKTER2d4XY8FD1qXv
	tCyaQaOHDrz/tjoia4v5MSZAlyVOTkN7c0mQtxgQuaNxgQ2YrCOOa1nW
X-Gm-Gg: AZFdTZc0AdjTwB9Hz12H8kLOafW1kmAMKoYP76+xaXljJcgaEcJnsGjdBcFQ3jXZMo3
	U2CvLXgt20UbU8kZoUN7NJr0sZNLsboFUAFlyRVS4WgXbFcOsbf0PQuWKDpBtm9imBa95+M2SL5
	iF4ubN3+z8agqNOzksXVgP8rZwGlnuZ+eO9gYoo7BQTVwBYVvDR+QDiPHSN+oN1umJu781g7AIs
	EFGbus3/QFldZOMy1Ii5OUROx5QPLuCJQ8z9vD5h12iBt7u25E50dcABbV2aAguxzCZ6snHXNnV
	tJG3orvYdxH0t8V0YZwKM9xc6dFRCasDq/0cF9hi7jQgO/PYxvN2ohK9KGjYv69uHdhjfLnrGYH
	OlNWqEZR2QG+DTuQOfS4ugGVVyueac3drRi5BG6qx0TWyVZwdDSgXJTnncwHRcu529n5EYzb5Uj
	KoPgPpRTwOZ2LI54/Vt6ECEBrnv6VnmwUoFSrDh1/lHFW8Lug7bpDfvS4Vrgh0PfPxEKuSen1o5
	2G2j2UqCtCFGRGyjdUDGgxXWNoK/2p1UwejlZKiubLCNjq8iW2Ayh1LUBpF+7NrRbsEICZBbfVD
	XhxUUTCLR47BqOhkROSxgT0RVQ==
X-Received: by 2002:a05:600c:4f4c:b0:4bb:8503:69f4 with SMTP id 5b1f17b1804b1-4bb888097a2mr193491915e9.5.1795306156329;
        Sat, 21 Nov 2026 16:09:16 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm13461872f8f.0.2026.11.21.16.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:15 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 2/3] vfs: add xflags mask to fileattr API
Date: Sun, 22 Nov 2026 01:08:55 +0100
Message-ID: <20261122000856.536902-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261122000856.536902-1-koray.fra@gmail.com>
References: <20261122000856.536902-1-koray.fra@gmail.com>
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

Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr and
equivalent masks to struct file_kattr.

Also add has_masks selector to struct file_kattr so we can know when a
user of this API (userspace or filesystem) supports them.

This lets filesystems advertise their support for specific xflags, like
statx.stx_attributes_mask does, and userspace can specify only which
xflags it wants to change without needing a RMW cycle:
- on GET: each filesystem that wants to support this new API fills the
  masks according to its supported and read-only xflags, then:
  * for boolean xflags: it fills fsx_xflags with the current on-disk value
  * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
    xflag value in the struct field;
- on SET: userspace fills the rw_mask with the bits of the xflags it
  wants to change, then:
  * for boolean xflags: it provides the xflag value as a bit in fa_xflags
  * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
    provides the value in the struct field; if the xflag bit is set to 0
    instead, this informs the kernel to unset/clear that value.

Since fa_xflags_rw_mask means "I want to change the xflags specified in
here", if userspace specifies fa_xflags_rw_mask = 0, only check for
permissions and fileattr support without checking any xflags.

Behaviour of older programs that already use file_[gs]etattr() is
preserved by checking against FILE_ATTR_SIZE_VER*.

Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
the projid using file_[gs]etattr() by leveraging the new masks.

Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accepting
FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
and use it to validate/clamp both the _xflags fields and the masks.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c           | 128 ++++++++++++++++++++++++++++++++++++---
 include/linux/fileattr.h |   7 +++
 include/uapi/linux/fs.h  |   7 ++-
 3 files changed, 131 insertions(+), 11 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 40d6518f1d8e..0e16c23368b2 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -102,13 +102,20 @@ EXPORT_SYMBOL(vfs_fileattr_get);
 static void fileattr_to_file_attr(const struct file_kattr *fa,
 				  struct file_attr *fattr)
 {
-	__u32 mask = FS_XFLAGS_MASK;
-
 	memset(fattr, 0, sizeof(struct file_attr));
-	fattr->fa_xflags = fa->fsx_xflags & mask;
+	/* Pass the masks to userspace if underlying fs uses them. */
+	if (fa->has_masks) {
+		fattr->fa_xflags_rw_mask = fa->fsx_xflags_rw_mask &
+					   FS_FILE_ATTR_XFLAGS_MASK;
+		fattr->fa_xflags_ro_mask = fa->fsx_xflags_ro_mask &
+					   FS_FILE_ATTR_XFLAGS_MASK;
+	}
+	fattr->fa_xflags = fa->fsx_xflags & FS_FILE_ATTR_XFLAGS_MASK;
 	fattr->fa_extsize = fa->fsx_extsize;
 	fattr->fa_nextents = fa->fsx_nextents;
 	fattr->fa_projid = fa->fsx_projid;
+	if (fa->fsx_projid)
+		fattr->fa_xflags |= FS_XFLAG_PROJID;
 	fattr->fa_cowextsize = fa->fsx_cowextsize;
 }
 
@@ -141,12 +148,30 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
 static int file_attr_to_fileattr(const struct file_attr *fattr,
 				 struct file_kattr *fa)
 {
-	__u64 mask = FS_XFLAGS_MASK;
+	u64 rw_mask = fa->has_masks ? fattr->fa_xflags_rw_mask : FS_XFLAGS_MASK;
 
-	if (fattr->fa_xflags & ~mask)
+	/*
+	 * No need to check for has_masks here, as fa_xflags_rw_mask is 0 in
+	 * VER0 mode.
+	 */
+	if (fattr->fa_xflags_rw_mask & ~FS_FILE_ATTR_XFLAGS_MASK)
 		return -EINVAL;
 
-	fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK);
+	if (fattr->fa_xflags & ~rw_mask)
+		return -EINVAL;
+
+	/*
+	 * Filter with ~FS_XFLAG_RDONLY_MASK only when in VER0 mode, so
+	 * filtering with the actual filesystem read-only xflags can be done in
+	 * vfs_fileattr_set() once we have the fsx_xflags_ro_mask from the fs.
+	 */
+	if (fa->has_masks) {
+		fileattr_fill_xflags(fa, fattr->fa_xflags);
+		fa->fsx_xflags_rw_mask = fattr->fa_xflags_rw_mask;
+	} else {
+		fileattr_fill_xflags(fa,
+				     fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK);
+	}
 	fa->fsx_extsize = fattr->fa_extsize;
 	fa->fsx_projid = fattr->fa_projid;
 	fa->fsx_cowextsize = fattr->fa_cowextsize;
@@ -187,6 +212,14 @@ static int fileattr_set_prepare(struct inode *inode,
 {
 	int err;
 
+	/*
+	 * If the fs supports the fsx_xflags_{rw,ro}_mask API, fail when the
+	 * requested rw flags are not in the supported ones for that fs
+	 */
+	if (old_ma->has_masks &&
+	    (fa->fsx_xflags_rw_mask & ~old_ma->fsx_xflags_rw_mask))
+		return -EOPNOTSUPP;
+
 	/*
 	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
 	 * the relevant capability.
@@ -211,6 +244,11 @@ static int fileattr_set_prepare(struct inode *inode,
 				FS_XFLAG_PROJINHERIT)
 			return -EINVAL;
 	} else {
+		/* If user wants to unset projid, set it to 0 */
+		if ((fa->fsx_xflags_rw_mask & FS_XFLAG_PROJID) &&
+		    ((fa->fsx_xflags & FS_XFLAG_PROJID) == 0))
+			fa->fsx_projid = 0;
+
 		/*
 		 * Caller is allowed to change the project ID. If it is being
 		 * changed, make sure that the new value is valid.
@@ -250,6 +288,8 @@ static int fileattr_set_prepare(struct inode *inode,
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
 	if (fa->fsx_cowextsize == 0)
 		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
+	if (fa->fsx_projid == 0)
+		fa->fsx_xflags &= ~FS_XFLAG_PROJID;
 
 	return 0;
 }
@@ -275,6 +315,8 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 {
 	struct inode *inode = d_inode(dentry);
 	struct file_kattr old_ma = {};
+	u32 rw_user_mask = fa->fsx_xflags_rw_mask;
+	u32 rw_fs_mask = 0, ro_fs_mask = 0;
 	int err;
 
 	if (!inode->i_op->fileattr_set)
@@ -288,15 +330,53 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (err)
 		goto out;
 
+	if (old_ma.has_masks) {
+		old_ma.fsx_xflags_rw_mask &= FS_FILE_ATTR_XFLAGS_MASK;
+		old_ma.fsx_xflags_ro_mask &= FS_FILE_ATTR_XFLAGS_MASK;
+		rw_fs_mask = old_ma.fsx_xflags_rw_mask;
+		ro_fs_mask = old_ma.fsx_xflags_ro_mask;
+	}
+	old_ma.fsx_xflags &= FS_FILE_ATTR_XFLAGS_MASK;
+
 	/* initialize missing bits from old_ma */
 	if (fa->flags_valid) {
+		/* FS_IOC_SETFLAGS */
+		fa->fsx_xflags_rw_mask = 0;
 		fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
 		fa->fsx_extsize = old_ma.fsx_extsize;
 		fa->fsx_nextents = old_ma.fsx_nextents;
 		fa->fsx_projid = old_ma.fsx_projid;
 		fa->fsx_cowextsize = old_ma.fsx_cowextsize;
 	} else {
+		/*
+		 * Preserve flags not being set when using FS_IOC_FSSETXATTR or
+		 * file_setattr VER0+.
+		 */
 		fa->flags |= old_ma.flags & ~FS_COMMON_FL;
+
+		/* file_setattr VER1+ */
+		if (fa->has_masks) {
+			/* Preserve old xflags that aren't being set. */
+			fa->fsx_xflags |= old_ma.fsx_xflags & ~rw_user_mask;
+
+			/*
+			 * Filter fsx_xflags by removing xflags that are:
+			 * - filesystem-reported read only
+			 * - globally read only
+			 * but keeping xflags that are:
+			 * - filesystem-reported rw, globally ro
+			 */
+			ro_fs_mask |= FS_XFLAG_RDONLY_MASK & ~rw_fs_mask;
+			fileattr_fill_xflags(fa, fa->fsx_xflags & ~ro_fs_mask);
+
+			if (!(rw_user_mask &
+			      (FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT)))
+				fa->fsx_extsize = old_ma.fsx_extsize;
+			if (!(rw_user_mask & FS_XFLAG_PROJID))
+				fa->fsx_projid = old_ma.fsx_projid;
+			if (!(rw_user_mask & FS_XFLAG_COWEXTSIZE))
+				fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+		}
 	}
 
 	err = fileattr_set_prepare(inode, &old_ma, fa);
@@ -424,6 +504,14 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		return error;
 
 	fileattr_to_file_attr(&fa, &fattr);
+	/*
+	 * Remove xflags added in or after VER1 so userspace programs compiled
+	 * against VER0 don't try to write xflags they don't know about (since
+	 * they do RMW).
+	 */
+	if (usize < FILE_ATTR_SIZE_VER1)
+		fattr.fa_xflags &= FS_XFLAGS_MASK;
+
 	error = copy_struct_to_user(ufattr, usize, &fattr,
 				    sizeof(struct file_attr), NULL);
 
@@ -460,10 +548,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (error)
 		return error;
 
-	error = file_attr_to_fileattr(&fattr, &fa);
-	if (error)
-		return error;
-
 	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
@@ -479,6 +563,30 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 			return error;
 	}
 
+	/*
+	 * Userspace said "I don't want to change any flag", so be it I guess.
+	 * Still check for fileattr support and permissions, also in case this
+	 * is just a probe.
+	 */
+	if (usize >= FILE_ATTR_SIZE_VER1 && fattr.fa_xflags_rw_mask == 0) {
+		struct inode *inode = d_inode(filepath.dentry);
+
+		if (!inode->i_op->fileattr_set)
+			return -EOPNOTSUPP;
+
+		if (!inode_owner_or_capable(mnt_idmap(filepath.mnt), inode))
+			return -EPERM;
+
+		return error;
+	}
+
+	if (usize >= FILE_ATTR_SIZE_VER1)
+		fa.has_masks = true;
+
+	error = file_attr_to_fileattr(&fattr, &fa);
+	if (error)
+		return error;
+
 	error = mnt_want_write(filepath.mnt);
 	if (!error) {
 		error = vfs_fileattr_set(mnt_idmap(filepath.mnt),
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index c8f69dde5dd3..4faa40febf11 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -35,6 +35,10 @@
 	(FS_XFLAG_COMMON | FS_XFLAG_RDONLY_MASK | FS_XFLAG_VALUES_MASK | \
 	 FS_XFLAG_DIRONLY_MASK | FS_XFLAG_MISC_MASK)
 
+/* Flags only for fa_ fields */
+#define FS_FILE_ATTR_XFLAGS_MASK \
+	(FS_XFLAGS_MASK | FS_XFLAG_PROJID)
+
 /*
  * Merged interface for miscellaneous file attributes.  'flags' originates from
  * ext* and 'fsx_flags' from xfs.  There's some overlap between the two, which
@@ -45,6 +49,8 @@ struct file_kattr {
 	u32	flags;		/* flags (FS_IOC_GETFLAGS/FS_IOC_SETFLAGS) */
 	/* struct fsxattr: */
 	u32	fsx_xflags;	/* xflags field value (get/set) */
+	u32	fsx_xflags_rw_mask; /* supported writeable xflags (get) / flags to set (set) */
+	u32	fsx_xflags_ro_mask; /* supported read-only xflags (get) */
 	u32	fsx_extsize;	/* extsize field value (get/set)*/
 	u32	fsx_nextents;	/* nextents field value (get)	*/
 	u32	fsx_projid;	/* project identifier (get/set) */
@@ -52,6 +58,7 @@ struct file_kattr {
 	/* selectors: */
 	bool	flags_valid:1;
 	bool	fsx_valid:1;
+	bool	has_masks:1;
 };
 
 int copy_fsxattr_to_user(const struct file_kattr *fa, struct fsxattr __user *ufa);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a13c7b32a1bd..e40806b3a69c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -238,10 +238,13 @@ struct file_attr {
 	__u32 fa_nextents;	/* nextents field value (get)   */
 	__u32 fa_projid;	/* project identifier (get/set) */
 	__u32 fa_cowextsize;	/* CoW extsize field value (get/set) */
+	__u32 fa_xflags_rw_mask;/* supported writeable xflags (get) / flags to set (set) */
+	__u32 fa_xflags_ro_mask;/* supported read-only xflags (get) */
 };
 
 #define FILE_ATTR_SIZE_VER0 24
-#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
+#define FILE_ATTR_SIZE_VER1 32
+#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
 
 /*
  * Flags for the fsx_xflags field
@@ -270,6 +273,8 @@ struct file_attr {
  */
 #define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
 #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
+
+#define FS_XFLAG_PROJID		0x00100000	/* project ID */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.56.0

