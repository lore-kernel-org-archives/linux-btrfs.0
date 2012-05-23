Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46784 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933686Ab2EWPdV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 11:33:21 -0400
Date: Wed, 23 May 2012 16:33:16 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Rogerio Bastos <rogeriobastos@dcc.ufba.br>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Cant mount multi-subvolume via fstab
Message-ID: <20120523153316.GB31037@carfax.org.uk>
References: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
In-Reply-To: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 12:00:02PM -0300, Rogerio Bastos wrote:
> Hi,
> 
> I'm trying mount many subvolume during boot via fstab:
> 
> UUID=xxx /usr btrfs subvol=usr,ro,nodev 0 0
> UUID=xxx /home btrfs subvol=home,nodev,nosuid 0 0
> UUID=xxx /var btrfs subvol=var,nodev 0 0
> UUID=xxx /var/tmp btrfs subvol=var-tmp,nodev,noexec,nosuid 0 0
> 
> But only the first one is mounted. When try to mount the others
> subvolumes, I get this error:
> 
> mount: /dev/sda3 already mounted or /home busy
> mount: according to mtab, /dev/sda3 is mounted on /usr
> mount: /dev/sda3 already mounted or /var busy
> mount: according to mtab, /dev/sda3 is mounted on /usr
> mount: mount point /var/tmp does not exist
> 
> I'm using linux kernel 3.3.6 and mount 2.20 in Debian 7.

   How are your subvolumes arranged?

   If you have:

top-level            # default subvolume mounted as /
        `--- home
        `--- usr
        `--- var
               `--- tmp

and you are mounting / first, then you don't need to mount the
subvolumes, as they're already visible within /  I'm not quite sure
what the consequences of mounting a subvolume directly onto itself as
a mountpoint are -- but it may have this effect.

   If you have:

top-level
        `--- root    # default subvolume mounted as /
        `--- home
        `--- usr

then you should be able to (and have to) mount them separately.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- UNIX:  Japanese brand of food containers. ---            

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPvQM8IKyzvlFcI40RAuH7AKDOiAnnDRQ1Pcm+lFVylqphIIui/gCeO5uS
v+K798xr4ekkGtlLPrQoBZo=
=mcQh
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
