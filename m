From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [PATCH v4 1/8] btrfs: Balance progress monitoring
Date: Fri, 8 Apr 2011 14:43:17 +0100
Message-ID: <20110408134317.GA1608@carfax.org.uk>
References: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
 <1302195975-3088-2-git-send-email-hugo@carfax.org.uk>
 <4D9E7249.60303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9E7249.60303@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Li,

   Thanks for the comments.

On Fri, Apr 08, 2011 at 10:26:17AM +0800, Li Zefan wrote:
> 01:06, Hugo Mills wrote:
> > This patch introduces a basic form of progress monitoring for balance
> > operations, by counting the number of block groups remaining. The
> > information is exposed to userspace by an ioctl.
> > 
> > Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> > ---
> >  fs/btrfs/ctree.h   |    9 +++++++
> >  fs/btrfs/disk-io.c |    2 +
> >  fs/btrfs/ioctl.c   |   34 +++++++++++++++++++++++++++++
> >  fs/btrfs/ioctl.h   |    7 ++++++
> >  fs/btrfs/volumes.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  5 files changed, 111 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 7f78cc7..6c5526c 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -865,6 +865,11 @@ struct btrfs_block_group_cache {
> >  	struct list_head cluster_list;
> >  };
> >  
> > +struct btrfs_balance_info {
> > +	u64 expected;
> > +	u64 completed;
> > +};
> > +
> 
> Those can be u32.
> 
> And how about also count the total size and used size of all the chunks ?

   Raw size, or storage size? (i.e. total amount of data to be written
to block devices, or the amount of user data stored?)

[snip]
> > @@ -2074,10 +2089,42 @@ int btrfs_balance(struct btrfs_root *dev_root)
> >  		btrfs_end_transaction(trans, dev_root);
> >  	}
> >  
> > -	/* step two, relocate all the chunks */
> > +	/* step two, count the chunks */
> >  	path = btrfs_alloc_path();
> > -	BUG_ON(!path);
> > +	if (!path) {
> > +		ret = -ENOSPC;
> > +		goto error;
> > +	}
> > +
> > +	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> > +	key.offset = (u64)-1;
> > +	key.type = BTRFS_CHUNK_ITEM_KEY;
> > +
> > +	ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
> > +	if (ret <= 0) {
> > +		printk(KERN_ERR "btrfs: Failed to find the last chunk.\n");
> > +		BUG();
> > +	}
> > +
> 
> How about record the chunk count when allocating a chunk, and clear
> the count before balancing? In this way we can avoid reading the
> chunk tree.

   Well, that works for this case, but we'd still need to iterate over
the contents of the chunk tree in the filtered case (later in the
patch set), so there's not a great deal of point in making that change
here, as I'd only have to put the counting back in later. Also, we'd
end up with an incorrect chunk count if the machine was rebooted
during a balance.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Questions are a burden, and answers a prison for oneself. ---    

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNnxD1IKyzvlFcI40RAs6JAJ4nuollbX6SuW8Cgtc+AiWzA3AOUACgs8T4
AZqX24BT9i6/CYymoI88FTQ=
=ltro
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
