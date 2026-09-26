Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09EA382F1A
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443860; cv=none; b=mFar31Uq6a7YG7ARReUkCW3Hy7AN2WnR9TxK61jgOiUHpDK3Exh4FiDxzW3JubnJo6YYjFEk4UCW37Ew459VbzG3DPHRBVWNurOlIao+Ex4uoRxMv0UWX8BkVx6rD79mY/4eQHmgyT/kUfLC3/FnfakXnEWRqx/J9vZw3VFFo34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443860; c=relaxed/simple;
	bh=mo+M4WxlVeudge8H+ednqjMf1xNuskB2V4NIJYExa60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKrBTUVAkPSLabjvKGeeo7PuHcIJsYcVNCztB/hO1hDuh/NIFwodryuP03TY8JV8exkk7JZ8jvJNtQEoK5iQNPQVWgsAarhlL/AD5q6qi+FLiMAL4vr64vLQA6uCnvvl/rpcDF11GArcut2Krm2ODGWDNpvA1z05XI2Bld1f+Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lo/7VuKf; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lo/7VuKf"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c3ea1f6so975071f8f.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 10:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790443849; x=1791048649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5cl10t76VYkno36ovaUOcHrrjyEAaNIH7dhahegRDZo=;
        b=Lo/7VuKfeEfvyn2de3ZYD784Cq4y41JR33cS2axepGLpFbmBUJEcDo9UYlQ2pEf395
         c/mV8UmjMzeL0gGyAdovy4Os71tPa2vl85rnlv905vZkzCs5gmRDGMf0KHye03JZFBRK
         GYbpaRf0cFJyN0DqgVT7YhkUvQpJTnoSLuDVjuE6uEtLc2ImKvXYd6eK9bCW9anlnbjY
         6JkZbDZ7vP/daybP0PUxzTzgJW8lq7Se+KVmC1IeNIh2bhUVXy8SmQ3eTWQ7/j8uQcRc
         UOO2VmmtykNe/rcjQKsQtGR4WuAWxyzkXQvdp6Sq8VddDLrMYGP+U1sa3eocPR81vWYG
         pjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790443849; x=1791048649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5cl10t76VYkno36ovaUOcHrrjyEAaNIH7dhahegRDZo=;
        b=a+owGfkylOgtN2+LMjMi8jaaGIdiXJjQGV5/r/Hmim8yxyjM2l/xdEHXVdIzfZMxJl
         h7yV8WJXZe6UPclEgO/mNWcpu/N1PYhIo5yWNzEow0gMKsxLmsrp7JO1vAvClrF2cmE5
         J+OsE/gB+HPouht9PZQp1EueZsCiSd2JNDTEJu3kP2Yqvvgz97cTF2nq4Ndxqpmv20V4
         QD9CrCRSo5TYkxpr4d7rWg0ZwCkFFo7sYHmGUKmpa9ESo3uhQXXh6qVLj78WIfrwSmlH
         bTXsEs7hc3yOBsn61vTAzdtzceK2T4ZWqUqOKSrHWFyGiXp47f2g2xI+xnwj94zcmCvq
         u+Kg==
X-Forwarded-Encrypted: i=1; AKwUvBxKBngEX4TRcGKEWW2cBu4xi/c/PTHddYyGgb05Of7fY+icmDL9FKRGIk3NjeHJ36TwyKXe6B8vqiDlZg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJa8iD6eYhi0kFEMvkUwQ00KL5ezzL8btDnkKKU4weJQyTTJlZJ
	VYMcr2j6T2QQLFMEMzIYgQ//96IvshKXXwaJDuwVubDGxsGstAtKD1VB
X-Gm-Gg: AYBFou0jemDBj7P5oefkHbnXM99G3odRgjhncm9Cr86Lsr7YUKM/5RavVnBwTR3kiYa
	rXQLAJpRCTh5KGtxQf6ZikwVVDPfeMGEqwqL77SqhIOzasUGk2jnfBFJ/qCtdcmBoLilrJKkZ7u
	MjyW3XWvo6toEBeGU07n0t+paDdZ10KbDwb8viDYuEZCg6nR5clcdccjI5vB/BYU2vDjk14DTQF
	kQoeePg9+blxbFxttYyQ72Q4FSgDkt9vYyBULK8yer97UrwiOfpoWLbMRpmMLfOVxOlM0PHfO8i
	c/Lj1MSf6vbG1r7aBWDqGHGjcnPRZYtByKMrDGZhS1S+CID3WTD0yarX0QiMz159bYE1MXxRCbK
	ZAESjAGCsPo1NmwzYECeRUrM6vpUzx4BVrJ7vneexxhudRbxHyXbR496HmF9UlJorZcGfO8J9ae
	sXKA0/2rzodFr3OMkRHL1T0BcSOXfbnL3aSLaMwnuwt91I3+By5jRl9iw1biJICbNVQw==
X-Received: by 2002:a05:6000:260c:b0:488:823d:5060 with SMTP id ffacd0b85a97d-488823d52d1mr7731612f8f.48.1790443849188;
        Sat, 26 Sep 2026 10:30:49 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a84221bsm15255859f8f.36.2026.09.26.10.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 10:30:48 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 4/6] btrfs: support inheritance for per-inode compression levels
Date: Sat, 26 Sep 2026 19:29:34 +0200
Message-ID: <20260926172936.337085-5-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926172936.337085-1-koray.fra@gmail.com>
References: <20260926172936.337085-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change prop_handler's extract() signature to take an output buffer and
its length. This allows for the algo:level string to be generated
dynamically, but now the caller is in charge of managing that buffer
memory. Before this patch prop_compression_extract() would return only
the address of statically compiled string without being able to add the
level, now it concatenates the level to that statically compiled string.

This signature change is fine because the only currently supported prop
is compression, so there is only 1 extract() function.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/props.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 7b966b9e4c8d..1a6b0103bbfa 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -36,7 +36,7 @@ struct prop_handler {
 	int (*validate)(const struct btrfs_inode *inode, const char *value,
 			size_t len);
 	int (*apply)(struct btrfs_inode *inode, const char *value, size_t len);
-	const char *(*extract)(const struct btrfs_inode *inode);
+	const char *(*extract)(const struct btrfs_inode *inode, char *buf, size_t len);
 	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
@@ -411,12 +411,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
 	return false;
 }
 
-static const char *prop_compression_extract(const struct btrfs_inode *inode)
+static const char *prop_compression_extract(const struct btrfs_inode *inode,
+					    char *buf, size_t len)
 {
 	switch (inode->prop_compress) {
 	case BTRFS_COMPRESS_ZLIB:
 	case BTRFS_COMPRESS_LZO:
 	case BTRFS_COMPRESS_ZSTD:
+		if (inode->prop_compress_level) {
+			snprintf(buf, len, "%s:%d",
+				 btrfs_compress_type2str(inode->prop_compress),
+				 inode->prop_compress_level);
+			return buf;
+		}
 		return btrfs_compress_type2str(inode->prop_compress);
 	default:
 		break;
@@ -453,6 +460,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes = 0;
+		char buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 
 		if (!h->inheritable)
 			continue;
@@ -460,7 +468,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		if (h->ignore(inode))
 			continue;
 
-		value = h->extract(parent);
+		value = h->extract(parent, buf, sizeof(buf));
 		if (!value)
 			continue;
 
-- 
2.55.0

