Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382Ab2JKVja (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 17:39:30 -0400
Date: Thu, 11 Oct 2012 14:39:29 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: extended inode refs support for send mechanism
Message-ID: <20121011213928.GY8097@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1349868091-23041-1-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349868091-23041-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan!

On Wed, Oct 10, 2012 at 01:21:31PM +0200, Jan Schmidt wrote:
> @@ -1574,11 +1599,22 @@ static int get_first_ref(struct send_ctx *sctx,
>  		goto out;
>  	}
>  
> -	iref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> -			struct btrfs_inode_ref);
> -	len = btrfs_inode_ref_name_len(path->nodes[0], iref);
> -	ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
> -			(unsigned long)(iref + 1), len);
> +	if (key.type == BTRFS_INODE_REF_KEY) {
> +		struct btrfs_inode_ref *iref;
> +		iref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +				      struct btrfs_inode_ref);
> +		len = btrfs_inode_ref_name_len(path->nodes[0], iref);
> +		ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
> +						     (unsigned long)(iref + 1),
> +						     len);
> +	} else {
> +		struct btrfs_inode_extref *extref;
> +		extref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +					struct btrfs_inode_extref);
> +		len = btrfs_inode_extref_name_len(path->nodes[0], extref);
> +		ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
> +					(unsigned long)&extref->name, len);
> +	}
>  	if (ret < 0)
>  		goto out;
>  	btrfs_release_path(path);

Ok there's the following line in get_first_ref() which I believe was missed:

	*dir = found_key.offset;

that will have to account for an extended ref.

The rest of the patch looks pretty good to me. Thanks for writing this up!
	--Mark

--
Mark Fasheh
