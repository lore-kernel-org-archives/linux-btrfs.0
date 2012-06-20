Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60040 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2FTUvt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 16:51:49 -0400
Received: by wgbdr13 with SMTP id dr13so8361447wgb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2012 13:51:47 -0700 (PDT)
Date: Wed, 20 Jun 2012 23:56:52 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs hates lone HDDs on manycore systems
Message-ID: <20120620235652.606e2b43@sf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LGjP2GumYybDFkRD.MPg+4Z"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LGjP2GumYybDFkRD.MPg+4Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Most of io workers in btrfs don't take into account amount
of disks they deal with:

    fs/btrfs/disk-io.c:        fs_info->thread_pool_size =3D min_t(unsigned=
 long, num_online_cpus() + 2, 8);

It might not be a problem for 'write-only' workloads,
but it's a serious problem for read/write ones.

Let's consider simple setup:
   - dualcore (core2) laptop with sole HDD (5200 rpm)
   - slightly aged btrfs: ~50% of 200GB is filled
      and used as / (nothing special: stock mkfs.btrfs /dev/root)
   - kernel does not matter much. any 3.3.0+ would fit.
     3.5.0-rc3 runs here
   - tried both anticipatory and deadline schedulers. does not
      seem to matter that much

My "benchmark"[1] is gcc unpacking/perm-sanitizing. It
emulates typical workload of source based package manager.

When [1] is ran as 'sh torture.sh':
- first we see at least 4 'btrfs-endio-wri' hammering disk
   with random reads and writes in the 'untar' phase
- then we see 4 'btrfs-delayed-m' with similar effect
   in the 'chmod' phase

If it would be a quad-cpu laptop (typical i5) we would get 6(!)
threads chewing disk, so you get worse behaviour. System
becomes completely unusable. Right now I try to mitigate it
with 'thread_pool' mount option, but it looks like a crude hack.

Would be nice to have amount of parallel readers comparable to
number underlying spinning devices.

Thanks for your patience!

[1] torture.sh:
    #!/bin/sh
    gcc_url=3Dhttp://distfiles.gentoo.org/distfiles/gcc-4.7.0.tar.bz2
    gcc_tarball=3Dgcc-4.7.0.tar.bz2
    gcc_dir=3Dgcc-4.7.0
    [ -f "$gcc_tarball" ] || wget "$gcc_url"
    chatty() {
        echo "RUN: $@"
        /usr/bin/time "$@"
    }
    torture() {
        chatty rm -rf "${gcc_dir}"

        ### iotop pattern: scattered seeks/reads to death
        #25499 be/4 root       60.34 K/s   79.20 K/s  0.00 % 99.99 % [btrfs=
-endio-wri]
        #28151 be/4 root       56.57 K/s   60.34 K/s  0.00 % 99.73 % [btrfs=
-endio-wri]
        # 6181 be/4 root       56.57 K/s   71.66 K/s  0.00 % 96.96 % [flush=
-btrfs-1]
        #23881 be/4 root       52.80 K/s   52.80 K/s  0.00 % 93.70 % [btrfs=
-endio-wri]
        chatty tar -xjf "${gcc_tarball}"

        ### iotop pattern: scattered seeks/reads to death
        #29109 be/4 slyfox    870.05 K/s    0.00 B/s  0.00 % 97.05 % chmod =
-R 700 gcc-4.7.0/
        #28067 be/4 root      162.66 K/s  949.49 K/s  0.00 % 77.72 % [btrfs=
-delayed-m]
        #28164 be/4 root       22.70 K/s  215.62 K/s  0.00 % 14.23 % [btrfs=
-delayed-m]
        # 4690 be/4 root        0.00 B/s   15.13 K/s  0.00 %  0.00 % [btrfs=
-delayed-m]
        echo "now look at iotop"
        chatty chmod -R 700 "${gcc_dir}"/

        chatty sync
    }

    torture
    torture
    torture
    torture

--=20

  Sergei

--Sig_/LGjP2GumYybDFkRD.MPg+4Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk/iORsACgkQcaHudmEf86rz9ACbBbsNdIkMYEANfphkw2IEgXa7
CowAnRa2q5bwA3drRDg4nWI4b04plYtZ
=+7nn
-----END PGP SIGNATURE-----

--Sig_/LGjP2GumYybDFkRD.MPg+4Z--
