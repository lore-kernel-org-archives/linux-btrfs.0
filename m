Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39106 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdBOUkY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 15:40:24 -0500
Date: Wed, 15 Feb 2017 12:38:27 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 17/29] btrfs: remove unused parameter from
 extent_write_cache_pages
Message-ID: <20170215203827.GB11220@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <43296f2bae8942890fda6c428617fb474c812696.1486977712.git.dsterba@suse.com>
 <20170214193511.GD31091@localhost.localdomain>
 <20170215153046.GR16928@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170215153046.GR16928@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2017 at 04:30:46PM +0100, David Sterba wrote:
> On Tue, Feb 14, 2017 at 11:35:11AM -0800, Liu Bo wrote:
> > On Mon, Feb 13, 2017 at 10:34:13AM +0100, David Sterba wrote:
> > > The 'tree' was used to call locking hook that does not exist anymore.
> > > 
> > > Signed-off-by: David Sterba <dsterba@suse.com>
> > > ---
> > >  fs/btrfs/extent_io.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > index f683fa5a4b91..22a2f2fa62c7 100644
> > > --- a/fs/btrfs/extent_io.c
> > > +++ b/fs/btrfs/extent_io.c
> > > @@ -3916,8 +3916,7 @@ int btree_write_cache_pages(struct address_space *mapping,
> > >   * WB_SYNC_ALL then we were called for data integrity and we must wait for
> > >   * existing IO to complete.
> > >   */
> > > -static int extent_write_cache_pages(struct extent_io_tree *tree,
> > > -			     struct address_space *mapping,
> > > +static int extent_write_cache_pages(struct address_space *mapping,
> > >  			     struct writeback_control *wbc,
> > >  			     writepage_t writepage, void *data,
> > >  			     void (*flush_fn)(void *))
> > > @@ -4158,8 +4157,7 @@ int extent_writepages(struct extent_io_tree *tree,
> > >  		.bio_flags = 0,
> > >  	};
> > >  
> > > -	ret = extent_write_cache_pages(tree, mapping, wbc,
> > > -				       __extent_writepage, &epd,
> > > +	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd,
> > >  				       flush_write_bio);
> > 
> > Are we going to leave {btrfs,extent}_{read,write}pages untouched?
> 
> Yes, because extent_writepages uses 'tree', it's stored in the
> extent_page_data, and some if not all callbacks do utilize it.
> 
> 4140 int extent_writepages(struct extent_io_tree *tree,
> 4141                       struct address_space *mapping,
> 4142                       get_extent_t *get_extent,
> 4143                       struct writeback_control *wbc)
> 4144 {
> 4145         int ret = 0;
> 4146         struct extent_page_data epd = {
> 4147                 .bio = NULL,
> 4148                 .tree = tree,
> ^^^^
> 4149                 .get_extent = get_extent,
> 4150                 .extent_locked = 0,
> 4151                 .sync_io = wbc->sync_mode == WB_SYNC_ALL,
> 4152                 .bio_flags = 0,
> 4153         };
> 
> btrfs_readpages
>   extent_readpages
>     __extent_readpages
>       __do_contiguous_readpages
> 	lock_extent
> 
> and btrfs_writepages calls extent_writepages.

OK, I see.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
