Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48809 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbaAAMiI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jan 2014 07:38:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VyL3m-0005eQ-7I
	for linux-btrfs@vger.kernel.org; Wed, 01 Jan 2014 13:38:06 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 13:38:06 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 13:38:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Wed, 1 Jan 2014 12:37:42 +0000 (UTC)
Message-ID: <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
References: <52C2AE7C.5020601@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sulla posted on Tue, 31 Dec 2013 12:46:04 +0100 as excerpted:

> On my Ubuntu Server 13.10 I use a RAID5 blockdevice consisting of 3
> WD20EARS drives. On this I built a LVM and in this LVM I use quite
> normal partitions /, /home, SWAP (/boot resides on a RAID1.) and also a
> custom /data partition. Everything (except boot and swap) is on btrfs.
> 
> sometimes my system hangs for quite some time (top is showing a high
> wait percentage), then runs on normally. I get kernel messages into
> /var/log/sylsog, see below. I am unable to make any sense of the kernel
> messages, there is no reference to the filesystem or drive affected (at
> least I can not find one).
> 
> Question: What is happening here?
> * Is a HDD failing (smart looks good, however)
> * Is something wrong with my btrfs-filesystem? with which one?
> * How can I find the cause?
> 
> Dec 31 12:27:49 freedom kernel: [ 4681.264112] INFO: task
> btrfs-transacti:529 blocked for more than 120 seconds.
> 
> Dec 31 12:27:49 freedom kernel: [ 4681.264239] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.

First to put your mind at rest, no, it's unlikely that your hardware is 
failing; and it's not an indication of a filesystem bug either.  Rather, 
it's a characteristic of btrfs behavior in certain corner-cases, and yes, 
you /can/ do something about it with some relatively minor btrfs 
configuration adjustments... altho on spinning rust at multi-terabyte 
sizes, those otherwise minor adjustments might take some time (hours)!

There seem to be two primary btrfs triggers for these "blocked for more 
than N seconds" messages.  One is COW-related (COW=copy-on-write, the 
basis of BTRFS) fragmentation, the other is many-hardlink related.  The 
only scenario-trigger I've seen for the many-hardlink case, however, has 
been when people are using a hardlink-based backup scheme, which you 
don't mention, so I'd guess it's the COW-related trigger for you.

A bit of background on COW:  (Assuming I get this correct, I don't claim 
to be an expert on it.)  In general, copy-on-write is a data handling 
technique where any modification to the original data is made out-of-line 
from the original, then the extent map (be it memory extent map for in-
memory COW applications, or on-device data extent map for filesystems, 
or...) is modified, replacing the original inline extent index with that 
of the new modification.

The advantage of COW for filesystems, over in-place-modification, is that 
should the system crash at just the right (wrong?) moment, before the 
full record has been written, an in-place-modification may corrupt the 
entire file (or worse yet, the metadata for a whole bunch of files, 
effectively killing them all!), while with COW the update is atomic -- at 
least in theory, it has either been fully written and you get the new 
version, or the remapping hasn't yet occurred and you get the old version 
-- no corrupted case which is if you're lucky, part new and part old, and 
if you're unlucky, has something entirely unrelated and very possibly 
binary in the middle of what might have previously been for example a 
plain-text config file.

However, COW-based filesystems work best when most updates either replace 
the entire file, or append to the end of the file, luckily the most 
common case.  COW's primary down side in filesystem implementations is 
that for use-cases where only a small piece of the file somewhere in the 
middle is modified and saved, then another small piece somewhere else, 
and another and another... repeated tens of thousands of times, each 
small modification and save gets mapped to a new location and the file 
fragments into possibly tens of thousands of extents, each with just the 
content of the individual modification made to the file at that point.

On a spinning rust hard drive, the time necessary to seek to each of 
those possibly tens of thousands of extents in ordered to read the file, 
as compared to the cost of simply reading the same data were it stored 
sequentially in a straight line, is... non-trivial to say the least!

It's exactly that fragmentation and the delays caused by all the seeks to 
read an affected file, that result in the stalls and system hangs you are 
seeing.

OK, so now that we know what causes it, what files are affected, and what 
can you do to help the situation?

Fortunately, COW-fragmentation isn't a situation that dramatically 
impacts operations on most files, as obviously if it was, it'd be 
unsuited for filesystem use at all.  But it does have a dramatic effect 
in some cases -- the ones I've seen people report on this list are listed 
below:

1) Installation.

Apparently the way some distribution installation scripts work results in 
even a brand new installation being highly fragmented. =:^(  If in 
addition they don't add autodefrag to the mount options used when 
mounting the filesystem for the original installation, the problem is 
made even worse, since the autodefrag mount option is designed to help 
catch some of this sort of issue, and schedule the affected files for 
auto-defrag by a separate thread.

The fix here is to run a manual btrfs filesystem defrag -r on the 
filesystem immediately after installation completes, and to add 
autodefrag to the mount options used for the filesystem from then on, to 
keep updates and routine operation from triggering new fragmentation.

(It's possible to do the same with just the autodefrag option over time, 
but depending on how fragmented the filesystem was to begin with, some 
people report that this makes the problem worse for awhile, and the 
system unusable, until the autodefrag mechanism has caught up to the 
existing problem.  Autodefrag works best to /keep/ an already in good 
shape filesystem in good shape; it's not so good at getting one that's 
highly fragmented back into good shape.  That's what btrfs filesystem 
defrag -r is for. =:^)

2) Pre-allocated files.

Systemd's journal file is probably the most common single case here, but 
it's not the only case, and AFAIK ubuntu doesn't use systemd anyway, so 
that's highly unlikely to be your problem.

A less widespread case that's never-the-less common enough is bittorrent 
clients that preallocate files at their final size before the download, 
then write into them as the torrent chunks are downloaded.  BAD situation 
for COW filesystems including btrfs, since now the entire file is one 
relocated chunk after another.  If the file's a multi-gig DVD image or 
the like, as mentioned above, that can be tens of thousands of extents!  
This situation is *KNOWN* to cause N-second block reports and system 
stalls of the nature you're reporting, but of course only triggers for 
those running such bittorrent clients.

One potential fix if your bittorrent client has the option, is to turn 
preallocation off.  However, it's there for a couple reasons -- on normal 
non-COW filesystems it has exactly the opposite effect, ensuring a file 
stays sequentially mapped, AND, by preallocating the file, it's easier to 
ensure that there's space available for the entire thing.  (Altho if 
you're using btrfs' compression option and it compresses the allocation, 
more space will still be used as the actual data downloads and the file 
is filled in, as that won't compress as well.)

Additionally, there's other cases of pre-allocated files.  For these and 
for bittorrent if you don't want to or can't turn pre-allocation off, 
there's the NOCOW file attribute.  See below for that.

3) Virtual machine images.

Virtual machine images tend to be rather large, often several gig, and to 
trigger internal-image writes every time the configuration changes or 
something is saved to the virtual disk in the image.  Again, a big worst-
case for COW-based filesystems such as btrfs, as those internal image-
writes are precisely the sort of behavior that triggers image file 
fragmentation.

For these, the NOCOW option is the best.  Again, see below.

4) Database files.

Same COW-based-filesystem-worst-case behavior pattern here.

The autodefrag mount option was actually designed to help deal with this 
case, however, for small databases (typically the small sqlite databases 
used in firefox and thunderbird, for instance).  It'll detect the 
fragmentation and rewrite the entire file as a single extent.  Of course 
that works well for reasonably small databases, but won't work so well 
for multi-gig databases, or multi-gig VMs or torrent images for that 
matter, since the write magnification would be very large (rewriting a 
whole multi-gig image for every change of a few bytes).  Which is where 
the NOCOW file attribute comes in...


Solutions beyond btrfs filesystem defrag -r, and the autodefrag mount 
option:

The nodatacow mount option.

At the filesystem level, btrfs has the nodatacow mount option.  For use-
cases where there's several files of the same problematic type, say a 
bunch of VM images, or a bunch of torrent files downloading to the same 
target subdir or subdirectory tree, or a bunch of database files all in 
the same directory subtree, creating a dedicated filesystem which can be 
mounted with the nodatacow option can make sense.

At some point in the future, btrfs is supposed to support different mount 
options per subvolume, and at that point, a simple subvolume mounted with 
nodatacow but still located on a main system volume mounted without it, 
might make sense, but at this point, differing subvolume mount options 
aren't available, so to use this solution, you have to create a fully 
separate btrfs filesystem to use the nodatacow option on.

But nodatacow also disables some of the other features of btrfs, such as 
checksumming and compression.  While those don't work so well with COW-
averse use-cases anyway (for some of the same reasons COW doesn't work on 
them), once you get rid of them on a global filesystem level, you're 
almost back to the level of a normal filesystem, and might as well use 
one.  So in that case, rather than a dedicated btrfs mounted with 
nodatacow, I'd suggest a dedicated ext4 or reiserfs or xfs or whatever 
filesystem instead, particularly since btrfs is still under development, 
while these other filesystems have been mature and stable for years.

The NOCOW file attribute.

Simple command form:

chattr +C /path/to/file/or/directory

*CAVEAT!  This attribute should be set on new/empty files before they 
have any content.  The easiest way to do that is to set the attribute on 
the parent directory, after which all new files created in it will 
inherit the attribute.  (Alternatively, touch the file to create it 
empty, do the chattr, then append data into it using cat source >> target 
or the like.)

Meanwhile, if there's a point at which the file exists in its more or 
less permanent form and won't be written into any longer (a torrented 
file is fully downloaded, or a VM image is backed up), sequentially 
copying it elsewhere (possibly using cp --reflink=never if on the same 
filesystem, to avoid a reflink copy pointing at the same fragmented 
extents!), then deleting the original fragmented version, should 
effectively defragment the file too.  And since it's not being written 
into any more at that point, it should stay defragmented.

Or just btrfs filesystem defrag the individual file...


Finally, there's some more work going into autodefrag now, to hopefully 
increase its performance, and make it work more efficiently on a bit 
larger files as well.  The goal is to eliminate the problems with 
systemd's journal, among other things, now that it's known to be a common 
problem, given systemd's widespread use and the fact that both systemd 
and btrfs aim to be the accepted general Linux default within a few years.


Summary:

Figure out what applications on your system have the "internal write" 
pattern that causes so much trouble to COW-based filesystems, and turn 
off that behavior either in that app (as possible with torrent clients), 
or in the filesystem, using either a dedicated filesystem mount, or more 
likely, by setting the NOCOW attribute (chattr +C) on the individual 
target files or directories.

Figuring out which files and applications are affected is left to the 
reader, but the information above should provide a good starting point.

Then btrfs filesystem defrag -r the filesystem and add autodefrag to its 
mount options to help keep it free of at least smaller-file fragmentation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

