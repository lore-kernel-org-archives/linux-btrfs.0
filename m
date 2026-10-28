Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793195264;
	b=hqslhSj2Ec8SK+jMjk2hPOQfJz2K4fBa6TXkuVvI23WX4kIITTjq+xhJ54nbQveQ04gY
	 ECmnF1YVNnCu/5GAvixa0uS8xjJnIKMLl1PW4m+Aj4JoYbwKyrNIW9CMhYfeG249Xaxv8
	 vzo+T12IerudeY+gPqLgfkrjpyYhbsLZv3/96zJ/CyacK6e8v8wx7Fzkzb8gnwO/ziAjp
	 GMTv5urcckyJtY1WS6jL5rYpGLehtFkHyPOSsd06i33s3I0ckvJA+r7+TckuNtYgeZPEF
	 /vHR8elyfcemyowrgUuvu4h4w2iJnw5wcjxuzPZIuY7dEciBZBZ06dQZDmFKlvESCXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793195264;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e1x9xfVzJvSIrAF0Tny3oa0xaZaQVjBEcFd91S1KOeg=;
	b=lZUQX4PV2dM+OYK1J+U7G6N5tHY5DwsdIz5mYnJLqw5d5FLX7GvF68kRlVIp2kk36Fv6
	 8zJikmsnN5b+FGfvZub/GVaz5rEQc22lmjHFl6bDE142jZobbjofT5Ow62niG1UiTEG/P
	 7E35q7+mMml/DDarTkhffUDJZLG7LNPaB46hywTcDWOcOQkXSX+nQWZWmgzJzJn53IB0Z
	 aSShD8QQAjAtUqbmkchtoIVPeVuwnqcEnk+90Ib7g1F7CvXe+mce43MKZFEtgucpS5WjE
	 LZ+91EUr2d4mTJv4Y7Azz52AnleHrShqFZpXkiE6nwaTCo/KdQU4OwycJfEMMWqtkaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DJou7qPW;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3F7606A31D
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 13:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA3F7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DJou7qPW
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so8055985e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793195262; x=1793800062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1x9xfVzJvSIrAF0Tny3oa0xaZaQVjBEcFd91S1KOeg=;
        b=DJou7qPWaPw94RtWDO0VKRgcv6ZqXA8MEV2LZ9qpDAQBtM7+9B/+LvP1/TXqrxxoPS
         OJ2yXG5zsszI+CwhPBuFyjD1i5NddkwuKRq85t7fGVP77CMOz3zMtxL37Yt3i4YizKxs
         /cn2O6dVv7G/3Wgp7wBvntZ8E+TYyu44JNBFYdIfxY8k9DWi52/xF9Le7Hbwu7O3M6EP
         lj2xLJNMtc5ufyHhNgidpi0hz1m9RnQk3ROClrMs7YpgzEqY5eOQc83JiN6VabirHpsJ
         EVaJJ/eoWwI3Hzz+krM3GaMnE96yukmyuCwLeEhgRRHMSYBoJTx9EjF+NO2d3KahEoIp
         HIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195262; x=1793800062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1x9xfVzJvSIrAF0Tny3oa0xaZaQVjBEcFd91S1KOeg=;
        b=B3AH8O+GSc00k/xGUzfV7D7RfyIxOumeDyvY0MGL/WW0omDZ4NvTJjmL3TWI8GAe0B
         c9QFevpQoXFitJDGYbTlvkzafFUafKWYeeRGZCBVwo/jgMEFlWfVC3SxrLAsnqaMHRU1
         zPC1GWCEkrE0nepMVlNDfjITLGsD+5odlRF5/1rx7hQpg94u/fG12V4f6cedwzvRDCnt
         gAx4C35mKZC86PQ3RkFsF/i8VmmYozeww+ra3T55inZhMjT9ADmJ/aouQt92cRD2/QT4
         T7dVUZzY+zR3Kpo/Tg3CeqJDvdhvvTa5E1f3VKy2E9FkTMqWn9GxymyfqeLKKBxwxP1j
         KDmA==
X-Forwarded-Encrypted: i=1; AKwUvBwUoGtbhdH3BfmBItvF0PDVQ+EJQ6LeKa7LA5SqdZK9MM0cD+i1vPscEwJmZnFRcsPqPw6JfHVVF1JJgg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKNXE8+mhQgCSRGU7U2lCKlf7OVzRy1Hhukan4OGMlHH2FoOI9r
	AHUPsNT8zVltdffwkQthgyxsRKGf+KuLT0fAy9MAR+2jY2dXeeqJ+yV4
X-Gm-Gg: AYBFou3j1G1PCrolA0BD1QnyurVpfdW+JeuLAtjCmXkmChqXBEvPwNV5oZwJOy/UFao
	Ui7FXd/LuuuwD7gnkJaBn7fRVn1q3ua+yUl+hyglQ/pj0F1xu47uhx8oRY36AXg+359ITvTpuNK
	OQoP/7YBbyiCs7fFdgey4pzm9pTZmmfZ6FFwBTTfLwEVBDU7VNBKU2AiJ0AFH4Jn5EmVRn6RzL+
	0wqub+R+zYESkMHrr/oJavzhKR4eV8sKBK1He11wdRMzZ1Prancao/VCOcT+8t/eVu2LEEExeBr
	Bl+Am+q6RjYkSTSVBHrYXv92udCTcwLXL5/HK1mxQCc16Al8E9VeOteLxhGtt8eXgawnrt272Jl
	qE0XUJX9t3KyA51tkS/QP42/hJh3gJ8An9QmuFarZUD+BHyx17r0znuXsfu2wREsnYzYe7y2+II
	DS8bRMtlCxkL1BWa0EDGbDAt/mePU1rkldDFpuQyJory/W9/ijmOO+FSEZi5tknvCv74juatKRV
	nv8ltetMaaIEV9tMBo3yK5h7mbvZAk8oMhSP8UG9UAnK02BIcFIvkytGB8+nZVfUzFX5nYNgTCT
	34v/BgajS55ATUwQM185dLQG
X-Received: by 2002:a05:600c:c117:b0:4a2:f58:9a82 with SMTP id 5b1f17b1804b1-4a7c58f3472mr124358745e9.13.1793195262069;
        Wed, 28 Oct 2026 06:47:42 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc4d76sm29077715f8f.12.2026.10.28.06.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:47:41 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v2 1/2] vfs: add provenance time (ptime)
Date: Wed, 28 Oct 2026 14:47:27 +0100
Message-ID: <20261028134728.294127-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028134728.294127-1-koray.fra@gmail.com>
References: <20261028134728.294127-1-koray.fra@gmail.com>
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

Add provenance time (ptime), indicating the time when a file or
directory was created. This is user-settable via file_setattr() and
retrievable via statx(2) (using STATX_PTIME) or file_getattr().

The semantics of when to preserve this new timestamp are the same as
mtime, the idea being that there is a correspondence like this:

ctime <-> btime
mtime <-> ptime

so every operation (copying, moving, ...) that currently preserves mtime
should also preserve ptime.

Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
allow ptime to be used with the file_setattr()/file_getattr() syscalls.

[ This is a re-implementation of the initial patch[1] by Sean Smith
  <defendthedisabled@gmail.com>, following the advice[2] from Darrick J.
  Wong <djwong@kernel.org> of using file_setattr() instead of updating
  utimensat() ]

[1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmail.com
[2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c            | 29 +++++++++++++++++++++++++++--
 fs/stat.c                 |  2 ++
 include/linux/fileattr.h  |  5 +++++
 include/linux/stat.h      |  1 +
 include/uapi/linux/fs.h   |  8 +++++++-
 include/uapi/linux/stat.h |  7 ++++++-
 6 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..9c1dfdba6b4d 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
 static void fileattr_to_file_attr(const struct file_kattr *fa,
 				  struct file_attr *fattr)
 {
-	__u32 mask = FS_XFLAGS_MASK;
+	__u32 mask = FS_FILE_ATTR_XFLAGS_MASK;
 
 	memset(fattr, 0, sizeof(struct file_attr));
 	fattr->fa_xflags = fa->fsx_xflags & mask;
@@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct file_kattr *fa,
 	fattr->fa_nextents = fa->fsx_nextents;
 	fattr->fa_projid = fa->fsx_projid;
 	fattr->fa_cowextsize = fa->fsx_cowextsize;
+	fattr->fa_ptime_sec = fa->fsx_ptime.tv_sec;
+	fattr->fa_ptime_nsec = fa->fsx_ptime.tv_nsec;
 }
 
 /**
@@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
 static int file_attr_to_fileattr(const struct file_attr *fattr,
 				 struct file_kattr *fa)
 {
-	__u64 mask = FS_XFLAGS_MASK;
+	__u64 mask = FS_FILE_ATTR_XFLAGS_MASK;
 
 	if (fattr->fa_xflags & ~mask)
 		return -EINVAL;
 
+	if (fattr->fa_pad != 0)
+		return -EINVAL;
+
 	fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK);
 	fa->fsx_extsize = fattr->fa_extsize;
 	fa->fsx_projid = fattr->fa_projid;
 	fa->fsx_cowextsize = fattr->fa_cowextsize;
+	fa->fsx_ptime.tv_sec = fattr->fa_ptime_sec;
+	fa->fsx_ptime.tv_nsec = fattr->fa_ptime_nsec;
 
 	return 0;
 }
@@ -232,6 +239,16 @@ static int fileattr_set_prepare(struct inode *inode,
 	    !S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
 		return -EINVAL;
 
+	if (fa->fsx_xflags & FS_XFLAG_PTIME) {
+		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+			return -EPERM;
+
+		if ((unsigned long)fa->fsx_ptime.tv_nsec >= NSEC_PER_SEC)
+			return -EINVAL;
+
+		fa->fsx_ptime = timestamp_truncate(fa->fsx_ptime, inode);
+	}
+
 	/*
 	 * It is only valid to set the DAX flag on regular files and
 	 * directories on filesystems.
@@ -293,6 +310,7 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 			fa->fsx_nextents = old_ma.fsx_nextents;
 			fa->fsx_projid = old_ma.fsx_projid;
 			fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+			fa->fsx_ptime = old_ma.fsx_ptime;
 		} else {
 			fa->flags |= old_ma.flags & ~FS_COMMON_FL;
 		}
@@ -423,6 +441,10 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		return error;
 
 	fileattr_to_file_attr(&fa, &fattr);
+
+	if (usize < FILE_ATTR_SIZE_VER1)
+		fattr.fa_xflags &= ~FS_XFLAG_PTIME;
+
 	error = copy_struct_to_user(ufattr, usize, &fattr,
 				    sizeof(struct file_attr), NULL);
 
@@ -459,6 +481,9 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (error)
 		return error;
 
+	if ((fattr.fa_xflags & FS_XFLAG_PTIME) && usize < FILE_ATTR_SIZE_VER1)
+		return -EINVAL;
+
 	error = file_attr_to_fileattr(&fattr, &fa);
 	if (error)
 		return error;
diff --git a/fs/stat.c b/fs/stat.c
index a2e63c6c45b7..e426f41253f6 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -728,6 +728,8 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_ctime.tv_nsec = stat->ctime.tv_nsec;
 	tmp.stx_mtime.tv_sec = stat->mtime.tv_sec;
 	tmp.stx_mtime.tv_nsec = stat->mtime.tv_nsec;
+	tmp.stx_ptime.tv_sec = stat->ptime.tv_sec;
+	tmp.stx_ptime.tv_nsec = stat->ptime.tv_nsec;
 	tmp.stx_rdev_major = MAJOR(stat->rdev);
 	tmp.stx_rdev_minor = MINOR(stat->rdev);
 	tmp.stx_dev_major = MAJOR(stat->dev);
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 09e32b84e02a..0b93f9609284 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -35,6 +35,10 @@
 	(FS_XFLAG_COMMON | FS_XFLAG_RDONLY_MASK | FS_XFLAG_VALUES_MASK | \
 	 FS_XFLAG_DIRONLY_MASK | FS_XFLAG_MISC_MASK)
 
+/* Flags only for fa_ fields */
+#define FS_FILE_ATTR_XFLAGS_MASK \
+	(FS_XFLAGS_MASK | FS_XFLAG_PTIME)
+
 /*
  * Merged interface for miscellaneous file attributes.  'flags' originates from
  * ext* and 'fsx_flags' from xfs.  There's some overlap between the two, which
@@ -49,6 +53,7 @@ struct file_kattr {
 	u32	fsx_nextents;	/* nextents field value (get)	*/
 	u32	fsx_projid;	/* project identifier (get/set) */
 	u32	fsx_cowextsize;	/* CoW extsize field value (get/set)*/
+	struct timespec64 fsx_ptime; /* provenance (settable birth) time */
 	/* selectors: */
 	bool	flags_valid:1;
 	bool	fsx_valid:1;
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 9c5709132862..69d2ecfd1bf2 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -48,6 +48,7 @@ struct kstat {
 	struct timespec64 mtime;
 	struct timespec64 ctime;
 	struct timespec64 btime;			/* File creation time */
+	struct timespec64 ptime;	/* File provenance (user-settable creation) time */
 	u64		blocks;
 	u64		mnt_id;
 	u64		change_cookie;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a46c33692aa2..c00e72fcfa3e 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -229,10 +229,14 @@ struct file_attr {
 	__u32 fa_nextents;	/* nextents field value (get)   */
 	__u32 fa_projid;	/* project identifier (get/set) */
 	__u32 fa_cowextsize;	/* CoW extsize field value (get/set) */
+	__s64 fa_ptime_sec;	/* provenance (settable birth) time (seconds) */
+	__u32 fa_ptime_nsec;	/* provenance (settable birth) time (nanoseconds) */
+	__u32 fa_pad;
 };
 
 #define FILE_ATTR_SIZE_VER0 24
-#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
+#define FILE_ATTR_SIZE_VER1 40
+#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
 
 /*
  * Flags for the fsx_xflags field
@@ -261,6 +265,8 @@ struct file_attr {
  */
 #define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
 #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
+
+#define FS_XFLAG_PTIME		0x00100000	/* provenance time */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 1686861aae20..f3a1013ba022 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -187,7 +187,11 @@ struct statx {
 	__u32	__spare2[1];
 
 	/* 0xc0 */
-	__u64	__spare3[8];	/* Spare space for future expansion */
+	/* Data provenance (creation) time */
+	struct statx_timestamp	stx_ptime;
+
+	/* 0xd0 */
+	__u64	__spare3[6];	/* Spare space for future expansion */
 
 	/* 0x100 */
 };
@@ -219,6 +223,7 @@ struct statx {
 #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
 #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
 #define STATX_DIO_READ_ALIGN	0x00020000U	/* Want/got dio read alignment info */
+#define STATX_PTIME		0x00040000U	/* Want/got stx_ptime */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
-- 
2.56.0

