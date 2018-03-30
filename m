Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752384AbeC3XqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 19:46:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7D17EAE8D
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 23:46:17 +0000 (UTC)
Date: Sat, 31 Mar 2018 01:43:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2.1 2/2] btrfs: Validate child tree block's level and
 first key
Message-ID: <20180330234348.GY30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180329010811.13687-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180329010811.13687-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 09:08:11AM +0800, Qu Wenruo wrote:
> We have several reports about node pointer points to incorrect child
> tree blocks, which could have even wrong owner and level but still with
> valid generation and checksum.
> 
> Although btrfs check could handle it and print error message like:
> leaf parent key incorrect 60670574592
> 
> Kernel doesn't have enough check on this type of corruption correctly.
> At least add such check to read_tree_block() and btrfs_read_buffer(),
> where we need two new parameters @level and @first_key to verify the
> child tree block.
> 
> The new @level check is mandatory and all call sites are already
> modified to extract expected level from its call chain.
> 
> While @first_key is optional, the following call sites are skipping such
> check:
> 1) Root node/leaf
>    As ROOT_ITEM doesn't contain the first key, skip @first_key check.
> 2) Direct backref
>    Only parent bytenr and level is known and we need to resolve the key
>    all by ourselves, skip @first_key check.
> 
> Another note of this verification is, it needs extra info from nodeptr
> or ROOT_ITEM, so it can't fit into current tree-checker framework, which
> is limited to node/leaf boundary.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Make @level check mandatory, suggesed by Jeff and Nikolay.
>   Change parameter order as @level is now mandatory, put it in front of
>   @first_key.
>   Change verify_parent_level() to verify_key_level() to avoid confusion
>   on the @level parameter.
>   Add btrfs_error() output for CONFIG_BTRFS_DEBUG to help debugging.
> v2.1
>   Rebased to misc-next branch, to use parent_level, it needs to revert
>   Nikolay's patch "btrfs: Remove unused parent_level var from btrfs_realloc_node",
>   sorry Nikolay.

Ah ok, I've reverted the patch, thanks.
