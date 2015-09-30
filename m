Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44542 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbbI3Gdo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 02:33:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZhAxQ-0000mW-Q7
	for linux-btrfs@vger.kernel.org; Wed, 30 Sep 2015 08:33:40 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 08:33:40 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 08:33:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lots of snapshots, forcing defragmentation, and figuring out
 which files to defrag or nodatacow
Date: Wed, 30 Sep 2015 06:33:33 +0000 (UTC)
Message-ID: <pan$cb2b2$2828df0b$1c0acc6e$dc1ae5ae@cox.net>
References: <CAHpmPOC643754430B2WX+w_tgQkZKQLYOoUjbfzuo=hObAGj1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Cook posted on Mon, 28 Sep 2015 22:51:05 -0700 as excerpted:

> The context of these three questions is that I'm experiencing occasional
> hangs for several seconds while btrfs-transacti works, and very long
> boot times. General comments welcome. System info at bottom,
> end part of dmesg.log attached.
> 
> Q1:
> 
> I keep a lot of read-only snapshots (> 300 total) of all of my
> subvolumes and haven't deleted any so far. Is this in itself a problem
> or unanticipated use of btrfs?

Very large numbers of snapshots do slow things down, but ~300 isn't what 
I'd call "very large" -- we're talking thousands to tens of thousands.

My general recommendation is to keep it to ~250ish (under 300) per 
snapshotted subvolume, preferably under 2000 (and if possible 1000) 
total, easy enough to do even with automated frequent snapshotting (on 
the order of an hour apart, initially), as long as an equally automated 
snapshot thinning program is also established.  At ~250 per subvolume, 
1000 is 4 subvolumes worth, 2000 8 subvolumes worth.

A bit over 300, assuming they're all of the same subvolume, is getting a 
bit high, but it shouldn't be causing a lot of trouble yet.  It's just 
time to start thinking about a thinning program.

There's one exception, quotas.  Quotas continue to be an issue on btrfs; 
they're on their third rewrite now and while they believe it will work 
this time, there's still some serious bugs that will take a couple more 
kernels to work out.  And besides not working right, they dramatically 
increase scalability issues.  So my recommendation, unless you're 
directly working with the devs to test, report problems with, and bug-
trace various quota issues, just don't run them on btrfs at this time.  
If you need quotas, use a filesystem where they're mature and work.  If 
you don't, use btrfs without them.

Really.  I've seen at least two confirmed cases posted where people 
running quotas turned them off and their scaling issues disappeared.
So if you have them on, that could well be your problem, right there.

> Q2:
> 
> I have some files that remain heavily fragmented (according to filefrag)
> even after I run btrfs fi defragment. I think this happens because btrfs
> doesn't want to unlink parts of the files from their snapshotted copies.
> Can I tell btrfs to defragment them anyway, and not worry about wasting
> space? And can I make the autodefrag mount option do this?
> 
> For example (not all output shown):
> 
> # filefrag *
> ...
> 
system@1973a03e3af1449ba5dd93362953fd5f-0000000000000001-00051f9377f11af6.journal:
> 553 extents found ...
> 
> # btrfs fi defragment -rf .
> 
> # filefrag *
> ...
> 
system@1973a03e3af1449ba5dd93362953fd5f-0000000000000001-00051f9377f11af6.journal:
> 331 extents found ...

Several points to note, here:

1) Filefrag doesn't understand btrfs compression.

If you don't use btrfs compression, this doesn't apply, but for btrfs 
compressed files, filefrag reports huge numbers of extents -- generally 
one per btrfs compression block (128 KiB), so 8 per MiB, 8192 per GiB of 
(before compression, not like btrfs give you a way to see post-
compression file size anyway) file size.

But unless you run compress-force you won't see it everywhere, because 
btrfs only compresses some files.

2) Btrfs defrag isn't snapshot aware, and will only defrag the files it's 
directly pointed at, using more space as it breaks the reflinks to the 
snapshotted copy.  Around 3.9 snapshot-aware defrag was introduced, but 
it turned out to have *severe* scalability issues, so that was rolled 
back and snapshot-aware defrag was turned off again in, IIRC, 3.12 (thus 
well before what you're running).

So worrying about breaking snapshot reflinks while defragging isn't going 
to be your problem, that, per se, is simply not an issue.

3) What /can/ be an issue is dealt with using defrag's -t parameter.  I 
don't remember what the default target extent size is, but it's somewhat 
smaller than you might expect, well under a gig.  Extent sizes larger 
than this are considered to be already defragged and aren't touched.  
(While this does touch on #2 above as well, not unnecessarily breaking 
reflinks to extents shared with other snapshots, the mechanism is one of 
extent size, not whether the extent is shared with another snapshot.  So 
even if it's a new file not yet snapshotted, extents over this size won't 
be touched.)

It's worth keeping in mind that btrfs' nominal data chunk size is 1 GiB.  
As such, that's the nominal largest extent size as well, altho in some 
cases (data chunks created on nearly empty TiB-scale filesystems) data 
chunk size can be larger, multiple GiB, in which case extent size can be 
larger as well.

Regardless, extent sizes > 1 GiB really aren't going to be a performance 
issue anyway, so while using the -t 1G or -t 2G option is a good idea and 
should reduce fragmentation further for extents between the default size 
and your -t size, going above that isn't likely to do any good anyway.

Which means for multi-gig files ideal minimum fragmentation will be a 
number of extents equal to their size in GiB, perhaps plus 2, assuming 
the first extent is in a partially used data chunk and thus under a gig, 
with the last being under a gig as well.  You are extremely unlikely to 
get better than that, so for file sizes over a GiB, you /will/ see 
multiple extents.  (Again, keeping in mind the exception where a data 
chunk is multi-GiB sized itself.)

So using defrag's -t 1G is likely to get you somewhat better results, but 
don't expect multi-gig files to ever be a single extent.

4) Recently (3.17?), btrfs got a new feature that allowed it to 
automatically delete chunk-allocations with zero usage.  This solved a 
serious problem, as before this, btrfs could allocate new chunks but 
couldn't deallocate them, and over time and many normal file-creation/
deletion cycles, most people ended up with a huge number of empty data 
chunks, often filling their filesystem until no new metadata chunks could 
be allocated, resulting in ENOSPC errors despite df reporting tens or 
occasionally even hundreds of GiB free.  (Also possible, but less common, 
was the reverse case, all otherwise free space allocated to empty 
metadata chunks, with no space left to allocate new data chunks.) A btrfs 
balance start -dusage=0 -musage=0 could quickly get rid of them, but 
before this feature, it had to be done manually.

Unfortunately, it appears defrag's previously great strategy of trying to 
use the space in existing data chunks before allocating new ones hasn't 
yet been adjusted for this, and it will first try to fill up holes in 
existing data chunks before allocating new ones.  With btrfs 
automatically deleting empty chunks now, that means defrag will be 
working with partially full chunks with free space, but where 
unfortunately that free space is itself fragmented.  So for a large multi-
gig file, instead of allocating new GiB sized chunks and defragging to 
whole-chunk GiB sized extents, it's likely to be trying to work with much 
smaller free-space extents in existing chunks.

Obviously this is going to rather negatively affect the results of a 
defrag and post-defrag filefrag results will still be higher numbers of 
extent counts than desired. =:^(

This is a known bug, a result of the fairly recent automated deleting 
empty data chunks and defrag's reluctance to allocate new ones, that will 
no doubt be fixed in time, but meanwhile, we deal with the code we have.


Here's an *entirely* *untested* idea for a workaround that I just came up 
with as I was typing the explanation above.  If you'd try it and report 
back whether it works, we might well have at least some way to work 
around the issue.

Before your defrag, do a btrfs fi df (or usage), and see what the numbers 
for data are.  (If you haven't run a balance recently and you see a big 
spread tens of GiB, between data size and data used, try something like 
btrfs balance start -dusage=20, which will only try to balance data 
chunks under 20% usage.  This will go much faster than balancing the 
whole filesystem, and often gets you quite a bit of space returned to 
unallocated from partially empty data chunks.  If it doesn't have the 
desired effect, try -dusage=50, or even higher, but be aware that above 
50, you're dealing with mostly full chunks already, which will take far 
longer to balance, with much less return for the time taken.  If you do 
such a balance, check again the btrfs fi df results and see how you did.)

Then do a truncate -s 100G some-not-yet-existing-file (adjusting the 100G 
as appropriate for your level of unallocated space, see either btrfs fi 
show or btrfs fi usage), and a sync, to ensure it's allocated in the 
filesystem.  Do another fi df and you should see the data size has 
increased accordingly.

Now delete that file, sync again, and do a fi df to double-check that you 
now have a bunch of empty data space (a spread between data size and used 
of near the file's size. 

Since I think btrfs doesn't delete those empty data chunks immediately, 
this /should/ give defrag a bunch of empty data chunks to use, and post-
defrag filefrag results should end up much better (accounting for the 
first three points above, of course)! =:^)

You might have to play with the idea a bit, perhaps using fallocate 
instead of truncate, etc, but as long as you get something to allocate a 
bunch of otherwise empty data chunks, delete it to empty them, and do the 
defrag before btrfs has deleted those empty chunks, I think it should 
work. =:^)

5) Judging by the filename of your example file, you run systemd, and 
it's a systemd journal file.  These files (along with database and VM 
image files) have a non-append-only rewrite pattern that is known to be 
problematic on COW-based filesystems such as btrfs, triggering very high 
levels of fragmentation.

What version of systemd are you running?  221 and later (219 first tried 
but there were bugs in the initial 219 implementation that remained in 
220, that weren't worked out until 221) are more btrfs-friendly than 
previous versions.

For reasons I'll explain in a moment, while I run btrfs and systemd (226 
ATM), I don't know how well systemd's efforts at btrfs-friendliness 
turned out, at least not as pertains to the journal, but AFAIK, they 
consisted of two parts, which together should definitely help with the 
problem.  However, the one part won't trigger on older systems updated to 
the newer btrfs-friendly systemd, without some manual intervention.  I'll 
explain...

First of all, it can be noted that if you're running an older systemd, or 
if you're on a newer systemd now but it was updated from an older one, 
you can take these steps manually, as well.  I'll outline them that way, 
tho newer systemd would take these steps automatically if installed 
fresh, not updated from an older installation.

a) With systemd running in emergency/rescue mode or at least with 
journaling shut down so it won't interfere...

b) Move/rename the existing journal directories (see the notes under (c), 
you might wish to do this with all of /var, or only with /var/log or
/var/log/journal, the latter being what I'd do) to something else.

c) Create a new btrfs /subvolume/ in place of the old /directory/ that 
you just moved, so it can be named the same.

The reason for this is that btrf snapshots stop at subvolume boundaries.  
What we're doing here is taking the journal dir out of future / (or /var) 
snapshots, by making it a subvolume of its own.

It should be noted that systemd's auto-create mechanism is the systemd-
tmpfiles-setup service, as configured in the various tmpfiles.d 
locations, namely /usr/lib/tmpfiles.d/*, specifically the var.conf file, 
here.  If you look at that file, you'll see that systemd (226 at least) 
actually creates a directory (d) for /var/log, with the subvolume 
creation (v) as /var itself.  Of course, only if they don't already exist 
(and v/subvolume-creation gracefully degrades to the d/dir-creation 
behavior it was before 219, on non-btrfs).

If I were doing it manually, however, I'd create the subvolume as 
/var/log/journal, keeping /var either as its own subvolume (as systemd 
now creates it) or as a directory on /, depending on whether I wanted the 
rest of /var to be snapshotted separately from / or not.

d) Set /var/log/journal (creating it if you just created /var as its own 
subvolume) nocow.

Systemd/tmpfiles.d has this (h line, setting +C) in /usr/lib/tmpfile.d/
journal-nocow.conf.

To do it manually, use chattr +C.  Do the same for subdirs (the remote 
subdir and individual machines subdirs), if applicable.

What nocow does is turn off copy-on-write for the file(s) in question, 
making it/them rewrite-in-place instead of cow.  As a (btrfs) side 
effect, it turns off compression (if otherwise on) and checksumming for 
the file as well.  On a directory, nocow does nothing, /except/ that 
newly created files (and subdirs) in that directory now inherit the nocow 
attribute.

The idea is that our journal files should be nocow, and with the +C set 
on the containing subdir, /newly/ /created/ journals should now be just 
that.

e) Now copy your old journals back in from the renamed backup, but 
there's a caveat...

On btrfs, for existing files that have nocow set after they already have 
content (are not zero size), when they actually start behaving as nocow 
isn't defined.  Thus, the files have to be created new in the target 
directory, in ordered to ensure that the (inherited) nocow takes effect 
immediately.

The easiest way to ensure this is to copy them in from a different 
filesystem (not subvolume).  Assuming your memory is sufficiently large, 
the easiest way to do /that/ is to copy the files to tmpfs, then copy/
move them to their new location under the nocow dir.  Because it's a 
cross-filesystem copy/move, that will ensure that they are actually 
created in the new filesystem, not just reflinked or some such.

(AFAIK, current cp without the reflink option does the right thing 
anyway, but there has been quite some discussion about making reflink 
copies the default, in which case you'd have to set --reflink=no to turn 
it off.  Mv will always take a shortcut and simply create a reflink at 
the new location, deleting the old one, if it can, which it normally can 
if both the source and destination are on the same filesystem, so it'd 
definitely be a problem from the same filesystem.  So there's ways to do 
it without using a separate filesystem as an intermediate, but the 
easiest way to be sure it's right is to just use the separate filesystem 
as an intermediate, and not have to worry about whether it's actually a 
newly created file at the destination, because you /know/ it is due to 
the cross-filesystem copy/move.)


OK, so why go to all this trouble?

First of all, nocow means the file is (normally) updated in-place, so 
fragmentation isn't an issue -- as long as that remains true.

The problem is that snapshots depend on cow because they lock in place 
the existing version.  With the existing version locked in place, 
obviously new writes must be cowed elsewhere, killing the intent of nocow.

What btrfs actually does with nocow files when a write comes in after a 
snapshot, is use what some call cow1.  The first write to a (4k) block 
cows it elsewhere, as it normally would, but the file's nocow attribute 
remains, and further writes to the now new block write in-place to it... 
until the next snapshot locks it /too/ in place.

So frequent snapshots pretty well disable nocow and trigger fragmentation 
just as if the file wasn't nocow... depending of course on how relatively 
frequent and widely spread out those writes are into a file, vs the 
frequency of snapshots locking the existing version in place.

So, what systemd did is ensure that newly created journal files are nocow, 
by setting the attribute on the existing dirs containing them so they'll 
inherit the attribute at creation.  That's half the solution.

Unfortunately, systemd didn't get the other half of the solution, the 
subvolume side, quite right.  They created a subvolume at the /var 
level.  Which means /var will not be snapshotted with /, OK, but what if 
you want to snapshot other files in /var?  Now you'll setup a 
snapshotting schedule for the /var subvol, but because /var/log/journal 
is a directory not a subvolume of its own, it'll be included in the /var 
snapshot, triggering the very same cow1 problems on the nocow journals 
(tho at a different frequency if /var is snapshotted at a different 
frequency) as they'd have if they were still part of the main / subvolume!

Which is why I recommend setting up /var/log/journal as its own subvolume, 
to exclude it from the snapshots above (either /var if it's its own subvol 
or / if not) and not snapshotting the journal subvolume at all, thus 
avoiding snapshot-triggered cow1 fragmentation with the journal files.

Of course not snapshotting the journals is its own tradeoff.  If you want 
to snapshot them, you can do so, but try to do it at as low a frequency 
as possible, and consider running defrag on the files.  Depending on your 
frequency of snapshotting and how frequently your journal files are 
cycled based on your journal configuration, if they're actually rotated 
out within a week or so and you're snapshotting also either every week or 
perhaps every couple days, then fragmentation shouldn't get bad enough 
due to the cow1 to be worth worrying about defrag.

6) Meanwhile, one final point to note, as hinted above, my own journal 
configuration, which bypasses all this.

Basically, I did this:

a) When I converted to systemd, I kept my old syslog (syslog-ng), only 
now built with the build-time-optional systemd/journal integration.  
(FWIW I'm on gentoo, so toggling the systemd integration was as simple as 
setting the systemd USE flag and rebuilding syslog-ng.  However, binary-
based distros based on systemd will probably already have such 
integration enabled in sysloggers they still ship.)

b) Because systemd's journal has some very nice current-session features 
(and because it's difficult/impossible to entirely disable in any case, 
but the features meant I didn't want to), I configured it to handle 
current session stuff only, basically by setting things up in 
journald.conf so it only used the /run/log/journal location, which being 
on tmpfs by default, is memory-only and thus blown away on reboot or 
when /run is unmounted.

This way I was able to keep the systemctl status last-ten-messages from 
that service feature, since the journal was still operational, but only 
to tmpfs. =:^)

c) I then configured my normal syslogger (syslog-ng in my case) to pull 
from systemd/journald, and to continue to log to the normally configured 
files in /var/log, as it normally did.  And logrotate and various scripts 
continue to rotate those logs as they normally would.

** Critically, because the normal syslogger writes in append-only mode, 
its files aren't subject to the fragmentation that rewrite-all-over-the-
file files get.  Thus, journals are subject to the problem, but the only 
journals I have are in tmpfs which is memory-only so access is fast no 
matter what it does, while the normal logs in (the btrfs) /var/log are 
append-only and thus not subject to the problem.

So for current-session investigations, I can use the journal with its 
best features, or the normal syslog files.  If I'm investigating 
something that happened in an earlier session/boot, I don't have the 
journal to use (but also don't have the problems that writing journals to 
btrfs brings), but the normal syslog files are still there and usable, 
just as they always were.

IOW, I've lost none of the old log style features, while still being able 
to use the new journal features in the current session, where they're of 
most use anyway.

(As an additional benefit, despite scouring the journald documentation, I 
found absolutely no way to filter out "noise" entries so they didn't hit 
the journal at all -- it's possible to filter them on the journal-read 
side, but not before they're written to journal.  With syslog-ng and 
presumably with other syslogs as well, filtering out such "noise" entries 
before they're written to the logs at all, is simple, once the config 
file format is understood, at least.  For noise that happens several 
times a minute, that's a lot of permanent filesystem writes that I'm 
avoiding!  Of course they're still stored in the tmpfs journals, using 
memory, but luckily the journal's binary format does compression, so 10K 
identical noise entries don't actually take up that much more room than 
just one does.)

d) I did find that with journald journaling a whole session to the /run 
tmpfs, instead of switching to /var/log/journal once it was available, I 
did have to increase the size of the /run tmpfs some.  However, before 
systemd, my old init system (the sysvinit-based openrc) only used /run 
for a few PID files, etc, so I had it clamped down rather tight, to 
something like 20 MiB max.  Now it's 512 MiB, half a GiB, reasonable on 
my 16 GiB memory system.

I then had to tweak the journald.conf settings a bit, so it'd use most of 
that half-GiB for itself (IIRC it uses only 50% by default, for safety, 
then stops journaling), while still leaving a bit of room for the 
standard PID files and the like.

FWIW, these are my non-default journald.conf settings; others remain at 
default:

ForwardToSyslog=yes
RuntimeKeepFree=48M
RuntimeMaxFileSize=64M
RuntimeMaxUse=448M
Storage=volatile
TTYPath=/dev/tty12

Storage=volatile is the critical one for confining journals to tmpfs.  
ForwardToSyslog=yes simply tells journald that I have a syslogger too, 
and I want it to get the logs.  The Runtime* settings determine systemd's 
usage on that tmpfs, and TTYPath is more or less unrelated.  (Gentoo 
defaults to printing the messages log to tty12 when it's syslog, and here 
I just decided to let journald do that, giving me an easy way to check on 
the "noise" that syslog-ng is filtering if I want to, instead of having 
syslog-ng print to that tty.  Obviously there's a corresponding non-
default setting in syslog-ng's config turning off printing to the tty, 
there.)

So there you have it, why I don't have to worry about journal behavior on 
btrfs at all, should you want to do similar.  Otherwise, simply follow 
the recommendations in point #5 (as well as the others), and your 
problems should go down dramatically, tho obviously I prefer the method I 
described here in point #6, thus not having to deal with the problem, for 
journal files at least, at all.

> Q3:
> 
> What's the best way to tell which files are causing the hangs? My
> current method is to make an educated guess (e.g. think of programs that
> store large database files) then use filefrag to see if there's
> fragmentation. I'm not confident I've found all the sources of bad
> performance.

That one I don't really have a good answer for... *except* to remind you 
that systemd, which you do appear to be using, has reasonably good 
boottime taken reports available.  If the problem's primarily at boot 
time or it at least exists there as well, as seems to be the case, you 
should be able to use those to at least get some idea of what services 
are taking the time, so you can focus on them.

One more thing for completeness, tho based on the below it's unlikely to 
apply to you.  People report that when their filesystem has many devices 
(more than four, so not applying to your two), the mount will sometimes 
take so long it times out, tho they can mount the filesystem fine at the 
command prompt.  One workaround here is to simply lengthen the timeout 
for that mount service.  IIRC some people had ideas for shortening that 
mount time, but I don't remember what they were.

... And few more (short) comments below the system info...

> System info:
> 
> [root@angel-nixos:~]# uname -a Linux angel-nixos 3.18.20 #1-NixOS SMP
> Thu Jan 1 00:00:01 UTC 1970 x86_64 GNU/Linux
> 
> [root@angel-nixos:~]# btrfs --version btrfs-progs v4.2
> 
> [root@angel-nixos:~]# btrfs fi show Label: 'AngelBtrfs'  uuid:
> 7f4b4b5d-1ba5-46cc-b782-938e3600a427
>         Total devices 2 FS bytes used 1.06TiB
>         devid    5 size 2.00TiB used 1.07TiB path /dev/mapper/[snip]
>         devid    6 size 2.00TiB used 1.07TiB path /dev/mapper/[snip]
> 
> btrfs-progs v4.2
> 
> [root@angel-nixos:~]# btrfs fi df /
> Data, RAID1: total=1.01TiB, used=1.01TiB
> System, RAID1: total=32.00MiB, used=192.00KiB
> Metadata, RAID1: total=60.00GiB, used=58.65GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

3.18 series kernel, second to last LTS series, so you're good there.
4.2 userspace, current AFAIK.

Btrfs is raid1 with two devices, and seems a bit more than half full (2 
TiB devices, just over 1 TiB data plus 60 GiB metadata on each).  The fi 
df says data is basically full, with metadata close enough as well, but 
as I implied, nearly a full TiB unallocated, so it appears the empty-
chunk removal is functioning fine, and the filesystem is healthy in terms 
of space available.

All around, pretty healthy! =:^)  The only thing I'd suggest in general 
is to setup a schedule of snapshot thinning, before it becomes a 
problem.  But at ~300 snapshots, it shouldn't be anything like a problem 
yet.

And as I said above, disable btrfs quotas if they're turned on (unless 
you're specifically helping to fix them), as right now they're simply 
more trouble than they're worth, and we have posts demonstrating that 
very point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

