From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: SSD Optimizations
Date: Sat, 13 Mar 2010 20:41:35 +0100
Message-ID: <201003132041.36712.hka@qbs.com.pl>
References: <4B97F7CE.4030405@bobich.net> <20100311180017.GK6509@think> <20100313174359.ec81c8b7.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, sander@humilis.net,
	linux-btrfs@vger.kernel.org, Gordan Bobic <gordan@bobich.net>
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100313174359.ec81c8b7.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 13 March 2010 17:43:59 Stephan von Krawczynski wrote:
> On Thu, 11 Mar 2010 13:00:17 -0500
> Chris Mason <chris.mason@oracle.com> wrote:
> > On Thu, Mar 11, 2010 at 06:35:06PM +0100, Stephan von Krawczynski w=
rote:
> > > On Thu, 11 Mar 2010 15:39:05 +0100
> > > Sander <sander@humilis.net> wrote:
> > > > Stephan von Krawczynski wrote (ao):
> > > > > Honestly I would just drop the idea of an SSD option simply b=
ecause
> > > > > the vendors implement all kinds of neat strategies in their
> > > > > devices. So in the end you cannot really tell if the option d=
oes
> > > > > something constructive and not destructive in combination wit=
h a
> > > > > SSD controller.
> > > >=20
> > > > My understanding of the ssd mount option is also that the fs do=
ens't
> > > > try to do all kinds of smart (and potential expensive) things w=
hich
> > > > make sense for rotating media to reduce seeks and the like.
> > > >=20
> > > > 	Sander
> > >=20
> > > Such an optimization sounds valid on first sight. But re-think cl=
osely:
> > > how does the fs really know about seeks needed during some operat=
ion?
> >=20
> > Well the FS makes a few assumptions (in the nonssd case).  First it
> > assumes the storage is not a memory device.  If things would fit in
> > memory we wouldn't need filesytems in the first place.
>=20
> Ok, here is the bad news. This assumption everything from right to
> completely wrong, and you cannot really tell the mainstream answer.
> Two examples from opposite parts of the technology world:
> - History: way back in the 80's there was a 3rd party hardware for C=3D=
1541
> (floppy drive for C=3D64) that read in the complete floppy and served=
 all
> incoming requests from the ram buffer. So your assumption can already=
 be
> wrong for a trivial floppy drive from ancient times.

such assumption doesn't make it work slower on such device

> - Nowadays: being a linux installation today chances are that the mat=
rix
> has you. Quite a lot of installations are virtualized. So your storag=
e is
> a virtual one either, which means it is likely being a fs buffer from=
 the
> host system, i.e. RAM.

Buffers use read_ahead and are smaller than the underlaying device, sti=
ll, such=20
assumption doesn't make the FS perform worse in this situation.=20

> And sorry to say: "if things would fit in memory" you probably still =
need a
> fs simply because there is no actual way to organize data (be it
> executable or not) in RAM without a fs layer. You can't save data wit=
hout
> an abstract file data type. To have one accessible you need a fs.

yes, that's why there is tmpfs, btrfs isn't meant to be all and end all=
 as far=20
as FSs go

> Btw the other way round is as interesting: there is currently no fs f=
or
> linux that knows how to execute in place. Meaning if you really had o=
nly
> RAM and you have a fs to organize your data it would be just logical =
to
> have ways to _not_ load data (in other parts of the RAM), but to use =
it in
> its original storage (RAM-)space.

at least ext2 does support XIP on platform that support it...

>=20
> > Then it assumes that adjacent blocks are cheap to read and blocks t=
hat
> > are far away are expensive to read.  Given expensive raid controlle=
rs,
> > cache, and everything else, you're correct that sometimes this
> > assumption is wrong.
>=20
> As already mentioned this assumption may be completely wrong even wit=
hout a
> raid controller, being within a virtual environment. Even far away bl=
ocks
> can be one byte away in the next fs buffer of the underlying host fs
> (assuming your device is in fact a file on the host;-).

and again, such assumption doesn't reduce the performance

>=20
> >  But, on average seeking hurts.  Really a lot.
>=20
> Yes, seeking hurts. But there is no way to know if there is seeking a=
t all.
> On the other hand, if your storage is a netblock device seeking on th=
e
> server is probably your smallest problem, compared to the network lat=
ency
> in between.

and because of that, there's read ahead and support for big packets on =
the TCP=20
level, so the assumption does make the FS perform better with it than w=
ithout=20
it.


It's one of the assumptions that you _have_ to make, just like the assu=
mption=20
that the computer counts in binary, or there's more disk space than RAM=
=2E But=20
those assumptions _don't_ make the performance (much) worse when they d=
on't=20
hold true for known devices that can impersonate rotating magnetic medi=
a.

> > We try to organize files such that files that are likely to be read
> > together are found together on disk.  Btrfs is fairly good at this
> > during file creation and not as good as ext*/xfs as files over
> > overwritten and modified again and again (due to cow).
>=20
> You are basically saying that btrfs perfectly organizes write-once de=
vices
> ;-)
>=20
> > If you turn mount -o ssd on for your drive and do a test, you might=
 not
> > notice much difference right away.  ssds tend to be pretty good rig=
ht
> > out of the box.  Over time it tends to help, but it is a very hard =
thing
> > to benchmark in general.
>=20
> Honestly, this sounds like "I give up" to me ;-)
> You just said that generally it is "very hard to benchmark". Which me=
ans
> "nobody can see or feel it in real world" in non-tech language.

No, it's not this. When a SSD is fresh, the undeling write leveling has=
 many=20
blocks to choose from, so it's blaizing fast. The same holds true when =
the=20
test uses small amount of data (relative to SSD size).

"very hard to benchmark" means just that -- the benchmark is much more=20
complicated, must take into account much more variables and takes much =
more=20
time compared to rotating magnetic media benchmark.

To test SSD performance you need to benchmark both the speed of flash m=
emory=20
_and_ the speed and performance of the write leveling algorithm (becaus=
e it=20
shows its ugly head only after specific workloads or when all blocks ar=
e=20
allocated), and that's non trivial to say the least. Add FS on top of i=
t and=20
you have a nice dissertation right there.

--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=F3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
