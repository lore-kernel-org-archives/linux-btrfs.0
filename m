Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:42645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752625AbeFHBVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 21:21:08 -0400
Subject: Re: [PATCH RFC] btrfs-progs: map-logical: look at next leaf if slot >
 items
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
 <274f47db-b3cc-60fd-002b-f8c1eba29d6c@gmx.com>
 <CA+X5Wn7ore144+BqMSmntPOGX3c5HiyQtQN_p4+F1+rfhCQSsg@mail.gmail.com>
 <c10bf62d-8c31-7f1d-809a-c36b39c1930c@gmx.com>
 <CA+X5Wn6sHMVt=U81GVmD4X6ffk8H1NtN9dMuQcyheKv3BA4azA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <83428e27-51c2-ad54-74d7-2f8e1245c5fa@gmx.com>
Date: Fri, 8 Jun 2018 09:21:00 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn6sHMVt=U81GVmD4X6ffk8H1NtN9dMuQcyheKv3BA4azA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xX59SLbPvsO6v2kdt4TN0oRIu1tGHhowl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xX59SLbPvsO6v2kdt4TN0oRIu1tGHhowl
Content-Type: multipart/mixed; boundary="dXpabqk8KqRFnnm2cJx2D1X2Ap5TjFxcl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <83428e27-51c2-ad54-74d7-2f8e1245c5fa@gmx.com>
Subject: Re: [PATCH RFC] btrfs-progs: map-logical: look at next leaf if slot >
 items
References: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
 <274f47db-b3cc-60fd-002b-f8c1eba29d6c@gmx.com>
 <CA+X5Wn7ore144+BqMSmntPOGX3c5HiyQtQN_p4+F1+rfhCQSsg@mail.gmail.com>
 <c10bf62d-8c31-7f1d-809a-c36b39c1930c@gmx.com>
 <CA+X5Wn6sHMVt=U81GVmD4X6ffk8H1NtN9dMuQcyheKv3BA4azA@mail.gmail.com>
In-Reply-To: <CA+X5Wn6sHMVt=U81GVmD4X6ffk8H1NtN9dMuQcyheKv3BA4azA@mail.gmail.com>

--dXpabqk8KqRFnnm2cJx2D1X2Ap5TjFxcl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8808=E6=97=A5 03:57, james harvey wrote:
> "On Thu, Jun 7, 2018 at 3:26 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>> On 2018=E5=B9=B406=E6=9C=8807=E6=97=A5 15:19, james harvey wrote:
>>> On Thu, Jun 7, 2018 at 12:44 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>> On 2018=E5=B9=B406=E6=9C=8807=E6=97=A5 11:33, james harvey wrote:
>>>>> * btrfs_item_key_to_cpu sets key to (10955960320, BTRFS_EXTENT_ITEM=
_KEY, 4096)
>>>>> !!! Bonus bug, LEFT FOR READER.  Why is this item #197, 5 items bef=
ore the 203
>>>>>     given?  I think no bounds checking causes a buffer over-read he=
re.
>>>>>     btrfs_item_key_to_cpu() calls btrfs_item_key(), which uses the =
macro
>>>>>     read_eb_member() to call read_extent_buffer() which memcpy's us=
ing an out
>>>>>     of range index, at least for this leaf.
>>>>
>>>> Here the key you got could be garbage.
>>>> Either the leaf has enough free space, then you got pending zero int=
o
>>>> the key, or the leaf is full, you got some item data into the key.
>>>>
>>>> Either way, the key should be read/trusted at all.
>>>
>>> Is the group's preference to leave things like bounds checking to the=

>>> caller?
>>
>> The problem here is, btrfs_search_slot() is not only called for
>> read_only search, but also for insert.
>>
>> For insert usage, such returned path is completely valid and in fact
>> could be pretty useful.
>=20
> I don't mean for btrfs_search_slot() behavior to change, since it is
> called for inserting.  I mean btrfs_item_key_to_cpu() behavior could
> change.

Makes sense!

An nice point to enhance!

>=20
>>>  (I get the merit to that, avoiding redundant checks.)  My
>>> normal style would be to have read_extent_buffer() fail if start + le=
n
>>> is out of bounds.
>>
>> In this case, it's not out-of-boundary at all, and the invalid key you=

>> read out if from the last item, which could contain a valid key.
>>
>> For leaf, btrfs puts btrfs items pointers at the head, and the items
>> data at the tail.
>>
>> Thus for this case, your invalid key slot is just in the middle of the=

>> leaf, making read_extent_buffer() unable to detect anything wrong.
>>
>> Thanks,
>> Qu
>=20
> You're right.  read_extent_buffer() doesn't have the information to
> look at this.
>=20
> And, "buffer over-read error" was probably the wrong term.  I mean in
> the sense that it has 203 valid values, and is being asked for the
> 204'th item.
>=20
> btrfs_item_key() could error on
>=20
> (nr > btrfs_header_nritems(eb))
>=20
> This defensive programming would cause redundant checks, if the caller
> checks this too as they are supposed to, so I understand if the group
> doesn't swing that far on defensive programming.
>=20
> Although, perhaps in such situation, btrfs_item_key() could
> automatically call btrfs_next_leaf().

This introduce extra return value, and for things like btrfs_item_key(),
we need to modify tons of call sites.

But at least, I could check if doing extra check (mostly a WARN_ON()) in
btrfs_item_key() is valid.

Thanks,
Qu

>  I'm thinking this might not be
> desired behavior everywhere, but just in case it is, mentioning it
> because then btrfs_item_key() could handle all of this, not allowing
> the caller to shoot their own foot, without redundant checks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--dXpabqk8KqRFnnm2cJx2D1X2Ap5TjFxcl--

--xX59SLbPvsO6v2kdt4TN0oRIu1tGHhowl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsZ2fwACgkQwj2R86El
/qj4XQgAjyOgR+aGcyGIQO5ASN43ycDgTI+/9i/FlCjR/OG6BYA02y0Sw0rfT6BR
ZoxptRP260GTyDw1lUf7TkmAOP8XMFdShil3ieVm3z20xDmoDijeuTJCQwIBh+6G
gdK7Ga3zu7W2UO5t+Y29hKz8Kp3j0i4AWBdWJOCfp60j0+hS03K5POAjxNiIEOSf
s8Eq6LWSEUdXbUbsjCuw4j2GF4UBTs+4D2MnTafndrhgqkigoZmEXV2iKGWmJF7D
n6YBTloXgq5wo/QMzB/dICUbCkVcNDQcBECageNcS6g0TXYNkBwV24LM/IPDOYMp
LvMQM0j3+zRhZDj8rkaExiefFDGB/g==
=OZFw
-----END PGP SIGNATURE-----

--xX59SLbPvsO6v2kdt4TN0oRIu1tGHhowl--
