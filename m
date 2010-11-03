From: Sean Reifschneider <jafo@tummy.com>
Subject: Re: Patch to provide "btrfs subvolume last-gen".
Date: Wed, 03 Nov 2010 05:04:58 -0600
Message-ID: <4CD141DA.8050709@tummy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1E65A02E545695F172220921"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E65A02E545695F172220921
Content-Type: multipart/mixed;
 boundary="------------080908000005050907090002"

This is a multi-part message in MIME format.
--------------080908000005050907090002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks for the feedback Goffredo.  I've given it some thought and in the
spirit of "small programs cooperating", it seems like just having it writ=
e
out the generation id without the surrounding text makes sense.  The text=

I pulled from the find-new sub-command, where it makes sense (to
differentiate it from the other changes).

The patch here makes that change and also adds the man page entries for
last-gen and find-new (since last-gen refers to it, but there isn't any
documentation for it).

Thanks,
Sean

--------------080908000005050907090002
Content-Type: text/plain;
 name="0002-Updating-man-page-and-removing-transid-text.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0002-Updating-man-page-and-removing-transid-text.patch"

=46rom 17459dcc8cc9d54963cbfd844006340315b73e86 Mon Sep 17 00:00:00 2001
From: Sean Reifschneider <jafo@tummy.com>
Date: Wed, 3 Nov 2010 04:59:20 -0600
Subject: [PATCH 2/2] Updating man page and removing transid text.

---
 btrfs_cmds.c   |    2 +-
 man/btrfs.8.in |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 25eafb8..9439457 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -272,7 +272,7 @@ int do_get_latest_gen(int argc, char **argv)
 		return 12;
 	}
 	max_found =3D find_root_gen(fd);
-	printf("transid marker was %llu\n", (unsigned long long)max_found);
+	printf("%llu\n", (unsigned long long)max_found);
 	return 0;
 }
=20
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..23ba7d2 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,6 +15,10 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume last-gen\fP\fI <path>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <path> <last_gen>\fP
+.PP
 \fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP=

 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
@@ -96,6 +100,21 @@ These <ID> may be used by the \fBsubvolume set-defaul=
t\fR command, or at
 mount time via the \fIsubvol=3D\fR option.
 .TP
=20
+\fBsubvolume last-gen\fR\fI <path>\fR
+Return the most current generation id of \fI<path>\fR.  This number is
+suitable for use with the \fBsubvolume find-new\fR command, for example.=

+A single number is sent to stdout, representing the most recent generati=
on
+within a subvolume/snapshot.
+
+\fBsubvolume find-new\fR\fI <path> <last_gen>\fR
+Display changes to the subvolume \fI<path>\fR since the generation id
+\fI<last_gen>\fR.  The resulting information includes filenames, offset
+within the file, length, and more.  The last line output displays the mo=
st
+recent generation id represented by the output.  For example, one could
+feed this id back in to get an ongoing report of changes to the
+subvolume.
+.TP
+
 \fBsubvolume set-default\fR\fI <id> <path>\fR
 Set the subvolume of the filesystem \fI<path>\fR which is mounted as=20
 \fIdefault\fR. The subvolume is identified by \fB<id>\fR, which=20
--=20
1.7.3.1


--------------080908000005050907090002--

--------------enig1E65A02E545695F172220921
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iD8DBQFM0UHaxUhyMYEjVX0RAjtMAJ9V/29ublm7g3l1vzpG44H4TVTKVQCgnXpd
UZY/1c8u1cCU5RII5QY2KRs=
=DZpy
-----END PGP SIGNATURE-----

--------------enig1E65A02E545695F172220921--
