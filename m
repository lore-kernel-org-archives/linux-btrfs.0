Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161258Ab3BONR0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 08:17:26 -0500
Date: Fri, 15 Feb 2013 14:17:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH] btrfs: use kmalloc for lzo de/compress buffer
Message-ID: <20130215131724.GP12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360933701-17434-1-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360933701-17434-1-git-send-email-kyungsik.lee@lge.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 15, 2013 at 10:08:21PM +0900, Kyungsik Lee wrote:
> The size of de/compress buffer and LZO1X_MEM_COMPRESS is small enough.

Unfortunatelly it is not.

include/linux/lzo.h:

#define LZO1X_MEM_COMPRESS      (16384 * sizeof(unsigned char *))

128k with 8 byte pointers

> @@ -54,9 +53,10 @@ static struct list_head *lzo_alloc_workspace(void)
>  	if (!workspace)
>  		return ERR_PTR(-ENOMEM);
>  
> -	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);

vmalloc needed

> -	workspace->buf = vmalloc(PAGE_CACHE_SIZE);

kmalloc is ok here

> -	workspace->cbuf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));

#define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)

4096+4096/16+64+3 = 4419

vmalloc needed as well

david
