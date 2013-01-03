Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33856 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3ACQI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 11:08:56 -0500
Date: Thu, 3 Jan 2013 16:08:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Option LABEL
Message-ID: <20130103160853.GA19051@carfax.org.uk>
References: <CO8iDgPPCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VIT1Kna7lLfXMiZV"
In-Reply-To: <CO8iDgPPCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VIT1Kna7lLfXMiZV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 03, 2013 at 04:14:00PM +0100, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> please delete the option "-L" (for labelling) in "mkfs.btrfs", in some  
> configurations it doesn't work as expected.
> 
> My usual way:
> 
>         mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd ...
> 
> One call for some devices.
> Wenn I add the option "-L mylabel" then each device gets the same label,  
> and therefore some other programs can't find the (one) device with the  
> defined label.

   I'm sure we've been over this territory before. Devices are not
labelled; filesystems are labelled. You are labelling the whole
filesystem, which exists over several devices, so the same label will
be attached to every device in the filesystem.

> Especially
> 
>      blkid
>      findfs LABEL=mylabel
> 
> don't work.

   How do you mean, "don't work"? What are they showing, and what do
you think should they be showing? It looks like both of them print an
arbitrary device node of the devices that the FS lives on. Given that
both of these tools probably expect a one-to-one relationship between
a block device and a filesystem, this is not unreasonable.

>      file -s /dev/sdb  (etc.)
> 
> shows the label (and the problem).
> 
> Other tries:
> 
>         mkfs.btrfs -L mylabel /dev/sdb
> 
> creates a new btrfs filesystem and overwrites prior tries.

   Yes, because you've just created a new filesystem. That's what
mkfs.btrfs does, same as every other mkfs -- it creates a new
filesystem, destroying what was there before. This is unsurprising.

   Hugo.

> What works:
> 
>         btrfs filesystem label /dev/sdb mylabel

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- What part of "gestalt" don't you understand? ---           

--VIT1Kna7lLfXMiZV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUOWtFb9z9OVl50rAAQK7hg//VII+dtNhNwGrBJFgDQo185oetful4Wt/
SEm6W4rd2jEMxYpc3XQt4O8yMCbu9Ng7lReAUBe8lbc0CaA5DK6lfJfm1koCO0we
F4mdEUFlieTLYPdlWBdKAH9mf+Cz604XXLinCMPnxvlpHhHueDj1YEMaQG7g/Myr
ia91D86w7Q0YmgwPSHjiYPx8zNlW2L5HnZTj1ATos1JPZ5cK04eag9/p/GHgpZKJ
2NfWdYtuaBVHy2S9oBbN+6FS3fD5MNnplMzfly9A2TKrP8t1p6OlHv3twIKofcBB
xmPu7u9NV/nwiYD5e/Arq90jKwmu1qAeVLnO2/hP1mSmcQ8wgc0Rr5KKfcgoOd1R
f7BUsbx3KZhMvA0J1T2CXqAg849UZdwHcKmK3ArLIbqLwfhnbPfmN7mRYG4DJbyr
bz5quqjI/8CTGJG7yaxgXxPyd2ZPw2XC0puH0MPqdHkIUYwlbCPUdtAXT0w1JgJ9
Cg9VP07XWyxdt4n23oMvrqGX+y1oz3vNRdQwF5wePte6saK2M0WQljRxrZSukGlW
9k7K4o8p95mC4s3wPdwmxWvZJK+UCXN/oDZsJbbzC9QzR+gYhnnqTv+nwoAN+Bdh
2x6OvJaPqX4rObX7ya3T3D8SLFSjFwV1TQ88qwe76n7CjWU00nKbXn2zvySKO6M2
YvlSYDPSgpk=
=cS0Q
-----END PGP SIGNATURE-----

--VIT1Kna7lLfXMiZV--
