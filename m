Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F4D2DE702
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 01:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786240301; cv=none; b=DU4U+ZqqPXKoRApTZ4LRK9IvLzj2aoeZ+eTJAopVbxZN0E9KO3mh8ywbMy03UHEcwyfFYjur7PbS7yNGaArs97YrgbJy6WfSMEL6B1HO3kpN/6fTCjIokY5aUky2ySTVGiIjsLE7ja0LpbkGvNhrnObfuC2eFoW0dUmoEQigue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786240301; c=relaxed/simple;
	bh=Cg3/OQDfXsmIgi48KMc54M7OzK2RX3z7+29+SRkEL7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIrzMCJeJWMXa/ismAmcIAIVJcm/+QUcWuAf5wKAEio94+5VaWZmbunUVP53jcb8w/VzdNOcyny9bnCkO8ngsYICW4KGnbjq6XW42LDmaxNYJGKO5pdSEtBZ12lgl0FhXSiLGs7ElRnjppYKHksCIY/wLhleKtvZ803GDqkmQ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ic6It/uN; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ic6It/uN"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47db714766aso1862551f8f.0
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 18:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786240298; x=1786845098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VnXCGLGY2a0lbi/irO4xK3JDq7ziQ8lQYUwadMJHPIE=;
        b=Ic6It/uNzSo1jPKL9RxQF4n2Rb8EISE2nrBYkAn/XolH2fAkawVbCuiIdtqSyGIKLO
         spa+/7QYypDhkBXh+Ww55/375IbgUxFGpYKv/KYBcfeP5rp2kv25u1Q7LdyfNLXgfK+a
         AO58xF0TmltmAdRelToJ+sqsr7daPqU3fJJ18T4ihJ3laA43PFL0elu2db3Sq4SAXDjk
         +p7z4F5brZiSkQl8m5OLJBOSN8mdkWXohz9XIYLMiGjn2G3Q7fDa0bu5EEdsXyA2Fabo
         RyoJ4VChImUkC7J/bxxiU77zOkCynhxc40DXUChlWtEFd6fnxBahrYcWZwi9BThYFcJL
         EmrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786240298; x=1786845098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VnXCGLGY2a0lbi/irO4xK3JDq7ziQ8lQYUwadMJHPIE=;
        b=Ljup/6G9cOqdQ4J0AYtvavbpAv78IcLSeeYtqaEpiI3ONF50l0/EyRKdHoNFDZT24o
         D7TbANBJhnCLou2oUJzGOlS4dNPXGQti08CdE8h0lzxfIbRZNRjdFVaaIiwQLoVkdgbs
         B9IHHAIMU3iTljuB+ijoxX6Uluq74YvXi24lrMvqlUrmWhHGOTiKjhlBh9W/gXunThp4
         rIgyvSkA1jAFSteAreZ9teP5iw019cGaQkMQ13IS6ecIBhVXHruKQIcEb5nrAvFGUXxn
         0pqxy5gJPOiKG/7z+XkoGLDg0GRBr1JOGzk0Qq693ToOuGkfTT8KV5ib9KP8QUuBjG/R
         qkwA==
X-Forwarded-Encrypted: i=1; AHgh+RrJDrUqMOGKlTitPx3cqi3ewR/dd14CwW7sLQEKFQpvF3Y0VJzJmbM4YTW0BETAHlHg0pTcWnSquPy/lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdkLvFEtkx7YVLAt7Y+9GU0832r9bOoPSvB4dQJqiqRp6Clvv/
	0zElXJifPZJA3oiuN//3qTA2dcfxhHFic9d/A6O3q2oFFhMstfP7WV/6
X-Gm-Gg: AR+sD12PIGZKeFSCdJrbIghfIeBM8ZHoHnf3TNehJXoCVow6HaihSvDRO5NWpVsF+2D
	uyeRjGoE4pSzQ1shacnj6yQ12T3zvekrmk4vioaYVHzxe51PLcceVO38HXsf2c8RAP3M5f9G8d+
	xYb1wBqp+cGm11ieU+3ZhC79hfDFgGPjCsmu6SlnGQsVkKxft97wKlqkjryhYFHO8a48A6B+w8v
	fsdfN93NYjR+KUhh0HIEBzfTl0VJMeQu1F5RZAQv6MNXJGpjmQ3exBl83bwDNOKpSuEp8HtETN3
	J2HNbv/I7XNkM8GkD7dEHBgSIzMuDEBcO2DRjdA6rZOnaYBirjcveOHB9gC8MPmzmiI1u3Bqi4X
	xGZbcMKNSFH2De0Rg1amlry9l/f77YG/f2d7rifzaWykrHOO0884yIDPoZv8qgRpCZpdnCXpGFF
	kPxmEN7bxzo2g+Z1SUxFwHbShNEklpDHU3qJR1QYIUcJtWdssBgf//rs0=
X-Received: by 2002:a05:6000:24c7:b0:474:bbbb:bf17 with SMTP id ffacd0b85a97d-481314f647emr9614472f8f.0.1786240298427;
        Sat, 08 Aug 2026 18:51:38 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f90f8sm17155676f8f.26.2026.08.08.18.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 18:51:37 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 2/4] btrfs: also validate compression levels in btrfs_compress_is_valid_type()
Date: Sun,  9 Aug 2026 03:50:52 +0200
Message-ID: <20260809015054.779137-3-koray.fra@gmail.com>
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

Change btrfs_compress_is_valid_type() to use btrfs_match_compress_type()
and btrfs_compress_str2level() instead of a simple strncmp, which would
validate even incorrect strings (e.g. "zstd:invalid" or "zstdinvalid").

This also makes the function validate levels in the same way the
compress= option gets parsed, allowing bigger or smaller values, but
still clamping them to the min or max supported.

Furthermore, remove the len parameter, since now it requires a
NUL-terminated string because of btrfs_compress_str2level(); this change
is fine because btrfs_compress_is_valid_type() is used only once in
props.c

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/compression.c | 11 ++++++++---
 fs/btrfs/compression.h |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 58138f300b58..833c5f45afec 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -70,18 +70,23 @@ static struct compressed_bio *alloc_compressed_bio(struct btrfs_inode *inode,
 	return to_compressed_bio(bbio);
 }
 
-bool btrfs_compress_is_valid_type(const char *str, size_t len)
+bool btrfs_compress_is_valid_type(const char *str)
 {
+	size_t len = strlen(str);
 	int i;
 
 	for (i = 1; i < ARRAY_SIZE(btrfs_compress_types); i++) {
 		size_t comp_len = strlen(btrfs_compress_types[i]);
+		const char *comp_type = btrfs_compress_types[i];
+		int tmp_level;
 
 		if (len < comp_len)
 			continue;
 
-		if (!strncmp(btrfs_compress_types[i], str, comp_len))
-			return true;
+		if (btrfs_match_compress_type(str, comp_type, true)) {
+			if (btrfs_compress_str2level(i, str + comp_len, &tmp_level) == 0)
+				return true;
+		}
 	}
 	return false;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index e67ba47b4cdc..c63bed9f4152 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -132,7 +132,7 @@ extern const struct btrfs_compress_levels btrfs_lzo_compress;
 extern const struct btrfs_compress_levels btrfs_zstd_compress;
 
 const char* btrfs_compress_type2str(enum btrfs_compression_type type);
-bool btrfs_compress_is_valid_type(const char *str, size_t len);
+bool btrfs_compress_is_valid_type(const char *str);
 
 int btrfs_compress_heuristic(struct btrfs_inode *inode, u64 start, u64 end);
 
-- 
2.55.0

