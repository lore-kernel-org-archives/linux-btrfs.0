Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37729 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754090AbdHWPTT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:19:19 -0400
Subject: Re: [PATCH v2 0/3] Introduce comprehensive sanity check framework and
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aea1a159-2729-e386-79ac-135e3c51c178@suse.com>
Date: Wed, 23 Aug 2017 18:19:16 +0300
MIME-Version: 1.0
In-Reply-To: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.08.2017 10:57, Qu Wenruo wrote:
> The patchset introduce a new framework to do more comprehensive (if not
> the most) sanity check when reading out a leaf.
> 
> The new sanity checker will include:
> 
> 1) Key order
>    Existing code
> 
> 2) Item boundary
>    Existing code with enhanced checker to ensure item pointer doesn't
>    overlap with item itself.
> 
> 3) Key type based sanity checker
>    Only EXTENT_DATA and EXTENT_CSUM checker is implemented yet.
>    As each checker should go through review and tests, or it can easily
>    make a valid btrfs failed to be mounted.
>    So only two checkers are implemented as an example.
> 
>    Existing checker like INODE_REF checker can be moved to this
>    framework easily, and we can centralize all existing checkers, make
>    the rest of codes more clean.
> 
> Performance wise, it's just iterating a leaf.
> And it will only get triggered when reading a leaf, cached leaf will
> not go through such checker.
> So it won't be a performance breaker.
> 
> I tested with the patchset applied on v4.13-rc6 with fstests, no
> regression is detected.
> 
> Changelog:
> v2:
>   Use EUCLEAN to replace EIO as error code. (Suggested by Nikolay Borisov)
>   Pass the whole key from check_leaf() to reduce btrfs_item_key_to_cpu()
>   call. (Suggested by Nikolay Borisov)
>   Add EXTENT_CSUM checker
> 
> Qu Wenruo (4):
>   btrfs: Refactor check_leaf function for later expansion.
>   btrfs: Check if item pointer overlap with item itself
>   btrfs: Add sanity check for EXTENT_DATA when reading out leaf
>   btrfs: Add checker for EXTENT_CSUM
> 
>  fs/btrfs/disk-io.c              | 189 +++++++++++++++++++++++++++++++++++-----
>  include/uapi/linux/btrfs_tree.h |   1 +
>  2 files changed, 167 insertions(+), 23 deletions(-)
> 

For the whole series:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
