Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55127 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755614AbeDXGvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 02:51:08 -0400
Subject: Re: [PATCH 3/3] btrfs-progs: do not merge tree block refs have
 different root_id
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>
 <5de2f409-32e4-7e23-3589-e89c2e7510c3@gmx.com>
 <c40ab3ef-5495-74be-489c-1704eac9f77f@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ae2fa324-0e8b-9641-d957-37c941344321@gmx.com>
Date: Tue, 24 Apr 2018 14:50:57 +0800
MIME-Version: 1.0
In-Reply-To: <c40ab3ef-5495-74be-489c-1704eac9f77f@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lyQSJBFgC0Ind8hrsAqhB2kv0B03LBRBZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lyQSJBFgC0Ind8hrsAqhB2kv0B03LBRBZ
Content-Type: multipart/mixed; boundary="W0f207QeBjGP4SvGWmnGqxcchx6kngYRp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <ae2fa324-0e8b-9641-d957-37c941344321@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: do not merge tree block refs have
 different root_id
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>
 <5de2f409-32e4-7e23-3589-e89c2e7510c3@gmx.com>
 <c40ab3ef-5495-74be-489c-1704eac9f77f@cn.fujitsu.com>
In-Reply-To: <c40ab3ef-5495-74be-489c-1704eac9f77f@cn.fujitsu.com>

--W0f207QeBjGP4SvGWmnGqxcchx6kngYRp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 14:43, Su Yue wrote:
>=20
>=20
> On 04/24/2018 02:17 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 13:52, Su Yue wrote:
>>> For an extent item which contains many tree block backrefs, like
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> In 020-extent-ref-cases/keyed_block_ref.img
>>>
>>> item 10 key (29470720 METADATA_ITEM 0) itemoff 3450 itemsize 222
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 refs 23 gen 10 flags TREE_BLOCK
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block skinny level 0
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 278
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 277
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 276
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 275
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 274
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 273
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 272
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 271
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 270
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 269
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 268
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 267
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 266
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 265
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 264
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 263
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 262
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 261
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 260
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 259
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 258
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree block backref root 257
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> In find_parent_nodes(), these refs's parents are 0, then __merge_refs=

>>> will merge refs to one ref. It causes only one root to be returned.
>>
>> This is a pretty big problem, and it would cause qgroup verification
>> code to cause false alerts.
>>
>> So a new test case would do great help here.
>>
> Let me think how to construct a test case a while.
> If I remember correctly, the function is called rarely only
> in check/lowmem check.
> Check calls it in a very corner case.
> As you know, extent check in lowmme is buggy which I'm try to fix.

I mean, if the problem is find_parent_nodes() can only return one root,
it would definitely cause problem for qgroup_verify_all() function, then
it should be pretty easy to craft a test image.

Thanks,
Qu

>=20
>>>
>>> So, if both parents are 0, do not merge refs.
>>>
>>> Lowmem check calls find_parent_nodes frequently to decide whether.
>>> check an extent buffer or not. These bug influences bytes accounting.=

>>
>> Although it looks good so far, and would fix the problem you found, bu=
t
>=20
> Fixing another bug in lowmem, found it by accident.
>=20
>> I strongly recommend to port kernel backref code to btrfs-progs here, =
as
>> kernel backref code is more tested than btrfs-progs backref code.
>>
> It's a fact. Seen backref.c in btrfs-progs, there are many useless code=
s
> and confusing logicals.
> I agree that port kernel backref code to btrfs-progs.
>=20
>> I'm pretty sure we have more bugs in btrfs-progs backref, and I'm not =
a
>> big fan of playing whac-a-mole here.
>>
>>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>> =C2=A0 backref.c | 2 ++
>>> =C2=A0 1 file changed, 2 insertions(+)
>>>
>>> diff --git a/backref.c b/backref.c
>>> index 51553c702187..daadb6299c79 100644
>>> --- a/backref.c
>>> +++ b/backref.c
>>> @@ -507,6 +507,8 @@ static void __merge_refs(struct pref_state
>>> *prefstate, int mode)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 } else {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ref1->parent !=3Def2->parent)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (ref1->parent =3D0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>
>> It's better to put it above (ref1->parent !=3Def2->parent).
>> As parent =3D0 means we haven't resolve the parent bytenr yet, so can'=
t
>> be merged nor compared.
>=20
> Ok, will do it in V2.
>=20
> Thanks,
> Su
>>
>> Thanks,
>> Qu
>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 eie =3Def1->inode_list;
>>>
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--W0f207QeBjGP4SvGWmnGqxcchx6kngYRp--

--lyQSJBFgC0Ind8hrsAqhB2kv0B03LBRBZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlre09EACgkQwj2R86El
/qjhzgf/epULbdZggOZYyT/uRX3LM6gX/UxEUBdyS7NN9KkwnIFpCuGT5gAd/Xvg
ATmgyyjbSQsb67B/1hcucjZo8ddKBUwo34D0zVmf8pQ3XnfxTyCgnhns5RcWhSWz
a2APjFp61HilWp4gAL2vlO1gKQIDpp8WtGfXNgpQyUUrkeq5b+vewOZiCn1Jarfi
EytPj28EHiGbxqUzI+TUOk3N+EtmiPEg9vySIBM0OSvgleRBn6jueeZR3bO0B2UF
9G0KdtPPqxVv5Gb0BvXqbtPgh7BDKjTVrbGkACyuVNNZwMy4dFbx3aRlm7CkMIKr
C5iAeYV7x7FlGA/PAecmdSbddsofSQ==
=2bnb
-----END PGP SIGNATURE-----

--lyQSJBFgC0Ind8hrsAqhB2kv0B03LBRBZ--
