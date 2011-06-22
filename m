From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [HELP!] parent transid verify failed on 600755752960 wanted
 757102 found 756726
Date: Wed, 22 Jun 2011 19:45:05 +0100
Message-ID: <20110622184505.GA3837@carfax.org.uk>
References: <BANLkTimgsJa6MzR+Gm4vCkW4wqku9NjxFw@mail.gmail.com>
 <loom.20110621T155927-215@post.gmane.org>
 <BANLkTikrDb4dGjgSi=1OOaLLcffmrdaLTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Cc: Daniel Witzel <dannyboy48888@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Francesco R <vivo75@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikrDb4dGjgSi=1OOaLLcffmrdaLTA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 21, 2011 at 05:01:53PM +0200, Francesco R wrote:
> 2011/6/21 Daniel Witzel <dannyboy48888@gmail.com>:
> > Welcome to the club, I have a similar issue. We pretty much have to wait for the
> > fsck tool to finish being developed. If possible unhook the drives and leave
> > them be until the tool is done. I don't know when it will be done as I am not a
> > developer, mearly a follower.
> >
> 
> There are tools to view the metadata stored as raid10? possibly in
> high level language?
> 
> I see Chris Mason stopped git commits to btrfs-progs-unstable in 2010,
> there is someone working on it?

   There have been lots of commits and patches since then. The "tmp"
branch contains a bunch of commits from Chris, and the
"integration-20110616" branch in my git repository[1] contains more or
less all of the other patches that have made it to this mailing list
since.

   Sadly, none of them contain the new btrfsck code. :(

   Hugo.

[1] http://git.darksatanic.net/repo/btrfs-progs-unstable.git/

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- There are three mistaiks in this sentance. ---            

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOAjgxIKyzvlFcI40RAjy6AJ4qg9lrh6e7TPy/y87y6hT21Ad2eQCg1GJr
EmnqJ5xlc+bzxVrz0R+GRk4=
=4cZP
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
