Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab3H3WxW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 18:53:22 -0400
Date: Sat, 31 Aug 2013 00:53:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: setup framework to corrupt specific fields
 of an inode
Message-ID: <20130830225320.GT23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376927312-2898-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376927312-2898-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 19, 2013 at 11:48:32AM -0400, Josef Bacik wrote:
> @@ -344,10 +442,12 @@ int main(int ac, char **av)
>  	ac = ac - optind;
>  	if (ac == 0)
>  		print_usage();
> -	if (logical == 0 && !extent_tree)
> +	if (logical == 0 && (!extent_tree && !inode))

There's a conflict with the chunk-recovery patches and this check does
not make sense with the -i & -f options. The one below is the one I'd
expect here, thus removing the one above.

>  		print_usage();
>  	if (copy < 0)
>  		print_usage();
> +	if ((inode && !strlen(field)) || (strlen(field) && !inode))
> +		print_usage();
>  
>  	dev = av[optind];
>  
