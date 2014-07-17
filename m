Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57316 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbaGQLNH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 07:13:07 -0400
Date: Thu, 17 Jul 2014 12:13:03 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Philippe.Simonet@swisscom.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: NFS FILE ID not unique when exporting many brtfs subvolumes
Message-ID: <20140717111303.GI4834@carfax.org.uk>
References: <562cbe8120c64c99b7dcee045a3bdc7e@SG001738.corproot.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CD/aTaZybdUisKIc"
In-Reply-To: <562cbe8120c64c99b7dcee045a3bdc7e@SG001738.corproot.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CD/aTaZybdUisKIc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 10:40:14AM +0000, Philippe.Simonet@swisscom.com wro=
te:
> I have a problem using btrfs/nfs to store my vmware images.
[snip]
> - vmware is basing its NFS files locks on the nfs fileid field returned f=
rom a NFS GETATTR request for the file being locked
> 	http://kb.vmware.com/selfservice/microsites/search.do?language=3Den_US&c=
md=3DdisplayKC&externalId=3D1007909
>    vmware assumes that these nfs fileid are unique per storage.
>=20
> - it seemed that these nfs fileid are only unique 'per-subvolume', but be=
cause my nfs export contains many subvolumes,
> the nfs export has then my files (in different subvolume) with the same n=
fs fileid.
>=20
> - no problem when I start all machine alone, but when 2 machines are runn=
ing at the same time, vmware seems to mix its reference to lock file and=20
> sometimes kills one vm.
>=20
> 	in esx server, following messages : 	/var/log/vmkwarning.log :=20
>=20
> 	2014-07-17T06:31:46.854Z cpu2:268913)WARNING: NFSLock: 1315: Inode (Dup:=
 260 Orig: 260) has been recycled by server, freeing lock info for .lck-040=
1000000000000
> 	2014-07-17T06:34:47.925Z cpu2:114740)WARNING: NFSLock: 2348: Unable to r=
emove lockfile .invalid, not found
> 	2014-07-17T10:18:50.320Z cpu0:32824)WARNING: NFSLock: 2348: Unable to re=
move lockfile .invalid, not found
>=20
> 	and in machine log :=20
> 		Message from sncubeesx02: The lock protecting vm-w7-sysp.vmdk has been =
lost,=20
> 		possibly due to underlying storage issues. If this virtual machine is c=
onfigured to be highly=20
> 		available, ensure that the virtual machine is running on some other hos=
t before clicking OK.=20
> =09
> - vmware try to make its own file locking for flowing file type :=20
> 	http://kb.vmware.com/selfservice/microsites/search.do?language=3Den_US&c=
md=3DdisplayKC&externalId=3D10051
>=20
> 	VMNAME.vswp=20
> 	DISKNAME-flat.vmdk=20
> 	DISKNAME-ITERATION-delta.vmdk=20
> 	VMNAME.vmx=20
> 	VMNAME.vmxf=20
> 	vmware.log
>=20
> Is there a way to deal with this problem ? is that a bug ?=20

   Add an arbitrary and unique "fsid=3D0x12345" value to the exports
declaration. For example, my server exports a number of subvolumes
=66rom the same FS with:

/srv/nfs/nadja    -rw,async,fsid=3D0x1729,no_subtree_check,no_root_squash \
                   10.0.0.20 fe80::20
/srv/nfs/home     -rw,async,fsid=3D0x1730,no_subtree_check,no_root_squash \
                   fe80::/64
/srv/nfs/video    -ro,async,fsid=3D0x1731,no_subtree_check \
                   10.0.0.0/24 fe80::/64

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- You can get more with a kind word and a two-by-four than you ---  =20
                       can with just a kind word.                       =20

--CD/aTaZybdUisKIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU8evv1heFHXiqx3kAQLNXQ/+MwwovtBBJmYAexIa7d3tUuT79bDb85Qx
4ILtGyiI0QFGdboP6cL+WYkCwG+Cnqn2puSgAHOCeqjYUnMSgiFv+C+bm8H8dBqA
4iMtv91Xs14NGxg658+yjhw0XdhcICPSSqQGy/MUG+c/ODchKQY26OM9d1U+qDyR
8k9jFsGIR92DHAdV6QH9ehrwdGWzkAyuAkjbLqD92wcopJsgpjzuS36FHTQRmZHb
XRlOSQMzmaEGsQgps7UarVuLU4kNSu23+j9JevEeLCEydZNOIOKy5tsL+2er5p1Q
wkvQEU4Vtmd+impl+PciwIa1gdanjYRfstqPNLiW92HEaXjNC+wIkvKkOLnXiEYX
bY4ozS9FT7xI5lyDXv2ZZDnYE6bXo6GJ+Hjx0Ut3wAxVNQZhHm1t0hMAnx/Wu+xN
cVBYLXaSbBp1GR+xJ5AuVFLWKsM6GicmCoacnZKB1JQSniKO4W82m1GdL14WHLPA
Jvz6mCZ81wWJb1q8V+NQx3inMHe+wZCjZ0HjTSLzZeK6gA0GIOTNNyLK+qBL4gZg
v6UB9YDQIpsVtxvXfRFeqp0zAwW/KP9BHy8BtCN8Zx7ejPYftTaQHdCBVY6pcQMp
qoRcBGIxtc1l7uOhwOmMNFIrLU0AlKZIb7MKZ45R55/rpWhlJLJQnLjgoTuR1fs4
My884tX3MLE=
=kFaD
-----END PGP SIGNATURE-----

--CD/aTaZybdUisKIc--
