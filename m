Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726902AbeINUns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 16:43:48 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4220EAF65
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 15:28:46 +0000 (UTC)
Date: Fri, 14 Sep 2018 17:28:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] Add delayed-refs support to btrfs-progs
Message-ID: <20180914152845.GN5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 16, 2018 at 04:10:27PM +0300, Nikolay Borisov wrote:
> Hello, 
> 
> Here is the second version of the delayed refs for progs support. The first 
> version can be found here [1]. I've taken into account all the feedback from 
> Misono and have verified the code is working and rebased it atop btrfs-progs
> 4.17.1.
> 
> Changes since v1: 
>  * Removed num_entries variable from delayed ref root
>  
>  * Added a patch to refactor btrfs_write_dirty_block_groups and subsequently 
>  changed when this function is called to fix an issue reported by Misono. I
>  verified that 'make test-fsck TEST_ENABLE_OVERRIDE=true TEST_ARGS_CHECK=--mode=lowmem'
>  produces no errors
> 
>  * Added 2 patches which remove the newly added adapter functions at the 
>  beggining of the series, following the wiring up of the delayed refs 
>  infrastructured. The first one (dealing with __free_extent2) is trivial, while
>  the second one (for alloc_reserved_tree_block2) is a bit more involved, since
>  I've opted to merge the two functions. 
> 
>  * Rebased atop latest btrfs-progs release - 4.17.1
> 
>  * Dropped patches which have been merged in the mean time
> 
> 
> [1] https://www.spinics.net/lists/linux-btrfs/msg79173.html
> 
> Nikolay Borisov (8):
>   btrfs-progs: Add __free_extent2 function
>   btrfs-progs: Add alloc_reserved_tree_block2 function
>   btrfs-progs: Add delayed refs infrastructure
>   btrfs-progs: Make btrfs_write_dirty_block_groups take only trans
>     argument
>   btrfs-progs: Wire up delayed refs
>   btrfs-progs: Remove old delayed refs infrastructure
>   btrfs-progs: Remove __free_extent2
>   btrfs-progs: Merge alloc_reserved_tree_block(2|)

For the record, the v2 patchset has been merged to devel.
