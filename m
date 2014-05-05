Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37241 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaEEAgn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 20:36:43 -0400
Date: Mon, 5 May 2014 01:36:39 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does Suse do live filesystem revert with btrfs?
Message-ID: <20140505003639.GO24298@carfax.org.uk>
References: <20140504005257.GF9061@merlins.org>
 <20140504232645.GQ9061@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MmQIYbZiCoQ2kDro"
In-Reply-To: <20140504232645.GQ9061@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MmQIYbZiCoQ2kDro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 04, 2014 at 04:26:45PM -0700, Marc MERLIN wrote:
> Actually, never mind Suse, does someone know whether you can revert to
> an older snapshot in place?

   Not while the system's running useful services, no.

> The only way I can think of is to mount the snapshot on top of the other
> filesystem. This gets around the umounting a filesystem with open
> filehandles problem, but this also means that you have to keep track of
> daemons that are still accessing filehandles on the overlayed
> filesystem.

   You have a good handle on the problems.

> My one concern with this approach is that you can't free up the
> subvolume/snapshot of the underlying filesystem if it's mounted and even
> after you free up filehandles pointing to it, I don't think you can
> umount it.
> 
> In other words, you can play this trick to delay a reboot a bit, but
> ultimately you'll have to reboot to free up the mountpoints, old
> subvolumes, and be able to delete them.

   Yup.

> Somehow I'm thinking Suse came up with a better method.

   I'm guessing it involves reflink copies of files from the snapshot
back to the "original", and then restarting affected services. That's
about the only other thing that I can think of, but it's got load of
race conditions in it (albeit difficult to hit in most cases, I
suspect).

   Hugo.

> Even if you don't know Suse, can you think of a better way to do this?
> 
> Thanks,
> Marc
> 
> On Sat, May 03, 2014 at 05:52:57PM -0700, Marc MERLIN wrote:
> > (more questions I'm asking myself while writing my talk slides)
> > 
> > I know Suse uses btrfs to roll back filesystem changes.
> > 
> > So I understand how you can take a snapshot before making a change, but
> > not how you revert to that snapshot without rebooting or using rsync,
> > 
> > How do you do a pivot-root like mountpoint swap to an older snapshot,
> > especially if you have filehandles opened on the current snapshot?
> > 
> > Is that what Suse manages, or are they doing something simpler?
> > 
> > Thanks,
> > Marc
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- That's not rain,  that's a lake with slots in it. ---        

--MmQIYbZiCoQ2kDro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2bdF1heFHXiqx3kAQKvZQ//beb4jjt+84ohUYyfKDg0pbshhYKC4CEV
H7QPg46LQ3jiee63Qp20TS9UzvQYF3Zw1e5DDyXhM93wA+LHefy9CNzfi2m5VKDa
m+0n+yeVVSCXQ4CW+g9eV6vAGaORh+7BI1+1fmnLTRagDI4MPjsVVmegWfUxRH5k
LDJxJCu8z0xkLI3179PvlnwDJoEfbXhFKTgeU3gquCzuQ1I8c5d2lx0NBZ41F5M2
ur/379bltZABXt+G8ucpp4KtSFKWBa1tHYyYHic/ewqGiluqy25vxi0sQCY3JReo
EHbBOCR7/IeFHxN3eFnTtBTq4P/u4F9woPhWw/mrRHg4+Cu0T/BKEsnYkuluhGvI
UdcBiXUpf0lUtd25ju7f+tRDS4UE8nm+VeXuRuFWSBsI19S7MhDKlDgdHVw5Xm4t
g5HmWH7u6fnRQ0x+efypb3ErIQj4P0d8vzxL7BfN6QMAvWoLiGnjU5Pwc6KJQGjD
JQ6dMJNR23PlfgU39bgpGpGWTNYENoB4XmwX/IsJub+TBsRs80YC6CYjRgfwrKlr
Na9s7sS5Z9cgF23JAKU5ivHi7gF1Q1Yh7ZZMHZbL+nHtVzLY4VCwah3kU5DhqJl4
9Egba2t+pAyUBaWteblW3PWCi/LCAfzGCbPs4c6i/XiD7+4AlmDUdwuVvHW5X7w3
lzw989v9Do8=
=4mYr
-----END PGP SIGNATURE-----

--MmQIYbZiCoQ2kDro--
