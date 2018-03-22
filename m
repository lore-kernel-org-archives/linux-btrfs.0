Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43255 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752219AbeCVO0U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:26:20 -0400
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
 <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
 <20180322140041.GB6955@twin.jikos.cz>
 <1cecd52c-74f5-5c2b-73ba-c5b817bbe18f@gmx.com>
 <47bb1e1a-97f2-817c-7b80-6190cc5da18e@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fd2e2920-afcc-6bcf-77bf-17380252524b@gmx.com>
Date: Thu, 22 Mar 2018 22:26:08 +0800
MIME-Version: 1.0
In-Reply-To: <47bb1e1a-97f2-817c-7b80-6190cc5da18e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mIwe79XliaDzSAlH1LRjsXzSbmgXbihB3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mIwe79XliaDzSAlH1LRjsXzSbmgXbihB3
Content-Type: multipart/mixed; boundary="C4pmvfjD2WZGsQWvGwhV9zkSUz7A4d2Fe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fd2e2920-afcc-6bcf-77bf-17380252524b@gmx.com>
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
 <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
 <20180322140041.GB6955@twin.jikos.cz>
 <1cecd52c-74f5-5c2b-73ba-c5b817bbe18f@gmx.com>
 <47bb1e1a-97f2-817c-7b80-6190cc5da18e@suse.com>
In-Reply-To: <47bb1e1a-97f2-817c-7b80-6190cc5da18e@suse.com>

--C4pmvfjD2WZGsQWvGwhV9zkSUz7A4d2Fe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 22:20, Nikolay Borisov wrote:
>=20
>=20
> On 22.03.2018 16:17, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 22:00, David Sterba wrote:
>>> On Thu, Mar 22, 2018 at 09:53:46PM +0800, Qu Wenruo wrote:
>>>>>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>>>>>> index 26484648d090..3866b8ab20f1 100644
>>>>>> --- a/fs/btrfs/backref.c
>>>>>> +++ b/fs/btrfs/backref.c
>>>>>> @@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_in=
fo *fs_info,
>>>>>>  		BUG_ON(ref->key_for_search.type);
>>>>>>  		BUG_ON(!ref->wanted_disk_byte);
>>>>>> =20
>>>>>> -		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0);
>>>>>> +		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0, NULL,=

>>>>>> +				     0);
>>>>>
>>>>> Please add 2nd function that will take the extended parameters and
>>>>> keep read_tree_block as is.
>>>>
>>>> So for any new caller of read_tree_block(), reviewer is the last per=
son
>>>> to info the author to use these parameters for safety check?
>>>>
>>>> And in fact, the old function should be avoid if possible, I think t=
he
>>>> new parameters act as a pretty good sign to make any caller double t=
hink
>>>> about this.
>>>
>>> I saw half of the new parameters were just 0, NULL, so this looks lik=
e a
>>> lot of code churn and I haven't looked closer if there's a chance to
>>> fill the parameters in all callsites. So if it's a matter of adding t=
hem
>>> incrementally then fine.
>>>
>> I'm afraid some of the call sites (ones I left with NULL, 0) are unabl=
e
>> to pass the new parameters by its nature.
>>
>> Such callers include:
>> 1) Tree root
>>    Just @bytenr and @gen from ROOT_ITEM. No @first_key.
>>
>> 2) Backref walker for FULL_BACKREF
>>    Only parent bytenr, no extra info on @first_key.
>>
>> But despite of such call sites, every top-down reader should grab firs=
t
>> key and level. (And so I did in the patch).
>>
>> BTW, about half of the read_tree_block() callers are using the new
>> parameters.
>> So a new function seems a little embarrassing here.
>=20
>=20
> Is it possible to centralise those checks in the read tree verifier,
> rather than sprinkling them around the code?

The problem is, tree checker can only handle things *inside* a
leaf/node, nothing can go beyond leaf/node boundary.

And for current check, we need a top-down pointer (nodeptr, which has
bytenr, generation, first key along with the level) to do the
verification, so that's the reason we can't put it into tree-checker.

(Sorry I forgot to add this explanation, and I didn't find better solutio=
n)

Thanks,
Qu

>=20
>>
>> Thanks,
>> Qu
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--C4pmvfjD2WZGsQWvGwhV9zkSUz7A4d2Fe--

--mIwe79XliaDzSAlH1LRjsXzSbmgXbihB3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqzvQAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjWjwf+PKmJpObu7rCmxdsIHPqxy+AG
79aaKlm3JTWVbCQd54LB4gj/KMwSLEaEkGFiZRcaQBcjQ4SepMOHOWctRv/D4Vv0
5f93NJ2dKk9MqF1i5S6NQpqsBTn720P23gIklK6lvfVgFTDAFXh/g7jOvtdKwnIV
iFHuTGRbsGwH/KRf+A1Nom6D6+miermz7marvvHqgy7FkeMfQsuSU3epDn/QITLk
wUebG87sWUfvw5Uvq/70M85YL3lnyVWlWwH0ob28oeC53czF9rFr51jUX2x4GCay
cIFb5H7nWd9PtU83nZ+YPV9ro9YZEzDiUFFU4XZOHckxubnMptUZr8AEWXlfiQ==
=zk+j
-----END PGP SIGNATURE-----

--mIwe79XliaDzSAlH1LRjsXzSbmgXbihB3--
