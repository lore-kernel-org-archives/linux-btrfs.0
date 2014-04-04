Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52247 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaDDUbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 16:31:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WWAm4-00038Q-TE
	for linux-btrfs@vger.kernel.org; Fri, 04 Apr 2014 22:31:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 22:31:40 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 22:31:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Fri, 4 Apr 2014 20:31:25 +0000 (UTC)
Message-ID: <pan$24330$c9f1bcdd$7db9345d$b2b93067@cox.net>
References: <2692878.dRG1K49eOP@fnix> <533EA686.5030909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Fri, 04 Apr 2014 08:33:10 -0400 as
excerpted:

> On 2014-04-04 04:02, Swâmi Petaramesh wrote:
>> Hi,
>> 
>> I'm going to receive a new small laptop with a 500 GB 5400 RPM
>> mechanical "ole' rust"  HD, and I plan ton install BTRFS on it.

Reminds me of my query to the list, some months ago.  (Altho I was/am 
using dual 238 GiB SSDs, in btrfs raid1 mode both data and metadata, in a 
desktop, additionally with a 500 gig spinning rust drive for media that 
is still running reiserfs, so the details are somewhat different.)

>> It will have a kernel 3.13 for now, until 3.14 gets released.

$ uname -r
3.14.0

=:^)

But it's good you (SP) keep reasonably current.  I see people posting 
with old 2.6.* kernels and wonder why they're even bothering with btrfs, 
since they obviously aren't current, kernel-wise.

>> However I'm still concerned with chronic BTRFS dreadful performance and
>> still find that BRTFS degrades much over time even with periodic defrag
>> and "best practices" etc.

> I keep hearing this from people, but i personally don't see this to be
> the case at all.  I'm pretty sure the 'big' performance degradation that
> people are seeing is due to how they are using snapshots, not a result
> using BTRFS itself (I don't use them for anything other than ensuring a
> stable system image for rsync and/or tar based backups).

I'll second what you (AH) and Hugo say elsewhere, and I've written some 
on the subject in other threads too.  Snapshots per se aren't bad, but 
there's really no reason to have thousands of them against the same base 
subvolume -- in practice, if you need to mount a snapshot a month or six 
old, are you really going to know or care what exact minute to mount?

While I /personally/ think per-minute snapshots are overdoing it, per 
hour or so is definitely logically supportable and if you /want/ per-
minute, well, fine.  But per-minute or per-hour or per-day, or just 
taking an occasional manual snapshot, /do/ strongly consider thinning 
them out on a reasonable schedule, and the more frequently you take 'em 
the more you need to thin.  So if for example you're taking per-minute, 
thin them down to perhaps one per half-hour after six hours and one per 
hour after a day, then to one a day after a week and one a week after 
four weeks.  At some point between a month and a quarter, external 
backups should have taken over, and deleting older snapshots or only 
keeping perhaps one every 13 weeks (quarter) should suffice.

Meanwhile, as Hugo hints there are still known issues with snapshots and 
large (half-gig-plus) frequently internally rewritten files such as VM 
images, databases, etc, even if set NOCOW.  If you're running something 
like this, strongly consider putting those files on a dedicated subvolume 
and using conventional backups instead of snapshotting for that 
subvolume.  (And set NOCOW using the directory inheritance mechanism 
described in other posts.)

For smaller stuff the autodefrag option should help.


>> So I'd like to start with the best possible options and have a few
>> questions :
>> 
>> - Is it still recommended to mkfs with a nodesize or leafsize different
>> (bigger) than the default ? I wouldn't like to lose too much disk space
>> anyway (1/2 nodesize per file on average ?), as it will be limited...

> This depends on many things, the average size of the files on the disk
> is the biggest factor.  In general you should get the best disk
> utilization [snip]

As Hugo says, btrfs' current nodesize settings, etc, apply to metadata, 
not data, which is currently the standard 4K page-size on x86.  Metadata 
nodesize now defaults to 16K with newer mkfs.btrfs, which should be 
reasonable.  (There's work to make the data-block size configurable as 
well, in part because it's currently not possible to mount btrfs created 
on architectures with different page sizes, tho luckily both arm and x86/
amd64 have 4k page sizes so are compatible.)

>> - Is it recommended to alter the FS to have "skinny extents" ? I've
>> done this on all of my BTRFS machines without problem, still the kernel
>> spits a notice at mount time, and I'm worrying kind of "Why is the
>> kernel warning me I have skinny extents ? Is it bad ? Is it something I
>> should avoid ?"

> I think that the primary reason for the warning is that it is backward
> incompatible, older kernels can't mount filesystems using it.

Agreed.  When skinny extents first came out there were some initial bugs, 
but I believe they've been worked out by now in general, so it shouldn't 
be a problem.  The big remaining issue is backward compatibility.

Tho at least here (where I've been running 3.14 pre-releases since before 
rc1), the on-mount skinny-extents comment seems more informational than 
actual warning.

That said, more conservative users might wish to stay with "fat" extents, 
since AFAIK that's still the default, so it's going to get the most 
testing.  FWIW, when I last re-did my partitions in ordered to take 
advantage of the 16k metadata node-sizes, etc (late kernel 3.13 cycle I 
think), I kept fat extents on root and home, but went with skinny extents 
on my packages partition.  I've seen no issues with it in my usage, and 
will probably go all skinny-extent the next time I redo my partitions.

>> - Are there other optimization tricks I should perform at mkfs time
>> because thay can't be changed later on ?

I used -O extref on all my partitions here, when I redid them.  That's 
probably a good idea.

The -m (mixed data/metadata) thing is interesting.  You probably don't 
want to do it on a 500 gig unless you partition up (tho some do for the 
dup mode benefit mentioned below), and it's the default on really small 
(gig and smaller) partitions, but some people use it on filesystems up to 
128 gig or so for a couple reasons.

Mixed mode does help avoid the issue of having to run a balance if data 
(typical) or metadata chunk allocations end up using all available space, 
since to the present, btrfs can automatically allocate new chunks of one 
or the other if there's unallocated chunks available, but can't 
reallocate empty chunks from one to the other if necessary, without a 
rebalance.  Mixed mode eliminates having to do a manual rebalance to 
return chunks to the unallocated pool so they can be used for the other 
type, since all chunks can then be used for data and metadata, both.  But 
it DOES have a bit of a performance impact.

The other and arguably more interesting feature of mixed mode for single 
device filesystems is that it allows and in fact defaults to dup profile 
mode for the now mixed data/metadata chunks, inheriting that default (as 
well as the 256 MiB chunk size) from the metadata side.  Since unlike 
metadata, data chunks are otherwise limited to single profile mode, mixed-
mode is the only way (other than creating two partitions on the same 
hardware device and running btrfs raid1 on that, but that's less 
efficient, particularly on spinning rust) to fully apply btrfs data 
integrity benefits to data chunks on a single device.  Normally, in case 
of corruption btrfs scrub on a single device filesystem can only recover 
metadata, since those are the only chunks in dup mode.  But with mixed-
mode, data and metadata share the same chunks and thus can both be dup, 
thus allowing data to be recovered from the other copy if one copy goes 
bad, as well as metadata.

To someone like me where a big reason for using btrfs at all is the data 
integrity aspect, thus my running two SSDs configured in btrfs raid1 mode 
for most partitions, if I were limited to a single hardware device (as I 
will be for my netbook, tho I've not actually converted it to btrfs yet), 
I may well consider mixed-mode, for the benefit of dup-mode data as well 
as metadata, alone!

Tho of course that does effectively limit you to half capacity, since all 
data and metadata is duplicated.  And on spinning rust it's going to be a 
performance issue, tho it should be less of one doing it that way than it 
would be forcing it with two identical partitions on the same hardware 
disk and setting btrfs up in raid1 mode.

But if you /do/ use mixed-mode, as I implied above, you may wish to break 
up that 500 gig into multiple 128 gig or so partitions, each with its own 
btrfs, as I believe your performance cost will be lower that way, than 
they'd be with a single 500 gig mixed-mode single-device btrfs.  But do 
remember when you'r setting up the partitions that dup mode does mean 
they get full with half the stuff they'd normally hold, and size the 
partitions accordingly!

>> - Are there other btrfstune or mount options I should pass before
>> starting to populate the FS with a system and data ?
> Unless you are using stuff like QEMU or Virtualbox, you should probably
> have autodefrag and space_cache on from the very start.

Agreed in general.  However, my experience is that space_cache is now the 
default, so you don't have to set that explicitly.

As for autodefrag, definitely strongly recommended, /except/ as mentioned 
for large (half-gig or larger) frequent-internal-rewrite files such as VM 
images and databases.  For large internal-write files I'd recommend 
putting them on their own dedicated subvolume (or fully separate 
partition) to avoid snapshotting, and setting up NOCOW for the affected 
directories.  (At some point individual subvolumes will be mountable with 
different options and the entire dedicated subvolume could then be 
mounted with nodatacow.  But AFAIK, that doesn't work yet and the 
nodatacow would apply to all subvolumes on that filesystem, not a good 
idea.  So for now, NOCOW at the directory and file level and dedicated 
subvolume only to prevent snapshotting the NOCOW files, will have to do.)

Also noatime.  That's not btrfs specific, but especially if you're doing 
snapshots it has stronger implications on btrfs than other filesystems.  
Consider, if there hasn't been a whole lot of write activity between 
snapshots, atime updates can be a big part of the difference between one 
snapshot and the last, thus making snapshots far less space efficient 
than they might otherwise be.  So while noatime is always a good option 
to enable unless you're running something (like mutt) that really needs 
them, it's REALLY a good option to enable on btrfs if you're doing 
snapshotting at all.

>> - Generally speaking, does LZO compression improve or degrade
>> performance ? I'm not able to figure it out clearly.

> As long as your memory bandwidth is significantly higher than disk
> bandwidth (which is almost always the case, even with SSD's), this
> should provide at least some improvement with respect to IO involving
> large files.  Because you are using a traditional hard disk instead of
> an SSD, you might get better performance using zlib (assuming you don't
> mind slightly higer processor usage for IO to files larger than the
> leafsize).  If you care less about disk utilization than you do about
> performance, you might want to use compress_force instead of compress,
> as the performance boost comes from not having to write as much data to
> disk.

Agreed.  I'm using compress=lzo here, even on ssd.  I'd probably use zlib 
on spinning rust, and would then experiment with compress-force as well.

The other thing about compress, on a standard single-device filesystem 
with default dup metadata and default single data, is that when I tried 
it here at least (before I got the ssds and went raid1 mode), compress=lzo 
rather nicely offset (and then some, for my use-case) the extra space 
required by the duplicate metadata.

Come to think of it, depending on the compressibility of your data, 
compress=zlib (or possibly compress-force=zlib) might offset much of the 
duplicate space required for mixed-mode dup as well, thereby making it 
more practical.  Since on spinning rust the compression is also likely to 
offset to some degree the slowness of the spinning rust, that might be 
quite a reasonable tradeoff (tho write speeds would still likely be 
noticeably slower than single-data mode due to having to write out both 
copies).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

