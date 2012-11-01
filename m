Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:44071 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756931Ab2KANhs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 09:37:48 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id naHX9u9VysbEoGrU (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 07:37:47 -0600 (MDT)
Date: Thu, 1 Nov 2012 09:37:46 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: check block group used count and fix if
 specified
Message-ID: <20121101133746.GA8307@shiny>
References: <1351773294-1458-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1351773294-1458-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 01, 2012 at 06:34:54AM -0600, Josef Bacik wrote:
> A user reported a problem where all of his block groups had invalid used
> counts in the block group item.  This patch walks the extent tree and counts
> up the used amount for each block group.  If the user specifies repair we
> can set the correct used value and when the transaction commits we're all
> set.  This was reported and tested by a user and worked.  Thanks,

Josef and I hashed this out a little bit on irc.  My fsck repair code
already tries to fix the block group accounting, but I think there is a
key part his code does differently (correctly ;):

> +static int check_block_groups_used(struct btrfs_trans_handle *trans,
> +				   struct btrfs_root *root, int repair)
> +{
> +	struct btrfs_block_group_cache *block_group;
> +	struct btrfs_path *path;
> +	u64 bytenr = 0;
> +	int ret;
> +	int err = 0;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	path->reada = 2;
> +	while ((block_group = btrfs_lookup_first_block_group(root->fs_info,
> +							     bytenr))) {
> +		ret = check_block_group_used(trans, root, block_group, path,
> +					     repair);
> +		if (ret && !err)
> +			ret = err;
> +		bytenr = block_group->key.objectid + block_group->key.offset;
> +	}
> +	btrfs_free_path(path);
> +
> +	return err;
> +}

My code reuses btrfs_fix_block_group_acounting, which does this:

	start = 0;
        while(1) {
                cache = btrfs_lookup_block_group(fs_info, start);
                if (!cache)
                        break; 
                start = cache->key.objectid + cache->key.offset;
                btrfs_set_block_group_used(&cache->item, 0);
                cache->space_info->bytes_used = 0;
                set_extent_bits(&root->fs_info->block_group_cache,
                                cache->key.objectid,
                                cache->key.objectid + cache->key.offset -1,
                                BLOCK_GROUP_DIRTY, GFP_NOFS);
        }

Using btrfs_lookup_first_block_group here should fix things.  It must be
breaking out too soon and so the accounting isn't updated properly.

-chris
