From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: SELinux inode size gotcha in btrfs.
Date: Mon, 27 Feb 2012 23:09:05 +0000
Message-ID: <20120227230904.GC4481@carfax.org.uk>
References: <loom.20120227T210703-631@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120227T210703-631@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 27, 2012 at 10:18:55PM +0000, Alex wrote:
> I've come across the 'gotcha' in XFS where the inode size defaults to 256 [1]
> whereas for SELinux the attributes play better when you initialise it at
> creation to 512.

   A btrfs inode structure is 136 bytes in size. xattrs and any inline
file data are separate from the inode structure, stored with
additional keys in the FS tree (which means that they're quite likely
to appear in the same page, as the inode data, but not guaranteed).

> From my reading of the btrfs specs [2] it doesn't look like you'll get caught
> with that as the inodes "will not contain embedded file data or extended
> attribute data. These things are stored in other item types."
> 
> Have I read that right? I've seen xattr bugs patches etc but nothing that would
> hit the SE Linux domain.

   It's not clear from looking at the gentoo doc what the problem
actually is with different inode sizes... Without some kind of
indication what the issue really is, it's kind of hard to say how this
might affect btrfs.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The enemy have elected for Death by Powerpoint. That's what ---   
                         they shall get.  -- gdb                         

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPTA0QIKyzvlFcI40RAmsjAKCZGgJEbsbjrt7xDILNXjXN2CStHACeP9b8
F1PAIyRcIewiF+YeEtD3+h8=
=PzuZ
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
