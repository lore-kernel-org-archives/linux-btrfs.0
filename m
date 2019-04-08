Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67C9C282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 04:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F1AD20880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 04:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Y3yfQ0Id"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfDHEfK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 00:35:10 -0400
Received: from mout.gmx.net ([212.227.17.21]:55111 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfDHEfJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 00:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554698099;
        bh=IQC3XetucnjsQ5lIZFvVN9fgVDhWd/nFxsgkY27zIF8=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Y3yfQ0IdHZUDGi69Fxrt0vfb26JIgS7ZOxnF53Xlhl8awQ4cNm9Nbjyjynj/cDSTe
         ik2qPEQeOkw8hNqfn/kIzvh2R7DRgjs+0fzXTtNYRuA/rZHXX+WO2ciZN1cwCYmwKW
         VZT5JnPk85h1uyatuv7EyGkxYd+rruSA4eQ8A2rQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LjN0F-1gcd0I42RT-00dT1T; Mon, 08
 Apr 2019 06:34:59 +0200
Subject: Re: [PATCH] btrfs: tree-checker: Don't check device size as we can
 have valid 0 total_bytes
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
References: <20190408042756.25969-1-wqu@suse.com>
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
Message-ID: <c14dc283-69ef-8ef2-e314-8e144ecfd3fe@gmx.com>
Date:   Mon, 8 Apr 2019 12:34:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408042756.25969-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UjY7zsOIL9XARNVDKgtpERCpmWDLvafS1"
X-Provags-ID: V03:K1:R4zJ+fr7mNfWTGYQIT5guWuYDRxyvitS5EcLrnUOpE/KuK0KV/z
 Cjau6QByy/Ig8RMaDDUhz70uxZ5HzV4hM0zix3VUpMWitz1Jh7sTXKBhd5pso7KXmydODSI
 ParlKSx37bg3p7ZolO+siB/0PZN6naSqYYLQglpmta0PHImza6o3lYoVS4wGxqRKLiej0s7
 is9kI1m8HnDDDkXm0sxvw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8R6rFTBwrts=:XZeN2mqZmvlf8iEw9vniUk
 v9ozuRpm0fJ80U5nVnr5KVYCJLPL18CNAFbcPBnbT+1OUpftNCbBVUHU1HqxiIBaUeyeDxI+B
 KfH6xQLEsraYkrizp9VdN1evseh+WKxY0xAlUgRWZBv60OO5zuW51gy96X22wlq76ebKUHee8
 P00tHv91AsWNyZSoztVM04/LpuW9pvAiwmxUmK0/HqEEWeBoZyHXoVu7ZeVFvj2hEJvP4UyBD
 qZKMYDHj+cnjBGVsruh313K/7hyYAdLWVgoD09PPO15I/Ne8GtuG54a6rK4aICG7pRoEKxGvt
 kbWMzR1YCJAaeEOAdS1r0t6Rpvrgpbv8kljUh51+g50z4YwiZ00gZlf9QmA6tg8pjCSvNAxeD
 GtuYdul6VaCsQz+lrQ98aVI7xx7gHkq4BHJZINCU1oeqkptyuRjEsS3IvMOWFrvN7xa4lYnsN
 xri1ulANsS9IR7ucVWF8QJo/0LcipYTQ0LS4MErBFp2/jt37yH4wn7dfQRi6+lg+Tp1faPHlW
 MI6kdG+FrMKZ4k8tRHBywhQYwM1h7HHSBhH5ZLzdF4FJBWttwKgGJO1Xw6wUu0bmRvgyV9LiK
 zDca4herV5HSpQCZBOro3+CjR17td35/QoII34pEtLJ+zWyY3jPMkZcex5MNsU9iYNRVBRz7b
 Qkb1tAP0CQpClBcvEqObw7QwR55d5qlCWEtDq3OHSKmXe5K9IcLtDoiG/54qDDQUNx42056Wz
 bGeMATmTOhC6hmwvGYJ7cABETlzFx+fuW+e19w/sCRtXywOcRiqCX16iItWepCvAmTH2LD3Lg
 91cEZ8xsuiKwREpDXLOtCgsmkDDMLd7sP6dHq0ZELaPISa6vlYXNv3uM4me1hV151I3QR2aDj
 LtMQpDixhJkYuwBs2ROFzF31kOdR085fJczaUOYsnnqC2xjbqoordYHUdCRbe+
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UjY7zsOIL9XARNVDKgtpERCpmWDLvafS1
Content-Type: multipart/mixed; boundary="AghTU2FEnUKwLo9P0gXRi63YboJ0cYjGI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <c14dc283-69ef-8ef2-e314-8e144ecfd3fe@gmx.com>
Subject: Re: [PATCH] btrfs: tree-checker: Don't check device size as we can
 have valid 0 total_bytes
References: <20190408042756.25969-1-wqu@suse.com>
In-Reply-To: <20190408042756.25969-1-wqu@suse.com>

--AghTU2FEnUKwLo9P0gXRi63YboJ0cYjGI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/8 =E4=B8=8B=E5=8D=8812:27, Qu Wenruo wrote:
> Under the following call traces, btrfs can commit device with 0
> total_bytes onto disk:
> btrfs_rm_device()
> |- btrfs_shrink_device()
> |  |- btrfs_device_set_total_bytes(device, 0)
> |  |- btrfs_update_device()
> |  |- btrfs_commit_transaction() #1
> |- btrfs_rm_dev_item()
>=20
> This will trigger write time tree checker warning.
> And further more, this can create valid btrfs with device->total_bytes
> =3D=3D 0 and triggering read time tree-checker if power loss happens af=
ter
> above transaction #1 but before next transaction.
>=20
> So this dev item check is too restrict.
>=20
> Please fold this patch into commit 87d87c6dcbbe ("btrfs: tree-checker:
> Verify dev item") in misc-next branch.
>=20
> The fuzzed image can be already addressed by commit 1b3922a8bc74
> ("btrfs: Use real device structure to verify dev extent") thus we don't=

> need that strict check anymore.

Just a kind reminder, folding the patch will be much easier than my
original purpose to discard that patch completely.

Discarding causes at least 4 conflicts, and will be a pain in the ass.

Thanks,
Qu

>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index d2c3c1f8870d..974208ac56da 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -657,16 +657,11 @@ static int check_dev_item(struct extent_buffer *l=
eaf,
>  	}
> =20
>  	/*
> -	 * Since btrfs device add doesn't check device size at all, we could
> -	 * have device item whose size is smaller than 1M which is useless, b=
ut
> -	 * still valid.
> -	 * So here we can only check the obviously wrong case.
> +	 * For device total_bytes, we don't have solid way to check it, as it=
 can
> +	 * be 0 for device removal.
> +	 * device size check can only be done by dev extents check.
>  	 */
> -	if (btrfs_device_total_bytes(leaf, ditem) =3D=3D 0) {
> -		dev_item_err(leaf, slot,
> -			     "invalid total bytes: have 0");
> -		return -EUCLEAN;
> -	}
> +
>  	if (btrfs_device_bytes_used(leaf, ditem) >
>  	    btrfs_device_total_bytes(leaf, ditem)) {
>  		dev_item_err(leaf, slot,
>=20


--AghTU2FEnUKwLo9P0gXRi63YboJ0cYjGI--

--UjY7zsOIL9XARNVDKgtpERCpmWDLvafS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyqz2gACgkQwj2R86El
/qj+/Qf+JHihYGkvO4/o8gKPEBn7n4enxov7+XHXVBTotGBFxUgiJ+aa/5ILw/Up
KUjmbY5lypIp/FnliGmenxqvlvG0EMnUi9HE1MVjoOsNPFoCRJkApHSFLm1D4AmH
3uRJ/cLA1YEaxVVaZJTCZbffXCwwHc3IqSoOtEoMOqpwUKq98MWXjB366TYGfwMi
S266tnto8N7piK93LJb0Ncy7eROEBn9s2bkEQPfsWkQ3qWMz5lHzU/g4+NQPqSKz
kazCHMikNKDvpIIGU2PzAFYsdRq8dvSdgGhPMAd0R52sW6T063zy28FxZAJ9Wp9O
srUTESCW3P1H3NL8X1DwtEIGGNpnxA==
=ZlMY
-----END PGP SIGNATURE-----

--UjY7zsOIL9XARNVDKgtpERCpmWDLvafS1--
