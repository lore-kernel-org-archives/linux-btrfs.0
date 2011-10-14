From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs still looks for not existing devices
Date: Fri, 14 Oct 2011 16:08:24 +0100
Message-ID: <20111014150824.GK21931@carfax.org.uk>
References: <20111014140516.GJ21931@carfax.org.uk>
 <BvpRQTCy1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wIc/V6YLA2QdyfT4"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BvpRQTCy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--wIc/V6YLA2QdyfT4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 14, 2011 at 04:59:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> Du meintest am 14.10.11:
> 
> >    This is not a kernel issue, it's a purely userspace issue. Try the
> > latest integration branch from git.darksatanic.net, which should have
> > a fix for it.
> 
> I've just tried
> 
>    git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git
> 
> and got the answer
> 
> + git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git
> git.darksatanic.net[0: 212.13.194.111]: errno=Connection refused
> git.darksatanic.net[0: 2001:ba8:1f1:f1d9:216:3eff:fe14:aef9]: errno=Network is unreachable
> fatal: unable to connect a socket (Network is unreachable)
> 
> -----------------------------
> 
> Have I got just another typo (or user mistake), or is there another  
> problem?

   It seems to be OK for me from here (the server is in a totally
different network to where I am), so I think it must be a problem
local to you. The IP addresses (both v4 and v6) look like the right
ones, and I'm not aware of having any blocking in place from my
service provider. Do you have a "transparent" proxy in the way?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- UNIX:  Japanese brand of food containers. ---            

--wIc/V6YLA2QdyfT4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOmFBoIKyzvlFcI40RAun9AKDU2CMbGk51JhUR95UhdRe3nunCwACfRZn4
ccZ7C4R2RuH6llfvkJzOeao=
=99IS
-----END PGP SIGNATURE-----

--wIc/V6YLA2QdyfT4--
