From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: SELinux inode size gotcha in btrfs.
Date: Tue, 28 Feb 2012 11:37:05 +0000
Message-ID: <20120228113705.GD4481@carfax.org.uk>
References: <loom.20120227T210703-631@post.gmane.org>
 <20120227231749.GR1046@twin.jikos.cz>
 <loom.20120228T122833-822@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120228T122833-822@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 11:30:26AM +0000, Alex wrote:
> David Sterba <dave <at> jikos.cz> writes:
> 
> > 
> > That's right. Inode represented as btrfs_inode_item does not contain any
> > xattr fields, they're stored independently as a btrfs_dir_item of type
> > BTRFS_FT_XATTR . Due to the way the b-tree keys are built, the xattr
> > item key should be stored near the inode item key, that's for the tree
> > search side. The xattr data are always stored inline in the b-tree leaf.
> > 
> 
> 
> Thank you David and Hugo,
> 
> My bad on three counts:
> 1) My courtesy close seems to have gone missing.
>  Sorry and thank you for replying.
> 2) I, perhaps, should have pointed to
> https://wiki.debian.org/SELinux/Setup#Prerequisites
> _.28kernel_and_filesystems.29
> which gives a better explanation.

   Aaah, OK, that makes sense now. So: we don't have the issue over
xattr sizes at all. The main issue would then seem to be over
atomicity of writing xattrs -- I don't know what the APIs for this
look like, or whether we've implemented them, so I can't comment any
further on btrfs's suitability I'm afraid.

> 3) Made it clear that I wasn't attacking
>  XFS, It's my fs of (non /boot) choice
> for some years now; I'm exploring SELinux
>  (after the recent Linux conf au 2012
> talk) and know I have used inode size defaults
>  for my xfs init back in the day!

   I certainly didn't read it as such.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- In the future, terrorists won't be carrying their ID cards. ---   
                   They'll be carrying yours. -- Henry                   
                         Porter,  Suspect Nation                         

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPTLxhIKyzvlFcI40RAp+vAJ9SdZZZLO5/6DJ9VaV61w9KPeV/5ACdHHeG
Aq60DQiXS6BRAJEjqMmacYs=
=nePP
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
