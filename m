Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from omr-m09.mx.aol.com ([64.12.143.82]:58130 "EHLO
	omr-m09.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbaISU4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 16:56:07 -0400
To: linux-btrfs@vger.kernel.org
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
MIME-Version: 1.0
From: William Hanson <will.a.hanson@aol.com>
Content-Type: text/plain; charset="us-ascii"
Cc: calestyo@scientia.net
Message-Id: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com>
Date: Fri, 19 Sep 2014 16:50:05 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys...

I was just crawling through the wiki and this list's archive to find
answers about some questions.
Actually many of them matching those which Christoph has asked here
some time ago, though it seems no answers came up at all.

Isn't it possible to answer them, at least one by one? I'd believe that
most of these questions and their answers would be of common interest
and having them properly answered should be a benefit for all possible
btrfs users.

Regards,
William.


On Sun, 2014-08-31 at 06:02 +0200, Christoph Anton Mitterer wrote:
> Hey.
>
>
> For some time now I consider to use btrfs at a larger scale, basically
> in two scenarios:
>
> a) As the backend for data pools handled by dcache (dcache.org), where
> we run a Tier-2 in the higher PiB range for the LHC Computing Grid...
> For now that would be rather "boring" use of btrfs (i.e. not really
> using any of its advanced features) and also RAID functionality would
> still be provided by hardware (at least with the current hardware
> generations we have in use).
>
> b) Personally, for my NAS. Here the main goal is less performance but
> rather data safety (i.e. I want something like RAID6 or better) and
> security (i.e. it will be on top of dm-crypt/LUKS) and integrity.
> Hardware wise I'll use and UPS as well as enterprise SATA disks, from
> different vendors respectively different production lots.
> (Of course I'm aware that btrfs is experimental, and I would have
> regular backups)
>
>
>
>
> 1) Now I've followed linux-btrfs for a while and blogs like Marc's...
> and I still read about a lot of stability problems, some which sound
> quite serious.
> Sure we have a fsck now, but even in the wiki one can read statements
> like "the developers use it on their systems without major
problems"...
> but also "if you do this, it could help you... or break even more".
>
> I mean I understand that there won't be a single point in time, where
> Chris Mason says "now it's stable" and it would be rock solid form
that
> point on... but especially since new features (e.g. things like
> subvolume quota groups, online/offline dedup, online/offline fsck)
move
> (or will) move in with every new version... one has (as an end-user)
> basically no chance to determine what can be used safely and what
> tickles the devil.
>
> So one issue I have is to determine the general stability of the
> different parts.
>
>
>
>
> 2) Documentation status...
> I feel that some general and extensive documentation is missing. One
> that basically handles (and teaches) all the things which are specific
> to modern (especially CoW) filesystems.
> - General design, features and problems of CoW and btrfs
> - Special situations that arise from the CoW, e.g. that one may not be
> able to remove files once the fs is full,... or that just reading
files
> could make the used space grow (via the atime)
> - General guidelines when and how to use nodatacow... i.e. telling
> people for which kinds of files this SHOULD usually be done (VM
> images)... and what this means for those files (not checksumming) and
> what the drawbacks are if it's not used (e.g. if people insist on
having
> the checksumming - what happens to the performance of VM images? what
> about the wear with SSDs?)
> - the implications of things like compression and hash algos...
whether
> and when this will have performance impacts (positive or negative) and
> when not.
> - the typical lifecycles and procedures when using stuff like multiple
> devices (how to replace a faulty disk) or important hints like (don't
> span a btrfs RAID over multiple partitions on the same disk)
> - especially with the different (mount)options, I mean things that
> change the way the fs works like no-hole or mixed data/meta block
> groups... people need to have some general information when to choose
> which and some real world examples of disadvantages / advantages. E.g.
> what are the disadvantages of having mixed data/meta block groups? If
> there'd be only advantages, why wouldn't it be the default?
>
> Parts of this is already scattered over LWN articles, the wiki
(however
> the quality greatly "varies" there), blog posts or mailing list
posts...
> many of the information there is however outdated... and suggested
> procedures (e.g. how to replace a faulty disk) differ from example to
> example.
> An admin that wants to use btrfs shouldn't be required to pick all
this
> together (which is basically impossible).. there should be a manpage
> (which is kept up to date!) that describes all this.
>
> Other important things to document (which I couldn't fine so far in
most
> cases): What is actually guaranteed by btrfs respectively its design?
> For example:
> - If there'd be no bugs in the code,.. would the fs be guaranteed to
be
> always consistent by it's CoW design? Or are there circumstances where
> it can still run into being inconsistent?
> - Does this basically mean, that even without and fs journal,.. my
> database is always consistent even if I have a power cut or system
> crash?
> - At which places does checksumming take place? Just data or also meta
> data? And is the checksumming chained as with ZFS, so that every
change
> in blocks, triggers changes in the "upper" metadata blocks up to the
> superblock(s)?
> - When are these checksums verified? Only on fsck/scrub? Or really on
> every read? All this is information needed by an admin to determine
what
> the system actually guarantees or how it behaves.
> - How much data/metadata (in terms of bytes) is covered by one
checksum
> value? And if that varies, what's the maximum size? I mean if there
> would be on CRC32 per file (which can be GiB large) which would be
read
> every time a single byte of that file is read... this would probably
be
> bad ;) ... so we should tell the user "no we do this block or extent
> wise"... And since e.g. CRC32 is maybe not well suited for very big
> chunks of data, the user may want to know how much data is "protected"
> by one hash value... so that he can decide whether to switch to
another
> algorithm (if one should become available).
> - Does stacking with block layers work in all cases (and in which does
> it not)? E.g. btrfs on top of looback devices, dm-crypt, MD, lvm2? And
> also the other way round: What of these can be put on top of btrfs?
> There's the prominent case, that swap files don't work on btrfs. But
> documentation in that area should also contain performance
instructions,
> i.e. that while it's possible to have swap on top of btrfs via
loopback,
> it's perhaps stupid with CoW... or e.g. with dmcrypt+MD there were
quite
> some heavy performance impacts depending on whether dmcrypt was below
or
> above MD. Now of course normally, dmcrypt will be below btrfs,... but
> there are still performance questions e.g. how does this work with
> multiple devices? Is there one IO thread per device or one for all?
> Or questions like: Are there any stability issues when btrfs is
stacked
> below/above other block layer, e.g. in case of power losses...
> especially since btrfs relies so heavy on barriers.
> Or questions like: Is btrfs stable if lower block layers modify data?
> e.g. if dmcrypt should ever support online re-encryption
> - Many things about RAID (but more on that later).
>
>
>
>
> 3) What about some nice features which many people probably want to
> see...
> Especially other compression algos (xz/lzma or lz4[hc]) and hash alogs
> (xxHash... some people may even be interested in things like SHA2 or
> Keccak).
> I know some of them are planned... but is there any real estimation on
> when they come?
>
>
>
>
> 4) Are (or how) exiting btrfs filesystems kept up to date when btrfs
> evolves over time?
> What I mean here is... over time, more and more features are added to
> btrfs... this is of course not always a change in the on disk
format...
> but I always wonder a bit: If I write the same that of my existing fs
> into a freshly created one (with the same settings)... would it
> basically look like the same (of course not exactly)?
> In many of the mails here on the list respectively commit logs one can
> read things which sound as this happens quite often... that things
(that
> affect how data is written on the disk) are now handled better.
> Or what if defaults change? E.g. if something new like no-hole would
> become the default for new filesystems?
> An admin cannot track all these things and understand which of them
> actually means that he should recreate the filesystem.
>
> Of course there's the balance operation... but does this really affect
> everything?
>
> So the question is basically: As btrfs evolves... how to I keep my
> existing filesystems up to date so that they are as if they were
created
> as new.
>
>
>
>
> 5) btrfs management [G]UIs are needed
> Not sure whether this should be go into existing files managers (like
> nemo or konqueror) or something separate... but I definitely think,
that
> the btrfs community will need to provide some kind of powerful
> management [G]UI.
> Such a manager is IMHO crucial for anything that behaves like a
storage
> management system.
> What should it be able to do?
> a) Searching for btrfs specific properties, e.g.
> - files compressed with a given algo
> - files for which the compression ratio is <,>,= n%
> - files which are nodatacow
> - files for which integrity data is stored with a given hash algo
> - files with a given redundancy level (e.g. DUP or RAID1 or RAID6 or
> DUPn if that should ever come)
> - files which should have a given redundancy level, but whose actual
> level is different (e.g. due to a degraded state, or for which more
> block copies than desired are still available)
> - files which are defragmented at n%
>
> Of course all these conditions should be combinable, and one should
have
> further conditions like m/c/a-times or like the subvolumes/snapshots
> that should be searched.
>
> b) File lists in such a manager should display many details like
> compression ratio, algos (compression, hash), number of fragments,
> whether blocks of that file are referenced by other files, etc. pp.
>
> c) Of course it should be easy to change all the properties from above
> for a files (well at least if that's possible in btrfs).
> Like when I want to have some files, or dirs/subdirs, recompressed
with
> another algo, or uncompressed.
> Or triggering online defragmentation for all files of a given
> fragmentation level.
> Or maybe I want to set a higher redundancy level for files which I
> consider extremely precious to myself (not sure if it's planned to
have
> different redundancy levels per file)
>
> d) Such manager should perhaps also go through the logs and tell
things
> like:
> - when was the last complete balance
> - when was the last complete scrub
> - for which files happened integrity check problems during
read/scrub...
> how many of these could be corrected via other block copies?
>
> e) Maybe it could give even more low level information, like showing
how
> a file is distributed over the devices, e.g. how the blocks are
located,
> or showing the location block copies or involved block devices for the
> redundancy levels.
>
>
>
>
> 6) RAID / Redundancy Levels
> a) Just some remark, I think it's a bad idea to call these RAID in the
> btrfs terminology... since what we do is not necessarily exactly the
> same like classic RAID... this becomes most obvious with RAID1, which
> behaves not as RAID1 should (i.e. one copy per disk)... at least the
> used names should comply with MD.
>
> b) In other words... I think there should be RAID1, which equals to 1
> copy per underlying device.
> And it would be great to have a redundancy level DUPx, which is x
copies
> for each block spread over the underlying devices. So if x is 6 and
one
> has 3 underlying devices, each of them should have 2 copies of each
> block.
> I think the DUPx level is quite interesting to protect against single
> block failures, especially also on computers where one usually simply
> doesn't have more than one disk drive (e.g. notebooks).
>
> c) As I've noted before, I think it would be quite nice if it would be
> supported to have different redundancy levels for different files...
> e.g. less previous stuff like OS data could have DUP ... more valuable
> data could have RAID6... and my most precious data could have DUP5
(i.e.
> 5 copies of each block).
> If that would ever come, one would probably need to make that property
> inheritable by directories to be really useful.
>
> d) What's the status of the multi-parity RAID (i.e. more than tow
parity
> blocks)? Weren't some patches for that posted a while ago?
>
> e) Most important:
> What's the status on RAID5/6? Is it still completely experimental or
> already well tested?
> Does rebuilding work? Does scrubbing work?
> I mean as far as I know, there are still important parts that miss so
> that it works at all, right?
> When can one expect work on that to be completed?
>
> f) Again, it detailed documentation should be added how the different
> redundancy levels actually work, e.g.
> - Is there a chunk size, can it be configured and how does it affect
> reads/writes (as with MD)
> - How do parallel reads happen if multiple blocks are available? What
> e.g. if there are multiple block copies per device? Is simply always
the
> first tried to be read? Or the one with the best seek times? Or is
this
> optimised with other reads?
>
> g) When a block is read (and the checksum is always verified), does
that
> already work, that if verification fails, the other blocks are tried,
> respectively the block is tried to be recalculated using the parity?
> What if all that fails, will it give a read error, or will it simply
> deliver a corrupted block, as with traditional RAID?
>
> h) We also need some RAID and integrity monitoring tool.
> Doesn't matter whether this is a completely new tool or whether it can
> be integrated in something existing.
> But we need tools, which inform the admin via different ways when a
disk
> failed an a rebuild is necessary.
> And the same should happen when checksum verification errors happen
that
> could be corrected (perhaps with a configurable threshold)...so that
> admins have the chance to notice signs of a disk that is about to
fail.
>
> Of course such information is already printed to the kernel logs -
well
> I guess so),... but I don't think it's enough to let 3rd parties and
> admins write scripts/daemons which do these checks and alerting...
there
> should be something which is "official" and guaranteed to catch all
> cases and simply works(TM).
>
>
>
> Cheers,
> Chris.

