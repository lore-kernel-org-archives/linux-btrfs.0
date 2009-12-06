From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Q: list  btrfs snapshots/subvolumes
Date: Sun, 6 Dec 2009 16:37:49 +0100
Message-ID: <200912061637.50131@fortytwo.ch>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2048369.uRRm852Zri";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2048369.uRRm852Zri
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Heyho!

I'm currently (once more) trying to experiment with btrfs, especially since=
=20
the ENOSPC handling and "delete snapshots/subvolumes" make it look extremel=
y=20
appealing now.

Some questions:
 * how do I list available snapshots/subvolumes?
 * assuming a disk has failed: just to be sure:
   "btrfs-vol -r missing" will remove the missing device.  Not sure: will i=
t=20
also replicate the missing copies of my (raid1) data and metadata?  Given t=
hat=20
it takes ages (ok, just running a few minutes now ;-) to run on this system=
,=20
I'd assume so.  Or is a separate "btrfs-vol -b" necessary?
 * "subvolume" and "snapshot" is technically the same, except that a subvol=
ume=20
is created empty and a snapshot is a cow copy of an existing tree.  Handlin=
g=20
these two is the same once they're created?

Ok, that's what I can think of right now.  Eagerly waiting for "set default=
=20
subvolume to be mounted" to be written... :-)

I just did a few tests with a 4 x 450G raid 1 btrfs volume: adding some 5G =
of=20
small files, remove a disk (didn't pull it out, but shut down the system=20
first), remove failing disk, re-add a disk.  So far it seems to work just=20
fine.  Just a curiosity: it seems to distribute all data between only two o=
f=20
the disks, the other two stay empty.  Is that desired behaviour?  Wouldn't =
it=20
be more efficient to distribute data across all disks?

(everything with 2.6.32-rc8. Filesystem was created with btrfs-tools 0.19.)

cheers
=2D- vbi

(((
P.S.: since recovery after disk failure is a tense moment where I don't wan=
t=20
to have to hunt around for the answer ...:

=2D-- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -53,6 +53,8 @@ static void print_usage(void)
        fprintf(stderr, "\t-a device add one device\n");
        fprintf(stderr, "\t-b balance chunks across all devices\n");
        fprintf(stderr, "\t-r device remove one device\n");
+       fprintf(stderr, "\t   use 'missing' as device name "
+               "to remove a failed device\n");
        exit(1);
 }
)))


=2D-=20
featured link: Debian Bookmark Collection - http://bookmarks.debian.net/

--nextPart2048369.uRRm852Zri
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAksbz85gGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJEIukMYvlp/fWbioAoNwsHAMV+adky3fAuNrD9azC
EuZrAJ9TcoCE8rs1WSBCjoTpVjqRFbbVtA==
=7kQU
-----END PGP SIGNATURE-----

--nextPart2048369.uRRm852Zri--
