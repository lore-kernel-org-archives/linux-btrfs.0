From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [PATCH v5 1/8] btrfs: Balance progress monitoring
Date: Mon, 11 Apr 2011 09:48:58 +0100
Message-ID: <20110411084858.GG5301@carfax.org.uk>
References: <1302469571-12605-2-git-send-email-hugo@carfax.org.uk>
 <BjeBXGRy1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BjeBXGRy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 11, 2011 at 07:34:00AM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 10.04.11:
> 
> > This patch introduces a basic form of progress monitoring for balance
> > operations, by counting the number of block groups remaining. The
> > information is exposed to userspace by an ioctl.
> 
> Just for curiosity:
> 
> If I remember correct then "btrfs device delete" shows growing and  
> shrinking numbers, resp. on the remaining and on the deleting  
> partition(s).
> 
> Can this patch show the remaining number of block groups too?

   This patch doesn't touch the code in device delete, but once this
patch series is finished and accepted, I'll take a look. We can
probably share a good chunk of the code between the two.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "How deep will this sub go?" "Oh,  she'll go all the way to ---   
                    the bottom if we don't stop her."                    

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNosB6IKyzvlFcI40RAoYwAJ0SirYR6W50wBX9PVOpw5owQo+/bgCguDx6
hPecU0Ay+AwZOgN7SPqijBA=
=3PKi
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
