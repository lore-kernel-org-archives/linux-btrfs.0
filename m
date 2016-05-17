Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbcEQJkU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:40:20 -0400
Date: Tue, 17 May 2016 11:39:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] Btrfs: check if extent buffer is aligned to
 sectorsize
Message-ID: <20160517093952.GH511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-3-git-send-email-bo.li.liu@oracle.com>
 <02aae5ea-bd0e-689d-85d2-327d7b177aad@gmx.com>
 <20160516180141.GB11100@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160516180141.GB11100@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 16, 2016 at 11:01:41AM -0700, Liu Bo wrote:
> On Sat, May 14, 2016 at 06:30:52PM +0800, Qu Wenruo wrote:
> > Hi Liu,
> > 
> > Thanks for your patch first.
> > 
> > On 05/14/2016 08:06 AM, Liu Bo wrote:
> > > Thanks to fuzz testing, we can pass an invalid bytenr to extent buffer
> > > via alloc_extent_buffer().  An unaligned eb can have more pages than it
> > > should have, which ends up extent buffer's leak or some corrupted content
> > > in extent buffer.
> > > 
> > > This adds a warning to let us quickly know what was happening.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > >  fs/btrfs/extent_io.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > index d247fc0..e601e0f 100644
> > > --- a/fs/btrfs/extent_io.c
> > > +++ b/fs/btrfs/extent_io.c
> > > @@ -4868,6 +4868,10 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> > >  	int uptodate = 1;
> > >  	int ret;
> > > 
> > > +	WARN_ONCE(!IS_ALIGNED(start, fs_info->tree_root->sectorsize),
> > > +		  KERN_WARNING "eb->start(%llu) is not aligned to root->sectorsize(%u)\n",
> > > +		  start, fs_info->tree_root->sectorsize);
> > > +
> > 
> > IMHO this is a quite big problem. As almost all other things rely on the
> > assumption that extent buffer are at least sectorsize aligned.
> 
> It won't cause too much trouble as reading eb's page can prevent btrfs
> using this eb.
> 
> > What about warning and returning NULL? WARN_ONCE() only won't info user
> > quick enough.
> 
> I'm OK with warning, but I just realized that warning doesn't show which
> filesystem has problems, so btrfs_crit and -EINVAL is preferable.

NULL means it's allocation error, so please convert it to IS_ERR and
return more fine grained errors so we can distinguish the problems. An
unaligned 'start' almost always means a corruption or other problem in
the callers of alloc_extent_buffer().
