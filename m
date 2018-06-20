Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750852AbeFTNAU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 09:00:20 -0400
Date: Wed, 20 Jun 2018 14:57:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix invalid-free in btrfs_extent_same
Message-ID: <20180620125728.GW24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180619065438.20293-1-lufq.fnst@cn.fujitsu.com>
 <20180619132753.GN24375@twin.jikos.cz>
 <20180620071146.GA31702@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620071146.GA31702@fnst.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 03:11:46PM +0800, Lu Fengqi wrote:
> On Tue, Jun 19, 2018 at 03:27:54PM +0200, David Sterba wrote:
> >On Tue, Jun 19, 2018 at 02:54:38PM +0800, Lu Fengqi wrote:
> >> If this condition ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> >> 		   (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM))
> >> is hit, we will go to free the uninitialized cmp.src_pages and
> >> cmp.dst_pages.
> >> 
> >> Fixes: 67b07bd4bec5 ("Btrfs: reuse cmp workspace in EXTENT_SAME ioctl")
> >> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> >> ---
> >>  fs/btrfs/ioctl.c | 10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >> 
> >> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> >> index c2837a32d689..43ecbe620dea 100644
> >> --- a/fs/btrfs/ioctl.c
> >> +++ b/fs/btrfs/ioctl.c
> >> @@ -3577,7 +3577,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> >>  		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
> >>  					      dst, dst_loff, &cmp);
> >>  		if (ret)
> >> -			goto out_unlock;
> >> +			goto out_free;
> >>  
> >>  		loff += BTRFS_MAX_DEDUPE_LEN;
> >>  		dst_loff += BTRFS_MAX_DEDUPE_LEN;
> >> @@ -3587,16 +3587,16 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> >>  		ret = btrfs_extent_same_range(src, loff, tail_len, dst,
> >>  					      dst_loff, &cmp);
> >
> >The labels now switch order and there's one more 'goto out_free' that
> >actually also wants to unlock the pages, after error of
> >btrfs_extent_same_range in the for loop. So this needs to be update too.
> 
> Sorry, I'm not quite sure what needs to be updated. I will appreciate if
> you are willing to take time to make it clear. There are three goto
> statements here. The first one that between lock and malloc, jumps directly
> to the unlock label. The rest goto statements (including this goto
> statement after btrfs_extent_same_range in the for loop) that after malloc,
> jump to the following free label. No matter jump to which label, the pages
> will be freed and the inodes will be unlocked.

Sorry, I must have looked at the unpatched sources, the patch is fine as
sent and I'll add it to 4.18 queue.
