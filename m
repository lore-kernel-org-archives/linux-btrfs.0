From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH v8 7/8] btrfs: Replication-type information
Date: Tue, 28 Jun 2011 23:41:50 +0300
Message-ID: <20110628204150.GA27970@zambezi.lan>
References: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
 <1309120615-18104-8-git-send-email-hugo@carfax.org.uk>
 <20110628163243.GS12709@twin.jikos.cz>
 <20110628192643.GC24675@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110628192643.GC24675@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2011 at 08:26:43PM +0100, Hugo Mills wrote:
> On Tue, Jun 28, 2011 at 06:32:43PM +0200, David Sterba wrote:
> > On Sun, Jun 26, 2011 at 09:36:54PM +0100, Hugo Mills wrote:
> > > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > > index 828aa34..fb11550 100644
> > > --- a/fs/btrfs/volumes.c
> > > +++ b/fs/btrfs/volumes.c
> > > @@ -117,6 +117,52 @@ static void requeue_list(struct btrfs_pending_bios *pending_bios,
> > >  		pending_bios->tail = tail;
> > >  }
> > >  
> > > +void btrfs_get_replication_info(struct btrfs_replication_info *info,
> > > +								u64 type)
> > > +{
> > > +	info->sub_stripes = 1;
> > > +	info->dev_stripes = 1;
> > > +	info->devs_increment = 1;
> > > +	info->num_copies = 1;
> > > +	info->devs_max = 0;	/* 0 == as many as possible */
> > > +	info->devs_min = 1;
> > > +
> > > +	if (type & BTRFS_BLOCK_GROUP_DUP) {
> > > +		info->dev_stripes = 2;
> > > +		info->num_copies = 2;
> > > +		info->devs_max = 1;
> > > +	} else if (type & BTRFS_BLOCK_GROUP_RAID0) {
> > > +		info->devs_min = 2;
> > > +	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
> > > +		info->devs_increment = 2;
> > > +		info->num_copies = 2;
> > > +		info->devs_max = 2;
> > > +		info->devs_min = 2;
> > > +	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
> > > +		info->sub_stripes = 2;
> > > +		info->devs_increment = 2;
> > > +		info->num_copies = 2;
> > > +		info->devs_min = 4;
> > > +	}
> > > +
> > > +	if (type & BTRFS_BLOCK_GROUP_DATA) {
> > > +		info->max_stripe_size = 1024 * 1024 * 1024;
> > > +		info->min_stripe_size = 64 * 1024 * 1024;
> > > +		info->max_chunk_size = 10 * info->max_stripe_size;
> > > +	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
> > > +		info->max_stripe_size = 256 * 1024 * 1024;
> > > +		info->min_stripe_size = 32 * 1024 * 1024;
> > > +		info->max_chunk_size = info->max_stripe_size;
> > > +	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
> > > +		info->max_stripe_size = 8 * 1024 * 1024;
> > > +		info->min_stripe_size = 1 * 1024 * 1024;
> > > +		info->max_chunk_size = 2 * info->max_stripe_size;
> > > +	} else {
> > > +		printk(KERN_ERR "Block group is of an unknown usage type: not data, metadata or system.\n");
> > > +		BUG_ON(1);
> 
>    From inspection, this looks like it's a viable solution:
> 
> +               info->max_stripe_size = 0;
> +               info->min_stripe_size = -1ULL;
> +               info->max_chunk_size = 0;
> 
> We only run into problems if a user of this function passes a
> RAID-only block group type and then tries to use the size parameters
> from it. There's only three users of the function currently, and this
> case is the only one that doesn't pass a "real" block group type flag.
> 
>    I'll run a quick test of dev rm and see what happens...

[ I didn't apply or run this series, take this with a grain of salt ]

The problem seems to be that Hugo's function expects on-disk chunk type
as it's input.  However avail_{data,metadata,system}_alloc_bits (of
which all_avail is comprised) are in-memory fields, they don't have
BTRFS_BLOCK_GROUP_{DATA,METADATA_SYSTEM} set by design.  There are three
fields:

avail_data_alloc_bits
avail_metadata_alloc_bits
avail_system_alloc_bits

so we don't need BTRFS_BLOCK_GROUP_{DATA,METADATA_SYSTEM} set to
differentiate between data and metadata profiles.

I'd say that BUG_ON should be dropped and those three lines above added
or maybe a special switch for this particular case to leave info
partially un-initialized, since we only need devs_min in this case.

Thanks,

		Ilya

> > I'm hitting this BUG_ON with 'btrfs device delete', type = 24 which is
> > BTRFS_BLOCK_GROUP_RAID0 + BTRFS_BLOCK_GROUP_RAID1 .
> > 
> > in btrfs_rm_device:
> > 
> > 1277         all_avail = root->fs_info->avail_data_alloc_bits |
> > 1278                 root->fs_info->avail_system_alloc_bits |
> > 1279                 root->fs_info->avail_metadata_alloc_bits;
> > 
> > the values before the call are:
> > 
> > [  105.107074] D: all_avail 24
> > [  105.111844] D: root->fs_info->avail_data_alloc_bits 8
> > [  105.118858] D: root->fs_info->avail_system_alloc_bits 16
> > [  105.126110] D: root->fs_info->avail_metadata_alloc_bits 16
> > 
> > 
> > there are 5 devices, sdb5 - sdb9, i'm removing sdb9, after clean
> > mount.
> > 
> > 
> > david
> 
>    Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>                --- vi vi vi:  the Editor of the Beast. ---               


