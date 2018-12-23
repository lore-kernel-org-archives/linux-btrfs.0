Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D96C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 16:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E037222A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 16:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="m7VVqNoU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GbMANGJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbeLWQbW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 11:31:22 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35827 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbeLWQbV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 11:31:21 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id E18C221BEB;
        Sun, 23 Dec 2018 11:31:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 23 Dec 2018 11:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:references:to:cc:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm1; bh=YMj7iU+I9cVfM6G2TDfNZBp6cWQ
        LBUzknBZ6wBI8yfE=; b=m7VVqNoU5xejTxdZnGwbbzFo32eL0OwzvUpMpyzIrCX
        K2PS2tnRQDXgX5RJ9cQOKej2Ll4Ufk2Cwm9ChwddBy+AXJWC4keygJBzJ/X9gxRq
        EKX9XA6BF0bWS70Gxx4mTOm38lVLCSl+yTlHADTuxAmBj+ip2LuONmHRdDxNwhlz
        mW9HRfUNR8wZPVKU2IDh6CgHuylS8lu53FxPAs6fP9wKZC6eyK6QwIuxCmSCp+Kk
        7W8d6vrAcRIHnBdTLWR4wBvLsda+MDj4/zEyCsRWJqY5xQrrKwGdG92w4sI3MPXF
        5Ug4JbtJQXeDaSeCDMP7KhQQrMHFoatOnA5k6I5s16Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YMj7iU
        +I9cVfM6G2TDfNZBp6cWQLBUzknBZ6wBI8yfE=; b=GbMANGJFnZrDYskAiyDzXR
        k0T4pFRTjXcSbC29WM36mc2OgPcOxtycCpvraN3u8pmv43gSTJTYOBrE/mzY9hSl
        W6oJlS1Tp5rd+Gf3MutDQgwG01a8Eqi+nnZtAVaHMBXecSnk3pASXhPGUyMPUZO/
        QaMg7mzNXbwaquo1Sp/JufCZ4kiM6E9xVuCe7jpVv5WVCwoYo/tKEGhfQeFBWf6R
        7Q1h0ro4RI4i39BiYEr9+2k4DR0dIthrtNjr6nzbMiLn4un8nKy7ZJMm/lahJ223
        HTputndjfV6aasVSOwgJY+jNK0Z908hfGVSDwSzbqDMJgqHhvdFubSQ0vJLAKdLw
        ==
X-ME-Sender: <xms:WLgfXOmJU2c10Zs36i_Aa75LClfRudvCn8SKV2n63DLZeUFkjsR20g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtkedrudejledgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecunecujfgurhepufhfvffhkffffgggjggtsehgtderofdtfeejnecuhfhrohhmpe
    ftvghmihcuifgruhhvihhnuceorhgvmhhisehgvghorhhgihgrnhhithdrtghomheqnecu
    kfhppedufeehrddvfedrvdegiedrudefudenucfrrghrrghmpehmrghilhhfrhhomheprh
    gvmhhisehgvghorhhgihgrnhhithdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:WLgfXBquC-p7sMs0nq0jkIkQVtFampV8CJU1wpskKfn7OCVqmBVb_A>
    <xmx:WLgfXDGhw0wd4LqzHpt2c4edYsSNg3IXl48gwrOJ3-Ra2vMga_GL5w>
    <xmx:WLgfXPSsdB0WPDwduyXQoLVQyE8hcFHWi81W7lc5-L8y4iGqmRmA3Q>
    <xmx:WLgfXNVnD_bIo8bj61qG36EUzhHr4LUDhz4SuKYxkr94Wcpot44qow>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6565810085;
        Sun, 23 Dec 2018 11:31:20 -0500 (EST)
Subject: Re: Aw: Re: Defining quota on /home
References: <trinity-d2464fff-db28-4205-9fe2-db6d5e1879ea-1545569213648@3c-app-webde-bs12>
To:     c.monty@web.de
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Remi Gauvin <remi@georgianit.com>
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
Message-ID: <cc6473e3-4fc9-5c1e-b8a7-5427b2c0fa3f@georgianit.com>
Date:   Sun, 23 Dec 2018 11:31:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <trinity-d2464fff-db28-4205-9fe2-db6d5e1879ea-1545569213648@3c-app-webde-bs12>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2rafJAmRMQKnn3XJD99sVHwekUJJ67FcI"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2rafJAmRMQKnn3XJD99sVHwekUJJ67FcI
Content-Type: multipart/mixed; boundary="oN2UQyhph2szXOkOJ3R5kq8DaBPqHJj7X";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: c.monty@web.de
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <cc6473e3-4fc9-5c1e-b8a7-5427b2c0fa3f@georgianit.com>
Subject: Re: Aw: Re: Defining quota on /home
References: <trinity-d2464fff-db28-4205-9fe2-db6d5e1879ea-1545569213648@3c-app-webde-bs12>
In-Reply-To: <trinity-d2464fff-db28-4205-9fe2-db6d5e1879ea-1545569213648@3c-app-webde-bs12>

--oN2UQyhph2szXOkOJ3R5kq8DaBPqHJj7X
Content-Type: multipart/mixed;
 boundary="------------6FB3155B7923804D92943C75"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------6FB3155B7923804D92943C75
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2018-12-23 7:46 a.m., c.monty@web.de wrote:
>=20
>=20
> I'm sorry.
> Of course the line
> 0/279 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.79GiB =C2=A0 =C2=A0 =C2=A01.79GiB =C2=
=A0 =C2=A0150.00GiB =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> is correct.
>=20
> The issue is with this line:
> 255/279 =C2=A0 =C2=A0 =C2=A0 1.79GiB =C2=A0 =C2=A0 =C2=A01.79GiB =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 none =C2=A0 =C2=A0 =C2=A0 =C2=A0 none
> I didn't define a quota like this.
>=20

I don't know if it's the 4.4 kernel, or the tools, but I observed the
same extra quota group whenever quotas were enabled on Ubunut 16.04 syste=
m.

 I didn't give it much though, as it didn't hurt anything to have an
extra higher level group.  (quotas and snapshots on that kernel were
effectively mutually exclusive features in any case.)



--------------6FB3155B7923804D92943C75
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


--------------6FB3155B7923804D92943C75--

--oN2UQyhph2szXOkOJ3R5kq8DaBPqHJj7X--

--2rafJAmRMQKnn3XJD99sVHwekUJJ67FcI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcH7hXAAoJEO9Tn/JHRWptAc0H/iHcj1K7qCt0qZX/+QQSGALd
717LmMJeJDQP3tcE7QZrBIz9mFi8/NyIJeLo58HHH/U8S6l6U29fdppiLg7co0tC
DIQYzaIdlHm9SToXMg9Z4bK4mFGHlht0fUpqJblvicAdoufRlj9/1EsLv9q8/Liz
+q14UleFWDFfXWyPZLaK7yKafJmsiddCQ3rU6asdyNvr50mvxU678cx1HaYpZKHb
8KZwWnVO/ogrA4m7pvImzk6ssrAJTCxB2UnEeHI8mznmFgl5xImRzb2CHqJGf0oz
ovydZwgMHd/4JADTsLtcOrtUqvjoKZhGxHSVDIyjDIhuJHmHR71itQdlNvXdlSU=
=rnbJ
-----END PGP SIGNATURE-----

--2rafJAmRMQKnn3XJD99sVHwekUJJ67FcI--
