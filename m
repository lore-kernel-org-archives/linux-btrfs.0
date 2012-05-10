From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Thu, 10 May 2012 22:23:27 +0200
Message-ID: <5041285.rOQcMTyNWa@bursa22>
References: <20120508200228.GM8938@carfax.org.uk> <3868267.PxBJ7yCiiK@bursa22> <20120510201530.GS8938@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org, Kaspar Schleiser <kaspar@schleiser.de>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120510201530.GS8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 10 of May 2012 21:15:30 Hugo Mills wrote:
> On Thu, May 10, 2012 at 09:43:58PM +0200, Hubert Kario wrote:
> > On Thursday 10 of May 2012 12:40:49 Martin Steigerwald wrote:
> > > Am Mittwoch, 9. Mai 2012 schrieb Kaspar Schleiser:
> > > > Hi,
> > > >=20
> > > > On 05/08/2012 10:56 PM, Roman Mamedov wrote:
> > > > > Regarding btrfs, AFAIK even "btrfs -d single" suggested above
> > > > > works
> > > > > not "per file", but per allocation extent, so in case of one =
disk
> > > > > failure you will lose random *parts* (extents) of random file=
s,
> > > > > which in effect could mean no file in your whole file system =
will
> > > > > remain undamaged.
> > > >=20
> > > > Maybe we should evaluate the possiblility of such a "one file g=
ets
> > > > on
> > > > one disk" feature.
> > > >=20
> > > > Helmut Hullen has the use case: Many disks, totally non-critica=
l but
> > > > nice-to-have data. If one disk dies, some *files* should lost, =
not
> > > > some
> > > > *random parts of all files*.
> > > >=20
> > > > This could be accomplished by some userspace-tool that moves st=
uff
> > > > around, combined with "file pinning"-support, that lets the use=
r
> > > > make
> > > > sure a specific file is on a specific disk.
> > >=20
> > > Yeah, basically I think thats the whole point Helmut is trying to
> > > make.
> > >=20
> > > I am not sure whether that should be in userspace. It could be ju=
st an
> > > allocation mode like "raid0" or "single". Such as "single" as in =
one
> > > file
> > > is really on one disk and thats it.
> >=20
> > I was thinking that "linear" would be good name for old style alloc=
ator.
>=20
>    Please do distinguish between the replication level (e.g. "single"=
,
> "RAID-1") and the allocator algorithm. These are distinct. Also, note
> that both of those work on the scale of chunks/block groups. There is
> a further consideration, which is the allocation of file data to bloc=
k
> groups, which is a whole different thing again (and not something I
> know a great deal about), but which will also affect the desired
> outcome quite a lot.

Yes, I know about that.

I was more thinking on the line "how quickly restore aviability of old=20
allocator".

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
