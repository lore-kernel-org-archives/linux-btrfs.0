Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13D6C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 807C82082F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="pxsB/8iO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="j4ZN2t6S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfBLHzi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 02:55:38 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57655 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbfBLHzh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 02:55:37 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id E8D2B23733;
        Tue, 12 Feb 2019 02:55:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 12 Feb 2019 02:55:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:cc:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=/gzGyDzlTdaFu0Ow/U9rLN3JOr7
        xZLd27QkXYyEaECY=; b=pxsB/8iOtITLkv6i2YRUsHI0XG9pFbYFGCaZ9IoUxLg
        bvt5MJnWLyoqPnP9wvPf3jMny9fQP2CdJarsPrGD0Bk99IMykllyxmha+XU4Y7sb
        S2lruyMEYxDgPK+6GNLGgT5IpydM6y4qItht5O+sUQ2LQ9fIqiViRLR6wmvIwEUI
        /ImGWfLO+obPKhq7z2Ay7S4G1Z/Dv8gf6TZ4F2lMkJycDFxKpKmvioRgcofz372e
        Xy+jKiPINO1oJWZiJ1H6oOosgUvegDXteup+i4aFe76yZfFKo5feo6N1rqcVPe6i
        H6dOA4RjO4q3JFsTKQUFW6jspH/dejGfx/owvBNknpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/gzGyD
        zlTdaFu0Ow/U9rLN3JOr7xZLd27QkXYyEaECY=; b=j4ZN2t6SvcjNHwjbyvoCzx
        +zlqZoe5ssz1rgn1TDK9piNTCMIQ77vFCCCh6ctHezQ3q99iyKZUAj3vSbCULTuA
        vhhBz5G3j2NuHm1JcvoD4fab6o1B1IGLZ2R2b1Ge6lsz+ebQHmUr3BwlXECFh/7L
        GvrLpuZ7TEmGoG1obF0N3oPaaDESFwq1hdCcKDv/hLQSk2mx5PTKbhdWdSn3Daub
        qNe2z3Hd5iHKYzx7ec286cSJCWq4ieKFXS8ZgGDLdiLjszLL4Ej8ullcM+OZRoC/
        5l7W6rVOtfCwu8z5D9Alrtl8xS9WcK03g50hAqldfNXn7ZCFbI42yTyZqScx7/3Q
        ==
X-ME-Sender: <xms:9XtiXBkINrPdteu9dRxJ3m7GQgdK_YE78M2lRro3MoryeY3Gp4uECg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddttddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecu
    fedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkf
    fffgggjggtsehgtderofdtfeejnecuhfhrohhmpeftvghmihcuifgruhhvihhnuceorhgv
    mhhisehgvghorhhgihgrnhhithdrtghomheqnecukfhppedufeehrddvfedrvdegiedrud
    efudenucfrrghrrghmpehmrghilhhfrhhomheprhgvmhhisehgvghorhhgihgrnhhithdr
    tghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:9XtiXFcwaQ_JKMuT3HgXOlTLvJNuZUbUpasXtpMV97gmvuP8ObumpA>
    <xmx:9XtiXLl7emM0JTvyA0adVZbc5O54lO5Sol3KtMko86AirHyDRStl3A>
    <xmx:9XtiXHDf_VQilAiaJgtXrTVU6bKE-68ElwCnPM6wcDCWn69qrZxVJQ>
    <xmx:9XtiXFNWFJSdBABNYiU03uPZw_6DMUhQfJShCl7KwpezOBX1zwdK5w>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18DDFE4652;
        Tue, 12 Feb 2019 02:55:33 -0500 (EST)
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
To:     Qu Wenruo <wqu@suse.de>
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Remi Gauvin <remi@georgianit.com>
Openpgp: url=http://www.georgianit.com/pgp/Remi%20Gauvin%20remi%40georgianit.com%20(0xEF539FF247456A6D)%20pub.asc
Autocrypt: addr=remi@georgianit.com; prefer-encrypt=mutual;
 keydata= mQENBFogjcYBCADvI0pxdYyVkEUAIzT6HwYnZ5CAy2czT87Si5mqk4wL4Ulupwfv9TLzaj3R
 CUgHPNpFsp1n/nKKyOq1ZmE6w5YKx4I8/o9tRl+vjnJr2otfS7XizBaVV7UwziODikOimmT+
 sGNfYGcjdJ+CC567g9aAECbvnyxNlncTyUPUdmazOKhmzB4IvG8+M2u+C4c9nVkX2ucf3OuF
 t/qmeRaF8+nlkCMtAdIVh0F7HBYJzvYG3EPiKbGmbOody3OM55113uEzyw39k8WHRhhaKhi6
 8QY9nKCPVhRFzk6wUHJa2EKbKxqeFcFzZ1ok7l7vrX3/OBk2dGOAoOJ4UX+ozAtrMqCBABEB
 AAG0IVJlbWkgR2F1dmluIDxyZW1pQGdlb3JnaWFuaXQuY29tPokBPgQTAQIAKAUCWiCNxgIb
 IwUJCWYBgAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ71Of8kdFam2V1Qf9Fs6LSx1i
 OoVgOzjWwiI06vJrZznjmtbJkcm/Of5onITZnB4h+tbqEyaMYYsEIk1r4oFMfKB7SDpQbADj
 9CI2EbpygwZa24Oqv4gWEzb4c7mSJuLKTnrhmwCOtdeDQXO/uu6BZPkazDAaKHUM6XqNEVvt
 WHBaGioaV4dGxzjXALQDpLc4vDreSl9nwlTorwJR9t6u5BlDcdh3VOuYlgXjI4pCk+cihgtY
 k3KZo/El1fWFYmtSTq7m/JPpKZyb77cbzf2AbkxJuLgg9o0iVAg81LjElznI0R5UbYrJcJeh
 Jo4rvXKFYQ1qFwno1jlSXejsFA5F3FQzJe1JUAu2HlYqRrkBDQRaII3GAQgAo0Y6FX84QsDp
 R8kFEqMhpkjeVQpbwYhqBgIFJT5cBMQpZsHmnOgpYU0Jo8P3owHUFu569g6j4+wSubbh2+bt
 WL0QoFZcng0a2/j3qH98g9lAn8ZgohxavmwYINt7b+LEeDoBvq0s/0ZeXx47MOmbjROq8L/g
 QOYbIWoJLO2emyxmVo1Fg00FKkbuCEgJPW8U/7VX4EFYaIhPQv/K3mpnyWXIq5lviiMCHzxE
 jzBh/35DTLwymDdmtzWgcu1rzZ6j2s+4bTxE8mYXd4l2Xonn7v448gwvQmZJ8EPplO/pWe9F
 oISyiNxZnQNCVEO9lManKPFphfVHqJ1WEtYMiLxTkQARAQABiQElBBgBAgAPBQJaII3GAhsM
 BQkJZgGAAAoJEO9Tn/JHRWptnn0H+gOtkumwlKcad2PqLFXCt2SzVJm5rHuYZhPPq4GCdMbz
 XwuCEPXDoECFVXeiXngJmrL8+tLxvUhxUMdXtyYSPusnmFgj/EnCjQdFMLdvgvXI/wF5qj0/
 r6NKJWtx3/+OSLW0E9J/gLfimIc3OF49E3S1c35Wj+4Okx9Tpwor7Tw8KwBVbdZA6TyQF08N
 phFkhgnTK6gl2XqIHaoxPKhI9pKU5oPkg2eI27OICZrpTCppaSh3SGUp0EHPkZuhVfIxg4vF
 nato30VZr+RMHtPtx813VZ/kzj+2pC/DrwZOtqFeaqJfCi6JSik3vX9BQd9GL4mxytQBZKXz
 SY9JJa155sI=
Message-ID: <406ce62a-6ff4-af73-b7fb-69733ccdbdc1@georgianit.com>
Date:   Tue, 12 Feb 2019 02:55:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g6tLj3vo9qAIntNfTJ6wblzycdt5PNkZd"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g6tLj3vo9qAIntNfTJ6wblzycdt5PNkZd
Content-Type: multipart/mixed; boundary="XV55AjcjQgiB4H34CX2HujfWiOk8zLGwN";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: Qu Wenruo <wqu@suse.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <406ce62a-6ff4-af73-b7fb-69733ccdbdc1@georgianit.com>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
In-Reply-To: <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>

--XV55AjcjQgiB4H34CX2HujfWiOk8zLGwN
Content-Type: multipart/mixed;
 boundary="------------E5A1994BD5F30BBBF30114D8"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------E5A1994BD5F30BBBF30114D8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-12 2:47 a.m., Qu Wenruo wrote:
>
>=20
> Consider this use case:
>=20
> One btrfs with 2 devices, RAID1 for data and metadata.
>=20
> One day devid 2 got failure, and before replacement arrives, user can
> only use devid 1 alone. (Maybe that's the root fs).
>=20
> Then new disk arrived, user replaced the missing device, caused SINGLE
> or DUP chunks on devid 1, and more importantly, some metadata/data is
> already in DUP/SINGLE chunks.
>=20


Maybe the btrfs-replace command can have some magic logic attached that
checks for single/dup chunks after completion and either launches an
automatic convert, or prompts the user that one is probably needed?




--------------E5A1994BD5F30BBBF30114D8
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------E5A1994BD5F30BBBF30114D8--

--XV55AjcjQgiB4H34CX2HujfWiOk8zLGwN--

--g6tLj3vo9qAIntNfTJ6wblzycdt5PNkZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcYnv0AAoJEO9Tn/JHRWptLAIIALmKPOxvwT51Rqu4oWbbhufZ
5QidmvmFiujbMWQxMg51sEefHUqaCm6zKmiXuRMYKKFpH7HHiDy7AXJ2LVQn/u9W
+xKBR2NsLiX9bakmGRVFN1lv2dYl9WuijkcLXFeiqL2YRZ8vqNAnIVsJ0sUuHTmF
VwZAAHqNklOoAr0kWLnkhlw1QZn7jldYqpXA7wZ3KzqmAlww7rXTSF/zA44WzRRc
/UAgPMxTibA2C+mtYVhGeC69wjPQre9On15id4QFLew6Uc9x5tVVqACXpzekoQ76
p84lY9lOm1JYsEEAfMPLuwmLWZKXD4zLfPdh5Rzax5TvgyxVbwHyj7mb6UDpSDU=
=8Uqe
-----END PGP SIGNATURE-----

--g6tLj3vo9qAIntNfTJ6wblzycdt5PNkZd--
