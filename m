Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35960 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDDDDc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Apr 2014 23:03:32 -0400
Date: Fri, 4 Apr 2014 11:03:16 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix reversed warning condition in
 btrfs_delayed_inode_reserve_metadata
Message-ID: <20140404030315.GA24064@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1396458780-10923-1-git-send-email-dsterba@suse.cz>
 <20140403053421.GB11484@localhost.localdomain>
 <20140403161840.GL29256@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140403161840.GL29256@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 03, 2014 at 06:18:40PM +0200, David Sterba wrote:
> On Thu, Apr 03, 2014 at 01:34:23PM +0800, Liu Bo wrote:
> > On Wed, Apr 02, 2014 at 07:13:00PM +0200, David Sterba wrote:
> > > Commit fae7f21cece9a4c181 ("btrfs: Use WARN_ON()'s return value in place of
> > > WARN_ON(1)") cleaned up WARN_ON usage and in one place reversed the condition
> > > that led to loads of warnings that were not supposed to occur.
> > > 
> > > WARN_ON will trigger because it sees 'ret' though in the previous code
> > > did not reach the WARN_ON below. The correct pattern is
> > > 
> > > -       if (condition)
> > > +       if (WARN_ON(condition))
> > > 
> > > CC: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
> > > CC: <stable@vger.kernel.org> # 3.13
> > > Reported-by: Liu Bo <bo.li.liu@oracle.com>
> > > Signed-off-by: David Sterba <dsterba@suse.cz>
> > > ---
> > >  fs/btrfs/delayed-inode.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > > index 451b00c86f6c..098af20abd88 100644
> > > --- a/fs/btrfs/delayed-inode.c
> > > +++ b/fs/btrfs/delayed-inode.c
> > > @@ -649,7 +649,7 @@ static int btrfs_delayed_inode_reserve_metadata(
> > >  			goto out;
> > >  
> > >  		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
> > > -		if (!WARN_ON(ret))
> > > +		if (WARN_ON(!ret))
> > >  			goto out;
> > 
> > Oh sorry, I'd have to get my Reviewed-by back and give a NACK instead.
> > 
> > With this patch, (ret = 0) triggers the WARNING, which is not right.
> 
> Thanks for catching this, you're right, my patch was wrong. I must say
> the patch (fae7f21ce) made the code harder to read at some places, I
> don't see much help in removing plain WARN_ON(1) at this cost.

I agree, I prefer the original code which is easier to understand,

if (!ret)
	goto out;
WARN_ON(1);

> 
> Back to the warning flood you observed, the comment under the warning
> says:
> 
> 655                 /*
> 656                  * Ok this is a problem, let's just steal from the global rsv
> 657                  * since this really shouldn't happen that often.
> 658                  */
> 659                 ret = btrfs_block_rsv_migrate(&root->fs_info->global_block_rsv,
> 660                                               dst_rsv, num_bytes);
> 
> so the question is why it does happen so often.
> 
> A WARN_ON_ONCE hides the severity of the problem, so I'd rather suggest
> to put it under enospc_debug option so we can debug it and it does not
> bother users. As this is closer to the way you were going to fix that,
> I'm not sending a patch, take this as a review comment.

The comment was based on some assumptions which could be wrong according to
my observation.

-liubo
