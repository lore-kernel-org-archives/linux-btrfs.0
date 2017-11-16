Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40212 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbdKPBHY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 20:07:24 -0500
From: Nick Terrell <terrelln@fb.com>
To: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: move some zstd work data from stack to workspace
Date: Thu, 16 Nov 2017 01:07:19 +0000
Message-ID: <8E453D19-A43F-4472-BAAA-0944F6ACB324@fb.com>
References: <20171115172739.25017-1-dsterba@suse.com>
In-Reply-To: <20171115172739.25017-1-dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/15/17, 9:30 AM, "David Sterba" <dsterba@suse.com> wrote:
> * ZSTD_inBuffer in_buf
> * ZSTD_outBuffer out_buf
>
> are used in all functions to pass the compression parameters and the
> local variables consume some space. We can move them to the workspace
> and reduce the stack consumption:
>
> zstd.c:zstd_decompress                        -24 (136 -> 112)
> zstd.c:zstd_decompress_bio                    -24 (144 -> 120)
> zstd.c:zstd_compress_pages                    -24 (264 -> 240)

It looks good to me, and I ran my btrfs zstd compression and
decompression test and everything worked.

Is there a case where these 24 bytes matter, or is this just an easy
optimization?

Reviewed-by: Nick Terrell <terrelln@fb.com>


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
