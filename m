Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56505 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbbJRFql (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 01:46:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zngnl-0007yS-2o
	for linux-btrfs@vger.kernel.org; Sun, 18 Oct 2015 07:46:37 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 07:46:37 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 07:46:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs autodefrag?
Date: Sun, 18 Oct 2015 05:46:30 +0000 (UTC)
Message-ID: <pan$6489f$54c8fba2$f1fc6c81$81eac@cox.net>
References: <56227910.7000208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xavier Gnata posted on Sat, 17 Oct 2015 18:36:32 +0200 as excerpted:

> Hi,
> 
> On a desktop equipped with an ssd with one 100GB virtual image used
> frequently, what do you recommend?
> 1) nothing special, it is all fine as long as you have a recent kernel
> (which I do)
> 2) Disabling copy-on-write for just the VM image directory.
> 3) autodefrag as a mount option.
> 4) something else.
> 
> I don't think this usecase is well documented therefore I asked this
> question.

You are correct.  The VM images on ssd use-case /isn't/ particularly well 
documented, I'd guess because people have differing opinions, and, 
indeed, actual observed behavior, and thus recommendations even in the 
ideal case, may well be different depending on the specs and firmware of 
the ssd.  The documentation tends to be aimed at the spinning rust case.

There's one detail of the use-case (besides ssd specs), however, that you 
didn't mention, that could have a big impact on the recommendation.  What 
sort of btrfs snapshotting are you planning to do, and if you're doing 
snapshots, does your use-case really need them to include the VM image 
file?

Snapshots are a big issue for anything that you might set nocow, because 
snapshot functionality assumes and requires cow, and thus conflicts, to 
some extent, with nocow.  A snapshot locks in place the existing extents, 
so they can no longer be modified.  On a normal btrfs cow-based file, 
that's not an issue, since any modifications would be cowed elsewhere 
anyway -- that's how btrfs normally works.  On a nocow file, however, 
there's a problem, because once the snapshot locks in place the existing 
version, the first change to a specific block (normally 4 KiB) *MUST* be 
cowed, despite the nocow attribute, because to rewrite in-place would 
alter the snapshot.  The nocow attribute remains in place, however, and 
further writes to the same block will again be nocow... to the new block 
location established by that first post-snapshot write... until the next 
snapshot comes along and locks that too in-place, of course.  This sort 
of cow-only-once behavior is sometimes called cow1.

If you only do very occasional snapshots, probably manually, this cow1 
behavior isn't /so/ bad, tho the file will still fragment over time as 
more and more bits of it are written and rewritten after the few 
snapshots that are taken.  However, for people doing frequent, generally 
schedule-automated snapshots, the nocow attribute is effectively 
nullified as all those snapshots force cow1s over and over again.

So ssd or spinning rust, there's serious conflicts between nocow and 
snapshotting that really must be taken into consideration if you're 
planning to both snapshot and nocow.

For use-cases that don't require snapshotting of the nocow files, the 
simplest workaround is to put any nocow files on dedicated subvolumes.  
Since snapshots stop at subvolume boundaries, having nocow files on 
dedicated subvolume(s) stops snapshots of the parent from including them, 
thus avoiding the cow1 situation entirely.

If the use-case requires snapshotting of nocow files, the workaround that 
has been reported (mostly on spinning rust, where fragmentation is a far 
worse problem due to non-zero seek-times) to work is first to reduce 
snapshotting to a minimum -- if it was going to be hourly, consider daily 
or every 12 hours, if you can get away with it, if it was going to be 
daily, consider every other day or weekly.  Less snapshotting means less 
cow1s and thus directly affects how quickly fragmentation becomes a 
problem.  Again, dedicated subvolumes can help here, allowing you to 
snapshot the nocow files on a different schedule than you do the up-
hierarchy parent subvolume.  Second, schedule periodic manual defrags of 
the nocow files, so the fragmentation that does occur is at least kept 
manageable.  If the snapshotting is daily, consider weekly or monthly 
defrags.  If it's weekly, consider monthly or quarterly defrags.  Again, 
various people who do need to snapshot their nocow files have reported 
that this really does help, keeping fragmentation to at least some sanely 
managed level.

That's the snapshot vs. nocow problem in general.  With luck, however, 
you can avoid snapshotting the files in question entirely, thus factoring 
this issue out of the equation entirely.

Now to the ssd issue.

On ssds in general, there are two very major differences we need to 
consider vs. spinning rust.  One, fragmentation isn't as much of a 
problem as it is on spinning rust.  It's still worth keeping to a 
minimum, because as the number of fragments increases, so does both btrfs 
and device overhead, but it's not the nearly everything-overriding 
consideration that it is on spinning rust.

Two, ssds have a limited write-cycle factor to consider, where with 
spinning rust the write-cycle limit is effectively infinite... at least 
compared to the much lower limit of ssds.

The weighing of these two overriding ssd factors one against the other, 
along with the simple fact that ssds are new enough technology and 
behavior differs enough between them that people simply haven't had time 
to come to agreement yet on best-practices, is why recommendations here 
differ far more than on spinning rust, where fragmentation really is the 
single most important overriding factor compared to very nearly 
everything else.  The fact of the matter is, on ssds, people strongly 
emphasizing the limited write-cycle count will tend not to worry, perhaps 
at all, about fragmentation, since it's negative effects are so much 
lower on ssds, while those (including me) who emphasize the remaining 
negative effects that fragmentation has, including scaling issues should 
it get to bad, as well as the less easy to create a universal rule for 
(because devices and firmwares do differ in major ways here) effect of 
the larger erase block size and how that interacts with sub-erase-block-
size fragmentation and write-amplification, thus perhaps triggering more 
write cycles due to sub-erase-block-fragmentation than the defrag would 
trigger, still tend to recommend at least taking fragmentation into 
account, and may even consider autodefrag worth enabling, for use-cases 
with small enough internal-rewrite-pattern files, at least.

So let's address autodefrag...

It's worth noting that I have autodefrag enabled here, on my ssds, and 
have from the first mount where I put content on them, so it has been 
enabled for every write on every file.  However, it's not ideal in all 
cases, my use-case simply is one where autodefrag works well, so...

Here's the deal with autodefrag.  First of all, if a file isn't 
constantly being rewritten, or if its rewrite pattern is append-only 
(like most log files, but *not* systemd journal files!), it doesn't tend 
to get particularly fragmented in the first place, especially with a 
filesystem that itself isn't highly fragmented, so free-space blocks tend 
to be large enough that a file doesn't tend to be fragmented as initially 
written.  So fragmentation tends to be worst on internal-rewrite-pattern 
files, where a block here and a block there are rewritten, normally 
triggering cow on a cow-based filesystem such as btrfs.

But, consider that rewriting the entire file to avoid fragmentation, 
which is what autodefrag does, takes time, larger file, more time.   And 
at some point, as filesizes increase, rewrites can be coming in faster 
than the file can be rewritten.  So autodefrag works best on internal-
rewrite-pattern files (as we've already established), but also on smaller 
files.

On spinning rust, autodefrag tends to work best at file sizes under 256 
MiB, a quarter GiB, where they rewrite fast enough that there's generally 
no problems at all.  But on most spinning rust, people will begin to see 
performance issues with autodefrag, at somewhere between half a GiB and 
3/4 GiB (512-768 MiB), and nearly everyone on spinning rust reports 
performance issues at 1 GiB file sizes and larger.

As it happens, this quarter-GiB or so spinning-rust autodefrag limit is 
close to that of common desktop-only database uses such as the sqlite 
files firefox and thunderbird use, so this is the use-case for which 
autodefrag is really recommended and tuned ATM.  That's really useful, 
since it means most desktop-only users can simply enable autodefrag and 
forget about it, as it'll "just work".

People optimizing larger databases and GiB+ VM image files, however, are 
going to need to do rather more detailed optimization, which sucks, but 
in contrast with normal desktop users, they're generally used to doing 
various optimization things, at least to some extent, already, so at 
least the problem is hitting those generally more technically prepared to 
deal with it.

But that's for spinning rust.  On ssds, particularly fast ssds, write 
speeds tend to be high enough that autodefrag can work effectively with 
much larger files.  The rub, however, is that ssd speeds vary enough, and 
there's few enough reports from people actually testing autodefrag with 
larger internal-rewrite-pattern files on ssds, that we don't have nicely 
wrapped up numbers for our ssd autodefrag filesize limitation 
recommendations, as we do for spinning rust.

I'd suggest based on my own experience and the reports we /do/ have, that 
on most ssds, autodefrag, provided people are inclined to enable it in 
the first place (see above discussion of the two major ssd factors here 
and how emphasis on one or the other tends to put people in one of two 
camps regarding even worrying about fragmentation at all on ssds), should 
work well enough on files upto a gig in size, at least.  I wouldn't be 
surprised to see 2 GiB work fine, particularly on fast ssds, tho I'd 
guess people will begin to see performance issues at the 4 GiB to 8 GiB 
size.

You say your image file, while on ssd, is 100 GiB.  Please do your own 
tests and report as it's possible my EWAG (educated but wild-ass-guess) 
is wrong, but I'm predicting that's well above the good performance limit 
for autodefrag, even on SSD.

That said, performance may still be good /enough/ that you can deal with 
it, if if sufficiently simplifies the situation for you regarding /other/ 
files, and your balance of use tilts sufficiently toward those other 
files as opposed to this single very large image file.

Tho at 100 GiB, the repeated rewriting of autodefrag is definitely likely 
to cut into your write-cycle allowance, arguably rather heavily.  So I 
really can't recommend autodefrag, despite how very much I wish it would 
work for your case, since it does dramatically simplify things where it 
works and you can then simply forget about other alternatives and all 
their relative complications.  Maybe someday they'll optimize it to 
handle such large files better, but until then, I really don't think it's 
a good match to your requirements.

So with autodefrag out for that file, and with the previous issues 
discussed, here's some reasonable options to try.

1) The nothing special option.  With a bit of luck, the 0-seek-time of 
ssd will mean that the fragmentation you're likely to see won't 
dramatically affect you, and the "do nothing" option will work acceptably.

The biggest thing I'm worried about here is that fragmentation may well 
get bad enough that it affects btrfs maintenance times, etc, due to 
scaling issues.  Btrfs balance, scrub, and check, could end up taking far 
longer than you might expect on ssd and than they'd take were it not for 
the fragmentation on this single file.

And if you're keeping snapshots around, be aware that simply defragging 
the file isn't likely to solve the btrfs maintenance times issue, because 
while btrfs did have snapshot-aware-defrag for a few kernels, it did not 
scale well *AT* *ALL* and the snapshot awareness was disabled again, 
until the scaling issues could be worked thru (which they're gradually 
doing, but it's an exceedingly complex problem, with many sub-issues that 
must be solved before scaling itself can be considered solved).  So 
defragging a file that's already highly fragmented in various snapshots 
of differing ages, will defrag it in the subvolume/snapshot you run the 
defrag in, but won't affect it in the other snapshots, so isn't likely to 
do much at all for the overall btrfs maintenance scaling issue.  You'd 
have to delete all those snapshots (or not take them in the first place, 
if your use-case doesn't require them) to eliminate the scaling issue, if 
it's due to fragmentation of this file in all those snapshots as well as 
the working copy.

So watch out for the maintenance scaling (maybe run a scrub and/or read-
only check periodically, just to ensure the execution times aren't 
running away on you), but if it works well enough for you, this is by far 
the most uncomplicated option.

2) If your use-case doesn't involve snapshotting the image file, setting 
nocow on the dir before creation of the file, such that the file inherits 
the nocow, should be a reasonably uncomplicated option.

If you do plan on snapshotting the parent but don't actually need to 
snapshot the nocow subdir and its nocow inheriting images, then use the 
dedicated subvolume trick to keep the image file out of your snapshots 
and avoid the cow1 complications.

3) As an idea taking the dedicated subvolume idea even further, consider 
an entirely separate dedicated filesystem for this image file.  That 
gives you much more flexibility, because then you can, for instance, 
still set autodefrag on the main filesystem, if it'd be useful there, 
without worrying about how that huge image file and autodefrag interact.

Additionally, that lets you use something other than btrfs for the image 
file's filesystem, if you want, while still using btrfs for the rest of 
the system.  If you're nocowing the file, you're already killing many of 
the features that btrfs generally brings, and provided the additional 
overhead of managing the separate partition and filesystem isn't too 
much, you might /as/ /well/ simply use something other than btrfs for 
that particular file, thus avoiding the whole image file cowing 
complications scenario in the first place.

I'd strongly consider the separate filesystem option here, as I already 
use multiple separate filesystems in ordered to avoid having my data eggs 
all in the same single filesystem basket (subvolumes don't cut it in 
terms of separation safety, for me).  But some people are far more averse 
to partitioning and similar solutions, for reasons that aren't entirely 
clear to me.  If you'd prefer to avoid the complexity of managing an 
entirely separate filesystem just for your image file, fine, just cross 
this option off your list and don't consider it further.

4) If the "do nothing" option doesn't cut it and your use-case involves 
snapshotting the image file, then things get much more complex.

As mentioned above, the recommendation for this sort of use-case isn't 
going to give you a simple ideal, but others have reported it to work 
acceptably, even surprisingly, well, once it's all setup, and if that's 
the situation on spinning rust, it should be even better on ssd, since 
the "controlled amount of fragmentation" should be even further within 
acceptable levels on ssd with its zero-seek-times, than it is on spinning 
rust.

Again, the recommendation for this use-case is to set nocow on the image-
file's dir so it inherits, and aim for the low end of your acceptable 
snapshotting frequency range for the image file, weekly instead of daily, 
or daily instead of hourly.  If necessary, use the separate subvolume 
trick to separate the image file from the rest of the content you're 
snapshotting, so you can use a higher frequency snapshot schedule on the 
other stuff, while keeping it as low frequency as you can manage on the 
image file.

Then do scheduled periodic targeted defrag of the image file, at a 
frequency some fraction of the snapshot frequency, perhaps monthly or 
quarterly for weekly snapshots, etc.

Keep in mind that defrag will only affect the working copy, not existing 
snapshots, but provided you do it at some reasonable fraction of the 
snapshotting interval, you should reset the fragmentation for further 
snapshots often enough that it doesn't get out of hand for them, either.


Finally, orthogonal to the original fragmentation question, but 
particularly important if you /are/ doing scheduled snapshots...

For scheduled snapshots in particular, it's very important that you setup 
a reasonable snapshot thinning schedule as well, the object of which 
should be to keep the number of snapshots as low as possible, again, for 
scaling reasons.  At this point anyway, btrfs maintenance operations 
simply do /not/ scale well with snapshot numbers in the tens or hundreds 
of thousands range, as people often find themselves with if they aren't 
doing scheduled snapshot thinning as well.

With reasonable thinning, it's quite possible to keep per-subvolume 
snapshots to 250 or so, reasonably under 300, even if starting with 
incredibly high snapshot frequency such as every half-hour or even every 
minute (tho the latter tends to be impractical because while snapshots 
are fast, very nearly instantaneous, removing them is rather more complex 
and definitely not instantaneous!).  With 250 snapshots per subvolume, 
you keep it to 1000 snapshots per filesystem if you're snapshotting four 
subvolumes, 2000 per filesystem if you're doing eight, etc.  Ideally, 
you'll target 1000 or less, possibly by thinning more drastically on some 
subvolume snapshots than others, but 2000 or even 3000 isn't out of hand, 
tho by 2500 to 3000, you'll probably notice increased maintenance times.  
By 10k snapshots, however, things are starting to go south, and above 
that, things go unreasonable pretty fast.

So do try to keep to "a few thousand, at most" snapshots, or expect to 
btrfs balance and other maintenance tasks to take "unreasonable" amounts 
of time, should you need to run them.  And if you can keep to under 1000, 
so much the better; your improved maintenance times will reward you for 
it. =:^)

Also, as you may have already seen, my recommendation for quotas is 
simply leave them off on btrfs.  They're broken and dramatically increase 
the scaling issues.  You either rely on quotas working or you don't.  If 
you don't, leave them off and avoid the issues.  If you do, use a more 
stable and mature filesystem where they're known to work reliably.  
Unless of course you're specifically working with the devs to test, 
report and trace down quota problems and test possible fixes.  In that 
case, please continue, as its your tolerance for the present pain that's 
helping to make the feature actually usable for the rest of us, someday 
hopefully soon. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

