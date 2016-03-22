Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36703 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbcCVJkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 05:40:00 -0400
MIME-Version: 1.0
In-Reply-To: <1455609767-26992-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1455609767-26992-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Tue, 22 Mar 2016 10:39:59 +0100
Message-ID: <CAMuHMdVfCP97jKauZ5j29zAnWPi0ro_hRkq=A0AS=N6jgPHdwA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix build warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 16, 2016 at 9:02 AM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> We were getting build warning about:
> fs/btrfs/extent-tree.c:7021:34: warning: ‘used_bg’ may be used
>         uninitialized in this function
>
> It is not a valid warning as used_bg is never used uninitilized since
> locked is initially false so we can never be in the section where
> 'used_bg' is used. But gcc is not able to understand that and we can
> initialize it while declaring to silence the warning.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

FWIW, I've posted an alternative patch that killed the silly locked variable
a while ago.
"[PATCH] Btrfs: Refactor btrfs_lock_cluster() to kill compiler warning"
https://lkml.org/lkml/2014/6/22/96

> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e2287c7..f24e4c3 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7018,7 +7018,7 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
>                    struct btrfs_free_cluster *cluster,
>                    int delalloc)
>  {
> -       struct btrfs_block_group_cache *used_bg;
> +       struct btrfs_block_group_cache *used_bg = NULL;
>         bool locked = false;
>  again:
>         spin_lock(&cluster->refill_lock);
> --
> 1.9.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
