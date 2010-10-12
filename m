From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: converting one-disk btrfs into RAID-1?
Date: Tue, 12 Oct 2010 10:49:35 +0100
Message-ID: <20101012094935.GA2338@selene>
References: <4CB2FF03.8090608@wpkg.org>
 <m3ocb0irqj.fsf@pullcord.laptop.org>
 <i919v8$n91$1@dough.gmane.org>
 <20101012093431.GC30730@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101012093431.GC30730@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 12, 2010 at 11:34:31AM +0200, Tomasz Torcz wrote:
> On Tue, Oct 12, 2010 at 11:32:07AM +0200, David Brown wrote:
> > Is it possible to view the raid levels of data and meta data for an
> > existing btrfs filesystem?  It's easy to pick them when creating the
> > system, but I couldn't find any way to view them afterwards.
> 
>   "btrfs f df" will show them, except for few kernel releases when the ioctl()
> was broken.

   Umm...

hrm@vlad:~ $ sudo btrfs fi df /mnt/
[sudo] password for hrm: 
Data: total=303.01GB, used=302.16GB
Metadata: total=3.01GB, used=476.77MB
System: total=11.88MB, used=36.00KB

   This is the latest btrfs git kernel and tools. What should I be
seeing here?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- emacs: Emacs Makes A Computer Slow. ---               

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMtC8vIKyzvlFcI40RAjihAKDTJKBENd32yACPHrlj1DHgtR2stACffyyb
caMF8pDYHpFq06nlL93sasQ=
=rga/
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
