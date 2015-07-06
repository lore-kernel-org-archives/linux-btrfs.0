Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34758 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbbGFRx2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 13:53:28 -0400
Date: Mon, 6 Jul 2015 17:53:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Johannes Pfrang <johannespfrang@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs - distribute files equally across multiple devices
Message-ID: <20150706175327.GD10539@carfax.org.uk>
References: <559AAB5C.1030001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
In-Reply-To: <559AAB5C.1030001@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 06, 2015 at 06:22:52PM +0200, Johannes Pfrang wrote:
> Cross-posting my unix.stackexchange.com question[1] to the btrfs list
> (slightly modified):
> 
> [1]
> https://unix.stackexchange.com/questions/214009/btrfs-distribute-files-equally-across-multiple-devices
> 
> ---------------------------------------------------------------------------------
> 
> I have a btrfs volume across two devices that has metadata RAID 1 and
> data RAID 0. AFAIK, in the event one drive would fail, practically all
> files above the 64KB default stripe size would be corrupted. As this
> partition isn't performance critical, but should be space-efficient,
> I've thought about re-balancing the filesystem to distribute files
> equally across disks, but something like that doesn't seem to exist. The
> ultimate goal would be to be able to still read some of the files in the
> event of a drive failure.
> 
> AFAIK, using "single"/linear data allocation just fills up drives one by
> one (at least that's what the wiki says).

   Not quite. In single mode, the FS will allocate linear chunks of
space 1 GiB in size, and use those to write into (fitting many files
into each chunk, potentially). The chunks are allocated as needed, and
will go on the device with the most unallocated space.

   So, with equal-sized devices, the first 1 GiB will go on the first
device, the second 1 GiB on the second device, and so on.

   With unequal devices, you'll put data on the largest device, until
its free space reaches the size of the next largest, and then the
chunks will be alternated between those two, until the free space on
each of the two largest reaches the size of the third-largest, and so
on.

   (e.g. for devices sized 6 TB, 4 TB, 3 TB, the first 2 TB will go
exclusively on the first device; the next 2 TB will go on the first
two devices, alternating in 1 GB chunks; the rest goes across all
three devices, again, alternating in 1 GB chunks.)

   This is all very well for an append-only filesystem, but if you're
changing the files on the FS at all, there's no guarantee as to where
the changed extents will end up -- not even on the same device, let
alone close to the rest of the file on the platter.

   I did work out, some time ago, a prototype chunk allocator (the 1
GiB-scale allocations) that would allow enough flexibility to control
where the next chunk to be allocated would go. However, that still
leaves the extent allocator to deal with, which is the second, and
much harder, part of the problem.

   Basically, don't assume any kind of structure to the location of
your data on the devices you have, and keep good, tested, regular
backups of anything you can't stand to lose and can't replace. There
are no guarantees that would let you assume easily that any one file
is on a single device, or that anything would survive the loss of a
device.

   I'm sure this is an FAQ entry somewhere... It's come up enough
times.

   Hugo.

> The simplest implementation would probably be something like: Always
> write files to the disk with the least amount of space used. I think
> this may be a valid software-raid use-case, as it combines RAID 0 (w/o
> some of the performance gains[2]) with recoverability of about half of
> the data/files (balanced by filled space or amount of files) in the
> event of a drive-failure[3] by using filesystem information a
> hardware-raid doesn't have. In the end this is more or less JBOD with
> balanced disk usage + filesystem intelligence.
> 
> Is there something like that already in btrfs or could this be something
> the btrfs-devs would consider?
> 
> 
> [2] Still can read/write multiple files from/to different disks, so less
> performance only for "single-file-reads/writes"
> [3] using two disks, otherwise (totalDisks-failedDisks)/totalDisks

-- 
Hugo Mills             | "How deep will this sub go?"
hugo@... carfax.org.uk | "Oh, she'll go all the way to the bottom if we don't
http://carfax.org.uk/  | stop her."
PGP: E2AB1DE4          |                                                  U571

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVmsCXAAoJEFheFHXiqx3kpmgQAKsJC9vSQ+GJpcGYQK4PMt4v
NKl7Ue0QPvFfbVbYLUqn60VSNfu8kvBJSErNfJUDXZyQ7EHacwBCbyc6UmWALdRm
jg+PzLHCpujZDcPGWpsVIbAMnYF0ZK0Z0thCg3b8yLjTud60CuV60K4rAxofbO1F
vCmuqAyuKvWS5Mpv7nvh1NPkuoYrFDa2SHN/zIrAJZzzBuVi7BR7vsnJ+UxMSWkq
xIwThKu+nzudcwN4HRFf4jCQSXaHM4XN8C7ER1P76Tc9IXP0QY0u+dqYfQ3XeQTM
AbTaBHYg/PSBLmL7oQMNMUSfRfLUrIEhNwu+SkqhwtEdzdkJyO5CUMBPpCY2tyj6
UUnB4kx8EXBFns1ATXVUcefjHFgpLRC67oAiRl9pS/69w0f4brxy6oEtrf73UJFG
RUv9Nm5At0e85Ly2JwkYsUm5RmkOoPSFkzklI11RceSyDW9Hn9Gnh+lxuspwE5yq
V3L0HWt+U4vTbUgN+Dn3ssSljqozNLtREsc9he+3l58XhQX1IzXurt0hbu/FmxyM
vyz+g9w426ihzdN+ZC5LAGPXA/pRx0hVKi5EA5QwtYDZzMEP8TbDSRzVwU3XGAOX
P/t3Dx5RwSTTXTmF46hLt2TMfAd27CsnOHypxBRkLLBH4wkHjcgoAot6WCjOEQrN
h0CgjuHgzXdJTtmyCOQj
=c/pz
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
