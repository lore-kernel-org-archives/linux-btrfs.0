Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93592C282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 610F42171F
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710689;
	bh=i4FG26i8q8EtLkU9BJZgqrLnFygeBb+4G3OXrXYj7QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VNswLSRnCRS34/HR3eVtGXG38Hcz/N7fo9n/wx6UlfATO1kO1RpyZzWUIbRRPlhTZ
	 HjIpGS4LX7icodEtYrIm11HUjMCFKtYRoVak3aIrAdC32ZEa68KV8cfaPUyB/Bnk41
	 WfQbE75ik6eRKycqMq0LlLFV5w7+vIIhWbv5l6Lc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfA1VYr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:24:47 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:41497 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfA1VYr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:47 -0500
Received: by mail-yb1-f193.google.com with SMTP id n6so1916052ybg.8;
        Mon, 28 Jan 2019 13:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=urZHYaHVYTvaWvnMKkIGbrK6fCowBa9M7UNu2RVTVI8=;
        b=p/QRTCCL/QGTnFucc6pVxApqjerSboKfViaOdy5hYjE2pZwK7TGJXThqmkNz8bo3nP
         RCkc7OeDbNt3M0FClF47Y2m+SpUJSrOi8GQhshPgdtqIqevCZSxKzGtta78dHfxgch6x
         XNvlpoIiU1w4Xo7FQZ2bszVv0KBCZ39nhtu5OOddJI8wUb/ldMgxq97qDP+hTd1AGrE6
         lJE0JczYKQnvh3fTozUNaSrw+qlJbj5U+Q4bUg50Xy67az+RobqaZiTkr7RoHi/P3E5t
         2dkr8xCaeGKNOck/V0pugCWX0jg1ZNP1gxyovW9rOIrJX1OXNrRwb6BqS0m3HjO0AyjH
         qtoA==
X-Gm-Message-State: AJcUukdfB2ijFKjBrIwAGf66IKAsyM8xrQenPHa7Tu6PP+ZEcGoDGNBd
        4DDVDSTcfjnk3lWQRPs04iQ=
X-Google-Smtp-Source: ALg8bN7gRS0+yO9J9n6aHbHUlmqnzBOIFagxyXJANSwcT7qja+wzR4Lg2kSaJJY6VCUz0yzIVev1wQ==
X-Received: by 2002:a25:6ec5:: with SMTP id j188mr21995242ybc.129.1548710686109;
        Mon, 28 Jan 2019 13:24:46 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:45 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 01/11] btrfs: add macros for compression type and level
Date:   Mon, 28 Jan 2019 16:24:27 -0500
Message-Id: <20190128212437.11597-2-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It is very easy to miss places that rely on a certain bitshifting for
decyphering the type_level overloading. Make macros handle this instead.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 2 +-
 fs/btrfs/compression.h | 3 +++
 fs/btrfs/zlib.c        | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 548057630b69..586f95ac0aea 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1036,9 +1036,9 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 unsigned long *total_in,
 			 unsigned long *total_out)
 {
+	int type = BTRFS_COMPRESS_TYPE(type_level);
 	struct list_head *workspace;
 	int ret;
-	int type = type_level & 0xF;
 
 	workspace = find_workspace(type);
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index ddda9b80bf20..69a9197dadc3 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -25,6 +25,9 @@
 
 #define	BTRFS_ZLIB_DEFAULT_LEVEL		3
 
+#define BTRFS_COMPRESS_TYPE(type_level)		(type_level & 0xF)
+#define BTRFS_COMPRESS_LEVEL(type_level)	((type_level & 0xF0) >> 4)
+
 struct compressed_bio {
 	/* number of bios pending for this compressed extent */
 	refcount_t pending_bios;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 970ff3e35bb3..1480b3eee306 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -393,7 +393,7 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 static void zlib_set_level(struct list_head *ws, unsigned int type)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	unsigned level = (type & 0xF0) >> 4;
+	unsigned int level = BTRFS_COMPRESS_LEVEL(type);
 
 	if (level > 9)
 		level = 9;
-- 
2.17.1

