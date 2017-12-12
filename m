Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49529 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752303AbdLLSar (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 13:30:47 -0500
Date: Tue, 12 Dec 2017 19:28:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com, clm@fb.com
Subject: Re: [PATCH] btrfs: Fix out of bounds access in btrfs_search_slot
Message-ID: <20171212182845.GP3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1513070089-19002-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513070089-19002-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 12, 2017 at 11:14:49AM +0200, Nikolay Borisov wrote:
> When modifying a tree where the root is at BTRFS_MAX_LEVEL - 1 then
> the level variable is going to be 7 (this is the max height of the
> tree). On the other hand btrfs_cow_block is always called with
> "level + 1" as an index into the nodes and slots arrays. This leads to
> an out of bounds access. Admittdely this will be benign since an OOB
> access of the nodes array will likely read the 0th element from the
> slots array, which in this case is going to be 0 (since we start CoW at
> the top of the tree). The OOB access into the slots array in turn will
> read the 0th and 1st values of the locks array, which would both be 0
> at the time. However, this benign behavior relies on the fact that the 
> path being passed hasn't been initialised, if it has already been used to 
> query a btree then it could potentially have populated the nodes/slots arrays.
> 
> Fix it by explicitly checking if we are at level 7 (the maximum allowed
> index in nodes/slots arrays) and explicitly call the CoW routine with
> NULL for parent's node/slot.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Fixes-coverity-id: 711515

Reviewed-by: David Sterba <dsterba@suse.com>
