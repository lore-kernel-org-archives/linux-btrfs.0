Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF9EC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6D3520821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tUsamSlp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfAIB1f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33307 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbfAIB1b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so6055894wrr.0;
        Tue, 08 Jan 2019 17:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfygHIQ+1gH+Ojx0ZEP2lKfK/Oy3nkc0D6H0Gh5R4oo=;
        b=tUsamSlpfrtc9rrce985G+siJF8EKyZZ8M4/zeemuPvLXiXZzeSj7/6CkmqIQlcu2+
         FFDRXu3Td7Hyrrhqx/yLmsY535xsihSpppbZxzVMSBCRsY/zhiZ3lBrWkMtK1dOo3FE1
         47/Rpxe0D87Y12W3QhPE2YUQDE6M0slZvzmUPamLhQsjySX2cA1CIUTjA8S87NAjNiv5
         ExEcLncu94nP9Ti4TjFE36iFcBRlbjEIWQH5XqGh6Q62K2kHTUeLmzpWpXVytbkE7X8L
         1gyxfcaDcCvaNgtxcB0d6vks+i4NeUM4Aa0oGORp07DcdUPGQR1m+S/2YtySy+xmWwwP
         51MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=kfygHIQ+1gH+Ojx0ZEP2lKfK/Oy3nkc0D6H0Gh5R4oo=;
        b=kWjJmxnwp9/yhfnmK1IFMF0+vEjktRgdEn8MyH2RGQodtDz+tGw456JefkxS1oGvPb
         B0b1TylsFNCP1wuf3idiPaahGinSYX8JzRhYtGH/NHcx53rlT9s4IeLnEfL/RkLYTcLM
         tHhn4TA92BtiQfwWmWwG8gVtFGumEiWbBnB+zjnYGIhCH/WXt39R6C4GytCmF8I8IVzC
         M0jA2UMO+ZiW2wHU9c388vGpIq6AWKotAyA9iOZrl1OgyR5iCdxpZLWUy5rjon3TrhR3
         ZpLn6IINYD9rhsPcBBxdHLoUhDmFDmnjFejeXtnLy78YWYfOkSkQylmtT+8yPaYI+7v5
         TWxQ==
X-Gm-Message-State: AJcUukf7rgvC4N1SBB2X8OshNFPrU6Gq/t+g6oXy+keMe4U+x1iQXSLy
        1YKEmtkrvtBqGFda5YFcxPskR/o7Xpw=
X-Google-Smtp-Source: ALg8bN5oZxd5YHm/WFoKtcevZtzC3Su5huRYeBhkBi7uFUfUF0g8l9hYyGs+/h4OtXm5sUShS4GWxg==
X-Received: by 2002:a5d:68c3:: with SMTP id p3mr3272498wrw.34.1546997248495;
        Tue, 08 Jan 2019 17:27:28 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:28 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 05/19] btrfs: add key list
Date:   Wed,  9 Jan 2019 01:26:47 +0000
Message-Id: <20190109012701.26441-5-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/ctree.h      |  5 +++++
 fs/btrfs/disk-io.c    | 18 ++++++++++++++++++
 fs/btrfs/encryption.h | 13 +++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 723e9b38e0aa..3f3356a2d145 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1116,6 +1116,9 @@ struct btrfs_fs_info {
 	u32 sectorsize;
 	u32 stripesize;
 
+	struct list_head key_list;
+	struct rw_semaphore key_sem;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
@@ -2413,6 +2416,8 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 		   other_encoding, 16);
 
+#define BTRFS_ENCRYPTION_KEY_ID_LENGTH 64
+
 /*
  * this returns the number of bytes used by the item on disk, minus the
  * size of any extent headers.  If a file is compressed on disk, this is
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a533c00855be..a1964b768750 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -18,6 +18,7 @@
 #include <linux/error-injection.h>
 #include <linux/crc32c.h>
 #include <asm/unaligned.h>
+#include <crypto/rng.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -38,6 +39,7 @@
 #include "compression.h"
 #include "tree-checker.h"
 #include "ref-verify.h"
+#include "encryption.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2751,6 +2753,9 @@ int open_ctree(struct super_block *sb,
 
 	INIT_LIST_HEAD(&fs_info->pinned_chunks);
 
+	INIT_LIST_HEAD(&fs_info->key_list);
+	init_rwsem(&fs_info->key_sem);
+
 	/* Usable values until the real ones are cached from the superblock */
 	fs_info->nodesize = 4096;
 	fs_info->sectorsize = 4096;
@@ -4013,6 +4018,19 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		list_del_init(&em->list);
 		free_extent_map(em);
 	}
+
+	while (!list_empty(&fs_info->key_list)) {
+		struct btrfs_enc_key *key;
+
+		key = list_first_entry(&fs_info->key_list,
+				       struct btrfs_enc_key, key_list);
+
+		if (key->loaded)
+			crypto_free_skcipher(key->skcipher);
+
+		list_del_init(&key->key_list);
+		kfree(key);
+	}
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/encryption.h b/fs/btrfs/encryption.h
index b9a37e76e4a6..77914d7797c6 100644
--- a/fs/btrfs/encryption.h
+++ b/fs/btrfs/encryption.h
@@ -6,6 +6,8 @@
 #ifndef BTRFS_ENCRYPTION_H
 #define BTRFS_ENCRYPTION_H
 
+#include <crypto/skcipher.h>
+
 enum btrfs_encryption_type {
 	BTRFS_ENCRYPTION_NONE       = 0,
 	BTRFS_ENCRYPTION_AES256CTR  = 1,
@@ -17,4 +19,15 @@ struct btrfs_encryption_header {
 	u8 iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
 };
 
+struct btrfs_enc_key {
+	struct list_head key_list;
+	u8 key_id[BTRFS_ENCRYPTION_KEY_ID_LENGTH];
+	u64 key_number;
+	bool loaded;
+	bool added;
+	bool used;
+	struct crypto_skcipher *skcipher;
+	struct mutex lock;
+};
+
 #endif
-- 
2.19.2

