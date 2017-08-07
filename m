Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:38674 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbdHGFMO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 01:12:14 -0400
Received: by mail-wr0-f177.google.com with SMTP id f21so34976844wrf.5
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Aug 2017 22:12:13 -0700 (PDT)
From: Thomas Wurfbaum <thomas@wurfbaum.net>
To: linux-btrfs@vger.kernel.org
Reply-To: thomas@wurfbaum.net
Subject: Re: Crashed filesystem, nothing helps
Date: Mon, 07 Aug 2017 07:12:03 +0200
Message-ID: <30657728.PhKxf8kc3H@nimrod.thomas.wurfbaum.net>
In-Reply-To: <1636460.K4WVeUNh5S@nimrod.thomas.wurfbaum.net>
References: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net> <1785889.2psX1aaXR2@nimrod.thomas.wurfbaum.net> <1636460.K4WVeUNh5S@nimrod.thomas.wurfbaum.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1639234.RGLH701WDl"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1639234.RGLH701WDl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Now i do a btrfs-find-root, but it runs now since 5 day without a result.
How long should i wait? Or is it already to late to hope?

mainframe:~ # btrfs-find-root.static /dev/sdb1
parent transid verify failed on 29376512 wanted 1327723 found 1489835
parent transid verify failed on 29376512 wanted 1327723 found 1489835
parent transid verify failed on 29376512 wanted 1327723 found 1489835
parent transid verify failed on 29376512 wanted 1327723 found 1489835
Ignoring transid failure
Superblock thinks the generation is 1490226
Superblock thinks the level is 1

The process is still running...

Regards,
Thomas

-- 
Thomas Wurfbaum
Starkertshofen 15
85084 Reichertshofen

Tel.: +49-160-3696336
Mail: thomas@wurfbaum.net

Google+:http://google.com/+ThomasWurfbaum
Facebook: https://www.facebook.com/profile.php?id=100006061335414
Xing: https://www.xing.com/profile/Thomas_Wurfbaum
--nextPart1639234.RGLH701WDl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEib0Z9ILinUsMTE1rXgeiU5j4BKYFAlmH9qMACgkQXgeiU5j4
BKaimhAAl5CneRP7TIc39Pg0nYwB1UcGcSVE2FuJMDhmQ/oDhy+Z/mhZzwlBKRAU
4V+86H0Eb8Hxvzt5CBC7J5XdErnMJKIlTFrCaO1XeiocIphyrS0JPINVG3SHVUfu
tFo5yvtJx9gxujF8mBlfLyMOv2KlzguNlmsFclcrfcAtoGWQY3yPnKTopZYSQNOx
v3TrnKtSFzTGKHbIg/hXAt4d2/url+ZK8PPbDyK4zanJDka5gxEFIxDWwZV/+d4G
YXzj4IeNRleaJhk1iC5hIXSdPM3Q/jmDvMWt3M8lDMlkckCJmPVLENNxh2Jsdq6V
7bLBoJlOA5zMsbFJV69TQ1aUXo52l2cSivD5kr+xTqAMqPXoEPiJjxDQL8SZ2N6f
qBK/PvTI4fbnihII8w03d/MeQEjKcEob5RgDCwZGZI6IUo+p5WYB5QFnK2eKTVGd
SAz8D3U6Y3kfjCWhk9uHoi9L/5MB1bJTk/gI6Q+R8UH0FxikJJ0//I0Rr+EIAQ3S
UFLf2Z1/VKaLkwTNFJBJ2XTzhtLqWsbUB5wuvPo6RpUgoSxMkr18k4DLJejloJlh
uVZTVByvKJFfAIpmdLvDzPuETdUDyeV9DpaDFadiFvi7jCXTLqrOVy/4UIp/0SUS
2a2ngXcPyzjDWUsSG6R0ysYMbLArSoMiCfuOR+9GWKC8Dx5P1Ks=
=P8FS
-----END PGP SIGNATURE-----

--nextPart1639234.RGLH701WDl--

