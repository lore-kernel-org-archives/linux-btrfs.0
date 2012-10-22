Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59049 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2JVRSO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 13:18:14 -0400
Date: Mon, 22 Oct 2012 18:18:09 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: device delete, error removing device
Message-ID: <20121022171809.GA25498@carfax.org.uk>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com>
 <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com>
 <20121022091904.GY25498@carfax.org.uk>
 <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sT0SRK93LqpGW452"
In-Reply-To: <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sT0SRK93LqpGW452
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 10:42:18AM -0600, Chris Murphy wrote:
> Thanks for the response Hugo,
> 
> On Oct 22, 2012, at 3:19 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> >   I'm not entirely sure what's going on here(*), but it looks like an
> > awkward interaction between the unequal sizes of the devices, the fact
> > that three of them are very small, and the RAID-0/RAID-1 on
> > data/metadata respectively.
> 
> I'm fine accepting the devices are very small and the original file system was packed completely full: to the point this is effectively sabotage. 
> 
> The idea was merely to test how a full (I was aiming more for 90%, not 97%, oops) volume handles being migrated to a replacement disk, which I think for a typical user would be larger not the same, knowing in advance that not all of the space on the new disk is usable. And I was doing it at a one order magnitude reduced scale for space consideration.
> 
> 
> >   You can't relocate any of the data chunks, because RAID-0 requires
> > at least two chunks, and all your data chunks are more than 50% full,
> > so it can't put one 0.55 GiB chunk on the big disk and one 0.55 GiB
> > chunk on the remaining space on the small disk, which is the only way
> > it could proceed.
> 
> Interesting. So the way "device delete" moves extents is not at all similar to how LVM pvmove moves extents, which is unidirectional (away from the device being demoted). My, seemingly flawed, expectation was that "device delete" would cause extents on the deleted device to be moved to the newly added disk.

   It's more like a balance which moves everything that has some (part
of its) existence on a device. So when you have RAID-0 or RAID-1 data,
all of the related chunks on other disks get moved too (so in RAID-1,
it's the mirror chunk as well as the chunk on the removed disk that
gets rewritten).

> If I add yet another 12GB virtual disk, sdf, and then attempt a delete, it works, no errors. Result:
> [root@f18v ~]# btrfs device delete /dev/sdb /mnt
> [root@f18v ~]# btrfs fi show
> failed to read /dev/sr0
> Label: none  uuid: 6e96a96e-3357-4f23-b064-0f0713366d45
> 	Total devices 5 FS bytes used 7.52GB
> 	devid    5 size 12.00GB used 4.17GB path /dev/sdf
> 	devid    4 size 12.00GB used 4.62GB path /dev/sde
> 	devid    3 size 3.00GB used 2.68GB path /dev/sdd
> 	devid    2 size 3.00GB used 2.68GB path /dev/sdc
> 	*** Some devices missing
> 
> However, I think that last line is a bug. When I
> 
> [root@f18v ~]# btrfs device delete missing /mnt
> 
> I get
> 
> [ 2152.257163] btrfs: no missing devices found to remove
> 
> So they're missing but not missing?

   If you run sync, or wait for 30 seconds, you'll find that fi show
shows the correct information again -- btrfs fi show reads the
superblocks directly, and if you run it immediately after the dev del,
they've not been flushed back to disk yet.

> > btrfs balance start -dconvert=single /mountpoint

> Yeah that's perhaps a better starting point for many regular Joe
> users setting up a multiple device btrfs volume, in particular where
> different sized disks can be anticipated.

   I think we should probably default to single on multi-device
filesystems, not RAID-0, as this kind of problem bites a lot of
people, particularly when trying to drop the second disk in a pair.

   In similar vein, I'd suggest that an automatic downgrade from
RAID-1 to DUP metadata on removing one device from a 2-device array
should also be done, but I suspect there's some good reasons for not
doing that, that I've not thought of. This has also bitten a lot of
people in the past.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "There's more than one way to do it" is not a commandment. It ---  
                           is a dire warning.                            

--sT0SRK93LqpGW452
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUIV/0b9z9OVl50rAAQKuww/+MoYp8MkU5zc+C9Q0BWkqrKK/a5ILaqhO
hNXmKEwUY9SRUqwMOA5DhR+W8wboDX9aXWItMtkqSpWC7X7uVLd6En1yfK9sW91h
Qrh9wYDVURM6YN67ZNQP9lfajcBzk6TiErH+FkEw2uPPrJLqc2TwsZ2aQDPyk5Nn
SnQucMiL9GsQrXDkTrUtJiEyKAF1k1YPJKPcR9Fp+MFpQWkASOQALqqMbpqGlljr
JieEe+y7aGVjkYMpsHZ5m9syBv8o+eDnq1QRiTLC9U9iXw5uxjaBuaSO3VV0gdTl
fG/RkAs1ovW8gDBc4xCHdOgqvvsHxrfx2gNnFc2ABoMVMz9Xi0TJCn+zSme/pIAM
BCB4xQxSQne+3WPTnwqckOjV81j3ziddAKNIfVK1dPfeOCLJh7dbBeKpF72s9Ebs
VlGaHN0LmhWDk+q0h4UM2QLL9300doXbS6Eh5UKZuCfUhaDcTySnLmPlzZBG3bhl
ogafhbIdmq4b9PsaC41S+W4H3CstvgTmXbyTU6pnHT6OOULGBDMvdfECzu/bZsoU
SULzLW7nPmfNGFMcpzhDHekVaNrr+HMlGG5o59DTiHLUcJWMljgWDh8zXxllTJeU
BqqcadIJkBmEPI8FSBrCXlEvdsrlWCUQRNQuK2AoUeu4Jo0NwyZsmlObqNlmGMFj
XOC8dLYN6t4=
=6d/E
-----END PGP SIGNATURE-----

--sT0SRK93LqpGW452--
