Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F16C34F279
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 02:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156529; cv=none; b=OvEd0wZQnerTOr2tBR4hFGG/j/qvqxLej6WmYDhDhzV40V9PCPJ0s30eLNUO1Iv5RYmhMFIO0XYaojVSGFezL/G96Ig7eTJG01EMnVZnh7intYaPVY5FjPjMdL0SajxUcsCKQEvcJTM8WVyUcB4xVr4F3n/p06hzsL3bPb6OAGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156529; c=relaxed/simple;
	bh=rgwwk8h2kcu0I9U5H0VxIqoNO/XK3wsadyz7Pcy6oww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm1vLQMzX077ED1+COtA0efi2gVHdVpOJ/Q8laUTLMbsOk0Je6MkQzW179Ag7yQkR+r/e3SZrsHNnPBMftmXslxd0FMi1jy3d84mdzhwpns/DCF1GVMqPwQkVnSffRrdanJM9TPdFHBlBxZ6gfCBJ2z+LRm0ST1ZkPJF/0WEMUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pADMLB5+; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pADMLB5+"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso51883f8f.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 19:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786156515; x=1786761315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q05ELsrdWqLVPwB++0TpI3dK42t/rnrwbgPlEhl56L4=;
        b=pADMLB5+baHewPdMnxQiem4l1ggv4c0NjoQtVObRpGZuX9qZRQgmg1MkcaUDoWQ+xT
         eN5pvOFzsh01Ccz2qKeLyw2HnRopJEEJTOPJC/soSPzCI6JdAfO7B6IILHvDwl6bsrtn
         TyqYQHG0vMm4gjcPPU7DLLWjDRtnU1OEQH3vd6Auz8zD5iAwa+zsTlsjQKUg/X9OoyyC
         OxQ1OHbI9hvAIsRZRvlgeyQx5d+R9qeUgaD/V/gL5m81dJdzxkiZc0SpC+ENQ9Ch3HHX
         zsJKLhPn20/EeS2XzTczs6kaRThfrW3Qo9QomIZr/8IEvPTBEpt1wC9FiMQcQ8QoYQy2
         vJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786156515; x=1786761315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q05ELsrdWqLVPwB++0TpI3dK42t/rnrwbgPlEhl56L4=;
        b=qTt+8fojbl3BX1h3NrJY6vERpc0rMTLrSDa2hjPTB7nhkckwSllu9r42WOKOisjiEI
         IOtIdS8unNT7/3/ZNu5Usgb8JaKHA4RUxjxxyjPAO/kYhByFVSxQcmyyFLXB5nj5Cn8a
         P1ErpT4lWN32gm/RcmY6CULRgsvhXm8bQgHDzPPSV6twX/FTosLHAl7VNAZ9Yx8jsaRa
         AJPHAblfQSvPMX2IEPUyUZqhj0Ipy/NP3ZnOCNE8SHf/9gONq53jZ8sBcpcqYep/PrSz
         AHpnWsiD8yBb51m5gUlONxIXjyX4vMqqZry9pZujck4VJoRP7IRCizCl7hubhRNqJHvB
         guhA==
X-Gm-Message-State: AOJu0YwCRtQbVbldJb1mfM+6CuelaedeBlmo5npyU1lOhBMXO7Y8PrZx
	us4dUwum546iUTBkAO4bCkYPF0GPO46W4M8WWlCpBszmBMTs8WQBYNxo
X-Gm-Gg: AR+sD1137MAgvzmUcNhO2ZhlDLEaZ39k4jqXpLDfc/l+ekUY6SZ4Npb/kXfq9lk6Mx3
	x3GXQha5vaZdhwp70S2MPm/vZVDm24jafTcFyGW+ue70RuwEX8AoxPoflRrs12oobsPA28eWGUa
	3SGGq1XqE6Xwh3luiw/Ba2Zu6fTZFkqfrsRgpwBfygZblLy5yGlBN4C92Vlyg8kbvaB+3MSDPjx
	TjWZA55TZGYlMfktGLatJRzNPk4zX5/iZSCyWDQlq1tS0Cxjf5pmx8MpJuivGEJOzVAKZMMU1Xv
	Y+k+tgMWFTYfKK61I/+TkWh2Nhdr+m4BuQqIc2oeguEiUIqLesKMr7JfyvcFe/E0IzFLIPKs5hT
	tcwl6CoGAYcgvWzBiYu0x5p30qIDHh9d4gPKEHSiTMoADjcBwdezo+MUaGjw0cSJh+9150rv4MW
	uHexgcNk/51KSHspPe2gW/STUxahYDIvEU16YIh2EK1zXpVt/tRTHOoR4=
X-Received: by 2002:a5d:4b50:0:b0:47f:aead:f81b with SMTP id ffacd0b85a97d-48130ee376bmr3979692f8f.21.1786156514830;
        Fri, 07 Aug 2026 19:35:14 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800214557esm10571244f8f.2.2026.08.07.19.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 19:35:14 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 1/4] btrfs: export btrfs_match_compress_type(), move it to compression.h
Date: Sat,  8 Aug 2026 04:34:56 +0200
Message-ID: <20260808023459.1494928-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260808023459.1494928-1-koray.fra@gmail.com>
References: <20260808023459.1494928-1-koray.fra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export btrfs_match_compress_type() from being a static and locally used
function in super.c and move it to compression.c, exporting it in
compression.h. This allows it to be used in the next patches as validation
for compression algorithm names.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 17 +++++++++++++++++
 fs/btrfs/compression.h |  1 +
 fs/btrfs/super.c       |  8 --------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ffb6b52863a7..58138f300b58 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1660,3 +1660,20 @@ int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret)
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
index f4e34898d581..7a21085c33c5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -264,14 +264,6 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
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

