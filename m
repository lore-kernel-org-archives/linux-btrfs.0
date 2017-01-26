Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52787 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbdAZRnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:43:47 -0500
Date: Thu, 26 Jan 2017 18:28:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        cmason@fb.com, Josef Bacik <jbacik@fb.com>, dsterba@suse.com
Subject: Re: [PATCH] Btrfs: fix wrong argument for btrfs_lookup_ordered_range
Message-ID: <20170126172807.GH11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485302331-20167-1-git-send-email-bo.li.liu@oracle.com>
 <10463170.nZChnp8t2y@localhost.localdomain>
 <20170125150618.GA25499@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170125150618.GA25499@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 07:06:18AM -0800, Liu Bo wrote:
> On Wed, Jan 25, 2017 at 01:49:09PM +0530, Chandan Rajendra wrote:
> > On Tuesday, January 24, 2017 03:58:51 PM Liu Bo wrote:
> > > Commit "d0b7da88 Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units"
> > > did this, but btrfs_lookup_ordered_range expects a 'length' rather than a
> > > 'page_end'.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > > Is this a candidate for stable?
> > > 
> > >  fs/btrfs/inode.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > index 4e02426..366cf0b 100644
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > @@ -9023,7 +9023,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > >  	 * we can't set the delalloc bits if there are pending ordered
> > >  	 * extents.  Drop our locks and wait for them to finish
> > >  	 */
> > > -	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
> > > +	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
> > >  	if (ordered) {
> > >  		unlock_extent_cached(io_tree, page_start, page_end,
> > >  				     &cached_state, GFP_NOFS);
> > > 
> > 
> > Thanks for fixing this,
> > Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > 
> > As for the question about whether this commit should be merged into the stable
> > trees ... I am not sure about that since I don't notice any sort of filesystem
> > corruption that can be caused by the current code i.e. With the existing code,
> > apart from any ordered extents that map the page in question, we are most
> > likely to be *unnecessarily* starting i/o on ordered extents that don't map
> > the file offset range covered by the page. Chris, Josef or David, Please let
> > us know your thoughts on this.
> 
> It could be a performance regression which causes fault writes have
> unnecessary waits instead of a real corruption.

Does not seem to be urgent for stable, but I'll consider it next time
doing a stable round updates.
