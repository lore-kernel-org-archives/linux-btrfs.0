Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:36822 "EHLO
	mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbcFFNEO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 09:04:14 -0400
Received: by mail-it0-f53.google.com with SMTP id f67so41684329ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jun 2016 06:04:13 -0700 (PDT)
Subject: Re: btrfs
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1464819934.6742.71.camel@scientia.net>
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
 <1464975482.6679.11.camel@scientia.net>
 <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
 <1465005092.6648.39.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5f306afd-8a22-a707-022e-7572d3944752@gmail.com>
Date: Mon, 6 Jun 2016 09:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <1465005092.6648.39.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-03 21:51, Christoph Anton Mitterer wrote:
> On Fri, 2016-06-03 at 15:50 -0400, Austin S Hemmelgarn wrote:
>> There's no point in trying to do higher parity levels if we can't get
>> regular parity working correctly.  Given the current state of things,
>> it might be better to break even and just rewrite the whole parity
>> raid thing from scratch, but I doubt that anybody is willing to do
>> that.
>
> Well... as I've said, things are pretty worrying. Obviously I cannot
> really judge, since I'm not into btrfs' development... maybe there's a
> lack of manpower? Since btrfs seems to be a very important part (i.e.
> next-gen fs), wouldn't it be possible to either get some additional
> funding by the Linux Foundation, or possible that some of the core
> developers make an open call for funding by companies?
> Having some additional people, perhaps working fulltime on it, may be a
> big help.
>
> As for the RAID... given how many time/effort is spent now into 5/6,..
> it really seems that one should have considered multi-parity from the
> beginning on.
> Kinda feels like either, with multi-parity this whole instability phase
> would start again, or it will simply never happen.
New features will always cause some instability, period, there is no way 
to avoid that.
>
>
>>> - Serious show-stoppers and security deficiencies like the UUID
>>>   collision corruptions/attacks that have been extensively
>>> discussed
>>>   earlier, are still open
>> The UUID issue is not a BTRFS specific one, it just happens to be
>> easier
>> to cause issues with it on BTRFS
>
> uhm this had been discussed extensively before, as I've said... AFAICS
> btrfs is the only system we have, that can possibly cause data
> corruption or even security breach by UUID collisions.
> I wouldn't know that other fs, or LVM are affected, these just continue
> to use those devices already "online"... and I think lvm refuses to
> activate VGs, if conflicting UUIDs are found.
If you are mounting by UUID, it is entirely non-deterministic which 
filesystem with that UUID will be mounted (because device enumeration is 
non-deterministic).  As far as LVM, it refuses activating VG's, but it 
can still have issues if you have LV's with the same UUID (which can be 
done pretty trivially), and the fact that it refuses to activate them 
technically constitutes a DoS attack (because you can't use the resources).
>
>
>> There is no way to solve it sanely given the requirement that
>> userspace
>> not be broken.
> No this is not true. Back when this was discussed, I and others
> described how it could/should be done,... respectively how
> userspace/kernel should behave, in short:
> - continue using those devices that are already active
This is easy, but only works for mounted filesystems.
> - refusing to (auto)assemble by UUID, if there are conflicts
>   or requiring to specify the devices (with some --override-yes-i-know-
>   what-i-do option option or so)
> - in case of assembling/rebuilding/similar... never doing this
>   automatically
These two allow anyone with the ability to plug in a USB device to DoS 
the system.
>
> I think there were some more corner cases, I basically had them all
> discussed in the thread back then (search for "attacking btrfs
> filesystems via UUID collisions?" and IIRC some different titled parent
> or child threads).
>
>
>>   Properly fixing this would likely make us more dependent
>> on hardware configuration than even mounting by device name.
> Sure, if there are colliding UUIDs, and one still wants to mount (by
> using some --override-yes-i-know-what-i-do option),.. it would need to
> be by specifying the device name...
> But where's the problem?
> This would anyway only happen if someone either attacks or someone made
> a clone, and it's far better to refuse automatic assembly in cases
> where accidental corruption can happen or where attacks may be
> possible, requiring the user/admin to manually take action, than having
> corruption or security breach.
Refusing automatic assembly does not prevent the attack, it simply 
converts it from a data corruption attack to a DoS attack.
>
> Imagine the simple case: degraded RAID1 on a PC; if btrfs would do some
> auto-rebuild based on UUID, then if an attacker knows that he'd just
> need to plug in a USB disk with a fitting UUID...and easily gets a copy
> of everything on disk, gpg keys, ssh keys, etc.
If the attacker has physical access to the machine, it's irrelevant even 
with such protection, as there are all kinds of other things that could 
be done to get data off of the disk (especially if the system has 
thunderbolt ports or USB C ports).  If the user has any unsecured 
encryption or authentication tokens on the system, they're screwed 
anyway though.
>
>>> - a number of important core features not fully working in many
>>>   situations (e.g. the issues with defrag, not being ref-link
>>> aware,...
>>>   an I vaguely remember similar things with compression).
>> OK, how then should defrag handle reflinks?  Preserving them prevents
>> it
>> from being able to completely defragment data.
> Didn't that even work in the past and had just some performance issues?
Most of it was scaling issues, but unless you have some solution to 
handle it correctly, there's no point in complaining about it.  And my 
point about defragmentation with reflinks still stands.
>
>
>>> - OTOH, defrag seems to be viable for important use cases (VM
>>> images,
>>>   DBs,... everything where large files are internally re-written
>>>   randomly).
>>>   Sure there is nodatacow, but with that one effectively completely
>>>   looses one of the core features/promises of btrfs (integrity by
>>>   checksumming)... and as I've showed in an earlier large
>>> discussion,
>>>   none of the typical use cases for nodatacow has any high-level
>>>   checksumming, and even if, it's not used per default, or doesn't
>>> give
>>>   the same benefits at it would on the fs level, like using it for
>>> RAID
>>>   recovery).
>> The argument of nodatacow being viable for anything is a pretty
>> significant secondary discussion that is itself entirely orthogonal
>> to
>> the point you appear to be trying to make here.
>
> Well the point here was:
> - many people (including myself) like btrfs, it's
>   (promised/future/current) features
> - it's intended as a general purpose fs
> - this includes the case of having such file/IO patterns as e.g. for VM
>   images or DBs
> - this is currently not really doable without loosing one of the
>   promises (integrity)
>
> So the point I'm trying to make:
> People do probably not care so much whether their VM image/etc. is
> COWed or not, snapshots/etc. still work with that,... but they may
> likely care if the integrity feature is lost.
> So IMHO, nodatacow + checksumming deserves to be amongst the top
> priorities.
You're not thinking from a programming perspective.  There is no way to 
force atomic updates of data in chunks bigger than the sector size on a 
block storage device.  Without that ability, there is no way to ensure 
that the checksum for a data block and the data block itself are either 
both written or neither written unless you either use COW or some form 
of journaling.
>
>
>>> - still no real RAID 1
>> No, you mean still no higher order replication.  I know I'm being
>> stubborn about this, but RAID-1 is offici8ally defined in the
>> standards
>> as 2-way replication.
> I think I remember that you've claimed that last time already, and as
> I've said back then:
> - what counts is probably the common understanding of the term, which
>   is N disks RAID1 = N disks mirrored
> - if there is something like an "official definition", it's probably
>   the original paper that introduced RAID:
>   http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf
>   PDF page 11, respectively content page 9 describes RAID1 as:
>   "This is the most expensive option since *all* disks are
>   duplicated..."
>
>
>> The only extant systems that support higher
>> levels of replication and call it RAID-1 are entirely based on MD
>> RAID
>> and it's poor choice of naming.
>
> Not true either, show me any single hardware RAID controller that does
> RAID1 in a dup2 fashion... I manage some >2PiB of storage at the
> faculty, all controller we have, handle RAID1 in the sense of "all
> disks mirrored".
Exact specs, please.  While I don't manage data on anywhere near that 
scale, I have seen hundreds of different models of RAID controllers over 
the years, and have yet to see one that is an actual hardware 
implementation that supports creating a RAID1 configuration with more 
than two disks.

As far as controllers that I've seen that do RAID-1 solely as 2 way 
replication:
* Every single Dell branded controller I've dealt with, including recent 
SAS3 based ones (pretty sure most of these are LSI Logic devices)
* Every single Marvell based controller I've dealt with.
* All of the Adaptec and LSI Logic controllers I've dealt with (although 
most of these I've dealt with are older devices).
* All of the HighPoint controllers I've dealt with.
* The few non-Marvell based Areca controllers I've dealt with.
>
>
>>> - no end-user/admin grade maangement/analysis tools, that tell non-
>>>   experts about the state/health of their fs, and whether things
>>> like
>>>   balance etc.pp. are necessary
>> I don't see anyone forthcoming with such tools either.  As far as
>> basic
>> monitoring, it's trivial to do with simple scripts from tools like
>> monit
>> or nagios.
>
> AFAIU, even that isn't really possible right now, is it?
There's a limit to what you can do with this, but you can definitely 
check things like error counts from normal operation and scrubs, notify 
when the filesystem goes degraded, and other basic things that most 
people expect out of system monitoring.

In my particular case, what I'm doing is:
1. Run scrub from a cronjob daily (none of my filesystems are big enough 
for this to take more than an hour)
2. From monit, check the return code of 'btrfs scrub status' at some 
point early in the morning after the scrub finishes, if it returns 
non-zero, there were errors during the scrub.
3. Have monit poll filesystem flags every cycle (in my case, every 
minute).  If it sees these change, the filesystem had some issue.
4. Parse the output of 'btrfs device stats' to check for recorded errors 
and send an alert under various cases (checking whole system aggregates 
of each type, and per-filesystem aggregates of all types, and flagging 
when it's above a certain threshold).
5. Run an hourly filtered balance with -dusage=50 -dlimit=2 -musage=50 
-mlimit=3 to clean up partially used chunks.
6. If any of these have issues, I get an e-mail from the system (and 
because of how I set that up, that works even if none of the persistent 
storage on the system is working correctly).
Note that this is just the BTRFS specific things, and doesn't include 
SMART checks, low-level LVM verification, and other similar things.
> Take RAID again,... there is no place where you can see whether the
> RAID state is "optimal", or does that exist in the meantime? Last time,
> people were advised to look at the kernel logs, but this is no proper
> way to check for the state... logging may simply be deactivated, or you
> may have an offline fs, for which the logs have been lost because they
> were on another disk.
Unless you have a modified kernel or are using raid5/6, the filesystem 
will go read-only when degraded.  You can poll the filesystem flags to 
verify this (although it's better to poll and check if they're changed,a 
s that can detect other issues too).  Additionally, you can check device 
stats, which will show any errors.
>
> Not to talk about the inability to properly determine how often btrfs
> encountered errors, and "silently" corrected it.
> E.g. some statistics about a device, that can be used to decide whether
> its dying.
> I think these things should be stored in the fs (and additionally also
> on the respective device), where it can also be extracted when no
> /var/log is present or when forensics are done.
'btrfs device stats' will show you running error counts since the last 
time they were manually reset (by passing the -z flag to said command). 
It's also notably one of the few tools that has output which is easy to 
parse programmatically (which is an entirely separate issue).
>
>
>>   As far as complex things like determining whether a fs needs
>> balanced, that's really non-trivial to figure out.  Even with a
>> person
>> looking at it, it's still not easy to know whether or not a balance
>> will
>> actually help.
> Well I wouldn't call myself a btrfs expert, but from time to time I've
> been a bit "more active" on the list.
> Even I know about these strange cases (sometimes tricks), like many
> empty data/meta block groups, that may or may not get cleaned up, and
> may result in troubles
> How should the normal user/admin be able to cope with such things if
> there are no good tools?
Empty block groups get deleted automatically these days (I distinctly 
remember this going in, because it temporarily broke discard and fstrim 
support).\, so that one is not an issue if they're on a new enough kernel.

As far as what I specifically said, it's still hard to know if a balance 
will _help_ or not.  For example, one of the people I was helping on the 
mailing list recently had a filesystem which had a bunch of chunks which 
were partially allocated and thus a lot of 'free space' listed in 
various tools, but none which were empty, and the only reason this was 
apparent was because a balance filtered on usage was failing above a 
certain threshold and not balancing anything below that threshold. 
Having to test for such things and as such use potentially a lot of disk 
bandwidth (especially because the threshold can be pretty high, in this 
case it was 67%) is not user friendly any more than not reporting an 
issue at all is.

Part of the issue here is that people aren't used to using filesystem 
specific tools to check their filesystems.  df is a classic example of 
this, which was designed in the 70's and never envisioned some of the 
cases we have to deal with in BTRFS.
>
> It starts with simple things like:
> - adding a further disk to a RAID
>   => there should be a tool which tells you: dude, some files are not
>      yet "rebuild"(duplicated),... do a balance or whatever.
Adding a disk should implicitly balance the FS unless you tell it not 
to, it was just a poor design choice in the first place to not do it 
that way.
>
>
>>> - the still problematic documentation situation
>> Not trying to rationalize this, but go take a look at a majority of
>> other projects, most of them that aren't backed by some huge
>> corporation
>> throwing insane amounts of money at them have at best mediocre end-
>> user
>> documentation.  The fact that more effort is being put into
>> development
>> than documentation is generally a good thing, especially for
>> something
>> that is not yet feature complete like BTRFS.
>
> Uhm.. yes and no...
> The lack of documentation (i.e. admin/end-user-grade documentation)
> also means that people have less understanding in the system, less
> trust, less knowledge on what they can expect/do with it (will Ctrl-C
> on btrfs checl work? what if I shut down during a balance? does it
> break then? etc. pp.), less will to play with it.
Given the state of BTRFS, that's not a bad thing.  A good administrator 
looking into it will do proper testing before using it.  If you aren't 
going to properly test something this comparatively new, you probably 
shouldn't be just arbitrarily using it without question.
> Further,... if btrfs would reach the state of being "feature complete"
> (if that ever happens, and I don't mean because of slow development,
> but rather, because most other fs shows that development goes "ever"
> on),... there would be *so much* to do in documentation, that it's
> unlikely it will happen.
In this particular case, I use the term 'feature complete' to mean on 
par feature wise with most other equivalent software (in this case, near 
feature parity with ZFS, as that's really the only significant 
competitor in the intended market).  As of right now, the only extant 
items other than bugs that would need to be in BTRFS to be feature 
complete by this definition are:
1. Quota support
2. Higher-order replication (at a minimum, 3 copies)
3. Higher order parity (at a minimum, 3-level, which is the highest ZFS 
supports right now).
4. Online filesystem checking.
5. In-band deduplication.
6. In-line encryption.
7. Storage teiring (like ZFS's L2ARC, or bcache).

Of these, items 1 and 5 are under active development, 6 would likely not 
require much effort for a basic implementation because there's a VFS 
level API for it now, and 2 and 3 are stalled pending functional raid5/6 
(which is the correct choice, adding them now would make it more 
complicated to fix raid5/6), which means that the only ones that don't 
appear to be actively on the radar are 4 (which most non-enterprise 
users probably don't strictly need) and 7 (which would be nice but would 
require significant work for limited benefit given the alternative 
options in the block layer itself).
