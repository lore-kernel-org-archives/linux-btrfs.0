Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbeDXGv7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 02:51:59 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: remove comments about delayed ref in
 backref.c
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <59c132d1-f6eb-708d-2c8f-96533ac9ce59@gmx.com>
 <30643dd4-0f17-d89e-0216-9751d7133703@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <543ba6cf-a3b3-d6d2-29f3-bfaf7dfe6268@gmx.com>
Date: Tue, 24 Apr 2018 14:51:49 +0800
MIME-Version: 1.0
In-Reply-To: <30643dd4-0f17-d89e-0216-9751d7133703@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P6pjzq4tXOGSAFtWTSNmR7OFHHn0QmWFc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P6pjzq4tXOGSAFtWTSNmR7OFHHn0QmWFc
Content-Type: multipart/mixed; boundary="LFJ936UtYxPRAFbTs1UmwhAiJ4GkTsSuY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <543ba6cf-a3b3-d6d2-29f3-bfaf7dfe6268@gmx.com>
Subject: Re: [PATCH 1/3] btrfs-progs: remove comments about delayed ref in
 backref.c
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <59c132d1-f6eb-708d-2c8f-96533ac9ce59@gmx.com>
 <30643dd4-0f17-d89e-0216-9751d7133703@cn.fujitsu.com>
In-Reply-To: <30643dd4-0f17-d89e-0216-9751d7133703@cn.fujitsu.com>

--LFJ936UtYxPRAFbTs1UmwhAiJ4GkTsSuY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 14:48, Su Yue wrote:
>=20
>=20
> On 04/24/2018 02:02 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 13:52, Su Yue wrote:
>>> There is no delayed ref in btrfs-progs, so remove related comments.
>>>
>>
>> Indeed.
>> Delayed ref is only used to speed up extent tree modification with the=

>> cost of code complexity.
>>
> Thanks for your explanation :).
>=20
>> For btrfs-progs we don't need to worry about it at all.
>>
> So I suggest to remove comments in progs.

Yep, I totally agree with that.

Just forgot to add:

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Thanks,
> Su
>=20
>> Thanks,
>> Qu
>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>> =C2=A0 backref.c | 19 +++----------------
>>> =C2=A0 1 file changed, 3 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/backref.c b/backref.c
>>> index 27309e07a1e9..c144dbf060f2 100644
>>> --- a/backref.c
>>> +++ b/backref.c
>>> @@ -155,19 +155,6 @@ static void init_pref_state(struct pref_state
>>> *prefstate)
>>> =C2=A0=C2=A0 * - if you cannot add the parent or a correct key, then =
we will
>>> look into the
>>> =C2=A0=C2=A0 *=C2=A0=C2=A0 block later to set a correct key
>>> =C2=A0=C2=A0 *
>>> - * delayed refs
>>> - * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> - *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backref type | shared |=
 indirect | shared | indirect
>>> - * information=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 tree |=C2=A0=C2=A0=C2=A0=C2=A0 tree |=C2=A0=C2=A0 data |=C2=A0=C2=A0=
=C2=A0=C2=A0 data
>>> - * --------------------+--------+----------+--------+----------
>>> - *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 parent logical |=C2=A0=C2=A0=C2=A0 =
y=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=
=C2=A0 -=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 -
>>> - *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key to resolve |=C2=A0=C2=A0=C2=A0 =
-=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 y=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=
=C2=A0 y=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 y
>>> - *=C2=A0 tree block logical |=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0 |=C2=A0=
=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0 =
|=C2=A0=C2=A0=C2=A0=C2=A0 -
>>> - *=C2=A0 root for resolving |=C2=A0=C2=A0=C2=A0 y=C2=A0=C2=A0 |=C2=A0=
=C2=A0=C2=A0=C2=A0 y=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0 y=C2=A0=C2=A0 =
|=C2=A0=C2=A0=C2=A0=C2=A0 y
>>> - *
>>> - * - column 1:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 we've the parent =
-> done
>>> - * - column 2, 3, 4: we use the key to find the parent
>>> - *
>>> =C2=A0=C2=A0 * on disk refs (inline or keyed)
>>> =C2=A0=C2=A0 * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> =C2=A0=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backref type=
 | shared | indirect | shared | indirect
>>> @@ -735,9 +722,9 @@ static int __add_keyed_refs(struct btrfs_fs_info
>>> *fs_info,
>>> =C2=A0 }
>>> =C2=A0 =C2=A0 /*
>>> - * this adds all existing backrefs (inline backrefs, backrefs and
>>> delayed
>>> - * refs) for the given bytenr to the refs list, merges duplicates
>>> and resolves
>>> - * indirect refs to their parent bytenr.
>>> + * this adds all existing backrefs (inline backrefs, backrefs for
>>> the given
>>> + * bytenr to the refs list, merges duplicates and resolves indirect
>>> refs to
>>> + * their parent bytenr.
>>> =C2=A0=C2=A0 * When roots are found, they're added to the roots list
>>> =C2=A0=C2=A0 *
>>> =C2=A0=C2=A0 * FIXME some caching might speed things up
>>>
>>
>=20
>=20


--LFJ936UtYxPRAFbTs1UmwhAiJ4GkTsSuY--

--P6pjzq4tXOGSAFtWTSNmR7OFHHn0QmWFc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlre1AUACgkQwj2R86El
/qgOaAgArD6z2gYzI6flcCoY+1TlSHa5r9jjeCI17IxcUiirOYoK3ju6fZCmgNpI
SjflurrAvsj+KQBJ4uuJ8Rl8iVleYebgaoHOk7nXP8iMPza/jm16fStAy1hDiMSG
H7bAFz7NbzxKpJxbi/HGQ+f1L0DpH4VYbV4EjgcqCfnHWWWCJLNVc6Ky5L2VFFMJ
hbkum/ikrGwdZunOara+HDSeTkvRxaZWE3ZMgnEhtRburHKkSNRdo4zmnMKslH/6
KT+R+b85AO5ku07x5KV7mMCh2/6w7SPFJJ+uxOBK2Fvwas46FaK5z9CDo/KLvRhi
s4wqV/oTwwd2dfBkbCU5GYqZHqwktQ==
=HgKq
-----END PGP SIGNATURE-----

--P6pjzq4tXOGSAFtWTSNmR7OFHHn0QmWFc--
