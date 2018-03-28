Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753816AbeC1PwR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 11:52:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 41BB3AB39
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Mar 2018 15:52:16 +0000 (UTC)
Date: Wed, 28 Mar 2018 17:49:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: Validate child tree block's level and
 first key
Message-ID: <20180328154949.GO30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180327124419.28398-1-wqu@suse.com>
 <20180327124419.28398-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180327124419.28398-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2018 at 08:44:19PM +0800, Qu Wenruo wrote:
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

That's much better overall, thanks. Adding it to next.
