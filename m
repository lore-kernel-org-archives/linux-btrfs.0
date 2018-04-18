Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:42384 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753145AbeDRXY5 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 18 Apr 2018 19:24:57 -0400
Subject: Re: [PATCH v3] btrfs: Do super block verification before writing it
 to disk
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180417014719.3799-1-wqu@suse.com>
 <20180418220432.GV21272@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <55dd6f1f-c45f-ca91-f959-0d625129f5de@suse.com>
Date: Thu, 19 Apr 2018 07:24:43 +0800
MIME-Version: 1.0
In-Reply-To: <20180418220432.GV21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qttAXM4Mmizfd0irJx68fHJdBlgdNVZRZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qttAXM4Mmizfd0irJx68fHJdBlgdNVZRZ
Content-Type: multipart/mixed; boundary="9bzZHpZ1AJIY75D03YYXwCecVjnrkgwwW";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <55dd6f1f-c45f-ca91-f959-0d625129f5de@suse.com>
Subject: Re: [PATCH v3] btrfs: Do super block verification before writing it
 to disk
References: <20180417014719.3799-1-wqu@suse.com>
 <20180418220432.GV21272@twin.jikos.cz>
In-Reply-To: <20180418220432.GV21272@twin.jikos.cz>

--9bzZHpZ1AJIY75D03YYXwCecVjnrkgwwW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8819=E6=97=A5 06:04, David Sterba wrote:
> On Tue, Apr 17, 2018 at 09:47:19AM +0800, Qu Wenruo wrote:
>> @@ -2680,7 +2681,7 @@ int open_ctree(struct super_block *sb,
>> =20
>>  	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>> =20
>> -	ret =3D btrfs_check_super_valid(fs_info);
>> +	ret =3D btrfs_check_super_valid(fs_info, fs_info->super_copy);
>>  	if (ret) {
>>  		btrfs_err(fs_info, "superblock contains fatal errors");
>>  		err =3D -EINVAL;
>> @@ -3310,6 +3311,27 @@ static int write_dev_supers(struct btrfs_device=
 *device,
>=20
> This is in write_dev_supers, so the superblock is checked
> number-of-devices times. The caller write_all_supers rewrites the devic=
e
> item so it matches the device it's going to write to. But,
> btrfs_check_super_valid does not validate the dev_item so all the
> validation does not bring much benefit, as it repeatedly checks the sam=
e
> data.
>=20
> So, what if the validation is done only once in write_all_supers? Lock
> the devices, validate, if it fails, report that and unlock devices and
> go readonly.

Makes sense.

I'll update btrfs_check_super_valid() to cooperate with that in next upda=
te.

Thanks,
Qu

>=20
> There's a differnce to what you implemented: if the in-memory superbloc=
k
> corruption happens between writing to the devices, there are some left
> with the new superblock and some with the old.
>=20
> Although this sounds quite improbable, I think that doing the check in
> advance would save some trouble if that happens. The superblocks on all=

> devices will match.
>=20


--9bzZHpZ1AJIY75D03YYXwCecVjnrkgwwW--

--qttAXM4Mmizfd0irJx68fHJdBlgdNVZRZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrX07wACgkQwj2R86El
/qh7PAgAhltv6rV5EqdAZYL/qwuiosvPzg6qFJWzvcC+I9V6IzGRaDvwsEoCQ98D
XndcoBlEhg4m/vCbjzhQVfG83uVhlwve5fqMdqdU0tKF0RvoELLH3ph+K0kTPglX
aeTRfHTyc+2fNsUStYGpjsSETyA8tr9rTfTmttaKVHYFVkVnHnOx2kQILm9qqEMO
8f+bgvcdeUL0uWipVBrPb/hnNs2EUvuDSXkTsBEdLp0V/oExCL4cbhhaDVG/0a5W
t/icdggpHtAMJfmTYkgXvPo109kv+V66NruOKACAlWPrNr9WEs+juQykXF/Ps2lE
Jh1qOhEvI5kv8mpVvtKHW37/IphRJQ==
=BV/J
-----END PGP SIGNATURE-----

--qttAXM4Mmizfd0irJx68fHJdBlgdNVZRZ--
