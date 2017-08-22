Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55057 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932350AbdHVK65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 06:58:57 -0400
Subject: Re: [PATCH 0/3] Introduce comprehensive sanity check framework and
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2d3b55a3-8308-fd63-1d97-f94f19a85235@suse.com>
Date: Tue, 22 Aug 2017 13:58:55 +0300
MIME-Version: 1.0
In-Reply-To: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.08.2017 10:37, Qu Wenruo wrote:
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
>    Only EXTENT_DATA checker is implemented yet.
>    As each checker should go through review and tests, or it can easily
>    make a valid btrfs failed to be mounted.
>    So only one checker is implemented as an example.
> 
>    Existing checker like INODE_REF checker can be moved to this
>    framework easily, and we can centralize all existing checkers, make
>    the rest of codes more clean.
> 
> Performance wise, it's just iterating a leaf.
> And it will only get triggered when read out a leaf, cached leaf will
> not go through such checker.
> So it won't be a performance breaker.
> 
> I tested with the patchset applied on v4.13-rc6 with fstests, no
> regression is detected.
> 
> Qu Wenruo (3):
>   btrfs: Refactor check_leaf function for later expansion.
>   btrfs: Check if item pointer overlap with item itself
>   btrfs: Add sanity check for EXTENT_DATA when reading out leaf

I have one minor comment on 3/3 which I've sent separately but otherwise
this series looks good and I like the direction it's steering future
code into.

For the whole series:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
>  fs/btrfs/disk-io.c              | 137 ++++++++++++++++++++++++++++++++++------
>  include/uapi/linux/btrfs_tree.h |   1 +
>  2 files changed, 119 insertions(+), 19 deletions(-)
> 
