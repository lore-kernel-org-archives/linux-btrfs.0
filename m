From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [PATCH v4 1/8] btrfs: Balance progress monitoring
Date: Fri, 8 Apr 2011 15:07:17 +0100
Message-ID: <20110408140717.GB1608@carfax.org.uk>
References: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
 <1302195975-3088-2-git-send-email-hugo@carfax.org.uk>
 <20110408133715.GM31675@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110408133715.GM31675@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 08, 2011 at 03:37:15PM +0200, David Sterba wrote:
> Hi,
> 
> sorry for separate mail, just noticed a kfree inside a spinlock below
> 
> On Thu, Apr 07, 2011 at 06:06:08PM +0100, Hugo Mills wrote:
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > @@ -2115,10 +2162,20 @@ int btrfs_balance(struct btrfs_root *dev_root)
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
>         ^^^^^
> move it out of the spinlocked section

   From IRC:

<josef> darkling: you can safely kfree inside of a spinlock, dont worry about that
<kdave> josef: the kfree inside spinlock seem a bit heavy to me, if you were referring to the mail
<josef> kdave: kfree just inc's a stat and puts the object in the free array, so its not all that heavy
<josef> not to mention this isn't in a fastpath, if it were a fastpath i'd be more worried about it

   I'm with josef on this -- this is a one-off action at the end of a
process that's likely to take anything up to several days, so it's
about as far from being a fastpath as you can get.

> > +	dev_root->fs_info->balance_info = NULL;
> > +	spin_unlock(&dev_root->fs_info->balance_info_lock);
> > +error_no_status:
> >  	mutex_unlock(&dev_root->fs_info->volume_mutex);
> >  	return ret;
> >  }

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Questions are a burden, and answers a prison for oneself. ---    

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNnxaVIKyzvlFcI40RAt/xAKCRcqJG77UU0Ctj6eaZVWKJ8wrkXQCg1jLf
yDvRficTxa5/51vzs3scfcg=
=S0hE
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
