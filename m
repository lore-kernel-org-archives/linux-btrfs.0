From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: SSD Optimizations
Date: Fri, 12 Mar 2010 02:07:40 +0100
Message-ID: <201003120207.40740.hka@qbs.com.pl>
References: <4B97F7CE.4030405@bobich.net> <0592c2cb505638c1110eaef97192eb60@localhost> <20100311161932.GH6509@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311161932.GH6509@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 11 March 2010 17:19:32 Chris Mason wrote:
> On Thu, Mar 11, 2010 at 04:03:59PM +0000, Gordan Bobic wrote:
> > On Thu, 11 Mar 2010 16:35:33 +0100, Stephan von Krawczynski
> >=20
> > <skraw@ithnet.com> wrote:
> > >> Besides, why shouldn't we help the drive firmware by
> > >> - writing the data only in erase-block sizes
> > >> - trying to write blocks that are smaller than the erase-block i=
n a
> > >> way that won't cross the erase-block boundary
> > >=20
> > > Because if the designing engineer of a good SSD controller wasn't=
 able
> >=20
> > to
> >=20
> > > cope with that he will have no chance to design a second one.
> >=20
> > You seem to be confusing quality of implementation with theoretical
> > possibility.
> >=20
> > >> This will not only increase the life of the SSD but also increas=
e its
> > >> performance.
> > >=20
> > > TRIM: maybe yes. Rest: pure handwaving.
> > >=20
> > >> [...]
> > >>=20
> > >> > > And your guess is that intel engineers had no glue when desi=
gning
> > >> > > the XE
> > >> > > including its controller? You think they did not know what y=
ou and
> >=20
> > me
> >=20
> > >> > > know and
> > >> > > therefore pray every day that some smart fs designer falls f=
rom
> > >> > > heaven
> > >> > > and saves their product from dying in between? Really?
> > >> >=20
> > >> > I am saying that there are problems that CANNOT be solved on t=
he
> > >> > disk firmware level. Some problems HAVE to be addressed higher=
 up
> > >> > the
> >=20
> > stack.
> >=20
> > >> Exactly, you can't assume that the SSDs firmware understands any=
 and
> >=20
> > all
> >=20
> > >> file
> > >> system layouts, especially if they are on fragmented LVM or othe=
r
> > >> logical
> > >> volume manager partitions.
> > >=20
> > > Hopefully the firmware understands exactly no fs layout at all. T=
hat
> >=20
> > would
> >=20
> > > be
> > > braindead. Instead it should understand how to arrange incoming a=
nd
> > > outgoing
> > > data in a way that its own technical requirements are met as perf=
ect as
> > > possible. This is no spinning disk, it is completely irrelevant w=
hat
> > > the data
> > > layout looks like as long as the controller finds its way through=
 and
> >=20
> > copes
> >=20
> > > best with read/write/erase cycles. It may well use additional RAM=
 for
> > > caching and data reordering.
> > > Do you really believe ascending block numbers are placed in ascen=
ding
> > > addresses inside the disk (as an example)? Why should they? What =
does
> >=20
> > that
> >=20
> > > mean for fs block ordering? If you don't know anyway what a contr=
oller
> > > does to
> > > your data ordering, how do you want to help it with its job?
> > > Please accept that we are _not_ talking about trivial flash mem h=
ere or
> > > pseudo-SSDs consisting of sd cards. The market has already evolve=
d
> >=20
> > better
> >=20
> > > products. The dinosaurs are extincted even if some are still look=
ing
> >=20
> > alive.

You seem to be forgetting that CEOs like to save 10 cents per drive to =
show=20
"millions of dollars saved" by their work, I highly doubt that we won't=
 see=20
SSDs with half assed wear leveling implementations 10 years from now.

And no, I don't think that the linear storage that we see at the ATA le=
vel is=20
any linear on the drive itself. But erase blocks are still erase blocks=
=2E I=20
highly doubt that the abstraction layer works over sector sizes (512B) =
and not=20
over whole erase block sizes -- just because it would make it much more=
=20
complicated, thus slower.

This way, even if the writes to the flash cells are made in fashion sim=
ilar to=20
a LogFS, one will still get r/m/w cycle if the write is 512B in size on=
 a=20
block that has also other data.

> >=20
> > I am assuming that you are being deliberately facetious here (the
> > alternative is less kind). The simple fact is that you cannot come =
up
> > with some magical data (re)ordering method that nullifies problems =
of
> > common use-cases that are quite nasty for flash based media.
> >=20
> > For example - you have a disk that has had all it's addressable blo=
cks
> > tainted. A new write comes in - what do you do with it? Worse, a wr=
ite
> > comes in spanning two erase blocks as a consequence of the data
> > re-alignment in the firmware. You have no choice but to wipe them b=
oth
> > and re-write the data. You'd be better off not doing the magic and
> > assuming that the FS is sensibly aligned.
>=20
> Ok, how exactly would the FS help here?  We have a device with a 256k=
b
> erasure size, and userland does a 4k write followed by an fsync.

I assume here that the FS knows about erasure size and does implement T=
RIM.

> If the FS were to be smart and know about the 256kb requirement, it
> would do a read/modify/write cycle somewhere and then write the 4KB.

If all the free blocks have been TRIMmed, FS should pick a completely f=
ree=20
erasure size block and write those 4KiB of data.

Correct implementation of wear leveling in the drive should notice that=
 the=20
write is entirely inside a free block and make just a write cycle addin=
g zeros=20
to the end of supplied data.

> The underlying implementation is the same in the device.  It picks a
> destination, reads it then writes it back.  You could argue (and many
> people do) that this operation is risky and has a good chance of
> destroying old data.  Perhaps we're best off if the FS does the rmw
> cycle instead into an entirely safe location.

And IMO that's the idea behind TRIM -- not to force the device do do rm=
w=20
cycles, only write cycle or erase cycle, provided there's free space an=
d the=20
free space  doesn't have considerably more write cycles than the alread=
y=20
allocated data.

>=20
> It's a great place for research and people are definitely looking at =
it.
>=20
> But with all of that said, it has nothing to do with alignment or tri=
m.
> Modern ssds are a raid device with a large stripe size, and someone
> somewhere is going to do a read/modify/write to service any small wri=
te.
> You can force this up to the FS or the application, it'll happen
> somewhere.

Yes, and if the parition is full rmw will happen in the drive. But if t=
he=20
partition is far from full, free space is TRIMmed then than the r/m/w c=
ycle=20
will happen inside btrfs and the SSD won't have to do its magic -- maki=
ng the=20
process faster.

The effect will be a FS that behaves consistently over a broad range of=
 SSDs,=20
provided there's free space left.

> The filesystem metadata writes are a very small percentage of the
> problem overall.  Sure we can do better and try to force larger metad=
ata
> blocks.  This was the whole point behind btrfs' support for large tre=
e
> blocks, which I'll be enabling again shortly.

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
