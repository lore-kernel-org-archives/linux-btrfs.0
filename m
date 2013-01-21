Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab3AUP4d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 10:56:33 -0500
Date: Mon, 21 Jan 2013 16:56:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org, Nageswara R Sastry <nasastry@in.ibm.com>
Subject: Re: [PATCH 01/13] btrfs-progs: btrfs-image.c: Added NULL pointer
 check.
Message-ID: <20130121155630.GI19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <1358715858-4469-2-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358715858-4469-2-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 04:04:06PM -0500, Gene Czarcinski wrote:
> From: Nageswara R Sastry <nasastry@in.ibm.com>
> 
> Check for the return value of 'open_ctree()' before dereferencing it.
> 
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -491,6 +491,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
>  	int ret;
>  
>  	root = open_ctree(input, 0, 0);
> +	BUG_ON(!root);

Bug_on is not the right fix here, I prefer a more extensive fix

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15305

which prints a message and exits.

>  	BUG_ON(root->nodesize != root->leafsize);
>  
>  	ret = metadump_init(&metadump, root, out, num_threads,
