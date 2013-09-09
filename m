Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab3IIQJE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 12:09:04 -0400
Date: Mon, 9 Sep 2013 18:09:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: setup framework to corrupt specific fields
 of an inode V2
Message-ID: <20130909160900.GQ32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378473979-2432-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378473979-2432-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 06, 2013 at 09:26:19AM -0400, Josef Bacik wrote:
> @@ -93,6 +95,9 @@ static void print_usage(void)
>  	fprintf(stderr, "\t-b Number of bytes to be corrupted\n");
>  	fprintf(stderr, "\t-e Extent to be corrupted\n");
>  	fprintf(stderr, "\t-E The whole extent free to be corrupted\n");
> +	fprintf(stderr, "\t-i The inode item to corrupt (must also specify "
> +		"the field to corrupt\n");

forgotten )

> +	fprintf(stderr, "\t-f The field in the item to corrupt\n");
>  	exit(1);
>  }
>  
> @@ -344,10 +442,6 @@ int main(int ac, char **av)
>  	ac = ac - optind;
>  	if (ac == 0)
>  		print_usage();
> -	if (logical == 0 && !extent_tree)
> -		print_usage();
> -	if (copy < 0)
> -		print_usage();

Please base your patches on something more recent, I merged this hunk
manually 2 times already and it starts to diverge from trivial fixups
(which I'm fine with).

>  
>  	dev = av[optind];
>  
> @@ -361,6 +455,9 @@ int main(int ac, char **av)
>  	}
>  	if (extent_rec) {
>  		struct btrfs_trans_handle *trans;
> +
> +		if (logical == 0)

now it's (u64)-1 as the "invalie" value, and has to be added to the
'chunk_tree' branch as well.

> +			print_usage();
>  		trans = btrfs_start_transaction(root, 1);
>  		ret = corrupt_extent (trans, root, logical, 0);
>  		btrfs_commit_transaction(trans, root);
> @@ -374,6 +471,20 @@ int main(int ac, char **av)
>  		btrfs_commit_transaction(trans, root);
>  		goto out_close;
>  	}
> +	if (inode) {
> +		struct btrfs_trans_handle *trans;
> +
> +		if (!strlen(field))
> +			print_usage();
> +		printf("corrupting inode\n");
> +		trans = btrfs_start_transaction(root, 1);
> +		ret = corrupt_inode(trans, root, inode, field);
> +		btrfs_commit_transaction(trans, root);
> +		goto out_close;
> +	}
> +
> +	if (logical == 0)

same here

> +		print_usage();
>  
>  	if (bytes == 0)
>  		bytes = root->sectorsize;

All fixed and patch replaced in the middle of the branch, feel free to
review that I did not mess it up.

david
