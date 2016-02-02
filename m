Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46390 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbcBBOfh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 09:35:37 -0500
Date: Tue, 2 Feb 2016 14:35:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Wrong df Avail space on three disk RAID1 when empty
Message-ID: <20160202143535.GG8313@carfax.org.uk>
References: <56B0BA48.6070603@prismatelecomtesting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nqkreNcslJAfgyzk"
In-Reply-To: <56B0BA48.6070603@prismatelecomtesting.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nqkreNcslJAfgyzk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 02, 2016 at 03:16:40PM +0100, Marco Lorenzo Crociani wrote:
> Hi,
> df on btrfs RAID1 fs on 3 disks  (they are RAID0 hardware, two disk,
> arrays but its not important right?) show wrong avail space when
> empty
> 
> # uname -a
> Linux kvm4.prisma 4.4.0-2.el7.elrepo.x86_64 #1 SMP Tue Jan 26
> 13:06:01 EST 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
> # btrfs --version
> btrfs-progs v4.4
> 
> #   btrfs fi show
> Label: 'data'  uuid: 4421464d-479c-44c4-9f01-8df0f7d05bd2
>         Total devices 3 FS bytes used 640.00KiB
>         devid    1 size 7.28TiB used 2.00GiB path /dev/sdb
>         devid    2 size 7.28TiB used 2.01GiB path /dev/sdc
>         devid    3 size 7.28TiB used 2.01GiB path /dev/sdd
> 
> # btrfs fi df /data
> Data, RAID1: total=1.00GiB, used=512.00KiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=112.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> 
> I expect to get from df -h some like
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb                       11T   17M    11T   1% /data
> but I get:
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb                       11T   17M    7,3T   1% /data

   I've noticed this kind of error, too, although not to such a great
degree. The space estimation is definitely broken, although not to
such a bad degree as it used to be.

   There's a relatively complex (but implementable) algorithm that can
be used to determine the remaining usable space quite precisely. I'm
guessing that that's not in use here. :)

   I'll try to dig out the actual formula this evening and post it to
the list for reference. (It's the formula that's used in the
btrfs-usage tool[1], if anyone wants to see the JavaScript
implementation).

   Hugo.

[1] http://carfax.org.uk/btrfs-usage/


> If I fill the fs
> 
> # ls -laht
> totale 11T
> -rw-r--r--.  1 root root 921G  1 feb 16.17 prova10
> drwxr-xr-x.  1 root root  134  1 feb 15.23 .
> -rw-r--r--.  1 root root 1,0T  1 feb 14.00 prova9
> -rw-r--r--.  1 root root 1,0T  1 feb 13.07 prova8
> -rw-r--r--.  1 root root 1,0T  1 feb 12.20 prova7
> -rw-r--r--.  1 root root 1,0T 28 gen 21.50 prova6
> -rw-r--r--.  1 root root 1,0T 28 gen 21.08 prova5
> -rw-r--r--.  1 root root 1,0T 28 gen 20.28 prova4
> -rw-r--r--.  1 root root 1,0T 28 gen 19.50 prova3
> -rw-r--r--.  1 root root 1,0T 28 gen 19.13 prova2
> -rw-r--r--.  1 root root 1,0T 28 gen 18.37 prova1
> -rw-r--r--.  1 root root 1,0T 28 gen 18.02 prova0
> dr-xr-xr-x. 18 root root 4,0K 28 gen 15.30 ..
> 
> I get:
> 
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb                       11T   11T    256K 100% /data
> 
> # btrfs fi df /data/
> Data, RAID1: total=10.90TiB, used=10.90TiB
> System, RAID1: total=8.00MiB, used=1.50MiB
> Metadata, RAID1: total=13.00GiB, used=11.24GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 

-- 
Hugo Mills             | "He's a nutcase, you know. There's no getting away
hugo@... carfax.org.uk | from it -- he'll end up with a knighthood"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                         Lexy, The League of Gentlemen

--nqkreNcslJAfgyzk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWsL63AAoJEFheFHXiqx3kT2EP/1j+rfplfHQTNfDFvvyOJIQu
WIX9bXXA/QJgMgCNFsojgNEMS1LPDcGAB8Ky/UPQqgy4Zz4EW7J2IkClvUTygrf2
86dkoR8Hsm0ohmUgOHL/u2oNR7DueSJeM3Khjzjx75KOhHSBOa5FyJY5/aplFj2R
KNjsqTZkTHwVOIWiRagwvbEMAMDb7WOMOv+WUxmusvXuiv7+RXd0JVNRBoUt8Mar
2uPfpKDFCeDP54fbIjJEC3MnkZmkxioKEu76b9T9xh1xdtvdn5SU+fivYPIoq8Ao
QB7fvUKND/Z3q9QZOZhUDdRId4jfVGnSABDOkJdzOaF4T5A78OtAfz/98iP76rpA
penOOfnK4zpi0EWmmmdlwW7AFsxzC1NWmhhNfAJRpFmmLxUvfsPllznPRPkeJ+5w
GhlpE32Tc9Pv+0qJOIaz/MYbfPAEW2p7F0KbG2GZo0HU05aFI7IUv8kFhMTFrQtW
wqcG/QBuxbfepAUGXsrTh0dLhcHk2Cr89kNEUHM5OU1J5i7wn1dcgDceEGURFTW2
Cm19rPcYgOItJ8//p0KVWJRFX6dB6F/rWrNe6TNywzHclvByFVO3J23FMe7VPlfi
X7lxIVR6W/jdiBL8riQsJBO7pUvajw9dyoJh9NSwMEDH8/A3twztsHP42XPNefWY
q/D3u7S1vaq6mjJ0tmyX
=jzIV
-----END PGP SIGNATURE-----

--nqkreNcslJAfgyzk--
