From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: SSD Optimizations
Date: Sat, 13 Mar 2010 20:01:26 +0100
Message-ID: <201003132001.26896.hka@qbs.com.pl>
References: <4B97F7CE.4030405@bobich.net> <201003121700.09553.hka@qbs.com.pl> <20100313180210.4eb1b705.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100313180210.4eb1b705.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 13 March 2010 18:02:10 Stephan von Krawczynski wrote:
> On Fri, 12 Mar 2010 17:00:08 +0100
> Hubert Kario <hka@qbs.com.pl> wrote:
> > > Even on true
> > > spinning disks your assumption is wrong for relocated sectors.
> >=20
> > Which we don't have to worry about because if the drive has less th=
an 5
> > of 'em, the impact of hitting them is marginal and if there are mor=
e,
> > the user has much more pressing problem than the performance of the
> > drive or FS.
>=20
> Are you really sure that a drive firmware tells you about the true nu=
mber
> of relocated sectors? I mean if it makes the product look better in
> comparison to another product, are you really sure that the firmware =
will
> not tell you what you expect to see only to make you content and happ=
y
> with your drive?

because Joe Sixpack reads SMART values, and even if he does, he will be=
 much=20
more angry when a drive that has no or few relocations fails, that when=
 a=20
drive that reports that's failing fails.

If the drive arrives with badsectors, it goes where it came from the sa=
me day=20
if it meets an IT guy worth its salt, any IT guy knows that some HDDs d=
evelop=20
badsectors no matter the make and model, but if they do, you replace th=
em.

And as the Google disk survey showed, the SMART has very high percentag=
e of=20
Type I errors, but very few Type II errors.

But we're off-topic here

> > > Which
> > > basically means that every disk controller firmware fiddles aroun=
d with
> > > the physical layout since decades. Please accept that you cannot =
do a
> > > disks' job in FS. The more advanced technology gets the more disk=
s
> > > become black boxes with a defined software interface. Use this
> > > interface and drop the idea of having inside knowledge of such a
> > > device. That's other peoples' work. If you want to design smart S=
SD
> > > controllers hire at a company that builds those.
> >=20
> > And I don't think that doing disks' job in the FS is good idea, but=
 I
> > think that we should be able to minimise the impact of the translat=
ion
> > layer.
> >=20
> > The way to do this, is to threat the device as a block device with
> > sectors the size of erase-blocks. That's nothing too fancy, don't y=
ou
> > think?
>=20
> I don't believe anyone is able to tell the size of erase-blocks of so=
me
> device - current and future - for sure.

Well, if the engeneer that designed it doesn't know this, I don't know =
how he=20
got his degree.

Just because it isn't publicised now, doesn't mean it won't be in near =
future.

Besides that, to detect how big the erase-blocks are in size is easy, i=
f they=20
have any impact on the performance, if they don't have any impact (what=
ever=20
the reason) tunning for their size is pointless anyway.=20

> I do believe that making this
> guess only reduces the future design options for new devices - if its
> creators care at all about your guess.

Did I, or any one else, say that we want to hardwire a specific erase-b=
lock=20
size to the design of the FS?! That would be utter stupidity!

> Why not let the fs designer take his creative options in fs layer and=
 let
> the device designer use his brain on the device level and all meet at=
 the
> predefined software interface in between - and nowhere _else_.

We (well, at least Gordon and I) just want a "stripe_width" option adde=
d to=20
the mkfs.btrfs, just like it is there for ext2/3/4, reiserfs, xfs and j=
fs to=20
name a few. It would need very few additional tweaks to make it SSD fri=
endly,=20
hardly any considering how -o ssd or -o ssd_spread already work.

You're forgetting there's an elephant in the room that won't to talk to=
=20
devices that don't have sectors 512B in size. If not for it, there woul=
dn't=20
even _be_ SSDs with 512B sectors.

It's not the way Flash memory works.

The 512B abstraction is there to be compatible, to work with one curren=
t OS,=20
it's not there because it describes better the way Flash memory works o=
r is=20
the best way to address the data on the device itself.

There are already consumer HDDs with 4kiB sector size, so the situation=
 is =20
getting better. We can only hope that in few years time the SSDs will h=
ave=20
sectors the size of erase-blocks. But in the mean time, stripe_width wo=
uld be=20
enough.


Besides, the stripe_width option will be not only useful for the SSDs b=
ut also=20
in environments where btrfs is on a device that is a RAID5/6 array=20
(reconfiguring a server with many virtual machines is far from easy and=
=20
sometimes just can't be done because of heterogeneous virtualised OSs t=
hat=20
need the data protection provided by lower layers).

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
