Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38838 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2F0MGE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 08:06:04 -0400
Received: by wibhm11 with SMTP id hm11so5236524wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 05:06:02 -0700 (PDT)
Message-ID: <4FEAF723.1070601@grimmer.com>
Date: Wed, 27 Jun 2012 14:05:55 +0200
From: Lenz Grimmer <lenz@grimmer.com>
MIME-Version: 1.0
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: btrfs  filesystem defragment exits with non-zero return code (20)
 upon success
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2A9378DD2F458D58574119BE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2A9378DD2F458D58574119BE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

running "btrfs filesystem defrag" somehow always returns a non-zero exit =
code,
even when it succeeds:

[lenz@metis btrfs-progs]% sudo ./btrfs filesystem defrag -v /mnt
/mnt
Btrfs v0.19-102-g2482539-dirty
[lenz@metis btrfs-progs]% echo $?
20
[lenz@metis btrfs-progs]% sudo ./btrfs filesystem defrag -v /dev/loop0
/dev/loop0
ERROR: defrag failed on /dev/loop0 - Invalid argument
Btrfs v0.19-102-g2482539-dirty
total 1 failures
[lenz@metis btrfs-progs]% echo $?
1
[lenz@metis btrfs-progs]% sudo ./btrfs filesystem defrag -v /dev/loop0 /d=
ev/loop1
/dev/loop0
ERROR: defrag failed on /dev/loop0 - Invalid argument
/dev/loop1
ERROR: defrag failed on /dev/loop1 - Invalid argument
Btrfs v0.19-102-g2482539-dirty
total 2 failures
[lenz@metis btrfs-progs]% echo $?
1
[lenz@metis btrfs-progs]% sudo ./btrfs filesystem defrag -v /tmp
/tmp
ERROR: defrag failed on /tmp - Inappropriate ioctl for device
Btrfs v0.19-102-g2482539-dirty
total 1 failures
[lenz@metis btrfs-progs]% echo $?
1

I'm no C programmer, but looking at the end of the do_defrag function in
btrfs_cmds.c, I wonder if the last "return errors + 20" is correct? In ca=
se
that errors is greater than zero, the function would be left via the exit=
(1)
anyway, wouldn't it? In that case, wouldn't "return 0" at the end be more=

appropriate?

[SNIP]
  if (errors) {
    fprintf(stderr, "total %d failures\n", errors);
    exit(1);
  }

  free(av);
  return errors + 20;
[SNIP]

Thanks!

--=20
  Lenz Grimmer <lenz@grimmer.com> - http://www.lenzg.net/


--------------enig2A9378DD2F458D58574119BE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk/q9yQACgkQSVDhKrJykfJKOQCdEd+Fu2Aen1Sgo6wYLN+5pt+d
obQAn2ouXW1xLGotVzoefirqxxa+1Hu9
=j3lQ
-----END PGP SIGNATURE-----

--------------enig2A9378DD2F458D58574119BE--
