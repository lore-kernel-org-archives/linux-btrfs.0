From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Is it possible to reclaim block groups once they are allocated
 to data or metadata?
Date: Sat, 5 May 2012 13:52:38 +0100
Message-ID: <20120505125238.GJ9860@carfax.org.uk>
References: <CALzgn9tppzTem57mD6ORK7SXCK2vM6hcsWxphdHLr4eNwFTPQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mFHiwr52TKrxpkjc"
Cc: linux-btrfs@vger.kernel.org
To: Mike Sampson <mike@sambodata.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALzgn9tppzTem57mD6ORK7SXCK2vM6hcsWxphdHLr4eNwFTPQg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--mFHiwr52TKrxpkjc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 05, 2012 at 10:37:01PM +1000, Mike Sampson wrote:
> Hello list,
>=20
> recently reformatted my home partition from XFS to RAID1 btrfs. I used
> the default options to mkfs.btrfs except for enabling raid1 for data
> as well as metadata. Filesystem is made up of two 1TB drives.
>=20
> mike@mercury (0) pts/3 ~ $ sudo btrfs filesystem show
> Label: none  uuid: f08a8896-e03e-4064-9b94-9342fb547e47
> 	Total devices 2 FS bytes used 888.06GB
> 	devid    1 size 931.51GB used 931.51GB path /dev/sdb1
> 	devid    2 size 931.51GB used 931.49GB path /dev/sdc1
>=20
> Btrfs Btrfs v0.19
>=20
> mike@mercury (0) pts/3 ~ $ btrfs filesystem df /home
> Data, RAID1: total=3D893.48GB, used=3D886.60GB
> Data: total=3D8.00MB, used=3D0.00
> System, RAID1: total=3D8.00MB, used=3D136.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, RAID1: total=3D38.00GB, used=3D2.54GB
> Metadata: total=3D8.00MB, used=3D0.00
>=20
> As can be seen I don't have a lot of free space left and while I am
> planning on adding more storage soon I would like to gain a little
> breathing room until I can do this. While I don't have a lot of space
> remaining in Data, RAID1 I do have a good chunk in Metadata, RAID1.
> 2.5GB used out of 38GB. Does this excess become available
> automatically to the file system when the block groups in Data, RAID1
> are exhausted or, if not, is there a way to manually reallocate them?

   Youre best bet at the moment is to try a partial balance of
metadata chunks:

# btrfs balance start -m /home

   That will rewrite all of your metadata, putting it through the
allocator again, and removing the original allocated chunks. This
should have the effect of reducing the allocation of metadata chunks.

   You will need a 3.3 kernel, or later, and an up-to-date userspace
=66rom cmason's git repository.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- All hope abandon,  Ye who press Enter here. ---          =20

--mFHiwr52TKrxpkjc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPpSKWIKyzvlFcI40RAgaPAJ0aygivgnMt4+ArnBxhYekVIK64gQCfY1SF
yeBROFtmvfZNcOI+3SiRMMc=
=G8+P
-----END PGP SIGNATURE-----

--mFHiwr52TKrxpkjc--
