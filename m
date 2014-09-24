Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52570 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaIXPTq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 11:19:46 -0400
Date: Wed, 24 Sep 2014 16:19:39 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Robb Walker <rwalker@DRWHoldings.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: lvm thin provisioning snapshots and btrfs
Message-ID: <20140924151939.GB26425@carfax.org.uk>
References: <1411569217555.64572@DRWHoldings.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
In-Reply-To: <1411569217555.64572@DRWHoldings.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 02:34:45PM +0000, Robb Walker wrote:
> Hello all seeing something odd with btrfs and lvm thin-provisioning
> snapshots. Sent my finding to the lvm list and thought I might post
> here after some feedback which I have included. Apologies in advance
> if this is bad form. Please let me know. Hopefully the trail below
> is not too confusing.

   I'm afraid you're going to have problems with btrfs and LVM
snapshots. You're probably not going to like this.

   Here's the difficulty: btrfs identifies which block devices belong
to which filesystems by building up a map of device -> UUID pairs. It
can then work out from that which devices it should be looking at (and
modifying) when a filesystem is mounted. This process is done in
userspace, using "btrfs dev scan", which then tells the kernel about
it.

   In most modern systems, udev is configured so that it runs a btrfs
dev scan on any newly-discovered block device, just to see if it's a
part of a btrfs filesystem. Note that making an LVM snapshot creates a
new block device.

   Now, the difficulty is, if btrfs is told about two block devices
that have a btrfs superblock and the same filesystem UUID on them, it
will assume that they're part of a single multi-device filesystem.

   This means that if you have two block-level copies of a filesystem,
the FS code will try to treat them as a single multi-device
filesystem. This means that the data structures are somewhat screwy,
but it's still good enough to look like a real and mostly undamaged
btrfs FS.

   This is, I think, the effect that you're seeing here -- your LVM
snapshots are getting merged with the original FS, and writes are
going to the wrong block device. Short of changing the UUID of the
filesystem (which requires rewriting every single metadata block, as
the UUID is embedded in the header of every tree node), I don't think
there's a particularly good solution to this issue, without allowing
direct control of the device<->UUID mapping. The UUID-changing idea
has been around for a while, but nobody's managed to get around to
implementing it yet.

   So, short answer: you can't make block-level copies of btrfs
filesystems and expect the copies to work on the same system.

   Hugo.

> ----original post -- and note I see this on centos 6u5 outlined below and ubuntu 14.04.1
> 
> 
>  With  lvm thin prov + ext4 I get expected results. When I take a snapshot. I see the snapshot is the state of the lvm volume at the point of time of snapshot creation.
> 
> 
> For  btrfs, I am using a root subvolume mounted as @foo_root with a thinly provisioned lvm underneath. Same setup just using btrfs.
> 
> I take a thin snapshot
> lvcreate -n lv_root_thin -s vg_thin/lv_root
> snapshot is created
> activate with lvchange -Kay  /dev/vg_thin/lv_root_thin
> 
> 
> I then mount the snap with mount -odefaults,subvol=@foo_root /dev/vg_thin/lv_root_thin /snaps
> The contents match the origin  lvm. Both  lvms, origin and snap stay in sync with whatever changes I make.
> At one point I thought that maybe it was snapping at the subv level so I decided a snapshot of the root vol. However the deletion also appeared in the thin snapshot
> 
> 
> Also couple notes:
> I never see in lvs that the thin snapshot goes -o- online as I do in ext4
> chdir into the /snaps and running df -h . shows that I'm in the snapshot
> chdir into /snaps/\@foo_root and running df -h . shows I'm in the origin vol. <this is where I thought it might be snapping at the "raw" brtfs subvolume level
> 
> 
> 
> Hopefully this is somewhat clear
> 
> 
> 
> Regards and TIA
> ---Lvm list feedback ---
> 
> It's likely  btrfs problem that it is not reporting duplicity problem?
> 
> In  lvm2 we try to detect duplicate PVs and report problem and pick one to use.
> 
> Btrfs needs to do the same - I'd expect some kernel messages about these kind
> of problems?
> 
> Snapshot activation is skipped here for a reason.
> 
> It's upto user/admin to avoid system confusion.
> 
> So my best advice is - to ensure you do not have active origin & snapshot at
> the same time - especially when manipulating with  btrfs - since it most likely
> ignore device UUID generated by  lvm (and that should be unique)
> 
> You will need to check disk  btrfs identifiers if you need to have active these
> volumes at the same time.
> 
> ----------
> I actually see the same thing with regular snapshots as well
> 
> 
> 
> dmesg shows
>  153.594444] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/dm-1
> [  153.598598] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/dm-2
> [  153.602398] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/dm-1
> [  153.605490] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/dm-1
> [  153.608078] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/dm-2
> [  153.611517] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/dm-2
> [  195.495648] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/mapper/vg00_th-lv_root_140924
> [ 1171.952393] btrfs: device fsid 44c76cc5-5d03-4f02-af5f-2028e61e09fa devid 1 transid 38 /dev/mapper/vg00_th-lv_root_140924
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> This e-mail and any attachments may contain information that is confidential and proprietary and otherwise protected from disclosure. If you are not the intended recipient of this e-mail, do not read, duplicate or redistribute it by any means. Please immediately delete it and any attachments and notify the sender that you have received it in error. Unintended recipients are prohibited from taking action on the basis of information in this e-mail or any attachments. The DRW Companies make no representations that this e-mail or any attachments are free of computer viruses or other defects.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVCLhC1heFHXiqx3kAQLKNw//aW0i1DUAkUOQB+v3kKaWm6fTlJgKZT+e
I1DOEe7OxbAVnoa+aIGJs9lF+SgzmJ2gl7bjhaL0hVqWdqo3zC2hucYSYNDE6pEl
YkpgpQdYQTK3gmuLEADw3RmxWsR7i3XHiQEcppRAaZcmwOvGiGqO3Dx0ct/3ORRX
yZ7+/frVUSLhz6hKotyc2nRFzoH1L8yxTRGSMVdLa885YwYdh1vIQ6XavB6zPBUP
fUPARN11TDFyHfHjibecBAdFaI9iGwrG3h0v6X1JE/pQzJfBDdOOvr3PdEgMRmvP
zzbMNuOn6Gof2RIXurDhCrNtZN16p02Nu5FN35Riu3XBOrmAcnj/AKfzu9xINUjT
Jv4C4a1GlzECWu9r1JEMdaGJ5vJIH5ebeCh0Fdp7qHetvvXuESn1UND/IwuJAdD+
xkd4/O0elQiDb8ZkfjPcWIHvq96qeJNS44d4AO8s+h3GvbJnnum5zn1kA07c5PH1
MLScpR7ixCFBQQVEK6fRNzZ4WZaUhknnDpJBzPe346skKGnl0dJs3DiIBP0eKPeE
XflseJ3ARuLVhaWFi8vLzwxJucc5sl3FMNS/8Aj8DOOURl+17riNOz9ZybQI+1yy
EVazyIfW4yKyy7Pz2a49wYXL7CXPLbU3QNMZ86gxT871uDgj5KEsalTIbhDn0XRF
cTZh6737vG0=
=f4uC
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
