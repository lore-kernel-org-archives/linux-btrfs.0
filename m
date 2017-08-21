Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754366AbdHUPd3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 11:33:29 -0400
Date: Mon, 21 Aug 2017 17:32:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 0/7] add sanity check for extent inline ref type
Message-ID: <20170821153204.GK2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818211524.31325-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:15:17PM -0600, Liu Bo wrote:
> An invalid extent inline ref type could be read from a btrfs image and
> it ends up with a panic[1], this set is to deal with the insane value
> gracefully in patch 1-2 and clean up BUG() in the code in patch 3-6.
> 
> Patch 7 adds one more check to see if the ref is a valid shared one.
> 
> I'm not sure in the real world what may result in this corruption, but
> I've seen several reports on the ML about __btrfs_free_extent saying
> something was missing (or simply wrong), while testing this set with
> btrfs-corrupt-block, I found that switching ref type could end up that
> situation as well, eg. a data extent's ref type
> (BTRFS_EXTENT_DATA_REF_KEY) is switched to (BTRFS_TREE_BLOCK_REF_KEY).
> Hopefully this can give people more sights next time when that
> happens.
> 
> [1]:https://www.spinics.net/lists/linux-btrfs/msg65646.html
> 
> v3:
> - btrfs_inline_ref_types -> btrfs_inline_ref_type
> - convert WARN(1) to btrfs_err so that we know which btrfs has that error.
> 
> v2:
> - add enum type and return BTRFS_REF_TYPE_INVALID instead of -EINVAL.
> - remove one more BUG_ON which is in __add_tree_block.
> - add validation check for shared refs.
> - improve btrfs_print_leaf to show which refs has something wrong.
> 
> Liu Bo (7):
>   Btrfs: add a helper to retrive extent inline ref type
>   Btrfs: convert to use btrfs_get_extent_inline_ref_type
>   Btrfs: remove BUG() in btrfs_extent_inline_ref_size
>   Btrfs: remove BUG() in print_extent_item
>   Btrfs: remove BUG() in add_data_reference
>   Btrfs: remove BUG_ON in __add_tree_block
>   Btrfs: add one more sanity check for shared ref type

Added to 4.14 queue, some trivial fixups were needed due to other patches.
