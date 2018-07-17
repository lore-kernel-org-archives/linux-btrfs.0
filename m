Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.maketank.net ([144.76.88.81]:40339 "EHLO mx02.maketank.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbeGQIbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 04:31:43 -0400
Subject: Re: Corrupted FS with "open_ctree failed" and "failed to recover
 balance: -5"
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
 <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>
 <effecc0d-c835-c690-522f-ccd0214a61db@gmx.com>
From: Udo Waechter <root@zoide.net>
Message-ID: <aead107b-8d03-eaee-05ea-f13f64a3a7e0@zoide.net>
Date: Tue, 17 Jul 2018 10:00:00 +0200
MIME-Version: 1.0
In-Reply-To: <effecc0d-c835-c690-522f-ccd0214a61db@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="e9unI47z8NQo6cpMgDH2mnfilhbch75zE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e9unI47z8NQo6cpMgDH2mnfilhbch75zE
Content-Type: multipart/mixed; boundary="7Ghhtv8vLGdQpLBIYPlAqv0sGNHkO6l1e";
 protected-headers="v1"
From: Udo Waechter <root@zoide.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <aead107b-8d03-eaee-05ea-f13f64a3a7e0@zoide.net>
Subject: Re: Corrupted FS with "open_ctree failed" and "failed to recover
 balance: -5"
References: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
 <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>
 <effecc0d-c835-c690-522f-ccd0214a61db@gmx.com>
In-Reply-To: <effecc0d-c835-c690-522f-ccd0214a61db@gmx.com>

--7Ghhtv8vLGdQpLBIYPlAqv0sGNHkO6l1e
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Thanks for the answer.

On 16/07/18 10:32, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B407=E6=9C=8816=E6=97=A5 16:15, Udo Waechter wrote:
>>> The weird thing is that I can't really find information about the
>>> "failed to recover balance: -5" error. - There was no rebalancing
>>> running when during the crash.
>=20
> Can only be determined by tree dump.
>=20
> # btrfs ins dump-tree -t root <device>
This gives me:

btrfs-progs v4.13.3
parent transid verify failed on 321265147904 wanted 3276017 found 3273915=

parent transid verify failed on 321265147904 wanted 3276017 found 3273915=

parent transid verify failed on 321265147904 wanted 3276017 found 3263707=

parent transid verify failed on 321265147904 wanted 3276017 found 3273915=

Ignoring transid failure
leaf parent key incorrect 321265147904
ERROR: unable to open /dev/vg00/var_....

>>> * Unfortunatly I did a "btrfs rescue zero-log" at some point :( - As =
it
>>> turns out that might have been a bad idea
>>>
>>>
>>> * Also, a "btrfs  check --init-extent-tree" - https://pastebin.com/jA=
TDCFZy
>=20
> Then it is making things worse, fortunately it should terminate before
> it causes more damage.
>=20
> I'm just curious why people doesn't try the safest "btrfs check" withou=
t
> any options, but goes the most dangerous option.
>=20
> And "btrfs check" output please.
> If possible, "btrfs check --mode=3Dlowmem" is also good for debug.
>=20
Same thing here:

parent transid verify failed on 321265147904 wanted 3276017 found 3273915=

parent transid verify failed on 321265147904 wanted 3276017 found 3273915=

parent transid verify failed on 321265147904 wanted 3276017 found 3263707=

parent transid verify failed on 321265147904 wanted 3276017 found 3273915=

Ignoring transid failure
leaf parent key incorrect 321265147904
ERROR: cannot open file system


I did an image with dd pretty early in this process. Unfortunatly this
gives me the same error.


Thanks,
udo.

> Thanks,
> Qu
>=20
>>>
>>> The volume contained qcow2 images for VMs. I need only one of those,
>>> since one piece of important software decided to not do backups :(
>>>
>>> Any help is highly appreciated.
>>>
>>> Many thanks,
>>> udo.
>>>
>>
>=20


--7Ghhtv8vLGdQpLBIYPlAqv0sGNHkO6l1e--

--e9unI47z8NQo6cpMgDH2mnfilhbch75zE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEKvHlGi1zjN9ykHKEyMU4ySCz1VEFAltNogQACgkQyMU4ySCz
1VFbxAgAjEs0xdalR7HFgDCQalJGvV0flDfgdtoX0wX7YfbHpeThH0xguBGGifu9
BQ7ap7hiOS7RMyPxoWxufO1IIGTu/QWWO61UJOCkpNe4Q6VMi61nMlV6JxQF7lNw
/jTuLGgeb513uDfRM1ZR+UZ+UEc/Zyp6O/WqfhLZMjGIWppJHId/6cFiLxEy7bUU
mhfWwz/PUfETOdlD3eR02WXIhN91W8RipYUcZXVMmk2JMUyD5fm9D48a15HvsLYe
/ycLl1TwM5teTabm7LVKxUug7zAumS5oXhvcuefusn7JnU9+vbJKZW7wmZE7Y0Lh
KDRYXRU0OFmQUylyfBo9rCmqwKNzQg==
=7JxV
-----END PGP SIGNATURE-----

--e9unI47z8NQo6cpMgDH2mnfilhbch75zE--
