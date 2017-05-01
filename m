Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.123.212]:58380 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952214AbdEAKWD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 May 2017 06:22:03 -0400
Date: Mon, 1 May 2017 13:21:38 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 1/7] btrfs: Introduce a function to check if all
 chunks a OK for degraded rw mount
Message-ID: <20170501132138.0bd3e33a@job>
In-Reply-To: <4b9409a0-290a-02d4-4288-2b66c1ed0cd6@cn.fujitsu.com>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
        <20170309013442.19957-2-quwenruo@cn.fujitsu.com>
        <f01fd9f3-85fe-c390-5358-be8c5d67ebc6@oracle.com>
        <4b9409a0-290a-02d4-4288-2b66c1ed0cd6@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
> >> +{
> >> +    struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
> >> +    struct extent_map *em;
> >> +    u64 next_start = 0;
> >> +    bool ret = true;
> >> +
> >> +    read_lock(&map_tree->map_tree.lock);
> >> +    em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)-1);
> >> +    read_unlock(&map_tree->map_tree.lock);
> >> +    /* No chunk at all? Return false anyway */
> >> +    if (!em) {
> >> +        ret = false;
> >> +        goto out;
> >> +    }
> >> +    while (em) {
> >> +        struct map_lookup *map;
> >> +        int missing = 0;
> >> +        int max_tolerated;
> >> +        int i;
> >> +
> >> +        map = (struct map_lookup *) em->bdev;  
> >
> >
> >    any idea why not   map = em->map_lookup;  here?  
> 
> 
> My fault, will update the patch.
> 
> Thanks,
> Qu

Sorry to bother, but looks like this patchset suddenly got forgotten.
It still applies to 4.11 but I'm afraid it won't after 4.12 merge
window. Any update on it?
