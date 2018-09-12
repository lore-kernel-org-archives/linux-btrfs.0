Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:41573 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbeILFKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 01:10:45 -0400
Subject: Re: [PATCH 0/3] btrfs-progs: Detect compressed extent without csum
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180514065444.26313-1-wqu@suse.com>
 <20180911155803.GF2154@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c35be529-be80-7abd-1c2b-7ec0ab0589f1@gmx.com>
Date: Wed, 12 Sep 2018 08:08:53 +0800
MIME-Version: 1.0
In-Reply-To: <20180911155803.GF2154@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eMJwoRPSkJJ3E4DeWwNNInmKioElKxK4M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eMJwoRPSkJJ3E4DeWwNNInmKioElKxK4M
Content-Type: multipart/mixed; boundary="mtED1Nb623eaXmz3fDNajGwmbY2uaaWdt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c35be529-be80-7abd-1c2b-7ec0ab0589f1@gmx.com>
Subject: Re: [PATCH 0/3] btrfs-progs: Detect compressed extent without csum
References: <20180514065444.26313-1-wqu@suse.com>
 <20180911155803.GF2154@twin.jikos.cz>
In-Reply-To: <20180911155803.GF2154@twin.jikos.cz>

--mtED1Nb623eaXmz3fDNajGwmbY2uaaWdt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/11 =E4=B8=8B=E5=8D=8811:58, David Sterba wrote:
> On Mon, May 14, 2018 at 02:54:41PM +0800, Qu Wenruo wrote:
>> Patches can be fetch from github:
>> https://github.com/adam900710/btrfs-progs/tree/compress_nodatasum
>>
>> It's based on v4.16 stable branch.
>>
>> James Harvey from mail list reports a strange kernel panic, whichs sho=
w
>> obviously kernel memory corruption, while after btrfs decompression
>> failure.
>>
>> It turns out that, some compressed extent get corrupted on-disk, while=

>> the inode has NODATASUM set, there is no csum to prevent corrupted
>> mirror being used.
>>
>> Although the root cause should be buggy lzo implementation, it still
>> shows that btrfs is not following the behavior defined in btrfs(5):
>>
>>      Note
>>      If nodatacow or nodatasum are enabled, compression is disabled.
>>
>> So at least make btrfs check to detect such problem.
>>
>> Qu Wenruo (3):
>>   btrfs-progs: check/lowmem: Add checks for compressed extent without
>>     csum
>>   btrfs-progs: check/original: Add checks for compressed extent withou=
t
>>     csum
>>   btrfs-progs: fsck-tests: Add test case for detecting compressed exte=
nt
>>     without csum
>=20
> Sorry for late reply, can you please refresh the patches on top of a
> more recent progs? Thanks.

https://github.com/adam900710/btrfs-progs/tree/compress_nodatasum

Branch updated.

Rebased to v4.17.1 tag, with first patch commit message change:
"1) 0 or less than expected csum" -> "1) missing csum"

And re-numbering the test case of the last patch from 032 to 036.

Thanks,
Qu


--mtED1Nb623eaXmz3fDNajGwmbY2uaaWdt--

--eMJwoRPSkJJ3E4DeWwNNInmKioElKxK4M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluYWRYACgkQwj2R86El
/qhoCQf/RIvs+NKH6F8bPD630FUIunHLYFnxB33Kxx+I+ZFpZaCQH8s1Cobs8Z6h
pQNZr0ZU/mLvA1Fin3NKQA3ZWAbfCpYUKwu2uc7EaN3qp+Cj7XPqMuSCdFdaNw97
By782GB8zav7m22d4x8s8pi3nDQgMMn5k+F+4CgDD0rlV/TJ32c1k5R43VolfskT
e0IMA4zGwuis7fah99bDo+ivShRP0bGWJE8SZoK9Ze331T3jSWGN6v5G8hY8evgS
MEjSGzJbMvxyaKHPWkQ5hdQEVkFzUUKHii8aFLrtlTrSh5l5p8MCtMFQtftxHpMS
1ygzlaqWkrPRY37tUhSaMrDPn7Q3Zw==
=5+dX
-----END PGP SIGNATURE-----

--eMJwoRPSkJJ3E4DeWwNNInmKioElKxK4M--
