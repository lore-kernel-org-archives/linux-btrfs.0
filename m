From: Chris Samuel <chris@csamuel.org>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 13 Oct 2011 22:28:01 +1100
Message-ID: <201110132228.07805.chris@csamuel.org>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <CA+JuuGo-iREXO4cZKT61tHZMTAr_edBv=O51-uSA7Bgynbgu6w@mail.gmail.com> <4E8F1128.4000508@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1901607.6L1gLZy870";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8F1128.4000508@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1901607.6L1gLZy870
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Saturday 08 October 2011 01:48:08 Josef Bacik wrote:

> [...]  Fsck has the
> potential to make any users problems worse, and given the
> increasing number of people putting production systems on btrfs
> with no backups the idea of releasing a unpolished and not fully
> tested fsck into the world is terrifying, and would likely cause
> long term "I heard that file system's fsck tool eats babies" sort
> of reputation.

=2E..and, for instance, it was one of the criticisms levelled at
reiserfs (v3) that its fsck implementation was rather brain dead
in some ways - it couldn't distinguish files contained in an image
of a reiserfs filesystem from those in the reiserfs filesystem that
the image file was in, plus it could discover files from a previous=20
reiserfs filesystem after it had been reformatted (as reiserfs).

http://en.wikipedia.org/wiki/ReiserFS#fsck

Chris worked on reiserfs, so he probably doesn't really want to
go through all that again..

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1901607.6L1gLZy870
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATpbLQo1yjaOTJg85AQI+BAgAtWwVq1Bcitw4jn2BnajxzT3RsYkVThQh
IB6jPaD1UJ0lZt5eNdPzUp9v9zRdlvJbp9EdAbcZfr0drbDU5j2k3gbUxOUc9nhO
ajgnXT1tJdm4JM8UK//wfJP/LEu6mKCEK/+bPh/WO8CbX1QETn9snlyXRAzoHlr+
JbUSkRQbp3pyC9qC14uDqM8HrlCbSV2Yb3ImH2PS71E8QA6k603JqDYIXAvFPCqM
wAt/uDTwQZo9wjqgfNj5Y23y2EVg7EUypzMqFdVj1ElQvnH0Uq+NrOjzDqeKAuLR
o+gGy+QvqwBOASrZA4svR8YEVsnWPenJ1VvZtf8v4Rec5xcFm8Q6Nw==
=W79b
-----END PGP SIGNATURE-----

--nextPart1901607.6L1gLZy870--
