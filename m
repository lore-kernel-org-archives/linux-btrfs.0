Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39206 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751079AbaL0S2u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 13:28:50 -0500
Date: Sat, 27 Dec 2014 13:28:46 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Hugo Mills <hugo@carfax.org.uk>, Martin Steigerwald <Martin@lichtvoll.de>,
        Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Message-ID: <20141227182846.GA11878@hungrycats.org>
References: <3738341.y7uRQFcLJH@merkaba>
 <549DE5C6.2000606@pobox.com>
 <4232026.31LFOYpm2s@merkaba>
 <20141227093043.GJ25267@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
In-Reply-To: <20141227093043.GJ25267@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 27, 2014 at 09:30:43AM +0000, Hugo Mills wrote:
> On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrote:
> > Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> > > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
>    Now, since you're seeing lockups when the space on your disks is
> all allocated I'd say that's a bug. However, you're the *only* person
> who's reported this as a regular occurrence. Does this happen with all
> filesystems you have, or just this one?

I do see something similar, but there are so many problems going on I
have no idea which ones to report, and which ones are my own doing.  :-P

I see lots of CPU being burned when all the disk space is allocated
to chunks, but there is still lots of space free (multiple GB) inside
the chunks.

iotop shows a crapton of disk writes (1-5MB/sec) from one kworker.
There are maybe a few kB/sec of writes through the filesystem at the time.

The filesystem where I see this most is on a laptop, so the disk writes
also hit the CPU again for encryption.  There's so much CPU usage it's
worth mentioning twice.  :-(

'watch cat /proc/12345/stack' on the active processes shows the kernel
fairly often in that new chunk deallocator function whose name escapes
me at the moment.

Deleting a bunch of data then running balance helps return to sane CPU
usage...for a while (maybe a week?).

It's not technically "locked up" per se, but when a 5KB download takes
a minute or more, most users won't wait around to see the difference.

Kernel versions I'm using are 3.17.7 and 3.18.1.

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSe+l4ACgkQgfmLGlazG5zzNACghx7EGnU0vxuzvcn4hYGfnFFv
hxcAn2UmJBUyRfcsqu0xQ6SqXSEJ/eSY
=91Zq
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
