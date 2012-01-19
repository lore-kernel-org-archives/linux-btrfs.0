From: Chris Samuel <chris@csamuel.org>
Subject: Re: Errors after clean reboot
Date: Thu, 19 Jan 2012 18:37:55 +1100
Message-ID: <201201191838.03289.chris@csamuel.org>
References: <CALkG1Nwkeohg0CwWg-bGDnvvMuJLFO8RvB1r0FddqCk8MRDdww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1540451.CkOz3rd58c";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Elsa Thomas <elsa.thomas-f5ob1dq@yopmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALkG1Nwkeohg0CwWg-bGDnvvMuJLFO8RvB1r0FddqCk8MRDdww@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1540451.CkOz3rd58c
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 19 January 2012 17:54:37 Elsa Thomas wrote:

> I can no longer mount my Btrfs filesystem after a clean reboot.
> Before the reboot, there were errors in the syslog, but
> unfortunately I can't recover them now that the root filesystem
> won't mount.

Might be worth trying to remount read-only, I've seen others reporting=20
success with that when it won't remount read-write.

Best of luck!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1540451.CkOz3rd58c
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATxfIU41yjaOTJg85AQKCFwf+Jm2MbkI3a7kx0k9utMFM8QTjk/NxlCk3
suTlwpziS3lVKqiONnyFjQ47lMsdmu2leELCwtNhyUi5aBwNKSoh4q40xMW/Sa1z
Afk8dbRxvxUHxq1m8QkeZkv7alVX41aUYe01BpnkxIOmTIiP+fdZR19NNwh+OjzK
hjBKXcD+SquxPWNOrpg3uuS3LP2PAAOYocFOUFCr71v2JJokYVvZm6JzdraCgN8u
g+GazhR9X98d16Y69vMtWdHYVHSJnetg1Wl2NTPJo6igdTuh1mhNx7ViDRVpePU2
dfPp96Ei6KcILfonNimz8zQdCAFF7IRJE6Dj3MZC71P22Mnfv+WNzw==
=R+Pz
-----END PGP SIGNATURE-----

--nextPart1540451.CkOz3rd58c--
