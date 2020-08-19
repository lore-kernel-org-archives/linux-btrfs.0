Return-Path: <SRS0=vkwB=B5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFE3C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 14:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C75A22080C
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597846609;
	bh=0CwqqpI/doCNdLbaPsaZaTuQDib4tuZ/A83w7/3MMDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LDC3xwZ8v/olbmj3IebmDct9t6TkF3z2YN4s9bWbA3l3GiPlu/YMLGTkR/unrde3g
	 Zenad242pfB2ZYUw08PIW8IgFH0TSgT5B53hOdmzKcKmhna7XFC/bMglA8ZeOj4Zen
	 bNJ3wPeWejf3Pq3TP3byAOMwkTPxs/w6jn2vs9fc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgHSOQr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 10:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgHSOQo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Aug 2020 10:16:44 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A24EE2078D;
        Wed, 19 Aug 2020 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597846603;
        bh=0CwqqpI/doCNdLbaPsaZaTuQDib4tuZ/A83w7/3MMDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2eskXGibcBkg54wYhLtn6iK6N3yjHMgqcWmYdY5HTeTZWOy/hQpA0iA99BGxN7E1
         aF0gsXiyBaPO9Svm8/EwjWV0hOwO0BxH05pJQBpcLZb6mxlKeUCJIYC2cTOimkRENn
         oPMo0JD2UtQn6i9nPrgqRAVh2rkzGVec1Qa6eejM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fs/btrfs: Fix -Wmissing-prototypes warnings
Date:   Wed, 19 Aug 2020 17:16:30 +0300
Message-Id: <20200819141630.1338693-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200819141630.1338693-1-leon@kernel.org>
References: <20200819141630.1338693-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Move function declaration to shared header file to fix multiple -Wmissing-prototypes
warnings like below:

fs/btrfs/zstd.c:369:5: warning: no previous prototype for ‘zstd_compress_pages’ [-Wmissing-prototypes]
  369 | int zstd_compress_pages(struct list_head *ws, struct address_space *mapping,
      |     ^~~~~~~~~~~~~~~~~~~

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 fs/btrfs/compression.c | 35 -----------------------------------
 fs/btrfs/compression.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1ab56a734e70..eeface30facd 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -29,41 +29,6 @@
 #include "extent_io.h"
 #include "extent_map.h"

-int zlib_compress_pages(struct list_head *ws, struct address_space *mapping,
-		u64 start, struct page **pages, unsigned long *out_pages,
-		unsigned long *total_in, unsigned long *total_out);
-int zlib_decompress_bio(struct list_head *ws, struct compressed_bio *cb);
-int zlib_decompress(struct list_head *ws, unsigned char *data_in,
-		struct page *dest_page, unsigned long start_byte, size_t srclen,
-		size_t destlen);
-struct list_head *zlib_alloc_workspace(unsigned int level);
-void zlib_free_workspace(struct list_head *ws);
-struct list_head *zlib_get_workspace(unsigned int level);
-
-int lzo_compress_pages(struct list_head *ws, struct address_space *mapping,
-		u64 start, struct page **pages, unsigned long *out_pages,
-		unsigned long *total_in, unsigned long *total_out);
-int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb);
-int lzo_decompress(struct list_head *ws, unsigned char *data_in,
-		struct page *dest_page, unsigned long start_byte, size_t srclen,
-		size_t destlen);
-struct list_head *lzo_alloc_workspace(unsigned int level);
-void lzo_free_workspace(struct list_head *ws);
-
-int zstd_compress_pages(struct list_head *ws, struct address_space *mapping,
-		u64 start, struct page **pages, unsigned long *out_pages,
-		unsigned long *total_in, unsigned long *total_out);
-int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb);
-int zstd_decompress(struct list_head *ws, unsigned char *data_in,
-		struct page *dest_page, unsigned long start_byte, size_t srclen,
-		size_t destlen);
-void zstd_init_workspace_manager(void);
-void zstd_cleanup_workspace_manager(void);
-struct list_head *zstd_alloc_workspace(unsigned int level);
-void zstd_free_workspace(struct list_head *ws);
-struct list_head *zstd_get_workspace(unsigned int level);
-void zstd_put_workspace(struct list_head *ws);
-
 static const char* const btrfs_compress_types[] = { "", "zlib", "lzo", "zstd" };

 const char* btrfs_compress_type2str(enum btrfs_compression_type type)
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 9f3dbe372631..8001b700ea3a 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -144,4 +144,39 @@ bool btrfs_compress_is_valid_type(const char *str, size_t len);

 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);

+int zlib_compress_pages(struct list_head *ws, struct address_space *mapping,
+		u64 start, struct page **pages, unsigned long *out_pages,
+		unsigned long *total_in, unsigned long *total_out);
+int zlib_decompress_bio(struct list_head *ws, struct compressed_bio *cb);
+int zlib_decompress(struct list_head *ws, unsigned char *data_in,
+		struct page *dest_page, unsigned long start_byte, size_t srclen,
+		size_t destlen);
+struct list_head *zlib_alloc_workspace(unsigned int level);
+void zlib_free_workspace(struct list_head *ws);
+struct list_head *zlib_get_workspace(unsigned int level);
+
+int lzo_compress_pages(struct list_head *ws, struct address_space *mapping,
+		u64 start, struct page **pages, unsigned long *out_pages,
+		unsigned long *total_in, unsigned long *total_out);
+int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb);
+int lzo_decompress(struct list_head *ws, unsigned char *data_in,
+		struct page *dest_page, unsigned long start_byte, size_t srclen,
+		size_t destlen);
+struct list_head *lzo_alloc_workspace(unsigned int level);
+void lzo_free_workspace(struct list_head *ws);
+
+int zstd_compress_pages(struct list_head *ws, struct address_space *mapping,
+		u64 start, struct page **pages, unsigned long *out_pages,
+		unsigned long *total_in, unsigned long *total_out);
+int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb);
+int zstd_decompress(struct list_head *ws, unsigned char *data_in,
+		struct page *dest_page, unsigned long start_byte, size_t srclen,
+		size_t destlen);
+void zstd_init_workspace_manager(void);
+void zstd_cleanup_workspace_manager(void);
+struct list_head *zstd_alloc_workspace(unsigned int level);
+void zstd_free_workspace(struct list_head *ws);
+struct list_head *zstd_get_workspace(unsigned int level);
+void zstd_put_workspace(struct list_head *ws);
+
 #endif
--
2.26.2

