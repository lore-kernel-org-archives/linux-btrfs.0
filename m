Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40859 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751456AbdIGTkt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 15:40:49 -0400
Date: Thu, 7 Sep 2017 21:39:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
        nefelim4ag@gmail.com
Subject: Re: [PATCH 00/10] Unused parameter cleanup
Message-ID: <20170907193920.GL31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 12:43:40PM +0300, Nikolay Borisov wrote:
> Here is a series that I've been sitting on for a while. It removes unused 
> parameter in various functions, no functional changes. Patch 09/10 reworks
> some error handling to eliminate an if branch in __btrfs_alloc_chunk, but it's
> still a minor refactoring. 
> 
> Nikolay Borisov (10):
>   btrfs: Remove chunk_objectid parameter of btrfs_alloc_dev_extent
>   btrfs: remove superfluous chunk_tree argument from
>     btrfs_alloc_dev_extent
>   btrfs: Remove unused variable
>   btrfs: Remove unused parameters from various functions
>   btrfs: Remove unused arguments from btrfs_changed_cb_t
>   btrfs: Remove unused parameter from check_direct_IO
>   btrfs: Remove unused parameter from extent_clear_unlock_delalloc
>   btrfs: remove unused parameter in cow_file_range
>   btrfs: Rework error handling of add_extent_mapping in
>     __btrfs_alloc_chunk
>   btrfs: Remove redundant argument of __link_block_group

Some of the patches have been applied earlier and are now in the frozen
branch for the pull request so I did not update them with the reviewed
tags.

The remaining patches are now in the 4.15 devel queue, with the reviewed
tags that have been sent.
