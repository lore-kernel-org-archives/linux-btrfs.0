From: devzero@web.de
Subject: Re: Compressed Filesystem
Date: Tue, 16 Dec 2008 00:19:13 +0100
Message-ID: <543762723@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> If multiple compression schemes are implemented how should the user g=
o
> about choosing which one they want? Should it be done at kernel time?=
 Or
> with the userland tools on a per file basis(maybe zlib is the default
> but a user could say I want this directory to be bzip)?

yes, why not...

doing that at mounttime like

mount -o compress,cscheme=3Dmyzip /dev/xyz /mntpoint

would be a good start....



> -----Urspr=FCngliche Nachricht-----
> Von: "Lee Trager" <lt73@cs.drexel.edu>
> Gesendet: 16.12.08 00:07:32
> An: devzero@web.de
> CC: linux-btrfs@vger.kernel.org
> Betreff: Re: Compressed Filesystem


> If multiple compression schemes are implemented how should the user g=
o
> about choosing which one they want? Should it be done at kernel time?=
 Or
> with the userland tools on a per file basis(maybe zlib is the default
> but a user could say I want this directory to be bzip)?
>=20
> On Mon, Dec 15, 2008 at 11:14:01PM +0100, devzero@web.de wrote:
> > fantastic feature!
> >=20
> > i`m curious: can btrfs support more than one compression scheme at =
the same time, i.e. is compression "pluggable" ?
> If you look at compression.c, compression.h, and ctree.h you can clea=
rly
> see that support for multiple compression scheme was in mind. Implmen=
ted
> a new one shouldn't be to hard but you probably want to make the curr=
ent
> system a little bit more pluggable and move all the zlib stuff into
> zlib.c.
> >=20
> > lzo compression coming to my mind, as this is giving real-time comp=
ession and may even speed up disk access.
> >=20
> > compression ratio isn`t too bad, but speed is awesome and doesn`t n=
eed as much cpu as gzip.
> >=20
> In some tests I've run zlib is actually faster then nocompression
> because of the lesser amount of data that has to transfer to and from
> the disk. It would be instresting to see how bzip works with this to.
> > experimental lzo compression in zfs-fuse showed that it could compr=
ess tarred kernel-source with 2.99x compressratio (where gzip gave 3.41=
x), so maybe lzo is a better algorithm for realtime filesystem compress=
ion...
> >=20
> > regards
> > roland
> >=20
> >=20
> >=20
> > From: Chris Mason <chris.mason <at> oracle.com>
> > Subject: Re: Compressed Filesystem
> > Newsgroups: gmane.comp.file-systems.btrfs
> > Date: 2008-10-29 20:08:42 GMT (6 weeks, 5 days, 1 hour and 53 minut=
es ago)
> >=20
> > On Wed, 2008-10-29 at 12:14 -0600, Anthony Roberts wrote:
> > > Hi, I have a few questions about this:
> > >=20
> > > > Compression is optional and off by default (mount -o compress t=
o enable
> > > > it).  When enabled, every file is compressed.
> > >=20
> > > Do you know what the CPU load is like with this enabled?
> >=20
> > Now that I've finally pushed the code out, you can try it ;)  One p=
art
> > of the implementation I need to revisit is the place in the code wh=
ere I
> > do compression means that most of the time the single threaded pdfl=
ush
> > is the one compressing.
> >=20
> > This doesn't spread the load very well across the cpus.  It can be
> > fixed, but I wanted to get the code out there.
> >=20
> > The decompression does spread across cpus, and I've gotten about 80=
0MB/s
> > doing decompress and checksumming on a zero filled compressed file.=
  At
> > the time, the disk was reading 14MB/s.
> >=20
> > >=20
> > > Do you know whether data can be compressed at a sufficient rate t=
o still
> > > saturate the disk on recent-ish AMD/Intel CPUs?
> >=20
> > My recentish intel cpu can compress and checksum at about 120MB/s. =
=20
> > >=20
> > > If no, is the effective pre-compression I/O rate still comparable=
 to the
> > > disk without compression?
> > >=20
> >=20
> > It depends on your disks...
> >=20
> > > I'm pretty sure that won't even matter in many cases (eg you're s=
eeking
> > > too much to care, or you're on a VM with lots of cores but conges=
ted
> > > disks, or you're dealing with media files that it doesn't bother
> > > compressing, etc), but I'm curious what sort of overhead this add=
s. :)
> > >=20
> > > Mostly it seems like a good tradeoff, it trades plentiful cores f=
or scarce
> > > disk resources.
> >=20
> > This varies quite a bit from workload to workload, in some places i=
t'll
> > make a big difference, but many workloads are seek bound and not
> > bandwidth bound.
> >=20
> > -chris
> >=20
> >=20
> > ___________________________________________________________________=
_
> > Psssst! Schon vom neuen WEB.DE MultiMessenger geh?rt?=20
> > Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3D3=
123
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


_______________________________________________________________________
Sensationsangebot verl=E4ngert: WEB.DE FreeDSL - Telefonanschluss + DSL
f=FCr nur 16,37 Euro/mtl.!* http://dsl.web.de/?ac=3DOM.AD.AD008K15039B7=
069a

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
