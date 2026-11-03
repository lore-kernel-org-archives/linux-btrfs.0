Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735270;
	b=liImJWwBwXRXaYwjck/cAbI1/rkKCn3J/2CXn7jTm3fupqzGGu7d7ynK6btMz5Z2DLLp
	 G2v5xt7dMZ7cX9Vsg+6LoON5KW8iR6pLsYGb4py2eS+eFZtTMkq0ZBoUInTOn2sQHVHXQ
	 DQOr8eVfl/ha3T4hKwU1UMcOxfyNpUVzo6ixiHWAcL3JVUi5dQhNzrPvQbIifhCSxt1VX
	 FoDB7F1oGllpCBUOv0zOUk1ag9ganCk45RyBjxg3Qh2kQBCgHjHlckAfgDBCJPsUna6yh
	 2dYjTqluQTRpqeLjtSQEX4qYQuMP8RgET7AuL6lBXAAeKGfdJ+r2CPwjYcDbMtezCyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735270;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GkH4++dBijCXwD5VYEy6fAXo1cqRdIgNM8BgDbHwXH0=;
	b=X8bVulKuMOTx8mmJpO9gdQDO8OaXCJN+4wITyp9ZgnnePWj8qrQDzm8bKBaX2GXO36mY
	 3j+bpcBQL5kruEBlZ6yDil8+F7TOnVKw0WsYoxCtCS7o67jX1oEqTucMah3oW4K0rKNSK
	 MwnG1aQmRasYxgDby9QgeVej168wZQebDWs54EgDeS64f0acBvgz8CshsqCU0VmbeIaHw
	 qT7IELdPC9p5ieGxeepOp4jDzZsBwXf5gW4adAI9x8RCJ113Cn6JvTBGV2R5Fg0SeATSV
	 2Ode2f+lYzb73p1xeh3k7RlSbUJL+K4HoNloIzAKi58ZCIKEZU75SRH2hyVRoI54YAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GpMlzHMj;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACAA606D80C
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 19:47:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ACAA606D80C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GpMlzHMj
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso29537325e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 11:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735268; x=1794340068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GkH4++dBijCXwD5VYEy6fAXo1cqRdIgNM8BgDbHwXH0=;
        b=GpMlzHMjXN/6idxMBVyEypL3QyWcWhwlDHnx4qBxqS1k/CHkJpdZ5PZIY3egJMLKCw
         rzRHO96eERISuoGV6+cOFKOxQlidE7483hprNmTjMla0WHfugA0ZsbUJCXuMDw9wkn7P
         UxgpM8mhy3VNIIGwUX0Ene9rlav+g8EPpaj7mHWLtOV4PU0n8/zeZl2h13hz24fcEHWv
         YT28+H5OrYEtyNTSBtK3dC3nANwZuiemL+RBU0zS7raIg48/Efs/D848v81f5LPtZRK7
         6i3YvoWdc43CFRTQRVe0cWUMxIhbPj/gisaquIsX9W8XUQLsO4Sxb7jMGT/TtT6kOouE
         CnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735268; x=1794340068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GkH4++dBijCXwD5VYEy6fAXo1cqRdIgNM8BgDbHwXH0=;
        b=cGASmqKCmVFr63/NL53bXaRqPcp5i+FAPODG3b7hy+j2l4JFo41V17hwDtST2XRurP
         iw/Tny7tfW4e9wTLfGknXgdGWq+03QMwa8CYGBTm7y9uLVQqNOGfpLsN1ser2sAeOhqq
         vrpe49uQxzc4452cSUGxE3iFw04o+FXKaceqpKV4WjXg7c7UpPsFGoXDT9mxLxNzBBiM
         C2JF3FVJW06nmjIDx0QX5oM8MbKVtGLVy95mUjpyaAptDHglMh/b0clzQqVA3BE4PMck
         /ZxJtSdXwvbZo4DR9DaOmHyWlQ2Er0hR3gZddl0hw0iz52VKjDIUXfND8asiLHPP6zcp
         1oGA==
X-Forwarded-Encrypted: i=1; AKwUvBx+DhoRYYD1W9mYxtqgQbjncMC3768TgPafVJQeWQsUZpLsakE7MEvN97jutyWpQqowGGwEiYYQwHbOdw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9kdWKx/o/1w7/LTMDJGFQK0T0TnKxnO6nxUQGCTFKpIfSZoTbT
	rE+WmOwrvGaA6+x6KhiV/9EAscEKXDL3R+/H1O6zSGWoKn+bnvD1ulzF
X-Gm-Gg: AYBFou0D+VedIg3q+E/K5u4Vh/cn87eWd4SIV0bM118NdGsCmfsY+LUS4gMAvdKNweq
	LQm2x0ovBTi3fS1cLanm0JkUrTWCnhO+9Zp1RHz9/+2BwE0K+9uzr3h+TXaSJW/d3XY0WTvNoXU
	YDoa1Fdg7eGcTLoBvKvsn7LC7RN5/y88WCsNFJhOBseVC+gBubaiHTjMXPUdicgHjX8LUtyO6us
	DIYykqBtCC8PRWdmVxRWHEsvWuJYweOyRrXGsBLB0gL5fBpZSY5pkx8m71YCx1gckdPA9m4PY7n
	Qd7egkLa8+Z+kXZiGO6RFjjh/BBUJV1QEhUZRtQ/1n2m591W6Y6XFUvN1zbjhZC+SaViAoxRLZs
	4erYdB8qnC8J+FXBzJ5YitIsdkT+IqekAKf8zw+RFsdO2cA41hDKNWAzoZzfp03RHMeGqAXNZNu
	/mqqJ+n0MmTLB+rs/wYIcZ5BFaBVC+0K8Svqbbi253kLx/KT/x3Sh69J4XJjqUfI52oXIf5vkmE
	yJEovKpLW6WXm3orhb6tYs0NKmnuhqhznSod7m4dG/uVLbwQS1yZJDPu2HWpEjRmc2ckpHuNQTP
	gOM1kdLQtDPyG9GoPH/kP7yr
X-Received: by 2002:a05:600c:1387:b0:4aa:2339:a375 with SMTP id 5b1f17b1804b1-4ac1793fa6bmr336065455e9.13.1793735268364;
        Tue, 03 Nov 2026 11:47:48 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a879f401sm76832035e9.5.2026.11.03.11.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:47:47 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 3/6] btrfs: add per-inode compression levels in xattrs
Date: Tue,  3 Nov 2026 20:47:31 +0100
Message-ID: <20261103194734.598182-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103194734.598182-1-koray.fra@gmail.com>
References: <20261103194734.598182-1-koray.fra@gmail.com>
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

Add support for specifying algo:level using
btrfs property set /path/to/file compression "algo:level".

Add a signed 8 bit prop_compress_level property to btrfs_inode, which
can support from level -128 to 127, plenty for the currently supported
algo:level(s).

Change prop_compression_apply() to use the already present
btrfs_match_compress_type() and btrfs_compress_str2level() to parse the
xattr, using a stack-based buffer and memcpy() to convert the
user-supplied xattr value to a NUL-terminated string to be used by
btrfs_compress_str2level().

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/inode.c       | 10 ++++++++++
 fs/btrfs/props.c       | 31 ++++++++++++++++++++++++++++---
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0782f917fccc..58ee9bbd7b5b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -137,6 +137,7 @@ struct btrfs_inode {
 
 	/* Cached value of inode property 'compression'. */
 	u8 prop_compress;
+	s8 prop_compress_level;
 
 	/*
 	 * Force compression on the file using the defrag ioctl, could be
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0bc668c9ec88..2078a3b004fe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -945,6 +945,11 @@ static void compress_file_range(struct btrfs_work *work)
 		compress_level = inode->defrag_compress_level;
 	} else if (inode->prop_compress) {
 		compress_type = inode->prop_compress;
+		if (inode->prop_compress_level)
+			compress_level = inode->prop_compress_level;
+		else if (compress_type != fs_info->compress_type)
+			compress_level = 0;
+		/* else use fs_info->compress_level */
 	}
 
 	/* Compression level is applied here. */
@@ -2330,6 +2335,11 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 			compress_level = inode->defrag_compress_level;
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
+			if (inode->prop_compress_level)
+				compress_level = inode->prop_compress_level;
+			else if (compress_type != fs_info->compress_type)
+				compress_level = 0;
+			/* else use fs_info->compress_level */
 		}
 		/*
 		 * We need to pass blocksize and not i_size, otherwise we can't
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index d196b73f4ffa..effc2daa2e3d 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -332,6 +332,10 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int type;
+	int level = 0;
+	int ret = 0;
+	char value_str[BTRFS_COMPRESS_PROP_MAX_LEN];
+	int level_pos = 0;
 
 	/* Reset to defaults */
 	if (len == 0) {
@@ -351,21 +355,42 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
 		return 0;
 	}
 
-	if (!strncmp("lzo", value, 3)) {
+	if (len >= BTRFS_COMPRESS_PROP_MAX_LEN)
+		return -EINVAL;
+
+	memcpy(value_str, value, len);
+	value_str[len] = '\0';
+
+	if (btrfs_match_compress_type(value_str, "lzo", true)) {
 		type = BTRFS_COMPRESS_LZO;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
-	} else if (!strncmp("zlib", value, 4)) {
+	} else if (btrfs_match_compress_type(value_str, "zlib", true)) {
 		type = BTRFS_COMPRESS_ZLIB;
-	} else if (!strncmp("zstd", value, 4)) {
+		level_pos = 4;
+	} else if (btrfs_match_compress_type(value_str, "zstd", true)) {
 		type = BTRFS_COMPRESS_ZSTD;
+		level_pos = 4;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
 	} else {
 		return -EINVAL;
 	}
 
+	/* Parse level if the algorithm supports it */
+	if (level_pos > 0) {
+		const char *level_str = value_str + level_pos;
+
+		/* and if user specified it */
+		if (level_str[0] == ':') {
+			ret = btrfs_compress_str2level(type, level_str, &level);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
 	inode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 	inode->flags |= BTRFS_INODE_COMPRESS;
 	inode->prop_compress = type;
+	inode->prop_compress_level = level;
 
 	return 0;
 }
-- 
2.56.0

