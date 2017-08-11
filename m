Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50743 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdHKCN0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 22:13:26 -0400
Date: Fri, 11 Aug 2017 04:13:17 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/5] btrfs: Add zstd support
Message-ID: <20170811021317.ykbpots4vinw7yjb@angband.pl>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023902.3231324-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170810023902.3231324-1-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 09, 2017 at 07:39:02PM -0700, Nick Terrell wrote:
> Add zstd compression and decompression support to BtrFS.

Re-tested on arm64, amd64 and i386, this time everything seems fine so far.

As I'm too lazy to have a separate test setup for the zlib level patch,
I'm using a dummy implementation:

--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -423,10 +423,16 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
        return ret;
 }
 
+static void zstd_set_level(struct list_head *ws, unsigned int type)
+{
+       // TODO
+}
+
 const struct btrfs_compress_op btrfs_zstd_compress = {
        .alloc_workspace = zstd_alloc_workspace,
        .free_workspace = zstd_free_workspace,
        .compress_pages = zstd_compress_pages,
        .decompress_bio = zstd_decompress_bio,
        .decompress = zstd_decompress,
+       .set_level = zstd_set_level,
 };


It might be worthwhile to do some early testing using different levels,
though.


喵!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
