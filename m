Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935239AbeCSSLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 14:11:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92256AEF2
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 18:11:23 +0000 (UTC)
Date: Mon, 19 Mar 2018 19:08:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
Message-ID: <20180319180859.GJ6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180316183627.15476-1-jeffm@suse.com>
 <20180316201206.GG16736@twin.jikos.cz>
 <8950172e-98bc-8136-0ce3-aba1c5105c77@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8950172e-98bc-8136-0ce3-aba1c5105c77@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2018 at 01:52:05PM -0400, Jeff Mahoney wrote:
> On 3/16/18 4:12 PM, David Sterba wrote:
> > On Fri, Mar 16, 2018 at 02:36:27PM -0400, jeffm@suse.com wrote:
> >> From: Jeff Mahoney <jeffm@suse.com>
> >>
> >> While running btrfs/011, I hit the following lockdep splat.
> >>
> >> This is the important bit:
> >>    pcpu_alloc+0x1ac/0x5e0
> >>    __percpu_counter_init+0x4e/0xb0
> >>    btrfs_init_fs_root+0x99/0x1c0 [btrfs]
> >>    btrfs_get_fs_root.part.54+0x5b/0x150 [btrfs]
> >>    resolve_indirect_refs+0x130/0x830 [btrfs]
> >>    find_parent_nodes+0x69e/0xff0 [btrfs]
> >>    btrfs_find_all_roots_safe+0xa0/0x110 [btrfs]
> >>    btrfs_find_all_roots+0x50/0x70 [btrfs]
> >>    btrfs_qgroup_prepare_account_extents+0x53/0x90 [btrfs]
> >>    btrfs_commit_transaction+0x3ce/0x9b0 [btrfs]
> >>
> >> The percpu_counter_init call in btrfs_alloc_subvolume_writers
> >> uses GFP_KERNEL, which we can't do during transaction commit.
> >>
> >> This switches it to GFP_NOFS.
> > 
> >> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> >> ---
> >>  fs/btrfs/disk-io.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index 21f34ad0d411..eb6bb3169a9e 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -1108,7 +1108,7 @@ static struct btrfs_subvolume_writers *btrfs_alloc_subvolume_writers(void)
> >>  	if (!writers)
> >>  		return ERR_PTR(-ENOMEM);
> >>  
> >> -	ret = percpu_counter_init(&writers->counter, 0, GFP_KERNEL);
> >> +	ret = percpu_counter_init(&writers->counter, 0, GFP_NOFS);
> > 
> > A line above the diff context is another allocation that does GFP_NOFS,
> > so one of the gfp flags were wrong.
> > 
> > Looks like there's another instance where percpu allocates with
> > GFP_KERNEL: create_space_info that can be called from the path that
> > allocates chunks, so this also looks like a NOFS candidate.
> 
> We can get rid of this case entirely.  Those call sites should be
> removed since the space_infos are all allocated at mount time.

That would be great and make a few things simpler. So this means that
__find_space_info never fails once the space infos are properly
initialized, right? That was my concern in do_chunk_alloc and
btrfs_make_block_group (that's called from __btrfs_alloc_chunk).

