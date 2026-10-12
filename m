Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9D44CC26B
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791832071; cv=none; b=oD4QDtB5wMJ4RV0xZv+qsE5tbZi4PeQO/F3cfzePiYmMZHMfJdWlmvxFSQRxXuemdPQE8pb4wgBZe6oz1HPdxfzvTTNqExvx0CH5XsfpyNaOZJx+/8CsxWQSKORevGil0uZPgldSKHG0rQ0Nlv2z8x6KlgOuriuTJ4sBEnIFk6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791832071; c=relaxed/simple;
	bh=e6LC3tUQXXCwZtdgcEjCOU0TcX3Mg7qaGsXLelZ4uJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suLALJh9VT1z4v8NCXaJVB5V2cm78Zol+Q0phTk9Kyufkph6iDkjZ4KkZ269u9BxUo6Jg/lBwAe5Ol7Ukb5G7U0hUVObr2NZaMds/NjGJMTTKpKDLZ9ggWYer1wGxd/TX/Poy9FwrTVh8/ewNNLHJGWneCO5jBkgLFmCjpqwVFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkDzUCEr; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkDzUCEr"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49ff680331aso17801095e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791832068; x=1792436868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1LqFFMvfYgSUPQU1CLhVEFwCrs0YsfqRy2cePq3vrU0=;
        b=RkDzUCErT1nskc9BnbJErUm4E66Eib2DEFxgkNBI/YIof6cIBKUXYaFz9GThS8cffJ
         ahYgpw+Fk4W4dW0viECwxCqYxIDgtZXJCoayS7thfJzv8Ww322GrvX2l8Qd2d3yQAjS4
         wOscnxZptH4Y5zrL6WwUCFOpOxWJjVJC3TbxzTXX/Kh7ibvNN5/PHgY86YfmXAn7WggD
         9Xk0zmTXP8/4n2oOGPsOe4FOFWuZCYsqQXK1lkNKakXTAOLZ/L+ZNOA1oBwr6PczdOVv
         P9cs7DWKbZicCxhu7trT/gYVnplgWvzvyDcwtqFvYquUrybne521x/FivgKdnsojAkbB
         vezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791832068; x=1792436868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1LqFFMvfYgSUPQU1CLhVEFwCrs0YsfqRy2cePq3vrU0=;
        b=M9hFYpAgkrS7qbWlQTETi/9g+aiMDBHfQ4dvYBuQT2oQzBcqWggWqB9CtAASrr+jcj
         33NZH8+DrOon0tCTUS9dCMnFWl4FlXScUSUEBQKRX30kKEQ1ym7x/N0YhAO7Kh6jhC2P
         DJJQbwazOMYU1aUFXwbf3p3D1Q4O1lWC/y61DNAdZ0g0/g64kKS4SiKdAXX1OOQ9jFO7
         HNXexFv1aO1RXPn2ovvOIoT5fgIfFtcCNPxl8lMyOc17sTzUyx+2V9unxCnHHj0RkAZK
         lhqELeWiN4cuu5euD6kzmw5qA+6eTqekPiORx9BHk4rr6xSbG4cSq40Fs+9ZeQ4L2Ez/
         CB4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxuo03zbN/2Qz2eaKNNv1krswCVnvR+5aU6TPQChMRP9l4QBwvHRfpYeUYpxTIU3J7I3qR6BREyUCe9Jw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIgLIpa4qp97tyQ4VubdByrwITCnHbrtdkZvQleRH2AM+IOBjov
	Rxu8/THTr8KkuB6BtdNx1Httw3m4bp75DS2DjE/bhSs7mOevktRC4QLt
X-Gm-Gg: AYBFou3Anram/K1o98HU/gneGcDTt7xPTac1UnN5/R8kYR7W1UJssaNu1xhiz51CiL1
	cPUcwxn/6AeIOPn4dlVcLiy95Ao9WAFdu7E8GorydwWNunVBQ1XkOUJfNUtXVyaXNx+be84jHUP
	AMD9XgoLdSq4NpbHdIiUXQGDlQw9xeriwINSVxQOXMqwii28Xvibmmu3jUyxJPgO0nvM01I/bdK
	oZj1URPROTaUpefa7ihYe+m+4li4kkhxgxrUhYwX1gnpJwZPgT4ah0EYkuuVfaXuHkbWyZ/W3Hr
	ymN8JBAtlBYtlGL24JicIMHbglPFjRTXCquHtWud/aX3p6HfgQbKYMhYWODvaG7mdbPny3a3YeB
	s4IBR/1UB8uka8S+gYbTST+C6Fm0VY6WrX8RTHGkHRXYLfTEAG38em6sMl1IIWLC4O2bfDhcmvF
	CQPjwcu6owddMJ+L0Ot8i6D7iUhT5qrFfqjKpt6ueRm+V7DfecJrOLCeFh3btGYMPlziU=
X-Received: by 2002:a05:600c:e547:20b0:4a1:946c:953d with SMTP id 5b1f17b1804b1-4a1946c968cmr95919815e9.27.1791832067667;
        Mon, 12 Oct 2026 12:07:47 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a195002123sm299461215e9.1.2026.10.12.12.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 12:07:46 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 1/6] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Mon, 12 Oct 2026 21:07:26 +0200
Message-ID: <20261012190731.951056-2-koray.fra@gmail.com>
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
index 20169d028961..2880ee1f80d1 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1652,3 +1652,20 @@ int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret)
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
index 464129b1b0d4..00452ed872d3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -261,14 +261,6 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
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
2.55.0

