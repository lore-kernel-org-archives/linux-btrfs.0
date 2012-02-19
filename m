From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: online snapshots of subvolumes?
Date: Sun, 19 Feb 2012 13:09:52 +0000
Message-ID: <20120219130952.GC17761@carfax.org.uk>
References: <4F40EF5F.1010404@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Cc: linux-btrfs@vger.kernel.org
To: andrew henry <adhenry.9@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F40EF5F.1010404@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 19, 2012 at 01:47:27PM +0100, andrew henry wrote:
> Can I create a snapshot of a subvolume whilst that subvolume is mounted?
> If so can you explain how?

   Yes.

# btrfs sub snap /subvolume/to/snapshot /path/to/snapshot/name

   The path for the snapshot can be under the subvolume it is a
snapshot of. So for example, I just ran on my machine:

# btrfs sub snap /media/video /media/video/video-snapshot

> I read the sysadmin guide and it details one management setup where you
> leave the initial fs empty, create a subvol, then mount that, and for
> subsequent subvol operations you need to first unmount the subvol and
> remount the original empty fs.

   You don't need to unmount the subvolume. Linux allows you to mount
a filesystem in multiple places at one. With the ability to mount
subvolumes separately in btrfs, this means that you can mount the top
level (subvolid=0) somewhere temporarily without having to unmount
anything else.

   Ths structure suggested in the sysadmin guide is more about not
having snapshots of / kept under / rather than for any technical
limitation of btrfs. If you re-read that section of the sysadmin
guide, the "creating a snapshot" doesn't involve unmounting any "live"
part of the FS. It's only when you want to roll back to an earlier
snapshot that you need to unmount the original subvolume (the second
example in that section).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Comic Sans goes into a bar,  and the barman says, "We don't ---   
                         serve your type here."                          

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPQPSgIKyzvlFcI40RAugOAKCjAoMrvHu1avpAnerOLmkB/0Mu+QCgrhxT
1yUb1u+vEh6P37en97DteOU=
=qkbP
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
