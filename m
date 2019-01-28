Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777A9C282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 401572177E
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710719;
	bh=q8lP/rRHnXTUxoIgT581gVq+PQi+1knkh1MrcgQMBQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rY/sjmV8LCNMcKjuooBmAYb297B00tNdaukjIjrPRopIIwzutX3p0zxH1Crww8p7z
	 zPdaV7wXTtuiTvM7THCP0pRSfNTM5E2WzUvreGLyevoZiATD3mViYIk1zvA1XABgVI
	 DsHfQMCUlrQAv+RcELnzg19YQ9YxAS0r8g8lDY3w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfA1VY7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:24:59 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36697 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbfA1VY6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:58 -0500
Received: by mail-yw1-f66.google.com with SMTP id i73so7356243ywg.3;
        Mon, 28 Jan 2019 13:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wisqPDSfzfuGtfQPMvdQY71lpH/gg72mzhu83259kzY=;
        b=jZK6tNFIYRpY+yIcfDkagJ3sEtejj63ieLD6SSHnkljUruyYwBWr70Ss6/eYXLKGxi
         258QGiyZCIfIpOspjxWnpeqB35A91/1zHYSfckKam3yRxmWyHmQyOk2DCDxy1oPtX8PZ
         MOFgXd0vBcixyM6/IybK3cTtYathShnG8Ek6JXPPCeY0jOjXvrB+25GUUd6rpOF9dIzw
         3RXCqaTc/WVfAe/wVdnqI7idQhZ4QdSoXxYxNvur5yUoX+im8l9igZeDgDQ02Pm+ZWUZ
         Frs3yipJHmTIB/iClVQ1tkoehLATNwL4S3p9Ejt7Siv7hiztNfK2UgTZoaxx+4JuRan2
         IO/g==
X-Gm-Message-State: AJcUukd9MVyk0S4KlqUYBNbcqWtwLqN4xgNGnSxuJjAikyJm75dM0r50
        d55s3f3TBiaSz+bgi9/0KbI=
X-Google-Smtp-Source: ALg8bN5UMRGWhuyjNZXutlYtAafP3bI86CSqqidL++DGdcxPR12bJhZHQ2o08FAbnjiOU8UrKsUueg==
X-Received: by 2002:a81:c93:: with SMTP id 141mr22834674ywm.356.1548710697375;
        Mon, 28 Jan 2019 13:24:57 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:56 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 09/11] btrfs: change set_level() to bound the level passed in
Date:   Mon, 28 Jan 2019 16:24:35 -0500
Message-Id: <20190128212437.11597-10-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
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
 fs/btrfs/compression.c | 23 +++++++++++++++--------
 fs/btrfs/compression.h |  4 ++--
 fs/btrfs/lzo.c         |  3 ++-
 fs/btrfs/super.c       |  4 +++-
 fs/btrfs/zlib.c        | 18 +++++++++++-------
 fs/btrfs/zstd.c        |  3 ++-
 6 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e509071eaa69..a552c6f61e6d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1008,9 +1008,9 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 	struct list_head *workspace;
 	int ret;
 
-	workspace = get_workspace(type, level);
+	level = btrfs_compress_op[type]->set_level(level);
 
-	btrfs_compress_op[type]->set_level(workspace, level);
+	workspace = get_workspace(type, level);
 	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
@@ -1563,14 +1563,21 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
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
index e3627139bc5c..d607be40aa0e 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -90,7 +90,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
 
-unsigned btrfs_compress_str2level(const char *str);
+unsigned int btrfs_compress_str2level(unsigned int type, const char *str);
 
 enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
@@ -149,7 +149,7 @@ struct btrfs_compress_op {
 			  unsigned long start_byte,
 			  size_t srclen, size_t destlen);
 
-	void (*set_level)(struct list_head *ws, unsigned int type);
+	unsigned int (*set_level)(unsigned int level);
 };
 
 extern const struct btrfs_compress_op btrfs_heuristic_compress;
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
index e2173d0c4fd3..388b1f000fca 100644
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
@@ -413,15 +418,14 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zlib_set_level(struct list_head *ws, unsigned int type)
+static unsigned int zlib_set_level(unsigned int level)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	unsigned int level = BTRFS_COMPRESS_LEVEL(type);
-
-	if (level > 9)
+	if (!level)
+		level = BTRFS_ZLIB_DEFAULT_LEVEL;
+	else if (level > 9)
 		level = 9;
 
-	workspace->level = level > 0 ? level : 3;
+	return level;
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

