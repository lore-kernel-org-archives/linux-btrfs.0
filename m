Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F939C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 08:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BE68222B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 08:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390221AbfBMIEu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:04:50 -0500
Received: from mout.gmx.net ([212.227.17.21]:46345 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfBMIEt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 03:04:49 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M0QLp-1hEEX349BV-00uacT; Wed, 13
 Feb 2019 09:04:37 +0100
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Roman Mamedov <rm@romanrm.net>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs@vger.kernel.org
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org> <20190213124708.0dd4dbc4@natsu>
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
Message-ID: <cef5ecc4-3a64-cde0-8d21-a3473149000c@gmx.com>
Date:   Wed, 13 Feb 2019 16:04:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190213124708.0dd4dbc4@natsu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a2YfQ8sRF4Nb1Z6q1wnWpYXTqjEDAidut"
X-Provags-ID: V03:K1:Ul9xQUGMd7Iuu8JOgZU5b9X7He5RkEvHGSNA49cuM6T666Co0y5
 1zjc+FUHC7hVuH+ANQCujMPu+nOusA9MPj/Wy+OOSlZkGwzHB0KZO9m0e5vOiIp93cQHJjN
 yloudJE6pVI2DCfXOA9Dm0s/+85xzeH+KtwV5GF9ldgsYG1w7MW//zKrZQi6UpaOPapbRP/
 wNI1GrPwF2MOyKwMozz7w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yOsKVhPzeMs=:EWT5L/OORdnQ1NqdAz9v+n
 9uLN1b6TdUtFq3+ee9MJJJcIGADCmCBHGm41t8OF6H1QpcIIv8bn57YqhYubvPjl7rryyxbwP
 YCM2wYE4cHDPro3Bo8w547AZmFQMhCloPLZMWYhErDfthFBUoxsbDgkasPDXiK2CO6vqUejZM
 RelhXp1wbOErfYHQHAViOMJqTQ4E1Qm7RS39wm6puSOjfPuLy6/iMCrJgpvZxngf51RLOXGKD
 HUUEsFlxq0j0VSmrzAjid3HTU3PK/cPGkZIcFpoX7QZI3UDKsrnd5QcQrvD7IGvfsrBSBcFT/
 Mha/BxjwD4qYMIQuvg5tC8DEGWqsfX3/G9W/8KA67CqXq7H83vZjdGLFskt/wuVsNw0NpcQfP
 LR0/r1cdIvGV8BwdzevkFK978Qjpwu9ces+c6U03JCzgIqHdIn9LPRPwaAGHWQRgqgdIzgkoC
 e0D9nL7jJiSunc0DH6Sk2IteshPUuyY7m1tRoZmBgjW6q3UiBQ0wR5oFuzUKaNtSDQ6eZfqHR
 l2bkcuK4RUARvFND9Ul507cekVFYrpg/VqZwc5o1imxaeihUH0x5S2/KJpdjlCn1EG/26uqle
 0XzB09Vc7hwyIyXnVENvYmR0GZ63kbEZXbNpvr6J7ne0uL0V2JWaZsfDZyWqlsxLG7DGf8TQc
 A7rd9r8MetA5ILYpFSrBnCxtNACEjFYa3Wv9zVUvL831tZ72sYr+QujYkQoRbiKKgKtytqCb2
 RYYjmfhU6dbBjekjhxUBArH7J9s4IsmTbi7OPse/p7lgT+OF4ETr30SR7Y8FNQTbeANK+x05K
 Q/gqfcxHnpU1WXJbOzfZDlxoOC42HmZ8wNQGn8ZvrPoczCDakyJqAFnAjxFeqQ/BPyCJU5eJL
 ADLShXASY4azGdyy4qXrkelwAwcLIRay7/d9GQhhSzIFQv5ZoyBoPBwbmXzNrv
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a2YfQ8sRF4Nb1Z6q1wnWpYXTqjEDAidut
Content-Type: multipart/mixed; boundary="b6hWysisDWPqs1cjvtv0EKfULwhiRVydU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Roman Mamedov <rm@romanrm.net>,
 Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <cef5ecc4-3a64-cde0-8d21-a3473149000c@gmx.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org> <20190213124708.0dd4dbc4@natsu>
In-Reply-To: <20190213124708.0dd4dbc4@natsu>

--b6hWysisDWPqs1cjvtv0EKfULwhiRVydU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/13 =E4=B8=8B=E5=8D=883:47, Roman Mamedov wrote:
> On Mon, 11 Feb 2019 22:09:02 -0500
> Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>=20
>> Still reproducible on 4.20.7.
>>
>> The behavior is slightly different on current kernels (4.20.7, 4.14.96=
)
>> which makes the problem a bit more difficult to detect.
>>
>> 	# repro-hole-corruption-test
>> 	i: 91, status: 0, bytes_deduped: 131072
>> 	i: 92, status: 0, bytes_deduped: 131072
>> 	i: 93, status: 0, bytes_deduped: 131072
>> 	i: 94, status: 0, bytes_deduped: 131072
>> 	i: 95, status: 0, bytes_deduped: 131072
>> 	i: 96, status: 0, bytes_deduped: 131072
>> 	i: 97, status: 0, bytes_deduped: 131072
>> 	i: 98, status: 0, bytes_deduped: 131072
>> 	i: 99, status: 0, bytes_deduped: 131072
>> 	13107200 total bytes deduped in this operation
>> 	am: 4.8 MiB (4964352 bytes) converted to sparse holes.
>> 	94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>> 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>=20
> Seems like I can reproduce it as well. Vanilla 4.14.97 with .config loo=
sely
> based on Debian's.
>=20
> $ sudo ./repro-hole-corruption-test=20
> i: 91, status: 0, bytes_deduped: 131072
> i: 92, status: 0, bytes_deduped: 131072
> i: 93, status: 0, bytes_deduped: 131072
> i: 94, status: 0, bytes_deduped: 131072
> i: 95, status: 0, bytes_deduped: 131072
> i: 96, status: 0, bytes_deduped: 131072
> i: 97, status: 0, bytes_deduped: 131072
> i: 98, status: 0, bytes_deduped: 131072
> i: 99, status: 0, bytes_deduped: 131072
> 13107200 total bytes deduped in this operation
> am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> c5f25fc2b88eaab504a403465658c67f4669261e am
> 1d9aacd4ee38ab7db46c44e0d74cee163222e105 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>=20
> The above is on a 3TB spinning disk. But on a 512GB NVMe SSD I even got=
 the
> same checksums as you did.
>=20
> $ sudo ./repro-hole-corruption-test=20
> i: 91, status: 0, bytes_deduped: 131072
> i: 92, status: 0, bytes_deduped: 131072
> i: 93, status: 0, bytes_deduped: 131072
> i: 94, status: 0, bytes_deduped: 131072
> i: 95, status: 0, bytes_deduped: 131072
> i: 96, status: 0, bytes_deduped: 131072
> i: 97, status: 0, bytes_deduped: 131072
> i: 98, status: 0, bytes_deduped: 131072
> i: 99, status: 0, bytes_deduped: 131072
> 13107200 total bytes deduped in this operation
> am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> 94a8acd3e1f6e14272f3262a8aa73ab6b25c9ce8 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
>=20
> In my case both filesystems are not mounted with compression,

OK, I forgot the compression mount option.

Now I can reproduce it too, both host and VM now.
I'll try to make the test case minimal enough to avoid too many noise
during test.

Thanks,
Qu

> just chattr +c of
> the directory with the script is enough to see the issue.
>=20


--b6hWysisDWPqs1cjvtv0EKfULwhiRVydU--

--a2YfQ8sRF4Nb1Z6q1wnWpYXTqjEDAidut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxjz5AACgkQwj2R86El
/qgVYAf9GAEprZDmwIs5gtt39eayuxWbcUCBIVFt2OueTcQoGSRm0tbIibub69c+
+xnMIZBWR3T7dysqm6F5q3QaYsbTuMDPCgiDxuyKljyJHqAVaOry4lxoxWmHOS/h
4poT91EoZMGgKceC6MtO7uKWLLjIJ36mud+75x9ampp2Ef71zFw6kQ8jaDT7a8iE
8VAr5h2ZR0FGhLMYu2YvWNcR81f+gQKZumncEHWFSDviGYn/ntkYsPctwNrC0FzD
E1iYo/BwJhM/IVeF1OKDqLx9tZZPzhGN1XQr068HEo0gx/f/bEsvsIL9N0PBqMeo
nnOsDhiuPkhMS0hZHS+wn2t/oII50g==
=M6mX
-----END PGP SIGNATURE-----

--a2YfQ8sRF4Nb1Z6q1wnWpYXTqjEDAidut--
