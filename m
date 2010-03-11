From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 15:01:55 +0100
Message-ID: <201003111501.55663.hka@qbs.com.pl>
References: <4B97F7CE.4030405@bobich.net> <20100311135909.a7acc23e.skraw@ithnet.com> <be59d9db8e9c4f9fa0dd856a95ed208b@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <be59d9db8e9c4f9fa0dd856a95ed208b@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 11 March 2010 14:20:23 Gordan Bobic wrote:
> On Thu, 11 Mar 2010 13:59:09 +0100, Stephan von Krawczynski
>=20
> <skraw@ithnet.com> wrote:
> >> >> > > >On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic
> >> >> > > ><gordan@bobich.net>
> >> >> > > >
> >> >> > > >wrote:
> >> >> > > >>Are there options available comparable to ext2/ext3 to he=
lp
> >>
> >> reduce
> >>
> >> >> > > >>wear and improve performance?
> >> >> >
> >> >> > With SSDs you don't have to worry about wear.
> >> >>
> >> >> Sorry, but you do have to worry about wear. I was able to destr=
oy a
> >> >> relatively
> >> >> new SD card (2007 or early 2008) just by writing on the first 1=
0MiB
> >>
> >> over
> >>
> >> >> and
> >> >> over again for two or three days. The end of the card still wor=
ks
> >> >> without
> >> >> problems but about 10 sectors on the beginning give write error=
s.
> >> >
> >> > Sorry, the topic was SSD, not SD.
> >>
> >> SD =3D=3D SSD with an SD interface.
> >
> > That really is quite a statement. You really talk of a few-bucks SD=
 card
> > (like the one in my android handy) as an SSD comparable with Intel =
XE
>=20
> only with
>=20
> > different interface? Come on, stay serious. The product is not only=
 made
>=20
> of
>=20
> > SLCs and some raw logic.
>=20
> I am saying that there is no reason for the firmware in an SD card to=
 not
> be as advanced. If the manufacturer has some advanced logic in their =
SATA
> SSD, I cannot see any valid engineering reason to not apply the same =
logic
> in a SD product.

The _SD_standard_ states that the media has to implement wear-leveling.
So any card with an SD logo implements it.

As I stated previously, the algorithms used in SD cards may not be as a=
dvanced=20
as those in top-of-the-line Intel SSDs, but I bet they don't differ by =
much to=20
the ones used in cheapest SSD drives.

Besides, why shouldn't we help the drive firmware by=20
- writing the data only in erase-block sizes
- trying to write blocks that are smaller than the erase-block in a way=
 that=20
won't cross the erase-block boundary
- using TRIM on deallocated parts of the drive

This will not only increase the life of the SSD but also increase its=20
performance.

>=20
> >> > Honestly I would just drop the idea of an SSD option simply beca=
use
>=20
> the
>=20
> >> > vendors implement all kinds of neat strategies in their devices.=
 So
>=20
> in
>=20
> >> the
> >>
> >> > end you cannot really tell if the option does something construc=
tive
> >> > and not destructive in combination with a SSD controller.
> >>
> >> You can make an educated guess. For starters given that visible se=
ctor
> >> sizes are not equal to FS block sizes, it means that FS block size=
s can
> >> straddle erase block boundaries without the flash controller, no m=
atter
> >> how
> >> fancy, being able to determine this. Thus, at the very least, alig=
ning
>=20
> FS
>=20
> >> structures so that they do not straddle erase block boundaries is
>=20
> useful
>=20
> >> in
> >> ALL cases. Thinking otherwise is just sticking your head in the sa=
nd
> >> because you cannot be bothered to think.
> >
> > And your guess is that intel engineers had no glue when designing t=
he XE
> > including its controller? You think they did not know what you and =
me
>=20
> know
>=20
> > and
> > therefore pray every day that some smart fs designer falls from hea=
ven
>=20
> and
>=20
> > saves their product from dying in between? Really?
>=20
> I am saying that there are problems that CANNOT be solved on the disk
> firmware level. Some problems HAVE to be addressed higher up the stac=
k.

Exactly, you can't assume that the SSDs firmware understands any and al=
l file=20
system layouts, especially if they are on fragmented LVM or other logic=
al=20
volume manager partitions.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl

System Zarz=C4=85dzania Jako=C5=9Bci=C4=85
zgodny z norm=C4=85 ISO 9001:2000
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
