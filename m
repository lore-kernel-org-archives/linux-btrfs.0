Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B696C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 00:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B37A92086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 00:50:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B37A92086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbeKSLKy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 06:10:54 -0500
Received: from mout.gmx.net ([212.227.17.21]:37795 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbeKSLKy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 06:10:54 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MfzEP-1g40iP25YL-00NQ1R; Mon, 19
 Nov 2018 01:48:53 +0100
Subject: Re: Broken filesystem, looking for guidance
To:     =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
        linux-btrfs@vger.kernel.org
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
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
Message-ID: <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
Date:   Mon, 19 Nov 2018 08:48:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="awVfW33C7GvYSdydrFnhwQyK5b1CjmEAM"
X-Provags-ID: V03:K1:4o8mO0Zya6QpMpbd7mUxYq94r9X4e371TvcVkCH+hEaj84XBuBM
 se1jB1l6HjScGMpSt8Na6xbZapcyWXNPLtZQcCnv5Nw6wPS22gAHFW/BTRHodRqKqjm70Cn
 lOL2xF74EnCDtWi2t/f0FmMxCx4Egh4b7V+IP2Z/9jh3Q6HqSMreSxyaQnbtQugV0fDxD5U
 44wr16XmTkxI17sn7K9JQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:C5OABmuoQXY=:jsduG4GWYONk39mcgymOW7
 0TUfsMJM82cn3tAW26NwOd07ctAJj2rahkhTmCZHuXdzKaR27ldYpsZlPZWZOHNFgK54dSD4t
 p8fIIYaXJ5pSFZDoD4cUuPcZrTeNIyFJIhEE/OO/I1vdRA9e/jy/tzC3GsQ2+AHTKEPg+8SwK
 1poWVXKf5UpCIa/Rgf6Oyy8AxlIpYDPJMRZSYfAg/WI25YS4LYRrkGyBr1Ns2BP9+KOOPliqD
 LyZO7CAdFhAyvu78UwkWrGfqrRj7u6O+RAxJti1O/jzG8iDPfjDVuzKUCiKjb3GyAEbSKhY9t
 htk1L+bVyk/TjmJGMUxJDVySQk0XRZ1zFucr3CrGTLXQYtTeR70EHOujHqmgMkQKUttbJ3cns
 rhQzQvcUGsQbO36L59BLm/HWD7OlVlOX3AZdRnh9rxNDKgI70i+btmuSqiX46XEeux0/h9faQ
 iJe3btVhQ/slVl9AT4WZA33T8ar+hQ5UfpwdC+sjw4vcjGF3Y1urrCsrqKi2P3uCDVSm6/Gzw
 5gADeUUwlDiKXmwuTv4rW3KWpX0DneBDS8Jdt2v7lSOzFX0h5wEuFaxp3hL0pejqG2QeHNHDo
 QmF4/vLEKL2We+VzzP+O4SDt7Euff7X+avW+xIg4DHIOvc/CtvcjOsSUBbuHJc9nBrRLyo9nY
 ayYkQPDIiuCn4nY4MrV2u0k/xHAwkd3jecRPDLldT9zkakzH9tLOEsqi6Y2Bay7pxK46Z1Hl5
 CH+u2NjJ7sVktvvyzlo4qP2Zt5raRSO9Ebk4CXJdPJsLMVpF7ETQvYwGrupnC6psF+70pN2OQ
 dnOg+tbr9WvPv+jOAagjwtnS0F5hqNnmKpMZE5SkAB7hZUzELmm3rw8vBCZIT7lpRRvV2HK6R
 6YNj1hqkIiLdX/psHCRUcdPMt7Ae1B/F4yxjbLAfcU1yJgNAAnksYJ3VCGVCpo
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--awVfW33C7GvYSdydrFnhwQyK5b1CjmEAM
Content-Type: multipart/mixed; boundary="LAF4prpxoxUgJaCjcrJkPcEDVen4GT7H1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
 linux-btrfs@vger.kernel.org
Message-ID: <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
Subject: Re: Broken filesystem, looking for guidance
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
In-Reply-To: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>

--LAF4prpxoxUgJaCjcrJkPcEDVen4GT7H1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/19 =E4=B8=8A=E5=8D=883:37, S=C3=A9bastien Luttringer wrote:
> Hello,
>=20
> I opened a bug report[1]

Normally mail list will give you a quick response.

> about a situation I have with a btrfs filesystem on my
> backup server. Looks like there is internal errors inside the filesytem=
 which
> cannot be fixed by btrfs check.

No btrfs check --repair please.

You haven't post btrfs check --readonly output, thus not helpful.

> Currently, each time I cat a specific file, the
> filesystem is remounted read-only.
>=20
> How can I get some help getting this file system back on track?
>=20
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D201525

Please post the original kernel version where you hit the first kernel
warning.

Without any useful detail, it's hard to say, but your filesystem is
already corrupted, by the original (maybe very old) kernel.
Thus newer kernel can't process on the corrupted fs.

Thanks,
Qu

>=20
>=20
> S=C3=A9bastien "Seblu" Luttringer
>=20


--LAF4prpxoxUgJaCjcrJkPcEDVen4GT7H1--

--awVfW33C7GvYSdydrFnhwQyK5b1CjmEAM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvyCHEACgkQwj2R86El
/qgU+AgAiNjCPK5QdxuYJ1kYjFQav+JyD5nN+SinBRrGKRyVq4hUkK8SeoqVd17S
sszwgCg4thXjjEg+N9B0y6xifkZu8CNEKMmk7t6Nu/ykEHeWGAf4OD3p6oLIbSKo
AXU8KHkPxGKgttiSI7amJwrNQ835U90wKV7cQqFDqIcod/cRXdtDCtXgdAdlASuj
J7jO7el1YA7nQ3Moj4Bn3rRk0tQ2m/x6oxYayACC8RsmEFXIcvt/TMBIzo8r5V/0
y6QOeBBY0OhXzJUv6DPtGzbC5H9hEXWi2AlZz9imHBG13OEgDAYsIfx359PUBOma
Q9tV5ImICI6JirVNJk+GWK2QnfBKAQ==
=Nb0s
-----END PGP SIGNATURE-----

--awVfW33C7GvYSdydrFnhwQyK5b1CjmEAM--
