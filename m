From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: btrfsck: doesn't correct errors
Date: Thu, 27 May 2010 18:46:04 +0200
Message-ID: <201005271846.16832@fortytwo.ch>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1996695.VMZtEAD1OC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1996695.VMZtEAD1OC
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Heyho!

(This is using btrfs from Debian's 2.6.32	2.6.32-3-kirkwood kernel (-9=20
package; btrfs tools is v0.19-16-g075587c)

A few observations about btrfsck:

a btrfsck run on a 2T volume (4 disks) on a QNAP appliance (512M ram) got=20
killed by Mr. OOM Killer.  Initially, I was quite surprised.  I'm only=20
moderately surprised now since it might well be that I forgot to enable=20
swap.

A btrfsck run (on a remote machine this time, with nbd) showed quite a few=
=20
errors like:
root 268 inode 34001 errors 2000
root 268 inode 34002 errors 2000
root 268 inode 34074 errors 2000
root 268 inode 34102 errors 2000
root 268 inode 34103 errors 2000
root 268 inode 34104 errors 2000
root 268 inode 34132 errors 2000
root 268 inode 34133 errors 2000

2nd observation: am I supposed to know what this means?

And 3rd observation: btrfsck apparently doesn't correct this kind of error.=
 =20
Running btrfsck again still shows the error.

cheers
=2D- vbi


=2D-=20
Could this mail be a fake? (Answer: No! - http://fortytwo.ch/gpg/intro)

--nextPart1996695.VMZtEAD1OC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAkv+oc1gGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6zX8An3UBOHMrtYLDhPDabKOgPfkh
tWn1AJ921LqRo+vQt/3WBEv0/gyr0VIfpQ==
=VZvI
-----END PGP SIGNATURE-----

--nextPart1996695.VMZtEAD1OC--
