Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:59848 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752635Ab3KCWDL (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Sun, 3 Nov 2013 17:03:11 -0500
Message-ID: <5276C811.9040201@suse.com>
Date: Sun, 03 Nov 2013 17:02:57 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 01/13] btrfs: add ioctls to query/change feature bits
 online
References: <20131101170654.164867629@suse.com> <20131101172240.170283465@suse.com> <20131101205659.GQ19383@lenny.home.zabbo.net>
In-Reply-To: <20131101205659.GQ19383@lenny.home.zabbo.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wDGKWxoStWUKwGOLRjoCsidwMf1oGnXdp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wDGKWxoStWUKwGOLRjoCsidwMf1oGnXdp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/1/13, 4:56 PM, Zach Brown wrote:
>> +static int btrfs_ioctl_get_supported_features(struct file *file,
>> +					      void __user *arg)
>> +{
>> +	struct btrfs_ioctl_feature_flags features[3];
>> +
>> +	features[0].compat_flags =3D BTRFS_FEATURE_COMPAT_SUPP;
>> +	features[0].compat_ro_flags =3D BTRFS_FEATURE_COMPAT_RO_SUPP;
>> +	features[0].incompat_flags =3D BTRFS_FEATURE_INCOMPAT_SUPP;
>> +
>> +	features[1].compat_flags =3D BTRFS_FEATURE_COMPAT_SAFE_SET;
>> +	features[1].compat_ro_flags =3D BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
>> +	features[1].incompat_flags =3D BTRFS_FEATURE_INCOMPAT_SAFE_SET;
>> +
>> +	features[2].compat_flags =3D BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
>> +	features[2].compat_ro_flags =3D BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
>> +	features[2].incompat_flags =3D BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
>> +
>> +	if (copy_to_user(arg, &features, sizeof(features)))
>> +		return -EFAULT;
>=20
> If these are all constants shouldn't that just copy out of a static
> built flags array?

Works for me. Change added.

-Jeff

> #define cpp4ever(suff) \
> 	BTRFS_FEATURE_COMPAT_#suff, BTRFS_FEATURE_COMPAT_RO_#suff, \
> 	BTRFS_FEATURE_INCOMPAT_#suff
>=20
> 	static struct btrfs_ioctl_feature_flags features[3] =3D {
> 		{ cpp4ever(SUPP) }, { cpp4ever(SAFE_SET) },
> 		{ cpp4ever(SAFE_CLEAR) },
> 	};
>=20
> 	if (copy_to_user(arg, &features, sizeof(features)))
> 		return -EFAULT;
>=20
> ?
>=20
> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--wDGKWxoStWUKwGOLRjoCsidwMf1oGnXdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQIcBAEBAgAGBQJSdsgSAAoJEB57S2MheeWyC98P/jpaRB7h6coHapB/9VwiFLIG
so6LpndpQVdCdZ2l98OiCkIk6zZO0VK8yTwRQ3599Mq88aGtmPfpkx0JnZsNAZef
t6XQLqXF8RjK1nwdmo93fs8zUySt+RyVxmdoDSpPjtOrVZHdNB+ltRfv0iLhxwDn
uhKxslP9aQdqNQUansbf5rnifO8Lr7rl0URpvufk3deJNh9ug7cOO0vOBsLf9M/9
HvzFXxyyMd/7PGAOD2PyoxdnE7/4hFnG06XsDxIukJJzAofAh8sIf7yjIpoXJxlJ
rKix4cBmSFuWG7JnG318pVCNqAlVDaxOuGdhPQiBjQIDTLGHbfp6rKDZa5kV1uJj
thpC3M+xWxXMc3KK2cXHEWyeto64rhEvdbHO3noCEGd7UqmWtBDT1YE1C9jWJ1DT
SUOS78/i/HByN0MLxkG/DyZBXb/kYpH/VVB1oeZWNMTx0CwPdtXVnQuldVE/g6Kb
llUSEP5vjwKHuseX6liewdjOft8Q/YV1T6NIjxqgLcSAh0fUv6WLld9y2MbeC5mC
m/64J7cDGEMDEg49kB/osUCBw6fYq7LbxpaZ0ZOH290oVpZk8GzNVVXsMGhR9CiX
qbXpGowvw1WHMfg2ITwOuEK65c5Q8V46JUzqd78hHDWOZUOuDbKx2QMUrLP+oDD/
F13kvy7z22eEl3f2AWTD
=Y27P
-----END PGP SIGNATURE-----

--wDGKWxoStWUKwGOLRjoCsidwMf1oGnXdp--
