Return-Path: <SRS0=NsLk=QI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40770C282D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 18:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0649218A6
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 18:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="MBEuzFjS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kVSFgcS3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfBASqR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Feb 2019 13:46:17 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48661 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbfBASqQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Feb 2019 13:46:16 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id F056C220AD;
        Fri,  1 Feb 2019 13:46:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 01 Feb 2019 13:46:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=4oCHcIIBQ9ehN6gpgspnvr3gjn8
        BRV2n4CtGZb+KQaI=; b=MBEuzFjSX4EDr5cC/hniRvX+tZzVzQsecl4vkBpSZLh
        xJY6CE3NziERwdfmUQYJMenpxg1Bd3HWohYLt38JfWwNG3JpIlvP07E6WG9hkR6B
        jsMIz1JGlJrtn7maKZQ41sGQIyEf0iNkNodYW9mOiapId+RxE1Nv80vMeultpoe9
        E+4I/j+T7MH8GgnNFv57QHLbcvBeftanypjoHy2YB4q0eloIBPU48lKGAKO4crpM
        3xzS+yEOUWX0B3JBsdCWTA4WRjcP2Jn9z5K8SlD34XYy+8U8cWOgQUVCkNzOAEjf
        HF4bxwDxUcaq6od1eTg9b15iB0iBMb561ktIpfjYOEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4oCHcI
        IBQ9ehN6gpgspnvr3gjn8BRV2n4CtGZb+KQaI=; b=kVSFgcS3S3FQ38btcrUkO7
        w5F5qUY96JcMiNbBOdEmZq3K7I9k0iCkR3HGReibJo0lU97DEZ9ENB7nHZcLwA7x
        S9n278HtkfFIYM3T1ks56324ycGj8KJOO7uFYWGozqKHKsHWU0UiTVuFFkLrCQNA
        64BsYCdI+b23ovO9pXbhJS2mSos8YiIw9Te92QoQ2t7rvGt9GC0hAHgbLSRWtGNC
        RnlN/tggiDiPnsocAAuJbMtou2Kuf79jlwYCu9EsZHoJhlk51DwPFK9d1wH2bvOL
        ErEUDM61lZ8UG6+hQjjWFWKnQHU1v9S6tqGu9nbV6RppN+Xtt+XkOD0guNeUOTaw
        ==
X-ME-Sender: <xms:9JNUXEYzMKSvj37G6c89YD5IM-irFlAALHweZaujNOxGV-6i6eeaZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrjeekgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecunecujfgurhepuffvfhfhkffffgggjggtsehgtderofdtfeejnecuhfhrohhmpe
    ftvghmihcuifgruhhvihhnuceorhgvmhhisehgvghorhhgihgrnhhithdrtghomheqnecu
    kfhppedufeehrddvfedrvdegiedrudefudenucfrrghrrghmpehmrghilhhfrhhomheprh
    gvmhhisehgvghorhhgihgrnhhithdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:9JNUXFL-RBozrSDT-gwHhJovPpaPrC28jmcftvVZte3LeAr9goVmIg>
    <xmx:9JNUXFyWpDCVifTSW2-FVe-4yc6w98qr2WfGn9URR4d76j2ad55B2w>
    <xmx:9JNUXF1Ei7WnUHx-62sN2oeIlNq7xRo3Mzoa6ejDevKysuwBN84wgw>
    <xmx:9JNUXJSljBP_T-4wcTr2tl4pYqt5ue8MQYROmNfRULXJLX9fK2fZsw>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A2ADE4046;
        Fri,  1 Feb 2019 13:45:56 -0500 (EST)
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
 <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
 <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>
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
Message-ID: <36f81db3-7346-482d-9e13-7365d647afbc@georgianit.com>
Date:   Fri, 1 Feb 2019 13:45:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V44Rzyj2xRqxLZJCOXsboxJHOBU0eyZxM"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V44Rzyj2xRqxLZJCOXsboxJHOBU0eyZxM
Content-Type: multipart/mixed; boundary="zrrpcwwA6vLQig4X2IaV4gS98QcFFrBCu";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: Chris Murphy <lists@colorremedies.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <36f81db3-7346-482d-9e13-7365d647afbc@georgianit.com>
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <a18f2081-cf5d-d914-bb16-dba51c949c30@gmail.com>
 <36be9ca6-4aa0-f00a-c1b4-a59026a1909e@georgianit.com>
 <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>
In-Reply-To: <CAJCQCtQ=mGdZ+90uR68hwqFcZaNP8xQwKXkpO395xB+KBXRkxA@mail.gmail.com>

--zrrpcwwA6vLQig4X2IaV4gS98QcFFrBCu
Content-Type: multipart/mixed;
 boundary="------------2FEDCF81380D0C275BC7A422"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------2FEDCF81380D0C275BC7A422
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-01-29 2:02 p.m., Chris Murphy wrote:

>=20
> There's no dirty bit set on mount, and thus no dirty bit to unset on
> clean mount, from which to infer a dirty unmount if it's present at
> the next mount.


Some time back, i was toying with the idea of a Startup script that
creates a /need_scrub file, paired with a daily nightly script that
checks for that file and runs scrub if found.  That way, if the system
ever ended up re-started without admin intervention, a scrub would be
run that very night.

But I've decided against using BTRFS parity raid until I can get working
2 device failure with no write hole. Either with Metadata Raid 1 N3
(what's the correct way to say that?) or Raid 6 that's write hole proof.

--------------2FEDCF81380D0C275BC7A422
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


--------------2FEDCF81380D0C275BC7A422--

--zrrpcwwA6vLQig4X2IaV4gS98QcFFrBCu--

--V44Rzyj2xRqxLZJCOXsboxJHOBU0eyZxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcVJPjAAoJEO9Tn/JHRWpt7IIH/jYGAdHiUTuAsLDTF9cmrFhY
40EUFgEvhUZEbwtoTN9ndQLbzW9el1NPRIKW1GvqtZNwIqNViIeptmcIWexV0K8h
DsqTtb9biZpdxlUHXHTe9uzg3wjdKLtiyMUH6t/cDa1/ghhGHNrwcHJVwwNC6hk6
MlTxffDC+EnoTF6M8VnLDk6RwNGR4J/s8BnbiH/F6VdyAec9MVVxmMAqi3SGgdeF
miX6ZGwWNYVbyIGZC3u5XE4w0GnKSX9OdDwmTp6RC6NYlg7B7kKbc9mrQLEDxa7p
A7w0b++i0c4FV/TRUAM7+eR021mJLM9gJphGWXFH9jFzZZGneF1SfMvjWjAgQY8=
=ciMB
-----END PGP SIGNATURE-----

--V44Rzyj2xRqxLZJCOXsboxJHOBU0eyZxM--
