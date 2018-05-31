Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754522AbeEaLhM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 07:37:12 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12DCFAE92
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 11:37:11 +0000 (UTC)
Date: Thu, 31 May 2018 13:34:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11] Summer argument cleanup
Message-ID: <20180531113425.GO3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 09:36:39AM +0300, Nikolay Borisov wrote:
> Hello, 
> 
> Here is yet another series removing a bunch of extraneous argument. The series 
> constitutes no functional changes. Some of the function actually have a kernel 
> counterpart (btrfs_lookup_extent_info/clean_tree_block). However the former's 
> userspace signature differs and the patch in this series makes it identical to 
> the kernel one. 
> 
> Nikolay Borisov (11):
>   btrfs-progs: check: Remove root argument from delete_extent_records
>   btrfs-progs: check: Remove root parameter from
>     btrfs_fix_block_accounting
>   btrfs-progs: check: Remove root parameter from del_pending_extents
>   btrfs-progs: check: Remove root argument from finish_current_insert
>   btrfs-progs: check: Make update_pinned_extents take btrfs_fs_info
>   btrfs-progs: Remove unused argument from clean_tree_block
>   btrfs-progs: check: Remove unused root argument from
>     btrfs_extent_post_op
>   btrfs-progs: Change btrfs_root to btrfs_fs_info argument in
>     btrfs_lookup_extent_info
>   btrfs-progs: Remove root argument from btrfs_set_block_flags
>   btrfs-progs: Remove root argument from write_one_cache_group
>   btrfs-progs: Remove fs_info argument from write_ctree_super

Applied, thanks.
