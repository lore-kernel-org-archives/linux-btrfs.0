Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756140AbdKOUJb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 15:09:31 -0500
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>
Subject: Re: Read before you deploy btrfs + zstd
Date: Wed, 15 Nov 2017 20:09:15 +0000
Message-ID: <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com>
References: <20171113225046.GD28899@suse.cz>
 <20171114185331.GJ28899@twin.jikos.cz> <20171115143906.GM28899@twin.jikos.cz>
In-Reply-To: <20171115143906.GM28899@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/15/17, 6:41 AM, "David Sterba" <dsterba@suse.cz> wrote:
> The branch is now in a state that can be tested. Turns out the memory
> requirements are too much for grub, so the boot fails with "not enough
> memory". The calculated value
>
> ZSTD_BTRFS_MAX_INPUT: 131072
> ZSTD_DStreamWorkspaceBound with ZSTD_BTRFS_MAX_INPUT: 549424
>
> This is not something I could fix easily, we'd probalby need a tuned
> version of ZSTD for grub constraints. Adding Nick to CC.

If I understand the grub code correctly, we only need to read, and we have
the entire input and output buffer in one segment. In that case you can use
ZSTD_initDCtx(), and ZSTD_decompressDCtx(). ZSTD_DCtxWorkspaceBound() is
only 155984. See decompress_single() in
https://patchwork.kernel.org/patch/9997909/ for an example.

This (uncompiled and untested) code should work:

```
static grub_ssize_t
grub_btrfs_zstd_decompress(char *ibuf, grub_size_t isize, grub_off_t off,
                           char *obuf, grub_size_t osize)
{
  grub_size_t ret = 0;
  ZSTD_DCtx *ctx;
  void *wmem;
  grub_size_t wsize;

  wsize = ZSTD_DCtxWorkspaceBound();
  wmem = grub_malloc(wsize);
  if (!wmem)
    {
       return -1;
    }
  ctx = ZSTD_initDCtx(wmem, wsize);
  if (!ctx)
    {
       grub_free(wmem);
       return -1;
    }

  /* This is only necessary if there is junk after the end of the zstd
   * compressed data in the input buffer. Otherwise the return value
   * should always be exactly isize. If you delete this, and it always works,
   * then there isn't junk data at the end.
   */
  isize = ZSTD_findFrameCompressedSize(in_buf, in_len);
  if (ZSTD_isError(isize))
    {
       grub_free(wmem);
       return -1;
    }

  ret = ZSTD_decompressDCtx(ctx, obuf, osize, ibuf, isize);
  grub_free(wmem);
  if (ZSTD_isError(ret))
    {
       return -1;
    }
  return ret;
}
```


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
