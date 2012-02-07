From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 0/3] Btrfs-progs: restriper interface
Date: Tue, 7 Feb 2012 11:05:05 +0000
Message-ID: <20120207110505.GE19330@carfax.org.uk>
References: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
 <201202041406.28273.kreijack@inwind.it>
 <20120204144717.GB10916@zambezi.lan>
 <201202062320.19154.kreijack@inwind.it>
 <20120207093037.GA9690@zambezi.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q8BnQc91gJZX4vDc"
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120207093037.GA9690@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>


--Q8BnQc91gJZX4vDc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 11:30:37AM +0200, Ilya Dryomov wrote:
> On Mon, Feb 06, 2012 at 11:20:18PM +0100, Goffredo Baroncelli wrote:
> > If exist a filesystem called 's' 
> > 
> > # btrfs fi bal s
> > 
> > could be:
> > 
> > 1) an error (missing parameters for the command "btrfs filesystem balance 
> > start/status" )
> > 2) the starting of the balance of the filesystem 's'
> 
> It's true, but you are supposed to look at the synopsis before using new
> commands.

   Haha. This is naive at best.

   I'm with Goffredo on this one -- I would much prefer to stick to
commands of precisely two words: a group and an action.

   That should mean that we have "filesystem balance" as a synonym for
"balance start", and all the other restriper functions under "balance
XYZ". Then the remaining parameter will always be the filesystem path.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "How deep will this sub go?" "Oh,  she'll go all the way to ---   
                    the bottom if we don't stop her."                    

--Q8BnQc91gJZX4vDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPMQVgIKyzvlFcI40RAgA4AKC6ex6t84FY92aXeVEuT9/QzxUH7gCgpJFC
ryt6w7TQZ1wFrt/FgDenCXU=
=CuKO
-----END PGP SIGNATURE-----

--Q8BnQc91gJZX4vDc--
