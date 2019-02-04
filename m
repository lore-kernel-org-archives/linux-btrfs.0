Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4117AC282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE9A2087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311677;
	bh=eCV48zC7k4gJ5KNswA7AvWM6KnhTlLgK6IvOenRPqX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TPHVFpTRNXU48iccrQ/dLVYI3LS89x/GbbW13ymd2ORBuEWUOEII7mqHW5ergE7uU
	 8rA5zMIC9u7bmw50FZtz8+Yav8gKklF5j0k62507a28P0+jEnaFmg7VVrKE3HSkvcw
	 TnSXlYJPLsNFbnlECAIq6C+EqLiLIPHbD4CecM1Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfBDUVL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:21:11 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46037 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbfBDUUx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:53 -0500
Received: by mail-yw1-f68.google.com with SMTP id d190so789437ywd.12;
        Mon, 04 Feb 2019 12:20:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5po2rJiSXoneqYNQf9aqN1I3NYn8b2+90A3O+aqr8/o=;
        b=GyHzU/MIh2wl0de/C2P564VI+kHEGmKWrSmSfk9o4tP2ZaEwd4NDTYK+/xaJFaChRQ
         rMoEt1Mo10LwnOCCR9MmZqKYSDzilOggPR10laaeog2Zu4Sb641V49dmAL3eEkkS7ZmE
         ZItoG5BihiIVf7PY4yC7VqTjS1MlyCMR43schhHtb3X1PejXRHK2iC7Y0zHydgRaoeIo
         8RknvwuxSfqONXsyvkiPSueiT8dqj8pFhhrRt7glkFWYzMv8M3xfYasbYW1NGKvOuOys
         lRayaPt8on13g9WjZI0EPXPvix4/QZWAu0NMjQ0pgtFRY+1s9XgCOuYxZZ/6Tzr6b1Bl
         8OrA==
X-Gm-Message-State: AHQUAuZUbqntkcT5xQeJyNNo1B4RGPa/TKOTjcGcPWUiLd/+p8uRjRcJ
        ggen4Pzmv4+RY9YQfC/EbL4=
X-Google-Smtp-Source: AHgI3IbDBnnSFmg+zlZwku+cC6TCreqmgBjWumDEwb7bPXVdVWxow6JQL7oUJvFwaGqoKLWUhECOAw==
X-Received: by 2002:a81:a988:: with SMTP id g130mr1040981ywh.307.1549311652426;
        Mon, 04 Feb 2019 12:20:52 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:51 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 11/12] btrfs: make zstd memory requirements monotonic
Date:   Mon,  4 Feb 2019 15:20:07 -0500
Message-Id: <20190204202008.51652-12-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It is possible based on the level configurations that a higher level
workspace uses less memory than a lower level workspace. In order to
reuse workspaces, this must be made a monotonic relationship. This
precomputes the required memory for each level and enforces the
monotonicity between level and memory required. This is also done
in upstream zstd in [1].

[1] https://github.com/facebook/zstd/commit/a68b76afefec6876f8e8a538155109a5aeac0143

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
---
 fs/btrfs/zstd.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index a951d4fe77f7..2231123fedbe 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -20,6 +20,7 @@
 #define ZSTD_BTRFS_MAX_WINDOWLOG 17
 #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
 #define ZSTD_BTRFS_DEFAULT_LEVEL 3
+#define ZSTD_BTRFS_MAX_LEVEL 15
 
 static ZSTD_parameters zstd_get_btrfs_parameters(unsigned int level,
 						 size_t src_len)
@@ -44,8 +45,39 @@ struct workspace {
 
 static struct workspace_manager wsm;
 
+static size_t zstd_ws_mem_sizes[ZSTD_BTRFS_MAX_LEVEL];
+
+/*
+ * zstd_calc_ws_mem_sizes - calculate monotonic memory bounds
+ *
+ * It is possible based on the level configurations that a higher level
+ * workspace uses less memory than a lower level workspace.  In order to
+ * reuse workspaces, this must be made a monotonic relationship.  This
+ * precomputes the required memory for each level and enforces the
+ * monotonicity between level and memory required.
+ */
+static void zstd_calc_ws_mem_sizes(void)
+{
+	size_t max_size = 0;
+	unsigned int level;
+
+	for (level = 1; level <= ZSTD_BTRFS_MAX_LEVEL; level++) {
+		ZSTD_parameters params =
+			zstd_get_btrfs_parameters(level, ZSTD_BTRFS_MAX_INPUT);
+		size_t level_size =
+			max_t(size_t,
+			      ZSTD_CStreamWorkspaceBound(params.cParams),
+			      ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
+
+		max_size = max_t(size_t, max_size, level_size);
+		zstd_ws_mem_sizes[level - 1] = max_size;
+	}
+}
+
 static void zstd_init_workspace_manager(void)
 {
+	zstd_calc_ws_mem_sizes();
+
 	btrfs_init_workspace_manager(&wsm, &btrfs_zstd_compress);
 }
 
@@ -80,17 +112,13 @@ static void zstd_free_workspace(struct list_head *ws)
 
 static struct list_head *zstd_alloc_workspace(unsigned int level)
 {
-	ZSTD_parameters params =
-			zstd_get_btrfs_parameters(level, ZSTD_BTRFS_MAX_INPUT);
 	struct workspace *workspace;
 
 	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
 	if (!workspace)
 		return ERR_PTR(-ENOMEM);
 
-	workspace->size = max_t(size_t,
-			ZSTD_CStreamWorkspaceBound(params.cParams),
-			ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
+	workspace->size = zstd_ws_mem_sizes[level - 1];
 	workspace->mem = kvmalloc(workspace->size, GFP_KERNEL);
 	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!workspace->mem || !workspace->buf)
-- 
2.17.1

