Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57566 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964831AbbJ0QIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 12:08:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zr6na-0002jO-FC
	for linux-btrfs@vger.kernel.org; Tue, 27 Oct 2015 17:08:34 +0100
Received: from 178.165.131.228.wireless.dyn.drei.com ([178.165.131.228])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 17:08:34 +0100
Received: from wertstoffe by 178.165.131.228.wireless.dyn.drei.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 17:08:34 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: Re: btrfs-balance causes system-freeze on full disk
Date: Tue, 27 Oct 2015 17:05:55 +0100
Message-ID: <40k4gc-scp.ln1@aldebaran.xundeenergie.at>
References: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
 <CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uT6klIT8kMpqSInqxNcjidrvjTP2s5aiK"
In-Reply-To: <CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uT6klIT8kMpqSInqxNcjidrvjTP2s5aiK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Found a new habit...

I have a lot Snapshots on my drive. (Take every 10 Min a new one, every
houry one, every day one, every system-update, every plugin after
external HD...)

If there are to much snapshots (didn't find out the count how much
exactly) balancing fails with a system-freeze.
if i delete some of my snapshots, balancing is working...

Maybe this is a hint for bugfixing!!

Do you think?

greez

Jakob

Am 2015-10-21 um 22:51 schrieb Kyle Manna:
> I had a number of similar btrfs balance crashes in the past few days,
> but the disk wasn't full.  You should try tailing the system logs from
> a remote machine when it happens. You'll likely see some bug info
> before the system dies and becomes unusable.
>=20
> The issue I encountered is described @
> https://bugzilla.kernel.org/show_bug.cgi?id=3D105681
> =E1=90=A7
>=20
> On Wed, Oct 21, 2015 at 12:38 PM, Jakob Sch=C3=BCrz
> <wertstoffe@nurfuerspam.de> wrote:
>> Hi there!
>>
>> Is it possible, what i've recognized now. My system (debian) runs on
>> btrfs, and i have a lot of snapshots on my hard-disk.
>> Since some days my system freezes totally. I recognized, it always
>> happens during btrfs-balance.
>>
>> So i deleted some of the old snapshots and tried another balance-run.
>> Nothing happened... No system-freeze.
>>
>> System-freeze means: No Keyboard-action. The Mouse is frozen, the scre=
en
>> is frozen, no magic-sysreq, no ssh-login.
>>
>> Can btrfs cause such a freeze??
>>
>> greez
>>
>> jakob
>> --
>> http://xundeenergie.at
>> http://verkehrsloesungen.wordpress.com/
>> http://cogitationum.wordpress.com/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/


--uT6klIT8kMpqSInqxNcjidrvjTP2s5aiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWL6DkAAoJEF2YPOCqoD05pugH/jd+UU3TVkFJR03/8MbSP9r7
ABUWDR+eybpErHVjPNFTF/kehqgfPqTPD3nfskCH0ybPIB+pJveLgM+V1MMRgmIL
ms5KPccYajpZrHFmgPinhWAoBHt+K2rcTGps43M6NCHaLMoCj+ypwHvQF48Ral2v
BcimpVx84YK8bRIUBOdyAiuzKZkrexUzbVL3DxXocxP1zJRkIqpasiUO9mbQqrhx
c3UkXGJ+lmTZDcF1eF5Kh6OyTBOZyP1nZiOZmDLmJRFqzz06f/s4/F8oh9hDqK8W
ITucZBuh3fIcrRcovqqJSnOphuAn3V8Ip7AGxH82RA6StcHpME7BGGMQ+JPgIJw=
=zEHT
-----END PGP SIGNATURE-----

--uT6klIT8kMpqSInqxNcjidrvjTP2s5aiK--

