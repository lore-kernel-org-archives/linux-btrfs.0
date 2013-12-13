Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33889 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3LMWzY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 17:55:24 -0500
Date: Fri, 13 Dec 2013 22:55:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-send-receive vs rsync for (incremental/full) backups
Message-ID: <20131213225516.GQ9738@carfax.org.uk>
References: <l8fo25$a4h$1@ger.gmane.org>
 <20131213203554.GP9738@carfax.org.uk>
 <3D785BE5-E19C-4C32-8CF9-D10F106727D6@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b0op/nKJ9CeIhp9z"
In-Reply-To: <3D785BE5-E19C-4C32-8CF9-D10F106727D6@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--b0op/nKJ9CeIhp9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 13, 2013 at 02:30:26PM -0700, Chris Murphy wrote:
> 
> On Dec 13, 2013, at 1:35 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Fri, Dec 13, 2013 at 07:44:16PM +0000, Martin wrote:
> >> OK... So for backing up across a local network to a second physical host...
> >> 
> >> Is btrfs-send-receive stable enough now to be used?
> > 
> >   It seems to be OK for me at the moment -- I'm not running it across
> > a network (yet), but I am using it between different filesystems on
> > the same host, using pipes.

> Question. Are the source file system's checksums (and metadata)
> preserved in the send file?

   I don't think checksums are transported (from what I remember of
the FAR format).

> Or does the send file just contain data, and checksums are
> recomputed on receive? I'm curious if the send file can be stored on
> a non-checksumming file system, and yet have a means to verify the
> integrity of the files once received. Either the checksums in the
> send file being check during receive, or subsequent to receive
> completion by using scrub?

   The FAR format contains a sequence of what amount to FS commands:
there are equivalents of cp, rm, chmod, chown, setfattr, cat (of data
inline in the FAR file). There's also a data type that clones an
extent from a file in another subvolume with a given UUID. Assuming
you have some way of keeping track of subvolume UUIDs on an FS that
doesn't support them, there's no reason you can't generate or unpack
FAR files on a non-checksumming (and non-CoW) FS.

> And yes I can confirm that send outputting to a file on a 2nd drive,
> and receiving it to yet another drive does work, and the source and
> destination subvolumes are the same in seemingly every way. I didn't
> separately rsync checksum compare the two subvolumes, however. That
> seems like possibly a good test. I also haven't tried doing it over
> a network.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Once is happenstance; twice is coincidence; three times ---     
                            is enemy action.                             

--b0op/nKJ9CeIhp9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUquQVFheFHXiqx3kAQJgBQ//ROUCzwujnkwDuItAi32RNkPyp7wpZeR4
QVuKmFfIIJJqbO+9dpAWBoFlCgj0agozhY1vD1lpSlsBT0jKHraRttB+CevnhkqS
/KFKP66UdV8CU1mfB5zaUnYyU5d8JkgspwqImIcOgHohDh1ba0/xlekk39pmvfTe
flyWxu6yUJjCs7962Au9fWMVMxBAgqcnoSJB+IKHUzEW+80Aa8Fq2K5xRvLB3bgm
Ce/PTnWvnrPtB2ODrKigUt0W6WVn7/Mot+h9UQu8+WNEJkhTSj0fqxQfRjSIU7UM
GP//6cOJ9eHKGP6i3rg7/Uycvh8za4fX/I3I368QZorHbFT6MqxpCnnxi2f0H961
Fmd/APlAr0pEnL7tpTLgX8/uzN9YYAJ+QKrH+ujfZt+pyQg/N3oAU/ET8shFC5Sy
hqTO5MYNzETFG71vhMn54fJLRL8/6cWJOa8O9QbZrXmiRr98/RrNntscQTwTEm4x
LiUY2Di0TOPVUXq33tJ8L/0HajBex9GJ/87SyB3X8ZDz3O3DzZV5DvTgFS79i8TW
8+h+6UX7Gy/GzClmmO43fwbJmH24T38qYeUbMXn9fkgqRRoD5DZ2sgMWMuqkZaFL
Yn9MuH4hqoml+2N2j3gkhrGPQXCXl424QWDypyn8oKZQakI57ioVuyVH7l/ghZyu
cs/3bRIxyns=
=5jTw
-----END PGP SIGNATURE-----

--b0op/nKJ9CeIhp9z--
