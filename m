From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Kernel Modules
Date: Sat, 9 Jul 2011 18:39:11 +0100
Message-ID: <20110709173910.GH4325@carfax.org.uk>
References: <201107090919.12739.CACook@quantum-sci.com>
 <4E188C0B.4060004@gmail.com>
 <201107091028.04403.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vjQsMS/9MbKYGLq"
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107091028.04403.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


--5vjQsMS/9MbKYGLq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 09, 2011 at 10:28:03AM -0700, CACook@quantum-sci.com wrote:
> On Saturday 9 July, 2011 10:12:43 you wrote:
> > If your btrfs lives on two or more devices you will have to run 'btrfs
> > device scan' prior to mount or give all devices as arguments to mount.btrfs.
> 
> Ohhh, I'd added a disk drive without modifying fstab.  Thanks.
> 
> Where would you put a device scan to happen at boot?

   This is distribution dependent, but I do know that Debian will put
it in your initrd for you if you install Debian's btrfs-tools package.
If you have your root FS on btrfs, you *must* put the scan in an
initrd (or specify all the root devices as mount options in your
kernel command-line).

   If you don't use an initrd, then add the scan to your startup
scripts anywhere before the point that filesystems are mounted, and
anywhere after the point that block devices are detected (typically
when udev is started).

> On another subject, I guess there are two ways to remove old snapshot directories:
> - btrfs subvolume delete
> - rm -rf
> 
> I understand that snapshots are cumulative for files and do not duplicate, but is it necessary to use the subvolume delete command to preserve the integrity of remaining snapshots?

   No, effectively each snapshot is independent of the others (by the
magic of copy-on-write). When items from a snapshot are deleted, the
filesystem automatically cleans up by updating the extent reference
counts.

> And also, about once a week KDE locks up on me after a suspend, and
> I have to power-cycle it.  Is there any maintenance I should do on a
> btrfs part when this happens?

   No, if the storage stack from filesystem all the way down to the
drive platter handles barriers correctly, then btrfs should always be
in a consistent state, even over a power-cycle.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--5vjQsMS/9MbKYGLq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOGJI+IKyzvlFcI40RApSoAJ9g8NpMwBrXLrrtqGxOPulTMK+t8gCfUvWV
2FgNDMY3xl5xeiPSxwaN9Mo=
=4qeG
-----END PGP SIGNATURE-----

--5vjQsMS/9MbKYGLq--
