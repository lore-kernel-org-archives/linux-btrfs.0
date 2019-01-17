Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCF2C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 00:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E2A20657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 00:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfAQAvF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 19:51:05 -0500
Received: from mout.gmx.net ([212.227.17.21]:47445 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbfAQAvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 19:51:05 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHbpA-1gge6q35w4-003PC0; Thu, 17
 Jan 2019 01:51:01 +0100
Subject: Re: issue mounting volume
To:     Christian Schneider <christian@ch-sc.de>,
        linux-btrfs@vger.kernel.org
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
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
Message-ID: <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
Date:   Thu, 17 Jan 2019 08:50:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vd1haEZFibRRQ35YDVh4TuW2WaoY14OvZ"
X-Provags-ID: V03:K1:uMGNi0q8tnfTb6oaXMnmXWLZH5/ZdP/D41bK0ceMtIQsuqNtyAi
 Day//4lw9IrT737Npms0FeemhopGruqJg20vMmtlGtXxvB6u5g+fn+mHDgjyURGAl7TQ4QE
 VBsMQVphrmfGaneUG+xF6TiVtkP8DG67ss8tQW2EFCRwSS23XCQR9+/fgi0b5/M5POlB2f6
 C3S8GxgTk+xxPh/oyRtYA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:f63nIc4r2Rs=:pd1PYp2B214yJac9pKv8Sm
 M5SQvFGSoZZnFFwzflisITbox2Hy/9kvmeFJ9jKl2Rk2gLedGGxGf2chXzA3CI/VIVqdwQeST
 mtnav5BdivRAtYHLeEOUTouMahj/kZ1rUifUBHK/dt0lSwg+V7crhbLTijCF7DTa5Z8rlwaj7
 +uoJeKLR3pBM8Sz3lVTteu3mFHEqW7Dzxt40EfzXNfCqdfd+iRjdGkBZxBJu8tf8FsH8p5Vq/
 AGsqK9qDiYCVromAt38DbBg1ig+9e+4KEO1CDE6XCjTNO/Te1TvHR/Yy8IZXL8LNQy9arxQil
 hhg/dEqXBQEhhtsD94sRO9TBHDwleNkH/lojn9/DKFoyRYfvqAXbp0SWASc+Iv4vHehQs+0OY
 wMdic9d2AoVQ/QQnIF0f4s0ZLuKZq8q0H6d1CU32q/O1wX37Upo4L68OcI+IAh9Si5gw1/xrf
 EQaxfZWo3H1MXYWU6Crq/kPJAybaA+0K7ZSPM+11qK5/UB43yQ0wLJbdWbzPGCuWGLXSHSEz8
 x5nz61i+ssPV+vlWYqeDTeuXPMBq8y6h9obMrtsOr/Ah3BCtHJrsgraODxAE/KxA9isrwnNRl
 ZDY+bfubAFxfl9vwVM7q0tiA56WrEKgsYLx/+cq8PbuFH2znS5IIJTLJEKWNlRbD0A9hqpcsT
 IVSKdACZ8oB1PHmxqkcFQgTOCVRpqUWLuJeVtuU6VI3fpqFobJ/cDE1MTafEl1xkprQOpD+A6
 RG3JHdoL5m0GaKwy9dbw2/JtuUMZoliZhfKSGf8WC7KzzLpqpLsDq2yC8g2QAKBZOgveIvp+3
 uMU960qYjFzA7REc2kZy0Hn2Ru2+M7cDkRoDUe96+Oz1IIFT4WjMcAegWmZAkCQiJiF+4c9Bd
 eLSD8Pxamer52NfAcZBGip6a+zLCsElcsHiZxgCI6r6LkHj55yl/UdEEm710xz
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vd1haEZFibRRQ35YDVh4TuW2WaoY14OvZ
Content-Type: multipart/mixed; boundary="cwWosdbii7ZCMLTJQkMqIMxCI6K3agYVU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christian Schneider <christian@ch-sc.de>, linux-btrfs@vger.kernel.org
Message-ID: <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
Subject: Re: issue mounting volume
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
In-Reply-To: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>

--cwWosdbii7ZCMLTJQkMqIMxCI6K3agYVU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/16 =E4=B8=8A=E5=8D=8812:33, Christian Schneider wrote:
>=20
> Hello all, after a power failure I have issues mounting a btrfs volume:=

>=20
> =C2=A0mount /dev/md42
> mount: /home: wrong fs type, bad option, bad superblock on /dev/md42,
> missing codepage or helper program, or other error
>=20
> dmesg
> [...]
> [ 4322.061000] BTRFS info (device md42): use lzo compression, level 0
> [ 4322.061004] BTRFS info (device md42): disk space caching is enabled
> [ 4322.061005] BTRFS info (device md42): has skinny extents
> [ 4323.016007] BTRFS error (device md42): parent transid verify failed
> on 448888832 wanted 68773 found 68768
> [ 4323.025656] BTRFS error (device md42): parent transid verify failed
> on 448888832 wanted 68773 found 68771

Transid error, and furthermore, two copies are pointing to different leav=
es.

So in short conclusion, your fs is screwed up.

You could try this patch:
https://patchwork.kernel.org/patch/10738583/

Then mount with "ro,skip_bg" mount options.

Or go btrfs-restore.

> [ 4323.025665] BTRFS error (device md42): failed to read block groups: =
-5
> [ 4323.036088] BTRFS error (device md42): open_ctree failed
>=20
> adding -o ro,usebackuproot doesn't change anything, same mount error,
> same error messages in dmesg.
>=20
> Also tried btrfs check with this error.
> btrfs check /dev/md42
> Opening filesystem to check...
> parent transid verify failed on 448888832 wanted 68773 found 68768
> parent transid verify failed on 448888832 wanted 68773 found 68768
> parent transid verify failed on 448888832 wanted 68773 found 68771
> parent transid verify failed on 448888832 wanted 68773 found 68771
> Ignoring transid failure
> leaf parent key incorrect 448888832
> ERROR: cannot open file system
<snip>
> [...]
>=20
> The last line repeats with different block numbers with decreasing gen
> and level sometimes 0.
>=20
> A simple
> btrfs filesystem show /dev/md42
> Label: none=C2=A0 uuid: 8c6746f0-944a-45c5-90f3-622724d15998
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes use=
d 1.63TiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 7.26TiB used 1.90TiB path /dev/md42
>=20
> for me, seems to be ok.
>=20
> Is there something I could try to recover from this?
> Any help is welcome, as it happened during backup creation, and the
> backup volume suffers from the same issue.
>=20
> Additional info of system:
> uname -a
> uname -a
> Linux jane 4.19.6-gentoo #1 SMP PREEMPT Sat Dec 15 13:26:24 CET 2018
> x86_64 Intel(R) Core(TM) i7-4785T CPU @ 2.20GHz GenuineIntel GNU/Linux

I'm more interested in the history of the fs.

Did the fs get created/modified by some older kernel?
Especially considering you're using Gentoo, and every kernel update
needs time consuming compile, it may be caused by some older kernel.

Thanks,
Qu

>=20
> btrfs --version
> btrfs-progs v4.19.1
>=20
> BR, Christian


--cwWosdbii7ZCMLTJQkMqIMxCI6K3agYVU--

--vd1haEZFibRRQ35YDVh4TuW2WaoY14OvZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw/0XEACgkQwj2R86El
/qgoDQf/c05hXhKWSmaoGcxcA6vRn6qqm6ES2FgilSCuoMEN18eTlEcxnoGHkR3S
PUJX5WS2jFo6kMOW38y5PfHm2xu/iMQGLbQmOYSEBplLt8oYlQqsXBM2YqUDG5pE
QRqh+vZ17kB9pV+eZMMR58TzsZqPrjToovSYPKx/lkKTckdPRPs8Ag+asjiinXty
rB+tDHo91wHFMlkcpt+/Flxfy7XxJjfVmSL8ddUVxG7EoxbooXypTyvmbSTS6cUv
GjneL7jnMQOZr9iURWb6oZuJym0+y3D4DrWrlr598kvw11eoIAwZq630uDNbAdXq
FSE9Jl5Egp5BujL5KSU0v9kvpWCYZg==
=g0JK
-----END PGP SIGNATURE-----

--vd1haEZFibRRQ35YDVh4TuW2WaoY14OvZ--
