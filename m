Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:55639 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752608AbdC0Lvj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 07:51:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.gocept.net (Postfix) with ESMTP id 0CCF914C0020
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 13:51:03 +0200 (CEST)
Received: from mail.gocept.net ([127.0.0.1])
        by localhost (mail.gocept.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VFUtSbCCdoUa for <linux-btrfs@vger.kernel.org>;
        Mon, 27 Mar 2017 13:51:02 +0200 (CEST)
Received: from [IPv6:2003:a:b60:f100:50a:8066:6685:5534] (unknown [IPv6:2003:a:b60:f100:50a:8066:6685:5534])
        (Authenticated sender: ct@flyingcircus.io)
        by mail.gocept.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 13:51:02 +0200 (CEST)
From: Christian Theune <ct@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2180B6DC-36D4-461A-925E-4EEFD39DC17B";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Shrinking a device - performance? 
Message-Id: <BA9E63E9-0362-4DBD-8B7F-12CA97C4D127@flyingcircus.io>
Date: Mon, 27 Mar 2017 13:51:01 +0200
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_2180B6DC-36D4-461A-925E-4EEFD39DC17B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

(I hope I=E2=80=99m not double posting. My mail client was misconfigured =
and I think I only managed to send the mail correctly this time.)

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


--Apple-Mail=_2180B6DC-36D4-461A-925E-4EEFD39DC17B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJY2PylAAoJEKuh8lKpfGLOJ6cH/1A9oC1RImqQegk244k940o+
8GVJxwXq/dFFRVq9dSyjeRslo3lJVKKJ8Dk4Y9hwzdQIMILM/OUiX5xdZwGoHk8r
sWMr3tTR114zUksaeqxO4aRzdDAHn1GeT2jAO08tOqSMJJbm1xEpCXPVPjyadCxm
iht6WMuGimw79mCzd5owvq7Arj+zbA7Ptp4xfMfcJkaA964Qe8dscSF/QWBuGBFF
mIclCbCuZNFPChga9iaPrgday22/LVCR9VvvqVPkiT3WkoPOnDn5Qur8StNR9HF0
b5csfIm0QifXp5nYBnKivBtkoFe9n3ZZuT1RbqQfuwM00rY24kJKmI5S/pzV8ik=
=IKAc
-----END PGP SIGNATURE-----

--Apple-Mail=_2180B6DC-36D4-461A-925E-4EEFD39DC17B--
