Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735268;
	b=XVg8Df9KsNYzT/KsgBDRBJqAqdFG/85TxnFZZiP0/SbGSbuoZTx2mM6qv/PoDBKi2TbN
	 UCUbp8JhwG1yS8EfAB1D7YV2uulfkAFH+fODwxvMSC2GMnooLmBCmhkvyKnnnVX3oEhIN
	 hZ7DvZvnEKXIwknPRrRKIPS0i9fYu+2wPhusLTYyLxGERvf+PkRq+0cXsXDioSdDfd15h
	 W72BW5eiIdJbvOTEX7VtHHGPgl3nHff9TVYgxGJ58Cx1UtDz4eJGZESXTKWVtMERPh4YR
	 PQ+X/Q1IQ8EeQ2X0ukCDwD+jQbUbF+vheZ4v3rIi5XLYxgzDyf62g071lAKzN9pwTkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735268;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WGtTYsgHZU2Xo1JHDEb/zFgOTE/Pnd35ZkM7zjcF8u0=;
	b=0wc/HPFWZZPKdg4deanMurHVYJkrb6etXWzTwq0AFbRoVAwnsNG5Ci4hidP4ZYRJ/rLV
	 9/tgGzQXO2q7WoLTOx9VDy0ZFprZeLtV+bDcpxrGAXoZANia5JfU48pqbkPOY3bj1cy2e
	 55B5eQ9yUZC0km5Pee4Bhk1msb3pV1JFgS8OOFOqYdvsTsdYGBcCRc75vY5TjT+FwRKDW
	 eRWKyo9oprsNMTBSoajhnW3D4QUjDRpuUZy19tcyZNZDTJ9NObPorXZeJ3Ht4Ynf8IMLU
	 7EMa07N/xwI1Yp4QmvnBqBx6ANKntTRxBGQ9ZsVdyItMvomnxXHOCAUkyPKZofTouXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ooERRIwO;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD698606A32C
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 19:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD698606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ooERRIwO
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so34813245e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 11:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735266; x=1794340066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WGtTYsgHZU2Xo1JHDEb/zFgOTE/Pnd35ZkM7zjcF8u0=;
        b=ooERRIwOC7Mug9/M6vIYZOsskMRLm9D8MMXDqxkKiaqCb4LT9L8OPesM3O3C+AjWqu
         eiPn398cXhe3rbdkvtkJhG71SrcakIzj2mVB28bCSQEHYV0zdFJxhg/7lquDf0h9nIGW
         jqwKLGoXQDAcp2EGH5h81Z3C6wb0AcTEqRsnPxkgKjtXoXYsLCVg13vDZDYhe+pQ3dLl
         W9vP6Y7Le0v2euasbdqdrfA26Y+khnDVFjMAczVpMsk32MAMexYD2egmzK+TmVHPK7t+
         25snLZIXh2WygKGSIiJVQyBCr/mhcBkmuw7828gehAI2CJ2ApXJBpSPZtFdcIxDtitIQ
         t/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735266; x=1794340066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WGtTYsgHZU2Xo1JHDEb/zFgOTE/Pnd35ZkM7zjcF8u0=;
        b=q4E/wDM/i9JrtI9Xdj2A/Jt0E5Lc3qR9RK3IbMvDCsEuyDPmK1c6T6EjBTSn8g/AX6
         3is6LiHSHT8FcdUn1qYJ8aCAQXE0VnERtqRs+QfoAMIPcHd8QkOlklWsHi9bPVBKxlGf
         8ZKo5+pFjn+WD8x1oqWQV4CFFfbyUEl6xE/KPfKfvTI5jM/bLpGYUDXQ1y/2qTlRlwF3
         PIEHC4u/o8RIM/+Sld0C9apzZ7LIMoT7rZAB7w/C9Fsq1eYY13KXw3PHUIsdN/nriaWs
         A9CcobZXEJxYjVf20wLz2sdSdim0j03iuDecx+v3lVJYpi7Bl3RXmfJmDMBiQY95sf1N
         UdTA==
X-Forwarded-Encrypted: i=1; AKwUvBwbT9H489Cz9YHfmlsRgdHO1LNdbcmeKiyD1AVCh3/80KQi3KqGuP6Ebarr9iU0y1XCikWkbTK3FacO0w==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Rm4A9ybAYZqG/A6/I8zwPobWC+tdKjwg011FkyTEBF0Ke7kho
	uN4ZJ24EgaunABlGS+K/WyXHn3VFHyqo+SYJ90sKldkkfUvE5pW5IKAQ
X-Gm-Gg: AYBFou0XD02A2HFGkKV7cCAmWpDNJ0dxLfEW5ZrgFhoT0nQNfG41I0lA47iewKmrvqL
	O8S8z4TOcUsHt9bDqAV55QZYYTVSfDqIPmlY7DBwi6zdfL/r1zjHjBi/mlWLOnQQq27RDzQyEEr
	HeLhYMCqypIA1FZXJaA329F+4a002o50IoD4KKfTQC6brOurJ/ox/lHXlIR5mj0+ayC7e+zNHFG
	frzFB+8gwh7F4C9oB7n1fzFe8zcKSH+9PipcbRU40/rVWsRR4mxnHplcOGy/wYqLaoGm43u8BN7
	0jq81NsmTGmuKrzG72GQKS2zAS/wDK5ctmwFRMiGGXZxi1qWuVzUgtUNcgqZGaVQ21TF9xPTWEv
	qqJ+jhY1j/6QOXQHUThyzctRj2QnvypYExiBFvA2tO/sNLDZSIxNxMPr1GybxFd4tXowm3wNzO8
	BIsORagwGgCyBmA873MetGzG3joPYhf2pUyf+Px0VnXAEAYA1ylYYZT4IQV2h+mmIGau8O+zm9f
	jAOTW3Cr5eox5JaVxv9GRyFF74QEyuPpgs6ZnJgFRnuD6iIPJI9c8w9nJHYhejwZsRrjJdaVIg9
	Fjc2L7IuzbDCUPs64EIK+6p7
X-Received: by 2002:a05:600c:8581:b0:4af:29b9:32d0 with SMTP id 5b1f17b1804b1-4af29b933ddmr181477455e9.32.1793735266059;
        Tue, 03 Nov 2026 11:47:46 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a879f401sm76832035e9.5.2026.11.03.11.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:47:45 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 1/6] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Tue,  3 Nov 2026 20:47:29 +0100
Message-ID: <20261103194734.598182-2-koray.fra@gmail.com>
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

Export btrfs_match_compress_type() from being a static and locally used
function in super.c and move it to compression.c, exporting it in
compression.h.  This allows it to be used in the next patches as
validation for compression algorithm names.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 17 +++++++++++++++++
 fs/btrfs/compression.h |  1 +
 fs/btrfs/super.c       |  8 --------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b12b7f1b31fd..9f0e42424e86 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1646,3 +1646,20 @@ int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret)
 	*level_ret = btrfs_compress_set_level(type, level);
 	return 0;
 }
+
+/**
+ * btrfs_match_compress_type - Check if the string matches the compression type
+ * @string:         The string to check
+ * @type:           The compression type string (name) to match against (e.g. "zstd")
+ * @may_have_level: If true, the string may have a level suffix (e.g., ":1")
+ *
+ * Return: %true if the string matches the type and, if %may_have_level is %true,
+ * has a level suffix, %false otherwise.
+ */
+bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
+{
+	const int len = strlen(type);
+
+	return (strncmp(string, type, len) == 0) &&
+		((may_have_level && string[len] == ':') || string[len] == '\0');
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 1022dc53ec51..e67ba47b4cdc 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -97,6 +97,7 @@ void btrfs_submit_compressed_write(struct btrfs_ordered_extent *ordered,
 void btrfs_submit_compressed_read(struct btrfs_bio *bbio);
 
 int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret);
+bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level);
 
 struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gfp_t gfp);
 void btrfs_free_compr_folio(struct folio *folio);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b424cc836bd4..372d4e75bfb6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -270,14 +270,6 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
 	{}
 };
 
-static bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
-{
-	const int len = strlen(type);
-
-	return (strncmp(string, type, len) == 0) &&
-		((may_have_level && string[len] == ':') || string[len] == '\0');
-}
-
 static int btrfs_parse_compress(struct btrfs_fs_context *ctx,
 				const struct fs_parameter *param, int opt)
 {
-- 
2.56.0

