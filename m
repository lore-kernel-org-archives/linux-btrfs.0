Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41979 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdF3DYv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 23:24:51 -0400
Date: Fri, 30 Jun 2017 05:24:43 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        David Sterba <dsterba@suse.cz>, squashfs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Message-ID: <20170630032443.nji7n5kwk7bxopzp@angband.pl>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170629194108.1674498-4-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 12:41:07PM -0700, Nick Terrell wrote:
> Add zstd compression and decompression support to BtrFS. zstd at its
> fastest level compresses almost as well as zlib, while offering much
> faster compression and decompression, approaching lzo speeds.

> +static int zstd_decompress_bio(struct list_head *ws, struct page **pages_in,
> +		u64 disk_start,
> +		struct bio *orig_bio,
> +		size_t srclen)

Note that this fails to build if e1ddce71 is applied, and it'll be in
mainline in just a few days from now.  Fixing that is obvious, but
to avoid duplicating the effort:


diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 838741b3732c..e9403e569d8e 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -25,6 +25,7 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 #include <linux/zstd.h>
+#include <linux/refcount.h>
 #include "compression.h"
 
 #define ZSTD_BTRFS_MAX_WINDOWLOG 17
@@ -262,17 +263,18 @@ static int zstd_compress_pages(struct list_head *ws,
        return ret;
 }
 
-static int zstd_decompress_bio(struct list_head *ws, struct page **pages_in,
-               u64 disk_start,
-               struct bio *orig_bio,
-               size_t srclen)
+static int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 {
        struct workspace *workspace = list_entry(ws, struct workspace, list);
        ZSTD_DStream *stream;
        int ret = 0;
        unsigned long page_in_index = 0;
+       size_t srclen = cb->compressed_len;
        unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_SIZE);
        unsigned long buf_start;
+       struct page **pages_in = cb->compressed_pages;
+       u64 disk_start = cb->start;
+       struct bio *orig_bio = cb->orig_bio;
        unsigned long total_out = 0;
        ZSTD_inBuffer in_buf = { NULL, 0, 0 };
        ZSTD_outBuffer out_buf = { NULL, 0, 0 };


-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
