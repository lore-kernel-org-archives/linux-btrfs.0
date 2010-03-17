From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Content based storage
Date: Wed, 17 Mar 2010 20:43:17 +0100
Message-ID: <201003172043.17314.hka@qbs.com.pl>
References: <hnnijd$jol$1@dough.gmane.org> <201003171625.50257.hka@qbs.com.pl> <23a15591003170833t3ec4dc3fq9630558aa190afc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591003170833t3ec4dc3fq9630558aa190afc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 17 March 2010 16:33:41 Leszek Ciesielski wrote:
> On Wed, Mar 17, 2010 at 4:25 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> > On Wednesday 17 March 2010 09:48:18 Heinz-Josef Claes wrote:
> >> Hi,
> >>
> >> just want to add one correction to your thoughts:
> >>
> >> Storage is not cheap if you think about enterprise storage on a SA=
N,
> >> replicated to another data centre. Using dedup on the storage boxe=
s
> >> leads to performance issues and other problems - only NetApp is of=
fering
> >> this at the moment and it's not heavily used (because of the issue=
s).
> >
> > there are at least two other suppliers with inline dedup products a=
nd
> > there is OSS solution: lessfs
> >
> >> So I think it would be a big advantage for professional use to hav=
e
> >> dedup build into the filesystem - processors are faster and faster=
 today
> >> and not the cost drivers any more. I do not think it's a problem t=
o
> >> "spend" on core of a 2 socket box with 12 cores for this purpose.
> >> Storage is cost intensive:
> >> - SAN boxes are expensive
> >> - RAID5 in two locations is expensive
> >> - FC lines between locations is expensive (depeding very much on w=
here
> >> you are).
> >
> > In-line dedup is expensive in two ways: first you have to cache the=
 data
> > going to disk and generate checksum for it, then you have to look i=
f such
> > block is already stored -- if the database doesn't fit into RAM (fo=
r a VM
> > host it's more than likely) it requires at least few disk seeks, if=
 not a
> > few dozen for really big databases. Then you should read the block/=
extent
> > back and compare them bit for bit. And only then write the data to =
the
> > disk. That reduces your IOPS by at least an order of maginitude, if=
 not
> > more.
>=20
> Sun decided that with SHA256 (which ZFS uses for normal checksumming)
> collisions are unlikely enough to skip the read/compare step:
> http://blogs.sun.com/bonwick/entry/zfs_dedup . That's not the case, o=
f
> course, with btrfs-used CRC32, but a switch to a stronger hash would
> be recommended to reduce collisions anyway. And yes, for the truly
> paranoid, a forced verification (after the hashes match) is always an
> option.
>=20

If the server contains financial data I'd prefer the "impossible" not=20
"unlikely".

Read further, Sun did provide a way to enable the compare step by using=
=20
"verify" instead of "on":
zfs set dedup=3Dverify <pool>

And, yes, I know that the probability of hardware malfunction is vastly=
 higher=20
than the probability of collision (that's why I wrote "should", next ti=
me I'll=20
write it as SHOULD as per RFC2119 ;), but, as the history showed, all h=
ash=20
algorithms are broken, the question is only when, if the FS does verify=
 the=20
data, then the attacker can't use the collisions to get data it souldn'=
t have=20
access to.
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl

System Zarz=B1dzania Jako=B6ci=B1
zgodny z norm=B1 ISO 9001:2000
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
