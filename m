Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:52703 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753916AbcHSRPZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 13:15:25 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id 1589347A5A4
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 19:10:29 +0200 (CEST)
From: Davide Depau <me@davideddu.org>
Subject: Balancing subvolume on a specific device
To: linux-btrfs@vger.kernel.org
Message-ID: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
Date: Fri, 19 Aug 2016 19:09:48 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DxMba9NM4lKQBgt0udX6ouvV3HxLtWdT5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DxMba9NM4lKQBgt0udX6ouvV3HxLtWdT5
Content-Type: multipart/mixed; boundary="clJM2lImtmsiuHMIWABhtCrrqcjHnSRie"
From: Davide Depau <me@davideddu.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
Subject: Balancing subvolume on a specific device

--clJM2lImtmsiuHMIWABhtCrrqcjHnSRie
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I have a btrfs filesystem spanning over two drives: an SSD and HDD.

Label: 'Android Dev'  uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx
    Total devices 3 FS bytes used 32.08GiB
    devid    1 size 21.95GiB used 12.00GiB path /dev/sda2
    devid    2 size 33.22GiB used 12.01GiB path /dev/sda3
    devid    3 size 53.10GiB used 13.01GiB path /dev/sdb2

(sda is the SSD, sdb is the HDD)

I've got these subvolumes in the filesystem:

ID 258 gen 708 top level 5 path cm13.0
ID 259 gen 708 top level 5 path ccache
ID 269 gen 708 top level 5 path omni

I would like the ccache subvol to always be stored on the SSD, unless no
disk space is available. Is that possible?


Thank you



--clJM2lImtmsiuHMIWABhtCrrqcjHnSRie--

--DxMba9NM4lKQBgt0udX6ouvV3HxLtWdT5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXtz1kAAoJEIdTK3rbE+XCVt4P/1Quc4se+WG2BIkSPldcwhvy
51Ki68EwmTLsJjSdPiBH08L+6+D9eolx5ftqUnOhKa+ftnSha2nBXLofrfPAYkW5
CX7zCA3Chp/1ryCE561stRozflaPq9dZA+5GtuzFC3bovvwqxB4LTcOoZuJLE3xP
tlz+DZ0mrwC46U7IGu5yHG9F2jc+9MH0BL2/pAlLqFCfuXXjdze9q7ni3UsFHJ+a
lNNid+KFG6LhSP0qSkJOPx2IVzC4FUg4BpFPaGJkgHikdnZnmh39yFgclzFN/9UF
6MTlkpZbV7o/Lla0sbQPlu+19NQcKb4diISiYNdigTiyjRqqNVul6frFZeXaHci6
3B4HvvJrpABEYMDmWKO+P4UECRjgSSA11pu49t85XFyTIlo24h9ymi7ZRRkoGA1U
jENJwig/lF4g0Wn7XjfspRAY5mW85y0yOFlNBeW+qnRRmn6KXEBosCokS+3Qy4kP
Nx39KCfj5d9BWjD4EL7+bbXegaIlAhblT5Zva73+NfxJvxRdrEn7SUzZwbDkdVop
n3ZXbubr6tSHKjMwAbRyAs0x4PcEbfdgK3tBZOqTlixa4vl9xsFksgPzBM3M3pTi
F5usE6Rl/3ozsk0wzjOP+nOb/UrCZYAFVEupflBULu5Uz1zhlumNeklRkNn2F+b2
k/JS1Q5/lehKvez1+1Hs
=TIow
-----END PGP SIGNATURE-----

--DxMba9NM4lKQBgt0udX6ouvV3HxLtWdT5--
