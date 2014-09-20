Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51163 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaITJce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 05:32:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XVH1s-0006v6-6L
	for linux-btrfs@vger.kernel.org; Sat, 20 Sep 2014 11:32:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 11:32:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 11:32:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
Date: Sat, 20 Sep 2014 09:32:21 +0000 (UTC)
Message-ID: <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net>
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

William Hanson posted on Fri, 19 Sep 2014 16:50:05 -0400 as excerpted:

> Hey guys...
> 
> I was just crawling through the wiki and this list's archive to find
> answers about some questions. Actually many of them matching those
> which Christoph has asked here some time ago, though it seems no
> answers came up at all.

Seems his post slipped thru the cracks, perhaps because it was too much 
at once for people to try to chew on.  Let's see if second time around 
works better...

> 
> On Sun, 2014-08-31 at 06:02 +0200, Christoph Anton Mitterer wrote:
> 
>>
>> For some time now I consider to use btrfs at a larger scale, basically
>> in two scenarios:
> 
>>
>> a) As the backend for data pools handled by dcache (dcache.org), where
>> we run a Tier-2 in the higher PiB range for the LHC Computing Grid...
> 
>> For now that would be rather "boring" use of btrfs (i.e. not really
>> using any of its advanced features) and also RAID functionality would
>> still be provided by hardware (at least with the current hardware
>> generations we have in use).

While that scale is simply out of my league, here's what I'd say if I 
were asked my own opinion.

I'd say btrfs isn't ready for that, basically for one reason.

Btrfs has stabilized quite a bit in the last year, and the scary warnings 
have now come off, but it's still not fully stable, and keeping backups 
of any data you value is still very strongly recommended.

The scenario above is talking high PiB scale.  Simply put, that's a 
**LOT** of data to keep backups of, or to lose all at once if you don't 
and something happens!  At that scale I'd look at something more mature, 
with a reputation for working well at that scale.  Xfs is what I'd be 
looking at.  That or possibly zfs.

People who value their data highly tend, for good reason, to be rather 
conservative when it comes to filesystems.  At that level and at the 
conservatism I'd guess it calls for, I'd say another two years, perhaps 
longer, given btrfs history and how much longer than expected every step 
has seemed to take.

>> b) Personally, for my NAS. Here the main goal is less performance but
>> rather data safety (i.e. I want something like RAID6 or better) and
>> security (i.e. it will be on top of dm-crypt/LUKS) and integrity.
>> Hardware wise I'll use and UPS as well as enterprise SATA disks, from
>> different vendors respectively different production lots.
> 
>> (Of course I'm aware that btrfs is experimental, and I would have
>> regular backups)

[...]

>> [1] So one issue I have is to determine the general stability of the
>> different parts.

Raid5/6 are still out of the question at this point.  The operating code 
is there, but the recovery code is incomplete.  In effect, btrfs raid5/6 
must be treated as if it's slow raid0 in terms of dependability, but with 
a "free" upgrade to raid5/6 when the code is complete (assuming the array 
survives that long in its raid0 stage), as the operational code has been 
there all along and it has been creating and writing the parity, it just 
can't yet reliably restore from it if called to do so.

So if you wouldn't be comfortable with the data on raid0, that is, with 
the idea of losing it all if you lose any of it, don't put it on btrfs 
raid5/6 at this point.  The situation is actually /somewhat/ better than 
that, but that's the reliability bottom line you should be planning for, 
and if raid0 reliability isn't appropriate for your data, neither is 
btrfs raid5/6 at this point.

Btrfs raid1 and raid10 modes, OTOH, are reasonably mature and ready for 
use, basically at the same level as single-device btrfs.  Which is to say 
there's still active development and keep your backups ready as it's not 
/entirely/ stable yet, but a lot of people are using it without undue 
issues -- just keep those backups current and tested, and be prepared to 
use them if you need to.

For btrfs raid1 mode, it's worth pointing out that for btrfs raid1 means 
two copies on different devices, no matter how many devices are in the 
array.  It's always two copies, more devices simply adds more total 
capacity.

Similarly with btrfs raid10, the "1/mirror" side of that 10 is always 
paired.  Stripes can be two or three or whatever width, but there's 
always only the two mirrors.

N-way-mirroring is on the roadmap, scheduled for introduction after 
raid5/6 is complete.  So it's coming, but given the time it has taken for 
raid5/6 and the fact that it's still not complete, reasonably reliable n-
way-mirroring could easily still be a year away or more.


Features: Most of the core btrfs features are reasonably stable but some 
don't work so well together; see my just-previous post on a different 
thread about nocow and snapshots, for instance.  (Basically, setting nocow 
ends up being nearly useless in the face of frequent snapshots of an 
actively rewritten file.)

Qgroups/quotas are an exception.  They've recently rewritten it as the 
old approach simply wasn't working, and while it /should/ be more stable 
now, it's still very new (like 3.17 new), and I'd give it at least two 
more kernel cycles before I'd consider it usable... if no further major 
problems show up during that time.

And snapshot-aware-defrag has been disabled for now due to scalability 
issues, so defrag only considers the current snapshot it's actually 
pointed into to defrag, triggering data duplication and using up space 
faster that would otherwise be expected.

You'd need to check on the status of non-core btrfs features like the 
various dedup applications, snapper style scheduled snapshotting, etc, 
individually, as they're developed separately and more or less 
independently.

>> 2) Documentation status...
> 
>> I feel that some general and extensive documentation is missing.

This is gradually getting better.  The manpages are generally kept 
current, and their practical usability without reference to other sources 
such as the wiki has improved DRAMATICALLY in the last six months or so.

It still helps to have some good background in general principles such as 
COW, as they're not always explained, either on the wiki or in the 
manpages, but it's coming, and really, if there's one area I'd point out 
as having made MARKED strides toward a stable btrfs over the last six 
months, it WOULD be the documentation, as six months ago it simply wasn't 
stable ready, full-stop, but now I'd characterize much of the 
documentation as reasonably close to stable-ready, altho there are still 
some holes.

IOW, while before documentation had fallen behind the progress of the 
rest of btrfs toward stable, in the last several months it has caught up 
and in general can be characterized as at about the same stability/
maturity status as btrfs itself, that is, not yet fully stable, but 
getting to where that goal is at least visible, now.

But there's still no replacement for some good time investment in 
actually reading a few weeks of the list and most of the user-pages in 
the wiki, before you actually dive into btrfs on your own systems.  Your 
choices and usage of btrfs will be the better for it, and it could well 
save you needless data loss or at least needless grief and stress.  But 
of course that's the way it is with most reasonably advanced systems.


>> Other important things to document (which I couldn't fine so far in
>> most cases): What is actually guaranteed by btrfs respectively its
>> design?
> 
>> For example:
> 
>> - If there'd be no bugs in the code,.. would the fs be guaranteed to
>> be always consistent by it's CoW design? Or are there circumstances
>> where it can still run into being inconsistent?

In theory, yes, absent (software) bugs, btrfs would always be 
consistent.  In reality, hardware has bugs too, and then there's simply 
cheap hardware that even absent bugs doesn't make the guarantees of more 
expensive hardware.

Consumer-level storage hardware doesn't tend to have battery-backed write-
caches, for instance, and some of it is known to lie and say the write-
cache has been flushed to permanent storage when it hasn't been, for 
instance.

But absent (both hardware and software) bugs, in theory...


>> - Does this basically mean, that even without and fs journal,.. my
>> database is always consistent even if I have a power cut or system
>> crash?

That's the idea of tree-based copy-on-write, yes.

> 
>> - At which places does checksumming take place? Just data or also meta
>> data? And is the checksumming chained as with ZFS, so that every
>> change in blocks, triggers changes in the "upper" metadata blocks up
>> to the superblock(s)?

FWIW, at this level of question, people should really be reading the 
various whitepapers and articles discussing and explaining the 
technology, as linked on the wiki.

But both data and metadata are checksummed, and yes, it's chained, all 
the way up the tree.

>> - When are these checksums verified? Only on fsck/scrub? Or really on
>> every read? All this is information needed by an admin to determine
>> what the system actually guarantees or how it behaves.

Checksums are verified per-read.  If verification fails and there's a 
second copy available (btrfs multi-device raid1 or raid10 modes and dup-
mode metadata or mixed-bg on single-device), it is verified and 
substituted (both in RAM and rewritten in place of the bad copy) if it 
checks out.  If no valid copy is available, IO error.

Scrub is simply the method used to do this systematically across the 
entire filesystem, instead of waiting until a particular block is read 
and its checksum verified.


>> - How much data/metadata (in terms of bytes) is covered by one
>> checksum value? And if that varies, what's the maximum size?

Checksums are normally per block or node.  For data, that's a standard 
page-size block (4 KiB on x86 and amd64, and also on arm, I believe, but 
for example, I believe it's 64 KiB on sparc).  Metadata node/leaf sizes 
can be set at mkfs.btrfs time, but now default to 16 KiB, altho that too 
was 4 KiB in the past.  

>> - Does stacking with block layers work in all cases (and in which does
>> it not)? E.g. btrfs on top of loopback devices, dm-crypt, MD, lvm2?

Stacking btrfs on top of any block device variant should "just work", 
altho it should be noted that some of them might not pass flushes down 
and thus not be as resilient as others.  And of course performance can be 
more or less affected as well.

>> And also the other way round: What of these can be put on top of btrfs?

Btrfs is a filesystem.  So it'll take files.  Via a loopback mounted 
file, you can make it a block device, which will of course take 
filesystems or other block devices stacked.  That's not saying 
performance will be good thru all those layers, and reliability can be 
affected too, but it's possible.

>> There's the prominent case, that swap files don't work on btrfs. But
>> documentation in that area should also contain performance
>> instructions

Wait a minute.  Where's my consulting fee?  Come on, this is getting 
ridiculous.  That's were individual case research and deployment testing 
comes in.

>> Is there one IO thread per device or one for all?

It should be noted that btrfs has /not/ yet been optimized for 
parallelization.  The code still generally serializes writing each copy 
of a raid1 pair, for instance, and raid1 reads are assigned using a 
fairly dumb but reasonable initial-implementation odd/even-PID-based 
round-robin.  (So if your use-case happens to involve a bunch of 
otherwise parallelized reads from all-even PIDs, for instance, they'll 
all hit the same copy of the raid1, leaving the other one idle...)

This stuff will eventually be optimized, but getting raid5/6 and N-way-
mirroring done first, so they know the implementation there that they're 
optimizing for, makes sense.


>> 3) What about some nice features which many people probably want to
>> see...
> 
>> Especially other compression algos (xz/lzma or lz4[hc]) and hash alogs
>> (xxHash... some people may even be interested in things like SHA2 or
>> Keccak).
> 
>> I know some of them are planned... but is there any real estimation on
>> when they come?

If there were estimations they'd be way off.  The history of btrfs is 
that features repeatedly take far longer to implement than originally 
thought.

What roadmap there is, is on the wiki.

We know that raid5/6 mode is still in current development and n-way-
mirroring is scheduled after that.  But raid5/6 has been a kernel cycle 
or two out for over a year now.  Then when they got it in, it was only 
the operational stuff, the recovery stuff, scrub, etc, still isn't 
complete.

And there's the quota rework that is just done or still ongoing (I'm not 
sure which as I'm not particularly interested in that feature), and the 
snapshot-aware-defrag that was introduced in 3.9 but didn't scale so was 
disabled again, that is still to be reenabled after the quota rework and 
snapshot scaling stuff is done, and one dev has been putting a *LOT* of 
work into improving the manpages, and that intersects with the work on 
mount option consistency they're doing, and..., and...

Various devs are the leads on various features and so several are 
developing in parallel, but of course there's the bug hunting, and review 
and testing of each other's work they do, and... so they're not able to 
simply work on their assigned feature.

>> 4) Are (or how) exiting btrfs filesystems kept up to date when btrfs
>> evolves over time?
> 
>> What I mean here is... over time, more and more features are added to
>> btrfs... this is of course not always a change in the on disk format...

The disk format has been slowly changing, but keeping compatibility for 
the existing format and filesystems since I believe 2.6.32.

What I do as part of my regular backup regime, is every few kernel cycles 
I wipe the (first level) backup and do a fresh mkfs.btrfs, activating new 
optional features as I believe appropriate.  Then I boot to the new 
backup and run a bit to test it, then wipe the normal working copy and do 
a fresh mkfs.btrfs on it, again with the new optional features enabled 
that I want.

All that keeping in mind that I have a second level backup (and for some 
things a third level), that's on reiserfs (which I used before and which 
since the switch to data=ordered by default has been extremely dependable 
for me, even thru hardware issues like bad memory, failing mobo that 
would reset the sata connection, etc) not btrfs, in case there's a 
problem with btrfs that hits both the working copy and primary backup.

New kernels can mount old filesystems without problems (barring the 
occasional bug, and it's treated as a bug and fixed), but it isn't always 
possible to mount new filesystems on older kernels.

However, given the rate of change and the number of fixed bugs, the 
recommendation is to stay current with the kernel in any case.  Recently 
there was a bug that affected 3.15 and 3.16 (fixed in 3.16.2 and in 3.17-
rc2), that didn't affect 3.14 series.  During the trace and fix of that 
bug, the recommendation was to use 3.14, but not previous to that as 
there were known bugs fixed, and now that that known bug has been fixed, 
the recommendation is again latest stable series, thus 3.16.x currently, 
if not latest development serious, 3.17-rcX currently, or even btrfs 
integration, which currently are the patches that will be submitted for 
3.18.

Given that, if you're using earlier kernels you're using known-buggy 
kernels anyway.  So keep current with the kernel (and to a lessor extent 
userspace, btrfs-progs-3.16 is current, and the previous 3.14.2 is 
acceptable, 3.12 if you /must/ drag your feet), and you won't have to 
worry about it.

Of course that's a mark of btrfs stability as well.  The recommendation 
to keep to current should relax as btrfs stabilizes.  But 3.14 is a long-
term-support stable kernel series and the recommendation to be running at 
least that is a good one.  Perhaps it'll remain the earliest recommended 
stable kernel series for some time now that btrfs is stabilizing.

>> Of course there's the balance operation... but does this really affect
>> everything?

Not everything.  Some things are mkfs.btrfs-time only.

>> So the question is basically: As btrfs evolves... how to I keep my
>> existing filesystems up to date so that they are as if they were
>> created as new.

Balance is reasonable on an existing filesystem.  However, as I said, I 
myself do, and would also recommend, taking advantage of those backups 
you should be making/testing, to boot from them and do a mkfs on the 
working filesystem every few kernel cycles, to take advantage of the new 
features and keep everything working as well as possible considering the 
filesystem is after all, while no longer officially experimental, 
certainly not yet entirely stable, either.


>> 5) btrfs management [G]UIs are needed

Separate project.  It'll happen as that's the way FLOSS works, but it's 
not a worry of the core btrfs project at this point.

As such, I'm not going to worry about it either, which means I can delete 
a nice big chunk without replying to any of it further than I just have...

>> 6) RAID / Redundancy Levels
> 
>> a) Just some remark, I think it's a bad idea to call these RAID in the
>> btrfs terminology... since what we do is not necessarily exactly the
>> same like classic RAID... this becomes most obvious with RAID1, which
>> behaves not as RAID1 should (i.e. one copy per disk)... at least the
>> used names should comply with MD.

While I personally would have called in something else, say pair-
mirroring, by the original raid definitions going back to the original 
paper outlining them back in the day (which someone posted a link to at 
one point and I actually read, at least that part), two-way-mirroring 
regardless of the number of devices actually DOES qualify as RAID-1.

mdraid's implementation is different and does N-way-mirroring across all 
devices for RAID-1, but that's simply its implementation, not a 
requirement for RAID-1 either in the original paper or as generally 
accepted today.

That said, you will note that in btrfs, the various levels are called 
raid0, raid1, raid10, raid56, in *non-caps*, as opposed to the 
traditional ALL-CAPS RAID-1 notation.  One of the reasons given for that 
is that these btrfs raidN "modes" don't necessarily exactly correspond to 
the traditional RAID-N levels at the technical level, and the non-caps 
raidN notation was seen as an acceptable method of noting "RAID-like", 
behavior, that wasn't technically precisely RAID.

N-way-mirroring is coming.  It's just not implemented yet.


>> c) As I've noted before, I think it would be quite nice if it would be
>> supported to have different redundancy levels for different files...

That's actually on the roadmap too, tho rather farther down the line.  
The btrfs subvolume framework is already setup to allow per-subvolume 
raid-levels, etc, at some point, altho it's not yet implemented, and 
there's already per-subvolume and per-file properties and extended 
attributes, including a per-file compression attribute.  After they 
extend btrfs to handle per-subvolume redundancy levels, it should be a 
much smaller step to simply make that the default, and have per-file 
properties/attributes available for it as well, just as the per-file 
compression attribute is already there.

But I'd put this probably 3-5 years out... and given btrfs history with 
implementations repeatedly taking longer than expected, it could easily 
be 5-10 years out...

>> d) What's the status of the multi-parity RAID (i.e. more than [two]
>> parity blocks)? Weren't some patches for that posted a while ago?

Some proof-of-concept patches were indeed posted.  And it's on the 
roadmap, but again, 3-5 years out.  Tho it's likely there will be a 
general kernel solution before then, usable by mdraid, btrfs, etc, and if/
when that happens, it should make adapting it for btrfs much simpler.  
OTOH, that also means there will be much broader debate about getting a 
suitable general purpose solution, but it also means not just btrfs folks 
will be involved.  At this point then, it's not a btrfs problem, but 
waiting on that general purpose kernel solution, which btrfs can then 
adapt at its leisure.


>> e) Most important:
> 
>> What's the status on RAID5/6? Is it still completely experimental or
>> already well tested?

Covered above.  Consider it raid0 reliability at this point and you won't 
be caught out.  Additionally, Marc MERLIN has put quite a bit of testing 
into it and has writeups on the wiki and linking to his blog.  That's 
more detail than I have, for sure.

>> f) Again, it detailed documentation should be added how the different
>> redundancy levels actually work, e.g.
> 
>> - Is there a chunk size, can it be configured

There's a semi-major rework potentially planned to either coincide with 
the N-way-mirroring introduction, or possibly for after that, but with 
the N-way-mirroring written with it in mind.

Existing raid0/1/10/5/6 would remain implemented as they are, possibly 
with a few more options, and likely with the existing names being aliases 
for new ones fitting the new naming framework.  The new naming framework, 
meanwhile, would include redundancy/striping/parity/hotspares (possibly) 
all in the same overall framework.  Hugo Mills is the guy with the 
details on that, tho I think it's mentioned in the ideas section on the 
wiki as well.

With that in mind, too much documentation detail on the existing 
implementation would be premature as much of it would need rewritten for 
the new framework.

Never-the-less, there's reasonable detail out there if you look.  The 
wiki covers more than I'll write here, for sure.

>> g) When a block is read (and the checksum is always verified), does
>> that already work, that if verification fails, the other blocks are
>> tried, respectively the block is tried to be recalculated using the
>> parity?

Other copies of the block (raid1,10,dup) are checked, as mentioned above.

I'm not sure how raid56 handles it with parity, but since that code 
remains incomplete, it hasn't been a big factor.  Presumably either Marc 
MERLIN or one of the devs will fill in the details once it's considered 
complete and usable.

>> What if all that fails, will it give a read error, or will it simply
>> deliver a corrupted block, as with traditional RAID?

Read error, as mentioned above.

>> h) We also need some RAID and integrity monitoring tool.

"Patience, grasshopper." All in time...

And that too could be a third-party tool, at least at first, altho while 
separate enough to be developed third-party, it's core enough presumably 
one would eventually be selected and shipped as part of btrfs-progs.

I'd actually guess it /will/ be a third party tool at first.  That's pure 
userspace after all, with little beyond what's already available in the 
logs and in sysfs needed, and the core btrfs devs already have their 
hands full with other projects, so a third-party implementation will 
almost certainly appear before they get to it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

