Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42407 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab3BNU4j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 15:56:39 -0500
Date: Thu, 14 Feb 2013 20:56:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Fredrik Tolf <fredrik@dolda2000.com>, linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
Message-ID: <20130214205632.GF28997@carfax.org.uk>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com>
 <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com>
 <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com>
 <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
 <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com>
 <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com>
 <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com>
 <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com>
 <20130214085925.GD28997@carfax.org.uk>
 <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ls2Gy6y7jbHLe9Od"
In-Reply-To: <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Ls2Gy6y7jbHLe9Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 11:05:39AM -0700, Chris Murphy wrote:
> 
> On Feb 14, 2013, at 1:59 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> 
> >> Data, RAID1: total=2.66TB, used=2.66TB
> > 
> >   This is the amount of actual useful data (i.e. what you see with du
> > or ls -l). Double this (because it's RAID-1) to get the number of
> > bytes or raw storage used.
> 
> Right, the decoder ring. Effectively no outsiders will understand
> this. It contradicts the behavior of conventional df with btrfs
> volumes. And it becomes untenable with per subvolume profiles.

   Correct, but *all* other single-value (or small-number-of-values)
displays of space usage fail in similar ways. We've(*) had this
discussion out on this mailing list many times before. All "simple"
displays of disk usage will cause someone to misinterpret something at
some point, and get cross.

(*) For non-"you" values of "we".

   If you want a display of "raw bytes used/free", then someone will
complain that they had 20GB free, wrote a 10GB file, and it's all
gone. If you want a display of "usable data used/free", then we can't
predict the "free" part. There is no single set of values that will
make this simple.

> >> Total devices 2 FS bytes used 1.64TB
> >> devid    1 size 2.73TB used 1.64TB path /dev/sdi1
> >> devid    2 size 2.73TB used 2.67TB path /dev/sde1
> > 
> >   This is the amount of raw disk space allocated. The total of used
> > here should add up to twice the "total" values above (for
> > Data+Metadata+System).
> 
> I'm mostly complaining about the first line. If 2.67TB of writes to sde1 are successful enough to be stated as "used" on that device, then FS bytes used should be at least 2.67TB.

   The values shown above are for bytes *allocated* -- i.e. the
"total" values shown in btrfs fi df. You haven't added in the
metadata, which I'm willing to bet is another 100 GiB or so allocated
space, bringing you up to the 2.67 TiB.

   (There's another problem with this display, which is that it's
actually showing TiB, not TB. There have been patches for this, but I
don't know if any are current).

> > 
> >> So I can't tell if it's ~1.64TB copied or 2.6TB.

   2.66 TiB. The 1.64TiB is clearly wrong, given all the other values.
Hence my conclusion below.

> >   Looks like /dev/sdi1 isn't actually being written to -- it should
> > be the same allocation as /dev/sde1.
> 
> Yeah he's getting a lot of these, and I don't know what it is:
> 
> > Feb 14 08:32:30 nerv kernel: [180511.760850] lost page write due to I/O error on /dev/sdd1
> 
> It's not tied to btrfs or libata so I don't think it's the drive itself reporting the write error. I think maybe the kernel has become confused as a result of the original ICRC ABRT, and the subsequent change from sdd to sdi. 

   That would be my conclusion, too. But with the newly-appeared
/dev/sdi1, btrfs fi show picks it up as belonging to the FS (because
it's got the same UUID), but it's not been picked up by the kernel, so
the kernel's not trying to write to it, and it's therefore massively
out of date.

   I think the solution, if it's certain that the drive is now
behaving sensibly again, is one of:

 * unmount, btrfs dev scan, remount, scrub
or
 * btrfs dev delete missing, add /dev/sdi1 to the FS, and balance

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I must be musical:  I've got *loads* of CDs ---           

--Ls2Gy6y7jbHLe9Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUR1Pf79z9OVl50rAAQK3/A//Um75IchyQulX4ppUZ6YHTS56WnUx+Uyh
UhvtbFnKAu3iGlYnYXryBfw311Js3kFKiB58l8odMmSLEDRT89JPHLWKoQcw6c+R
YLzFhWU9W34gFeoFmCYljMVnzceGy9xXTVyt9L+hs8wTfMw78pgK24HBNk3sZ6FJ
dg7g/PIg5mdGktnUCLbtByTElsTRIO+f3nHhQZTnJmjbsu64KVIAzP9UIrHxfKFe
xzkcnl6MwxqOaD1aQadKERQXv+5LRuGAwGiTz779MgYTHzHjkJIfqlXNgEpWi9ow
/aLd130aymLlt5AJMv0EMQtH89mzAgpJC8e6SJ7XiHXY6KC+MZY5X5UAvzz6pu2e
TuQZ3B6bpeEovb0GhLaIO9Umq9jv6bqeAG1GbaMrESvjLfOhkzrcF/r7oOaWWnkk
8Hu/aYymWqn4I9jBA7/YEGCCVsO21co0Cmj8SFOHHbPhDnTW1phjE+foxVmer0Ci
UXJiNfyZYmjTOSKWglXr1YPRxtWbJ+bGXhdJiKmXh0Q+8eWCN++V9vlccrEVWSYa
QNI85iAt4fdhnBe9WyfKFvdn0EkMmbyYqOsEVtGP2KVeNhY3SWTu8AKuvYcfDfh3
6EEgg3ssg7U2CTAwLBDc0agxc9gu/al0/Fp2523PZqNoXEVrR31Y1UHCId+ExiuY
ZmkcXl93ihY=
=BT/n
-----END PGP SIGNATURE-----

--Ls2Gy6y7jbHLe9Od--
