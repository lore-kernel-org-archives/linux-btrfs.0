Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:36454 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726Ab3KDFif (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 4 Nov 2013 00:38:35 -0500
Message-ID: <5276BED4.4060707@suse.com>
Date: Sun, 03 Nov 2013 16:23:32 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH] BTRFS_PROG: mount.btrfs helper
References: <1383503921-6694-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1383503921-6694-1-git-send-email-kreijack@inwind.it>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1vaNcFNnFWdhuFPxjTOAvPMG5mtdSUSfh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1vaNcFNnFWdhuFPxjTOAvPMG5mtdSUSfh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/3/13, 1:38 PM, Goffredo Baroncelli wrote:
> Hi all,
>=20
> this patch provides a mount.btrfs helper for the mount command to
> mounting a btrfs filesystem.
> A btrfs filesystem could spans several disks. This helper scans all
> the partition to discover all the disks required to mount a filesystem.=

> So it is not necessary any-more to "scan" manually the partitions to mo=
unt
> a filesystem via the "btrfs device scan" command.
>=20
> It adds in the option parameters the devices required to mount a
> filesystem. Supposing that a filesystem is composed by several disks
> (/dev/sd[cdef]), when the user does "mount /dev/sdd /mnt", mount calls
> mount.btrfs which int turn calls the mount(2) syscall like:
> mount("/dev/sdd", "/mnt", "btrfs", 0,
> "device=3D/dev/sdc,device=3D/dev/sde,device=3D/de/vsdf").
>=20
> This helper uses both the libblkid and libmount to discover the
> devices, to compute the parameters manipulation and to update the mtab
> file.
>=20
> I got the idea from the btrfs.wiki; its biggest gains is to avoid the
> separation of scanning phases (at boot time or during the block device
> discovery) from the mounting. Also mkfs.btrfs could avoid to re-do a
> rescan of the devices after a formatting.
>=20
> mount.btrfs doesn't add more requirement than the mount command. It
> would be possible to remove the "btrfs" command from the initramfs, and=

> all the related scripts (in my debian both udev and btrfs-tools
> packages contains three udev rules for btrfs).
>=20
> Comments are welcome.

I like the idea but I'm concerned how well this will perform on large
systems with thousands of disks attached. btrfs dev scan can have a list
of potential devices specified, but this helper defaults to all devices.
A quick test run with 2000 scsi_debug targets shows that btrfs dev scan
can take 8 seconds, and that's with no actual I/O occurring. I don't
think we want to specify the list of devices to scan on the mount
command line, but perhaps an /etc config file that limits the scan to a
list of devices (and defaults to all) similar to how mdadm.conf works
would be a good improvement.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--1vaNcFNnFWdhuFPxjTOAvPMG5mtdSUSfh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQIcBAEBAgAGBQJSdr7bAAoJEB57S2MheeWyOE4P/3iN5a1Y4db6HgHYK/OiMzNO
tN0LPjFpwS3ZlICfNPYU64cMF9Ft1UGB80q5wZ+SwY8ZiT29DlBqxsoK0PhpB2gR
gzxsC35jEkjZpV95onGO+a0fUsms74IsmhJrDLSzWXqXsZ8U4ZkU+mRQyJ/KHRTG
3uk9FmUf/BYVyYNg4PeYBFKe/dwzK/aG/nkzljveHuu4hHg3/VF3lW53DkEFbOhB
4/jUdU7RLL8oJK8ZlXVELb8oG6XOLj/KB48gZZoWpVbgE3uJOyIfXqs0o/yQbp0P
NlZv14Iex7Ps9zhkoU5EP05cFvn+ryIfeHWOtWx+aTY2YCuQSeqDg8trbiLhXEjk
srBs2BlGl4zXvYUHCz6ttIWUXTFgzNZqOm5XPDUTaYlLmtBWXv0IJ/tYL2c7gkes
Ij6w8zYn1uNbYl18JmURwz/PO44H5d2bo16wUfYh7yep1j/E1a6jtpQcljrXVPyF
mqZsZHz2Spryaszg7mdozRHFusBMVd5b3hyFNeV94gKPkUC+FkfNYCeVoNKAtC9Y
Owr2CMAzKTjzmAOEjF0CvQXGfrwfCIvCt4E2/j9/EoZqi8C1rUj84sN/t3aUG1dM
umsmZWQ446atFQYI0IlyJrccuXCRp3SLiMboFOkAC6YmMznCWEo4lrOo4k20Qu9V
c/NAQaXvknFTysPSjNZA
=qxco
-----END PGP SIGNATURE-----

--1vaNcFNnFWdhuFPxjTOAvPMG5mtdSUSfh--
