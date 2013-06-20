Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37576 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3FTK4L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 06:56:11 -0400
Date: Thu, 20 Jun 2013 11:56:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
Message-ID: <20130620105607.GO11290@carfax.org.uk>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
 <20130620091622.GL11290@carfax.org.uk>
 <kpul4f$ei7$1@ger.gmane.org>
 <20130620103404.GN11290@carfax.org.uk>
 <kpum9h$ei7$2@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rZHzn+A9B7nBTGyj"
In-Reply-To: <kpum9h$ei7$2@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rZHzn+A9B7nBTGyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 10:41:53AM +0000, Gabriel de Perthuis wrote:
> >> Instead of redirecting to a different block device, Btrfs could and
> >> should refuse to mount an already-mounted superblock when the block
> >> device doesn't match, somewhere in or below btrfs_mount.  Registering
> >> extra, distinct superblocks for an already mounted raid is a different
> >> matter, but that isn't done through the mount syscall anyway.
> > 
> >    The problem here is that you could quite legitimately mount
> > /dev/sda (with UUID=AA1234) on, say, /mnt/fs-a, and /dev/sdb (with
> > UUID=AA1234) on /mnt/fs-b -- _provided_ that /dev/sda and /dev/sdb are
> > both part of the same filesystem. So you can't simply prevent mounting
> > based on the device that the mount's being done with.
> 
> Okay.  The check should rely on a list of known block devices
> for a given filesystem uuid.

   And this is where we fail currently -- that list is held by the
btrfs module in the kernel, and is constructed on the basis of what
"btrfs dev scan" finds by looking at superblocks on block devices.
Currently, there's no method implemented for determining whether a
block device with a legitimate btrfs superblock on it is a duplicate
of another device, or whether it's a newly-discovered device which is
part of an as-yet incompletely specified multi-device FS.

   I think it should be possible to look up the device ID as well, and
complain (loudly, to the user, and in the kernel) at btrfs dev scan
time if we see duplicates. That would deal with the problem at the
earliest point of confusion.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- I know of three kinds: hot, ---                   
                cool,  and what-time-does-the-tune-start?                

--rZHzn+A9B7nBTGyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUcLfx1heFHXiqx3kAQLqRw//bgVm3Zu2gFGXrHrPtqyyDORj3elnhytg
hNHIflLeDVHS3/rsPR1XvuvYUFCH0TjqrUqXQgpZGowpk3xfazr6jpp7WrxX8o1k
eCZml9vDl9ePyo2bd/6qakZm40ZcU4JZJxmX8WNDE6d2whjioE4nTIk1087kGxU/
JkAm8sUyMYsmvxzTx77zH2hm1onciWjzdRIAi60RMLTRoA5E3YRL0vpmqDYKLi1d
7CIGZYlkJdltt78hXd1r9LYiYp2zFJ0CddLYkvh5q5OltMgZXL3I4YXelrZteBis
K9dmTOVSGaQzIjcxxgHrpfyX7vjUyxdkVHjNSiknW2BbiBlW2FoeIAi6gAuYAHeo
2uU7ujdXEZBhQRvBIFvI95dio6jljQGJrY/3rMcKB1dcZWNgE440JvydDDeRwySV
v1xv3TKkWIE0R4+2dhHl4T9YcpKQZloz3gzc7g5/5tlc4Us4MeKiH4UoCYCWgpqH
pNR5HdLNnzmIkmXo+rV6KUW5EPwpkWh88/BVJu012qMENbQuYumBjOO0wIphMaT2
Ct6HHzXys2tb8522l3qhY1jGcar1xXK9DV5aRPRLhGVEdF5uWjBHkZkSXDt3b664
eUWifPwxFdqSrcKT26cbx/sQtiGA7OjyfSm6lkkEkulg2q5oinY9/GEElVytRL91
0WusOs+S4Bs=
=gGuo
-----END PGP SIGNATURE-----

--rZHzn+A9B7nBTGyj--
