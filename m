Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58127 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751508AbeBYBg5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Feb 2018 20:36:57 -0500
Subject: Re: BTRFS RESTORE issue
To: =?UTF-8?B?TWFyacOhbiBNbMSNb2No?= <marian@prima.pis.sk>,
        linux-btrfs@vger.kernel.org
References: <E9DC5E3A12524BBAA0B7D3BDE7FB87F2@pc7ssd>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a7984d0a-15e0-a087-1616-1eb21f5ab60e@gmx.com>
Date: Sun, 25 Feb 2018 09:36:49 +0800
MIME-Version: 1.0
In-Reply-To: <E9DC5E3A12524BBAA0B7D3BDE7FB87F2@pc7ssd>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fZfSREvervayubO4mOLaTCFgcdlSlTQzG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fZfSREvervayubO4mOLaTCFgcdlSlTQzG
Content-Type: multipart/mixed; boundary="OgoP9wYWJffhKPZM48NKrKvnT0m2vtSO7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?TWFyacOhbiBNbMSNb2No?= <marian@prima.pis.sk>,
 linux-btrfs@vger.kernel.org
Message-ID: <a7984d0a-15e0-a087-1616-1eb21f5ab60e@gmx.com>
Subject: Re: BTRFS RESTORE issue
References: <E9DC5E3A12524BBAA0B7D3BDE7FB87F2@pc7ssd>
In-Reply-To: <E9DC5E3A12524BBAA0B7D3BDE7FB87F2@pc7ssd>

--OgoP9wYWJffhKPZM48NKrKvnT0m2vtSO7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8824=E6=97=A5 19:13, Mari=C3=A1n Ml=C4=8Doch wro=
te:
> Hello,
> i requst IRC , but nobody helps.
> My primary question is , how mark restored files with ignored errors.
>=20
> btrfs restore =E2=80=93iv /vol /restorage
>=20
> this command restores files like charm but no marker for ok and bad
> files (bad crc , bad ...). WHY?
> This file system isnt newbie , i mean this is urgent feature.

=46rom btrfs-restore(8):

btrfs-restore - try to restore files from a *damaged* btrfs filesystem im=
age

Unless your filesystem is really damaged, you shouldn't use btrfs-restore=
=2E
It's used to *salvage* data, no wonder it will bypass all checksum checki=
ng.

If you want checksum and your fs can stand normal RO mount, go RO mount,
and do normal cp, you will get csum error in kernel message if there is a=
ny.

>=20
> I restore terabytes miloins files , how after this check bad files ???
>=20
> Please send me info around this , and add this feature ifnt exist.
>=20
> I see one way use dump restore filter but how?
>=20
> btrfs restore =E2=80=93ivD /vol /restorage | grep ??? for bad files
>=20
> Second question is when files is restored with switch =E2=80=93iv , exi=
st way to
> update metadata in next restore without overwrite?

What did you mean update metadata?

Thanks,
Qu

> This is for restore
> next urgent feature.
>=20
> Thanks for info Marian.
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--OgoP9wYWJffhKPZM48NKrKvnT0m2vtSO7--

--fZfSREvervayubO4mOLaTCFgcdlSlTQzG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqSEzIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg/owgAkUKz627MnNevELhdiPLG4UNN
gyc0YiS9bbv1CNvuPzwRCvzKRYSIK2zJOXa6dBhA8SZxV1XeO8HZY20Tf4XAPgJR
KIurNXBMobSD7pI+OKIu6FxAFxC60NP7wD64033vZoj/d140ZyVX1U0cJQa7CtkH
3IzsJ+PKj2owkJ+Y9/04bgCBxymLv7AX+rzxV8JfmlewHITnKq7m6l8FsnQyqiYT
ypMLeDHc1yIThz1+D4aNMISYkmjwx5jX+1gVVrzfgvFQkJFneLVmmY6vZyk0Wp2v
Y0m3lGx9yyHIrBeQTNtkrkiAGzKdx6ntjpo8JOMRiTF3/1VZjj8qoPmZf7LlKg==
=+SQU
-----END PGP SIGNATURE-----

--fZfSREvervayubO4mOLaTCFgcdlSlTQzG--
