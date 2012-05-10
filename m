From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Thu, 10 May 2012 21:43:58 +0200
Message-ID: <3868267.PxBJ7yCiiK@bursa22>
References: <20120508200228.GM8938@carfax.org.uk> <4FAA8352.4020304@schleiser.de> <201205101240.49200.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, Kaspar Schleiser <kaspar@schleiser.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201205101240.49200.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 10 of May 2012 12:40:49 Martin Steigerwald wrote:
> Am Mittwoch, 9. Mai 2012 schrieb Kaspar Schleiser:
> > Hi,
> >=20
> > On 05/08/2012 10:56 PM, Roman Mamedov wrote:
> > > Regarding btrfs, AFAIK even "btrfs -d single" suggested above wor=
ks
> > > not "per file", but per allocation extent, so in case of one disk
> > > failure you will lose random *parts* (extents) of random files,
> > > which in effect could mean no file in your whole file system will
> > > remain undamaged.
> >=20
> > Maybe we should evaluate the possiblility of such a "one file gets =
on
> > one disk" feature.
> >=20
> > Helmut Hullen has the use case: Many disks, totally non-critical bu=
t
> > nice-to-have data. If one disk dies, some *files* should lost, not =
some
> > *random parts of all files*.
> >=20
> > This could be accomplished by some userspace-tool that moves stuff
> > around, combined with "file pinning"-support, that lets the user ma=
ke
> > sure a specific file is on a specific disk.
>=20
> Yeah, basically I think thats the whole point Helmut is trying to mak=
e.
>=20
> I am not sure whether that should be in userspace. It could be just a=
n
> allocation mode like "raid0" or "single". Such as "single" as in one =
file
> is really on one disk and thats it.

I was thinking that "linear" would be good name for old style allocator=
=2E

Regards
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
