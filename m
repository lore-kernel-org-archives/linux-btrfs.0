Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81286C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48FF9222A1
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 19:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="L72Q5XG3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cItpJjC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbfBOT34 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:29:56 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41295 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbfBOT3z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 14:29:55 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 0E1DA329A;
        Fri, 15 Feb 2019 14:29:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 15 Feb 2019 14:29:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=P5B8I61xbOVSK0GEr3ZGx984nh/
        zxQFGDIKnEI0Bjco=; b=L72Q5XG33FQcTU8ybrrdvEFZaEcDrJJ/ZEazofgbsHE
        rNwLeHPkRmHdoeugdrh+WCcPqZQ97C/sN6IkMeqwETSIkjWjlx9yhejF6uwJPmRF
        7t7eswLIjc25IuYccYfhvnHbddOy4exUrZHayhpZC3klvTDOSFb0odnt1S4LE3aY
        YQkNcRN2C2D0TwOjcAInlTJz5l+bPZUlt9P9MiSsZr6GEZKKO7zpw8+to1DD2Wj4
        TWNIB7YuM1Pb50TzOz5kvAgEQHiSwR8V24D2a8T2Wh+MGOWmxmISMwEsOU6kzpmr
        qFrSRJVn0ooxBqWDURWarcId6eldUwcDv0sYcwPqtMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=P5B8I6
        1xbOVSK0GEr3ZGx984nh/zxQFGDIKnEI0Bjco=; b=cItpJjC76pjjW2D7phf6KM
        KIVm71zCWGhB/E/ZOSHP0YJ6a7NNA7635ZDnVzzeRCudTHiq7KIxoTXEtfP06OBH
        5WNn06lSuEPWBy9zFg+OiB7imJquEb9m7vbYVQ4r8nouOGu0+8oRs/CyhxLBi4+Z
        u11bP75lOAbQL8iVlCoWd8v169c2yVg4Mffyz5scIVFyFr9iNtbCgX4pSU7K5TBC
        YC675md6U9qDti6fpfDjf8rLjySthsQKUy+ESwkkJWsF1cyRQh3mAndiXzNpYZuq
        ZQJWf5T6Oa2G159J/PbLni3b9pk1pfPpv4L/y+zZ2eF4t+PGZR6ceM/Bk2Sj5Pew
        ==
X-ME-Sender: <xms:MRNnXGteOF_T5zO-lFWyr-rUa3ARr2l2W8tMnCca8Y1_tL76boRvUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddtjedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecu
    fedttdenucenucfjughrpefuvfhfhffkffgfgggjtgesghdtrefotdefjeenucfhrhhomh
    eptfgvmhhiucfirghuvhhinhcuoehrvghmihesghgvohhrghhirghnihhtrdgtohhmqeen
    ucfkphepudefhedrvdefrddvgeeirddufedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hrvghmihesghgvohhrghhirghnihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:MRNnXClcFTIzvDeio1bZ2QDsSWqHeyPpIY_eI9yKmiTQqiXfNxTaLQ>
    <xmx:MRNnXEHqSMvPeIoPqfXzmCkSQ9_Z3zTkK-bf--T_MLAKT4tfbCq2hw>
    <xmx:MRNnXJ_Gr_ssx0Tliw1O-pcYpRIr8pihlzkT8CC3mCfwdCzSP8Oj9A>
    <xmx:MRNnXLNkVh0rUOQ7_f8kVjsb63wgM1NP29KePgRi3PFbpxMqk9YCHA>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5EECAE4649;
        Fri, 15 Feb 2019 14:29:52 -0500 (EST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>,
        linux-btrfs@vger.kernel.org
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
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
Message-ID: <681b0522-12ba-9da8-a143-019711e68260@georgianit.com>
Date:   Fri, 15 Feb 2019 14:29:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7jRUdPOlm2upj5nxEAIpWE1CZ34CAEB6k"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7jRUdPOlm2upj5nxEAIpWE1CZ34CAEB6k
Content-Type: multipart/mixed; boundary="hhD908glHWtP67cf8i7q8T1jEvQODpD90";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: =?UTF-8?Q?Andr=c3=a9_Malm?= <admin@sheepa.org>,
 linux-btrfs@vger.kernel.org
Message-ID: <681b0522-12ba-9da8-a143-019711e68260@georgianit.com>
Subject: Re: Btrfs send with parent different size depending on source of
 files.
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
In-Reply-To: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>

--hhD908glHWtP67cf8i7q8T1jEvQODpD90
Content-Type: multipart/mixed;
 boundary="------------D06C3DA30618E3E52A2FD064"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------D06C3DA30618E3E52A2FD064
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-14 6:37 a.m., Andr=C3=A9 Malm wrote:

>=20
>=20
> The 'out' file is 34M, which is the full size.
>=20
> What causes this?
>=20

Just to narrow it down, the fault is the contents of the server.jar
file, not how it was created.

If I upload a urandom server.jar file to my own website, then download
it with wget as described, btrfs send creates a properly small diff

However, if I upload the actual server.jar file to the same URL, then
repeat the process, I again get a 34MB out

How often does this happen?  Did you just happen to stumble on the one
file in the Universe that does this with server.jar?  Or was there are a
wider context?


--------------D06C3DA30618E3E52A2FD064
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


--------------D06C3DA30618E3E52A2FD064--

--hhD908glHWtP67cf8i7q8T1jEvQODpD90--

--7jRUdPOlm2upj5nxEAIpWE1CZ34CAEB6k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcZxMvAAoJEO9Tn/JHRWptMSUH/1NAtgQkGVPKdCmYZDuzFCH6
RIHexBjDe5dK4XiOKceN0JZqcLghw+8/SRwYJzhH8PclZtOVRI03HwMTYH1JBD/h
XrOZBi5oGa4bljE8AEXavajTbZ7LgkXJqe42LgulUEE5TPaUg2/4XjxuxoxMYHbP
AeLt/UDy3S7yEt8mR3W4UiTEeEl/wetH62cn5hawkoGc6Gv8wBuoiStF0QrxvWR9
8wcjveIvFgQ9vxKNGej55G7/LhBIiVoeMWVYSiwFwVmTDcWfmgh3RigCniJ7sbbS
04hIoVON0D2W5IM9F2B5UcKPzJLpiGMkjFXQfKRlsQGzYH5LI6vIozV/m7+6JDg=
=pclJ
-----END PGP SIGNATURE-----

--7jRUdPOlm2upj5nxEAIpWE1CZ34CAEB6k--
