Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E793C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23F232087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311679;
	bh=CLVcIJOFjibk/3lZFR7jt6ZsKwpLn+OtqvfuFHUdL6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2nCcl+HGa7iE25vtbLxM13K2ZpEBteU7bGlSCDvgrfRhOtwN1xWSCijMJRWK50GqF
	 knElwvaWXfZkTiwKYh2jwTgu7QeoWHUPNIsi4OlaakQdv4V2WwsnzOJRlG8Pw9b+en
	 g2+T8EDAVSvGzyTF4bHFYOPMwOm0GRYHDNuDyrBc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfBDUUw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:52 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44456 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbfBDUUv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:51 -0500
Received: by mail-yw1-f65.google.com with SMTP id b63so796349ywc.11;
        Mon, 04 Feb 2019 12:20:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r4ZmZMx8wEXohRPiPK3cR4oCz/MmawlbTP1VnR3Y4lE=;
        b=RrZ7XiQLlCKX8pePrccpwx+8aqf394NSGLDme/R3pqiCuQE9ha0X5roYfAIAaW2XSh
         s92sueZ50LiY9KCR3cr2ml0NXc+KDzjtjtaG4xYfRMikYDF1+fVkMUlkIm2rJFaX08r0
         FVE64OGBHst8m/vZYhJpct26EkAUqHbBNWkVQpAK2/FNWzNLWGmfbXi1Nk6vDLuUKeg1
         M3p4rh4VE+ZYzwMs4lCmvp4/5D44MORysUkw/sKfnBQ5GprUModpMojQvSQrPbQUwCeS
         8LJSnqWqXmqYarjwXtAC+Dm3d0EFkwTDycxIhtFV9GpjXRVyb8z+NJZcKK2m+sWC6mO6
         FH6w==
X-Gm-Message-State: AHQUAuZ31Gjm9u6+Tsq1tbWgiII4YLpJPaC9BXXaWP30uf6eeMgVbVOQ
        jevhlu0+cHzm9mZ32V1NMgg=
X-Google-Smtp-Source: AHgI3IZfr9BRIiIA0sCuSR7ELGe6WI7BviYIsCafy+VkxIMa2saOBPlLeHORmp9FWiUZVYJIwYkPHA==
X-Received: by 2002:a81:e408:: with SMTP id r8mr1077981ywl.367.1549311651029;
        Mon, 04 Feb 2019 12:20:51 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:50 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 10/12] btrfs: zstd use the passed through level instead of default
Date:   Mon,  4 Feb 2019 15:20:06 -0500
Message-Id: <20190204202008.51652-11-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
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
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
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

