Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38857 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab2F2O3U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 10:29:20 -0400
Date: Fri, 29 Jun 2012 15:29:17 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Richard Cooper <richard@richardcooper.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel panic from "btrfs subvolume delete"
Message-ID: <20120629142916.GL25572@carfax.org.uk>
References: <B53F1BEB-C285-4A01-A61A-4B324CB6FA7F@richardcooper.net>
 <CAG1y0seoS2c7d=jQgrZNF0aAJPrgTKbL1v6JzFigCk9ZMZ7H+w@mail.gmail.com>
 <1E782A38-6632-406F-A5BB-D42E78F5AAE3@richardcooper.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/jkxxxtAhYIHVDuh"
In-Reply-To: <1E782A38-6632-406F-A5BB-D42E78F5AAE3@richardcooper.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/jkxxxtAhYIHVDuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 29, 2012 at 03:23:13PM +0100, Richard Cooper wrote:
> 
> On 29 Jun 2012, at 11:42, Fajar A. Nugraha wrote:
> >> What should I do now? Do I need to upgrade to a more recent btrfs?
> > 
> > Yep
> > 
> >> If so, how?
> > 
> > https://blogs.oracle.com/linux/entry/oracle_unbreakable_enterprise_kernel_release
> > http://elrepo.org/tiki/kernel-ml
> 
> Perfect, thank you! I was looking for a mainline kernel yum repo but my google-fu was failing me. That looks like just what I need.
> 
> I've installed kernel v3.4.4 from http://elrepo.org/tiki/kernel-ml and that seems to have fixed my kernel panic. I'm still using the default Cent OS 6 versions of the btrfs userspace programs (v0.19). Any reason why that might be a bad idea?

   You miss out on new features (like scrub and btrfsck). Note that
"0.19" could actually be any version from the last 3 years or so. Most
distributions these days are putting a date in their package names --
anything from 20120328 or so is good.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Charting the inexorable advance of Western syphilisation... ---   

--/jkxxxtAhYIHVDuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP7bu8IKyzvlFcI40RAlviAKDGETqMrEzpZ6piSigStlX5NSn0+ACdETwl
GZVah+SpKLpohNvjwXNRDmU=
=VURS
-----END PGP SIGNATURE-----

--/jkxxxtAhYIHVDuh--
