Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380C1C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 08:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E52CB21738
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 08:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="kpzN3yxt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbfDEIPi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 04:15:38 -0400
Received: from mout.gmx.net ([212.227.15.19]:53493 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfDEIPh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 04:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554452134;
        bh=hAgn7+qdbpFdIGgZPti5K/13mWJcyVuAoAhup3ZsCnI=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=kpzN3yxtMNx5R0p2Tle1Pw/COYZYumSUJ486DKeaEf9ZatynE7EXkdmo1/U5uE0fN
         hL8RgYCZ4kuvJ2Et1noNZM5H/8tFd8OB7gfmnBy3wsXRwFzguOpAeYPa1FoRtTfIDT
         ZxHJBAltUJw81kyvFmH1mFpicAJad0ycExjeD+vw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MYP57-1hPMqS0dij-00V8Sa; Fri, 05
 Apr 2019 10:15:34 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
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
Message-ID: <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
Date:   Fri, 5 Apr 2019 16:15:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hFAuMnX5eterJmFGRXTxj9SXE5flEB9To"
X-Provags-ID: V03:K1:/jagW5jBCFsLK1ohobpVnjnNjNAZjd+cIXp4A58gZEGzrDTDKIZ
 BMgsxZNpX3BNWKh1I49J9daO6iQ7qzdPn1EbTmCCGePSwes8OuhCN/+/0tObLlj4s7+YT9c
 rSEmU9IiS0DgOK/+Wp0JAheKYi9IwmPfg6WgdrDPzcol9WetHFnJRV6FJ+CT3VKYzUJTvy2
 qiTY2oGh6yM79ja/JI+Hw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z35+zWJXBqQ=:5nBzK+qGkdRw9W+NhyDWje
 cnfRq94YFXut0Uz0HZP4TBzU/PkB/hdox+FKQa2axKaeu6i9c9XQFXSrMEsDKVT5pVt3JaXHB
 dX61TFi/F/P1zt5x5GIlo4fOfsjpmBw/UTiTEJkwXygIpbh0QjqXklPHs7XjIgnFOCwcj4spU
 Pv1tmTM9rnZkB6yntls+if/OofhXKQFNG5LK8Z95obyREZhCFAFUD+GcelajRREXMsyEmdVBe
 y/0FGXh+JVwfP65Akqp0jjmu80zidar+GIFEy3Kw3ujptgxulf8wfF2cpuYftnJL8n1g4GNwo
 hV2HnRnbElM4A4gWgN+eTU1KPq5AtmOwlEXaH+eT/Nx7tybolq6cAU6WerVwYiUZilGNEIQnt
 UHCqDniuh3oEFaYs6MgTj7Echi1CZCfH7NubC9AVE4gZzCuLd8EgM5Fs72bjZoGS2kOWq4Pc/
 dR0JzoEbKBDJmHA9Ah4KnSgHttVR3LI+7C3xi/U4urn3kTfS6pnxh555bk0BuY0gX+jIzh7Ia
 WGXEtus8FmQGbkcFO4IjVKg5AAAZgRY9Xs+st+zYiTBwaPVdLOQfpB+1+ZSN/0ua1+YcUzP3W
 ICtWn8p5oMQUnl8N48krnP/wwRmottR7EMjhfRMucUbJlRfypnjEqRQSskI0+MZxm4RhEQfZP
 NZYrw8wLPz0sSUD/ABoOziHiYNwGOlhIpl9DkA0sQ+na0QNtJoZ5I9dT0oK/GhuMBQIYUjXuH
 ld4R6EG2nWwv03CM44PHKOWW3z55ma+q3lVLehzF++cn/8XWZIhfCY4RAk4Z9PRKLr5hTGDf+
 ThHyRPUEXIPUUCVnlLuHJQjYRlGyqJT1mXhZIMVg0nBoLZTGQWGUEZ24m+ZQ9ILLqJoQPcQer
 dpVQOYIiNhiVtsGX5wvzHNN5JBaEzB9RBMKaatJhPxKWz2ozjwHMIw7V/K+O7r
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hFAuMnX5eterJmFGRXTxj9SXE5flEB9To
Content-Type: multipart/mixed; boundary="b7ki9RoKl5ExyWDOMAWO088UFUm0z3pDs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
In-Reply-To: <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>

--b7ki9RoKl5ExyWDOMAWO088UFUm0z3pDs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/5 =E4=B8=8B=E5=8D=883:41, Nik. wrote:
>=20
> Below is the stderr of both commands:
>=20
> # btrfs inspect dump-tree -t chunk /dev/md0>DT-chunk.log
> # btrfs inspect dump-tree -t extent /dev/md0>DT-extent.log
> ERROR: leaf 1894009225216 slot 30 pointer invalid, offset 146038 size 3=
7
> leaf data limit 16283
> ERROR: skip remaining slots
>=20
> Since the output on stdout is pretty long even after gzip, I am
> providing only the output of the first command as attachment. The outpu=
t
> of the second command (25 MB after gzip -9) can be downloaded here:
>=20
> https://cloud.avgustinov.eu/index.php/s/AgbwWyCrbYjenq8

Sorry, I should have use a more specific command to get a smaller output.=

But anyway, your output is good enough for me to craft the fix patch.

Here is the dirty fix branch:
https://github.com/adam900710/btrfs-progs/tree/dirty_fix_for_nik

Compile the btrfs-progs as usual.
Just a late hint, you can disable document/btrfs-convert to reduce the
dependency:
$ ./configure --disable-documentation --disable-convert

Then, inside btrfs-progs directory, call:
# ./btrfs-corrupt-block -X /dev/md0

If everything goes correctly, it should output something like:
  Successfully repaired tree block at 1894009225216
(And please ignore any grammar error in my code)

After that, please run a "btrfs check --readonly" to ensure no other bit
flip in your fs.

Thanks,
Qu



>=20
> Hope this is ok.
>=20
> Regards,
> Nik.
> -


--b7ki9RoKl5ExyWDOMAWO088UFUm0z3pDs--

--hFAuMnX5eterJmFGRXTxj9SXE5flEB9To
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlynDqEACgkQwj2R86El
/qjGfAgAqw8lmq70lwnahGDRL3DIszN3ZkG8wqqY9awX+UexGfdbOTfDJz9vsz3J
sVIeCwpDEDWU6o1jb0ZSoJ2HtWvMKONRgcNUfO2tEZ8g4VP5VC+k1Q+M+Uql35TJ
gezQEibzr7VPs6WoH+ckiD3rlXEqNVMIWaDQVLS2VFYI1zpcBpgcJt34yn9of/zA
8TH0OsIN15ewRkL3e06mv5N4NTR7z8l7ZkWg3YDTtBWYGldB6RS7UF8B2OInS01r
i3EtNIoVtlnNzc01V3DYUdQbNBjtt8+8jePabpO2rNcUY5zyF9W0kiQ33YZpKET5
UrHNv40oT99LlpWWoku4MAcnDVMbuw==
=hMZb
-----END PGP SIGNATURE-----

--hFAuMnX5eterJmFGRXTxj9SXE5flEB9To--
