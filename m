Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from s17634251.onlinehome-server.info ([87.106.5.14]:56580 "EHLO
        s17634251.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750927AbdIKSRJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 14:17:09 -0400
Received: from sgisoft.sgisoft.pri (247.red-81-39-174.dynamicip.rima-tde.net [81.39.174.247])
        by s17634251.onlinehome-server.info (Postfix) with ESMTPSA id 9515D1000F2D6
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 20:17:06 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
 by sgisoft.sgisoft.pri (Postfix) with ESMTP id BF971632CF4
 for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 20:17:05 +0200 (CEST)
Received: from sgisoft.sgisoft.pri ([127.0.0.1])
 by localhost (sgisoft.sgisoft.pri [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yWnNZUfi64Vy for <linux-btrfs@vger.kernel.org>;
 Mon, 11 Sep 2017 20:17:02 +0200 (CEST)
Received: from pcsenen.localnet (unknown [10.10.10.2])
 by sgisoft.sgisoft.pri (Postfix) with ESMTPSA id 92D66632CEA
 for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 20:17:02 +0200 (CEST)
From: =?ISO-8859-1?Q?Sen=E9n?= Vidal Blanco <senenvidal@sgisoft.com>
To: linux-btrfs@vger.kernel.org
Subject: Storage and snapshots as historical yearly
Date: Mon, 11 Sep 2017 20:17:01 +0200
Message-ID: <9208764.SjP1vfhOIA@pcsenen>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart100374585.bPWszNTI9B";
 micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart100374585.bPWszNTI9B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

I am trying to implement a system that stores the data in a unit (A) with=20
BTRFS format that is untouchable and that future files and folders created =
or=20
modified are stored in another physical unit (B) with BTRFS format.
Each year the new files will be moved to store A and start over.
=20
The idea is that a duplicate of disk A can be made to keep it in a safe pla=
ce=20
and that the files stored there can not be modified until the mixture of (A=
) and=20
(B) is made.
=20
I have looked for information on this but I do not see it very clear. Both=
=20
"SEND" and "RECEIVE" do the opposite case to what interests me.
=20
I have also seen that you could try to get a RAID 0 but I am afraid that th=
e=20
data in A will not remain intact if the system performs a "BALANCE" at some=
=20
point and mixes data between (A) and (B).
=20
It is assumed that both the (A) and (B) data will be displayed in the same=
=20
structure transparently, for example in "/ home".
=20
=2D------------------------------
|             HOME            |
| ------------   ------------ |
| |          |   |          | |
| |          |   |          | |
| | DISK (A) |   | DISK (B) | |
| |  BTRFS   |   |  BTRFS   | |
| |          |   |          | |
| ------------   ------------ |
=2D------------------------------
=20
=20



--nextPart100374585.bPWszNTI9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSK7dSjHxedEO9Hp55GZDGorwH5mgUCWbbTHQAKCRBGZDGorwH5
mh5kAJ4/kAXcXsLebHtTVgm1iMKeB29oqgCdH1KHzOgaQd3fmWeMKOBjebm2cWc=
=j+3H
-----END PGP SIGNATURE-----

--nextPart100374585.bPWszNTI9B--

