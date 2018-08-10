Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56259 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbeHJQeq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 12:34:46 -0400
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20180809180450.5091-1-naota@elisp.net>
 <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>
 <af160fd3-89dd-f54e-a1df-2a3cbc65a28d@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8ba6c115-bada-19f9-736e-e88859a46972@gmx.com>
Date: Fri, 10 Aug 2018 22:04:35 +0800
MIME-Version: 1.0
In-Reply-To: <af160fd3-89dd-f54e-a1df-2a3cbc65a28d@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nsz1QAuj6AvmvwGU6P0gNz2llwlCXgrNK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nsz1QAuj6AvmvwGU6P0gNz2llwlCXgrNK
Content-Type: multipart/mixed; boundary="1Go3PHdWwckzaof99Rd2Bp2HmPJRSeeoG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <8ba6c115-bada-19f9-736e-e88859a46972@gmx.com>
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
References: <20180809180450.5091-1-naota@elisp.net>
 <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>
 <af160fd3-89dd-f54e-a1df-2a3cbc65a28d@mendix.com>
In-Reply-To: <af160fd3-89dd-f54e-a1df-2a3cbc65a28d@mendix.com>

--1Go3PHdWwckzaof99Rd2Bp2HmPJRSeeoG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/10/18 9:32 PM, Hans van Kranenburg wrote:
> On 08/10/2018 09:28 AM, Qu Wenruo wrote:
>>
>>
>> On 8/10/18 2:04 AM, Naohiro Aota wrote:
>>> This series adds zoned block device support to btrfs.
>>>
>>> [...]
>>
>> And this is the patch modifying extent allocator.
>>
>> Despite that, the support zoned storage looks pretty interesting and
>> have something in common with planned priority-aware extent allocator.=

>=20
> Priority-aware allocator? Is someone actually working on that, or is it=

> planned like everything is 'planned' (i.e. nice idea, and might happen
> or might as well not happen ever, SIYH)?

I'm working on this, although it will take some time.

Although it's originally designed to solve the problem where some empty
block groups won't be freed due to pinned bytes.

Thanks,
Qu
>=20


--1Go3PHdWwckzaof99Rd2Bp2HmPJRSeeoG--

--nsz1QAuj6AvmvwGU6P0gNz2llwlCXgrNK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlttm3MACgkQwj2R86El
/qgNGAf/W1TzbF5idM/z3LJLC4fsSsZKSlZ88LhjV9rBIT/+5FBz0ZY0LxC6Qjg7
GXsXOHfq7csxB/qeOAURrSVSNAUymSq/A23RjB48o8w46U2dowYNJBynkN4aFyJk
05a4DyYDFPYthZ0z/pqc/Q24oeZaifwwKULet0R9lI191cRw1HNvZRLBfFAdvtUY
FHDDo22MaOeDIi/YEgBpWug+HOYrWjc3eKwisufMYsw6kJ5mgFtZZfPtS9ii2w06
j/yTiRnqlUWtLRdTrLgSnrpyigVcFixN6gbk24AFaqa93kZ17Ps39w+rVRKQzdQO
giHS8ozfaU8jikfhFG+lnO2c2H9vHA==
=xgbR
-----END PGP SIGNATURE-----

--nsz1QAuj6AvmvwGU6P0gNz2llwlCXgrNK--
