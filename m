From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Announcing btrfs-gui
Date: Wed, 23 Nov 2011 12:33:34 +0000
Message-ID: <20111123123333.GE28749@carfax.org.uk>
References: <20110601232058.GA22619@carfax.org.uk>
 <4EBDBCD9.8060009@vangasse.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Th5JPit8I3Q6/gDv"
Cc: linux-btrfs@vger.kernel.org
To: Amedee Van Gasse <amedee@vangasse.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EBDBCD9.8060009@vangasse.eu>
List-ID: <linux-btrfs.vger.kernel.org>


--Th5JPit8I3Q6/gDv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 12, 2011 at 01:24:57AM +0100, Amedee Van Gasse wrote:
> On 02-06-11 01:20, Hugo Mills wrote:
> >    Unless the traffic gets too high-volume, or unless someone
> >important objects, I'm going to suggest that bug reports should go to
> >this list for now (cc'd me, if you like). Note that this isn't an
> >"offical" btrfs project -- it's just something I knocked together on
> >my own.
> 
> 
> I seem to have stumbled upon a bug.
> During install, Ubuntu gives the user the option to use btrfs as the
> root filesystem. It automatically creates two subvolumes, @ (for /)
> and @home (for /home, only if no other partition is used for /home),
> like this:
> 
> mount | grep btrfs
> /dev/sda6 on / type btrfs (rw,subvol=@)
> /dev/sda6 on /home type btrfs (rw,subvol=@home)
> /dev/sda6 on
> /tmp/btrfs-gui-kl6zx1/12624/eba4f1e9-5b55-4e14-abb8-5a3cf3625c56
> type btrfs (rw,subvolid=0)
> 
> When gtrfs-gui scans for filesystems, it gives the error
> Root helper exception: b'@' is not JSON serializable
[snip]

   Mmm... That could be fun. :)

   Thanks for the bug report. I hope I'll have time to look into this
next week.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The English language has the mot juste for every occasion. ---    

--Th5JPit8I3Q6/gDv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOzOgdIKyzvlFcI40RAlvpAJ0QIvDK62XcFb+BTAIi/IQ9qxAo7ACcCVhz
Kwhbt61ykPr9auxDQTu4jJQ=
=GTFQ
-----END PGP SIGNATURE-----

--Th5JPit8I3Q6/gDv--
