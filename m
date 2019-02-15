Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF410C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83A22222A1
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:41:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="oymxZj4T";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YSHF6SlT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbfBOTll (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:41:41 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41459 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729324AbfBOTlk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 14:41:40 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 35EBB32C6;
        Fri, 15 Feb 2019 14:41:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 15 Feb 2019 14:41:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:from:to:references:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=DGSYjYFucm673RJLpzx1oTMPrK3
        9uCGwtmlRmK1oLAQ=; b=oymxZj4TV+sEWkbFIIUMfUEknSoSimkMqB6aPMXWZA9
        AoLYh+vhsdDilxAuyRDH2EohY4t8PMqhNq2pn+HaubPdIxal4hMJU7LMrdtsHwI/
        +24fu6MfsjagmHG6kO+mtK2WEDnwkg5rfY2HlzVKdPkP9DvjHz8zfHL3IkQhK7DY
        AxCeCYmylYU9KMKG4/ZU8yvSHVGOKiTpZUf8wfZfrEePyfrPnKO3I0llE0Dn7XDV
        V1XDh9h0r+hHBodNyUpDbWTZdA4a8aJIZVCghrIPoBeTkHchpQvNbo2SCK7XhAi9
        y5gWox9K5FtbHDCKAbE4AJHuvDFSEfDcPsgC5ODFTXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DGSYjY
        Fucm673RJLpzx1oTMPrK39uCGwtmlRmK1oLAQ=; b=YSHF6SlTIQ57FwbfSAh3o/
        YJQ3xVNW58nX9IjCzX+TWMgie5a+7v7S5r7LYRiJMeYEjAS0+VkZhjJc3o1JiOci
        pVkJQDyCqpjxwS8lyLOXQzsEztNAKp1+p94sogphzeuoq9H0QU5Exw/i3KZLxIOz
        fGpGqA/cUDgLdyUQTxc7T/9Mj4MAxUmEj0W7MsuUhpiDLHVDPbXElEQfKtuuF4oe
        LvdqYrCKOFMd7Rv2F04uSkDP+IrO1QZbgH43hItnsc+rJIQ4Gb0bRQeeAx1cSudQ
        8UNCLLIO0JJTKYZxgr8zNPSJAwXNHwKjCg7GxZ8hQ8FqLn+xM3YD6ASg3hHjtKlQ
        ==
X-ME-Sender: <xms:8hVnXFLjfL2QUxKz-5-w9OFh7a5-QW0VUrxvsmWFe4ngDgTx3vj4kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddtjedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecu
    fedttdenucenucfjughrpefuhffvfhfkffgfgggjtgesghdtrefotdefjeenucfhrhhomh
    eptfgvmhhiucfirghuvhhinhcuoehrvghmihesghgvohhrghhirghnihhtrdgtohhmqeen
    ucfkphepudefhedrvdefrddvgeeirddufedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hrvghmihesghgvohhrghhirghnihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:8hVnXCXJI8v2ox7DhJZBWYb3ALCEnzfU1CUuiYT4ih0QquM5wGoALw>
    <xmx:8hVnXOLMyg2Ga2-rB3iQSXuNLHkSHHLrpQtgdT2YlEBFlN7SLdu-pw>
    <xmx:8hVnXPzLD2z8EY2ZW75sPs3i4KnFMTsYj6HyYpTXYz_RbbTvojNmKA>
    <xmx:8hVnXHmL2t8A9f5xhY3JmVRVKNZVXpXK-mtKJ4QYfYrdOZPPtmoVrQ>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id E5B80E409D;
        Fri, 15 Feb 2019 14:41:37 -0500 (EST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
From:   Remi Gauvin <remi@georgianit.com>
To:     =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>,
        linux-btrfs@vger.kernel.org
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <681b0522-12ba-9da8-a143-019711e68260@georgianit.com>
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
Message-ID: <1d54f22f-1303-76b6-7ddb-1566a75d3e8c@georgianit.com>
Date:   Fri, 15 Feb 2019 14:41:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <681b0522-12ba-9da8-a143-019711e68260@georgianit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JN3dx9Dhw11oNTf8eCmJQURt1TDkRcSn2"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JN3dx9Dhw11oNTf8eCmJQURt1TDkRcSn2
Content-Type: multipart/mixed; boundary="zLclh82GpkK31dI7S3j6MGVQ4fEouk0LQ";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>,
 linux-btrfs@vger.kernel.org
Message-ID: <1d54f22f-1303-76b6-7ddb-1566a75d3e8c@georgianit.com>
Subject: Re: Btrfs send with parent different size depending on source of
 files.
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <681b0522-12ba-9da8-a143-019711e68260@georgianit.com>
In-Reply-To: <681b0522-12ba-9da8-a143-019711e68260@georgianit.com>

--zLclh82GpkK31dI7S3j6MGVQ4fEouk0LQ
Content-Type: multipart/mixed;
 boundary="------------2B021123AFF130060D1915C0"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------2B021123AFF130060D1915C0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-15 2:29 p.m., Remi Gauvin wrote:

>=20
> How often does this happen?  Did you just happen to stumble on the one
> file in the Universe that does this with server.jar?  Or was there are =
a
> wider context?
>=20

I just tried with a random epub file, and again get the full size out,
so it's a complete mystery to me why a file filled with random bytes work=
s.


--------------2B021123AFF130060D1915C0
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


--------------2B021123AFF130060D1915C0--

--zLclh82GpkK31dI7S3j6MGVQ4fEouk0LQ--

--JN3dx9Dhw11oNTf8eCmJQURt1TDkRcSn2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcZxXxAAoJEO9Tn/JHRWptPEIIAINRXEjkSiAwPjdninpowuTY
/en7zX8IRp+Nto4+hYLct4pZH7pfEjNZOjru+yNBVeRorxzSrnoJYAv4EaqaMUFu
qtX2eun6PiZCWHDeES8FCNLL6NaGa48MlMtOEz0OUGut7cUxjv/XmzvrE3H3EEb/
ue6Cf5dw9FI3OPsc7OPZnUW1f2SPpSspIP5yALN/4gnjQFCfBByHdBgy2UEYVuPs
ErjaqBLmFQmscRG0rRqousbwU5UMStB2U3Zbzv3Q6o9+i7H3OrjzvSMQ5Upb75Yv
Dw6tYvFsHYF6STFmQfFZNsizD50kNnIlUbGxRGkEhQp2Sj9GxhH7ShrEKVi/Dds=
=Wloz
-----END PGP SIGNATURE-----

--JN3dx9Dhw11oNTf8eCmJQURt1TDkRcSn2--
