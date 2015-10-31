Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38663 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbJaSdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 14:33:39 -0400
Date: Sat, 31 Oct 2015 18:33:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Simon King <simon.king@uni-koeln.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to delete this snapshot, and how to succeed with balancing?
Message-ID: <20151031183337.GG21103@carfax.org.uk>
References: <5634DD93.9050605@uni-koeln.de>
 <20151031164112.GF21103@carfax.org.uk>
 <5634FB01.9030602@uni-koeln.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKYYegg/GYAC5JIZ"
In-Reply-To: <5634FB01.9030602@uni-koeln.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TKYYegg/GYAC5JIZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 31, 2015 at 06:31:45PM +0100, Simon King wrote:
> Hi Hugo,
> 
> Am 31.10.2015 um 17:41 schrieb Hugo Mills:
> >> linux-va3e:~ # uname -a
> >> Linux linux-va3e.site 3.16.7-29-desktop #1 SMP PREEMPT Fri Oct 23
> >> 00:46:04 UTC 2015 (6be6a97) x86_64 x86_64 x86_64 GNU/Linux
> > 
> >    OK, that's a bit old -- you would probably do well to upgrade this
> > anyway, regardless of the issues you're having. (I'd recommend 4.1 at
> > the moment; there's a bug in 4.2 at the moment that affects
> > balancing).
> 
> The latest version of openSuse is Tumbleweed, in a few days there will
> be openSuse Leap; I am not sure what kernel it would give me.
> 
> >    I thought snapper could automatically delete old snapshots. (I've
> > never used it, though, so I'm not sure). Worth looking at the snapper
> > config to see if you can tell it how many to keep.
> 
> Probably it can, right.
> 
> >    You're telling it to move the first two chunks with less than 10%
> > usage. If all the other chunks are full, and there are two chunks (one
> > data, one metadata) with less than 10% usage, then they'll be moved to
> > two new chunks... with less than 10% usage. So it's perfectly possible
> > that the same command will show the same output.
> 
> Do I understand correctly: In that situation, balancing would have no
> benefit, as two old chunks are moved to two new chunks? Then why are
> they moved at all?

   Because that's what balance does -- it's a fairly blunt tool for
one thing (evening out the usage across multiple devices) that happens
to have some useful side-effects (compacting space usage into smaller
numbers of block groups and freeing up the empty ones).

> >    Incidentally, I would suggest using -dlimit=2 on its own, rather
> > than both limit and usage.
> 
> I combined the two, since -dlimit on its own won't work:
> 
> linux-va3e:~ # btrfs balance start -dlimit=2 /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail

   And this is with a filesystem that's not fully allocated?
(i.e. btrfs fi show indicates that used and total are different for
each device). If that's the case, then you may have hit a known but
unfixed bug to do with space allocation.

> >    "btrfs balance start /" should rebalance the whole filesystem --
> 
> linux-va3e:~ # btrfs balance start /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> linux-va3e:~ # dmesg | tail
> [ 9814.499013] BTRFS info (device sda2): found 8153 extents
> [ 9815.254270] BTRFS info (device sda2): relocating block group
> 820062978048 flags 36
> [ 9826.335122] BTRFS info (device sda2): found 8182 extents
> [ 9826.858482] BTRFS info (device sda2): relocating block group
> 805064146944 flags 36
> [ 9839.444820] BTRFS info (device sda2): found 8184 extents
> [ 9839.822108] BTRFS info (device sda2): relocating block group
> 794595164160 flags 36
> [ 9850.456697] BTRFS info (device sda2): found 8143 extents
> [ 9850.778264] BTRFS info (device sda2): relocating block group
> 794460946432 flags 36
> [ 9862.546336] BTRFS info (device sda2): found 8140 extents
> [ 9862.890330] BTRFS info (device sda2): 12 enospc errors during balance
> 
> 
> > not that you'd need to for purposes of dealing with space usage
> > issues.
> 
> I know that "df" is different from "btrfs fi df". However, I see that df
> shows significantly more free space after balancing. Also, when my
> computer became unusable, the problem disappeared by balancing and
> defragmentation (deleting the old snapshots was not enough).
> 
> Unfortunately, df also shows significantly less free space after
> UNSUCCESSFUL balancing.
> 
> >    You may have more success using mkfs.btrfs --mixed when you create
> > the FS, which puts data and metadata in the same chunks.
> 
> Can I do this in the running system? Or would that only be an option
> during upgrade of openSuse Harlequin to Tumbleweed/Leap? Or even worse:
> Only an option after nuking the old installation and installing a new
> one from scratch?

   You'd have to recreate the FS, so it's a matter of a reinstall, or
nuking it and restoring from your backups.

   Hugo.

-- 
Hugo Mills             | Le Corbusier's plan for improving Paris involved the
hugo@... carfax.org.uk | assassination of the city, and its rebirth as tower
http://carfax.org.uk/  | blocks.
PGP: E2AB1DE4          |                   Robert Hughes, The Shock of the New

--TKYYegg/GYAC5JIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWNQmBAAoJEFheFHXiqx3k6xkP/RibrQZAfKd5fcJtrTFFuWDE
VZq+K3FRnsSGev36LFVvB4iLt+n08OT6Y5ownfKKOjSNOCyypg3OOfDlv/tBHGqT
Wob4LFi9imRjU8TldHKmIthuoXojcUcoZAraze+tnXcCK/6AUEXf9B9whyJUjEwA
72RJHQmTArSK4iZQ0mUeEZ5n+CarU6zC48h3BPI9260fg6G45DFyK9mwY2Scb2qe
fFQESfHUk+kdTJxVxIaL/LLBq9l0R1E6A9qxaEdlNAs7HVOc+kB+hJS/74XsDxNx
uckOmIlE0mygBPUAbSRZz1ikVtLug1ZYMhUOko84iplezzZo9ZlTJjwpUGVnTIqA
cXo/eF/MwDPp3gL4FLX9wyj/kbKts/j6CnfiIDD7hSfjlXAGXkZTWbhjEdhM0KwA
ZZ056w7QY6dh/74AASH70vyxZfVlf3k5kdkvgfwcVEh3bjLc6jEgD/MewXzwFecm
m+Pmop8RufIcVAU45nh8ZFexLt7XdcAtOgi1GvVal8RpsKsrOqxcnJT1rlwpFh+A
ThsENev8FbZTiZCmCJL3F37AoXJC6Tdbrqc9JpbHg4h8d0+//QZ+pVrt1v7JjwBH
pa3GZVzGalmNPSAK8hR5TMh3YA768MISWrXJLSfMqli465XWNCUikv0DG0znJhwZ
8l2P1Mug8b+VosIF5o0J
=UClU
-----END PGP SIGNATURE-----

--TKYYegg/GYAC5JIZ--
