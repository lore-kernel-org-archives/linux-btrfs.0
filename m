Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab3LLS2o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 13:28:44 -0500
Date: Thu, 12 Dec 2013 19:28:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, guihc.fnst@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs-progs: deal with invalid key orderings and bad
 orphan items
Message-ID: <20131212182842.GU6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386779134-16228-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386779134-16228-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 11, 2013 at 11:25:34AM -0500, Josef Bacik wrote:
> @@ -5527,15 +5734,16 @@ again:
>  	}
>  	btrfs_release_path(&path);
>  	while(1) {
> -		ret = run_next_block(root, bits, bits_nr, &last, &pending,
> -				     &seen, &reada, &nodes, &extent_cache,
> -				     &chunk_cache, &dev_cache,
> +		ret = run_next_block(trans, root, bits, bits_nr, &last,
> +				     &pending, &seen, &reada, &nodes,
> +				     &extent_cache, &chunk_cache, &dev_cache,
>  				     &block_group_cache, &dev_extent_cache);
>  		if (ret != 0)
>  			break;
>  	}
>  
> -	ret = check_extent_refs(trans, root, &extent_cache);
> +	if (ret >= 0)
> +		ret = check_extent_refs(trans, root, &extent_cache);
>  	if (ret == -EAGAIN) {
>  		ret = btrfs_commit_transaction(trans, root);
>  		if (ret)

This hunk conflicts with Gui Hecheng's patch
"Btrfs-progs: fix btrfsck improper prompt on dropping snapshots"

I applied the change where necessary, but haven't reviewed if this does
not break the semantics. You may want to take a look.

thanks,
david
