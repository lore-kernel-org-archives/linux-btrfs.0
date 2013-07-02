Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3GBQ0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 12:26:07 -0400
Date: Tue, 2 Jul 2013 18:26:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix segmentation fault
Message-ID: <20130702162604.GI18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51c53889000d9fe000004a0d00004a0ea000000e0f48@amlmta037.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51c53889000d9fe000004a0d00004a0ea000000e0f48@amlmta037.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 22, 2013 at 02:39:21PM +0900, Kusanagi Kouichi wrote:
> @@ -224,12 +224,10 @@ again:
>  		goto out;
>  	}
>  
> -	cpath = realpath(path, 0);
> -	dname = strdup(cpath);
> +	dname = strdup(path);

We want realpath() here, and when it returns NULL, there was an
error that should be handled like in other cases where realpath is
used.

>  	dname = dirname(dname);
> -	vname = strdup(cpath);
> +	vname = strdup(path);
>  	vname = basename(vname);
> -	free(cpath);
>  
>  	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
>  	     strchr(vname, '/') ){
