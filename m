Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:43846 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbdESORk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 10:17:40 -0400
Subject: Re: [PATCH 2/3] Btrfs: lzo compression must free at least PAGE_SIZE
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170519133835.27843-1-nefelim4ag@gmail.com>
 <20170519133835.27843-3-nefelim4ag@gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <6a1f17d5-3cc8-f5c0-36af-39b41eebc426@bouton.name>
Date: Fri, 19 May 2017 16:17:38 +0200
MIME-Version: 1.0
In-Reply-To: <20170519133835.27843-3-nefelim4ag@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 19/05/2017 à 15:38, Timofey Titovets a écrit :
> If data compression didn't free at least one PAGE_SIZE, it useless to store that compressed extent
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/lzo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index bd0b0938..637ef1b0 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -207,7 +207,7 @@ static int lzo_compress_pages(struct list_head *ws,
>  		}
>  
>  		/* we're making it bigger, give up */
> -		if (tot_in > 8192 && tot_in < tot_out) {
> +		if (tot_in > 8192 && tot_in < tot_out + PAGE_SIZE) {
>  			ret = -E2BIG;
>  			goto out;
>  		}
I'm not familiar with this code but I was surprised by the test : you
would expect compression having a benefit when you are freeing an actual
page not reducing data by a page size. So unless I don't understand the
context shouldn't it be something like :

if (tot_in > 8192 && ((tot_in % PAGE_SIZE) <= (tot_out % PAGE_SIZE))

but looking at the code I see that this is in a while loop and there's
another test just after the loop in the existing code :

        if (tot_out > tot_in)
                goto out;

There's a couple of things I don't understand but isn't this designed to
stream data in small chunks through compression before writing it in the
end ? So isn't this later test the proper location to detect if
compression was beneficial ?

You might not save a page early on in the while loop working on a subset
of the data to compress but after enough data being processed you could
save a page. It seems odd that your modification could abort compression
early on although the same condition would become true after enough loops.

Isn't what you want something like :

        if (tot_out % PAGE_SIZE >= tot_in % PAGE_SIZE)
                goto out;

after the loop ?
The >= instead of > would avoid decompression in the case where the
compressed data is smaller but uses the same space on disk.

Best regards,

Lionel
