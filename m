From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs w/ckd
Date: Thu, 2 Jun 2011 21:43:06 +0100
Message-ID: <20110602204306.GD8002@carfax.org.uk>
References: <47C68B986D117D40A7E109AE2FC85C291128DB4A12@MX01A.corp.emc.com>
 <20110602195956.GC8002@carfax.org.uk>
 <47C68B986D117D40A7E109AE2FC85C291128DB4A33@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: kathleen.hodge@emc.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <47C68B986D117D40A7E109AE2FC85C291128DB4A33@MX01A.corp.emc.com>
List-ID: <linux-btrfs.vger.kernel.org>


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Kathleen,

On Thu, Jun 02, 2011 at 04:20:55PM -0400, kathleen.hodge@emc.com wrote:
> Hi Hugo, I don't seem to have mkfs.btrfs.  Here is the Red Hat 6.0 version I'm running, should it be included?
> 
> Linux LN164088.LSS.EMC.COM 2.6.32-71.el6.s390x #1 SMP Wed Sep 1 01:38:33 EDT 2010 s390x s390x s390x GNU/Linux

   OK, first -- kernel 2.6.32 is *massively* old in btrfs terms. There
are a whole bunch of pretty serious bugs that have been fixed between
then and now. You should really be running a kernel no earlier than
2.6.38: version 2.6.39 is preferable.

   You should also be using the latest btrfs-progs from the git
repository:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
$ git co tmp
$ make
$ sudo make install

   (You may need the libuuid-devel package to get this to build.
There's also a problem with the most recent gcc, but that probably
won't apply to you; it's easily dealt with if you do hit it).

   Once you've made and installed btrfs-progs, you will have
mkfs.btrfs, and the btrfs tool, which is used for managing your
filesystem.

   You should also ensure that you're keeping good and regular backups
of the data in your filesystem, and be prepared to use them -- btrfs
is still considered experimental, and if things go wrong, the fastest
way at the moment to get your data back is often to restore from
backups.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I don't like the look of it,  I tell you." "Well, stop ---     
                          looking at it, then."                          

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN5/XaIKyzvlFcI40RAvFdAJ0eWGBUs48soItdDA4+73PgUjcGfQCcCism
kp8NLA1PL1ECruEgQK5yBTQ=
=mGO+
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
