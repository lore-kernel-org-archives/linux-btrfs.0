From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Avoid error message during a scan of a static /dev directory
Date: Fri, 21 Oct 2011 19:36:36 +0200
Message-ID: <3718544.ruIhNEY1ge@venice>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12566422.1DUbKCobXQ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Cc: Helmut Hullen <Hullen@t-online.de>
To: linux-btrfs@vger.kernel.org, hugo@carfax.org.uk,
	chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart12566422.1DUbKCobXQ
Content-Type: multipart/mixed; boundary="nextPart2486840.o9Zh6TCADQ"
Content-Transfer-Encoding: 7Bit


--nextPart2486840.o9Zh6TCADQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi all,

as highlighted by Helmut (see "Re: btrfs still looks for not existing 
devices"), some btrfs tools (like mkfs.btrfs, btrfsck, btrfs-image, btrfs-
label...) have the habit to scan the /dev directories looking for a valid 
block device in order to assemble all the devices of a btrfs filesystems.

Some systems doesn't use udev, so they have a static /dev with a lot of block 
device nodes without a real device. Another source of error is that some 
devices return ENOMEDIUM (No medium found) when they haven't a medium (think 
about a CD with the tray empty, or a SD/CF reader). These two kind of errors 
are reported by these tools. 

I think that it is perfectly safe to ignore these error because the fact that 
a device doesn't exist or a CD is empty is not an error which should be 
handled and/or reported when the system is trying to assemble the devices for 
a filesystem.

In any case if a device *needed* for a btrfs filesystem is missing, an error is 
raised.

The patch enclosed allow to ignore the errors:
- ENXIO (device don't exists) 
- ENOMEDIUM (No medium found)

avoiding spurious messages during a scanning of the /dev directory.

I have to highlight that if a CDROM/DVD is inserted, the btrfs tools read the 
cdrom, and this is a very slow operation.

Hugo, Chris,
please apply.

Anyway comments are welcome.

BR


P.S.
you can pull this patch from the following repository:

        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

branch

	skip-not-existent-devices

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart2486840.o9Zh6TCADQ
Content-Disposition: inline; filename="skip-not-existant-devices.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="skip-not-existant-devices.diff"

commit 3635fcf3f7358f006a5025b9773034088bdd01fd
Author: Goffredo Baroncelli <kreijack@inwind.it>
Date:   Fri Oct 21 19:00:28 2011 +0200

    Ignore the error ENXIO and ENOMEDIUM during a devs scan
    
    Ignore the error ENXIO (device don't exists) and ENOMEDIUM (
    No medium found -> like a cd tray empty) in the function
    btrfs_scan_one_dir.
    This avoids spurios errors due to an empty CD or a block device node
    without a device (which is frequent in a static /dev).
    
    
    Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

diff --git a/utils.c b/utils.c
index 86c643c..5761e47 100644
--- a/utils.c
+++ b/utils.c
@@ -997,8 +997,14 @@ again:
 		}
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
-			fprintf(stderr, "failed to read %s: %s\n", fullpath,
-					strerror(errno));
+			/* ignore the following errors:
+				ENXIO (device don't exists) 
+				ENOMEDIUM (No medium found -> 
+					like a cd tray empty)
+			*/
+			if(errno != ENXIO && errno != ENOMEDIUM) 
+				fprintf(stderr, "failed to read %s: %s\n", 
+					fullpath, strerror(errno));
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,

--nextPart2486840.o9Zh6TCADQ--

--nextPart12566422.1DUbKCobXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOoa2kvwTxYT3FBRIRAs04AKCATM7N936vP0ysKEr+8PTmypnFEACZAaLF
zXjH/jSb3zpgrJCgpEFx6sU=
=ZAUV
-----END PGP SIGNATURE-----

--nextPart12566422.1DUbKCobXQ--

