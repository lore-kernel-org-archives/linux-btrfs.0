Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE07C282CB
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E12D2087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311730;
	bh=TURWZtE4SkXcb+oy/sh6XpS038UE7exv+NtYYXNHPHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xpG/L5wWj0Qg4aQK5tbRfvJ9+CJ2hUNAaQNxUnt6SPQCztSb6Nl6aD3f9y2qECVV1
	 gshQMOoPxInnsPrhhv6PqlxfBpj21L/0fuRMrguCVKTaOGTqbTPShtyp08lR6v96Bz
	 yxmhhAoDP13Q0H6UANaWM8sx3JW14CEoaVt2bLgE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfBDUUe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:34 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37090 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbfBDUUd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:33 -0500
Received: by mail-yb1-f196.google.com with SMTP id 2so130346ybw.4;
        Mon, 04 Feb 2019 12:20:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xOm05xx5lHMFxywtitgEsNJYMLsCrgVW7GHOHkAvYq8=;
        b=F6HABbWNNdmCNImh/8x6K3RAgB404NFW+WELHw2lV8SrXQy88FpIPQFDf0mFk2zV8B
         D6eSPSqtx+KIG6UJ22lhDkVxeUlyE0DhuTrCSuGEsqWEjxEfdo/EzoyRJEuUx7OmL2yq
         5mI4IKVqCdEhKXQhQ7jKOle8wz3y0z0o2bK5VqjFZDFal0gRzzajsJ/WI4rR71MimFds
         v0iyJa7YT/hjNerNBP5bwhUM/4y+uMV34X20W4IwsRa4GlEfdRHUMKACChauQhpwhUGm
         wcCWVxHwF28rK42w1ji/s9ySOxK0QTrxQQ9mZtesE7nQAchdnATcE5x5Z8C3LtWjNCHY
         /OdQ==
X-Gm-Message-State: AHQUAuZiBeFEkPnXyZrDavigGrypQ/v+868x5jgnzSahiTdGoZ+G7h0h
        ich0oM8/dwOoHyuYYD5Hr3g=
X-Google-Smtp-Source: AHgI3IY1xGnW2Tgh/7fCUad3IrnuedHpEP+IDBf5iwf++9W5LpPc9AQDcPlfG5sdZo9N4bfL/v+CZA==
X-Received: by 2002:a25:e08e:: with SMTP id x136mr1117746ybg.290.1549311632306;
        Mon, 04 Feb 2019 12:20:32 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:31 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 01/12] btrfs: add helpers for compression type and level
Date:   Mon,  4 Feb 2019 15:19:57 -0500
Message-Id: <20190204202008.51652-2-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It is very easy to miss places that rely on a certain bitshifting for
decyphering the type_level overloading. Add helpers to do this instead.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/compression.c |  2 +-
 fs/btrfs/compression.h | 10 ++++++++++
 fs/btrfs/zlib.c        |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 548057630b69..94a0b0a3a301 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1036,9 +1036,9 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 unsigned long *total_in,
 			 unsigned long *total_out)
 {
+	int type = btrfs_compress_type(type_level);
 	struct list_head *workspace;
 	int ret;
-	int type = type_level & 0xF;
 
 	workspace = find_workspace(type);
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index ddda9b80bf20..004db0b3111b 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -64,6 +64,16 @@ struct compressed_bio {
 	u32 sums;
 };
 
+static inline unsigned int btrfs_compress_type(unsigned int type_level)
+{
+	return (type_level & 0xF);
+}
+
+static inline unsigned int btrfs_compress_level(unsigned int type_level)
+{
+	return ((type_level & 0xF0) >> 4);
+}
+
 void __init btrfs_init_compress(void);
 void __cold btrfs_exit_compress(void);
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 970ff3e35bb3..2bd655c4f8b4 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -393,7 +393,7 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 static void zlib_set_level(struct list_head *ws, unsigned int type)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	unsigned level = (type & 0xF0) >> 4;
+	unsigned int level = btrfs_compress_level(type);
 
 	if (level > 9)
 		level = 9;
-- 
2.17.1

