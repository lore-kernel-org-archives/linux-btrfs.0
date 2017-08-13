Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36961 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdHMIbm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 04:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <20170804201921.156890-5-terrelln@fb.com>
References: <20170804201921.156890-1-terrelln@fb.com> <20170804201921.156890-5-terrelln@fb.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 13 Aug 2017 10:31:41 +0200
Message-ID: <CAMuHMdXGR2zG+LS9Qa1foLfWCzpFSmq2f=mNJp-65bH3ZwjoAA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] squashfs: Add zstd support
To: Nick Terrell <terrelln@fb.com>
Cc: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        squashfs-devel@lists.sourceforge.net,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 4, 2017 at 10:19 PM, Nick Terrell <terrelln@fb.com> wrote:
> --- a/fs/squashfs/decompressor.c
> +++ b/fs/squashfs/decompressor.c
> @@ -65,6 +65,12 @@ static const struct squashfs_decompressor squashfs_zlib_comp_ops = {
>  };
>  #endif
>
> +#ifndef CONFIG_SQUASHFS_ZSTD
> +static const struct squashfs_decompressor squashfs_zstd_comp_ops = {
> +       NULL, NULL, NULL, NULL, ZSTD_COMPRESSION, "zstd", 0

Can you please use designated initializers?

> +};
> +#endif
> +
>  static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
>         NULL, NULL, NULL, NULL, 0, "unknown", 0
> ;

> +const struct squashfs_decompressor squashfs_zstd_comp_ops = {
> +       .init = zstd_init,
> +       .free = zstd_free,
> +       .decompress = zstd_uncompress,
> +       .id = ZSTD_COMPRESSION,
> +       .name = "zstd",
> +       .supported = 1
> +};

... like you did here.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
