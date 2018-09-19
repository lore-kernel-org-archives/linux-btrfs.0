Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49972 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730892AbeISQnm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 12:43:42 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB2D6AD47
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 11:06:16 +0000 (UTC)
Subject: Re: [PATCH RFC] btrfs: delayed-inode: Use spinlock to protect
 btrfs_inode::delayed_node
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180919065958.21153-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ff4cb36b-a063-3947-8d59-37b6c71205ab@suse.com>
Date: Wed, 19 Sep 2018 14:06:15 +0300
MIME-Version: 1.0
In-Reply-To: <20180919065958.21153-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.09.2018 09:59, Qu Wenruo wrote:
> In the following case, we could trigger a use-after-free bug:
> 
>          CPU0                    |               CPU1
> -------------------------------------------------------------------------
> btrfs_remove_delayed_node        | btrfs_get_delayed_node
> |- delayed_node =                | |- node = btrfs_inode->delayed_node;
> |    btrfs_inode->delayed_node   | |
> |- btrfs_release_delaedy_node()  | |
>    |- ref_count_dev_and_test()   | |
>    |- kmem_cache_free()          | |
>       Now delayed node is freed  | |
>                                  | |- refcount_inc(&node->refs)
> 


btrfs_remove_delayed_node is called from evict_inode which is called
once the inode has been freed and there are no more referencs to this
inode (inode->i_count is 0). Also before calling
btrfs_remove_delayed_node we have flushed all the pages and ordered
extents. So the crucial bit of information missing is what is the
higher-level operation that requests the delayed node for a freed inode ?
