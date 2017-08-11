Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58497 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752011AbdHKDXT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 23:23:19 -0400
From: Nick Terrell <terrelln@fb.com>
To: Adam Borowski <kilobyte@angband.pl>
CC: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/5] btrfs: Add zstd support
Date: Fri, 11 Aug 2017 03:23:04 +0000
Message-ID: <E65158FB-D839-4949-BA9E-B62DAC9D0104@fb.com>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023902.3231324-1-terrelln@fb.com>
 <20170811021317.ykbpots4vinw7yjb@angband.pl>
In-Reply-To: <20170811021317.ykbpots4vinw7yjb@angband.pl>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/10/17, 7:13 PM, "Adam Borowski" <kilobyte@angband.pl> wrote:
> On Wed, Aug 09, 2017 at 07:39:02PM -0700, Nick Terrell wrote:
>> Add zstd compression and decompression support to BtrFS.
> 
> Re-tested on arm64, amd64 and i386, this time everything seems fine so far.
> 
> As I'm too lazy to have a separate test setup for the zlib level patch,
> I'm using a dummy implementation:
> 
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -423,10 +423,16 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
>         return ret;
>  }
>  
> +static void zstd_set_level(struct list_head *ws, unsigned int type)
> +{
> +       // TODO
> +}
> +
>  const struct btrfs_compress_op btrfs_zstd_compress = {
>         .alloc_workspace = zstd_alloc_workspace,
>         .free_workspace = zstd_free_workspace,
>         .compress_pages = zstd_compress_pages,
>         .decompress_bio = zstd_decompress_bio,
>         .decompress = zstd_decompress,
> +       .set_level = zstd_set_level,
>  };
> 
> 
> It might be worthwhile to do some early testing using different levels,
> though.

I'll run some preliminary tests and make sure nothing blows up and the
compression ratio looks good.

> 
> 
> å–µ!
> -- 
> â¢€â£´â ¾â »â¢¶â£¦â € 
> â£¾â â¢ â ’â €â£¿â¡ A dumb species has no way to open a tuna can.
> â¢¿â¡„â ˜â ·â šâ ‹â € A smart species invents a can opener.
> â ˆâ ³â£„â €â €â €â € A master species delegates.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
