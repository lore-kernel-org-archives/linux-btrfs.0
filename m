From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Confusing...
Date: Sat, 30 Apr 2011 23:30:20 +0100
Message-ID: <20110430223020.GA19913@carfax.org.uk>
References: <d513343c4c6ac383232407e4c6c585ac.squirrel@mail.fsck.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Cc: linux-btrfs@vger.kernel.org
To: "A. James Lewis" <james@fsck.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d513343c4c6ac383232407e4c6c585ac.squirrel@mail.fsck.co.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 30, 2011 at 09:42:39PM +0100, A. James Lewis wrote:
> 
> After completing an installation of Ubuntu 11.04 with a separate /boot
> partition and BTRFS as the main filesystem (Ubuntu creates subvolumes for
> / and /home).
> 
> sda1 being the GPT stuff
> sda2 being most of the disk as BTRFS
> sda3 being /boot
> sda4 being swap
> 
> sdb having an identical partition table...
> 
> I patched everything up to date, rebooted to make sure that all was ok..
> and then ran:-
> 
> btrfs device add /dev/sdb2 /
> sync
> reboot
> 
> The system stops in initrd unable to find the root filesystem...
> 
> It's my understanding that nothing should change here, am I missing
> something, I don't see how it can even tell I've added more storage, let
> alone fail to boot.

   In order to mount a multi-volume btrfs filesystem, the kernel needs
to know all of the devices that make up the filesystem. It can't do
that itself, so it needs some userspace assistance. Your system needs
to run "btrfs dev scan" from the initrd before attempting to mount the
root filesystem. On Debian, installing btrfs-tools will (I believe)
set that up.

   To get the system booting again temporarily, you could try adding
the option "mount=device=/dev/sda2,device=/dev/sdb2" (I think) to the
kernel command-line parameter in your boot loader. That should give
enough information to the initrd to be able to find the volumes that
your btrfs lives on, and get you enough of a system that you can work
out what's wrong with your initrd.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                --- If it ain't broke,  hit it again. ---                

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNvI18IKyzvlFcI40RAp/rAKCH8CvrwSl8UcC107ZLYG+o7dGBHQCdF2Ix
OIkdJpGnsaTs0UpDhOe3/Ig=
=LjBy
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
