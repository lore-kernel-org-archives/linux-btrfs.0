Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD28C282CD
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 01:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6522521738
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 01:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfA2Bqa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 20:46:30 -0500
Received: from mout.gmx.net ([212.227.15.15]:50431 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfA2Bqa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 20:46:30 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MDymt-1gxKt31aBD-00HRm5; Tue, 29
 Jan 2019 02:46:27 +0100
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <3bc7bf78-8a17-fdf8-e64b-fbfeb3a6218b@gmx.com>
Date:   Tue, 29 Jan 2019 09:46:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X0s8RO33fDfq5ADqWCoCXxpXurAEyJMhX"
X-Provags-ID: V03:K1:MwhojwNUl4VypqACsbdlZQ8aMKRxHFTcljr9Bec4IOrxMOhvVCf
 3BcNn5elaGi5PVUURZevRjOx3nOYf7fO4HnXpspXAvnwRtunqKAWy9BtCnIzDP+7w8cU4xu
 ke4UJbzdC7gaPgl9p6r80OWFCtmg6MGv0HWe9xuLrjIUKbtxAeUWwBns/XiphiTJcoefQbZ
 3mfylY48a1W1ernUoHssg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NTtibo+2POk=:7HyvsTcCTtIS4U7NMMr+eT
 31C5WBbGv8NiV1D9Z+/iLhUql0yaeJK4heUIistnoGf1beVXv8SUDLiNCHL3RWnDU0VRCW3Uh
 SZS5N2mpSty2zMHhSvhGty45XhokERXEkEJfO+o0YO+WVABOl40loP72zViTs7/oqq/WHBrYi
 5GtBaMTVPdJoMSV1Bu+QsROea06RYYp3oqqmlyoxfd/LI26HUhCIjptsCH92SpR3VA2KqqEW+
 CeezXqTofXkDDKEKvJQGGRVPit3wgAPFnkgpYEyMh2m0QRlCDmG8zg5IC8A/UQRBARAIyuFxc
 WLT+DzQFHK5oGOd8pAmrCwA8MVnlxkTaFKnMPsg92u04VEhI3HkmHmz63UiT5nGqLKPa/menv
 S+B+iwxsCKFfPKr7qBx2regGl09DioUALMjp2hpsvJNT4bfxwsjPs3ai99Iq/wjZ7AwbGIdSQ
 k6oE+S/jdFZRt4zH9szW6Z1C5lnYVpObcVRjuJ4ajyz++oIzfCsMMebcA7pFX70++kxKW8dJ0
 9nTZXLuef2rtjPbqzNZ0MLveBQK7iA/Tuo18MvMM1udDvi26HuozA2YprchDCw7kPIoJdBwer
 ojO88jb1fdi3L1E9zzIbY7RDdvLZ8DiK0BSj7Y8b3kG3plQH8vjIpjVeO7QQNH6k9QuG2Nz9W
 llxlVoLplagBcqxj2HD3HXw0apG2zVdPlodkQBB/8WZy9tZp0gPmekH3u6ol823vFaYHHJDHv
 QkX/U09X1J786Dy/x7a5AC7bKIZpbb/lDaSfkh/xHewTmOuEofp9IqK9IYVXvuJXlxawUvblz
 n/oCuWzHQFd52+9QyzkgnCRGJDILGGaFNzHTMsH27+qwFeRD39TfpOj6UMLd2pZz1lYzT2J2B
 4oFJVplTaL/L34zJz/FBLKoZcvT8t7WJVj+VWsV2UmpF4SXhPhL9iSTK/GKArd
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X0s8RO33fDfq5ADqWCoCXxpXurAEyJMhX
Content-Type: multipart/mixed; boundary="6QQhJRHugfF0NhGFy8Ghy5fRCCRFEwzTX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: DanglingPointer <danglingpointerexception@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <3bc7bf78-8a17-fdf8-e64b-fbfeb3a6218b@gmx.com>
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
In-Reply-To: <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>

--6QQhJRHugfF0NhGFy8Ghy5fRCCRFEwzTX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/29 =E4=B8=8A=E5=8D=886:07, DanglingPointer wrote:
> Thanks Qu!
> I thought as much from following the mailing list and your great work
> over the years!
>=20
> Would it be possible to get the wiki updated to reflect the current
> "real" status?
>=20
> From Qu's statement and perspective, there's no difference to other
> non-BTRFS software RAID56's out there that are marked as stable (except=

> ZFS).

I'm afraid that my old statement is wrong.

Quite a lot software RAID56 has a way to record which block get
modified, just like some hardware RAID56 controller does, thus get rid
of the write hole problem.

Thanks,
Qu

> Also there are no "multiple serious data-loss bugs".
> Please do consider my proposal as it will decrease the amount of
> incorrect paranoia that exists in the community.
> As long as the Wiki properly mentions the current state with the option=
s
> for mitigation; like backup power and perhaps RAID1 for metadata or
> anything else you believe as appropriate.
>=20
>=20
> Thanks,
>=20
> DP
>=20
>=20
> On 28/1/19 11:52 am, Qu Wenruo wrote:
>>
>> On 2019/1/26 =E4=B8=8B=E5=8D=887:45, DanglingPointer wrote:
>>>
>>> Hi All,
>>>
>>> For clarity for the masses, what are the "multiple serious data-loss
>>> bugs" as mentioned in the btrfs wiki?
>>> The bullet points on this page:
>>> https://btrfs.wiki.kernel.org/index.php/RAID56
>>> don't enumerate the bugs.=C2=A0 Not even in a high level.=C2=A0 If an=
ything what
>>> can be closest to a bug or issue or "resilience use-case missing" wou=
ld
>>> be the first point on that page.
>>>
>>> "Parity may be inconsistent after a crash (the "write hole"). The
>>> problem born when after "an unclean shutdown" a disk failure happens.=

>>> But these are *two* distinct failures. These together break the BTRFS=

>>> raid5 redundancy. If you run a scrub process after "an unclean shutdo=
wn"
>>> (with no disk failure in between) those data which match their checks=
um
>>> can still be read out while the mismatched data are lost forever."
>>>
>>> So in a nutshell; "What are the multiple serious data-loss bugs?".
>> There used to be two, like scrub racing (minor), and screwing up good
>> copy when doing recovery (major).
>>
>> Although these two should already be fixed.
>>
>> So for current upstream kernel, there should be no major problem despi=
te
>> write hole.
>>
>> Thanks,
>> Qu
>>
>>> If
>>> there aren't any, perhaps updating the wiki should be considered for
>>> something less the "dramatic" .
>>>
>>>
>>>


--6QQhJRHugfF0NhGFy8Ghy5fRCCRFEwzTX--

--X0s8RO33fDfq5ADqWCoCXxpXurAEyJMhX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxPsG8ACgkQwj2R86El
/qigPQf/cMLMWLxZf8J7Hs8WDP7RBw5c0F8QOmJRWmVi+sKeBtIGgS2avXqhPPvy
g9P4Or3EzWCEC4tPE/FHxLS14HXO8db4BA2Rf2xKZLBsycbnN1SozaJX+HJmiX19
v8wy7TJMJ4Sp+f9NRiyuaxOoY4v+OErdJLTchZW40xeGk9wzGuvu9+w72AgjGERQ
Up/FIFurGDwXsj7iEJoNSucPK43MI2NZu90vIy1xqQCqjxnNNPy4GO4rzCcJQhzS
94+aalJeoQcsjO/kTY8PFWQ0PQK1PGjL7wePFTHNImlTGOxMXe6yFOVZFsUYLIT6
7OWZacwGT3Tf4o4Ec2hywk91z93prw==
=tJhO
-----END PGP SIGNATURE-----

--X0s8RO33fDfq5ADqWCoCXxpXurAEyJMhX--
