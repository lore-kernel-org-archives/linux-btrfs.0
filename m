From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: First impression (pure user)
Date: Fri, 24 Jul 2009 12:37:13 +0200
Message-ID: <200907241237.18071@fortytwo.ch>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1808431.bAUiudZrxy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1808431.bAUiudZrxy
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Heyho!

Just a first impression report from a pure user.  I've started to play=20
around with btrfs a bit, without using any btrfs-specific features so far,=
=20
though.

700G, ca. 1/2 full, tons of small files, lots of hardlinks ("dirvish" backu=
p=20
trees of my workstations at home.)

The disk is currently attached to a very old machine that serves as home=20
server/router, so only 128M RAM and very slow CPU (350MHz PentiumII.)  And=
=20
only USB 1, no less, which I didn't realize when I bought the disk :-) =20
Since dirvish only writes new files, I can live with it for now.

Software: Debian packages, btrfs-tools 0.19 and kernel 2.6.31-rc1 (soon to=
=20
be rc3)

btrfs-convert (using my desktop, which is more or less ok performance-wise,=
=20
not the old machine): still took ca. 10h.
 * some progress indication would be nice (needn't be very accurate, but it=
=20
would be nice if it could tell me if I'm about to wait another hour or=20
another day...)
 * documentation: what happens when I kill btrfs-convert?  Will I have an=20
ext3 with only free space having been written to, or will I have an=20
unfinished btrfs that I need to rollback with btrfs-convert?  Documentation=
=20
would be nice.  (I haven't tried what happens.)

Ok, now I have a btrfs, attached it to the old router.

I'm now collecting data if the slow CPU or the slow USB is worse by=20
enabling/disabling -o compress on the mount (will metadata be compressed as=
=20
well?)

Since it basically worked: now tried to delete the image file in the=20
ext2_saved subvolume, which exposed very unexpected behaviour:  it takes=20
ages (ok, we're still on USB1 and the file is huge, after all) and then it=
=20
kicks the oom killer into action; the system then becomes unusable.  Plenty=
=20
of swapspace free, so I guess "rm" uses quite a bit kernel memory.  The=20
backtraces I've seen all are just about tasks the OOM killer got rid of,=20
nothing into the btrfs code.

On a faster machine with more memory and USB2, removing the image file=20
worked, but I was still surprised at how long it took.  Quite some time was=
=20
spent with vmstat reporting only 1-4M/s reads (dd manages ~20M/s to that=20
disk, full USB2); I can't tell if it was seeking wildly or if it was CPU=20
(sorry, didn't think to watch.)

After, it seems the free space isn't tracked properly, the removed image=20
file should have freed up lots of space but no increase in free space is=20
reported by df.

Ok, after all those crashes, I'll now run btrfsck just to be safe. (I=20
haven't so far, given that it'll take ages...)

Again, progress indication would be nice.

And: I notice that btrfsck /dev/sda1 doesn't complain even if the device is=
=20
currently mounted.  Is online fsck already implemented?  Or will fsck run=20
just in readonly mode?  A warning would be appropriate.

Ok, enough complaints.  I'm amazed at what you guys are doing, and await=20
eagerly the moment where I can switch my compuers to btrfs fully (ENOSPC=20
handling and the ability to remove snapshots/subvolumes are the critical=20
bits for me, and of course it shouldn't eat data.  Then creating snapshots=
=20
before "aptitude upgrade" orgies will make trying out new stuff so much=20
more fun!  Btw, will it be possible to designate a new snapshot=20
the "default" snapshot and remove the old default?  Not critical, though.)

cheers
=2D- vbi



=2D-=20
In short: just say NO TO DRUGS, and maybe you won't end
up like the Hurd people.
        -- Linus Torvalds, 2001

--nextPart1808431.bAUiudZrxy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAkppjtlgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l61B4Ani9KTxLIsWqVnxveRWC/VE6z
O54UAJ0UIJBrNUgXGwbQoaT3TS53WKr94Q==
=9B+S
-----END PGP SIGNATURE-----

--nextPart1808431.bAUiudZrxy--
