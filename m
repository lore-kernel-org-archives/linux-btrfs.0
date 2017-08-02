Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34138 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbdHBJla (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 05:41:30 -0400
Received: by mail-wr0-f175.google.com with SMTP id 12so16509478wrb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 02:41:29 -0700 (PDT)
From: Thomas Wurfbaum <thomas@wurfbaum.net>
To: linux-btrfs@vger.kernel.org
Reply-To: thomas@wurfbaum.net
Subject: Re: Crashed filesystem, nothing helps
Date: Wed, 02 Aug 2017 11:41:25 +0200
Message-ID: <1636460.K4WVeUNh5S@nimrod.thomas.wurfbaum.net>
In-Reply-To: <1785889.2psX1aaXR2@nimrod.thomas.wurfbaum.net>
References: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net> <20170802143141.71b47fe1@natsu> <1785889.2psX1aaXR2@nimrod.thomas.wurfbaum.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2188270.TVmfd4COZh"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2188270.TVmfd4COZh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

With the help of btrfs-corrupt-block i was able to get a little bit farer.
I marked some of my problem block corrupt.

Now i am in this stage
mainframe:~ # btrfs restore /dev/sdb1 /mnt
parent transid verify failed on 29409280 wanted 1486829 found 1488801
parent transid verify failed on 29409280 wanted 1486829 found 1488801
parent transid verify failed on 29409280 wanted 1486829 found 1488801
parent transid verify failed on 29409280 wanted 1486829 found 1488801
Ignoring transid failure
parent transid verify failed on 29376512 wanted 1327723 found 1489835
parent transid verify failed on 29376512 wanted 1327723 found 1489835
parent transid verify failed on 29376512 wanted 1327723 found 1489835
parent transid verify failed on 29376512 wanted 1327723 found 1489835
Ignoring transid failure
parent transid verify failed on 29786112 wanted 1489835 found 1489871
parent transid verify failed on 29786112 wanted 1489835 found 1489871
parent transid verify failed on 29786112 wanted 1489835 found 1489871
parent transid verify failed on 29786112 wanted 1489835 found 1489871
Ignoring transid failure
leaf parent key incorrect 29786112
Error searching -1

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
--nextPart2188270.TVmfd4COZh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEib0Z9ILinUsMTE1rXgeiU5j4BKYFAlmBnkYACgkQXgeiU5j4
BKaOtBAArJsb8pL6gZKp4MQrBc+P5n0r27rDWTTqCslZwgl0fqU3vGYlVPozuk0s
DrXC8mhtjfsn0S6JJ9phDyGRTziI2mLmDG4CFbwRwK4Zoxob5haoDzX8sBuwuw9Q
nQUTumTxP3gk4d/NmmeT/ejxusI8vdcptNQxSfyn95RXBjW0RrbatCO1uSIumRzm
r2hX2gDbqKYZyXkNCgtyeVuRvamK2CBp50hLumxsT/ZCorv9OaLOZ3jfEDSJei32
Dmd7iP4JpFW0vX/IyPgl2LGy/q+ukfB+Xy2PdTkfDB+Y8j3dQzO4vS9l1Nvr5fN3
GBXdu9rcGhiOL8hzTAUwU41iwF4itTMztX8ZS+3ahb50hKU/hceYRHzUZ+cSvPBw
BB5y/AUybwDmhz+4huo8YcC3yQwK7wxSwc6zF1hmTv30c6hy4bwi74ZZ1sCdLnzq
5EYBL4tRRlyEZu2Le1mMzvopEf0IgJey27IoenopnguC0w+z7mCCAfJwhsjcKqGd
iJRNOTf4z6Fx0T2ilidlhx5Dvnren59AsGQAXWTI6DKmRy4Tpp800AJsyvkxydug
QflwTpuhC9/weDA91nXSM6/553DBC2FwxDtEVPCrrD46BgFMtSJKqjaGc1X22uQx
xN6uP3yucZ8zxDxvgultb50SOlXXNBfJd2v5gHw0tDe6HrK2xVY=
=2emC
-----END PGP SIGNATURE-----

--nextPart2188270.TVmfd4COZh--

