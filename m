Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbeEKMPP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 08:15:15 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 206B7AF0A
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 12:15:14 +0000 (UTC)
Date: Fri, 11 May 2018 14:12:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/17] Freespace tree big fs_info cleanup
Message-ID: <20180511121234.GX6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 03:44:39PM +0300, Nikolay Borisov wrote:
> Here is a series which cleans _all_ freespace tree functions from a redundant
> fs_info argument since they already take either a transaction or a 
> block_group_cache structure. Both of those structures contain a reference to 
> fs info and can be used instead of an additional parameter. This is needed 
> since I will be pulling some of the freespace tree code into btrfs-progs in 
> implementing check/rebuild functionality for the freespace tree. So better have
> this sooner rather than later. 
> 
> This series should bring no functional changes but just in case it passed the 
> btrfs' selftests as well as a full xfstest run. 
> 
> Nikolay Borisov (17):
>   btrfs: Make btrfs_init_dummy_trans initialize trans' fs_info field
>   btrfs: Remove fs_info argument from add_block_group_free_space
>   btrfs: Remove fs_info argument from __add_block_group_free_space
>   btrfs: Remove fs_info argument from __add_to_free_space_tree
>   btrfs: Remove fs_info parameter from add_new_free_space_info
>   btrfs: Remove fs_info argument from add_new_free_space
>   btrfs: Remove fs_info parameter from remove_block_group_free_space
>   btrfs: Remove fs_info argument from convert_free_space_to_bitmaps
>   btrfs: Remove fs_info parameter from convert_free_space_to_extents
>   btrfs: Remove fs_info argument from update_free_space_extent_count
>   btrfs: Remove fs_info argument from modify_free_space_bitmap
>   btrfs: Remove fs_info argument from add_free_space_extent
>   btrfs: Remove fs_info argument from remove_free_space_extent
>   btrfs: Remove fs_info argument from __remove_from_free_space_tree
>   btrfs: Remove fs_info argument from remove_from_free_space_tree
>   btrfs: Remove fs_info argument from add_to_free_space_tree
>   btrfs: Remove fs_info argument from populate_free_space_tree

All
Reviewed-by: David Sterba <dsterba@suse.com>

and added to misc-next, thanks.
