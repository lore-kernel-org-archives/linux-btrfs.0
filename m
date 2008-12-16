From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: Compressed Filesystem
Date: Tue, 16 Dec 2008 10:20:04 -0500
Message-ID: <20081216152004.GA7002@tux64-01>
References: <543762723@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: devzero@web.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <543762723@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

While I agree that the command you send should be possible it wasn't
exactly what I was thinking. Currently I am working on a way for the
user to individually set which files/directories they want compressed or
not. What I was saying is that assuming you are in a mounted btrfs
directory you could do something like

chattr -R +c zlib dir1	Compress dir1 and all its contents with zlib
chattr -R +c bzip dir2	Compress dir2 and all its contents with bzip
chattr +c lzo file1	Compress fil1 with lzo
chattr -c file2		Uncompress file2
chattr +c none dir3	Uncompress dir3 but leave contents as is

If the user did something like 
mount -o compress,cscheme=zlib /dev/xyz /mntpoint
and then
chattr +c /mntpoint/dir
/mntpoint/dir would default to zlib as would anything else written to
the disk.

Lee

On Tue, Dec 16, 2008 at 12:19:13AM +0100, devzero@web.de wrote:
> > If multiple compression schemes are implemented how should the user go
> > about choosing which one they want? Should it be done at kernel time? Or
> > with the userland tools on a per file basis(maybe zlib is the default
> > but a user could say I want this directory to be bzip)?
> 
> yes, why not...
> 
> doing that at mounttime like
> 
> mount -o compress,cscheme=myzip /dev/xyz /mntpoint
> 
> would be a good start....
> 
> 
> 
> > -----Urspr?ngliche Nachricht-----
> > Von: "Lee Trager" <lt73@cs.drexel.edu>
> > Gesendet: 16.12.08 00:07:32
> > An: devzero@web.de
> > CC: linux-btrfs@vger.kernel.org
> > Betreff: Re: Compressed Filesystem
> 
> 
> > If multiple compression schemes are implemented how should the user go
> > about choosing which one they want? Should it be done at kernel time? Or
> > with the userland tools on a per file basis(maybe zlib is the default
> > but a user could say I want this directory to be bzip)?
> > 
> > On Mon, Dec 15, 2008 at 11:14:01PM +0100, devzero@web.de wrote:
> > > fantastic feature!
> > > 
> > > i`m curious: can btrfs support more than one compression scheme at the same time, i.e. is compression "pluggable" ?
> > If you look at compression.c, compression.h, and ctree.h you can clearly
> > see that support for multiple compression scheme was in mind. Implmented
> > a new one shouldn't be to hard but you probably want to make the current
> > system a little bit more pluggable and move all the zlib stuff into
> > zlib.c.
> > > 
> > > lzo compression coming to my mind, as this is giving real-time compession and may even speed up disk access.
> > > 
> > > compression ratio isn`t too bad, but speed is awesome and doesn`t need as much cpu as gzip.
> > > 
> > In some tests I've run zlib is actually faster then nocompression
> > because of the lesser amount of data that has to transfer to and from
> > the disk. It would be instresting to see how bzip works with this to.
> > > experimental lzo compression in zfs-fuse showed that it could compress tarred kernel-source with 2.99x compressratio (where gzip gave 3.41x), so maybe lzo is a better algorithm for realtime filesystem compression...
> > > 
> > > regards
> > > roland
> > > 
> > > 
> > > 
> > > From: Chris Mason <chris.mason <at> oracle.com>
> > > Subject: Re: Compressed Filesystem
> > > Newsgroups: gmane.comp.file-systems.btrfs
> > > Date: 2008-10-29 20:08:42 GMT (6 weeks, 5 days, 1 hour and 53 minutes ago)
> > > 
> > > On Wed, 2008-10-29 at 12:14 -0600, Anthony Roberts wrote:
> > > > Hi, I have a few questions about this:
> > > > 
> > > > > Compression is optional and off by default (mount -o compress to enable
> > > > > it).  When enabled, every file is compressed.
> > > > 
> > > > Do you know what the CPU load is like with this enabled?
> > > 
> > > Now that I've finally pushed the code out, you can try it ;)  One part
> > > of the implementation I need to revisit is the place in the code where I
> > > do compression means that most of the time the single threaded pdflush
> > > is the one compressing.
> > > 
> > > This doesn't spread the load very well across the cpus.  It can be
> > > fixed, but I wanted to get the code out there.
> > > 
> > > The decompression does spread across cpus, and I've gotten about 800MB/s
> > > doing decompress and checksumming on a zero filled compressed file.  At
> > > the time, the disk was reading 14MB/s.
> > > 
> > > > 
> > > > Do you know whether data can be compressed at a sufficient rate to still
> > > > saturate the disk on recent-ish AMD/Intel CPUs?
> > > 
> > > My recentish intel cpu can compress and checksum at about 120MB/s.  
> > > > 
> > > > If no, is the effective pre-compression I/O rate still comparable to the
> > > > disk without compression?
> > > > 
> > > 
> > > It depends on your disks...
> > > 
> > > > I'm pretty sure that won't even matter in many cases (eg you're seeking
> > > > too much to care, or you're on a VM with lots of cores but congested
> > > > disks, or you're dealing with media files that it doesn't bother
> > > > compressing, etc), but I'm curious what sort of overhead this adds. :)
> > > > 
> > > > Mostly it seems like a good tradeoff, it trades plentiful cores for scarce
> > > > disk resources.
> > > 
> > > This varies quite a bit from workload to workload, in some places it'll
> > > make a big difference, but many workloads are seek bound and not
> > > bandwidth bound.
> > > 
> > > -chris
> > > 
> > > 
> > > ____________________________________________________________________
> > > Psssst! Schon vom neuen WEB.DE MultiMessenger geh?rt? 
> > > Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3123
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> _______________________________________________________________________
> Sensationsangebot verl?ngert: WEB.DE FreeDSL - Telefonanschluss + DSL
> f?r nur 16,37 Euro/mtl.!* http://dsl.web.de/?ac=OM.AD.AD008K15039B7069a
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
