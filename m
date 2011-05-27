From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 10:12:24 +0100
Message-ID: <20110527091224.GA15627@carfax.org.uk>
References: <20110526212203.GA4611@yahoo.fr>
 <chaz20110527080157.GA27537@seebyte.com>
 <4DDF5EEF.6060706@gmail.com>
 <chaz20110527084733.GC27537@seebyte.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110527084733.GC27537@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 27, 2011 at 09:47:33AM +0100, Stephane Chazelas wrote:
> 2011-05-27 10:21:03 +0200, Andreas Philipp:
> [...]
> > > What do those top-level IDs mean by the way?
> > The top-level ID associated with a subvolume is NOT the ID of this
> > particular subvolume but of the subvolume containing it. Since the
> > "root/initial" (sub-)volume has always ID 0, the subvolumes of "depth"
> > 1 will all have top-level ID set to 0. You need those top-level IDs to
> > correctly mount a specific subvolume by name.
> > 
> > # mount /dev/dummy -o subvol=<subvolume>,subvolrootid=<top-level ID>
> > /mountpoint
> > 
> > Of course, you do need them, if you specify the subvolume to mount by
> > its ID.
> [...]
> 
> Thanks Andreas for pointing that subvolrootid (might be worth
> adding it to
> https://btrfs.wiki.kernel.org/index.php/Getting_started#Mount_Options
> BTW).
> 
> In my case, on a freshly made btrfs file system, subvolumes have
> top-level 5. (and neither volume with id 0 or 5 appear in the
> btrfs sub list).
> 
> All the top-levels are 5, and I don't even know how to create a
> subvolume with a different top-level there, so I wonder how that
> subvol that I had created with

   Actually, top-level subvolume ID=0 is a fiction. Internally, each
subvolume is a separate FS tree (an FS tree in btrfs is a btree
containing all of the inode and directory information for some
subvolume). These trees are all referred to by a tree called the "root
tree", which indexes all of the btrees in the filesystem.

   The root tree has a unique reference ID for each tree that it
points to: most of the trees (extent tree, device tree, etc) have
fixed and well-known IDs smaller than 256. The FS tree for the
top-level subvolume -- the one that doesn't show up on a subvolume
list -- always has ID 5. Hence the containing subvolume for most of
your subvolumes is 5. The FS trees for the non-top-level subvolumes
have IDs starting at 256 and increasing monotonically.

   Internally, there's a bit of a fiddle in the API, where a request
for a subvolume ID of 0 is (sometimes) translated to an ID of 5. It's
not always done, I think, and those cases where a subvol ID of 0
doesn't get you the top-level subvolume should be treated as bugs.

   That's all rather dense, and probably too much information. Hope
it's helpful, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- A linked list is still a binary tree.  Just a very unbalanced ---  
                             one.  -- dragon                             

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN32r4IKyzvlFcI40RAjp4AJ9y3qT9kOIx4/QeO+RdN1AXjgWhkACaAvLm
k+BKWKk/AWAew0zC3AXBr7M=
=kM5f
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
