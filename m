Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D11C282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 22:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11B2F2175B
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 22:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="C8xelVif";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vOW+VBuB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfA1WwQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 17:52:16 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33741 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726678AbfA1WwP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 17:52:15 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id ADE9C22E09;
        Mon, 28 Jan 2019 17:52:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 28 Jan 2019 17:52:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=BGuQU72jZ41nY4MW3965KaEVtnW
        /mgTWhgvGO6bRRYA=; b=C8xelVifweuT13d97fGcko+wXfhzwpyF6Dp1Ny9/XU5
        XNGKaNr1tmVlmxTtaysqyrgHjcNTWZlr5p+OBpGOvLsH5t8m67gsVWA3fC2FUAaG
        WQ0iRGI3JK9xGUvPvGK3f9lvPzGqCIXnmfbN6l4dYl+QDDqfRX07SwRjPCy380CO
        2K7wYxESruOi1hWbhzQNVWH5SzQcP6mRtYVE69THM8abpucFUVNklo97/zG/QSCM
        7/Fp0EaUVHxhRY2GorfP+uGKVU4t5dzGoda5wZ69i494r72FeGX9CpzyH2u0wpiP
        grvpODWaWcFYc8glyNQ0IO5V3aEkIlk8hhTFq5eNi+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BGuQU7
        2jZ41nY4MW3965KaEVtnW/mgTWhgvGO6bRRYA=; b=vOW+VBuBLqCQL8wuJpQ9D6
        ZnOuF/9IqkXBcn4FjIqwNDy5VOY0q9Dz4EcT8c6B1CaO1+Fo37F1DsXJXbtdKfv/
        sfoLPxRKpSMYzDcy+m6zFs6gMDaPe6yI/zxjBQxO0/lUt1p172KXzzNhjOejg2ZD
        8DiO6t9z5R8qMXnOnuO5Y91gNu1hZwazOB1fcJk6GWVaslqXO7RP6Fl/4Q/W90Wr
        VGc1h5YKhgTRieiYwegTQLvv64nbThXbhjfKkNlcje4lFg/XVPjEesMeaLggsIze
        RK2OR0NINfkusIc+gGOr2A9us1m2Q4iQzvXQJuU15mrl9+HqvqN7HlS+cUjLR2FQ
        ==
X-ME-Sender: <xms:nodPXGswIIeWZLTF0aHTQ6O7-9_2Vb0uurJhL2iN-LWz2LK64FuIeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrjedugddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucenucfjughrpefuvfhfhffkffgfgggjtgesghdtrefotdefjeenucfhrhhomheptf
    gvmhhiucfirghuvhhinhcuoehrvghmihesghgvohhrghhirghnihhtrdgtohhmqeenucfk
    phepudefhedrvdefrddvgeeirddufedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehrvg
    hmihesghgvohhrghhirghnihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nodPXDrQSqOunqh9i2Xm4vTFRbVb9zp9Ccjx3U_ectttcTPWY23sEg>
    <xmx:nodPXNWG4Yh3IgF9MJOWHydsyyd_6x6vyUAAMWvhiKnVAZc_FdfEUg>
    <xmx:nodPXL1M_ksb53E4yuEX_uzWzRmDCAcpWiI7E0QSAdNTh_uCitUQjA>
    <xmx:nodPXHtxIFaET9L88VEvm8ddzyRWBtPC2ALAJt1Av8yo5emiVtXCNg>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1A1A100BA;
        Mon, 28 Jan 2019 17:52:13 -0500 (EST)
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
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
Message-ID: <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
Date:   Mon, 28 Jan 2019 17:52:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="p37UGJ1tmo6xPqd8ewHJ7IQrSlolm7zAo"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--p37UGJ1tmo6xPqd8ewHJ7IQrSlolm7zAo
Content-Type: multipart/mixed; boundary="2zQHlpFtqJsyGUi9fcYZKxCcV2di0LVyl";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: DanglingPointer <danglingpointerexception@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
In-Reply-To: <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>

--2zQHlpFtqJsyGUi9fcYZKxCcV2di0LVyl
Content-Type: multipart/mixed;
 boundary="------------15111E03EAA2EA5A11590F16"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------15111E03EAA2EA5A11590F16
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-01-28 5:07 p.m., DanglingPointer wrote:

> From Qu's statement and perspective, there's no difference to other
> non-BTRFS software RAID56's out there that are marked as stable (except=

> ZFS).
> Also there are no "multiple serious data-loss bugs".
> Please do consider my proposal as it will decrease the amount of
> incorrect paranoia that exists in the community.
> As long as the Wiki properly mentions the current state with the option=
s
> for mitigation; like backup power and perhaps RAID1 for metadata or
> anything else you believe as appropriate.

Should implement some way to automatically scrub on unclean shutdown.
BTRFS is the only (to my knowlege) Raid implementation that will not
automatically detect an unclean shutdown and fix the affected parity
blocks, (either by some form of write journal/write intent map, or full
resync.)



--------------15111E03EAA2EA5A11590F16
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


--------------15111E03EAA2EA5A11590F16--

--2zQHlpFtqJsyGUi9fcYZKxCcV2di0LVyl--

--p37UGJ1tmo6xPqd8ewHJ7IQrSlolm7zAo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcT4ecAAoJEO9Tn/JHRWptXasIAKsBEWxQBxR9jht3cCYHhb+L
SK3vPC0lXtrWeYNrRvvv81MS0Jn590Ub3rQ16DbnWpNjD8iIk/nSk6FmEPZGDSpO
4Kuv8yYKGoH+8UcU0jYoUwDp17iaIeHhc1lds2Ehuc1kPdYLpXaQPV+3I73VMn2p
ftjURPJ/EVENG4sTeWxYCF5ZAfe4OPlO0okwk/7TS0WDT7ExklRWnUxxxG+lKH50
2YbOsUAsOTkfl5PFbh4ew/HVOejDpGQf4AH5uPcw579unX1KEECGk1fAtVWf5gRI
gmArzz+iSX1544Cvlu9/5scuPJxAt9OQVCVT7OqS5YVcvLssU+cqFTmKyI+I7BE=
=phcV
-----END PGP SIGNATURE-----

--p37UGJ1tmo6xPqd8ewHJ7IQrSlolm7zAo--
