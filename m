From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Hot data Tracking
Date: Thu, 03 May 2012 23:58:15 +0200
Message-ID: <1870258.Ysf9k76nss@bursa01>
References: <4F35F365.8000602@googlemail.com> <20120221232445.GJ1046@twin.jikos.cz> <4FA28385.7040709@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Timo Witte <timo.witte@googlemail.com>, linux-btrfs@vger.kernel.org
To: Waxhead <waxhead@online.no>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA28385.7040709@online.no>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 03 of May 2012 15:09:25 Waxhead wrote:
> David Sterba wrote:
> > On Sat, Feb 11, 2012 at 05:49:41AM +0100, Timo Witte wrote:
> >> What happened to the hot data tracking feature in btrfs? There are=
 a lot
> >> of old patches from aug 2010, but it looks like the feature has be=
en
> >> completly removed from the current version of btrfs. Is this featu=
re
> >> still on the roadmap?
> >=20
> > Removed? AFAIK it hasn't been ever merged, though it's be a nice
> > feature. There were suggestions to turn it into a generic API for a=
ny
> > filesystem to use, but this hasn't happened.
> >=20
> > The patches are quite independent and it was easy to refresh them o=
n top
> > of current for-linus branch. A test run did not survive a "random"
> > xfstest, 013 this time, so I probably mismerged some bits. The patc=
hset
> > lives in branch foreign/ibm/hotdatatrack in my git repo.
> >=20
> >=20
> > david
>=20
> Someone recently mentioned bcache in another post who seems to cover
> this subject fairly well.

bcache does one very specific assertion that isn't met by btrfs: overwr=
ing old=20
data in a file writes data to the same place on the disk, same goes for=
=20
metadata. In other words, it won't work with COW file system.

> However would it not make sense if btrfs
> actually was able to automatically take advantage of whatever disks i=
s
> added to the pool? For example if you have 10 disk of different size =
and
> performance in a raid5/6 like configuration would it not be feasible =
if
> btrfs automagically (option) could manage it's own cache? For example=
 it
> could reserve a chunk of free space as cache (based on how much data =
is
> free) and stripe data over all disks (cache). When the filesystem
> becomes idle or at set intervals it could empty the cache or
> move/rebalance pending writes over to the original raid5/6 like setup=
=2E
> As far as I remember hot data tracking was all about moving the data
> over to the fastest disk. Why not utilize all disks and benefit from
> disks working together?

=46or this to work, you need feature set that allows hot data movement =
between=20
disks and data restriping. Then such cache feature will use much of the=
 same=20
code.

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
