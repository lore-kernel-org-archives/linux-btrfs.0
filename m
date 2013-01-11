Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42617 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3AKWir (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 17:38:47 -0500
Date: Fri, 11 Jan 2013 22:38:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: partition question
Message-ID: <20130111223845.GV19051@carfax.org.uk>
References: <50F06639.6030409@home.nl>
 <818D716E-CEFF-4170-B470-574D6E98375E@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5ZoQamfY1dF16JN0"
In-Reply-To: <818D716E-CEFF-4170-B470-574D6E98375E@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5ZoQamfY1dF16JN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 11, 2013 at 03:34:25PM -0700, Chris Murphy wrote:
> On Jan 11, 2013, at 12:21 PM, Roelof Wobben <r.wobben@home.nl> wrote:
> > I have one thing I think I don't really understand about btrfs,
> > 
> > Normally if I use ext4 I make a  3 partitions for my distro.
> > 
> > one for boot about 1G
> > one for home about 30G
> > one for root for the rest of my 100G.
> > 
> > Now I wonder if I want to do the same with btrfs.
> > 
> > Can I do the same so make 3 partitions with btrfs or can I better make 1 partiton of 100G and make the /boot /home and  / subvolumes of the big partitiion.
> > 
> > Can one of you btfrs gurus shine a light of this matter ?

> You can make one Btrfs volume with /boot, /home, and / as
> subvolumes. GRUB2 2.00 can boot this arrangement, and that's the
> first caveat which is that many distributions are using older
> versions of GRUB2. It even works with Btrfs data/metadata profiles
> single, dup; and multiple device raid 0, 1, 10; and compression
> zlib, and lzo.
> 
> Swap still needs to be on a separate partition, as I don't think
> Btrfs is supporting swapfiles yet still, but maybe someone else can
> comment on the status of that.

   I don't know this area of the code at all well, but as I understand
it, there's been some work in the kernel (swap over NFS) which lays
down some of the underlying infrastructure we'd need to support
swapfiles on btrfs, but we don't have anything beyond that. I don't
know of anyone working on it, either.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- It's against my programming to impersonate a deity! ---       

--5ZoQamfY1dF16JN0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPCUdb9z9OVl50rAAQKmxQ//erVBQ+eqqYvVAR1UZXsOLG6k+nr2MGQO
pFj6tnzIVQe7g41ypCK4auD7Fj5kHCOOtODDcG2290D0LnpuSuM4roRSy5N88GYW
ved/U1dHTdAhBrkkanuf4eWD5DifKkSCArz00KZ6N+idaRdxy1MMgMbpAPpial2C
EPco7l8kQrCLA4A1J+79c33gHb3SnCsojQJlGc2P5L2zY7nz7vtjWeuHeEL227b/
zN/ojPGl2JFCIdtbDz05GsWH7Ydq+JQttoUShYy+PRB76a+NbJGdnWJwfibEs9i/
y6ReRUONjX6gn+n84ioNBFu0Gb1IeKiQrR33CdzVgNkZ2VGPIAiY8lRyGzWhhB51
eUWhC5F6sonAOB5moOlBaWXs7xYsAGPilflTMqM5Q4O6npD4wTCXL7lw+gKyDDKs
KOjywc70GPex+qffFp51cmfoyF6lMqDMRKhKVH/WsmFDZSlfcsPqqGoQUgXlwUkR
k8Rw2xSNR63BxB5JnnWsbybVOAE3l//5hkDq8VdKBx/+8AN/LJd/HiXvuCmoNIRS
Q790Q/ns8QoQqZVLrlX2G7pmMU1nSMVtIOg+IAxZpn8zlJ8aEGbuOXMbs9BlIp1c
uqdlK+fm/FQlCxyc+0XFUQXFbjR4wc/ewvB3bPN9vMuzwXkD9lzl4aAq7x5v8B17
uJrCS+Z5Hkw=
=9D93
-----END PGP SIGNATURE-----

--5ZoQamfY1dF16JN0--
