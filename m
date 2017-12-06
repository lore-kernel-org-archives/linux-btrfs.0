Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50788 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752812AbdLFALn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 19:11:43 -0500
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
To: bo.li.liu@oracle.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
 <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
 <20171205180925.GO3553@twin.jikos.cz>
 <20171205225501.GC18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2958e696-4671-73a4-5940-2b9a89627150@gmx.com>
Date: Wed, 6 Dec 2017 08:11:30 +0800
MIME-Version: 1.0
In-Reply-To: <20171205225501.GC18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OMJFCgpg7SWHmwaj9hCb3WGjHv48INKiQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OMJFCgpg7SWHmwaj9hCb3WGjHv48INKiQ
Content-Type: multipart/mixed; boundary="8dpWFVcAja9I07B6ITtMppErmgeNmg4w1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: bo.li.liu@oracle.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <2958e696-4671-73a4-5940-2b9a89627150@gmx.com>
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
 <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
 <20171205180925.GO3553@twin.jikos.cz>
 <20171205225501.GC18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
In-Reply-To: <20171205225501.GC18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>

--8dpWFVcAja9I07B6ITtMppErmgeNmg4w1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 06:55, Liu Bo wrote:
> On Tue, Dec 05, 2017 at 07:09:25PM +0100, David Sterba wrote:
>> On Tue, Dec 05, 2017 at 04:07:35PM +0800, Qu Wenruo wrote:
>>>> @@ -2166,11 +2166,21 @@ int raid56_parity_recover(struct btrfs_fs_in=
fo *fs_info, struct bio *bio,
>>>>  	}
>>>> =20
>>>>  	/*
>>>> -	 * reconstruct from the q stripe if they are
>>>> -	 * asking for mirror 3
>>>> +	 * Loop retry:
>>>> +	 * for 'mirror =3D=3D 2', reconstruct from all other stripes.
>>>
>>> What about using macro to makes the reassemble method more human read=
able?
>>
>> Yeah, that's definetelly needed and should be based on
>> BTRFS_MAX_MIRRORS, not just hardcoded to 3.
>=20
> OK.
>=20
> In case of raid5/6, BTRFS_MAX_MIRRORS is an abused name, it's more a
> raid1/10 concept, either BTRFS_RAID56_FULL_REBUILD or
> BTRFS_RAID56_FULL_CHK is better to me, which one do you guys like?

For mirror > 2 case, the mirror_num is no longer a single indicator, but
a ranged iterator for later rebuild retries.

Something like set_raid_fail_from_mirror_num() seems better to me.

Thanks,
Qu

>=20
> Thanks,
>=20
> -liubo
>=20


--8dpWFVcAja9I07B6ITtMppErmgeNmg4w1--

--OMJFCgpg7SWHmwaj9hCb3WGjHv48INKiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlonNbIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhXJgf/e8bAoJUoPqd9J1jWP0mTDsxB
gZz9/qYDS+S7WB1UuSBtGvrRvaKtIEKb5Xcrew5HAdr/vRdlAcp3bITZspsAS4DL
JKqMMuGR0HZ9qU9FiZT9mf6gG1EZpcvvbm0ywlucIMPYLkZGk+33pWm5Kvrm7N6Q
5iiJJVbjqTCPKmwYrMgVw9MbOkjPSZmwtlmsiiN4ngsYvmyL9Kj9wR30LxKTs9jC
SDQwd5De/k9CEmQecNNOLFKGxp6gY+pkslVROgfFdyJxiGpUdAi9ZXAfs0iNWtBM
iOMWHyzqd04hbyIYAHfU7ynDMCa66dnTJcItB63izJCXbX1/GyJjahztGsLTLw==
=A8J2
-----END PGP SIGNATURE-----

--OMJFCgpg7SWHmwaj9hCb3WGjHv48INKiQ--
