Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38772C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 01:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEBC32175B
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 01:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="DemAcixp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfCTBCb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 21:02:31 -0400
Received: from mout.gmx.net ([212.227.17.21]:49575 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbfCTBCb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 21:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553043745;
        bh=h5au+YVk83y/Z6h+YdexaVIwrf8uq32702xKeHC5WLs=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=DemAcixpOFpajVaSS62VycVUtrPBi5xGqBAKP6lQqe33d1PjsO2VTzsOLsyCrw1Ag
         sBD8SR1EV/RD8xmbhzjeTJqG2fflN/zLhz8GWE2UnBfnC3aoHVIeP+7KUpNUPnXtF5
         qSDQ6VYtu2lhx50hfokIgfYOTpp9ZTeWZ0Y6BCKw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LgqEs-1gd9Pl4Ayc-00oHk1; Wed, 20
 Mar 2019 02:02:24 +0100
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
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
Message-ID: <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
Date:   Wed, 20 Mar 2019 09:02:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ONGaBlD2Zb7L8lvhmwBWJUaZ0GFKxcp1Q"
X-Provags-ID: V03:K1:LY8k6Y89DQZkukObCV2l6lOtlmiR0saN3JqtWPUocFpBsAL5jZg
 roYgupgGu8bpGejK61ll8PvuqfnP/ZWMuqDiuc3h72DuHz8PTfTjdEMj4/AS6TzEATO+qdy
 x4jU2jCIzZQK7sZFQhoRjJK2af6kE0CcZgu8bGz3CBqR1fx8TYWwve5QkOpRpbiuZmTCEV1
 pbeieiXcHa5rc4MEvLFJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:j2qR231KYnM=:m4GvDkXKdTQLTkAbU/RWqY
 O+qBgWjWFVGy9/0ucTIkSyYVFrl6L6At8lC/DegZec6JxaYpZIPkHdjg77hhN4ki+tAX2Cah2
 w8dqQufVzIy0pEaZB8PdjwhIexqoecGduYBCJvRQ/UOxvSEE8NYtrniyfgvG73Kw74xcNqS8w
 U5cHecB5W4SQzVSuN00kVuUaeh4LWzpc7HIUjmqh9DMosLVjEcLd0bCiV2bI3q4AOu8TDV10W
 8h/6rYQ6uo+LodPTGLHMU4+5LslazNWlX1CiDPXXSpZmDJsJOwWh1u40g6hXqExWi9pe50woe
 /M36R/uhaOObNlHfASBH6F6rSscKMtKkd6nrBEajwnFEc+kjpvOHz5kvVkP2+JHlwa5Ml/ZlQ
 1nrO8/BDDjtszUYI22FmEPYvtsZTl39leoMp+3xPEC4BK64xrvee7COP9vnIamDHKOt5X4MqX
 VDe0TXOFGUQ665xNI1Tnym7x1Fy42xnKmIUMPbqLRLywX6HoYW5S065Mj3OzgTW1HlstSetOG
 cHyUhoqq8m02jOLRgkJ4rlqrocogpkyzsPd9fHqnJuKIzR4jD12pm331Mhmik2tMf+qiLmv3M
 ssKfRcJdl4d07scDBIKoXybY/2LrHWdyneQSIFz/jT4fsTgPFG/GQKUnkVek/1WJTQzFL6z+E
 jrzoNKKySgu/FJTmQz0zJ6r+Fn3GwlGqMPJV+r4kpDC/dKHRoHPdVIyI5XU5+tSA05lFsMDyh
 16r95sHorG/4tBjCDLLuqWRxHeb9SMWm0VzXTWcNuvKloZCbYPorzEvV5KJc1o9VrQQkBz/IY
 YyCwksLyDsKnX2xDcKOj7gNnbVSXWXOP7DPkL8vl0LOwiqBP0JdwdH0qi/NT+CrdrXRXlnJn+
 iW12no13EpqK/pzWQuBajjbVDayDqs80dlwJQyq/HPr2X7K2hz/fd5ZYlZrmCY
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ONGaBlD2Zb7L8lvhmwBWJUaZ0GFKxcp1Q
Content-Type: multipart/mixed; boundary="NH4V6d2RyMOa821zsO0OrRL6JXsYdpdBN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <36d9d5d6-323c-ebe6-5170-3b2555130bfd@gmx.com>
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
 <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
In-Reply-To: <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>

--NH4V6d2RyMOa821zsO0OrRL6JXsYdpdBN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/20 =E4=B8=8A=E5=8D=887:41, Anand Jain wrote:
>=20
>>> =C2=A0 But csum verification is a point in verification and its not a=

>>> =C2=A0 tree based transid verification. Which means if there is a sta=
le data
>>> =C2=A0 with matching csum we may return a junk data silently.
>>
>> Then the normal idea is to use stronger but slower csum in the first
>> place, to avoid the csum match case.
>=20
> =C2=A0This is just a general observational comment, its ok lets assume
> =C2=A0current point in csum verification works (as opposed to tree base=
d
> =C2=A0parent transid verification).
>=20
>>> =C2=A0 This problem is
>>> =C2=A0 easily reproducible when csum is disabled but not impossible t=
o
>>> achieve
>>> =C2=A0 when csum is not disabled as well.
>>
>> Under this case, it's the user to be blamed for the decision to disabl=
e
>> the csum in the first place.
>=20
> =C2=A0The point here is. The logic isn't aware of the write hole on the=
 other
> =C2=A0disk on which the metadata is not verified. I disagree that nocsu=
m or
> =C2=A0the user to be blamed.
>=20
>>
>>> A tree based integrity verification
>>> =C2=A0 is important for all data, which is missing.
>>> =C2=A0 =C2=A0 Fix:
>>> =C2=A0=C2=A0=C2=A0 In this RFC patch it proposes to use same disk fro=
m with the
>>> metadata
>>> =C2=A0 is read to read the data.
>>
>> The obvious problem I found is, the idea only works for RAID1/10.
>>
>> For striped profile it makes no sense, or even have a worse chance to
>> get stale data.
>>
>>
>> To me, the idea of using possible better mirror makes some sense, but
>> very profile limited.
>=20
> =C2=A0Yep. This problem and fix is only for the mirror based profiles
> =C2=A0such as raid1/raid10.

Then current implementation lacks such check.

Further more, data and metadata can lie in different chunks and have
different chunk types.

>=20
>>
>> Another idea I get inspired from the idea is, make it more generic so
>> that bad/stale device get a lower priority.
>=20
> =C2=A0When it comes to reading junk data, its not about the priority it=
s
> =C2=A0about the eliminating. When the problem is only few blocks, I am
> =C2=A0against making the whole disk as bad.
>=20
>> Although it suffers the same problem as I described.
>>
>> To make the point short, the use case looks very limited.
>=20
> =C2=A0It applies to raid1/raid10 with nodatacow (which implies nodatasu=
m).
> =C2=A0In my understanding that's not rare.
>=20
> =C2=A0Any comments on the fix offered here?

The implementation part is, is eb->read_mirror reliable?

E.g. if the data and the eb are in different chunks, and the stale
happens in the chunk of eb but not in the data chunk?

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>=20
>> Thanks,
>> Qu


--NH4V6d2RyMOa821zsO0OrRL6JXsYdpdBN--

--ONGaBlD2Zb7L8lvhmwBWJUaZ0GFKxcp1Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyRkRwACgkQwj2R86El
/qgrTgf/YN5SZDQHxsOsA5lesbId0ZdRlRBx1BzE3WwWHZZvuyJq8eYmSZSDQQnC
zwLPnskiP/7DmhuAqrp+KDHE+WsniAqlBTnMJoOcyqVGGsSH9xA3FuNvM5Z7ylJo
CL4/nRnDzJDl3PbfxrlnOUhtucckImOyLRdfzp9smHv4y/XajLRAWDMFdA4w3UOu
PUqtECf7w0/y+bVPtR0+C7flmqDq9EJfM8E+PwGY05PAaBsoeL7JwEfHOayNMVpc
w0QvDJzFh2XDdduWC7q/WOuWvcjXVXIUVkYWesDdxmmYMgA1RuM4rpS/DsopYEtx
/jXKUeGI250f6x+cOhjvalXTCU3EDQ==
=WD5/
-----END PGP SIGNATURE-----

--ONGaBlD2Zb7L8lvhmwBWJUaZ0GFKxcp1Q--
