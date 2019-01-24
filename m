Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2CBC282C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 03:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92D1C218A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 03:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfAXDFE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 22:05:04 -0500
Received: from mout.gmx.net ([212.227.15.19]:39435 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfAXDFD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 22:05:03 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M4WNA-1h7cdc2sfc-00yfIE; Thu, 24
 Jan 2019 04:04:53 +0100
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190118021956.22949-1-wqu@suse.com>
 <20190123171635.GU2900@twin.jikos.cz>
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
Message-ID: <0feee626-6d73-ba40-2e31-112ae5337f8d@gmx.com>
Date:   Thu, 24 Jan 2019 11:04:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190123171635.GU2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eeEWT8LNFHgmGzG0nXZPyD59BZMupgSAp"
X-Provags-ID: V03:K1:h7iHqBMT2MGB9oifo7DDI5c1Lyw0bOhwwKtNCWqZcKNHz6A9SuY
 H7t1pI1DBcYp5S18fMAWoyx45Qqq6uqaDa99JJp/I6dZIuO+IU5HBCdcuewRnriP6eYFWir
 ytMgzT5nCmYA2XVTwmrvMxplIv5fKGyLqll0lfCeFDNKN7yoZZ35QdcolNrqAXSI59OOcOi
 ul/u8vNXZslyBW5lNWSYQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dow29NZvwPI=:uH25TmGBAHmF4yCIcQ63sN
 GRK7Q4w2Y+QtYqinI9eteTwRfXdpxAStgGMAxcZfwCIybd2+eaWb6eoo6VEG8WzPrCwfFBXEN
 idgXUuyNNaJV1HoP/QeFNevRcwWcjVVfepOi6n3B5j/bRQecxnvgBubPra4R2MP7sL1XMLmAT
 c38nAH9M13OR36uyLca+bOCge+0CWkHHTzzS2CvwGmEt8lp7I104S7WhQaSx1iXI731Dy46gm
 u5W13W2OccfR/jX1QE6bExsVZAyQyJl16Tw8Hxymw08BpH8ymdE5+N/Wf5AO6EAwqJRvAoEBR
 FyMOWw0B4SondmuLjAojlW5EfrKZ02M7O5ZkWoHCEZIhQyKuClRy2WOczvYDjNHmklB2q1nV+
 eRa5R7FomUXMKdn2VeRRQ5gggdyNTF4qq024uWjRpqY3glf+oSaJV6amxKprtgbsHi2oHRczM
 IqWSZiI55UBDUHykSyeVq/v10yclDjfy8QVH5FZfz3cfiRGJot/5R33Q/MFZUjvo1u54gqI9r
 xpMc/ZU8izx6QUuCEIsSCk7DyzQEBcR3GUYvaARX5QB0Vc+FFVN9t0nocQejSg0zbgniswJ77
 YCjC3QLIOY//EfHs0Y2hNECuE46OwOk+oogVzVHpegiCNYHnxlimGu2bPkn0nQ0V0UJ+ZC/90
 HPzK230c4AxPpME0rBVmvajmwec64xKmVIOORjeUq/P7WhS/UMN7rhHyJsrLe1thVBkQiY8VN
 JDWV3OP1460ZoYkMUGIxXzflIZ0n4zmKarjatQnsTpZ2Ab3Jip7csZWAmC3eNF+Ee6e//JFeA
 lS19uqeKxMPyPPCEJyk+vXxy7kVc+LXiqj+uXxNwjzgh/iPYACdiDAnzZT1Ftfy/gYNwjjAiq
 Lm5Wc6BCwzzhxLRkROr+zVpM+tTPv3Ci+2BbNg275JWtRzWcD4NXzv5gowhrYO
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eeEWT8LNFHgmGzG0nXZPyD59BZMupgSAp
Content-Type: multipart/mixed; boundary="Q9ohf4skP8RTteGO6oadepMmPLjbnMh2A";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <0feee626-6d73-ba40-2e31-112ae5337f8d@gmx.com>
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
References: <20190118021956.22949-1-wqu@suse.com>
 <20190123171635.GU2900@twin.jikos.cz>
In-Reply-To: <20190123171635.GU2900@twin.jikos.cz>

--Q9ohf4skP8RTteGO6oadepMmPLjbnMh2A
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/24 =E4=B8=8A=E5=8D=881:16, David Sterba wrote:
> On Fri, Jan 18, 2019 at 10:19:51AM +0800, Qu Wenruo wrote:
>> Patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/write_time_tree_checker
>> Which is based on v5.0-rc1 tag.
>>
>> This patchset has the following two features:
>> - Tree block validation output enhancement
>>   * Output validation failure timing (write time or read time)
>>   * Always output tree block level/key mismatch error message
>>     This part is already submitted and reviewed.
>>
>> - Write time tree block validation check
>>   To catch memory corruption either from hardware or kernel.
>>   Example output would be:
>>
>>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D13506=
30375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (1=
714119868416 169 0)
>>     BTRFS error (device dm-3): write time tree block corruption detect=
ed
>>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D13506=
30375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (1=
714119868416 169 0)
>>     BTRFS error (device dm-3): write time tree block corruption detect=
ed
>>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=
=3D-5 IO failure (Error while writing out transaction)
>>     BTRFS info (device dm-3): forced readonly
>>     BTRFS warning (device dm-3): Skipping commit of aborted transactio=
n.
>>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=3D-5=
 IO failure
>>     BTRFS info (device dm-3): delayed_refs has NO entry
>=20
> Two tests complain:

Any info about the reproducibility and VM/hardware info? Especially for
the VM ram size.

I have looped these two test cases for 32 times, still no triggering.

Thanks,
Qu

>=20
> btrfs/139
> [ 7064.718943] run fstests btrfs/139 at 2019-01-23 15:56:29
> [ 7065.345503] BTRFS info (device vda): disk space caching is enabled
> [ 7065.347577] BTRFS info (device vda): has skinny extents
> [ 7065.666692] BTRFS: device fsid bc4c99e7-906a-44fd-b797-66eb7c9592d7 =
devid 1 transid 5 /dev/vdb
> [ 7065.684618] BTRFS info (device vdb): disk space caching is enabled
> [ 7065.687310] BTRFS info (device vdb): has skinny extents
> [ 7065.688887] BTRFS info (device vdb): flagging fs with big metadata f=
eature
> [ 7065.693432] BTRFS info (device vdb): checking UUID tree
> [ 7065.743019] BTRFS warning (device vdb): qgroup rescan is already in =
progress
> [ 7065.746433] BTRFS info (device vdb): qgroup scan completed (inconsis=
tency flag cleared)
> [ 7075.359872] BTRFS critical (device vdb): corrupt leaf: root=3D7 bloc=
k=3D31653888 slot=3D0, invalid nritems, have 0 should not be 0 for non-ro=
ot leaf
> [ 7075.363155] BTRFS error (device vdb): write time tree block corrupti=
on detected
> [ 7077.578167] BTRFS: error (device vdb) in btrfs_commit_transaction:22=
20: errno=3D-5 IO failure (Error while writing out transaction)
> [ 7077.583615] BTRFS info (device vdb): forced readonly
> [ 7077.585797] BTRFS warning (device vdb): Skipping commit of aborted t=
ransaction.
> [ 7077.588813] BTRFS: error (device vdb) in cleanup_transaction:1839: e=
rrno=3D-5 IO failure
>=20
> generic/344
>=20
> [11246.567119] run fstests generic/344 at 2019-01-23 17:06:11
> [11246.652295] BTRFS info (device vda): disk space caching is enabled
> [11246.654434] BTRFS info (device vda): has skinny extents
> [11246.730069] BTRFS: device fsid b82bc1cd-b380-4eff-a40a-1924c3bf0580 =
devid 1 transid 5 /dev/vdb
> [11246.740955] BTRFS info (device vdb): disk space caching is enabled
> [11246.742694] BTRFS info (device vdb): has skinny extents
> [11246.744173] BTRFS info (device vdb): flagging fs with big metadata f=
eature
> [11246.772934] BTRFS info (device vdb): checking UUID tree
> [11300.857850] BTRFS critical (device vdb): corrupt leaf: root=3D7 bloc=
k=3D31080448 slot=3D0, invalid nritems, have 0 should not be 0 for non-ro=
ot leaf
> [11300.861739] BTRFS error (device vdb): write time tree block corrupti=
on detected
> [11300.864232] BTRFS: error (device vdb) in btrfs_commit_transaction:22=
20: errno=3D-5 IO failure (Error while writing out transaction)
> [11300.867704] BTRFS info (device vdb): forced readonly
> [11300.869355] BTRFS warning (device vdb): Skipping commit of aborted t=
ransaction.
> [11300.871857] BTRFS: error (device vdb) in cleanup_transaction:1839: e=
rrno=3D-5 IO failure
> [11300.874292] BTRFS info (device vdb): delayed_refs has NO entry
> [11301.261978] BTRFS info (device vdb): disk space caching is enabled
> [11301.264639] BTRFS info (device vdb): has skinny extents
> [11301.266467] BTRFS info (device vdb): flagging fs with big metadata f=
eature
> [11301.299713] BTRFS info (device vdb): checking UUID tree
>  [17:07:06]- output mismatch (see /tmp/fstests/results//generic/344.out=
=2Ebad)
>     --- tests/generic/344.out   2018-04-12 16:57:00.652225551 +0000
>     +++ /tmp/fstests/results//generic/344.out.bad       2019-01-23 17:0=
7:06.424000000 +0000
>     @@ -17,6 +17,7 @@
>      INFO: thread 0 created
>      INFO: thread 1 created
>      INFO: 0 error(s) detected
>     +unlink(): Read-only file system
>=20
>      INFO: zero-filled test...
>      INFO: sz =3D 268435456
>     ...
>     (Run 'diff -u /tmp/fstests/tests/generic/344.out /tmp/fstests/resul=
ts//generic/344.out.bad'  to see the entire diff)
>=20


--Q9ohf4skP8RTteGO6oadepMmPLjbnMh2A--

--eeEWT8LNFHgmGzG0nXZPyD59BZMupgSAp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxJK08ACgkQwj2R86El
/qhUrAf/SYorXYfe2HJJdnj0f+fFel/JvUPPZjIXiGpiCGHVWX+AnT6rYFHlPfMb
Gqe9R7Tfeg1YEvLNQ4kVvntghx8FXV4KUDwr4t46k0UzZKL90uu/A6CP4b2Z2jpL
t2xCpNmKHGrXumU2pHwM20AWcsKhzCoWMahOgV/Aju+rLdpmu07aysUgwFgNT94w
kmrhluS+UUbOditKMb5NxaTu/Fyf2/GCdarIg7QO0Ct+g4vX1b0J9tCBnY6L4NoL
c+ztNQYcDj8RisQUvIDx/P9ePLzGdR1WJD2/QIBRAacrxlVJUuPzeHcsnACExoQl
rdF57aregYQivavByzpCmycvLGN8qw==
=/enR
-----END PGP SIGNATURE-----

--eeEWT8LNFHgmGzG0nXZPyD59BZMupgSAp--
