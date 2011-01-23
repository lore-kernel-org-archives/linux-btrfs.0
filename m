From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Cannot Create Partition
Date: Sun, 23 Jan 2011 18:23:49 +0000
Message-ID: <20110123182349.GG29985@carfax.org.uk>
References: <201101231007.55046.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpAOPzA3dXsRhoo+"
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101231007.55046.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


--PpAOPzA3dXsRhoo+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 23, 2011 at 10:07:54AM -0800, CACook@quantum-sci.com wrote:
> 
> On /dev/sda I have sda1 which is my / bootable filesystem for Debian formatted ext4.  This is 256MB on a 2TB drive.
> 
> I want to set up the rest of the drive as BTRFS for various functions, and I presume that I first have to create a partition using fdisk for this?  Since my first part is ext4?  So I:
> # fdisk /dev/sda
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk doesn't support GPT. Use GNU Parted.

   I think the above may be the root cause of your problem. You're
using the new GPT partition table format, not the traditional DOS one,
and fdisk is claiming that it can't handle it.

> WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
>          switch off the mode (command 'c') and change display units to
>          sectors (command 'u').
> Command (m for help): p
> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1      243202  1953514583+  ee  GPT
> Command (m for help): n
> Command action
>    e   extended
>    p   primary partition (1-4)
> p
> Partition number (1-4): 2
> No free sectors available
> Command (m for help):
> -------------------------------------------------
> Whaa?
> 
> Maybe it's possible that I just mkfs.btrfs /dev/sda and it will set
> up -only- the remaining space, but I'm afraid that this may destroy
> my OS.

   No, that will almost certainly destroy your existing partitioning,
and hence, as you say, your OS install.

> Also, what if I want to set up the whole drive as BTRFS?  Could this
> be bootable, and can the canned Debian kernel load the BTRFS driver
> for boot at install?  Or would I boot to the CD, mkfs.btrfs the
> drive, then install Debian?  Anyone tried this?

   As far as I know, GRUB2 doesn't yet support btrfs (although there
was some work done on it, I don't know what the status of that work
is). This means that you need a filesystem of some other type to boot
off -- even if it only holds the contents of /boot. There are
certainly people around who've done this, although I'm not one of
them.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- "Dullest spy film ever: The Eastbourne Ultimatum" ---        

--PpAOPzA3dXsRhoo+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNPHI1IKyzvlFcI40RAo/xAJ0aXbo9+nPaxvhZ9Zr7vnxrM8OZbgCfX/VC
IzVm2mgTW0EdSPzhuFdLXUc=
=EtSX
-----END PGP SIGNATURE-----

--PpAOPzA3dXsRhoo+--
