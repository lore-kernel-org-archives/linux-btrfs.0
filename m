Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab3BFSqX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Feb 2013 13:46:23 -0500
Date: Wed, 6 Feb 2013 10:46:21 -0800
From: Zach Brown <zab@redhat.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified.
Message-ID: <20130206184621.GP14246@lenny.home.zabbo.net>
References: <1360167017-19632-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360167017-19632-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +	unsigned compressed_extent_size;

It kind of jumps out that this mentions neither that it's the max nor
that it's in KB.  How about max_compressed_extent_kb?

> +	fs_info->compressed_extent_size = 128;

I'd put a DEFAULT_MAX_EXTENTS up by the MAX_ definition instead of using
a raw 128 here.

> +	unsigned long max_compressed = root->fs_info->compressed_extent_size * 1024;
> +	unsigned long max_uncompressed = root->fs_info->compressed_extent_size * 1024;

(so max_compressed is in bytes)

>  	nr_pages = (end >> PAGE_CACHE_SHIFT) - (start >> PAGE_CACHE_SHIFT) + 1;
> -	nr_pages = min(nr_pages, (128 * 1024UL) / PAGE_CACHE_SIZE);
> +	nr_pages = min(nr_pages, (max_compressed * 1024UL) / PAGE_CACHE_SIZE);

(and now that expression adds another * 1024, allowing {128,512}MB
extents :))

>  	 * We also want to make sure the amount of IO required to do
>  	 * a random read is reasonably small, so we limit the size of
> -	 * a compressed extent to 128k.
> +	 * a compressed extent (default of 128k).

Just drop the value so that this comment doesn't need to be updated
again.

-	 * a compressed extent to 128k.
+	 * a compressed extent.

> +	{Opt_compr_extent_size, "compressed_extent_size=%d"},

It's even more important to make the exposed option self-documenting
than it was to get the fs_info member right.

> +			if ((intarg == 128) || (intarg == 512)) {
> +				info->compressed_extent_size = intarg;
> +				printk(KERN_INFO "btrfs: compressed extent size %d\n",
> +				       info->compressed_extent_size);
> +			} else {
> +				printk(KERN_INFO "btrfs: "
> +					"Invalid compressed extent size,"
> +					" using default.\n");

I'd print the default value when it's used and would include a unit in
both.

> +	if (btrfs_test_opt(root, COMPR_EXTENT_SIZE))
> +		seq_printf(seq, ",compressed_extent_size=%d",
> +			   (unsigned long long)info->compressed_extent_size);

The (ull) cast doesn't match the %d format and wouldn't be needed if it
was printed with %u.

- z
