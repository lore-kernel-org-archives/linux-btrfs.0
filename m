From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 7 May 2012 15:05:40 +0100
Message-ID: <20120507140540.GF8938@carfax.org.uk>
References: <20120507105944.GD8938@carfax.org.uk>
 <C8PCDX9uCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PCDX9uCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 03:34:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 07.05.12:
> 
> >> =================== boot messages, kernel related ==============
> >>
> >> [boot with kernel 3.3.4]
> >> May  7 06:55:26 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0
> >> SErr 0x10000 action 0xe frozen
> >> May  7 06:55:26 Arktur kernel: ata5: SError: { PHYRdyChg }
> >> May  7 06:55:26 Arktur kernel: ata5: hard resetting link
> 
> [...]
> 
> >    This is a hardware error. You have a device that's either dead or
> > dying. (Given the number of errors, probably already dead).
> 
> It's dead - R.I.P.
> 
> I've tried it with a SATA-USB-adapter - that adapter produces dmesg  
> lines when connecting or disconnecting.
> 
> And this special drive doesn't tell anything now. Shit.

   Sorry to be the bearer of bad news. I don't think we can point the
finger at btrfs here.

   It looks like you've lost most of your data -- losing a RAID-0
stripe across the whole FS isn't likely to have left much of it
intact. If you've got the space (or the money to get it), mkfs.btrfs
-m raid1 -d raid1 would have saved you here.

[ Incidentally, thinking about it, the failure coming at a kernel
   upgrade could well be down to the additional stress of the
   power-down/reboot finally pushing a bad drive over the edge. ]

   In sympathy,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- But somewhere along the line, it seems / That pimp became ---    
                       cool,  and punk mainstream.                       

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPp9a0IKyzvlFcI40RAhP3AKCygTCunmJmOGTFUDxJzP9vAk4krgCgreEZ
Hgv2UPI8//IwM2CKANtzuQg=
=vM/v
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
