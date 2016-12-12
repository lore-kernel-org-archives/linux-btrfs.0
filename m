Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752188AbcLLQMD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 11:12:03 -0500
Date: Mon, 12 Dec 2016 17:11:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Seraphime Kirkovski <kirkseraph@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Coding style fixes
Message-ID: <20161212161156.GU12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161212141005.24071-1-kirkseraph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161212141005.24071-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 12, 2016 at 03:10:05PM +0100, Seraphime Kirkovski wrote:
> Per Documentation/CodingStyle remove brackets on single expression
> if statements, add missing spaces after `,` and around `=`,
> remove unnecessary line continuations, add missing blank lines
> after declarations and fix mixed spaces and tabs.

I'm sure you could find more things to fix, there are eg. some missing
spaces around + or - binary operators. Patches that just fix the style
are usally not very welcome, but I think that doing a sweep once upon a
time is good. We had comment typos fixed in a similar fashion, so I'm not
against improving code aesthetics.

> @@ -394,7 +394,7 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
>  		q = bdev_get_queue(device->bdev);
>  		if (blk_queue_discard(q)) {
>  			num_devices++;
> -			minlen = min((u64)q->limits.discard_granularity,
> +			minlen = min_t(u64, q->limits.discard_granularity,
>  				     minlen);

This type of change is more like a cleanup and you can find more
instances where the type is applied to just one of the operands, while
min_t/max_t would be better. Feel free to send a separate patch for
that.
