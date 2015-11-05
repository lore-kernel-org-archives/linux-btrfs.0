Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:35514
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030996AbbKENIu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 08:08:50 -0500
Subject: Re: [PATCH] btrfs: clear bio reference after submit_one_bio()
To: Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
References: <1420473663-9315-1-git-send-email-naota@elisp.net>
 <54AC65C2.8000801@jp.fujitsu.com>
 <CAOcd+r10Q08zhvjMawOrQ8jWBReD6dYxeEtiZSoqUEuHCeM27g@mail.gmail.com>
Cc: Naohiro Aota <naota@elisp.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <563B54DF.7080202@googlemail.com>
Date: Thu, 5 Nov 2015 14:08:47 +0100
MIME-Version: 1.0
In-Reply-To: <CAOcd+r10Q08zhvjMawOrQ8jWBReD6dYxeEtiZSoqUEuHCeM27g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/11/15 20:09, Alex Lyakas wrote:
> Hi Naota,
> 
> What happens if btrfs_bio_alloc() in submit_extent_page fails? Then we
> return -ENOMEM to the caller, but we do not set *bio_ret to NULL. And
> if *bio_ret was non-NULL upon entry into submit_extent_page, then we
> had submitted this bio before getting to btrfs_bio_alloc(). So should
> btrfs_bio_alloc() failure be handled in the same way?
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 3915c94..cd443bc 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2834,8 +2834,11 @@ static int submit_extent_page(int rw, struct
> extent_io_tree *tree,
> 
>         bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
>                         GFP_NOFS | __GFP_HIGH);
> -       if (!bio)
> +       if (!bio) {
> +               if (bio_ret)
> +                       *bio_ret = NULL;
>                 return -ENOMEM;
> +       }
> 
>         bio_add_page(bio, page, page_size, offset);
>         bio->bi_end_io = end_io_func;
> 

Did you get any feedback on this? It seems it could cause data loss or
corruption on allocation failures, no?

-h

