Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028E3C67839
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 10:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA2CD20811
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 10:39:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="CxnfHxfu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="W/FJ/qIa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA2CD20811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=georgianit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbeLMKjv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:39:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59723 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728537AbeLMKju (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 05:39:50 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 515E722071;
        Thu, 13 Dec 2018 05:39:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 13 Dec 2018 05:39:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm1; bh=f4RcpSwjDK5IIMrO5pf/76ojuE5
        gNvC099n0y8HKrVg=; b=CxnfHxfu3MWp3eqEGQrax9Jx6o5/a8JL1AuFvZk54Yw
        TQkwWmB+UekSY39rN9Fet2Qw5IcZdwi47XDVXC4WEDpWhlF/ohYkppzql/jdv3WK
        beWNHlyzmGbm2fX5u0s3XoKo1NvuqzG7IBe9OF/+VneQ5EDlbPgK9GySUTdHhcb4
        32cs7xIf4pj1CR0TuerAm2S1B79XsQFPliqXrGmBWmQS+sWJne67uHDm0HVF9c7I
        efc3B665bxEYKOxAN37kZRx634dKXeSpVkssnBumC1eC6HqvVBJgR42NAXgFTMOx
        8uMcsKDgCX+rzKl8ilLllr9qR44iAqgHGoCNkF4HoTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=f4RcpS
        wjDK5IIMrO5pf/76ojuE5gNvC099n0y8HKrVg=; b=W/FJ/qIaRLENRgQkMtVg3d
        CY2Vm8d5VNrol07vOTIenU0D75D0wRFNTq5BplAy0NCqLS9KGaMEeBzqFWE0rwHj
        0c6FAULb7mtXPG6Zp0ePpZ8stJtLIiPC2oflfK/E8nbqSyq+ZhD8oD/DknekYsuo
        62zahaZbOJZLXIYjcaaqrWJ5X4ar3uqal+5Gb9WPUTsMZcGp4wN+yRNhPzJtQvOf
        hIABqf6qdD2Zb+AWDrgDHz488IzBmwi1Ln3pQ88L+uDvjJ6f3NP/VvDUjcf9FYgJ
        lybOWtj2ab21zoqPHdWK+t0r+dXCCAf0bxm2zdDoC5UcnYfxC9shekk5ZIyYnhkw
        ==
X-ME-Sender: <xms:8zYSXOl8csTOWnFe0t7HoUK3yV2KQ5xG86OVllrgQrpreGbmUg3FLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtkedrudehvddgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkff
    gfgggjtgesghdtrefotdefjeenucfhrhhomheptfgvmhhiucfirghuvhhinhcuoehrvghm
    ihesghgvohhrghhirghnihhtrdgtohhmqeenucfkphepudefhedrvdefrddvgeeirddufe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpehrvghmihesghgvohhrghhirghnihhtrdgt
    ohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:8zYSXI-H6Ihu00G__-au07-yUCCBGbtu2kVDDldAO8Kjft9-nWSQKw>
    <xmx:8zYSXKHD4FKj8ku7K7Vpry6G3nWvbNM1C_RAgi_ihWbHkXJ3qgdyvQ>
    <xmx:8zYSXHJwBD-bd8E3jt0NQj8pphkU5GzVKl7yjNAAP5VXGn4YshexhQ>
    <xmx:9DYSXOvNkVWACQBRjULXKZTRlwqk0-iN1t5QQOZui7KE5d2jLXL3qg>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BB0910087;
        Thu, 13 Dec 2018 05:39:47 -0500 (EST)
Subject: Re: SATA/SAS mixed pool
To:     Adam Borowski <kilobyte@angband.pl>,
        Nathan Dehnel <ncdehnel@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
 <20181213072905.ac352nclowixfhpt@angband.pl>
From:   Remi Gauvin <remi@georgianit.com>
Openpgp: preference=signencrypt
Autocrypt: addr=remi@georgianit.com; prefer-encrypt=mutual;
 keydata= xsBNBFogjcYBCADvI0pxdYyVkEUAIzT6HwYnZ5CAy2czT87Si5mqk4wL4Ulupwfv9TLzaj3R
 CUgHPNpFsp1n/nKKyOq1ZmE6w5YKx4I8/o9tRl+vjnJr2otfS7XizBaVV7UwziODikOimmT+
 sGNfYGcjdJ+CC567g9aAECbvnyxNlncTyUPUdmazOKhmzB4IvG8+M2u+C4c9nVkX2ucf3OuF
 t/qmeRaF8+nlkCMtAdIVh0F7HBYJzvYG3EPiKbGmbOody3OM55113uEzyw39k8WHRhhaKhi6
 8QY9nKCPVhRFzk6wUHJa2EKbKxqeFcFzZ1ok7l7vrX3/OBk2dGOAoOJ4UX+ozAtrMqCBABEB
 AAHNIVJlbWkgR2F1dmluIDxyZW1pQGdlb3JnaWFuaXQuY29tPsLAfgQTAQIAKAUCWiCNxgIb
 IwUJCWYBgAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ71Of8kdFam2V1Qf9Fs6LSx1i
 OoVgOzjWwiI06vJrZznjmtbJkcm/Of5onITZnB4h+tbqEyaMYYsEIk1r4oFMfKB7SDpQbADj
 9CI2EbpygwZa24Oqv4gWEzb4c7mSJuLKTnrhmwCOtdeDQXO/uu6BZPkazDAaKHUM6XqNEVvt
 WHBaGioaV4dGxzjXALQDpLc4vDreSl9nwlTorwJR9t6u5BlDcdh3VOuYlgXjI4pCk+cihgtY
 k3KZo/El1fWFYmtSTq7m/JPpKZyb77cbzf2AbkxJuLgg9o0iVAg81LjElznI0R5UbYrJcJeh
 Jo4rvXKFYQ1qFwno1jlSXejsFA5F3FQzJe1JUAu2HlYqRs7ATQRaII3GAQgAo0Y6FX84QsDp
 R8kFEqMhpkjeVQpbwYhqBgIFJT5cBMQpZsHmnOgpYU0Jo8P3owHUFu569g6j4+wSubbh2+bt
 WL0QoFZcng0a2/j3qH98g9lAn8ZgohxavmwYINt7b+LEeDoBvq0s/0ZeXx47MOmbjROq8L/g
 QOYbIWoJLO2emyxmVo1Fg00FKkbuCEgJPW8U/7VX4EFYaIhPQv/K3mpnyWXIq5lviiMCHzxE
 jzBh/35DTLwymDdmtzWgcu1rzZ6j2s+4bTxE8mYXd4l2Xonn7v448gwvQmZJ8EPplO/pWe9F
 oISyiNxZnQNCVEO9lManKPFphfVHqJ1WEtYMiLxTkQARAQABwsBlBBgBAgAPBQJaII3GAhsM
 BQkJZgGAAAoJEO9Tn/JHRWptnn0H+gOtkumwlKcad2PqLFXCt2SzVJm5rHuYZhPPq4GCdMbz
 XwuCEPXDoECFVXeiXngJmrL8+tLxvUhxUMdXtyYSPusnmFgj/EnCjQdFMLdvgvXI/wF5qj0/
 r6NKJWtx3/+OSLW0E9J/gLfimIc3OF49E3S1c35Wj+4Okx9Tpwor7Tw8KwBVbdZA6TyQF08N
 phFkhgnTK6gl2XqIHaoxPKhI9pKU5oPkg2eI27OICZrpTCppaSh3SGUp0EHPkZuhVfIxg4vF
 nato30VZr+RMHtPtx813VZ/kzj+2pC/DrwZOtqFeaqJfCi6JSik3vX9BQd9GL4mxytQBZKXz
 SY9JJa155sI=
Message-ID: <60315740-e3e5-ed7f-a25b-6889932d0cfd@georgianit.com>
Date:   Thu, 13 Dec 2018 05:39:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <20181213072905.ac352nclowixfhpt@angband.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TVh2V8iWj3VsJUD2qUupzUBrH93lOUrXu"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TVh2V8iWj3VsJUD2qUupzUBrH93lOUrXu
Content-Type: multipart/mixed; boundary="y9SYsrBM3Ga7DHNiEWnrYSon5bNTXhfVX";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: Adam Borowski <kilobyte@angband.pl>, Nathan Dehnel <ncdehnel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <60315740-e3e5-ed7f-a25b-6889932d0cfd@georgianit.com>
Subject: Re: SATA/SAS mixed pool
References: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
 <20181213072905.ac352nclowixfhpt@angband.pl>
In-Reply-To: <20181213072905.ac352nclowixfhpt@angband.pl>

--y9SYsrBM3Ga7DHNiEWnrYSon5bNTXhfVX
Content-Type: multipart/mixed;
 boundary="------------2974E54B2F0296290F42EAC6"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------2974E54B2F0296290F42EAC6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2018-12-13 02:29 AM, Adam Borowski wrote:

>=20
> For btrfs, a block device is a block device, it's not "racist".
> You can freely mix and/or replace.  If you want to, say, extend a SD
> card with NBD to remote spinning rust, it works well -- tested :p
>=20

The possibility ff NBD certainly intrigues me, but I would be concerned
about the write barriers,, (needed to make sure cached writes are
committed to spinning rust in the correct order, so as to avoid
corruption in the case of interruption.

Assuming the underlaying block device on the remote device has a working
implementation, (as we know, not always a safe assumption...) does NBD
properly pass along the barriers commands/support?




--------------2974E54B2F0296290F42EAC6
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


--------------2974E54B2F0296290F42EAC6--

--y9SYsrBM3Ga7DHNiEWnrYSon5bNTXhfVX--

--TVh2V8iWj3VsJUD2qUupzUBrH93lOUrXu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcEjbyAAoJEO9Tn/JHRWptlQoH/0bovQJwA3qrmrnsK5YcC7tb
5fjyN7jIis8vdcc1w7N164x4bVZgu0JpasQcPq8X9osZMk0RiBHWb4d7k0REznAg
cgaUhjjc0kqFV+eEEpEP098hTGRJnXGyOfyU+CMUkDtmsmi38lia80mSulbVD5dD
XhlZmKRfMS1FNyBvxM2WHT574oSRUX98kW7WUxe9SJNvsOWugePi3AytUA2Rl7DB
W34Nte+BKIaWigN+6xvCX6sUMCc8uuM7OxXoJIM3+wyxhiQ9LXKns57jmRCdwd3k
Jyk6di0M0QIm76Bt6OUobSf67/EGrNrYt1TwVqtxnShiuEuuX31MoHW4c5G6vo8=
=xG01
-----END PGP SIGNATURE-----

--TVh2V8iWj3VsJUD2qUupzUBrH93lOUrXu--
