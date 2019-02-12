Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6462AC282CE
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29895206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="q2j7D8q/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vN7wkUug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfBLHn6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 02:43:58 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35353 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728252AbfBLHnw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 02:43:52 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 2362322A3B;
        Tue, 12 Feb 2019 02:43:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 12 Feb 2019 02:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=yvFVEqc6uwzGoBurqA8bHin0lDQ
        VcMB3m1ewSivGftA=; b=q2j7D8q/6JEm7gzRVdEqLSYkrqenPa6FkI93D01fMae
        sN503Og8uC//jZyGPZKUjKvuNH94hCIKidJbwWN99DoSkzpl8V9tu9f7CrY9WqdN
        wM583kUdpzvC4NZuLubVTFf9kA0INJpfFC22b2uux7r4lqUtL5tCBjTJc6cUMzsx
        joGfnl88fbFyzs4oSBxGeGnfUx5Iht9qB++jp26pXJqU3CR7jgQahlseFks4siTw
        CPdrvbPOAqOIwCfV+iLA6XssNWf9oElQ4igIzt0d1cL/25GDtslv9o9N6kphhQ+5
        VMle8h5UrhN5IUrHmAOYKuMeU3bCz5lofYa9Pw6MaPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yvFVEq
        c6uwzGoBurqA8bHin0lDQVcMB3m1ewSivGftA=; b=vN7wkUugf7OcV690XRw4JN
        q76I8nPDevxaFXhUqKrp4ajhMhXx7Lhn2FP3xJk8y1hdoUk6uPJ2moeegBMw+B3e
        t8NXdeodkFs59dsngu8HxFQxnS8T2F4h+lpbYdXiepDEsLuL1BnHv7ptlXM9MBBi
        0YUKlH9e/sPU9tzrz+cyQS2XibfQUjbOmeSwVdVR2dnMeM+jmgweUazGU3930zXC
        +mqlkhoHwEFtupyFbXzOQ4df0txsDmenDwtu4l/9LqoxuAAwT0wJ2UwQCGmjlV38
        9n/YEPAaBuTD1/mgjAYQew0VTeXYkAJqLEKdYK9dSaCCpNVTjxfU8j6OmqYNxyTg
        ==
X-ME-Sender: <xms:NnliXPQrkbZfcUJBY6BwbVwh6w1K3ZGH-IU-9vPjWhQNO45QvFwzlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddttddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecu
    fedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkf
    fffgggjggtsehgtderofdtfeejnecuhfhrohhmpeftvghmihcuifgruhhvihhnuceorhgv
    mhhisehgvghorhhgihgrnhhithdrtghomheqnecukfhppedufeehrddvfedrvdegiedrud
    efudenucfrrghrrghmpehmrghilhhfrhhomheprhgvmhhisehgvghorhhgihgrnhhithdr
    tghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:NnliXEHdzjyBNXo2f-NiBj-nD9mWR2Gm-v6kj61IYhC2z9jQ6ocpsQ>
    <xmx:NnliXI5EACMV2eQHQ7UBcBvQF4njFOub2Mdo3nV2B8nCn4cVdYW5vA>
    <xmx:NnliXFYObLBF21U6YRPGOOwZ8YDhQ1IlpB-XvYwCqgJPphCg-MVWhA>
    <xmx:N3liXDFd7NaIjKvypNGE4tgPi-6CluG-PZ01v6y1ruIhRFVkqBR54w>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 37616E462B;
        Tue, 12 Feb 2019 02:43:50 -0500 (EST)
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
To:     Qu Wenruo <wqu@suse.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
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
Message-ID: <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
Date:   Tue, 12 Feb 2019 02:43:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0S6owLUC3KM80QmavzRwYQR68JG4gygBm"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0S6owLUC3KM80QmavzRwYQR68JG4gygBm
Content-Type: multipart/mixed; boundary="Xg3UIKmhdoxizPLQweXvMOzN9aKvtjzsf";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: Qu Wenruo <wqu@suse.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
In-Reply-To: <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>

--Xg3UIKmhdoxizPLQweXvMOzN9aKvtjzsf
Content-Type: multipart/mixed;
 boundary="------------9CF464969B83F18E8C15118D"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------9CF464969B83F18E8C15118D
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-12 2:22 a.m., Qu Wenruo wrote:

>> Does this mean you would rely on scrub/CSUM to repair the missing data=

>> if device is restored?
>=20
> Yes, just as btrfs usually does.
>=20

I don't really understand the implications of the problems with mounting
fs when single/dup data chunk are allocated on raid1, but I would think
that would actually be a preferable situation than filling a drive with
'data' we know is completely bogus... converting single/dup data to raid
should be much faster than tripping on CSUM errors, and less prone to
missed errors?



--------------9CF464969B83F18E8C15118D
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


--------------9CF464969B83F18E8C15118D--

--Xg3UIKmhdoxizPLQweXvMOzN9aKvtjzsf--

--0S6owLUC3KM80QmavzRwYQR68JG4gygBm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcYnk1AAoJEO9Tn/JHRWptuWgH/jaEcs7y/WMmg9F9XqHn02bL
eRJLrHW0KVu3yFHV4ksJBfkwNQWAIue2V4cclN/IG6cipyS1lW76GZ9Lbf+InuWT
H7gTr06ADWzGSDomFDn3c/+MXd3frPeGqeH7ER5nQ+8eKcz/O268SKLh/qB8+a1x
tcbhQiyB29n8Z9fr6hm+G8ZVy8vrn/I7t95VItUq5LcNI8O28XHJG6jgL3e6HvOL
iOFwy+Rfo9qMlGm0UsN50mXGPZpBOgdi9neXsQMMclbE7BwzVRgovTrfNuchfCdD
qmFzgsUz97NlRH//onH8j0/VCv5WMRlRROxUupkSDTaUmovztgbCG7dHLMK0MKE=
=UePh
-----END PGP SIGNATURE-----

--0S6owLUC3KM80QmavzRwYQR68JG4gygBm--
