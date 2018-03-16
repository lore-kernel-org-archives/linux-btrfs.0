Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34505 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751445AbeCPSsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 14:48:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB8BAAF5C
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 18:48:02 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180316183627.15476-1-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9739e840-57e5-585f-8248-5d07b93b91ed@suse.com>
Date: Fri, 16 Mar 2018 20:48:01 +0200
MIME-Version: 1.0
In-Reply-To: <20180316183627.15476-1-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.03.2018 20:36, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> While running btrfs/011, I hit the following lockdep splat.
> 
> This is the important bit:
>    pcpu_alloc+0x1ac/0x5e0
>    __percpu_counter_init+0x4e/0xb0
>    btrfs_init_fs_root+0x99/0x1c0 [btrfs]
>    btrfs_get_fs_root.part.54+0x5b/0x150 [btrfs]
>    resolve_indirect_refs+0x130/0x830 [btrfs]
>    find_parent_nodes+0x69e/0xff0 [btrfs]
>    btrfs_find_all_roots_safe+0xa0/0x110 [btrfs]
>    btrfs_find_all_roots+0x50/0x70 [btrfs]
>    btrfs_qgroup_prepare_account_extents+0x53/0x90 [btrfs]
>    btrfs_commit_transaction+0x3ce/0x9b0 [btrfs]
> 
> The percpu_counter_init call in btrfs_alloc_subvolume_writers
> uses GFP_KERNEL, which we can't do during transaction commit.
> 
> This switches it to GFP_NOFS.

Given there is effort underway to actually kill GFP_NOFS and replace it
with the context annotation routines, shouldn't instead use those
routines directly ?

<snip>
