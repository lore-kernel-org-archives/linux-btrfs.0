From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: "Invalid argument" when mounting a btrfs raid1 filesystem
Date: Sat, 24 Mar 2012 18:21:05 +0000
Message-ID: <20120324182104.GB14080@carfax.org.uk>
References: <87vclt99tg.fsf@falma.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Cc: linux-btrfs@vger.kernel.org
To: Christoph Groth <cwg@falma.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87vclt99tg.fsf@falma.de>
List-ID: <linux-btrfs.vger.kernel.org>


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 24, 2012 at 06:40:27PM +0100, Christoph Groth wrote:
> Hello,
> 
> I'm trying to install current Debian testing (=kernel version 3.2) with
> btrfs as the root file system.  There is also a small ext3 /boot
> partition.
> 
> I create a btrfs raid1 file system with the command
> 
> mkfs.btrfs -d raid1 /dev/sda2 /dev/sdb2
> 
> Then I can mount it and finish the installation successfully.  Booting
> doesn't work, however: initrd complains that it cannot mount /dev/sda2:
> "Invalid argument".
> 
> The funny thing is, that in the initrd console I can mount /dev/sdb2!
> So I changed the kernel parameter in grub.cfg to mount /dev/sdb2
> instead, but the problem persists: Now I can mount /dev/sda2 in the
> initrd console!
> 
> In fact, when I boot a rescue system from a thumbdrive, the same thing
> happens:
> 
> # mount -t btrfs /dev/sda2 /mnt
> mount: mounting /dev/sda2 on /mnt failed: Invalid argument
> # mount -t btrfs /dev/sdb2 /mnt
> #
> 
> When I keep trying to mount the same device, it keeps failing.  When I
> start mounting /dev/sdb2, it works for /dev/sda2...
> 
> Isn't this very weird?  Any ideas?

   As Sadner says, you have to run "btrfs dev scan" before you try to
mount the FS. If you have root on btrfs, this will have to go in an
initrd; otherwise, it can go in your initscripts anywhere before the
non-root filesystem mounts.

   Basically, the kernel needs to know which devices hold which btrfs
filesystems (organised by UUID) before it tries to mount them. So,
there's an ioctl that is used for sending that data to the kernel, and
a userspace tool (btrfs dev scan) that enumerates all of the block
devices it can see, looks for a btrfs superblock on them, and tells
the kernel.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Have found Lost City of Atlantis.  High Priest is ---        
                           winning at quoits.                            

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPbhCQIKyzvlFcI40RAtLTAJ9BumTsr37P9BTs/6VM1Cf5pL578wCfZLLW
xVvpJZM8+9fDLHIGFBnMLZE=
=JNkB
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
