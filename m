Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B8BC64EB4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 23:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C66320660
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 23:57:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C66320660
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbeLALIq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 1 Dec 2018 06:08:46 -0500
Received: from mout.gmx.net ([212.227.17.20]:33987 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbeLALIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Dec 2018 06:08:44 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LnPnu-1hAC260YL0-00hb3x; Sat, 01
 Dec 2018 00:57:32 +0100
Subject: Re: Need help with potential ~45TB dataloss
To:     Patrick Dijkgraaf <bolderbast@duckstad.net>,
        linux-btrfs@vger.kernel.org
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
Date:   Sat, 1 Dec 2018 07:57:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f20gQiyW3jc2aV6JIzuRKVBcQ8StNwWtl"
X-Provags-ID: V03:K1:VLX0iPDhAowgb6yGBDOSjwpWotgj/GT6px9KLpa35XxHiGB9NPZ
 40tMOJwC609UU4EI7UaERUv3p8XL9CwFfbuYfbQk9pNlSymDkD0UewoIx7JQnpKjjZdfPPQ
 bOOoul0z/hqsHLVfIe0yevh+vpBdS7GHGqNdkOuY1uAV+HNB81H3PfDa3pi6TTZvRna9Fa1
 0DJjJHLKVIw8AYWpLP81A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:a8idX++Y8RM=:bKUkkvk1k1PUc1Ka+2xuQo
 soKqWIEPAG7QrV6fdrODQSrcABQIrq+kI6pmqV1opZcbKF9PsoVoLz8T/cfc15S/YqKxLryin
 YGP40u9514SsP4fP/dj0Xanc/D1KheTSpuYaM1cV8s3Za99Bjx99bLlCEqDDi3548+v/BDmq7
 HaaClEZ13oMsHHgA9LZ6+TEKUNRQDdfb53+RXu2FZaSCq4GZiJs7qJaC4IP9SqBkPVC6Ob4+b
 GJ5fR/naJyPlA9ox3VLVRMnmqmw0XhMXdXyN4l3F5+lnsf20tsPvfr6hkai1TR+hB6UVDqRFi
 LaQkUsePEwXCBUs5OqAXqgkHheGy//fRXHfh4BWfzycL0wPPMSQ8OL6VMVW0Spb5YCuX/DaIE
 1Gb0upKC7DchZv9UDL3ChlyCVBpI0++lW/CcUAvG7XoGzJZ6WNEk0H/MDQhiA9G0MwgsNaYpx
 lCpILhMZkx/Oq3AEKBbPTLrfG3Dj/UwTb5g0caeylw3MsDQ/eQ4ovnF3iQLA49ENz0dfP2vwj
 2gTIRl4jZQeSHh6Qd6EU0ndoSPo9xJXYrCt+8/7h0bP9Oco6WqelESqGInp6O9mO6aOUbYbA5
 m5TgiA1fCe+BVfTshr98oUDSBTUMpS9j1JgLAZzY1bTspFNYlDxeufFuYRZnTPxS8pGV+31bk
 x2HPwuVZkSHirRHfoGrOIdtmkZNWJQuDsgUlUZ9t3ElkVzftz94aVR+XfSs8mxsVwe9L9FDKW
 iVhBDGraP7yE5mBoX/1h2JYQY0pULqIYsb70cRJeVPZxy/Odm+RiazZW/tF8Vdz4XN/5doLo9
 xPcULn87v6cpBBF1YB/Tiydr+MBoN9ar/997nRgBnIBtxBcungfa7cy4Pfl4w4W2KnSdCW7D0
 GGBTmlD+UsHSf2kDegaVqq+GzvosX9mAKDU/cbx4wH15pBhMgn4lY7kb99X0gv
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f20gQiyW3jc2aV6JIzuRKVBcQ8StNwWtl
Content-Type: multipart/mixed; boundary="gl0j4BsLgaTrkubVhKhk5x9j6PtXeXIgz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Patrick Dijkgraaf <bolderbast@duckstad.net>, linux-btrfs@vger.kernel.org
Message-ID: <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com>
Subject: Re: Need help with potential ~45TB dataloss
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
In-Reply-To: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>

--gl0j4BsLgaTrkubVhKhk5x9j6PtXeXIgz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/30 =E4=B8=8B=E5=8D=889:53, Patrick Dijkgraaf wrote:
> Hi all,
>=20
> I have been a happy BTRFS user for quite some time. But now I'm facing
> a potential ~45TB dataloss... :-(
> I hope someone can help!
>=20
> I have Server A and Server B. Both having a 20-devices BTRFS RAID6
> filesystem. Because of known RAID5/6 risks, Server B was a backup of
> Server A.
> After applying updates to server B and reboot, the FS would not mount
> anymore. Because it was "just" a backup. I decided to recreate the FS
> and perform a new backup. Later, I discovered that the FS was not
> broken, but I faced this issue:=20
> https://patchwork.kernel.org/patch/10694997/

Sorry for the inconvenience.

I didn't realize the max_chunk_size limit isn't reliable at that timing.

>=20
> Anyway, the FS was already recreated, so I needed to do a new backup.
> During the backup (using rsync -vah), Server A (the source) encountered=

> an I/O error and my rsync failed. In an attempt to "quick fix" the
> issue, I rebooted Server A after which the FS would not mount anymore.

Did you have any dmesg about that IO error?

And how is the reboot scheduled? Forced power off or normal reboot comman=
d?

>=20
> I documented what I have tried, below. I have not yet tried anything
> except what is shown, because I am afraid of causing more harm to
> the FS.

Pretty clever, no btrfs check --repair is a pretty good move.

> I hope somebody here can give me advice on how to (hopefully)
> retrieve my data...
>=20
> Thanks in advance!
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> [root@cornelis ~]# btrfs fi show
> Label: 'cornelis-btrfs'  uuid: ac643516-670e-40f3-aa4c-f329fc3795fd
> 	Total devices 1 FS bytes used 463.92GiB
> 	devid    1 size 800.00GiB used 493.02GiB path
> /dev/mapper/cornelis-cornelis--btrfs
>=20
> Label: 'data'  uuid: 4c66fa8b-8fc6-4bba-9d83-02a2a1d69ad5
> 	Total devices 20 FS bytes used 44.85TiB
> 	devid    1 size 3.64TiB used 3.64TiB path /dev/sdn2
> 	devid    2 size 3.64TiB used 3.64TiB path /dev/sdp2
> 	devid    3 size 3.64TiB used 3.64TiB path /dev/sdu2
> 	devid    4 size 3.64TiB used 3.64TiB path /dev/sdx2
> 	devid    5 size 3.64TiB used 3.64TiB path /dev/sdh2
> 	devid    6 size 3.64TiB used 3.64TiB path /dev/sdg2
> 	devid    7 size 3.64TiB used 3.64TiB path /dev/sdm2
> 	devid    8 size 3.64TiB used 3.64TiB path /dev/sdw2
> 	devid    9 size 3.64TiB used 3.64TiB path /dev/sdj2
> 	devid   10 size 3.64TiB used 3.64TiB path /dev/sdt2
> 	devid   11 size 3.64TiB used 3.64TiB path /dev/sdk2
> 	devid   12 size 3.64TiB used 3.64TiB path /dev/sdq2
> 	devid   13 size 3.64TiB used 3.64TiB path /dev/sds2
> 	devid   14 size 3.64TiB used 3.64TiB path /dev/sdf2
> 	devid   15 size 7.28TiB used 588.80GiB path /dev/sdr2
> 	devid   16 size 7.28TiB used 588.80GiB path /dev/sdo2
> 	devid   17 size 7.28TiB used 588.80GiB path /dev/sdv2
> 	devid   18 size 7.28TiB used 588.80GiB path /dev/sdi2
> 	devid   19 size 7.28TiB used 588.80GiB path /dev/sdl2
> 	devid   20 size 7.28TiB used 588.80GiB path /dev/sde2
>=20
> [root@cornelis ~]# mount /dev/sdn2 /mnt/data
> mount: /mnt/data: wrong fs type, bad option, bad superblock on
> /dev/sdn2, missing codepage or helper program, or other error.

What is the dmesg of the mount failure?

And have you tried -o ro,degraded ?

>=20
> [root@cornelis ~]# btrfs check /dev/sdn2
> Opening filesystem to check...
> parent transid verify failed on 46451963543552 wanted 114401 found
> 114173
> parent transid verify failed on 46451963543552 wanted 114401 found
> 114173
> checksum verify failed on 46451963543552 found A8F2A769 wanted 4C111ADF=

> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4=

> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4=

> bad tree block 46451963543552, bytenr mismatch, want=3D46451963543552,
> have=3D75208089814272
> Couldn't read tree root

Would you please also paste the output of "btrfs ins dump-super /dev/sdn2=
" ?

It looks like your tree root (or at least some tree root nodes/leaves
get corrupted)

> ERROR: cannot open file system

And since it's your tree root corrupted, you could also try
"btrfs-find-root <device>" to try to get a good old copy of your tree roo=
t.

But I suspect the corruption happens before you noticed, thus the old
tree root may not help much.

Also, the output of "btrfs ins dump-tree -t root <device>" will help.

Thanks,
Qu
>=20
> [root@cornelis ~]# btrfs restore /dev/sdn2 /mnt/data/
> parent transid verify failed on 46451963543552 wanted 114401 found
> 114173
> parent transid verify failed on 46451963543552 wanted 114401 found
> 114173
> checksum verify failed on 46451963543552 found A8F2A769 wanted 4C111ADF=

> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4=

> checksum verify failed on 46451963543552 found 32153BE8 wanted 8B07ABE4=

> bad tree block 46451963543552, bytenr mismatch, want=3D46451963543552,
> have=3D75208089814272
> Couldn't read tree root
> Could not open root, trying backup super
> warning, device 14 is missing
> warning, device 13 is missing
> warning, device 12 is missing
> warning, device 11 is missing
> warning, device 10 is missing
> warning, device 9 is missing
> warning, device 8 is missing
> warning, device 7 is missing
> warning, device 6 is missing
> warning, device 5 is missing
> warning, device 4 is missing
> warning, device 3 is missing
> warning, device 2 is missing
> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
> bad tree block 22085632, bytenr mismatch, want=3D22085632,
> have=3D1147797504
> ERROR: cannot read chunk root
> Could not open root, trying backup super
> warning, device 14 is missing
> warning, device 13 is missing
> warning, device 12 is missing
> warning, device 11 is missing
> warning, device 10 is missing
> warning, device 9 is missing
> warning, device 8 is missing
> warning, device 7 is missing
> warning, device 6 is missing
> warning, device 5 is missing
> warning, device 4 is missing
> warning, device 3 is missing
> warning, device 2 is missing
> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
> checksum verify failed on 22085632 found 5630EA32 wanted 1AA6FFF0
> bad tree block 22085632, bytenr mismatch, want=3D22085632,
> have=3D1147797504
> ERROR: cannot read chunk root
> Could not open root, trying backup super
>=20
> [root@cornelis ~]# uname -r
> 4.18.16-arch1-1-ARCH
>=20
> [root@cornelis ~]# btrfs --version
> btrfs-progs v4.19
>=20


--gl0j4BsLgaTrkubVhKhk5x9j6PtXeXIgz--

--f20gQiyW3jc2aV6JIzuRKVBcQ8StNwWtl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwBzmgACgkQwj2R86El
/qicWwf/aZzIUPom86eXq5SJBrbe6pxXC6BkeTS0sgsJkirJ5T3kI0KFRNigX6Hv
Eu1nWPtq/0Hc1Qzf0KrkaeYtNP2W45EEiXUYhq6a3RRQ4CFrQ0W1GB5lT2L+rG0e
MFTtpoJvehYha8d5a6rWHpjJ+bd+hfE5vcCewdpmyuYfcr3gtNj22Dk+WZaxA41T
kwWVYoRDX9421b3r8/2ZXqtYpVmXRZGvIae7piY6br/vn33oh2Yyl/1RaPRSN3dZ
2UAuwVB8R5nzPjH71TcgjgsF3slxkFGr9QTfmrPijNC5F+NawI5teCqXP93GBnSl
+KUPKpKOBbCM1ZRPGXdipOHoagXwkA==
=0YTd
-----END PGP SIGNATURE-----

--f20gQiyW3jc2aV6JIzuRKVBcQ8StNwWtl--
