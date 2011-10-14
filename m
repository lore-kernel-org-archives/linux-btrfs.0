From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs still looks for not existing devices
Date: Fri, 14 Oct 2011 16:21:16 +0100
Message-ID: <20111014152116.GL21931@carfax.org.uk>
References: <20111014140516.GJ21931@carfax.org.uk>
 <BvpRQTCy1uB@helmut.hullen.de>
 <20111014150824.GK21931@carfax.org.uk>
 <20111014151432.GA19381@mother.jarsat.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dpynvXbW/eW9Tpc3"
To: Tomasz Torcz <tomek@pipebreaker.pl>, helmut@hullen.de,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111014151432.GA19381@mother.jarsat.pl>
List-ID: <linux-btrfs.vger.kernel.org>


--dpynvXbW/eW9Tpc3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 14, 2011 at 05:14:32PM +0200, Tomasz Torcz wrote:
> On Fri, Oct 14, 2011 at 04:08:24PM +0100, Hugo Mills wrote:
> > On Fri, Oct 14, 2011 at 04:59:00PM +0200, Helmut Hullen wrote:
> > > Du meintest am 14.10.11:
> > > I've just tried
> > > 
> > >    git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git
> > > 
> > > and got the answer
> > > 
> > > + git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git
> > > git.darksatanic.net[0: 212.13.194.111]: errno=Connection refused
> > > git.darksatanic.net[0: 2001:ba8:1f1:f1d9:216:3eff:fe14:aef9]: errno=Network is unreachable
> > > fatal: unable to connect a socket (Network is unreachable)
> > > 
> > > -----------------------------
> > > 
> > > Have I got just another typo (or user mistake), or is there another  
> > > problem?
>
>   I see the same problem from totally different network, tcptraceroute
> to git port ends with:
     ^^^^^^^^

   D'oh. Sorry, I only just noticed this. I don't run a git server -- you
need http:// not git://

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- UNIX:  Japanese brand of food containers. ---            

--dpynvXbW/eW9Tpc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOmFNsIKyzvlFcI40RAjbzAJ9tAFlzSTLxnk9yMj5n7HZbPF36RgCgky54
aqCH1XdnN0KtyDtvnqcye8E=
=xDj/
-----END PGP SIGNATURE-----

--dpynvXbW/eW9Tpc3--
