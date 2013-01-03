Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36531 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3ACVXp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 16:23:45 -0500
Date: Thu, 3 Jan 2013 21:23:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Option LABEL
Message-ID: <20130103212342.GE19051@carfax.org.uk>
References: <1CC7957D-2FAD-4E8D-9850-6A06458FF1ED@colorremedies.com>
 <CO8jEAMeCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jn9znQ5OoOl0oegR"
In-Reply-To: <CO8jEAMeCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jn9znQ5OoOl0oegR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 03, 2013 at 09:28:00PM +0100, Helmut Hullen wrote:
> Hallo, Chris,
> 
> Du meintest am 03.01.13:
> 
> > So 'btrfs fi label' relabeling with an unmounted system changes the
> > file system label metadata on all member devices, according to btrfs
> > fi label. Now when I use file:
> 
> On my system (a bundle of /dev/sdb, /dev/sdc, /dev/sdd)
> 
>         btrfs fi label /dev/sdb mylabel
> 
> only sets the label on the (unmounted) device /dev/sdb. "/dev/sdc" and  
> "/dev/sdd" remain without label.

   This is a bug.

> > # file -s /dev/sdb
> > /dev/sdb: BTRFS Filesystem (label "test2", sectorsize 4096, nodesize
> > 4096, leafsize 4096)
> > # file -s /dev/sdc
> > /dev/sdc: BTRFS Filesystem (label "test2", sectorsize 4096, nodesize
> > 4096, leafsize 4096)
> 
> > Again it correctly reports the label, even though I had only changed
> > the label on sdc (which actually is improper language, I changed the
> > label on the file system implied by device sdc which also extends to
> > device sdb).
> 
> Strange.
> Actually the btrfs system is mounted and has to run a job with needs  
> about 5 days - I may not stop it.
> 
> But before the first mounting of the system only "/dev/sdb" showed the  
> label. Maybe with the first mounting the label spreads over all disks.

   Probably.

> > And then for blkid:
> 
> > # blkid
> > /dev/sdb: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717"
> > UUID_SUB="a5bbaa83-6d6f-45dc-9804-9442350c3bc9" TYPE="btrfs"
> > /dev/sdc: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717"
> > UUID_SUB="01e0bc77-cfdf-4bd7-bfd3-05e14affa66a" TYPE="btrfs"
> 
> Strange - in another way.
> 
> Here "blkid" (without any device) hangs. See the attachment ("strace  
> blkid").
[snip]
> stat64("/dev/fd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
> open("/dev/fd0", O_RDONLY|O_LARGEFILE)  = 4
> fadvise64_64(4, 0, 0, POSIX_FADV_RANDOM) = 0
> fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
> uname({sys="Linux", node="izar", ...})  = 0
> ioctl(4, BLKGETSIZE64, 0x8050d5c)       = 0
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output error)
> _llseek(4, 0, [0], SEEK_SET)            = 0
> read(4,  <unfinished ...>

   This is waiting for /dev/fd0 to return some data. I guess it'll
give up after a few times round (8? 10?) and return some results.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- Putting U back in Honor,  Valor, and Trth ---            

--jn9znQ5OoOl0oegR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUBUOX23r9z9OVl50rAAQLV5A/2LMEC54VjmYys5L+XIa0Tjqct2ex2OmnK
L3kxQNtHLKxyOdzjUt+4tJaHLpxIpsp3XjOyL3+Hca1+JgWie3n5cVrQOxvdEfNU
Wp0y32U1jpX8hQjOKZNQrkzF8wtmEdmw6YNd0gQ0xFqfzUGv7jgfGDirf8oO1gAX
RpthwMhZ2w/FZ4wureNYVlOxZ87ZTdyFQgL5wszlWaOVxiyoslejglDgqXMqT6gf
rAR3I4CHSNSjHjGtJUrnb1chReQrFNJmpAcocGmCc0irj12sGdoGW5O2/0Dbbm66
gYusoRPcuw0y5GS40ksshUvvSLYayn8Vhrxu6f3G4C9/eCyHIzvK6GFeHzTX5JfG
5J4vEJhPg9m1OU9puIuEUJ5CQkej4/zZgoDxI8HzjG0wziSuIiYW+nVxuo5sV/Xy
iD6HDqi2K6RoDsLN26JlqeHy+lcTDDUtktWJbGFd9OBVMOM+EQWSQcfYf5upijwb
CZAX9fEbVbBaXN0lyHorEMxoJ7jMyFA+/7KgM3JBvwd3BbaFUBQgV8NQiVdKqjMR
Drf9Pz9fnAbleIIuy9O7Vz+HsMBy0Jch9IsdFKSHuwKc2wtNUnoYPBsX4BcSl+C6
razxmP86Xh9WkxXfa73sbcF6UxBlErNXiFePsHCI7d7JV+w/uq4zE4ZZGodhXX/m
FnNFNTGVIw==
=aLQx
-----END PGP SIGNATURE-----

--jn9znQ5OoOl0oegR--
