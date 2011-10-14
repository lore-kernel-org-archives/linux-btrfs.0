From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs still looks for not existing devices
Date: Fri, 14 Oct 2011 15:05:16 +0100
Message-ID: <20111014140516.GJ21931@carfax.org.uk>
References: <BvpREOmi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huG+SbfbdD6eblZQ"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BvpREOmi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--huG+SbfbdD6eblZQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 14, 2011 at 03:51:00PM +0200, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> I've just compiled kernel 3.9.04 and run

   Do you mean 3.0.4? We've not reached 3.2 yet, let alone 3.9 :) (Not
that it matters in this case).

>         btrfs filesystem show
> 
> On my system (Slackware 13.37, self made, without "udev") it still shows  
> a lot of non existent devices (I have shortened the list ...):

   This is not a kernel issue, it's a purely userspace issue. Try the
latest integration branch from git.darksatanic.net, which should have
a fix for it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        

--huG+SbfbdD6eblZQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOmEGcIKyzvlFcI40RAlCtAJ9YxYYoaWytvCp1KlR346gfNa34rQCePb/0
INa+tnw+WPMA+CpMBC62CUM=
=fOX6
-----END PGP SIGNATURE-----

--huG+SbfbdD6eblZQ--
