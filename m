Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710708;
	b=xsoAnP0FdtKhu24NIWA//5FLCmBeOS3ePWOSLg6GlSDbkc8swahu7JNJwoZi1bLcHzbe
	 +GO8/EfmbdewzIGe4BoPMZDjULJxTN/xkMP9NaBlNOfEDj85Z/BydT7npDGCqeZ4xGDGt
	 4Ln93ngdeGFbev/9rw6xXCciuQogTUffX2OFuDkylvLWJu5EqdxKbhKM+pOvp9xEutix7
	 INx9aBpK4DoUYbRO+H4r1hVznTEy+6FmziMVqhwPUnlyezpTF3nFPaDthvf17T8uDNIFP
	 mEfVwMH/gPoZWYcu3ON24+ID2QFg21MYrUq3ENp0FNlHIcCNWs6uQuvJ07DKTAnRHAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
	b=zuGO9xbDnTCcTW84rCO4xRBZu5pyXD8VPlW9SOgdyIJHPQAj9J1TcmI4RynGam5Lyq7J
	 tXWcOJvXt+ZoH9G/UypZi6CL8ksLk7vsAoDPJVcIh/ar8u6UTs1jMCUDN0125X5ATjGJv
	 XzgbN/tBDOdm8hVDtgsxFa9hJ7gPMXeZkHuYlokETCx1xp/jw3mWqzH+g49egrz3uxvHs
	 0go3RJNmpkvnoZ6wFpQroKbVBm6W8suKs2Qds2UjFnJzhsyfAVpawcY14wFGoY3Q7h1zk
	 lDbH5gSg29bjKitSoqyx0ae7eIGtAXVrfSTTcGD7Kur17Zpzty+Dk/Oq1+1VYS50MsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xc+MkwdP;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DFC606A334
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 16:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46DFC606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xc+MkwdP
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso51720675e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 08:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795710707; x=1796315507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
        b=xc+MkwdP2qSHhRJs8tqp0gJVAbhLaJGgxK7Lgcrjfgi+poNIcrpekreyQIw8Wa2ubw
         JTYEYjzBQHqXA+RCGlkMim5rWjlpg2Rc8MJ45f9iuFGrYnTeolSe9vBS2bLSeX5T5fZf
         SZX2nx4eSzWBYUFb1yi9O/TFdM/MA3MAnAw6/ApHrCpLQQihkBD0TTWOQKPnQ28uZTYE
         XpRkIhDzQqfntphSLOtItZuJswRxPc5PSDPlBmuNOaDHAcf8EMQ3hdeMUxJAM4CSuDyL
         mqwH8JHptswvYdfZEoqv6ChJC6m67PYPkI1mpROJ+wyATfnVNkfzJA1ri8ZRyz6/FKyk
         ZCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710707; x=1796315507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
        b=kl0KggkZgY8Kx0jjck9984IPcFRTnYPqXpLaow9tJ6Gxm7BeVhOShLik5YFb26oFE9
         Pg1Albvst3eopDaep9D4Y+f4dByAfswab5fEl4s7atYHAVTVIBnkhTmbiA9XBWtVB2yg
         syFo0czq0ZlG9wYvvPVyrSV5InbAMCp18r1RgY7GV9ohl+j51Q3EPQgWWa1yeRjyCprB
         MRv6kRJzMM2DdT+xm7Vag+69ZRiq3QH+glooNG2JtYxzr2nmUGKfUam6F5KGNPrRBxNE
         vr/CIvH9axhC97GJA2yvuj5flnJ93PZEWs/UR/pJ3oV6gG/L4/0fW/3rXazgjb0U5hqP
         gEiQ==
X-Forwarded-Encrypted: i=1; AL+hErEZtg5NmZaJA5S/CxgtTqeGNEe9L68mNgHmlZvO70MS8CBI7G6xAjoQMlL2bACvVWJ7A4grsKA0VpYStA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9qXBtdEV/3715Mit53dXKnd1mCJKwomD+aXd38Jk/y99TWLQiL
	FsNDAZg46gleqJcJ5znM5hkgQj6qRb29MsyZtd4T5hQ3l/yGnKhhYkt5
X-Gm-Gg: AZFdTZf8RFASMwjj1/1Cc036V876jissvlesXsBUHcPH9OSPFrFNQIRAAp/4d5jHBnE
	7AA0puQRjDlEZXdxw/+bUDPbk9szU1h9W5ICS++RvjMqZoacGlsmmPU00EiFQWGZzh12Pqi+wLL
	6AbvYUSCNDR6CvvLTBe1aYBM4iYmgVNCEMlkOYdsqQfuaxW+7qVy+ulXpvoQQRsa7TbTCsDFAMc
	HN0az9SSmccDginMnJltQzXOcJ7nFdXDyBNok85egoTpZyKSi3u2nhfdi6Uzfx2c1XEWTfqifWH
	HxaP4hacS3u9MztEMLyD53N2QUaooZc2Zn388PNLI92u+NGHuv8NpI0RB3YWksJixzUXN/95dPm
	r7HcQzZcIGnWkDt5bGbWQbv4iGpemj0V6UGDb0h6HdobCp4Jnr2b76k0oCEafbOMuTajVKWoLjA
	tONdXTPWUV5+s4/h5+fABzuT8fHhBZlmioSRfZ44hBXDaIhXNNqNKgMFgQCM52HRGqRrGPPXFLM
	YhdfkUUAAwKFe11MjWP00xw0YEOPcHMQkfssxqzyPpcXTg53c5j8vqtSuRsWg55CH12UhvhEZ+A
	Erv7ZjJXLlxkp5gRzZjrVt5K
X-Received: by 2002:a05:600c:4e0c:b0:4bb:875b:f23f with SMTP id 5b1f17b1804b1-4bb88827f0bmr416764955e9.33.1795710706373;
        Thu, 26 Nov 2026 08:31:46 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm721964995e9.11.2026.11.26.08.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:45 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Aring <alex.aring@gmail.com>,
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
Subject: [PATCH v2 1/4] vfs: use goto out on error in vfs_fileattr_set()
Date: Thu, 26 Nov 2026 17:31:11 +0100
Message-ID: <20261126163114.403846-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>
References: <20261126163114.403846-1-koray.fra@gmail.com>
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

Switch from using if (!err) { ... } to the cleaner if (err) goto out;
in the main body of vfs_fileattr_set().

Signed-off-by: koraynilay <koray.fra@gmail.com>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..40d6518f1d8e 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -285,30 +285,31 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 
 	inode_lock(inode);
 	err = vfs_fileattr_get(dentry, &old_ma);
-	if (!err) {
-		/* initialize missing bits from old_ma */
-		if (fa->flags_valid) {
-			fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
-			fa->fsx_extsize = old_ma.fsx_extsize;
-			fa->fsx_nextents = old_ma.fsx_nextents;
-			fa->fsx_projid = old_ma.fsx_projid;
-			fa->fsx_cowextsize = old_ma.fsx_cowextsize;
-		} else {
-			fa->flags |= old_ma.flags & ~FS_COMMON_FL;
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
+	if (err)
+		goto out;
+
+	/* initialize missing bits from old_ma */
+	if (fa->flags_valid) {
+		fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
+		fa->fsx_extsize = old_ma.fsx_extsize;
+		fa->fsx_nextents = old_ma.fsx_nextents;
+		fa->fsx_projid = old_ma.fsx_projid;
+		fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+	} else {
+		fa->flags |= old_ma.flags & ~FS_COMMON_FL;
 	}
 
+	err = fileattr_set_prepare(inode, &old_ma, fa);
+	if (err)
+		goto out;
+	err = security_inode_file_setattr(dentry, fa);
+	if (err)
+		goto out;
+	err = inode->i_op->fileattr_set(idmap, dentry, fa);
+	if (err)
+		goto out;
+	fsnotify_xattr(dentry);
+
 out:
 	inode_unlock(inode);
 	return err;
-- 
2.56.0

