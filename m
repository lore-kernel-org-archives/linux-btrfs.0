Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20450 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdAYPGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 10:06:31 -0500
Date: Wed, 25 Jan 2017 07:06:18 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, cmason@fb.com, Josef Bacik <jbacik@fb.com>,
        dsterba@suse.com
Subject: Re: [PATCH] Btrfs: fix wrong argument for btrfs_lookup_ordered_range
Message-ID: <20170125150618.GA25499@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1485302331-20167-1-git-send-email-bo.li.liu@oracle.com>
 <10463170.nZChnp8t2y@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <10463170.nZChnp8t2y@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 01:49:09PM +0530, Chandan Rajendra wrote:
> On Tuesday, January 24, 2017 03:58:51 PM Liu Bo wrote:
> > Commit "d0b7da88 Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units"
> > did this, but btrfs_lookup_ordered_range expects a 'length' rather than a
> > 'page_end'.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > Is this a candidate for stable?
> > 
> >  fs/btrfs/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 4e02426..366cf0b 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -9023,7 +9023,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	 * we can't set the delalloc bits if there are pending ordered
> >  	 * extents.  Drop our locks and wait for them to finish
> >  	 */
> > -	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
> > +	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
> >  	if (ordered) {
> >  		unlock_extent_cached(io_tree, page_start, page_end,
> >  				     &cached_state, GFP_NOFS);
> > 
> 
> Thanks for fixing this,
> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> As for the question about whether this commit should be merged into the stable
> trees ... I am not sure about that since I don't notice any sort of filesystem
> corruption that can be caused by the current code i.e. With the existing code,
> apart from any ordered extents that map the page in question, we are most
> likely to be *unnecessarily* starting i/o on ordered extents that don't map
> the file offset range covered by the page. Chris, Josef or David, Please let
> us know your thoughts on this.

It could be a performance regression which causes fault writes have
unnecessary waits instead of a real corruption.

Thanks,

-liubo
