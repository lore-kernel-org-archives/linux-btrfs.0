Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:44570 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbeBWAuq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 19:50:46 -0500
Subject: Re: [RFC] btrfs: Speedup btrfs_read_block_groups()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
References: <20180222045215.16426-1-wqu@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <e250b087-f640-3246-a3b5-c9ac74eeeb58@applied-asynchrony.com>
Date: Fri, 23 Feb 2018 01:50:32 +0100
MIME-Version: 1.0
In-Reply-To: <20180222045215.16426-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/22/18 05:52, Qu Wenruo wrote:
> btrfs_read_block_groups() is used to build up the block group cache for
> all block groups, so it will iterate all block group items in extent
> tree.
> 
> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
> thousands times, which is the most time consuming part of mounting
> btrfs.
> 
> So this patch will try to speed it up by:
> 
> 1) Avoid unnecessary readahead
>    We were using READA_FORWARD to search for block group item.
>    However block group items are in fact scattered across quite a lot of
>    leaves. Doing readahead will just waste our IO (especially important
>    for HDD).
> 
>    In real world case, for a filesystem with 3T used space, it would
>    have about 50K extent tree leaves, but only have 3K block group
>    items. Meaning we need to iterate 16 leaves to meet one block group
>    on average.
> 
>    So readahead won't help but waste slow HDD seeks.
> 
> 2) Use chunk mapping to locate block group items
>    Since one block group item always has one corresponding chunk item,
>    we could use chunk mapping to get the block group item size.
> 
>    With block group item size, we can do a pinpoint tree search, instead
>    of searching with some uncertain value and do forward search.
> 
>    In some case, like next BLOCK_GROUP_ITEM is in the next leaf of
>    current path, we could save such unnecessary tree block read.
> 
> Cc: Ellis H. Wilson III <ellisw@panasas.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Decided to give this a try & got interesting results!

The scene of the crime:
