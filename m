Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765855;
	b=Qt62muoqABPbHNB6B8kWZxkyp5deIaFASZ5N0zKyi5heGSt0/0yVUBEOcHqAnWZfoYBd
	 g4sdfonj17gt/Ctly+JkqIQQRJX7HWZ3OwdCxMU20YpD8DvKOxAQwrgK4/m6SK15gMMqS
	 7PoYmJbXD+m3s9G9ucTY1TKBAAaYmBHhZyrC3GwgmnyjDRVLNdUZKoFPJW68QCeXC7Ft8
	 w+T9eEsJRST556YSJ8IB1gzebFhdpcD1E0k+goVVqiZ8jc+tXM5Fikoq7RWVsqtgmzGz1
	 Q3i/YC1erU1TO10nYe2Wu/suVhlN0YCz4BvvA6cFMKPPVbzGK+uDA2s7DwrhEABrkng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765855;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dt00QcB/UAbcoWfb+Nc1N3msJVe+tAMzrHb6Fo7W5/Y=;
	b=PvFrBjgBd1x2YvGxXe53avY+I2dTsra4do/Czt8D8IpDCuITHozLB9pgEcLVlklsEg/d
	 +Z2zFaZ1XlwrUjTMfHUdEczCk2/c6AenasZoMLMwylu3JE45iQOSb246Hq4veFkP1pB1X
	 INUaYU93HO/A73FtEDui89MXig32KV0PPsyDNXOdsbfjWr7hFzoTLc7rT60xjm8lN7tsh
	 QjDwHzQ9qK4nEiOc3WfQ/aQaxD/67ZF/gqnHAzuu1u4LJKAA1eVAn6tBoiDElceAdoN2+
	 ya4LCbG3bu7R6Mb3vxM0ZJP+udfMm9QBdp9nPH3NNaJW6NVtznfVt56nCh+YJOJV7Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gudTlvRy;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCCE606A89E
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 18:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FCCE606A89E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gudTlvRy
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-492690dd5daso2667230f8f.1
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 10:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794765852; x=1795370652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dt00QcB/UAbcoWfb+Nc1N3msJVe+tAMzrHb6Fo7W5/Y=;
        b=gudTlvRybSJy4KLmYFZtNr9ekZ8L2alX0H3pXn05eEH3Y71gowCbfqSK14PUokehUu
         4BxfuuQukOHh4LKpkMI/IwaZELD8tsUAHTcYi5wyozwdkClCAzu8+dxdoC5rcEJEm7Bk
         ZS3WkN+bFmWrei1bYBQWwxIF0tQzF7lyoi5dAnRHKCO7O43Kl9edafYh5X5xlKQTA6Fr
         I7nyTa4AMxp1KV7GhugUFMg7CipLxXlEcJvUGt/khnJSi70VSYQm0pZTCNUG7Xd7EoAo
         NOY3cQW0eZ6EPN9T8M9IbWSSCNdWpIzlDs1+JH18HnaoSqfd+dMRGd444+JAqRIqyI2q
         7gjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794765852; x=1795370652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dt00QcB/UAbcoWfb+Nc1N3msJVe+tAMzrHb6Fo7W5/Y=;
        b=GroFk3uyA1MbNEHnWxad1vql3XvGsDzfaBKRupn9S1BFXvhGDZgWXaWoIJxo3jldsR
         flZuISoYgvMZ53zlasyztANSnPHqQzR2iv0eQGsHudQ/xglD7CHq4VokrMwa5gdtI1DX
         DA3bwpHUsUG7X8vqd9Eq9l9xF1rJ2QqodhcZp3MQMehHPgPSBG1Rcq4F3p+EZn3fOK7a
         0KYY11MthAkZYMHlshIJeFlv0xZzcjBSR+bvgPt0MFgGU0VmFHH3cLuVikI5WIteHHmO
         QxRpJr2Vx0cYBk6G60gNYZ7cl75xOFKxZ6FXNFsKJaJoFbEJrAPjl2uI8cRTINkYeG/c
         WQRw==
X-Forwarded-Encrypted: i=1; AL+hErHgWUiiYilMcUfP74dCHa8doF4VfJM4fab5zfc2aaFjCnyeguZW9ETXW/o85toQIJzlUHQThkGc9CPXKA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8BUCuFfn3X/fSkwTrpFrePKnuI677geI6mj1ml0yBEiLQkacLC
	ZepEQ26o/dNC1gsWvBeC21qSGTjXYwSF2MXR2lbvqIZNHZOb9vjQ4b94
X-Gm-Gg: AYBFou1lgWdtB2GZEwA04/4FHYMrLIQNMZ5MZwvcYzo1LlGQQcYfMy1OaA5VugMZBMN
	GB9EruJ5DZMCtfAyMJk572c+QfRLy1RCxF50ftrSHAzS8sQDdEVOFLvmUjzM5OrICdNJJRyaNhL
	89kw2iDuaYz7rTeLP14BZ/wxWJc9y5ReB4F/2upBAv0sCrPkp7vjHyckDeZw7az1srbbtCcaFCE
	nFDYtJMF19rEUp9UCVH/A5THpU4scTd2klYs+T3XqQhr8fjLDItLcujxZnN1z00D9G6zVwsIssw
	f7FNy7ynNbEN05dkH3/UtKDujzWWqWli5aNp6aXqftB1mmSJqIGDhW1qxJhhGhJ5fCde2Oca9Nu
	F1sNd2nukC7m3ScUWXxkoKagp2VXgsToi4vysv6ZM8BW9b01xo9RwqganxB2DJBtHoxNOohBNCj
	HvERRE0N3lxr7RcZtdcfiBhx54KB3Nu0h6HS64sSJu7TY/0w0q6WeHqgGy4TrXdVgu1SgwjHem3
	OXwJkVnTcZMCmQUC+ekaBjGsAcW53+g36SK7mT9kv239lPN2vgAvuCdK2h1jydNH7nx7MGQMF3D
	WgZmJrFRtyUVtB6gPeIpLJMM
X-Received: by 2002:a05:6000:4022:b0:49e:1601:2fb1 with SMTP id ffacd0b85a97d-49e1601310bmr10387323f8f.24.1794765852233;
        Sun, 15 Nov 2026 10:04:12 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm17980448f8f.58.2026.11.15.10.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 10:04:11 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Chris Mason <mason@kernel.org>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v4 06/10] vfs: add __vfs_fileattr_set_locked() for inode_lock()'d callers
Date: Sun, 15 Nov 2026 19:03:39 +0100
Message-ID: <20261115180343.576773-7-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115180343.576773-1-koray.fra@gmail.com>
References: <20261115180343.576773-1-koray.fra@gmail.com>
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

Currently there is no way for a caller to invoke vfs_fileattr_set()
while holding an inode lock without having the kernel go into deadlock.

Fix this by moving the vfs_fileattr_set() logic into
__vfs_fileattr_set_locked() and making vfs_fileattr_set() a simple
wrapper that only handles the inode lock.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c           | 139 +++++++++++++++++++++++----------------
 include/linux/fileattr.h |   2 +
 2 files changed, 86 insertions(+), 55 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 12610fb6a751..063c81fbfa6a 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -288,6 +288,89 @@ static int fileattr_set_prepare(struct inode *inode,
 	return 0;
 }
 
+/**
+ * __vfs_fileattr_set_locked - change miscellaneous file attributes while
+ * holding the inode lock
+ *
+ * @idmap:	idmap of the mount
+ * @dentry:	the object to change
+ * @fa:		fileattr pointer
+ *
+ * Same as vfs_fileattr_set(), but caller must hold the inode lock.
+ *
+ * Return: 0 on success, or a negative error on failure.
+ */
+int __vfs_fileattr_set_locked(const struct mnt_idmap *idmap, struct dentry *dentry,
+			      struct file_kattr *fa)
+{
+	struct inode *inode = d_inode(dentry);
+	struct file_kattr old_ma = {};
+	int err;
+
+	if (!inode->i_op->fileattr_set)
+		return -ENOIOCTLCMD;
+
+	if (!inode_owner_or_capable(idmap, inode))
+		return -EPERM;
+
+	err = vfs_fileattr_get(dentry, &old_ma);
+	if (err)
+		return err;
+
+	/* initialize missing bits from old_ma */
+	if (fa->flags_valid) {
+		/* FS_IOC_SETFLAGS */
+		fa->fsx_xflags |= (old_ma.fsx_xflags & FS_XFLAGS_MASK) &
+				  ~FS_XFLAG_COMMON;
+		fa->fsx_extsize = old_ma.fsx_extsize;
+		fa->fsx_nextents = old_ma.fsx_nextents;
+		fa->fsx_projid = old_ma.fsx_projid;
+		fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+		fa->fsx_ptime = old_ma.fsx_ptime;
+	} else {
+		/*
+		 * Preserve unmasked xflags when running file_setattr()
+		 * with a mask, which doesn't need a read-modify-write
+		 * so these attributes would be set to 0.
+		 *
+		 * With FS_IOC_FSSETXATTR or mask == 0 (legacy mode)
+		 * this is not needed as userspace does
+		 * read-modify-write already.
+		 */
+		if (fa->fsx_xflags_mask) {
+			fa->fsx_xflags |= old_ma.fsx_xflags &
+					  ~fa->fsx_xflags_mask;
+			fileattr_fill_xflags(fa, fa->fsx_xflags &
+					     ~FS_XFLAG_RDONLY_MASK);
+			if (!(fa->fsx_xflags_mask & FS_XFLAG_EXTSIZE))
+				fa->fsx_extsize = old_ma.fsx_extsize;
+			if (!(fa->fsx_xflags_mask & FS_XFLAG_PROJID))
+				fa->fsx_projid = old_ma.fsx_projid;
+			if (!(fa->fsx_xflags_mask & FS_XFLAG_COWEXTSIZE))
+				fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+		}
+		fa->flags |= old_ma.flags & ~FS_COMMON_FL;
+
+		/* xflags not present in fsxattr */
+		if (!(fa->fsx_xflags_mask & FS_XFLAG_PTIME))
+			fa->fsx_ptime = old_ma.fsx_ptime;
+	}
+
+	err = fileattr_set_prepare(inode, &old_ma, fa);
+	if (err)
+		return err;
+	err = security_inode_file_setattr(dentry, fa);
+	if (err)
+		return err;
+	err = inode->i_op->fileattr_set(idmap, dentry, fa);
+	if (err)
+		return err;
+	fsnotify_xattr(dentry);
+
+	return 0;
+}
+EXPORT_SYMBOL(__vfs_fileattr_set_locked);
+
 /**
  * vfs_fileattr_set - change miscellaneous file attributes
  * @idmap:	idmap of the mount
@@ -308,7 +391,6 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		     struct file_kattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
-	struct file_kattr old_ma = {};
 	int err;
 
 	if (!inode->i_op->fileattr_set)
@@ -318,60 +400,7 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		return -EPERM;
 
 	inode_lock(inode);
-	err = vfs_fileattr_get(dentry, &old_ma);
-	if (!err) {
-		/* initialize missing bits from old_ma */
-		if (fa->flags_valid) {
-			/* FS_IOC_SETFLAGS */
-			fa->fsx_xflags |= (old_ma.fsx_xflags & FS_XFLAGS_MASK) &
-					  ~FS_XFLAG_COMMON;
-			fa->fsx_extsize = old_ma.fsx_extsize;
-			fa->fsx_nextents = old_ma.fsx_nextents;
-			fa->fsx_projid = old_ma.fsx_projid;
-			fa->fsx_cowextsize = old_ma.fsx_cowextsize;
-			fa->fsx_ptime = old_ma.fsx_ptime;
-		} else {
-			/*
-			 * Preserve unmasked xflags when running file_setattr()
-			 * with a mask, which doesn't need a read-modify-write
-			 * so these attributes would be set to 0.
-			 *
-			 * With FS_IOC_FSSETXATTR or mask == 0 (legacy mode)
-			 * this is not needed as userspace does
-			 * read-modify-write already.
-			 */
-			if (fa->fsx_xflags_mask) {
-				fa->fsx_xflags |= old_ma.fsx_xflags &
-						  ~fa->fsx_xflags_mask;
-				fileattr_fill_xflags(fa, fa->fsx_xflags &
-						     ~FS_XFLAG_RDONLY_MASK);
-				if (!(fa->fsx_xflags_mask & FS_XFLAG_EXTSIZE))
-					fa->fsx_extsize = old_ma.fsx_extsize;
-				if (!(fa->fsx_xflags_mask & FS_XFLAG_PROJID))
-					fa->fsx_projid = old_ma.fsx_projid;
-				if (!(fa->fsx_xflags_mask & FS_XFLAG_COWEXTSIZE))
-					fa->fsx_cowextsize = old_ma.fsx_cowextsize;
-			}
-			fa->flags |= old_ma.flags & ~FS_COMMON_FL;
-
-			/* xflags not present in fsxattr */
-			if (!(fa->fsx_xflags_mask & FS_XFLAG_PTIME))
-				fa->fsx_ptime = old_ma.fsx_ptime;
-		}
-
-		err = fileattr_set_prepare(inode, &old_ma, fa);
-		if (err)
-			goto out;
-		err = security_inode_file_setattr(dentry, fa);
-		if (err)
-			goto out;
-		err = inode->i_op->fileattr_set(idmap, dentry, fa);
-		if (err)
-			goto out;
-		fsnotify_xattr(dentry);
-	}
-
-out:
+	err = __vfs_fileattr_set_locked(idmap, dentry, fa);
 	inode_unlock(inode);
 	return err;
 }
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index ba7ed3b387d8..7ff62ee27e58 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -97,6 +97,8 @@ static inline bool fileattr_has_fsx(const struct file_kattr *fa)
 int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
 int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		     struct file_kattr *fa);
+int __vfs_fileattr_set_locked(const struct mnt_idmap *idmap, struct dentry *dentry,
+			      struct file_kattr *fa);
 int ioctl_getflags(struct file *file, unsigned int __user *argp);
 int ioctl_setflags(struct file *file, unsigned int __user *argp);
 int ioctl_fsgetxattr(struct file *file, void __user *argp);
-- 
2.56.0

