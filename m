Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F7AC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1EC72184A
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="HJvkdX4o";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oKUR3Go+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfBLHUz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 02:20:55 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35669 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbfBLHUz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 02:20:55 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id D73DB2315F;
        Tue, 12 Feb 2019 02:20:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 12 Feb 2019 02:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=BUTxAxLnP/pkA5zaufjOZ0Wyg2L
        Xj1ke7yv4yI0Bk4I=; b=HJvkdX4oH/rcltzHqZTXpl153Ebf+ftnOpXWaBoN3p1
        ocqINhKHv3weD0ZdP8vsOV+9bhwdj7BxK7AT0YnwgQDL0tILSW6axNQdZpH7OhUr
        r+nQMz7P2H6zQvZZzinJwE3nzfvJNxLk0rAw5p3Cr+XedNtq6XpiVXDSmuuUOrO/
        aVJ0H+lH6WfPQr3czCIjFv81MH0xqBSHLSLLu7RClpIWDoz7qUC18ejUWl41iaxF
        44UobC+O037CuBOMkq+9RGZDjsPRMQ2MJSKBr/0p2P01atfaSpsefOCcT6r7xlIc
        eePrVqsJH+m3johjJ1IInzQlN+JW+P9RTrqzldgy/dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BUTxAx
        LnP/pkA5zaufjOZ0Wyg2LXj1ke7yv4yI0Bk4I=; b=oKUR3Go+oRwWteI8VrqWGK
        O+VwtNCShLWBXuGHGxPEUR1ar11XyVstbLDJIs6DFQtN7i1cOHjut+62NPKnSDEh
        VKpD5SgHm21EJQs/4VJSgkcw9ME7XsPdlCeJo+9S03gWgKnDUzpexrDVpp3022pG
        tP0AlqjiTKZSMeVG6fnysZkumQh0M6t7IH3bRL/GbJNexKA8rUt2dIes+kaANcp0
        0xRFv9kouCgyNE6E2yAenS+6fTh8tnvLfqHOhWoQq9TwZcoH/fJ4sOPEGI0aCiSr
        iNuy9JWxTgET03Pze+GmHnJreukg9ltXMjq01l5zVs4mH0GmnQou2ow5bMi9srcA
        ==
X-ME-Sender: <xms:1XNiXI_gTe58cmYLldBGgtFVkS94SnymekMmo2RMS2ktC4rpW87YpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddttddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecu
    fedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkf
    fffgggjggtsehgtderofdtfeejnecuhfhrohhmpeftvghmihcuifgruhhvihhnuceorhgv
    mhhisehgvghorhhgihgrnhhithdrtghomheqnecukfhppedufeehrddvfedrvdegiedrud
    efudenucfrrghrrghmpehmrghilhhfrhhomheprhgvmhhisehgvghorhhgihgrnhhithdr
    tghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:1XNiXHBfJgi1JSMm-Mms1QxkReJGJwLTfht0-nvSE3nzUv7QacbaXg>
    <xmx:1XNiXEC44f7j0W2xdFSK1-tzTDEO2edVc1ElTniUdYzufWgrLNvGrw>
    <xmx:1XNiXFyUoQtHz2cOxfOx0i80csAjIrV5OE9nnjS4bXdSHs2DQXF0gQ>
    <xmx:1XNiXDPKF_oBB9dnhrSz_Xl8A_anr6genNpIxlq7By9bzBg6Juv7hw>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE456E4652;
        Tue, 12 Feb 2019 02:20:52 -0500 (EST)
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190212070319.30619-1-wqu@suse.com>
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
Message-ID: <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
Date:   Tue, 12 Feb 2019 02:20:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190212070319.30619-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3U3kNy3vWnxRdbc9hBmCp8V7XUkD5nKuI"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3U3kNy3vWnxRdbc9hBmCp8V7XUkD5nKuI
Content-Type: multipart/mixed; boundary="F2vmnEQjRy8MxqWQPQmxbRCRDHZqCZ4oD";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
References: <20190212070319.30619-1-wqu@suse.com>
In-Reply-To: <20190212070319.30619-1-wqu@suse.com>

--F2vmnEQjRy8MxqWQPQmxbRCRDHZqCZ4oD
Content-Type: multipart/mixed;
 boundary="------------B0853D179C1176DB813CCBDF"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------B0853D179C1176DB813CCBDF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-12 2:03 a.m., Qu Wenruo wrote:

> So we only need to consider missing devices as writable, and calculate
> our chunk allocation profile with missing devices too.
>=20
> Then every thing should work as expected, without annoying SINGLE/DUP
> chunks blocking later degraded mount.
>=20
>

Does this mean you would rely on scrub/CSUM to repair the missing data
if device is restored?

--------------B0853D179C1176DB813CCBDF
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


--------------B0853D179C1176DB813CCBDF--

--F2vmnEQjRy8MxqWQPQmxbRCRDHZqCZ4oD--

--3U3kNy3vWnxRdbc9hBmCp8V7XUkD5nKuI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcYnPTAAoJEO9Tn/JHRWptXY0IAIfa2lL8QUtZaWE8NyJiRK9P
3xOF4RQV9NUjuDrgtH93dq58pTNB48k+UiTAv/7NSqX0n3Nud2N/YfXPbBu05Icp
i6Ae1EAxVc2K5AbuJK0aYm2y7ALs6nw7qcQxF8kUxuT5Etteu2AqWYcPGWs7Wuo1
lgpsK/tc93I+LUtW2z5Z54QDX4W+7Ndu7Mn1Hd1JWfv6sTU/XQlNxcgJuEv3Ymsb
mvzxOSQO5esIvCGvuvOGNQ+uWvAfqEU588AGF32Po2N8q1ioCIZjRBxR2byrFhXC
+suLCOEIvQthwhU3It4E0TP8XpIGuWVja7ykjs0yrn3MdHjrKAXj5ToQkEdmido=
=9Imv
-----END PGP SIGNATURE-----

--3U3kNy3vWnxRdbc9hBmCp8V7XUkD5nKuI--
