Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20A1C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 16:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C332081B
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549471744;
	bh=ZapJIeDXnRtZrhzsugTMqaVJpJSStWlHseVXAOMS+7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HASLDFEPWPYeiKXC2BbyhuLqLyi8RK/SvfcQB7gAVfNQG965JkWMDBh/tdH5uFJ0i
	 stZWJZMOOwIroGd8yKuMlwt2HdzqAm0vgdlH3BflZA27bVmvhbmGwjiAOZw0I3ilHH
	 QEr3kBm2O0KMH/0vZHCY78GvMe2algBgD9Sv+Fuw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731392AbfBFQs7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:48:59 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41092 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfBFQs7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 11:48:59 -0500
Received: by mail-yw1-f68.google.com with SMTP id f65so3385295ywc.8;
        Wed, 06 Feb 2019 08:48:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ha8IZIpmzI+LUF18oLEG1KScBR5rz2/y9Z33oy/8h14=;
        b=OUiomTtCgWzDY5Vsn/RuL80LGVzPV1CIED8d1Z/JRZFTDspETHi5hWQAkpj8db5gyX
         jJwTw04rXKw+zbF/9zgKhZGxUSNkS5/Zf3w6IOWJk792HI0pRjARviC/zpcjEU9tKXcU
         772e4oH5Ay2S6zzCwY+a2qcQparV0EBp8CWSMyliFYB7crsEZHs83p22XcHBfg52NPHI
         6CqKX12oor4XfI3kQkDbb+syAtRVj+gC7AyRa86YjMQtWeZJXA9k4Crj4RfRChqA940/
         Avujf64OitIAIvDT8ZIqAElsBR6qHj4AoVZJETcgBAJ+IhJfL26haFpm0saVd6ZQzN4p
         mwPg==
X-Gm-Message-State: AHQUAuZX0CexLLU3GMhwE9voF0ThnQKcQvkIMeoLfWNzQWjBuXNU/u/f
        5vX5Hb/td0008z1qN8GoQZs=
X-Google-Smtp-Source: AHgI3Iaj+qmpVNSYeFEkhqzLDl8DeknTYZGBWniDbzaxW3ch9j8eW2oWjAuH4aN06tRlj7+m9GvgjQ==
X-Received: by 2002:a81:4cc5:: with SMTP id z188mr8892050ywa.194.1549471737803;
        Wed, 06 Feb 2019 08:48:57 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::6:c448])
        by smtp.gmail.com with ESMTPSA id v127sm2225764ywb.96.2019.02.06.08.48.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 08:48:56 -0800 (PST)
Date:   Wed, 6 Feb 2019 11:48:55 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/12] btrfs: change set_level() to bound the level
 passed in
Message-ID: <20190206164854.GB73401@dennisz-mbp.dhcp.thefacebook.com>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190204202008.51652-10-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204202008.51652-10-dennis@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From ef64a8d1f4ec44f52bd13a825288a91667121708 Mon Sep 17 00:00:00 2001
From: Dennis Zhou <dennis@kernel.org>
Date: Thu, 17 Jan 2019 12:13:27 -0800

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
v2:
- warn on bad level format eg: zlib:c100
- warn on level out of bounds eg: zlib:10

 fs/btrfs/compression.c | 27 +++++++++++++++++++--------
 fs/btrfs/compression.h | 10 ++++++++--
 fs/btrfs/lzo.c         |  3 ++-
 fs/btrfs/super.c       |  4 +++-
 fs/btrfs/zlib.c        | 21 ++++++++++++++-------
 fs/btrfs/zstd.c        |  3 ++-
 6 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index a54b210739bc..560a926c2e2f 100644
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
@@ -1561,14 +1559,27 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	return ret;
 }
 
-unsigned int btrfs_compress_str2level(const char *str)
+unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
 {
-	if (strncmp(str, "zlib", 4) != 0)
+	unsigned int level = 0;
+	int ret;
+
+	if (!type)
 		return 0;
 
-	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the number */
-	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
-		return str[5] - '0';
+	if (str[0] == ':') {
+		if (str[1] != '+') {
+			ret = kstrtouint(str + 1, 10, &level);
+			if (!ret)
+				goto set_level;
+		}
+
+		pr_warn("BTRFS: invalid compression level %s, using default",
+			str + 1);
+	}
+
+set_level:
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
index c0ef09bef3b3..439dad221e9a 100644
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
@@ -413,15 +418,17 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zlib_set_level(struct list_head *ws, unsigned int type)
+static unsigned int zlib_set_level(unsigned int level)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	unsigned int level = btrfs_compress_level(type);
-
-	if (level > 9)
+	if (!level) {
+		return BTRFS_ZLIB_DEFAULT_LEVEL;
+	} else if (level > 9) {
 		level = 9;
+		pr_warn("BTRFS: zlib level > max level, using max level: %u",
+			level);
+	}
 
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

