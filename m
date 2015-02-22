Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56034 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbbBVLUM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Feb 2015 06:20:12 -0500
MIME-Version: 1.0
In-Reply-To: <1423915822-23442-1-git-send-email-fabf@skynet.be>
References: <1423915822-23442-1-git-send-email-fabf@skynet.be>
Date: Sun, 22 Feb 2015 12:20:11 +0100
Message-ID: <CAMuHMdXOVzn36+akifJ0TNp8=Fss4k1iR9Z=D+P=KXd8kAHzFg@mail.gmail.com>
Subject: Re: [PATCH 1/1 linux-next] btrfs: fix sizeof format specifier in btrfs_check_super_valid()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 14, 2015 at 1:10 PM, Fabian Frederick <fabf@skynet.be> wrote:
> This patch fixes mips compilation warning:

Actually it happens on all 32-bit platforms (where size_t is unsigned int).

> fs/btrfs/disk-io.c: In function 'btrfs_check_super_valid':
> fs/btrfs/disk-io.c:3927:21: warning: format '%lu' expects argument
> of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  fs/btrfs/disk-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f79f385..639f266 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3921,7 +3921,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>         }
>         if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
>                         + sizeof(struct btrfs_chunk)) {
> -               printk(KERN_ERR "BTRFS: system chunk array too small %u < %lu\n",
> +               printk(KERN_ERR "BTRFS: system chunk array too small %u < %zu\n",
>                                 btrfs_super_sys_array_size(sb),
>                                 sizeof(struct btrfs_disk_key)
>                                 + sizeof(struct btrfs_chunk));

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
