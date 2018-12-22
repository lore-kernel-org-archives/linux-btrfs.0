Return-Path: <SRS0=C3Cz=O7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FROM,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBECC43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 00:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ECB221928
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 00:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404690AbeLVAD5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Dec 2018 19:03:57 -0500
Received: from mout.gmx.net ([212.227.17.20]:43233 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404687AbeLVAD4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Dec 2018 19:03:56 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LnkiR-1h2NCp1VHD-00hyje; Sat, 22
 Dec 2018 01:03:53 +0100
Subject: Re: Defining quota on /home
To:     c.monty@web.de, linux-btrfs@vger.kernel.org
References: <trinity-ec0de399-18af-4184-bd8d-364ffa41afd3-1545402162344@3c-app-webde-bap30>
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
Message-ID: <e8f7544f-5588-66f9-aa55-1e040f6cb834@gmx.com>
Date:   Sat, 22 Dec 2018 08:03:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <trinity-ec0de399-18af-4184-bd8d-364ffa41afd3-1545402162344@3c-app-webde-bap30>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="j4k7aOO1fJCNb2PV2Ew3ELQOWWZnxzoSP"
X-Provags-ID: V03:K1:xkgXBnCoHdsu2Oa2QwvtSuBB6AKGyOGGx8jQfOwwZAsCWq+sOcH
 2vB1Wf3mKI5gCy83FdEEBc7Ogx9ZT9FuIBRJdtUWm4KpiUq2GnEBfrw6PQ/bZlgUYu+Cy78
 vEERA22j9qnCnd+TOqs9AcB5Lio7NeoOLFT34J6Ah6J9IAl/YmJIv+OciDaVhabDwnfP3sT
 QSR2cfUo0C1wek1iXrXGw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Nso0KmqO00Q=:9fNL2F+QIHcIN8iRb0M+e1
 eNFSsfuhaK4XXuAxgzW+F0x0lkxzs9vB2/y/4AK7rDCzy7sx+f/0jGMxtf9sW59c26nNBVGA1
 jshlAFOT5Cfif9JRGIrTuyayzJUPOhdBdefwv7qv6hSbmF0XGqgeLWoz+kYbqj8sEJB5ZeWZy
 wnj96NwlsHeO6mf7joXtnam7T2yjSv3CM4rwy7AK/x45BTuKxeBzTVntdbTmMHhe9pQLvLHP0
 JD5rqzGjElKtejWf/iqUVIaXcyJU31Qyav0rhxiTt8dfPHHtRkgFpbiDlyF3gFi5yRYL4y5E9
 wsuNhVvK0JRHUt54FtWNeBWocrntzNhqWteou3/cSw1NbWdFtTrm0xhG1KqIPh/ZvnHEfjc+o
 2ios2fDytyxkbDOyRxoMUgu/yNEAeXMGQY37q0fStz12iBklB2RoQ1Z0NyTCjQgAm8dzVPnu8
 63OJdayPLAwcJ/1F+6pB9YnbttC1Qu7+GlH2IkXq7+qYqh9NcYXFqpJk9bpDFiPFBZpw68XE/
 CDsp2MmUtNWrYicOsifsmoAjVgmUmNZU28UqGcqKoSWa4N1FO9bg9Lk2oTMwqRrkZeDoA8uHa
 Hicx4N2VnFwa1aZmKdIreo2reN8Jdu1fk91sNIaQ7hvyAY27rMoIqMZV5CH/pnsDR84mUQyay
 CUJJwNJPjo/tXkYJaGOVLLxQTt8TNijy4FyJI2LSmvpFIvXzSVcop44EIUNjojM5+UG6uY3v4
 pw6+4qPiXUElYKZiiE9inEnKIK9qdOyHfTkxFvuW12a9ALmwT65JkrjqPxOJaGVKMoGNH6CL+
 6Y85/MJyL8ORoW9thpoULp7WiLuhtSVMzsdrHPJOvfvpq5uRLton6Qy3D3bB/uQz0c+SpcIWx
 t/lJyXtWV+ZeDlZR4dZHBGHK2L4O+HU03Iqxc4GMN71njMd8dI+nYrDGJSHrp4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j4k7aOO1fJCNb2PV2Ew3ELQOWWZnxzoSP
Content-Type: multipart/mixed; boundary="FS8abH86RxNSOOVd43Ew0Hl52XS5A4Ha4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: c.monty@web.de, linux-btrfs@vger.kernel.org
Message-ID: <e8f7544f-5588-66f9-aa55-1e040f6cb834@gmx.com>
Subject: Re: Defining quota on /home
References: <trinity-ec0de399-18af-4184-bd8d-364ffa41afd3-1545402162344@3c-app-webde-bap30>
In-Reply-To: <trinity-ec0de399-18af-4184-bd8d-364ffa41afd3-1545402162344@3c-app-webde-bap30>

--FS8abH86RxNSOOVd43Ew0Hl52XS5A4Ha4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/21 =E4=B8=8B=E5=8D=8810:22, c.monty@web.de wrote:
> Hi,
> =C2=A0
> I have defined a quota on home with these steps:
> 1.=C2=A0btrfs quota enable /home
> 2.=C2=A0btrfs qgroup limit 150G /home
> =C2=A0
> Now I can verify the corresponding setting:
> btrfs qgroup show -reF /home
> WARNING: Qgroup data inconsistent, rescan recommended
> qgroupid =C2=A0 =C2=A0 =C2=A0 =C2=A0 rfer =C2=A0 =C2=A0 =C2=A0 =C2=A0 e=
xcl =C2=A0 =C2=A0 max_rfer =C2=A0 =C2=A0 max_excl
> -------- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ---- =C2=A0 =C2=A0 =C2=A0 =C2=A0 -=
--- =C2=A0 =C2=A0 -------- =C2=A0 =C2=A0 --------
> 0/279 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.79GiB =C2=A0 =C2=A0 =C2=A01.79GiB =C2=
=A0 =C2=A0150.00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> 255/279 =C2=A0 =C2=A0 =C2=A0 1.79GiB =C2=A0 =C2=A0 =C2=A01.79GiB =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 none =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> =C2=A0
> However I don't understand the line with qgroupid 0/279?!?

0 is the qgroup level, 0 means the lowest qgroup level for subvolume.

279 is your subvolume id.

255/279 is strange, unless you manually created high level qgroup, it
shouldn't be created automatically.

> =C2=A0
> I have created another quota earlier for /var/log, and there's no secon=
d line in output of=C2=A0btrfs qgroup show:
> btrfs qgroup show -reF /var/log
> WARNING: Qgroup data inconsistent, rescan recommended
> qgroupid =C2=A0 =C2=A0 =C2=A0 =C2=A0 rfer =C2=A0 =C2=A0 =C2=A0 =C2=A0 e=
xcl =C2=A0 =C2=A0 max_rfer =C2=A0 =C2=A0 max_excl
> -------- =C2=A0 =C2=A0 =C2=A0 =C2=A0 ---- =C2=A0 =C2=A0 =C2=A0 =C2=A0 -=
--- =C2=A0 =C2=A0 -------- =C2=A0 =C2=A0 --------
> 0/275 =C2=A0 =C2=A0 =C2=A0 =C2=A056.52MiB =C2=A0 =C2=A0 56.52MiB =C2=A0=
 =C2=A0 =C2=A05.00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> =C2=A0
> The following subvolumes do exist:
> =C2=A0btrfs su li /
> ID 257 gen 134 top level 5 path @
> ID 258 gen 36271 top level 257 path @/.snapshots
> ID 259 gen 36312 top level 258 path @/.snapshots/1/snapshot
> ID 260 gen 33772 top level 257 path @/boot/grub2/i386-pc
> ID 261 gen 33772 top level 257 path @/boot/grub2/x86_64-efi
> ID 262 gen 36311 top level 257 path @/opt
> ID 263 gen 33772 top level 257 path @/srv
> ID 264 gen 36312 top level 257 path @/tmp
> ID 265 gen 35961 top level 257 path @/usr/local
> ID 266 gen 36310 top level 257 path @/var/cache
> ID 267 gen 33772 top level 257 path @/var/crash
> ID 268 gen 33772 top level 257 path @/var/lib/libvirt/images
> ID 269 gen 33772 top level 257 path @/var/lib/machines
> ID 270 gen 33772 top level 257 path @/var/lib/mailman
> ID 271 gen 33772 top level 257 path @/var/lib/mariadb
> ID 272 gen 33772 top level 257 path @/var/lib/mysql
> ID 273 gen 33772 top level 257 path @/var/lib/named
> ID 274 gen 33772 top level 257 path @/var/lib/pgsql
> ID 275 gen 36312 top level 257 path @/var/log
> ID 276 gen 33772 top level 257 path @/var/opt
> ID 277 gen 36312 top level 257 path @/var/spool
> ID 278 gen 36309 top level 257 path @/var/tmp
> ID 279 gen 36311 top level 257 path @/home
> ID 280 gen 36311 top level 257 path @/usr/sap
> ID 308 gen 17373 top level 258 path @/.snapshots/19/snapshot
> ID 309 gen 17373 top level 258 path @/.snapshots/20/snapshot
> ID 315 gen 17373 top level 258 path @/.snapshots/25/snapshot
> =C2=A0
> This is the additional information demanded when asking a support quest=
ion:
>=20
> lvevm117:~ # uname -a
> Linux lvevm117 4.4.162-94.72-default #1 SMP Mon Nov 12 18:57:45 UTC 201=
8 (9de753f) x86_64 x86_64 x86_64 GNU/Linux

This kernel version is very old, especially for qgroup.

I won't be surprised if any qgroup related code went crazy.

> =C2=A0
> lvevm117:~ # btrfs --version
> btrfs-progs v4.5.3+20160729

The same to btrfs-progs, it may be btrfs-progs initializing wrong ioctl
parameters.

Thanks,
Qu

> =C2=A0
> lvevm117:~ # btrfs fi show
> Label: none =C2=A0uuid: fbe2e4f1-2ccd-44df-bc35-790c5e019d66
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Total devices 1 FS bytes used 8.78GiB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 devid =C2=A0 =C2=A01 size 198.84GiB used 23=
=2E07GiB path /dev/sda3
> =C2=A0
> lvevm117:~ # btrfs fi df /
> Data, single: total=3D20.01GiB, used=3D8.37GiB
> System, DUP: total=3D32.00MiB, used=3D16.00KiB
> Metadata, DUP: total=3D1.50GiB, used=3D414.19MiB
> GlobalReserve, single: total=3D27.38MiB, used=3D0.00B
> =C2=A0
> =C2=A0
> THX
>=20


--FS8abH86RxNSOOVd43Ew0Hl52XS5A4Ha4--

--j4k7aOO1fJCNb2PV2Ew3ELQOWWZnxzoSP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwdf2UACgkQwj2R86El
/qi3ygf+OXHb/LNuLorXXP/cbFNDQNhbIlCPizBSxF3b+IXXyAk80nu2AEr7gGrU
t75hWZBYQsxt7mCbJspaKeE+ZU9Frxz6JeQBeeWrZiyeEgCft77K5ykmU6gAPg/9
6Sr9vOERxQVXifdYETzbD61239Gv5V6l76PoQhqhtBWoLSTHvhW5WHrtCFlFrm1o
hsiRXXcY96yF16UO2/lP+X3w/IcudKDkT/UUPOFLD6lMdam7VVWr6zwbZwvmtKWQ
PfVLgIpUa66yrcEUtG+nIFg9xLbuW2P9FbXx55tfZ57pVhXERdWQC/qUjL0eZbKQ
IGilKCrrDIMTtuUfsXAGqb6MkYbZtQ==
=x2U8
-----END PGP SIGNATURE-----

--j4k7aOO1fJCNb2PV2Ew3ELQOWWZnxzoSP--
