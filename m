Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44927 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754098AbcIBP1D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 11:27:03 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
 <1472829630.3713.8.camel@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
Date: Fri, 2 Sep 2016 11:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <1472829630.3713.8.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UubsupfxuNgTqTH1qd8FgDdMBGuFMeIlT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UubsupfxuNgTqTH1qd8FgDdMBGuFMeIlT
Content-Type: multipart/mixed; boundary="jWnorAKMLGANbvLjmh4q2pjmepHGuk6mE";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Chris Murphy <lists@colorremedies.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
 <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
 <1472829630.3713.8.camel@gmail.com>
In-Reply-To: <1472829630.3713.8.camel@gmail.com>

--jWnorAKMLGANbvLjmh4q2pjmepHGuk6mE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/2/16 11:20 AM, Ronan Arraes Jardim Chagas wrote:
> Hi Jeff,
>=20
> Em Sex, 2016-09-02 =C3=A0s 10:48 -0400, Jeff Mahoney escreveu:
>> Sorry, I miscommunicated there.  The WARN_ON is annoying.  It's the
>> underlying issue that's causing you to lose work that is the one that
>> concerns me.
>> =20
>=20
> Oh, OK, I see, sorry about that :)
>=20
> Thus, if disabling quotas does not help to fix my problem, is there any=

> workaround you can think of to avoid the problem you suggested in the
> previous e-mail?

Which part?  The quota reservation race will go away with quotas
disabled, so you won't get the WARN_ON.  The ENOSPC issue needs more
investigation before I can suggest a workaround/fix.  I won't be able to
get into that until Tuesday.  (Start of a holiday weekend in the US).

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--jWnorAKMLGANbvLjmh4q2pjmepHGuk6mE--

--UubsupfxuNgTqTH1qd8FgDdMBGuFMeIlT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXyZpCAAoJEB57S2MheeWyEtUP/01ikFPl47YAIg4aOSnHmR2B
JeNCJb+a3v/tg8JWKCf/iQNw9TEKacE7WulZGQHQmobu5djNmuzxQCtU4nxPFjeH
omlE7CtWwEW4O/qPirDXnSTlv3PjuTeL4q2QzKqW6OJ0jrrAL8QBPm/OYYi2MKUY
8MZ7J6yUuJwSwpmjycAVpaZqH6xiMeCv7Gy8FioGfUuCx2Msta05R7EF9+uMFc0X
0hvjxlif4jLnF+PNXEUkz4ttDxRcdHaSrkEkMsl/OpHAQSjMKI+dIkTksco6vYKW
8oaF0QNgm+OP3Vs+/Fs2CNYEGA71valfBGNuhDoPoubF5SFdHNjN4FAmDtQhImjp
Rg8H/JVVijhBOgtSWSxDa2+g62GvOm5uqQf8q3KiQKT+hfZfNWffZjIvLbQAA27x
bDsMALmoD4T8zsA4rYGJVDoLA4rr3ho/1lbPrpV68rlyVSBPxib4N7LFdjJZegs3
L6qquSkp+7JAeQLggpXnEoxmgV9heQsu6fQueh36O06J4NYCasWKpff5AbK6hjXG
Txmn0QuPsXyu02NEkkJbvHMYcvKCN6rIPQD6Gd5uMwluiPHUNSoXMLjJ+3D9g9+g
V3Xu/2e3pjlwkhEvrIlQmGeAAmUOaFOOcRRFZ5ETKLEZO342rtRN1kekVXzItjL+
YwrYdQjwhV1tdxaE/pkK
=5dx2
-----END PGP SIGNATURE-----

--UubsupfxuNgTqTH1qd8FgDdMBGuFMeIlT--
