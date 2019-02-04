Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0526BC282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBA912087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311688;
	bh=wB78lZEpsmWzBYd3/1p0r6Ico84/5EcgKJCq0EqcN2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JwNDy1iOwtwLzQcl8o3T1ZnS0MDPynJX4/O0UhytJ5RIKJV9Md2rpOsuBzs9TuX59
	 2n6Xtamaw8ziD+i8xndTAOzGfuruQXIwZmaWeHZA2qr4BshxBWyn8LCVjp3WVAukPH
	 57NtpxiCdzRpoQOKkHLrZONcEKi/w3cedIA0tLU8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbfBDUVX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:21:23 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45731 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbfBDUUu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:50 -0500
Received: by mail-yb1-f193.google.com with SMTP id t11so130444ybi.12;
        Mon, 04 Feb 2019 12:20:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o15S86M6uxmmapywD2NM1Bm0CjjSN0V8I4m7bs8Lx4M=;
        b=FIkOJdoS58uYJXdTsexE61lxqBOk41aEvRZ9Qkk/LlUaNh85hFO+4dwLTAlBv+3mdb
         EGVF3+O4vKdg8gLPi4JPfLtyqAPCDKm11DPxPeUf5w/IJ1dx1lMrE+ngQfL7jW9L981Q
         lmBq58dOmATRLxtrAV2jd3joAxN5fSw5xPPhVONtzSlZYAMII3x+E8IIGBpvf58SM0He
         ovePEVFugZkyjy83HUkJeVMNpPLGg3/S5yPUzYjUO6U6RbiCd/Swukri5KYrNLNYXXxi
         gyOSwZDX1Jdw5O2yfEYW267b4beptiEhqnlZv7BO74e63FygTlOZqmMKFOqqqnfr40zT
         bW8Q==
X-Gm-Message-State: AHQUAuZ9mCdLxGu2lF3Hd5ZtuOPhtknKCirUO4pIzjgQJa8ELjFJvQjf
        3jOBPRPHUuLs5jY0H+59Keg=
X-Google-Smtp-Source: AHgI3IadIsYxC8HcR7P6OCEpoVmJFd3U8+kPiDr6RzK20N4Mb5AKqJV8XazXvMX1Pqxv9Pcroe2Kng==
X-Received: by 2002:a25:148b:: with SMTP id 133mr1060291ybu.181.1549311649513;
        Mon, 04 Feb 2019 12:20:49 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:48 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 09/12] btrfs: change set_level() to bound the level passed in
Date:   Mon,  4 Feb 2019 15:20:05 -0500
Message-Id: <20190204202008.51652-10-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently, the only user of set_level() is zlib which sets an internal
workspace parameter. As level is now plumbed into get_workspace(), this
can be handled there rather than separately.

This repurposes set_level() to bound the level passed in so it can be
used when setting the mounts compression level and as well as verifying
the level before getting a workspace. The other benefit is this divides
the meaning of compress(0) and get_workspace(0). The former means we
want to use the default compression level of the compression type. The
latter means we can use any workspace available.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 21 +++++++++++++--------
 fs/btrfs/compression.h | 10 ++++++++--
 fs/btrfs/lzo.c         |  3 ++-
 fs/btrfs/super.c       |  4 +++-
 fs/btrfs/zlib.c        | 18 ++++++++++--------
 fs/btrfs/zstd.c        |  3 ++-
 6 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index a54b210739bc..dc4afd7d9027 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1007,8 +1007,6 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 	int ret;
 
 	workspace = get_workspace(type, level);
-
-	btrfs_compress_op[type]->set_level(workspace, level);
 	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
@@ -1561,14 +1559,21 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	return ret;
 }
 
-unsigned int btrfs_compress_str2level(const char *str)
+unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
 {
-	if (strncmp(str, "zlib", 4) != 0)
+	unsigned int level;
+	int ret;
+
+	if (!type)
 		return 0;
 
-	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the number */
-	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
-		return str[5] - '0';
+	if (str[0] == ':') {
+		ret = kstrtouint(str + 1, 10, &level);
+		if (ret)
+			level = 0;
+	}
+
+	level = btrfs_compress_op[type]->set_level(level);
 
-	return BTRFS_ZLIB_DEFAULT_LEVEL;
+	return level;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 32ba40ebae1d..3f2d36b0aabe 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -97,7 +97,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
 
-unsigned btrfs_compress_str2level(const char *str);
+unsigned int btrfs_compress_str2level(unsigned int type, const char *str);
 
 enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
@@ -156,7 +156,13 @@ struct btrfs_compress_op {
 			  unsigned long start_byte,
 			  size_t srclen, size_t destlen);
 
-	void (*set_level)(struct list_head *ws, unsigned int type);
+	/*
+	 * This bounds the level set by the user to be within range of
+	 * a particular compression type.  It returns the level that
+	 * will be used if the level is out of bounds or the default
+	 * if 0 is passed in.
+	 */
+	unsigned int (*set_level)(unsigned int level);
 };
 
 /* the heuristic workspaces are managed via the 0th workspace manager */
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index f132af45a924..579d53ae256f 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -507,8 +507,9 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void lzo_set_level(struct list_head *ws, unsigned int type)
+static unsigned int lzo_set_level(unsigned int level)
 {
+	return 0;
 }
 
 const struct btrfs_compress_op btrfs_lzo_compress = {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c5586ffd1426..b28dff207383 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -529,7 +529,9 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				if (token != Opt_compress &&
 				    token != Opt_compress_force)
 					info->compress_level =
-					  btrfs_compress_str2level(args[0].from);
+					  btrfs_compress_str2level(
+							BTRFS_COMPRESS_ZLIB,
+							args[0].from + 4);
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index c0ef09bef3b3..77363f663868 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -41,7 +41,12 @@ static void zlib_cleanup_workspace_manager(void)
 
 static struct list_head *zlib_get_workspace(unsigned int level)
 {
-	return btrfs_get_workspace(&wsm, level);
+	struct list_head *ws = btrfs_get_workspace(&wsm, level);
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+
+	workspace->level = level;
+
+	return ws;
 }
 
 static void zlib_put_workspace(struct list_head *ws)
@@ -413,15 +418,12 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zlib_set_level(struct list_head *ws, unsigned int type)
+static unsigned int zlib_set_level(unsigned int level)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	unsigned int level = btrfs_compress_level(type);
-
-	if (level > 9)
-		level = 9;
+	if (!level)
+		return BTRFS_ZLIB_DEFAULT_LEVEL;
 
-	workspace->level = level > 0 ? level : 3;
+	return min_t(unsigned int, level, 9);
 }
 
 const struct btrfs_compress_op btrfs_zlib_compress = {
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 404101864220..43f3be755b8c 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -441,8 +441,9 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zstd_set_level(struct list_head *ws, unsigned int type)
+static unsigned int zstd_set_level(unsigned int level)
 {
+	return ZSTD_BTRFS_DEFAULT_LEVEL;
 }
 
 const struct btrfs_compress_op btrfs_zstd_compress = {
-- 
2.17.1

