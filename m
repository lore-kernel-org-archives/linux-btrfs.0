Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60227 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2F0MPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 08:15:03 -0400
Date: Wed, 27 Jun 2012 13:15:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Lenz Grimmer <lenz@grimmer.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs  filesystem defragment exits with non-zero return code
 (20) upon success
Message-ID: <20120627121459.GJ25572@carfax.org.uk>
References: <4FEAF723.1070601@grimmer.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Do4IU1xF/9sod/r6"
In-Reply-To: <4FEAF723.1070601@grimmer.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Do4IU1xF/9sod/r6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 27, 2012 at 02:05:55PM +0200, Lenz Grimmer wrote:
> Hi,
> 
> running "btrfs filesystem defrag" somehow always returns a non-zero exit code,
> even when it succeeds:

   Yes, this is a known problem, and one that's on my list of things
to deal with. Thanks for the reminder, though.
 
> I'm no C programmer, but looking at the end of the do_defrag function in
> btrfs_cmds.c, I wonder if the last "return errors + 20" is correct? In case
> that errors is greater than zero, the function would be left via the exit(1)
> anyway, wouldn't it? In that case, wouldn't "return 0" at the end be more
> appropriate?

   Yeah, basically, it's doing something silly and unexpected with
return codes.

   Hugo.

> [SNIP]
>   if (errors) {
>     fprintf(stderr, "total %d failures\n", errors);
>     exit(1);
>   }
> 
>   free(av);
>   return errors + 20;
> [SNIP]
> 
> Thanks!
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Mixing mathematics and alcohol is dangerous.  Don't ---       
                            drink and derive.                            

--Do4IU1xF/9sod/r6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP6vlDIKyzvlFcI40RAvOHAJ9XP0ugFUSYpwF339eHb0LngOM2bQCglwpG
T2qHNkCl+Sn+Tc5bjo48Sbw=
=JYBp
-----END PGP SIGNATURE-----

--Do4IU1xF/9sod/r6--
