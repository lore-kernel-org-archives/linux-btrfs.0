Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53627 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbeHHJjY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 05:39:24 -0400
Subject: Re: [RFC PATCH 0/4] undelete subvolume online version
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
 <20180807163950.GP3218@twin.jikos.cz>
 <bd99bd51-5813-702e-b496-654fead1be41@gmx.com>
 <20180808065306.GE3288@fnst.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d41f9a4b-8324-d260-ae71-7606ce5d3baf@gmx.com>
Date: Wed, 8 Aug 2018 15:20:47 +0800
MIME-Version: 1.0
In-Reply-To: <20180808065306.GE3288@fnst.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="awTXYlVSpmdIL8V0iKR5ya5cN57EoVEom"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--awTXYlVSpmdIL8V0iKR5ya5cN57EoVEom
Content-Type: multipart/mixed; boundary="azGhP8JlxQILBvovd5Qfy0Cmr7E2w6GK2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <d41f9a4b-8324-d260-ae71-7606ce5d3baf@gmx.com>
Subject: Re: [RFC PATCH 0/4] undelete subvolume online version
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
 <20180807163950.GP3218@twin.jikos.cz>
 <bd99bd51-5813-702e-b496-654fead1be41@gmx.com>
 <20180808065306.GE3288@fnst.localdomain>
In-Reply-To: <20180808065306.GE3288@fnst.localdomain>

--azGhP8JlxQILBvovd5Qfy0Cmr7E2w6GK2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8808=E6=97=A5 14:53, Lu Fengqi wrote:
> On Wed, Aug 08, 2018 at 02:11:24PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B408=E6=9C=8808=E6=97=A5 00:39, David Sterba wrote:
>>> On Sun, Aug 05, 2018 at 06:39:57PM +0800, Lu Fengqi wrote:
>>>> This patchset will add the BTRFS_IOC_SUBVOL_UNDELETE ioctl for onlin=
e
>>>> btrfs subvolume undelete.
>>>>
>>>> And btrfs subvolume undelete subcommand was added to btrfs-progs.
>>>>
>>>> So user can use the following command to recover all the subolume th=
at
>>>> is left on the device. The recovered subvolume will be link to <dest=
> dir
>>>> named to <name_prefix><subvol_id>.
>>>
>>> Hm, I don't agree with the proposed interface - to recover all delete=
d
>>> subvolumes. IMO this should recover just one subvolume of a given id =
a
>>> to given directory.
>>>
>>> The ioctl structure has to be reworked, I've skimmed the code and saw=

>>> some suspicious things but will have a look after the interface is
>>> settled.
>>
>> My concern is, is such purpose really needed?
>>
>> Yes, it's possible user made some mistake and want to get back the dat=
a.
>> But putting an ioctl for 'undelete', then user may consider btrfs is s=
o
>> powerful that can undelete everything.
>> In short, this undelete feature gives user too high expectation.
>>
>> And don't expect user really to read man pages. There are already tons=

>=20
> There is no more way about the too high expectation of users. If we pro=
vide
> a feature with a sufficiently detailed man page, but users do not read =
the
> man page when using this feature, I can only think that they are not
> responsible for their own data. So, this seems to be a problem they nee=
d to
> consider.

IMHO this ioctl is design only for a pretty niche use case.
As long as it's a designed ioctl, it's some kind of a "main" feature.

Even it's users' response to read the man page, we still need to bring
the surprise to minimal.
By all mean, undelete is a minor use case and should be prevented from
the very beginning.

>=20
>> of reports where user execute btrfs check --repair without realizing
>> --repair is pretty dangerous (and thanks to the work done to repair, i=
t
>> normally doesn't cause catastrophic result, but sometimes it indeed
>> causes extra damage)
>=20
> The good news is that online undelete is not as dangerous as btrfs chec=
k
> --repair. In fact, I think it is safe enough.

Yes, for the safety part I completely agree.

>=20
>>
>> And when user tried and failed due to deleted tree blocks, they will g=
et
>> even more frustrated or even betrayed.
>=20
> As mentioned previous, maybe we should do what we think is right, such =
as
> give the user more abilities to protect/recover their data, not to take=

> care of any sensitive users?

=46rom my personal experience, adding a new ioctl means a lot of new
maintenance burden, especially when the need is small (and sometimes
raises user expectation).

Personally speaking, we already have a lot of so-called "optimization"
which makes development pretty tricky.
We should pay more attention when introduce a new feature, evaluating
the user-case and possible complexity carefully, since removing a
feature is way more complex than adding a new one.

(Although thankfully, current undelete is pretty simple, but I'm not
sure if it will become more and more complex)

>=20
>>
>> I prefer to put such undelete as an off-line rescue tool, instead of
>> making it online with an ioctl interface.
>=20
> I also think that the offline undelete is more useful. After all, umoun=
t
> immediately to prevent further data loss is always the most effective a=
fter
> a mistake. However, since we can give the ability of online undelete to=
 a
> user which couldn't umount the filesystem easily,

Well, when the deletion happens, there is no much difference to do
online or offline rescue.
Either way, sane user should already stop its business and check the
system carefully.

> and don't have any side
> effect on existing features. IMHO, there is no reason to reject this.

I just don't want to regret several years later.
Currently for undelete, we already need to take a lot of factors into
consideration, (although most of them are not affected) qgroup, balance,
pending snapshot (and I may miss a lot of more).

I just don't want later development to take undelete into consideration
for such a niche use-case.

Thanks,
Qu


--azGhP8JlxQILBvovd5Qfy0Cmr7E2w6GK2--

--awTXYlVSpmdIL8V0iKR5ya5cN57EoVEom
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltqmc8ACgkQwj2R86El
/qjQgwgAsLAnySXmbuUa8a2TpQGBGo/xlYbDwka6lGF8CZQBn8NwNmF5TJOGkF0B
AIV/IHpS8AdQpmKoQVTBXnf22FnCKUSek2jXztSQBUl5jxLKYLhsG2heuJPjwTwD
VAAK+btovihVwpH5by/oolMn+W4Mlkj8Q7l8ON/IztQuIq8tcOXXUFP4glSoES7O
Pcij6Ab3o2GDRzSW06s//+fXUyIMcsQPL1IqC4YxJ/PkMQnL+XNFECy348LUBCwr
fm0Xw1StoT2Fd7KISpgVyxWTblEwQMknxvEOdav6bKzAntVam9zkYGKESiYkqBMS
Zj/58H/YBiSaK9nd4ym9uNDmYsUPGg==
=yKbK
-----END PGP SIGNATURE-----

--awTXYlVSpmdIL8V0iKR5ya5cN57EoVEom--
