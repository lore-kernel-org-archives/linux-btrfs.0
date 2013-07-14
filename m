Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50206 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3GNNtd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 09:49:33 -0400
Date: Sun, 14 Jul 2013 14:49:26 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Dave Barnum <dave@thebarnums.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Need help mounting broken btrfs Fedora 19
Message-ID: <20130714134926.GC29644@carfax.org.uk>
References: <CACvcmCCQKO6cx+vV0pb-GbiFBGDr2aq6q=Yt5StsDSkq91W9Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
In-Reply-To: <CACvcmCCQKO6cx+vV0pb-GbiFBGDr2aq6q=Yt5StsDSkq91W9Hw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 14, 2013 at 01:43:41PM +0000, Dave Barnum wrote:
> I need some help as may have lost some number of files on a btrfs raid
> 1 volume. I'm not quite sure what happend which, I know, only adds to
> the problem.
> 
> On my computer #1 I had only a month or so ago installed Fedora 19
> Beta and at the time of install chose BTRFS, raid 1. Recently one of
> the drives started complaining that it was going to die. WIthout
> taking it out of the array (perhaps I should have done that) I turned
> off the system and swapped the drive with another. From then on I lost
> my ability to boot the system. I could not get anything to work with
> the new hard drive. Then I put the old hard drive back in so that I
> could try to boot again. Still nothing. At one point I think I was
> able to see grub - but at this point, I'm not. I just get boot disk
> failure.

   Try adding the option "degraded" to your mount options. With grub,
this should be possible to do manually at boot time. That should get
yout the ability to mount the FS with just a single mirror. If that
works, you can then use btrfs dev add to add the new device to the
filesystem, and then a full balance to recreate the mirror.

   Hugo.

> Further more on the failing drive, drive A, I can still see the
> patitions but I cannot mount it on another system. On drive B (the
> other half of the mirror) I do not see any partitions. I tried copying
> the partition structure using sfdisk from A to B but that probably was
> not smart.
> 
> I plugged drive A into computer #2 using a live Fedora and Ubuntu CD
> to try to mount the volume. However in both distributions I am unable
> to mount the volume. I've tried mounting using -o degraded but I still
> get the same error. The error I'm seeing when I try to mount the
> filesystem goes like this:
> 
> Quote:
> [10792.307425] device label fedora_ison devid 2 transid 48720 /dev/sdc2
> [10792.308202] btrfs: allowing degraded mounts
> [10792.308206] btrfs: disk space caching is enabled
> [10792.308599] btrfs: failed to read chunk root on sdc2
> [10792.308799] btrfs warning page private not zero on page 20979712
> [10792.320146] btrfs: open_ctree failed
> 
> I believe the superblock may be in tact since when i turn the command
> ./btrfs-show-super /dev/sdc2 I get:
> 
> Quote:
> root@ubuntu:/downloads/btrfs-progs# ./btrfs-show-super /dev/sdc2
> superblock: bytenr=65536, device=/dev/sdc2
> ---------------------------------------------------------
> csum 0xfc19c468 [match]
> bytenr 65536
> flags 0x1
> magic _BHRfS_M [match]
> fsid cbbf7d4c-f7a0-43ff-aed5-77b347d6ff25
> label fedora_ison
> generation 48720
> root 1105526784
> sys_array_size 226
> chunk_root_generation 46504
> root_level 1
> chunk_root 20979712
> chunk_root_level 1
> log_root 0
> log_root_transid 0
> log_root_level 0
> total_bytes 2988521291776
> bytes_used 598216536064
> sectorsize 4096
> nodesize 4096
> leafsize 4096
> stripesize 4096
> root_dir 6
> num_devices 2
> compat_flags 0x0
> compat_ro_flags 0x0
> incompat_flags 0x1
> csum_type 0
> csum_size 4
> cache_generation 48720
> dev_item.uuid 5f61edaa-7f12-4ec5-a024-02f7797e1400
> dev_item.fsid cbbf7d4c-f7a0-43ff-aed5-77b347d6ff25 [match]
> dev_item.type 0
> dev_item.total_bytes 1494260645888
> dev_item.bytes_used 482110078976
> dev_item.io_align 4096
> dev_item.io_width 4096
> dev_item.sector_size 4096
> dev_item.devid 2
> dev_item.dev_group 0
> dev_item.seek_speed 0
> dev_item.bandwidth 0
> dev_item.generation 0
> 
> Could someone help me troubleshoot why I can't mount my volume? I
> would REALLY appreciate it! Perhaps there is a way to repair my broken
> tree structure?
> 
> Thank You!

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---          
                         darkness bind(2) them.                          

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUeKsZlheFHXiqx3kAQKUSw//SofzqXHmefMG9NqB8nmau5SygjP3bnil
fY6LH6Q8OwWS47lTIfMY70NfQAA2NcClHZgHH0Sr/Loso4IxNr9jbUEez5UGWy4M
DQK1qkgQT9dYANrOc+EEZMAln5BYJW2g0A52Yh5wU5jssUaXJoUhEFrT6z0WOnfD
9QfwOYpl7m9Ww9GpLnekwhE3O89dmo8otWNpsVKv6K1NRYstglHjZQDiPv4MER1O
EcAdo42DhZ7MsGRSB8GOx3PxdKH1wz83DqHSj693OhcBZWKpd0+TIIb9Rv1ewEG2
QTN54L1hzGxWMiWYw068uxK6IYL9GFYmW4kkKUdx144OKvTL3ezPpXT0Thc5L9pa
/m5u57msZ7B2v1buPURTATQ/aRe7QLZgFHvulSWQy6v9091GWqTF8g83u6Sp64s0
tp3Jv4D38uMG1i+xd66GegJJ+/5NU6GiBr9nPGpNqbXRabhAj3Ax2d5gp1+aMfde
WEMfELI2aEeiiPsMKgh9JoyeMs3hRqZHxMZmeGW+XhjY64lLftF9kY4gZzxuXoKS
88rCqKfvc1goxpd6vURsr93l/rG4vroC1YbEu05vmNDcg83aLaWok53DqUoVbk4C
1DINYE9OmwCRoL1pQR5jIxbxxiYhV6pXcawfdx/chQRNwef6ZiBI6l32PiVi+p/D
xIEF8nEBtE0=
=E7Vr
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
