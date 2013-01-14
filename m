Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab3ANWxM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 17:53:12 -0500
Date: Mon, 14 Jan 2013 23:53:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add UUID switches to mkfs and convert
Message-ID: <20130114225309.GQ20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357486331-4615-1-git-send-email-falbrechtskirchinger@gmail.com>
 <1357486331-4615-2-git-send-email-falbrechtskirchinger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357486331-4615-2-git-send-email-falbrechtskirchinger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 06, 2013 at 04:32:11PM +0100, Florian Albrechtskirchinger wrote:
> Add the following switches to mkfs.btrfs and update man page:
> * -U UUID, --uuid UUID
> 
> Add the following switches to btrfs-convert:
> * -U UUID
> * -U new
>   Generates a random UUID (default behavior).
> * -U copy
>   Copies the UUID from the ext2fs.

Sounds useful, thanks. There are minor comments to the
documentation/help strings.

More than one filesystem with the same UUID brings trouble when mounting
by UUID, a check that would at least warn that there are more such
filesystems would be good. This should catch easy & silly copy-paste
errors.

> --- a/convert.c
> +++ b/convert.c
> @@ -2752,23 +2759,28 @@ fail:
>  
>  static void print_usage(void)
>  {
> -	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] device\n");
> +	printf("usage: btrfs-convert [-d] [-i] [-n] [-r]"
> +	       " [-U UUID | new | copy] device\n");
>  	printf("\t-d disable data checksum\n");
>  	printf("\t-i ignore xattrs and ACLs\n");
>  	printf("\t-n disable packing of small files\n");
>  	printf("\t-r roll back to ext2fs\n");
> +	printf("\t-U UUID specify FS UUID\n");
> +	printf("\t-U new generate random FS UUID (default)\n");
> +	printf("\t-U copy copy FS UUID from ext2fs\n");

>From this is not clear that 'new' and 'copy' should be typed verbatim
(ie.  that it's not part of the help text), the expected format of the
UUID like "specify FS UUID in canonical format'.

>  }
>  
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -347,6 +347,7 @@ static void print_usage(void)
>  	fprintf(stderr, "\t -M --mixed mix metadata and data together\n");
>  	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
>  	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
> +	fprintf(stderr, "\t -U --uuid FS UUID\n");

maybe a little bit enhanced with the 'in canonical format'.

>  	fprintf(stderr, "\t -r --rootdir the source directory\n");
>  	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
>  	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
