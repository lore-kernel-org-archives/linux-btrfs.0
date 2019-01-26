Return-Path: <SRS0=UsBE=QC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED518C282C7
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 14:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8286214C6
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 14:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="gk5wSLvM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="a1t++CD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfAZOFM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 26 Jan 2019 09:05:12 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46881 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbfAZOFM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Jan 2019 09:05:12 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id E8F2F1787;
        Sat, 26 Jan 2019 09:05:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 26 Jan 2019 09:05:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=iNVV+KUqcvWgDd/PuJS9xwXppjW
        5+1fRtLJESq76QY0=; b=gk5wSLvMD8jyKfn3jGlpEstJBWZJ0IaDc1Me8gbxSUX
        S6Aa++Ufgc+Dh7u+4ufoV3dBEt9pbIWj+EM1dNnmWqdtHjVbnlkA2wvF6xNYu/or
        0Js/0R0oNwaDS9LfK/Df/iS2CizukGRIMIQMkoUtogi1ydo/+Kyodvwrj0wprldE
        arzV+d/gurd0VvAOx3SNUMu4kzZGEs2OTztsvmpIFZ8L2/nMpRE/ymPsd/otUaZS
        9IuMswhotPy0G47TTDX0bZ7k8BLkiVNFX9HnuqGfiBOdH6hWRWRUi6/XQHAThKun
        qCiCtAUsOIG4Bh0X/wEgq7maqNsE6hi2rG9Gz7fdzlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iNVV+K
        UqcvWgDd/PuJS9xwXppjW5+1fRtLJESq76QY0=; b=a1t++CD/CHmDokwZyHgLRL
        gPR0hFJWNjjgxIxIafkuApqd5D8QI05VGmwNcfA28zjyg7H/E5IW6e28VaE3lNih
        xDnPHpLTvtqUHPb4vDYQZ+13XNeckfiShKTe2CUYR+Wsr6qhEHqCRYkxkWUhwvlm
        rZJHdcUB+UyCjk58VDSpqt7/R2zvUbIMfODwPpDUvJ4z4VonjeOfi/mhdRHIb0yS
        4GZlEYMMJLOgFZq9fiaJYCJpzHA3k9S7NNQGLyGVCm+LrES+34NydojYiWCOYGdZ
        ls2QV6iqxBRxW9vplOW014WjnsnaUhlZn+Zd4x1+TeJsFGdX7TOCjkCko5s72J3g
        ==
X-ME-Sender: <xms:FmlMXKWvRWwpRu4q5gMYX0L1H7gtbuttUrTTPDLOFHw4KHvGaRx_Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrieeigdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucenucfjughrpefuvfhfhffkffgfgggjtgesghdtrefotdefjeenucfhrhhomheptf
    gvmhhiucfirghuvhhinhcuoehrvghmihesghgvohhrghhirghnihhtrdgtohhmqeenucfk
    phepudefhedrvdefrddvgeeirddufedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehrvg
    hmihesghgvohhrghhirghnihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:FmlMXCKxzcU7m4PIO4YuSN8J58nUHTcw2ecwnFwfKYy80oMW2LivdQ>
    <xmx:FmlMXFpB4AEsX6uSQbyUcqzd08bLbKVTaX09TNEVRRjcSWXXIHbVzA>
    <xmx:FmlMXJvy_uGuM0D0bGKYw8vuRBovvFQfeSZSKvTWfxR6TW4VwNPtWw>
    <xmx:FmlMXH-AO9mcW6_4YopqSkcR72ImXf4dnAFmQecthjuC7FPcLcfX1Q>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id D66CA100BA;
        Sat, 26 Jan 2019 09:05:09 -0500 (EST)
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     waxhead@dirtcellar.net, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <f7f5d96f-2650-9162-02ef-c9200364c86a@dirtcellar.net>
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
Message-ID: <b89f6e65-3e7c-14f0-919c-4057b202aa64@georgianit.com>
Date:   Sat, 26 Jan 2019 09:05:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <f7f5d96f-2650-9162-02ef-c9200364c86a@dirtcellar.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8RDohAP96JttrJZM5ZfRVWmpeTnMvap7B"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8RDohAP96JttrJZM5ZfRVWmpeTnMvap7B
Content-Type: multipart/mixed; boundary="hRdVouvSEiwKv30KS7ouPaAMWhiI6hj1c";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: waxhead@dirtcellar.net, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <b89f6e65-3e7c-14f0-919c-4057b202aa64@georgianit.com>
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <f7f5d96f-2650-9162-02ef-c9200364c86a@dirtcellar.net>
In-Reply-To: <f7f5d96f-2650-9162-02ef-c9200364c86a@dirtcellar.net>

--hRdVouvSEiwKv30KS7ouPaAMWhiI6hj1c
Content-Type: multipart/mixed;
 boundary="------------DF448B5033CD64C402FC9282"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------DF448B5033CD64C402FC9282
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-01-26 7:07 a.m., waxhead wrote:


>=20
> What effect exactly the write hole might have on *data* is not pointed
> out in detail, but I would imagine that for some it might be desirable
> to run a btrfs filesystem with metadata in "RAID" 1/10 mode and data in=

> "RAID" 5/6.
>=20

One big problem here is that neither Raid 1 nor Raid 10 currently have
configurable # of Mirrors, (N devices), so it's impossible to get 2
device failure redundancy.  (No point in using Raid 6 then, that's just
wasting space.)

--------------DF448B5033CD64C402FC9282
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


--------------DF448B5033CD64C402FC9282--

--hRdVouvSEiwKv30KS7ouPaAMWhiI6hj1c--

--8RDohAP96JttrJZM5ZfRVWmpeTnMvap7B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcTGkUAAoJEO9Tn/JHRWptYU4H/25ZuxTrXk9yibCU4uBcpdy3
Hvf1dyJYLA9tDd/X2Ww8m2un+rWPfg7wN4+vyViCjEOuGyHZFsY55O/B03caINjn
dIiU0Q1Cy1FELQtWya7fY8Bn5q0nMLHTj5WPxl0oMgZXukAbqzhztk5PPvPTDjvf
VnQKqtf7hL4sPyl9b2lHBLQDpBSJk1nZSAce9/6Z0CrUfsey2n55qjbt/4Z3r2Vj
TDShDYGHz/kVd25oVLD3qzm3H0av0FrlIJJt0mHoM2SATCAXIG68fmSrILiXILzZ
AXz6GbYgGtnec40lKaJouV5VpQYf/n+HTFlBvsdEIQd/NvjOrrVtp9qlPWbRc34=
=yIRE
-----END PGP SIGNATURE-----

--8RDohAP96JttrJZM5ZfRVWmpeTnMvap7B--
