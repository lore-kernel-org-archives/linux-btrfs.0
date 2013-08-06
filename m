Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab3HFAVV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 20:21:21 -0400
Date: Tue, 6 Aug 2013 02:21:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs.btrfs documentation: clarify current
 restrictions of sectorsize, nodesize and leafsize
Message-ID: <20130806002119.GI5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1373576177-9272-1-git-send-email-koen.de.wit@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373576177-9272-1-git-send-email-koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 11, 2013 at 10:56:17PM +0200, Koen De Wit wrote:
> Commit 8d082fb727ac11930ea20bf1612e334ea7c2b697 (Btrfs: do not mount when
> we have a sectorsize unequal to PAGE_SIZE) requires the sectorsize to be
> equal to the pagesize for the filesystem to be mountable.
> 
> The nodesize and leafsize should be equal, and not larger than 65536.
> 
> Adding this information to the manpage and usage instructions of mkfs.btrfs.

Please don't forget to add your signed-off-by line.

> --- a/man/mkfs.btrfs.8.in
> +++ b/man/mkfs.btrfs.8.in
> @@ -46,7 +46,8 @@ there is a filesystem or partition table on the device already.
>  .TP
>  \fB\-l\fR, \fB\-\-leafsize \fIsize\fR
>  Specify the leaf size, the least data item in which btrfs stores data. The
> -default value is the page size.
> +default value is the page size. Must be a multiple of the sectorsize, but
> +not larger than 65536. Should be equal to the nodesize.

As implemented now, setting one of leafsize/nodesize will set both, so
it's not necessary to specify both. The help text should reflect that.

> -Specify the nodesize. By default the value is set to the pagesize.
> +Specify the nodesize. By default the value is set to the pagesize. Must be a
> +multiple of the sectorsize, but not larger than 65536. Should be equal to the
> +leafsize.

>  .TP
>  \fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
> -Specify the sectorsize, the minimum block allocation.
> +Specify the sectorsize, the minimum block allocation. The default value is
> +the pagesize. If the sectorsize differs from the pagesize, the created
> +filesystem cannot be mounted by the current kernel. Therefore it is not
> +recommended to use this option.

"... unless you know what you're doing." :)

> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -319,7 +319,7 @@ static void print_usage(void)
>  	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
>  	fprintf(stderr, "\t -M --mixed mix metadata and data together\n");
>  	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
> -	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
> +	fprintf(stderr, "\t -s --sectorsize min block allocation (not mountable by current kernel)\n");

What if I'm on a ppc64 box? This message will be confusing. I'd stick
'may' into (...)

I'll fix the text wording when committing the patch, no need to resend.

david
