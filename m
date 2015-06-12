Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40277 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbbFLHyB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 03:54:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z3Jmp-00070w-VY
	for linux-btrfs@vger.kernel.org; Fri, 12 Jun 2015 09:54:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 09:53:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 09:53:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
Date: Fri, 12 Jun 2015 07:53:54 +0000 (UTC)
Message-ID: <pan$149c0$3c5d3f6$273a6c46$8d732b9c@cox.net>
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Thu, 11 Jun 2015 20:33:41 +0900 as excerpted:

> I have a server where I've installed a couple of LXC guests, btrfs - so
> easy to test things with snapshots. Or so it seems.
> 
> Unfortunately the box crashes when I put "too much IO load" - with too
> much load being these two running at the same time:
> 
> - quite busy MySQL database (doing up to 100% IO wait when running
> alone)
> - busy mongo database (doing up to 100% IO wait when running alone)
> 
> With both mongo and mysql running at the same time, it crashes after 1-2
> days (tried kernels 4.0.4, 4.0.5, 4.1-rc7 from Ubuntu "kernel-ppa"). It
> does not crash if I only run mongo, or only mysql. There is plenty of
> memory available (just around 2-4 GB used out of 32 GB) when it crashes.

Disclaimer: I'm not a dev, just a list regular and general btrfs using 
(not database) sysadmin.  So no code fixes and nothing too low-level 
technical here, just some btrfs observations based on what I've seen on 
the wiki and the list.

First some filesystem technology basics...

Traditional filesystems such as ext* are modify-in-place.  These are 
generally the filesystems upon which databases have been developed, and 
modify-in-place behavior is what they've been optimized for.  Make a 
change to some data in the middle of a file, write it out, and generally, 
just the affected blocks are rewritten, back to the same place on the 
device where those blocks were before.  The database file remains exactly 
as fragmented (or not) as it was before, because modifications are 
rewritten in-place.

Btrfs is, by contrast, COW (copy-on-write) based.  One of the weak points 
of cow-based filesystems in general, btrfs being no exception, is the 
processing pattern typified by large database and VM image files, that 
is, modifications written to the middle of rather large files, because 
copy-on-write then forces (at least) the modified blocks of the file to 
be (re)written elsewhere, NOT back to where they were, thereby triggering 
massive fragmentation as more and more blocks are modified and written 
somewhere else, while unchanged blocks stay where they were.

Obviously the biggest problem with fragmentation is on spinning rust, 
where fragmentation can easily slow down thruput by an order of magnitute, 
but in extreme, as could well be triggered by modify operations on large 
database files on a COW-based filesystem, it negatively affects SSD based 
filesystems, as well, both due to the additional complexity of the extent 
tracking the filesystem must do, and due to the the forced breakup of 
what would be a handful of large IO operations into possibly tens or 
hundreds of thousands of small ones.

So btrfs, being cow-based, isn't generally going to be an ideal 
filesystem host for databases.  It's just the nature of cow-based 
filesystems.  OTOH, some of the other features of btrfs (including some 
depending on that COW nature, including snapshots) make it an attractive 
host, if this problem can be mitigated to a large degree, and, in fact, 
it can, tho those mitigations come with their own limitations.

What can be done about it and what are the tradeoffs?

Btrfs' most straightforward solution to the problem, provided the files 
aren't /too/ large, is the autodefrag mount option.  When this is 
enabled, btrfs watches for fragmentation, and when it's found, queues up 
those files for defrag by a separate defrag worker thread.

This tends to work quite well for the normal desktop scenario, with for 
instance firefox's sqlite files of perhaps a couple hundred megabytes.  
The limitation to this solution, however, is that defrag rewrites the 
entire file.  As file sizes and modify-write transaction counts increase, 
it's not long before the transactions are coming in faster than the file 
can be rewritten. =:^(  On-list comments suggests that file sizes under 
say half a gig aren't generally a problem, while those over 1 gig do tend 
to be an issue, at least on legacy spinning rust.  The area between half 
a gig and a gig is a gray area, where it depends on the speed of your 
hardware and how many modify-writes are actually coming in.

(FWIW, as I don't deal with really large database/vm-image type files, 
autodefrag works great for me here.  From mkfs.btrfs, I never mount a 
btrfs without it, so fragmentation never becomes an issue as all files 
are defragged as they are copied to or created on the btrfs.)

But what then of large internal-modify-and-rewrite pattern files?

Above that half-gig to a gig autodefrag cutoff, the problem gets rather 
more complex.  The most direct solution at that point is the NOCOW file 
attribute, but its limitations are more severe, affecting btrfs' 
snapshotting feature (or rather, snapshotting affecting nocow), the 
reason that btrfs may have been chosen in the first place.  There are 
workarounds for that too, but they are definitely more complex than 
simply setting autodefrag (or nocow in this case) and forgetting about it 
is.

First off, setting nocow.  This is nominally accomplished with the chattr 
tool, chattr +C <file>.  However, on btrfs, just setting that attribute 
on an existing non-zero-length file isn't enough.  The attribute needs to 
be set before the file has content.  Normally, this is accomplished by 
setting nocow on the directory that the target file will be in, at which 
point any newly created files (and subdirs) will automatically inherit 
the nocow attribute of their parent directory.  (Setting nocow on a 
directory has no effect on the directory itself, it's simply inherited by 
files and subdirs newly created within it.)  For existing files, the 
recommended technique is to move them out of the directory, set the 
attribute on the dir, and then *copy* the existing files back in, in such 
a way that the new copy gets the attribute set before it actually has 
content.  There are two ways to ensure this: 1) copy across a filesystem 
boundary (btrfs subvolume isn't enough); 2) cat the file into place using 
redirection: cat existing.file > new.file.  (Normal copy will in most 
cases /currently/ work as well, as long as it's not a reflink copy that 
simply creates a new reflink pointing at the old location, or a move, 
which on the same filesystem, will simply create a new hardlink and 
delete the old one, without actually moving the data.  However, in the 
interest of efficiency and non-duplication, newer implementations might 
use reflinks where possible, defeating the purpose in this case, so the 
cross-filesystem or cat methods are recommended as they ensure that a new 
file is actually created, so it can inherit the nocow attribute from its 
parent dir at create, before it has any content.)

What does nocow do?

Nocow on a btrfs file, provided it was set correctly as described above, 
has three effects on btrfs.  First, it tells btrfs not to copy-on-write, 
but rather, to update-in-place.  In ordered to do that effectively, 
however, it has two additional effects.  It turns off any btrfs 
compression for the file (compression is typically set with a mount 
option), and it turns off btrfs checksumming for that file.  Both of 
these dramatically lower the complexity of rewriting the file in-place, 
where they'd otherwise create all sorts of complications that simply 
aren't a problem with btrfs' normal copy-on-write.

Now people often read turning off checksumming and get alarmed, but the 
fact of the matter is that both VMs and databases already have their own 
internal checksumming and error correction or coping mechanisms, as they 
must on ordinary filesystems, where filesystem level checksumming and 
error detection/correction simply isn't available, or they'd be 
/constantly/ running into problems.  Trying to have both btrfs and the VM/
DB track and correct errors isn't particularly efficient in any case, and 
since the VM/DB already does it, turning off that feature for the VM/DB 
files in btrfs, really isn't such a bad thing after all.

Much more potentially significant, however, is how nocow interacts with 
btrfs snapshots, which /depend/ on btrfs cow nature, because what a 
snapshot actually does, is lock in place the current copy and put a 
snapshot reference on it, so that snapshotted copy can still be accessed 
via the snapshot, even after the file has changed (which, due to cow, 
writes the changes to a different location).

But if nocow means update-in-place, and snapshotting locks the current 
copy in place, how does btrfs handle modification-writes to a snapshotted 
file?  Simple enough, snapshots are an exception to nocow.  After a 
snapshot, the first modification-write to a file block does copy that 
block elsewhere, because the existing version is locked in place by the 
snapshot and thus cannot be modified.  However, the file retains its nocow 
attribute, and any further writes to the same file block will overwrite 
the same block at its new location, instead of cowing it to a third and 
forth and ... location, each time the block is modified and written.  
This continues until such time as another snapshot locks the /new/ 
location in place, at which point the first write to that block after 
that will again cow it to a new location.  Thus, btrfs snapshots 
effectively turn nocow into cow1, copy-on-write-once-only.

OK, so cow1 does limit the damage, as long as snapshots aren't too 
frequent.  Some people go crazy, however, and set scripted snapshotting 
to occur as often as once per minute(!).  Obviously, these folks might as 
well not bother with nocow, because those cow1s will be happening once a 
minute anyway, and fragmentation will end up nearly as bad as if they'd 
not set nocow at all. =:^(

OK, so how then to mitigate the cow1 interaction issue of snapshots and 
nocow?

Beginning to see why I said this is much more complex than simply setting 
autodefrag, yet? =8^P

The first thing to (re)consider when attempting to combat the cow1 
problem, is thus how often you /really/ need to snapshot those 
(otherwise) nocow files.

The second thing to realize, and this helps with the first, is that 
snapshots stop at subvolume boundaries.

The first mitigation, then, is to put these nocow files in their own 
subvolume, so snapshotting the parent subvolume doesn't snapshot the nocow 
files as well, and parent subvolume snapshotting can continue on whatever 
schedule you want, without affecting these files.

But, there's a good chance you want to snapshot the nocow files at least 
/sometimes/.  Suppose you'd otherwise snapshot them once a day.  Perhaps 
you can cut down to snapshotting them once or twice a week, or at least 
halve it to every other day instead of every day.  That will already 
reduce the cow1 effect substantially, depending on how seldom you believe 
you can get away with snapshotting, while still staying within tolerable 
bounds in terms of backups, etc.

But still, over time, the database files will fragment.  However, on-list 
we've had a number of reports that a regularly scheduled btrfs defrag of 
the target files, combined with as minimal a snapshotting program as can 
be tolerated, keeps both fragmentation and thus performance, and 
snapshotting for backups, within tolerable limits.

Thus, the recommended approach for people with database or vm-image files 
too large and too busy for autodefrag, who still want/need snapshotting 
and via snapshotting, atomic backups on those files, is:

1) Create a dedicated database/vm-image subvolume so you can control 
snapshotting on it specifically.

2) Set the nocow attribute on the subvolume (here behaving as a 
directory).

3) Copy existing database/vm-image files into this subvolume using a 
method that ensures they inherit the nocow attribute appropriately.

4) Setup scheduled snapshotting of this subvolume at as minimal a 
frequency as you find tolerable, preferably no more than every other day, 
and if at all possible, no more than once a day.

5) Setup scheduled recursive btrfs defrag of this subvolume, at a 
suggested frequency of weekly to monthly.


Also note that btrfs filesystem maintenance (balance, check, etc) doesn't 
scale so well once a filesystem gets into the thousands to tens of 
thousands of snapshots range.  So this tip applies more to regularly 
scheduled snapshots than it does to nocow:

* If you regularly schedule snapshots, be sure to schedule regular 
snapshot deletion/thinning as well.  Try to keep each subvolume to 
200-300 snapshots (even half-hourly snapshots can be capped to well under 
300 with regular thinning, say to hourly after six hours, six-hourly 
after 3 days, daily after a week, etc), keeping in mind the number of 
subvolumes you have that are snapshotted separately, so ideally, the 
total number of snapshots per filesystem never exceeds 2000 (at 250 per 
subvolume, that's 8 subvolumes' worth) or so.  If you have lots of 
subvolumes, 3000 or so won't be too bad, but do try to keep it below 
5000, because as the number of snapshots on the filesystem approaches and 
passes 10K, maintenance scaling really doesn't fair well at all, and 
reports from people with 100K and above snapshots say it gets practically 
unworkable, even with 64 gig and higher RAM.  If you have /that/ many 
subvolumes, perhaps it's time to consider splitting the overall 
filesystem up into multiple separate btrfs, as maintenance on multi-TB 
size filesystems starts getting into the days count, even without 
snapshot scaling issues, and that's just too long to really be practical.


OK, now that that's all dealt with, back to your more immediate problem.  
I suspect that your current databases are **HEAVILY** fragmented, we've 
had people report filefrag extent counts well over 100K, and as you 
didn't mention SSD, I expect you're on spinning rust, and that heavy 
fragmentation is killing performance and heavily stressing btrfs, very 
possibly triggering those kernel crashes in the process, particularly 
since you said either one of the two would go 100% iowait on its own.

Of course, that's no excuse /for/ those kernel crashes, but it's 
certainly not going to help.  Perhaps some day btrfs will be resilient 
enough to deal with such things without crashing, but as you see, it's 
not there yet.

So I'd strongly suggest reconfiguring using the general guidelines/
recommendations above, and see if that doesn't help with both 
performance, and with a bit of luck, kernel crashes, both.

Your disks and kernel btrfs subsystem will thank you for it. =:^)  I can 
imagine the stress you're putting them under with the current setup, and 
it's not a pretty picture! =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

