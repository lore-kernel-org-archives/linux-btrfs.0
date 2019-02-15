Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9FEC10F02
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 04:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F9DA21B1C
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 04:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="UZZ4XM2p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yuPA1zVH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfBOEAq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 23:00:46 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60637 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbfBOEAq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 23:00:46 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A86B22EC5
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 23:00:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 14 Feb 2019 23:00:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=mRYuHxqJ+SE8rPSKhaRnqzeTGW3
        itPPNtWFSKf1h1AE=; b=UZZ4XM2pd/Zc3R/g7T8D9hGhXyHFPQJf4PQ0SiwVGfh
        9AD0hxDNzbREznvqURxqTY8SxeX+zc/qP0P7cVlOtP2VLGHhQ3pUpcyGiHABcIXc
        StSsrpsgIkGeG1VcFVIqMmUi5AhYbjY/y6zS/yvDCsLka47wOB8v+pKn01l7Yx40
        cJ47KeqApRoFcV6h287P5xMVbmZquxQf7VWeqweIaCDOzMMH70hrFTQZLPdWmsRI
        2yaFK9u/RRzluY6qeatDWgojv2kgXeC2BY6q3BQeZb6G8EcQvS5AVkW9k4fKYCyF
        fQtTzv7sNy+D2Ohm8lTI17cwoznIFi7fhLP9cKMQmpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mRYuHx
        qJ+SE8rPSKhaRnqzeTGW3itPPNtWFSKf1h1AE=; b=yuPA1zVHRw2Xc46XOhkREg
        Lln/00YanyRUgKdgKfB3O72JbFOkQujWZTrM0RJSDfDfbqCCDHMhVQZG9yx27BDg
        bLSbu8Xzh+UnGCF1CYlrNy7+PnoKUBG/AuaPS0Mk+1tPkb50C0P+xrNKX1j5qmax
        g6XE8tQe7zIfNA88UFNuDuP91x1Nt3zpDFfrH2ATEozes6Cy1l9TqbbACjyJfp5v
        iF5zkZ4k8XuG0p/ISEEMO8/nPAi9R5aYFq/5nHluCsM9p+QYKX+GP4PNBCMSCqsh
        2QMiuBCNNX6Wou/qrMUJKew2+2diAwCSS6FITnI/hSLxiMJ2uaLnqyQO9ExAEJNw
        ==
X-ME-Sender: <xms:azlmXHCCIFwEn16iJJ6ZfWknNic0_8pqdZXV3LlJgPeRoLBkvEwDGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddtiedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecunecujfgurhepuffvfhfhkffffgggjggtsehgtderofdtfeejnecuhfhrohhmpe
    ftvghmihcuifgruhhvihhnuceorhgvmhhisehgvghorhhgihgrnhhithdrtghomheqnecu
    ffhomhgrihhnpehmohhjrghnghdrtghomhenucfkphepudefhedrvdefrddvgeeirddufe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpehrvghmihesghgvohhrghhirghnihhtrdgt
    ohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:azlmXCu4hvb4RhyLs5kFalbBTHMLJKJ8WntPAXNsn26J8oqiwOao7A>
    <xmx:azlmXDcKL_N-iCVv60J7uiPMiyzAJGFFZWbmShP7UWNiMACg-DG26Q>
    <xmx:azlmXP8TrG0d8gDV3ON5enc4yJXoO97OyQeY6PvyDWEZdJyU6kJkQw>
    <xmx:azlmXJfkttTKnMsy5no8FGUFVLSxnN44bVDal-4zG4rRvaXMFIZQUw>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2A4FE4046
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 23:00:42 -0500 (EST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
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
Message-ID: <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
Date:   Thu, 14 Feb 2019 23:00:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ntpLru6zwgleoYcc3Z0Z2TQ8GtoAZajw5"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ntpLru6zwgleoYcc3Z0Z2TQ8GtoAZajw5
Content-Type: multipart/mixed; boundary="fOa36OxzGhjhvrHV0Om6qjOxLcCOfTfEC";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
Subject: Re: Btrfs send with parent different size depending on source of
 files.
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
In-Reply-To: <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>

--fOa36OxzGhjhvrHV0Om6qjOxLcCOfTfEC
Content-Type: multipart/mixed;
 boundary="------------6F1681050818850A8AEA4586"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------6F1681050818850A8AEA4586
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> It doesn't work this way. The snapshots a and b are not based on the
> same underlying subvolume. The gist is that you would keep changing A,
> and take additional snapshots of A, such as a.1 a.2 a.3, and you can
> do incremental send with 'btrfs send -p a.1 a.2' which describes the
> difference between those two snapshots of A at their respective
> moments in time. You could also do 'btrfs send -p a.2 a.3' or even
> 'btrfs send -p a.1 a.3'
>=20
> But as there's no relationship between=20

snapshots a and b, I consider
> it a bug/missing error handling feature, that btrfs send doesn't fail
> in this case. By using -p you're claiming there is a parent-child
> relationship between a and b, but there plainly isn't.

They kind of are related though, since the two snapshots reference the
same data blocks, and you can see it work in the first example with the
40MB of random data.

However, I can replicate this odd behaviour the conventional way.

btrfs sub create A
mkdir A/dir
dd if=3D/dev/urandom of=3DA/dir/server.jar bs=3D1024 count=3D40K
btrfs sub snap -r A a

cp --reflink=3Dalways A/dir/server.jar A/server.jar
rm A/dir -rf
btrfs sub snap -r A b

btrfs send -p a b > out


The out file is only 773 bytes.  However, if you repeat all those same
steps, but replace the dd with:
wget -O A/dir/server.jar
https://launcher.mojang.com/v1/objects/20c069d373e77265aaeeedb733f7051e29=
4325a3/server.jar

The resulting out file is 34MB.

--------------6F1681050818850A8AEA4586
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


--------------6F1681050818850A8AEA4586--

--fOa36OxzGhjhvrHV0Om6qjOxLcCOfTfEC--

--ntpLru6zwgleoYcc3Z0Z2TQ8GtoAZajw5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcZjlpAAoJEO9Tn/JHRWptNmkH/2YWPFNayYDxa1jgqH2Q3xJr
zY+dYx790JwTNjqdH18LDsE6feHc6VHc82//5UqYVKiqVV/QGGAF2KfjXHM6K3no
HlRmWHBKXXIojIVMFhjZb+wOHOpKpSo0Ewpph/VeqAYkfQozf6L8tMjzFKifVhMp
iDSsLz4mPPhcmZCu9duEp7aC8DGtNt4882QTAxk4/L4awlvXpJgKJFqsXs4cd+24
GhiTJJhWNcv3rp+5FJWlpiDtKJEbLiMdmCEBL9SNs82g0gXIuP4+yFwobnggFbwm
5dSTP+9VXgsr+txC5NsgxjQ3hVyJBQBAyeoBBbXEw9CqWI6Vsi4xHGi/73C5Qoo=
=x+uP
-----END PGP SIGNATURE-----

--ntpLru6zwgleoYcc3Z0Z2TQ8GtoAZajw5--
