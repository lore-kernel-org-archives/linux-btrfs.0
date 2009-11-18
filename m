From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: To loop or not to loop with btrfs
Date: Wed, 18 Nov 2009 21:52:57 +0000
Message-ID: <20091118215257.GA20857@vlad.carfax.org.uk>
References: <alpine.LSU.2.00.0911182229500.32206@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Cc: linux-btrfs@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0911182229500.32206@obet.zrqbmnf.qr>
List-ID: <linux-btrfs.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 18, 2009 at 10:31:53PM +0100, Jan Engelhardt wrote:
> This left me puzzled for a while:
> 
> 22:29 borg:/ # losetup /dev/loop1 /.B.disk
> 22:29 borg:/ # mount /dev/loop1 /B
> mount: /dev/loop1: can't read superblock
> 22:29 borg:/ # blkid /dev/loop1
> /dev/loop1: UUID="e19fe89b-cde3-4ccc-bc70-b759a57bd1c9"
> UUID_SUB="f29c6218-d040-4546-a227-4dd2d2142817" TYPE="btrfs" 
> 22:29 borg:/ # losetup -d /dev/loop1
> 22:29 borg:/ # losetup /dev/loop2 /.B.disk 
> 22:29 borg:/ # mount /dev/loop2 /B
> (success)
> 
> So the btrfs volume is tied to loop2? That certainly is not good.
> Even real disks (/dev/sd*) can move around, the more so USB flash
> gadgets and loop devices.

   This looks like it might be related to [1]? (I suspect it slipped
Chris's mind back in April, and nobody's really noticed it since).

   Hugo.

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/2817

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Most administrators wouldn't give their users the time of ---    
                      day.  That's what NTP is for.                      

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFLBGy5IKyzvlFcI40RApVBAKCaFQn+nRs6MPS7HIlS4lxcaEYibACdEcxP
04VaxinBpbQSHMsI11ev0VI=
=zDoY
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
