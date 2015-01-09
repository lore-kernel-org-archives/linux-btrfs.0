Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbbAIQLo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 11:11:44 -0500
Date: Fri, 9 Jan 2015 17:11:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: btrfs_inode_item's otime?
Message-ID: <20150109161142.GC3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150105172152.GB19126@gardel-login>
 <3797928.30urVis5AR@quad>
 <20150106184100.GF24104@twin.jikos.cz>
 <2188846.ArnMyWRJKN@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2188846.ArnMyWRJKN@quad>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 08, 2015 at 09:52:30PM +1100, Chris Samuel wrote:
> Sorry for the delay, took a while to poke around the code to figure
> out possible ways it would get done (and what the right structure was).

No delay noticed :)

> > Set the otime in btrfs_new_inode after the call to fill_inode_item.
> Unfortunately I won't have a test system to try this on for a little while.
> 
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e687bb0..60bcc72 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5835,6 +5835,11 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>                              sizeof(*inode_item));
>         fill_inode_item(trans, path->nodes[0], inode_item, inode);
>  
> +       /*
> +        * Set the creation time on the inode.
> +        */
> +       btrfs_set_stack_timespec_sec( &inode.otime, cur_time.tv_sec );

Drop the spaces after/before parens and also set usec the same way.
There's no such thing as 'current_time', only CURRENT_TIME but that
cannot be used directly as a structure.

Given that the mtime is set a few lines above, copy the tv_sec and
tv_usec from there.

> +
>         if (name) {
>                 ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
>                                      struct btrfs_inode_ref);
> 
