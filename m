Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9F0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 04:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5180F2087F
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 04:23:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="UnbsFUge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfCYEXV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 00:23:21 -0400
Received: from mout.gmx.net ([212.227.15.19]:43723 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfCYEXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 00:23:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553487798;
        bh=2aTBZQ0r35vmCXUohFO5nIPuozj/g1tXqiUz+kAvvrQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=UnbsFUgeqyfvPmDYcxeSeGZZcX96rfIDXC6mrB8HSPd298nHhiiIGFf3MAPqIeg39
         MsA/xfDvZCSdq8MVtFMwRM7tDRJhjB/IuD+CxoAUPHmWqBUeqnr/cQfxkQE3tfb88h
         /pqZCZHee204/2QtA4yhIgdFbRKHtA/oEUn/HXNI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MSMP5-1hXGnu0iqZ-00TYU7; Mon, 25
 Mar 2019 05:23:18 +0100
Subject: Re: Fw: kernel oops when mounting btrfs
To:     Chris Murphy <lists@colorremedies.com>,
        Thorsten Hirsch <t.hirsch@web.de>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
 <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
 <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
 <CAJCQCtR6FKOiNXupU-6UVX-zKzwmg848Jok_z-VStAwtjoGdEQ@mail.gmail.com>
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
Message-ID: <d297a788-a591-477e-a54f-31cb45ca37a1@gmx.com>
Date:   Mon, 25 Mar 2019 12:23:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR6FKOiNXupU-6UVX-zKzwmg848Jok_z-VStAwtjoGdEQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dqE8XMZTeUrhhsknsqgqQeYoGCGlaLY2n"
X-Provags-ID: V03:K1:DjewzLI9aSlYEObTbBhQB6jVcr94gH06cOu6AoYHbx5A3okI+9c
 wAWKnH+xxCjduaiL6tEGifwiTTPL2Rynm0mqweeqo1WwvqYPXVV2AsDfa+71BmaEYqX7560
 SJg/TKK5C03DWzU76NiSg7pRILhR3YtXi1Kfrj4/j86UnAhajA0KZ7zTs9ZzGqAxIAqfZfo
 5A/7rmsSdCD4lA3FemxtQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WP/WfP63mCM=:oLISI28/8FyepDFGSFwvZn
 uJChWzvBHE5/j/o4OcTnN20g+4/ICTBcLEFaHqOlQ/Fhgl/OoJVdfpkE1lYs1EHPWsogupvAn
 zTMQp4AOoLoTTTl0J7A09S9Y+BmzBbt/K/Ydhi9q2WWLmU6mELx8hte3I4vq2ZzR3A+oNlpQj
 fBx8pD4xZ+f3itDYO9+Y7XEsFQQz32V4bo5/ZkkZLS/YanuXKTlAcI9M89hVcg77AHyS8HWrM
 5A3RJdmBmo+rlAsT/pQDBCU1ktLrFCBG2KoFczIIaJ+d0oJqfoxf8xEGRT42HFCJvL+QlXz3V
 vQOxNI3w0p8HkAu8T3QV9Q7pSe0+rdc2Tb9X62dtDZrtl94yx1DiqbDs+UV9BgpltDSZspDql
 u+2jhEE7+aVPhRMbnrBJYMBpI8wyibkLhehLhiV/7i51+VgrJsmSHJ9ss8FP6ZAC3UgjTEgpv
 WOHHAoLDHoG+7H/Y/31GcGbzyw4xd/RfPb8pnkkQTios8SyoaR7KVhy/v5rf5dJTeFdI9jHO2
 KoWDQX/dLiRSCCO9TYQE9Ga5/1mReXNRJamZzuI+E+5M4CInM8saMfrT1FCcQ3dxB1IhEQGOt
 xspVMC6sJgJWLooyCE4zqgZ1ph/ITx8uJRpIN1jyzCIN2jnupLLsLsVF32Ibr2ZTwNb+F3luu
 6mAWycdJS8qKOFLob5prpoLyDNgVMNVQIP6C1CKK1L7qUzrPalbp/EsD379loIgHjt/ZPLrOC
 YjXhW+zgIcijHdblUDX1o+J6TMHSowE2hozWIjWQZ+rsXIZFmAbzvjW0FdeoSF5us9oO0npOK
 1ZYwAjAzpRfYuWESTs4JIKA1Z9+9wtv8SdEdMjU9M2/65A4fhrCQLczzSwOH4lWcuPy8Akmv4
 Bn32sfNQ7H8pA6XMPUHiITCM9EFRSCB8bK1RLmNQPP3Joyrn8kGE65grRW9kER
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dqE8XMZTeUrhhsknsqgqQeYoGCGlaLY2n
Content-Type: multipart/mixed; boundary="4VIrHLwKrPewzk36EwLjSQXKlagnjdb1W";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>, Thorsten Hirsch <t.hirsch@web.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <d297a788-a591-477e-a54f-31cb45ca37a1@gmx.com>
Subject: Re: Fw: kernel oops when mounting btrfs
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
 <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
 <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
 <CAJCQCtR6FKOiNXupU-6UVX-zKzwmg848Jok_z-VStAwtjoGdEQ@mail.gmail.com>
In-Reply-To: <CAJCQCtR6FKOiNXupU-6UVX-zKzwmg848Jok_z-VStAwtjoGdEQ@mail.gmail.com>

--4VIrHLwKrPewzk36EwLjSQXKlagnjdb1W
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



[snip]
>=20
> This looks like the same problem I reported earlier this month, and
> also filed a bug for at
> https://bugzilla.kernel.org/show_bug.cgi?id=3D202717
>=20
> In my case I did a scrub and check before clearing space cache v1. No
> problems reported. And then clearing space cache v1 crashed. And then
> check reports corruption.
>=20
> Bug 1, for sure btrfs check clear cache crashing is a bug
> Bug 2, btrfs check appears to do non-COW overwrite of the extent tree,
> which might be fine as long as it doesn't crash but it seems risky
> considering how fragile the extent tree is anyway

In fact I think this is a bigger problem.

This breaks the basic metadata CoW, so I'm going to look into this bug.

We have enough tool to investigate this problem, but I'm afraid it may
need certain images to trigger.

If anyone is trying to try clear space cache, please try to take a
binary dump and provide it (if small enough).

Thanks,
Qu

>=20
> Clear cache right now is not fail safe near as I can tell. It can make
> an error free file system corrupt.
>=20
> If there's some problem already, before clearing space cache, that
> means more bugs:
>=20
> Bug 3, btrfs check doesn't find the problem, reports no errors
> Bug 4, btrfs kernel code doesn't find the problem during scrub,
> reports no errors
>=20
>=20


--4VIrHLwKrPewzk36EwLjSQXKlagnjdb1W--

--dqE8XMZTeUrhhsknsqgqQeYoGCGlaLY2n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyYV7EACgkQwj2R86El
/qiZugf/XJsnYkB+4OQBZwe6DLPhGxrM3VMtn/j5ZyzHFs9q6o+l/UDvLNlt4PUk
pqSq8Xm3fNQbsYt8/HG++UcuEkqAUvkmvo1gG1oo5/i0pnTToNlKxEyq/aYmZWAY
mFdtNwksEBnEbpOVxWs3uXpvqU2JG9HJmFDS22iOqx+PPg2fETHYYb23brafdQhb
zji6M9AKqCVIkF0cQtSjvtMtSqcUtVdetzDMwJCIk9cRUgMTIDDVdz+KwQobwd86
rsA2MTbIu3q5+XL+jzZ4rFr/aWVoBLwE6WHD2rnHXE47UntUWr/oIGZyGGSIiuPl
OgOQOeRJUZMxLeyWuGEqH1IqBzZdgQ==
=iAH0
-----END PGP SIGNATURE-----

--dqE8XMZTeUrhhsknsqgqQeYoGCGlaLY2n--
