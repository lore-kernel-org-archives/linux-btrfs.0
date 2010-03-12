From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: SSD Optimizations
Date: Fri, 12 Mar 2010 17:00:08 +0100
Message-ID: <201003121700.09553.hka@qbs.com.pl>
References: <4B97F7CE.4030405@bobich.net> <201003120207.40740.hka@qbs.com.pl> <20100312101528.8e87810f.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100312101528.8e87810f.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 12 March 2010 10:15:28 Stephan von Krawczynski wrote:
> On Fri, 12 Mar 2010 02:07:40 +0100
>=20
> Hubert Kario <hka@qbs.com.pl> wrote:
> > > [...]
> > > If the FS were to be smart and know about the 256kb requirement, =
it
> > > would do a read/modify/write cycle somewhere and then write the 4=
KB.
> >=20
> > If all the free blocks have been TRIMmed, FS should pick a complete=
ly
> > free erasure size block and write those 4KiB of data.
> >=20
> > Correct implementation of wear leveling in the drive should notice =
that
> > the write is entirely inside a free block and make just a write cyc=
le
> > adding zeros to the end of supplied data.
>=20
> Your assumption here is that your _addressed_ block layout is complet=
ely
> identical to the SSDs "disk" layout.
> Else you cannot know where a "free
> erasure block" is located and how to address it from FS.
> I really wonder what this assumption is based on. You still think a S=
SD is
> a true disk with linear addressing. I doubt that very much.

I made no such assumptions.
Im sure that the linearity on the ATA LBA level isn't so linear on the =
device=20
level, especially after wear-leveling takes its toll, but I assume that=
 the=20
smallest block of data that the translation layer can address is erase-=
block=20
sized and that all the erase-block are equal in size. Otherwise the alg=
orithm=20
would be needlessly complicated which would make it both slower and mor=
e error=20
prone.

> Even on true
> spinning disks your assumption is wrong for relocated sectors.

Which we don't have to worry about because if the drive has less than 5=
 of=20
'em, the impact of hitting them is marginal and if there are more, the =
user=20
has much more pressing problem than the performance of the drive or FS.

> Which
> basically means that every disk controller firmware fiddles around wi=
th
> the physical layout since decades. Please accept that you cannot do a
> disks' job in FS. The more advanced technology gets the more disks be=
come
> black boxes with a defined software interface. Use this interface and=
 drop
> the idea of having inside knowledge of such a device. That's other
> peoples' work. If you want to design smart SSD controllers hire at a
> company that builds those.

And I don't think that doing disks' job in the FS is good idea, but I t=
hink=20
that we should be able to minimise the impact of the translation layer.

The way to do this, is to threat the device as a block device with sect=
ors the=20
size of erase-blocks. That's nothing too fancy, don't you think?

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
