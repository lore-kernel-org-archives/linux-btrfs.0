From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [PATCH v5 1/8] btrfs: Balance progress monitoring
Date: Tue, 12 Apr 2011 19:42:07 +0100
Message-ID: <20110412184207.GH5301@carfax.org.uk>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
 <1302469571-12605-2-git-send-email-hugo@carfax.org.uk>
 <20110412171232.GJ31675@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
To: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110412171232.GJ31675@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 12, 2011 at 07:12:32PM +0200, David Sterba wrote:
> Hi,
> 
> I've noticed that Arne's scrub patches add scrub variables directly
> into the fs_info structure, while you have a separate struct.

   Chris (I think -- might have been Josef) suggested the use of a
struct, back when I was first writing this code.

> I was wondering whether it would be better to put items of
> btrfs_balance_info to fs_info too, balance state is a global info.
> 
> Although fs_info is a huge structure now, 9402 bytes on 86_64, there is
> no space saving in this case.

   There will be savings in the future, however -- when I add Li's
suggestion for tracking the number of bytes (in the block groups as a
whole, and in terms of useful data stored), plus the vaddr of the
last-moved block group, the size of the btrfs_balance_info struct will
go up from its current 8 bytes to 48. I've just not quite finished
that patch yet, and wanted to get the rest of the patches settled
while I work on the new one...

   Hugo.

> On Sun, Apr 10, 2011 at 10:06:04PM +0100, Hugo Mills wrote:
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 7f78cc7..17c7ecc 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -865,6 +865,11 @@ struct btrfs_block_group_cache {
> >  	struct list_head cluster_list;
> >  };
> >  
> > +struct btrfs_balance_info {
> > +	u32 expected;
> > +	u32 completed;
> 
> two u32 make one u64
> 
> > +};
> > +
> >  struct reloc_control;
> >  struct btrfs_device;
> >  struct btrfs_fs_devices;
> > @@ -1078,6 +1083,10 @@ struct btrfs_fs_info {
> >  
> >  	/* filesystem state */
> >  	u64 fs_state;
> > +
> > +	/* Keep track of any rebalance operations on this FS */
> > +	spinlock_t balance_info_lock;
> > +	struct btrfs_balance_info *balance_info;
> 
> a pointer is a u64 too
> 
> >  };
> >  
> >  /*
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index dd13eb8..bb2ffed 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2051,6 +2052,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
> >  	mutex_lock(&dev_root->fs_info->volume_mutex);
> >  	dev_root = dev_root->fs_info->dev_root;
> >  
> > +	bal_info = kmalloc(
> > +		sizeof(struct btrfs_balance_info),
> > +		GFP_NOFS);
> 
> ... drop
> 
> > +	if (!bal_info) {
> > +		ret = -ENOMEM;
> > +		goto error_no_status;
> > +	}
> > +	spin_lock(&dev_root->fs_info->balance_info_lock);
> > +	dev_root->fs_info->balance_info = bal_info;
> > +	bal_info->expected = -1; /* One less than actually counted,
> > +				    because chunk 0 is special */
> > +	bal_info->completed = 0;
> > +	spin_unlock(&dev_root->fs_info->balance_info_lock);
> > +
> >  	/* step one make some room on all the devices */
> >  	list_for_each_entry(device, devices, dev_list) {
> >  		old_size = device->total_bytes;
> > @@ -2115,10 +2157,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
> >  					   found_key.offset);
> >  		BUG_ON(ret && ret != -ENOSPC);
> >  		key.offset = found_key.offset - 1;
> > +		spin_lock(&dev_root->fs_info->balance_info_lock);
> > +		bal_info->completed++;
> > +		spin_unlock(&dev_root->fs_info->balance_info_lock);
> > +		printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
> > +		       bal_info->completed, bal_info->expected);
> >  	}
> >  	ret = 0;
> >  error:
> >  	btrfs_free_path(path);
> > +	spin_lock(&dev_root->fs_info->balance_info_lock);
> > +	kfree(dev_root->fs_info->balance_info);
> 
> ... drop
> 
> > +	dev_root->fs_info->balance_info = NULL;
> > +	spin_unlock(&dev_root->fs_info->balance_info_lock);
> > +error_no_status:
> >  	mutex_unlock(&dev_root->fs_info->volume_mutex);
> >  	return ret;
> >  }

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Never underestimate the bandwidth of a Volvo filled ---       
                           with backup tapes.                            

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNpJz/IKyzvlFcI40RAg8SAJ9GznjaYSqpQhvXhPFhunIoCKn9xgCePkf9
owwfOJeNdkx9Uga2JcnPi8g=
=D0Xb
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
