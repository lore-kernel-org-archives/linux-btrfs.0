Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BF92E7F3E
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 01:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786240304; cv=none; b=elUZBD/QFvdUzewZJWZKTxysrtDXVf+YCR2QdfmgWXfz7WFu3zEC0CVc/PcvtyYDyROkpbptbpFQYhXybNqiy7cwUpA17dFkaFNims3VAnJpxFMw2lfumQNVDfFDTOBmKjjbfqfS7yRjAvkDFdB78z2/QG4QDW+SsiCD7T72N/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786240304; c=relaxed/simple;
	bh=lCUEbcQkQ7xwBOMY8LPO7sW1p0Qnj7dJC0KvmtRDMKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLb/rhJAfzmjzdkLRgoZZymtxJgLk4vcVtW5uB6/zUZgASUTmhAMSgTdjr+VDJRwOq+mCHZ11si/pbZAWaGjKXWcPDNrGN0RwZNF2yzsuVDykb15l++ZPZJvqH2K8XjuKtPP+qwilS1zIy62ES+Uyt9E2XCLyjRDIxnVCBdSI9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tKwtwmcU; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tKwtwmcU"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f84023916so623953f8f.3
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 18:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786240301; x=1786845101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uKJ/if92pdDDQvTLmJZBQb4UirOzDLEvc2DY352+aBI=;
        b=tKwtwmcU3hG5mXLC3QKUmkZL567qMNgoLc0H/meXIKZZrbldKngCGFuTqXcKjokRwH
         /UH8wpsvYFMRG2G/VMQ5EIhin/5MM+l4R7rpXpBD/JEojYveVJdcqKm9e+Rriv7Ef3Za
         wje95v+3Hsv1kIBe6MEhsU3Nm2W+Tekd/ap2kKnYIsDKDtM2v5EOyvjDBMg/0VFfU5rj
         peoLBQs82bEpW2/DOa38++rmIypNK+iB29I6lH0NoXyOPKRpnDHy2+m6Yg9mjmK1jkAN
         2L/zZwOypHITmP9JmPuTY6/g8fawOo4HLPJ4//4J6xZn/ShvtirrWlXGrkknN28zkmb5
         JeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786240301; x=1786845101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uKJ/if92pdDDQvTLmJZBQb4UirOzDLEvc2DY352+aBI=;
        b=tRJipipEhjucEUAkome5bLolzbNcgo5afMbCftqxxg9qYBXsAZVQke3q5bFU1cs88H
         yRSSRGhv2HJpDqOSsuASwmB0rAjxUBCJbH80/80F9iacnSblEhVbkZh15BBIIDOJEnvv
         8asV9W6/DNkXOc/K+RCQba9Ev+u0Q7yEsRhSXnDxVIhyGengw+elOdF4jaFC0M57VQ2v
         pKjSLOSKiYOEpTeK7lVaeddyJG9EZkdNgLUBLPPgzu4LFJuuSW7j+jiSQWJMqSWUZp9l
         u2yRvdMJGZmeUhxXJAIg4mNTzD+YLyAWd8wadOLIufmabMPL+HFdBY9zMDBOapp1THjR
         DCtA==
X-Forwarded-Encrypted: i=1; AHgh+RqyhsF8cq/ZCZ12dAp0UbZrk/c/QjOeLN0E3jSIkIiSWUgMJetdDqqVDbv9x1/agBFO98A4Joj6mohmvA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhgJI2vtn/247PPQ14lizI017bJDzB/XaJfW1FzXNh4fHD6YtL
	C5Tr4jbcCXeo74KxCrjqrtdlP85wzwvfdrLBaEYydgGcRLokAr9RuLMN
X-Gm-Gg: AR+sD13HatUrctQu6MBwV8T6CdTXeCiVGxZE9hSQGQWMKNTVwV7iGDaPHU+xQxQJbWd
	BepIG38SDNCQVlw3GnwPWZ7SuN5p07x49lLwRrM8pYMOH3pr6Dy3zAzz9YeaXEjT+jX9uSXs37i
	1clOfRXcFIxIkf2t7WpwuaJmdsMdxteTBA1OaeEdDFlcnl728bxd4E6PPAqkGze8+YK/F4pyyX8
	7z11IhwO2tlPjSmTseK6m3zI0Ie6lZH91cICrUNjXYROWr15HGRy66XEO3x98wCoSs6QY1nHBON
	7ZfI+EQrKPITzD+taT39ncSg5JTMKotPWReEf9frKbYkC9Ow1qYb91637JiL2bmP9/9s1uTONF4
	NuE4oA5MCNYs9iY/BYhgoQe538WCBbOw5WIgZAT2P/Hmf6m37a9pJJt2jWIhT+cMwG59aiBMshT
	da4wYDRs8ObCNVd8RyzYw9f3xNnmyc5SIZjmPrHh+EAWeRI0UG1L9vYxw=
X-Received: by 2002:a5d:5e91:0:b0:47f:fe22:c141 with SMTP id ffacd0b85a97d-47ffe22c1a0mr29557852f8f.30.1786240301371;
        Sat, 08 Aug 2026 18:51:41 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f90f8sm17155676f8f.26.2026.08.08.18.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 18:51:40 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 4/4] btrfs: support inheritance for per-inode compression levels
Date: Sun,  9 Aug 2026 03:50:54 +0200
Message-ID: <20260809015054.779137-5-koray.fra@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260809015054.779137-1-koray.fra@gmail.com>
References: <20260809015054.779137-1-koray.fra@gmail.com>
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
index f79a61a2759f..9c97792800fb 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -27,7 +27,7 @@ struct prop_handler {
 	int (*validate)(const struct btrfs_inode *inode, const char *value,
 			size_t len);
 	int (*apply)(struct btrfs_inode *inode, const char *value, size_t len);
-	const char *(*extract)(const struct btrfs_inode *inode);
+	const char *(*extract)(const struct btrfs_inode *inode, char *buf, size_t len);
 	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
@@ -395,12 +395,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
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
@@ -437,6 +444,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes = 0;
+		char buf[16];
 
 		if (!h->inheritable)
 			continue;
@@ -444,7 +452,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		if (h->ignore(inode))
 			continue;
 
-		value = h->extract(parent);
+		value = h->extract(parent, buf, sizeof(buf));
 		if (!value)
 			continue;
 
-- 
2.55.0

