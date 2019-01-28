Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1953FC282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8642171F
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710715;
	bh=LRD7JQeLuBHSJDf/uDfT15bVBx1BgPpGi2kItvUvzKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pN4rolnd3s+JwOb7I4kD/SHXKrn/bF1k4c6uIbhlQUrxapmZ2ry5pRY6+jtnsl/pp
	 +0xnfM50lQVhEYEShMvc8sGQxTELpitALXkomj3dq+/ytDIRipwnmcyPnncm7dJKpD
	 0b4ziqp+BbUYHgoACJZYYlDua/EoKaZyVes9f1ns=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbfA1VZK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:25:10 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38113 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfA1VY7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:59 -0500
Received: by mail-yw1-f67.google.com with SMTP id d190so7356779ywb.5;
        Mon, 28 Jan 2019 13:24:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i95HDMYBMKJoHPehH+6R+py5+DMch2uym+tajUEb64U=;
        b=cfhCLJOc45EhyGkR5uZlhot+DKHiqJVXdCjIvua9NQbk3fG8SZff/3SiM0ik4G+29i
         zkJRhwNyYnelUE1tmLFmtBvKvVDN+WP5effZ2mDXiAcKW9H9xQ8cvr0TStjmjEKaAhUh
         wzzrGXaeJt4zPqLFdJg770SH9RgcxtYBO9MrlFigo/MUouAXMmM2qXxmMGae0Vma2XU5
         IrN0s8ZgJmGGBbwXgWYWAh6qJRoFrraO3rQAPmwddmYDTnSjXL5qbyAi581MC0orhRqI
         YYJGPiP+fPUwn9DNILJR/kBU/Jkvm9lO7jn4rJ5ZFtxIL0cSRQ7K45ZfGe2ZAthxqO6m
         bN3A==
X-Gm-Message-State: AJcUukcfsrwWfxhf2R9WVVr8UZaI+olTInYMN0OQYW8aGhL2BBTmg1Jg
        4227k7IjcMpKOVYDUhBov5o=
X-Google-Smtp-Source: ALg8bN4+2RtE73arjUvpCBYxFMWs7AZsXIQ4B0tYbFHffl1Xt59wM08CqjISXIkFVJHZYHIOZfTkjw==
X-Received: by 2002:a81:af0c:: with SMTP id n12mr21761482ywh.446.1548710698757;
        Mon, 28 Jan 2019 13:24:58 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:57 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 10/11] btrfs: zstd use the passed through level instead of default
Date:   Mon, 28 Jan 2019 16:24:36 -0500
Message-Id: <20190128212437.11597-11-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Zstd currently only supports the default level of compression. This
patch switches to using the level passed in for btrfs zstd
configuration.

Zstd workspaces now keep track of the requested level as this can differ
from the size of the workspace.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/zstd.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 43f3be755b8c..a951d4fe77f7 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -21,10 +21,10 @@
 #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
 #define ZSTD_BTRFS_DEFAULT_LEVEL 3
 
-static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len)
+static ZSTD_parameters zstd_get_btrfs_parameters(unsigned int level,
+						 size_t src_len)
 {
-	ZSTD_parameters params = ZSTD_getParams(ZSTD_BTRFS_DEFAULT_LEVEL,
-						src_len, 0);
+	ZSTD_parameters params = ZSTD_getParams(level, src_len, 0);
 
 	if (params.cParams.windowLog > ZSTD_BTRFS_MAX_WINDOWLOG)
 		params.cParams.windowLog = ZSTD_BTRFS_MAX_WINDOWLOG;
@@ -36,6 +36,7 @@ struct workspace {
 	void *mem;
 	size_t size;
 	char *buf;
+	unsigned int req_level;
 	struct list_head list;
 	ZSTD_inBuffer in_buf;
 	ZSTD_outBuffer out_buf;
@@ -55,7 +56,12 @@ static void zstd_cleanup_workspace_manager(void)
 
 static struct list_head *zstd_get_workspace(unsigned int level)
 {
-	return btrfs_get_workspace(&wsm, level);
+	struct list_head *ws = btrfs_get_workspace(&wsm, level);
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+
+	workspace->req_level = level;
+
+	return ws;
 }
 
 static void zstd_put_workspace(struct list_head *ws)
@@ -75,7 +81,7 @@ static void zstd_free_workspace(struct list_head *ws)
 static struct list_head *zstd_alloc_workspace(unsigned int level)
 {
 	ZSTD_parameters params =
-			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT);
+			zstd_get_btrfs_parameters(level, ZSTD_BTRFS_MAX_INPUT);
 	struct workspace *workspace;
 
 	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
@@ -117,7 +123,8 @@ static int zstd_compress_pages(struct list_head *ws,
 	unsigned long len = *total_out;
 	const unsigned long nr_dest_pages = *out_pages;
 	unsigned long max_out = nr_dest_pages * PAGE_SIZE;
-	ZSTD_parameters params = zstd_get_btrfs_parameters(len);
+	ZSTD_parameters params = zstd_get_btrfs_parameters(workspace->req_level,
+							   len);
 
 	*out_pages = 0;
 	*total_out = 0;
-- 
2.17.1

