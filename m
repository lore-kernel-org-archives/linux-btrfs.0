Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41407 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2FLUGy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 16:06:54 -0400
Date: Tue, 12 Jun 2012 21:06:50 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Santosh Hosamani <Santosh_Hosamani@mindtree.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Bug in btrfs-debug-tree for two  or more devices.
Message-ID: <20120612200650.GA28932@carfax.org.uk>
References: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2012 at 06:53:00AM +0000, Santosh Hosamani wrote:
> 
> Hi btrfs folks,
>                 I am working on btrfs filesystem on how it manages the free space. And found out btrfs maintain a ctree which manages the physical location of the chunks and stripes of the filesystem.
> Btrfs-debug-tree also gives the information on the chunk tree
> 
> I created btrfs on single device and two device.I have attached the output of both on running btrfs-debug-tree.
> For single device sum of all the length in the chunks will add upto the total used bytes which is expected behavior.
> 
> But for two devices sum of all lengths in the chunks does not add to the total bytes .Am I missing something .

   Without actually seeing the details of your technique and
expectations, I shall make a guess that you're not accounting for the
double-counting of RAID-1 metadata. In other words, you will find that
all of the metadata device extents (or chunks) will appear twice --
once on each device.

   Actually, this isn't quite right either -- what you really need to
do is look at the RAID-1, RAID-10 and DUP bits in the chunk flags, add
up all of those chunks, divide by two, and then add in the remaining
(RAID-0 and single) chunks. That total should then add up to the total
value of allocated space that you get from the output of "btrfs fi df".

> Also I notice that for the second device the superblock location 0x10000 is not considered as used .
> 
> I would be really grateful if you folks can answer my query.
> 
> I hav run these tests on SLES11-sp2-x86
> Kernel 3.0.13.0.27-default

   This is pretty old, but shouldn't affect the results. It will cause
reliability problems if you try running it seriously.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "There's a Martian war machine outside -- they want to talk ---   
                to you about a cure for the common cold."                

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP16FaIKyzvlFcI40RAnzLAJ90i5rqqU8IQ62N2DtnwPrD3+CnQgCggrj6
8EooXXlJ7N/VR1ghviTSLJk=
=Dnvu
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
