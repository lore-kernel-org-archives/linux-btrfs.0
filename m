Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58282 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2HSOv1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 10:51:27 -0400
Date: Sun, 19 Aug 2012 15:51:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fail to mount after first reboot
Message-ID: <20120819145124.GF30735@carfax.org.uk>
References: <5030F351.6030807@pocock.com.au>
 <20120819141513.GE30735@carfax.org.uk>
 <5030F92A.4030309@pocock.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
In-Reply-To: <5030F92A.4030309@pocock.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 19, 2012 at 02:33:14PM +0000, Daniel Pocock wrote:
> On 19/08/12 14:15, Hugo Mills wrote:
> > On Sun, Aug 19, 2012 at 02:08:17PM +0000, Daniel Pocock wrote:
> >> I created a 1TB RAID1.  So far it is just for testing, no important data
> >> on there.
> >>
> >> After a reboot, I tried to mount it again
> >>
> >> # mount /dev/mapper/vg00-btrfsvol0_0 /mnt/btrfs0
> >> mount: wrong fs type, bad option, bad superblock on
> >> /dev/mapper/vg00-btrfsvol0_0,
> >>        missing codepage or helper program, or other error
> >>        In some cases useful info is found in syslog - try
> >>        dmesg | tail  or so
> > 
> >    With multi-volume btrfs filesystems, you have to run "btrfs dev
> > scan" before trying to mount it. Usually, the distribution will do
> > this in the initrd (if you've installed its btrfs-progs package).
> 
> I'm running Debian, I've just updated the system from squeeze to wheezy
> (with 3.2 kernel) so I could try btrfs and do other QA testing on wheezy
> (as it is in the beta phase now)
> 
> I already had the btrfs-tools package installed, before creating the
> filesystem.  So it appears Debian doesn't have an init script
> 
> It does have /lib/udev/rules.d/60-btrfs.rules:
> SUBSYSTEM!="block", GOTO="btrfs_end"
> ACTION!="add|change", GOTO="btrfs_end"
> ENV{ID_FS_TYPE}!="btrfs", GOTO="btrfs_end"
> RUN+="/sbin/modprobe btrfs"
> RUN+="/sbin/btrfs device scan $env{DEVNAME}"
> 
> LABEL="btrfs_end"
> 
> but I'm guessing that isn't any use to my logical volumes that are
> activated early in the boot sequence?
> 
> Could I be having this problem because I put my btrfs on logical volumes?

   Possibly. You may need the "Device mapper uevents" option in the
kernel (CONFIG_DM_UEVENT) to trigger that udev rule when you enable
your VG(s). Not sure if it's available/enabled in your kernel.

> Here is the package version I have:
> 
> # dpkg --list | grep btrfs
> ii  btrfs-tools                           0.19+20120328-7
>        Checksumming Copy on Write Filesystem utilities

   That should be fine.

> Here is a more thorough dmesg, since boot, does this suggest the scan
> was invoked?  I remember seeing some message about checking for btrfs
> filesystems just after selecting the kernel in grub (root is ext3)

   That message was probably grub checking the FS.

> # dmesg | grep btrfs
> [   40.677505] btrfs: setting nodatacow
> [   40.677514] btrfs: turning off barriers
> [17216.145092] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 1
> transid 34 /dev/mapper/vg00-btrfsvol0_0
> [17216.145639] btrfs: disk space caching is enabled
> [17216.146987] btrfs: failed to read the system array on dm-100
> [17216.147556] btrfs: open_ctree failed
> [17310.978518] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 1
> transid 34 /dev/mapper/vg00-btrfsvol0_0
> [17310.993882] btrfs: disk space caching is enabled
> [17598.736657] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 1
> transid 37 /dev/mapper/vg00-btrfsvol0_0
> [17598.750849] btrfs: disk space caching is enabled

   No, doesn't look like there were any scan results coming in before
17216.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- In one respect at least, the Martians are a happy people: ---    
                          they have no lawyers.                          

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQMP1sIKyzvlFcI40RAgTUAJ9gywp8CrZ2xDRILERn9fCXOAybbACgpHdR
Puxj9rvNgXpGnm6zkStxlCU=
=gyBW
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
