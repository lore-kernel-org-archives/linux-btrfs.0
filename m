Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590D2C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 06:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C52DB20870
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 06:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="bhiYs8dx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BsnhheOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfAVGHz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 01:07:55 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56853 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbfAVGHz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 01:07:55 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2019 01:07:54 EST
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 66716210F5;
        Tue, 22 Jan 2019 01:00:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 22 Jan 2019 01:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=from:subject:to:references:cc:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=jVT/3d0oKzbqkiNOL/gPezJ1FlJ
        ra6bzqiIcrnF+bFc=; b=bhiYs8dxejhowj1Moa1VNpOyZgKIOiHOAPIa/RFaVur
        9lo476fDFVJ+d7n2nc98sm00nwpxsyjzRZ7gMRUoyTlpDOJ5p4QhSa8RYGhYQjBJ
        2ifk3+3xE9SsGNp8+U6dOiFBUzcSfoLzH4dULs9icOXOTcBT8022wtKy/5VsrZQl
        tuvdxqVvp/AyxxlHraV5jKnBL53wAqTRigfzrKrV1q/gZipRBAHV6VxYh9n2MPON
        mUlM08yIMiMR7YH2UvGu0gU7+WXBEiBf2GArDorD+AJj+SxyMgtW3sTTI3wlvNTi
        rftW7igauMRK15/2FTgcnf7tpvODa+W+2sXxkEuKrEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jVT/3d
        0oKzbqkiNOL/gPezJ1FlJra6bzqiIcrnF+bFc=; b=BsnhheOCZxgyDeg9dWkV+P
        C6XovhctpTRqU/cbFGZ2NRzN+Q1/uxxRWD6mzZXcF6DRI7I0py4vwXh+BVHoE7jp
        YBOfdQ427oPgelRjO0slLmnXn22cY25KuRUH6sqBNAhk5H1HctTpP2ijW+biVF3t
        4KG6rZv4RToY/mb+BdnCYQUokib121l0Ke1rsc5DKOC7g8lve8oh108Wz4V0liqT
        doSuL6zFsOKMDBCQzO5Q+rYjWLHWvnqvbqsG6lvucsUdwIqCgn6QJKQPaNTl8X9L
        UfNEtrwwlr98TMc2KYp4elouSW83weLXgouCOuAf8L6PnAIjXznUGS39mfqPi3Fw
        ==
X-ME-Sender: <xms:brFGXO053hvppV0PSWRsXfALuLUiVl8zOyefBvpDQoO5DRxTum3VUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrheejgdeludcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucenucfjughrpefhuffvfhfkffgfgggjtgesghdtrefotdefjeenucfhrhhomheptf
    gvmhhiucfirghuvhhinhcuoehrvghmihesghgvohhrghhirghnihhtrdgtohhmqeenucfk
    phepudefhedrvdefrddvgeeirddufedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehrvg
    hmihesghgvohhrghhirghnihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:brFGXDhSbqbpx1ZwWaQOE05SRKkf21NglmgCbo-yRiW88ZKIVq_VOw>
    <xmx:brFGXHEXHHZfFfs4M7JWsnzh2-1_1IQ8vMjZxMQ1Q833qCb3Vaj7Pw>
    <xmx:brFGXHUyaLCblxpp98Q4KYMoB2Y0JcquYIyo6edeuylMev7Hq-WJVA>
    <xmx:brFGXL5ef9xz1tDcoaBpynFCd4RWyrqv_rVBwA3AG1BSP-Uqdq3ONg>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id EECC1E40D1;
        Tue, 22 Jan 2019 01:00:13 -0500 (EST)
From:   Remi Gauvin <remi@georgianit.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Chris Murphy <lists@colorremedies.com>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Openpgp: preference=signencrypt
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
Message-ID: <f3075aa9-d475-43cb-45eb-e02acb1d2868@georgianit.com>
Date:   Tue, 22 Jan 2019 01:00:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TSsCDyyFjMkb1rXAMTDcbgAOIvQLiRlzq"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TSsCDyyFjMkb1rXAMTDcbgAOIvQLiRlzq
Content-Type: multipart/mixed; boundary="KPQcvlH29AAb8MAyTlLTEDRwG2dWrY2Ja";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f3075aa9-d475-43cb-45eb-e02acb1d2868@georgianit.com>
Subject: Re: Incremental receive completes succesfully despite missing files
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>
In-Reply-To: <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>

--KPQcvlH29AAb8MAyTlLTEDRwG2dWrY2Ja
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-01-21 11:54 p.m., Chris Murphy wrote:
#
>=20
> I expect the last command to fail because 1.ro1 is not the parent of
> 2.ro2. The command completes, and 2.ro2 is on the destination, and at
> least in this simple example it contains the expected files. However
> 'btrfs show' indicates that the "parent UUID" of 2.ro2 is the "UUID"
> of 1.ro1, which is definitely wrong. So it's a legit bug, not just a
> cosmetic problem due to lack of error checking.
>


This is, as far as I understand, exactly how it's *supposed* to work, at
least, as documented.  The only relationship needed between a "parent"
snapshot, and the snapshot you're sending, is that the parent already
exists on the destination.  Your example would be completely
counter-productive, since there is no data shared between the two, but
perfectly legitimate.  1.ro1 is the parent of 2.ro2 because *you
explicitly told it to*.



--KPQcvlH29AAb8MAyTlLTEDRwG2dWrY2Ja--

--TSsCDyyFjMkb1rXAMTDcbgAOIvQLiRlzq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcRrFtAAoJEO9Tn/JHRWptUQQIALrhMpS17U/NonHL0xnOIAYl
TGP8ZvNvVDU0hLcUbRoQOGYoQ8aLwQXQfi6S+vkCGei6kuZcBP7N+gBbNNypB/cM
D89Ocn1psscgEVAYL18nI8PXRFaWgCAAiYLyTZng29YxDRLV9el4YXgEKFh8PNse
pah13QeJe7ND+p8CXr2hz34rGV/uF9ddYZ4Hi+Hjs4wGTFZLg32rJ+yOt90CoMgY
UaTjsvn7KOp06z7IrpP7A0p+e0EgJIQlN3R0iOb7OIkVs+PmvQ4Xo8MsY5F1RRB4
nGgVTouzCfZ3Elvrya7qbPclMz4wkQTCz6Rc8AjcQlZ+3PYwcWZFFAtl+ILyHxs=
=FVQ8
-----END PGP SIGNATURE-----

--TSsCDyyFjMkb1rXAMTDcbgAOIvQLiRlzq--
