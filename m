Return-Path: <SRS0=ilb6=O5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC192C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 00:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D8E92084A
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 00:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbeLTA53 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 19:57:29 -0500
Received: from mout.gmx.net ([212.227.15.18]:52909 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbeLTA53 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 19:57:29 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lx8OH-1hSp6S45Sz-016fcF; Thu, 20
 Dec 2018 01:57:26 +0100
Subject: Re: compress-force not really forcing compression?
To:     devzero@web.de, linux-btrfs@vger.kernel.org
References: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
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
Message-ID: <79977718-ac8f-3a62-529d-e9046c8066b2@gmx.com>
Date:   Thu, 20 Dec 2018 08:57:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ktk4NhY3dVTZYgFXixA1nmZVCbzbebZpS"
X-Provags-ID: V03:K1:NtvgKHVnftmbbLMTH8/BByj2QrJuhdgI7COXp7Syy3YCi5zxBwG
 nGrQJEbm+yopC2hRkKj98fa6iAf4fzCg1gusbJZiwPI9NFeYvMsPdDcsUzGgyTlN2Hq1KhK
 O22UWS3Hd6haOQNOQvbwaEO62abugdvMIiWyTa11+13rHs6tUw2S7jVrYQzKwb3FZBI67Nx
 QGtm3bJwfLtzk2l0+gM9A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:f7XyFF9kFlg=:toJy5xuCV+aRDkCcNYAUm/
 sksM4uWRjNfwvDNIbqNYUzqWcCIxfUnR5h/HbzxVVXuuYdl3hLHleHKqSmV79WjHq1NsuLj5F
 7/utFaygjSlaQRFUlXrHL213XPZzv4Nfc3W1kbF2VcAHPS5DJyoph//HUO4sCYwovehoCI2fR
 BmPNEANZwUJQjahHcu0XJ2ZE8YVyffrdLDpOjEbG21PZz5romPI4iOEWVJddHoPRZ27wbLzbZ
 aiE/8osn6/sNorTtcF3U1I2iJjVeYuiFx82Wnq/QPrNtnLp0sz9XQ7pGZ7DObJNDTQdhZsVmZ
 micGjXd5MAiTBnE67+joB0k8gC8qAe6+drfD9g8+fau+BnT0uFjdRnZmKrdsrzBShyilBz140
 FteeOKaWAOCrWcwGH2JidOfhvKpNWzlEUbaH2WbHun8tmTvEQOVzK/nvHpNFsb9BiNoyGr0zK
 05v6TK5pA7faIba+pjuF+8If1Zq4nYTI94GEZ/4+XjNcEGIpt2Uv9BQAxxs3Oo+WO9b0B07FM
 1c8ggcqMaV1Aqp0AXOiM35fvXiEGHlLG3APuM7n9ivxVUs1wakoUKkfIqk2mhxXOyBk0TmsHV
 w7Q9VtgcKi920JkQ6zpY9hxi+/VVDe9GyJnjyyh/LkLkFk64Y5KQ0v8yTA611cvkpP5CsiPTJ
 oAsipgTn5EZdqN2gdBaGi4HgHztbxGNoZh7Cua9j/7fQXV1usPNsRg1EtVgnLer0syuV6RJI4
 LPXAQoqA4T7m7WsTvlp1imCRhqZwMlNfo7kIfQihCgybEUSiaCk4qDY2KbTrzhtQ/Z6bJByw9
 rrxq1Lbpagn7FnsPtiNRphyh7a3jSkR9DPxDMpPigQBEmv2JkEZsc3P6HBvZx8entcnjJ4Rzv
 2FK9E324VtQCnkg+8suHUerfOJGDIFDfNhaEjhXqf7GWVDkuXXmrevf67qIz+z
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ktk4NhY3dVTZYgFXixA1nmZVCbzbebZpS
Content-Type: multipart/mixed; boundary="82DQliEBFwcNecSmvspePWFMvUxkLMSgf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: devzero@web.de, linux-btrfs@vger.kernel.org
Message-ID: <79977718-ac8f-3a62-529d-e9046c8066b2@gmx.com>
Subject: Re: compress-force not really forcing compression?
References: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
In-Reply-To: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>

--82DQliEBFwcNecSmvspePWFMvUxkLMSgf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/19 =E4=B8=8B=E5=8D=8811:41, devzero@web.de wrote:
> does compress-force really force compression?

It should.

The only exception is block size.

If the file is smaller than the sector size (4K for x86_64), then no
compression no matter whatever the mount options are.

>=20
> for me (found via compsize - see https://github.com/kilobyte/compsize/i=
ssues/24 )  it looks it is problably forcing compression check for every =
block of a file (while compress=3D makes btrfs skip compression check aft=
er first block) and if some block is incompressible, apparently it's bein=
g stored uncompressed.

Any reproducer for this unexpected behavior?

Thanks,
Qu

>=20
> so, the documentation is probably telling misleading information and sh=
ould be fixed!?
>=20
> roland
>=20
>=20
>=20
> https://btrfs.wiki.kernel.org/index.php/Compression#What_happens_to_inc=
ompressible_files.3F
>=20
> What happens to incompressible files?
>=20
> There is a simple decision logic: if the first portion of data being co=
mpressed is not smaller than the original, the compression of the file is=
 disabled -- unless the filesystem is mounted with -o compress-force. In =
that case it'll be compressed always regardless of the compressibility of=
 the file. This is not optimal and subject to optimizations and further d=
evelopment.=20
>=20
>=20
>=20


--82DQliEBFwcNecSmvspePWFMvUxkLMSgf--

--ktk4NhY3dVTZYgFXixA1nmZVCbzbebZpS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwa6PIACgkQwj2R86El
/qjqxAgAsP5xecamjkq4Fkz8krnvjoU/WpaRtYvx0X/Gan2KzDTVl0JNw8p7g+HT
cVOR181SHIB+bhKkiU1PcEuIIkhWi8oEM6Ps4RtuZhyl3inB6dZA3nTSNd/ita0w
Bj0CmauDXHJ1se1VkGoB25kNrLj9+fXLqP8igzkLjf2cXU4mMMhU3XPniluZJS9Z
7k5hifW1S0y8aW8pBy1kZa2cCOa8rEcWYxHbgHvRJTGISGe/sPEWI0kbRn0ZElWv
4bCmgaM4Syizo1FXzyN4KbzefR3p5rOtC61O17yESXJwDICmETg/6snreoav6p9b
euUKbBg6+8bSH0uz5naUjecc5neLxw==
=aS6p
-----END PGP SIGNATURE-----

--ktk4NhY3dVTZYgFXixA1nmZVCbzbebZpS--
