Return-Path: <SRS0=daUN=QY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E55CC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Feb 2019 03:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C1D021B69
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Feb 2019 03:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="p0IA+4tW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Jd8r0VbN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfBQDLa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 22:11:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40637 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727063AbfBQDLa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 22:11:30 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B9C0620F5C
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 22:11:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 16 Feb 2019 22:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=CC5nKrVHAkfQKlq8liD6Da9Xizn
        Rm6d93DwFAAiUChk=; b=p0IA+4tWIZMf3R0gBvh8VebKNoA5WRPIlHWsl3WMCBp
        P081W0Bz+EWde6tQlgxkF7A3BkBXjSaGCAW55zz9thvLpNoFpCHJrFZ582WfBHl6
        aWJmAJ9J7C6UT+HlABu8BeVq0Sb4N7rKqW5I9sm855y2LhsaAg+xTAXuBU3X1Z/6
        JY8RGoWfcumvSrtbJ/ysSAe5i098wwNIC44fu7burRUv3zNi8HZklSAiLOTCusY9
        NVqkT4GjlYl+PRdGcmjlpDTDoH4nVn2y+v0UfuUzAp23EV9ZkOpw4AvLJPhKGzjJ
        hG7EM2nknviVhsS3c8gQIqp74NKg3+9TufUZM+t2HJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CC5nKr
        VHAkfQKlq8liD6Da9XiznRm6d93DwFAAiUChk=; b=Jd8r0VbN46NEhu6bMtMp/1
        D7mEEp7/GpuaNLD/Cz4MqMPXD+UfpwqwEEZOI7X6AU0VqPVXCtJVcLI5iPiP/ZH2
        wjIWjEzOQb2j9u1f9JA9axXKNl2aMj7ne2E/wWIrBymmq2kF0n7IJmBt4InGS1ba
        egKmq1HgpZjXrHoieLGSedxgPz2b6PVx1Qb1wzsBeHi2Pfhz/YKZ18V7GisnCOa/
        9DpIv7MU9SM9gQHNp42KraZgyu2rsIOkr2CAKL4llN5HKr8vIE0spHrzBWtI/Rgx
        Z1V6k+utdUpsE9VRcG43O+hK47+zKVLt6y3MTM7avqh5C6zZ0QiAsYjShpbk/9xw
        ==
X-ME-Sender: <xms:4NBoXL5NwmWXl3KvNjqTW5Wf-rbT3__IB9jkTFtC8wWmH2zeL3h88A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddutddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecunecujfgurhepuffvfhfhkffffgggjggtsehgtderofdtfeejnecuhfhrohhmpe
    ftvghmihcuifgruhhvihhnuceorhgvmhhisehgvghorhhgihgrnhhithdrtghomheqnecu
    kfhppedufeehrddvfedrvdegiedrudefudenucfrrghrrghmpehmrghilhhfrhhomheprh
    gvmhhisehgvghorhhgihgrnhhithdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4NBoXJ1Lgj6i0sQ4mkuNbwadCdQlsIXDm93eV6HLwIUKTf2oR2K16Q>
    <xmx:4NBoXEYrvSULT4blAjYP-jPZk4JjhlqnhVRAJbdVVKuOJxiaaOWyQw>
    <xmx:4NBoXJADiXpRBf-RCJ7bAPsc7YPEa0id2SOiaoQfrM1eMwuD5ycTng>
    <xmx:4NBoXCFiAWfp3j76_aE-lyoQw8AwX_-K0KvQj00uQOvnbtWauKNp2g>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A486E4068
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 22:11:28 -0500 (EST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
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
Message-ID: <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
Date:   Sat, 16 Feb 2019 22:11:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SXNvTcgGo2UtgxLOtjBCBDKUo5jmFWei6"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SXNvTcgGo2UtgxLOtjBCBDKUo5jmFWei6
Content-Type: multipart/mixed; boundary="Xaqe9S2KUAAxZZlXTUSULx5FVbM8qHefw";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
Subject: Re: Btrfs send with parent different size depending on source of
 files.
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>
In-Reply-To: <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com>

--Xaqe9S2KUAAxZZlXTUSULx5FVbM8qHefw
Content-Type: multipart/mixed;
 boundary="------------92893C5E0559C090C5C229FA"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------92893C5E0559C090C5C229FA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-16 3:08 p.m., Andrei Borzenkov wrote:

>=20
> File size of "real" server.jar is not exact multiple of btrfs block siz=
e
> (4096) which causes the last extent to be "incomplete". btrfs won't
> clone extent in this case. You can trivially reproduce it by using the
> same size in the first case (although exact extent distribution may be
> different of course, in the worst case you get single extent which is
> sent in full):
>=20
>=20
>=20
> dd if=3D/dev/urandom of=3DA/dir/server.jar bs=3D1024 count=3D34625
>=20

Thank you.  I thought I had tested one where I changed the file size,
(by  altering the bs,) but I must have inadvertently created a file that
still divided by 4096, (or it got split into a second extent).



--------------92893C5E0559C090C5C229FA
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


--------------92893C5E0559C090C5C229FA--

--Xaqe9S2KUAAxZZlXTUSULx5FVbM8qHefw--

--SXNvTcgGo2UtgxLOtjBCBDKUo5jmFWei6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcaNDfAAoJEO9Tn/JHRWptKXkIAKp5JwTrHFq7ThnXjlJxdunS
phvmPLGdh3kLcJS81NWS1pX4evP6VPKLUhmFUTXEGcNHaQ+wgH+VbU6BoIMm9y3H
KcdMMHq9puVwfpyQkYY/lJb9dTuf+02ba8xROxA6zmLkf52TYq2FC2gRiFexcmtQ
fxMin36g0e2xP+9y7laLeqFDX2vZYC4kuuPSj1hhS+K0GLFUdPq/q31gfNOGgGm4
Q9JPstJLW69OzMr/Cmg3d8OCxnrf9fJcfFXZSRhpanVf3CY26zr4zLWks2dttLv9
ATSSW5e7S9kNe5n/Bh6InmtdqVWQcalCoe2ytvmD1UTFcoVcVaON5flc5mgX1bM=
=33s0
-----END PGP SIGNATURE-----

--SXNvTcgGo2UtgxLOtjBCBDKUo5jmFWei6--
