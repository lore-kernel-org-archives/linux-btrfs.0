From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 11:59:57 +0100
Message-ID: <201003111159.58081.hka@qbs.com.pl>
References: <4B97F7CE.4030405@bobich.net> <4B9829B1.1020706@bobich.net> <20100311073853.GA26129@attic.humilis.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Gordan Bobic <gordan@bobich.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311073853.GA26129@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 11 March 2010 08:38:53 Sander wrote:
> Hello Gordan,
>=20
> Gordan Bobic wrote (ao):
> > Mike Fedyk wrote:
> > >On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic <gordan@bobich.net>=
 wrote:
> > >>Are there options available comparable to ext2/ext3 to help reduc=
e
> > >>wear and improve performance?
>=20
> With SSDs you don't have to worry about wear.

Sorry, but you do have to worry about wear. I was able to destroy a rel=
atively=20
new SD card (2007 or early 2008) just by writing on the first 10MiB ove=
r and=20
over again for two or three days. The end of the card still works witho=
ut=20
problems but about 10 sectors on the beginning give write errors.

And with journaled file systems that write over and over again on the s=
ame spot=20
you do have to worry about wear leveling. It depends on the underlying =
block=20
allocation algorithm, but I'm sure that most of the cheap SSDs do wear=20
leveling only inside big blocks, not on whole hard drive, making it muc=
h=20
easier to hit the 10 000-100 000 erase cycles boundary.

Still, I think that if you can prolong the life of hardware without not=
icable=20
performance degradation, you should do it. Just because it may help the=
 drive=20
with some defects last those 3-5years between upgreades without any pro=
blems.

>=20
> > And while I appreciate hopeful remarks along the lines of "I think
> > you'll get more out of btrfs", I am really after specifics of what
> > the ssd mount option does, and what features comparable to the
> > optimizations that can be done with ext2/3/4 (e.g. the mentioned
> > stripe-width option) are available to get the best possible
> > alignment of data and metadata to increase both performance and lif=
e
> > expectancy of a SSD.
>=20
> Alignment is about the partition, not the fs, and thus taken care of
> with fdisk and the like.
>=20
> If you don't create a partition, the fs is aligned with the SSD.

But it does not align internal FS structures to the SSD erase block siz=
e and=20
that's what Gordon asked for.

And sorry Gordon, I don't know. But there's a 'ssd_spread' option that =
tries=20
to allocate blocks as far as possible (within reason) from  themselfs. =
That=20
should, in most cases, make the fs structures reside on an erase block =
by =20
themself.
I'm afraid that you'll need to dive into the code to know about block=20
alignment or one of the developers will need to provide us with info.

>=20
> > Also, for drives that don't support TRIM, is there a way to make th=
e
> > FS apply aggressive re-use of erased space (in order to help the
> > drive's internal wear-leveling)?
>=20
> TRIM has nothing to do with wear-leveling (although it helps reducing
> wear).
> TRIM lets the OS tell the disk which blocks are not in use anymore, a=
nd
> thus don't have to be copied during a rewrite of the blocks.
> Wear-leveling is the SSD making sure all blocks are more or less equa=
lly
> written to avoid continuous load on the same blocks.

Isn't this all about wear leveling? TRIM has no meaning for magnetic me=
dia.=20
It's used to tell the drive which parts of medium contain only junk dat=
a and=20
can be used in block rotation, making the wear-leveling easier and more=
=20
effective.

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
