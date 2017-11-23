Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53301 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752436AbdKWMOX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 07:14:23 -0500
Subject: Re: uncorrectable errors in Raid 10
To: Steffen Sindzinski <stesind@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
 <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
 <1c612777-77eb-1b83-101b-a9e0a53ee8be@gmail.com>
 <CAJCQCtRwO5E_xN-7u22uBQ57sYpUf8qQ7O0Abz2m+K8e9+DgdA@mail.gmail.com>
 <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
 <CAJCQCtQKOVYtOmQeCR0GZ08Wew2TjtZzfoA_mDvsHwL5vt06XA@mail.gmail.com>
 <63eff0dd-050c-95e5-0bc8-6c151900261c@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6f961563-f992-41c5-bb6f-2c7f66bbaa0c@gmx.com>
Date: Thu, 23 Nov 2017 20:14:15 +0800
MIME-Version: 1.0
In-Reply-To: <63eff0dd-050c-95e5-0bc8-6c151900261c@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l0fqUxiED7Wt52wumULsWfRLb5sPLbKDp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l0fqUxiED7Wt52wumULsWfRLb5sPLbKDp
Content-Type: multipart/mixed; boundary="5EhDElnpu8ohOsJN8VBta8TOih30ho70s";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steffen Sindzinski <stesind@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <6f961563-f992-41c5-bb6f-2c7f66bbaa0c@gmx.com>
Subject: Re: uncorrectable errors in Raid 10
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
 <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
 <1c612777-77eb-1b83-101b-a9e0a53ee8be@gmail.com>
 <CAJCQCtRwO5E_xN-7u22uBQ57sYpUf8qQ7O0Abz2m+K8e9+DgdA@mail.gmail.com>
 <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
 <CAJCQCtQKOVYtOmQeCR0GZ08Wew2TjtZzfoA_mDvsHwL5vt06XA@mail.gmail.com>
 <63eff0dd-050c-95e5-0bc8-6c151900261c@gmail.com>
In-Reply-To: <63eff0dd-050c-95e5-0bc8-6c151900261c@gmail.com>

--5EhDElnpu8ohOsJN8VBta8TOih30ho70s
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8823=E6=97=A5 20:02, Steffen Sindzinski wrote:
> Hi,
>=20
> I updated to btrfs-progs v4.14-5-gf09e98a3. Unfortunately after 10h
> Gnome desktop / Arch crashed with btrfs check --lowmem unfinished. I
> will run it this night again.

Any kernel backtrace about the crash?

IIRC user space program like btrfs check should not trigger a kernel cras=
h.

>=20
> The result until crash was:
>=20
> Checking filesystem on /dev/sdd2
> UUID: 4fafd0d4-7dd9-4dcc-9a33-5f1ad9555358
> ERROR: extent[15923092037632, 73728] referencer count mismatch (root:
> 260, owner: 3631467, offset: 1019904) wanted: 4, have: 6
> ERROR: extent[16078964924416, 69632] referencer count mismatch (root:
> 260, owner: 4086589, offset: 4296704) wanted: 5, have: 7

This is known bug, please use this branch instead.
https://github.com/adam900710/btrfs-progs/tree/lowmem_fix

Thanks,
Qu

>=20
> Steffen
>=20
>=20
> Am 22.11.2017 um 17:42 schrieb Chris Murphy:
>> On Wed, Nov 22, 2017 at 9:38 AM, Steffen Sindzinski
>> <stesind@gmail.com> wrote:
>>> Hello,
>>>
>>> I did btrfs check --readonly on both disk without finding any error. =
To
>>> reconfirm I did a scrub again which still has found 2 uncorrectable
>>> errors.
>>
>> Try --mode=3Dlowmem option with btrfs-progs 4.3.3 or better 4.14. This=

>> is a new implementation of btrfs check and sometimes it comes up with
>> different results. It's strange that there's only this error found by
>> scrub and not by btrfs check which should be fully checking all
>> metadata for sanity, and in the process it would surely hit a bad
>> checksum.
>>
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--5EhDElnpu8ohOsJN8VBta8TOih30ho70s--

--l0fqUxiED7Wt52wumULsWfRLb5sPLbKDp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloWu5cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhZ7Af/ZLWaWqJ3ANliB5cWvl0Xm0Jt
g5xTqpFwVUHCAXESVfNK8QNPQ3ypKCR7tc/cCMJaqsX33r85oDEmdWv2Rdrc2W59
lwGmuBxIQLsk31Lr9rhIl3rcmbnn04KTjiydavNiUTLH+h4indGhB9NWifaoUgTS
U/BAIxWx7Lqe6/EIYgLouXOwHSS/05l2CDmAzoKOOVnPDGXpm9pkFUPRPqRjRiqT
Ruj4JY7Scz8bjoCqf8RbXe2jnqIrdpe7hXA/dFg2Zhcu1gg2LPsKVnKOSp2NXrxW
nUjtQ+KGewmb09fJoGcXd4VAC52N/PJOGGBuYz2Oxy5aJddCTpD3EE/ZDNL08w==
=MjnJ
-----END PGP SIGNATURE-----

--l0fqUxiED7Wt52wumULsWfRLb5sPLbKDp--
