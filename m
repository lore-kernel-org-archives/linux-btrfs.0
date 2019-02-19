Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A47EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 426912146F
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 12:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfBSMeY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:34:24 -0500
Received: from mout.gmx.net ([212.227.17.21]:47709 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfBSMeY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 07:34:24 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MDn8s-1gpyTK1cdy-00HAoy; Tue, 19
 Feb 2019 13:34:21 +0100
Subject: Re: Broken filesystem
To:     Roderick Johnstone <rmj@ast.cam.ac.uk>, linux-btrfs@vger.kernel.org
References: <4d1be873-541a-96dd-0795-16a4fb2d4556@ast.cam.ac.uk>
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
Message-ID: <0d7012d4-0274-aa8b-1a49-9c269f3cfdf1@gmx.com>
Date:   Tue, 19 Feb 2019 20:34:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <4d1be873-541a-96dd-0795-16a4fb2d4556@ast.cam.ac.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rzVB5WEIBATLd8m2ArS1X4MjqE8P04jYC"
X-Provags-ID: V03:K1:dsi1NuCPNchw+y6W8jmssyzjkngbPdCE7h4LItIfPPsaCkjtGol
 FE26EJRx14Sq9QCR+75Y8DexjaYTs1yjf4MCIoNJsR0+qQh2+uGfO6r2t26hVVuGeVJIjuQ
 iAAWU1SpCbsiL06KITbZrN/V93ADuh09zivU7GterxRtd1tUfeXvfmI6INP92tZ7iL0zJCm
 K/tmAd7Bbr+24XJpK4BzA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:E98y++R1Oxs=:dt42CoO09YGf869lijY5Bf
 g+P2NgO1gnrlcsrbLET8flspcP2nQP3wJYOU53Mi875p3PWKdHWvUpOItyMfdWXyZgC9RVc3I
 hGXYYlw9YMBWFHyvp3wDkoQnyhkrDqugBhiOTK1xVB0TvhNEvEyWZgz7FEo5E0+11YhbM4n29
 t/FkWvDTvsR1ijSsOcmsUiJvJemfcq0FbzyzuB0gZwGKiDoXrWZN84Uk08sbvIVOtQS4t14n6
 ufxGQfSC9pyj1EULfu+H5bLG6xgvGapEpE6n3hsdhE1LGwYweoCoWHwLq0MgerzGzFHhINQLE
 TzVKPRbigwRMScytbQMS+5I2fULAVN6V83AnruMNuOXjvlwnAZ2ixo8mbP9vi65skv/bbMjfe
 JxwhTRT3kvV+2fLX1SK4l826bfAtktQz1cGNBH8uXdFAIPyJSv0gxI/bT8YRcAa9MvUG8buPn
 JEILH9aL3lNK+PYQFJrsUxyveP4iuX3/S1yP5MjgJqyQVjSwdDec27hJQOx54NSwgGqvvfS23
 OPlntXw9QwQMVzBiDLjb2bKbtyMoprQ+GxRiNjhMY7l6GEeUihqri8O8tHM9JG4qZyX6wFXQ0
 ckbezXdL1JfsB75QL3tKR42xKgsu49IDfrnYTeJBctTNRwSHEfgDYU9KU1gie+p13Dij/fPlZ
 qWjToXDKjubsmJbg7GGfZW/oLdRC5k54UFrDzvQfT9UmrHs6WHffdtzex2hC/LtLUg21dMawG
 0z5dZ9JneJp+HyqylAjiqEPITM9UMp+WUXm96LJXGwlpQwOTc5N1bRKbU3ECvAddG1BBqrs8D
 BqSrmQZ2S6v/pMCklE6wOyH/vhvnP9ST/x2e7hv8JBnOoCl+QeuTrfTbGmhhwzw1eoterKzbt
 CnCzwlgvlvHDEFX0zK2TYyu5EJOz1FxeJ7xRjZ1rmxBGJFc4Zhs8PbRyGh+5gK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rzVB5WEIBATLd8m2ArS1X4MjqE8P04jYC
Content-Type: multipart/mixed; boundary="oHtUw7iNluw38c0ct2mIVP9g2EWpVlu97";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Roderick Johnstone <rmj@ast.cam.ac.uk>, linux-btrfs@vger.kernel.org
Message-ID: <0d7012d4-0274-aa8b-1a49-9c269f3cfdf1@gmx.com>
Subject: Re: Broken filesystem
References: <4d1be873-541a-96dd-0795-16a4fb2d4556@ast.cam.ac.uk>
In-Reply-To: <4d1be873-541a-96dd-0795-16a4fb2d4556@ast.cam.ac.uk>

--oHtUw7iNluw38c0ct2mIVP9g2EWpVlu97
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/19 =E4=B8=8B=E5=8D=886:24, Roderick Johnstone wrote:
> Hi
>=20
> This is on Fedora 28:
>=20
> # uname -a
> Linux mysystem.mydomain 4.20.7-100.fc28.x86_64 #1 SMP Wed Feb 6 19:17:0=
9
> UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
>=20
> # btrfs --version
> btrfs-progs v4.17.1
>=20
> #=C2=A0=C2=A0 btrfs fi show
> Label: none=C2=A0 uuid: 56d0171a-440d-47ff-ad0f-f7f97df31f7b
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes use=
d 7.39TiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 9.10TiB used 7.50TiB path /dev/md2
>=20
>=20
> My btrfs filesystem is in a bad state after a partial disk failure on
> the md device (raid 6 array) the file system was on.
>=20
> One of the disks had bad blocks, but instead of being ejected from the
> array, the array hung up.

I'm a little interested why RAID6 hung up.

> After rebooting to regain access and remove
> the bad disk I am in the following situation:
>=20
> # mount -t btrfs -o compress-force=3Dzlib,noatime /dev/md2 /mnt/rmj
> mount: /mnt/rmj: wrong fs type, bad option, bad superblock on /dev/md2,=

> missing codepage or helper program, or other error.
> # dmesg
> ...
> =C2=A0 264.527647] BTRFS info (device md2): force zlib compression, lev=
el 3
> [=C2=A0 264.955360] BTRFS error (device md2): parent transid verify fai=
led on
> 5568287064064 wanted 254988 found 94122

It's 99% some extent tree blocks get corrupted.

> [=C2=A0 264.964273] BTRFS error (device md2): open_ctree failed
>=20
> I can mount and access the filesystem with the usebackuproot option:
>=20
> # mount -t btrfs -o usebackuproot,compress-force=3Dzlib,noatime /dev/md=
2
> /mnt/rmj
> [=C2=A0 307.542761] BTRFS info (device md2): trying to use backup root =
at
> mount time
> [=C2=A0 307.542768] BTRFS info (device md2): force zlib compression, le=
vel 3
> [=C2=A0 307.570897] BTRFS error (device md2): parent transid verify fai=
led on
> 5568287064064 wanted 254988 found 94122
> [=C2=A0 307.570979] BTRFS error (device md2): parent transid verify fai=
led on
> 5568287064064 wanted 254988 found 94122
> [=C2=A0 431.167149] BTRFS info (device md2): checking UUID tree
>=20
> But later after a umount there are these messages.
>=20
> # umount /mnt/rmj
> 2205.778998] BTRFS error (device md2): parent transid verify failed on
> 5568276393984 wanted 254986 found 94117
> [ 2205.779008] BTRFS: error (device md2) in __btrfs_free_extent:6831:
> errno=3D-5 IO failure
> [ 2205.779082] BTRFS info (device md2): forced readonly
> [ 2205.779087] BTRFS: error (device md2) in btrfs_run_delayed_refs:2978=
:
> errno=3D-5 IO failure
> [ 2205.779192] BTRFS warning (device md2): btrfs_uuid_scan_kthread
> failed -30
Of course it's extent tree corrupted.

>=20
> and a subsequent mount without the userbackuproot fails in the same way=

> as before.
>=20
> I have a copy of the important directories, but would like to be able t=
o
> repair the filesystem if possible,

You could mostly salvage the data, either use 'usebackuproot' mount
option + RO mount or btrfs-restore.

For full rw recovery, I don't think there is a good tool right now.
Extent tree repair is pretty trikcy, under most case, the only method is
--init-extent-tree, but that functionality isn't tried by many users.
And it only makes sense if all other trees are OK.

So in short, RW recovery is near impossible.

>=20
> Any advise around repairing the filesystem would be appreciated.

It's better to salvage your data first and if you like adventure, try
--init-extent-tree.
If not, just rebuild the array.

Thanks,
Qu

>=20
> Thanks.
>=20
> Roderick Johnstone


--oHtUw7iNluw38c0ct2mIVP9g2EWpVlu97--

--rzVB5WEIBATLd8m2ArS1X4MjqE8P04jYC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxr98kACgkQwj2R86El
/qjTWgf6A3vA+wNuChm7YLY4bsX/+gieIVr0P9e/3GE/XktOrENJdRCVVe72U/W7
53DXzcl8S7BesRBJ45g2hp3zLkLwQLw8ISUSubFTwHMfE7Avb0ehbzpDG1BDchhI
RPHubokA2ernBY9CcwqdiGIldnan1Gy01SlZNm/afJTFCkvUbQdpNXrP62tjuuNW
Ljj03CCLEuqI/sMTDo8snXHsL80Mpu19lJb9PQseWKcbnXlvNAyXOuJSAgTm6UZv
d8BIi9ku5t+5+1GFCJ3WLowqLbpWcmBYRwcHCPCF8UBmYXHfh0aON02AUXbh+m2L
CGRLpmwUuXZKWzca43fXoC46mn8QIA==
=ixQa
-----END PGP SIGNATURE-----

--rzVB5WEIBATLd8m2ArS1X4MjqE8P04jYC--
