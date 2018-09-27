Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9662FC004D5
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4D6215F0
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="z/caWFSC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F4D6215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbeI1Ahr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:37:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43837 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbeI1Ahr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:37:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id j26-v6so2460181pfi.10
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T+NFN9NWs+Mlw0O4AU4cAMqXtia5hH+lkj6tgPdvIGI=;
        b=z/caWFSCrDh6wG3X9A3bOKKqNfhJ5siHyK6zUe4QvRYzYiwJuLQ/I/8fKvGnXlScxU
         tjsYLxHRNqF4fQTTMZ2SeLvoEvCf/6l5xXNbIHp+U2dOj/5K63BrHw9wk9710sUmYi1E
         Bc+TExvzhhXEcdb4/HbpPfOusSPVUQ8KcUEM9T815LujpZnfop3LypGhA8udcPtI+IZj
         1t9X/CsP4MymPg/cbyvE+d9iY0mARCenPpZC7SIOnfeeCrxJW8cbWq0+4e4b5UUcyotj
         VW8m8U+GyJ1CAad2AU3QJD+/W9NYwXDK4+GP9mmJxO61JIz4YAyuHnSupeO03yyJUcla
         WfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T+NFN9NWs+Mlw0O4AU4cAMqXtia5hH+lkj6tgPdvIGI=;
        b=pH4HMILiBVJWWlS5qYFbBsLlj6iYodkBeo9M0pHrrj+ns9vY70cZG/Ev7DrfoMs5hX
         hH7/S9wcFmBsZOn6Mu5+QGR8iHeAajUuumhv6LJll3oV/otXDzxn3hnEb1NsCN1yD6JO
         /V/TQe46bndjS9Jvo0BV9p93Sy80GZKsJk0MNf9eUY4IY9XTWFGd8HVOg8LYB8ppGI8A
         RAdA7I3HRqnH3kT/XIVsY0gCs+Vz/2RWD6kaV4PvLBZ64QLQyWE9EPKRgEYUNAxHZHFj
         lkXf+ItPsWwppfzavsr3/nnr0r18u7b7gYMk1bAPZRpaqDwiif+gKywW916tUSP9jchT
         cAgw==
X-Gm-Message-State: ABuFfogrjy2T/5HWk+XSJlm0dOSdGBUNTg5olQcjsxbuTtAiC3YcD10v
        3fxYuulhmaQbq04cNa0RLphx/h6lo/g=
X-Google-Smtp-Source: ACcGV62Q7lMRu1UM7zBN0da0nTYBwbilCXUBmvOHJLhuUj0CC2gx5ZzuyFwp5CUuTgi4LKnvQRur7g==
X-Received: by 2002:a62:3306:: with SMTP id z6-v6mr12629911pfz.85.1538072295694;
        Thu, 27 Sep 2018 11:18:15 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id p19-v6sm4086614pgh.60.2018.09.27.11.18.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 11:18:15 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v9 5/6] Btrfs: rename get_chunk_map() and make it non-static
Date:   Thu, 27 Sep 2018 11:17:37 -0700
Message-Id: <fbdb60300626ecb9954021e0a33a7c885b2296dd.1538072009.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1538072009.git.osandov@fb.com>
References: <cover.1538072009.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

The Btrfs swap code is going to need it, so give it a btrfs_ prefix and
make it non-static.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/volumes.c | 29 ++++++++++++++++++-----------
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index aa37ae30bf62..20c26afdd330 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2714,8 +2714,15 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	return ret;
 }
 
-static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
-					u64 logical, u64 length)
+/*
+ * btrfs_get_chunk_map() - Find the mapping containing the given logical extent.
+ * @logical: Logical block offset in bytes.
+ * @length: Length of extent in bytes.
+ *
+ * Return: Chunk mapping or ERR_PTR.
+ */
+struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
+				       u64 logical, u64 length)
 {
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
@@ -2752,7 +2759,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 	int i, ret = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 
-	em = get_chunk_map(fs_info, chunk_offset, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
 	if (IS_ERR(em)) {
 		/*
 		 * This is a logic error, but we don't want to just rely on the
@@ -4902,7 +4909,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	int i = 0;
 	int ret = 0;
 
-	em = get_chunk_map(fs_info, chunk_offset, chunk_size);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, chunk_size);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5044,7 +5051,7 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	int miss_ndevs = 0;
 	int i;
 
-	em = get_chunk_map(fs_info, chunk_offset, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
 	if (IS_ERR(em))
 		return 1;
 
@@ -5104,7 +5111,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	struct map_lookup *map;
 	int ret;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 	if (IS_ERR(em))
 		/*
 		 * We could return errors for these cases, but that could get
@@ -5150,7 +5157,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	struct map_lookup *map;
 	unsigned long len = fs_info->sectorsize;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 
 	if (!WARN_ON(IS_ERR(em))) {
 		map = em->map_lookup;
@@ -5167,7 +5174,7 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	struct map_lookup *map;
 	int ret = 0;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 
 	if(!WARN_ON(IS_ERR(em))) {
 		map = em->map_lookup;
@@ -5326,7 +5333,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 	/* discard always return a bbio */
 	ASSERT(bbio_ret);
 
-	em = get_chunk_map(fs_info, logical, length);
+	em = btrfs_get_chunk_map(fs_info, logical, length);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5652,7 +5659,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		return __btrfs_map_block_for_discard(fs_info, logical,
 						     *length, bbio_ret);
 
-	em = get_chunk_map(fs_info, logical, *length);
+	em = btrfs_get_chunk_map(fs_info, logical, *length);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5951,7 +5958,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 	u64 rmap_len;
 	int i, j, nr = 0;
 
-	em = get_chunk_map(fs_info, chunk_start, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_start, 1);
 	if (IS_ERR(em))
 		return -EIO;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 23e9285d88de..f4c190c2ab84 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -465,6 +465,8 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 			     u64 chunk_offset, u64 chunk_size);
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset);
+struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
+				       u64 logical, u64 length);
 
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
-- 
2.19.0

