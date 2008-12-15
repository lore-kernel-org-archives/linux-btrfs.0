From: devzero@web.de
Subject: Re: Compressed Filesystem
Date: Mon, 15 Dec 2008 23:14:01 +0100
Message-ID: <543703915@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fantastic feature!

i`m curious: can btrfs support more than one compression scheme at the =
same time, i.e. is compression "pluggable" ?

lzo compression coming to my mind, as this is giving real-time compessi=
on and may even speed up disk access.

compression ratio isn`t too bad, but speed is awesome and doesn`t need =
as much cpu as gzip.

experimental lzo compression in zfs-fuse showed that it could compress =
tarred kernel-source with 2.99x compressratio (where gzip gave 3.41x), =
so maybe lzo is a better algorithm for realtime filesystem compression.=
=2E.

regards
roland



=46rom: Chris Mason <chris.mason <at> oracle.com>
Subject: Re: Compressed Filesystem
Newsgroups: gmane.comp.file-systems.btrfs
Date: 2008-10-29 20:08:42 GMT (6 weeks, 5 days, 1 hour and 53 minutes a=
go)

On Wed, 2008-10-29 at 12:14 -0600, Anthony Roberts wrote:
> Hi, I have a few questions about this:
>=20
> > Compression is optional and off by default (mount -o compress to en=
able
> > it).  When enabled, every file is compressed.
>=20
> Do you know what the CPU load is like with this enabled?

Now that I've finally pushed the code out, you can try it ;)  One part
of the implementation I need to revisit is the place in the code where =
I
do compression means that most of the time the single threaded pdflush
is the one compressing.

This doesn't spread the load very well across the cpus.  It can be
fixed, but I wanted to get the code out there.

The decompression does spread across cpus, and I've gotten about 800MB/=
s
doing decompress and checksumming on a zero filled compressed file.  At
the time, the disk was reading 14MB/s.

>=20
> Do you know whether data can be compressed at a sufficient rate to st=
ill
> saturate the disk on recent-ish AMD/Intel CPUs?

My recentish intel cpu can compress and checksum at about 120MB/s. =20
>=20
> If no, is the effective pre-compression I/O rate still comparable to =
the
> disk without compression?
>=20

It depends on your disks...

> I'm pretty sure that won't even matter in many cases (eg you're seeki=
ng
> too much to care, or you're on a VM with lots of cores but congested
> disks, or you're dealing with media files that it doesn't bother
> compressing, etc), but I'm curious what sort of overhead this adds. :=
)
>=20
> Mostly it seems like a good tradeoff, it trades plentiful cores for s=
carce
> disk resources.

This varies quite a bit from workload to workload, in some places it'll
make a big difference, but many workloads are seek bound and not
bandwidth bound.

-chris


____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger geh=F6rt?=20
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3D3123

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
