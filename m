Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:47686 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752278AbdC0Ls6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 07:48:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.gocept.net (Postfix) with ESMTP id 2ACCE14C0020
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 13:48:56 +0200 (CEST)
Received: from mail.gocept.net ([127.0.0.1])
        by localhost (mail.gocept.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dcO8GcMi-NXf for <linux-btrfs@vger.kernel.org>;
        Mon, 27 Mar 2017 13:48:55 +0200 (CEST)
Received: from [IPv6:2003:a:b60:f100:50a:8066:6685:5534] (unknown [IPv6:2003:a:b60:f100:50a:8066:6685:5534])
        (Authenticated sender: ct@flyingcircus.io)
        by mail.gocept.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 13:48:55 +0200 (CEST)
From: Christian Theune <ct@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A3F478F4-6F68-469D-85E4-B93EA725EE6D";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Date: Mon, 27 Mar 2017 13:17:26 +0200
Subject: Shrinking a device - performance?
To: linux-btrfs@vger.kernel.org
Message-Id: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_A3F478F4-6F68-469D-85E4-B93EA725EE6D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

I=E2=80=99m currently shrinking a device and it seems that the =
performance of shrink is abysmal. I intended to shrink a ~22TiB =
filesystem down to 20TiB. This is still using LVM underneath so that I =
can=E2=80=99t just remove a device from the filesystem but have to use =
the resize command.

Label: 'backy'  uuid: 3d0b7511-4901-4554-96d4-e6f9627ea9a4
        Total devices 1 FS bytes used 18.21TiB
        devid    1 size 20.00TiB used 20.71TiB path =
/dev/mapper/vgsys-backy

This has been running since last Thursday, so roughly 3.5days now. The =
=E2=80=9Cused=E2=80=9D number in devid1 has moved about 1TiB in this =
time. The filesystem is seeing regular usage (read and write) and when =
I=E2=80=99m suspending any application traffic I see about 1GiB of =
movement every now and then. Maybe once every 30 seconds or so.

Does this sound fishy or normal to you?

Kind regards,
Christian

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_A3F478F4-6F68-469D-85E4-B93EA725EE6D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJY2PwmAAoJEKuh8lKpfGLOEGwIAMgJ4zbvuNoSUa488TM8+0PO
/8RMvjafvXqvi/OU7lT065EMMNIq9MFNWT29DvJobQoUKzY1Vd+cTBoRD+Hiflkw
d4Q6+oKQSuDzDK8GN+KY7GArhxNbgplz/q9dt1eBTz+0nqnYYFi29Jw2WSYiVj0c
uAbfirAOMu/fRMUWg0XKSkQDvxIVEZZrr+kBeIMt+/PAuaNBMVWhW2JAn+nTqMfw
dZQRQuer0210IwqD2TkxLb9nhWCUnZf3/94ZCsVVI5DYxH5eDkfmOdZUvp/IFlzA
SUa+b55h5OrGOikwdT1H8l/jQ78oFfWf6fQczahA3mRahn3sQlfMlypBT4+W6tA=
=Tbb/
-----END PGP SIGNATURE-----

--Apple-Mail=_A3F478F4-6F68-469D-85E4-B93EA725EE6D--
