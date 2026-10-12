Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28EC4D37C3
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 19:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832077; cv=none; b=b91OqMdTGmb4MuyKyu43H8konnXmDUe35Ld9RdoYHIMItqXYL7Oh1I1PmE/omqdRuU/glX+OYr3y2fOnh8+rLFL4V6FufTpcxN265a16ZIkoNIxRabEItFs3+MKLq/PEB/zpco8Ffc/A7L41ZxNhm6fu+uDikIjcw/Bn74iayig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832077; c=relaxed/simple;
	bh=mo+M4WxlVeudge8H+ednqjMf1xNuskB2V4NIJYExa60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB2RjF/8QVs8g/P37r4/Zl002S2Yvum/Qd4Z0RI0xjxtiASzkwx8a2sUWrAPIh+LhsStlayYn7FWfFJLBf1ubDxJWaL5fv1WslGrdguWFgzjtTqk5xCTodey2/ci8Wy2RZdFlKrOicP5thsQDQ9Js64n/z76gkJom9x676Ld1hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+mkZ+oQ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+mkZ+oQ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a16bc2278aso15170415e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791832074; x=1792436874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5cl10t76VYkno36ovaUOcHrrjyEAaNIH7dhahegRDZo=;
        b=g+mkZ+oQ/pMi8A1iKLRO/IUChkiau31w0LIU3IkML9K7CcCQ53X+kfESQ6ZOsu+Ijv
         Osf6KbdV4nD38hxoAiHBPbSFtlOUIWk3/3gyFabVDVt8ipY9Zpt9xMNAnR6u8yKqjpZ9
         VtC5z+eBEEdIQrOwStA37p/Dnb3cbNovPMIk45lTg6xV/HOzqAIFMnp/yFz6AKk9V8zG
         nz2KBWak9HxohsnmxrDpMPuJF4xfikSfUNHwe7eGr9NUrVhkP9zFqa1clwJGAP5issHo
         tWHH+fONXbdw+FDt/q+u4j7QPv0EmnWzcmqvzCAj4smu8X9lSU6DIPmwLERFdv7Bvl62
         QXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791832074; x=1792436874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5cl10t76VYkno36ovaUOcHrrjyEAaNIH7dhahegRDZo=;
        b=q8ttIZhXf9Emo8LyFYfrBGlezHr7g2Mv5GbzcIPNzNOfJcoVvEUcB5wQuifb0k0jFH
         ODet1ie1APw7YN06iWCt8na4ak4Tb/YOtwRDZlhGRI6VKjRVEDZIphzzfvTwzCfkDd2m
         70QWgRYsz2b8ztPktumrxqDXgJLspnj30BRpuvuifcUeJvbqo92YcgjoYUrk/c+ImBjQ
         YORphvZAkRJbfLoJnG7Z2ekOQrbRXCgT3mL233nhhzFfxJJLT9SikiD1hcCxwHmZQS6K
         NabGzZZmoApp9I1RdegqmfImXfjfD7kRQuvVC7jF1/5sJXKgPDHHMB9V2Q3ZYqSm1cZs
         jZnA==
X-Forwarded-Encrypted: i=1; AKwUvByVAh7D/Zj6SXCbUaWJUfVJVqlAD5va3AwUyvuD+3ZuyzyHHp98G/YFxJhe6ifJLYGsZJ1FmAT0kxhWKA==@vger.kernel.org
X-Gm-Message-State: AFq9FYI1ketKNMfY6/JJ/i0sICXSRfOmFbWiYN4YVAs2kTCJwqK1eLtn
	n/6ddcyjgpVC7nrUmo/w3LhaDC4LqqV40y28svBEOjKIsLzQ8UivqVY/
X-Gm-Gg: AYBFou27XKwSGAR+28Zul4aLzo816IhmiSzYyTCLpKmYzWC+6jGyhhqfeNOd8yDE696
	wSz5/K5wslH3+3ZYFNBB7sD8Xc2mJIPaj+aofsAeXxtrtiUuO0Vv5x5pkKHs3FObqxSFFMVe5iM
	B4Ltr8JkjgTb9j7P/qzFmiXGp3sknV5+F3FLnobkjOTrTkEpG4caJhXiC3ab5BPkR8Iipp2KDlY
	ecjSj5LiyTko5q3OnbHIjq8nlQRkZuk0+4OUFU6FMMIe2DWJzOuFCOxGOakqwWZ/SRt6+A3XdNZ
	jDRuOjEly77zXDWcC7TDJ6ZTpyszcXzUKCw4JxfVbTugwlRwzb25hMc5cAahX6P9qcCe5vKF+dz
	PNKsDcmoHcMV6w7iecIRkwtf48MNtHeqPsKCh+Jg++/c+JMBPwHnGgFVm3zHku3OEET0wKSc56o
	EySpcYOFmc3gX6KUzvJ+2XicKyCl/dIElZMszJxWt4vHrB7ltWaCmWwR4NvWBLzC90Jg==
X-Received: by 2002:a05:600c:190b:b0:4a1:82cc:1e9a with SMTP id 5b1f17b1804b1-4a18e4b2b25mr199027165e9.17.1791832074293;
        Mon, 12 Oct 2026 12:07:54 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a195002123sm299461215e9.1.2026.10.12.12.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 12:07:53 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 4/6] btrfs: support inheritance for per-inode compression levels
Date: Mon, 12 Oct 2026 21:07:29 +0200
Message-ID: <20261012190731.951056-5-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012190731.951056-1-koray.fra@gmail.com>
References: <20261012190731.951056-1-koray.fra@gmail.com>
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

