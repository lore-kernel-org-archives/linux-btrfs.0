Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40738 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbbCRBWj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 21:22:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YY2gp-0004fK-Md
	for linux-btrfs@vger.kernel.org; Wed, 18 Mar 2015 02:22:31 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 02:22:31 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 02:22:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it safe or useful to use NOCOW flag and autodefrag mount
 option at same time?
Date: Wed, 18 Mar 2015 01:22:10 +0000 (UTC)
Message-ID: <pan$e9211$20694c4d$855e8e94$76cf2c75@cox.net>
References: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46>
	<C879D0AA-018D-4C52-94F8-37D322F8DCD4@gmail.com>
	<5508B245.5080607@inwind.it>
	<CAJCQCtRxOZTS=2KGQ6cY24NN3nb7gmX9WcG6iK4hxkCE4a5jhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 17 Mar 2015 17:16:06 -0600 as excerpted:

> On Tue, Mar 17, 2015 at 5:01 PM, Goffredo Baroncelli
> <kreijack@inwind.it> wrote:
> 
>> If I read correctly, autodefrag disables the NOcow behavior. This to me
>> doesn't seem be "work well"; these are two incompatibles features:
>> enabling autodefrag disables the nocow behavior on all files.
>> Do I understood correctly ?
> 
> I'm not sure whether autodefrag works on large VM files anyway. I
> thought it was more targeted for things like log files and journals.

AFAIK, autodefrag should "work", as in, trigger a defrag-purposed rewrite 
when fragmentation is detected, on files of any size.  Thus, "what it 
says on the tin" continues to apply. =:^)

The problem with autodefrag and large files is more one of performance.  
Given particularly the limited I/O speeds of spinning rust but applying 
to a much more limited extent to high-speed SSDs as well, as file sizes 
go up, so does the time required to rewrite the entire file in ordered to 
defrag it, as opposed to only the relatively small file blocks that were 
actually changed, creating the fragmentation in the first place.

With small or relatively infrequently changed files this isn't a big 
deal, as the rewrite time remains well below the time between changes.

The problem appears when the changes start coming in at near the same 
speed as the time taken to rewrite the file, which will obviously be the 
case for large files only, the larger the file, the longer it will take 
to fully rewrite, increasing accordingly the requirement for time between 
changes to the file.

Obviously, the exact point at which this becomes a problem depends on 
three things, the speed of the storage device(s) involved, the size of 
the file, and the frequency of incoming rewrites to it, plus of course 
the level of other I/O traffic on the device in question.  However, 
generally speaking, few people seem to have significant problems with 
files under a quarter gig, typifying sqlite databases like those firefox 
uses, etc, while VM images and database files over say two gig are very 
often problematic, at least on spinning rust.  Between those extremes and 
picking round numbers, half a gig to a gig seems to be the size at which 
people seem to notice problems and thus, where the worry zone begins, 
depending, again, on individual use-case specifics.  Below a half gig is 
likely to be fine except for slow and busy devices with heavy VM/DB file 
activity as well; above a gig is a common enough problem that it's a 
concern for most spinning rust users; in between the two is the very gray 
area.

The problem, therefore, isn't one of autodefrag "not working" on large VM 
files, but of the performance issues it causes with them, especially on 
spinning rust.

On fast SSDs the write times for a given file size are going to be much 
lower, meaning the incoming write stream will have to be much higher 
before there are issues.  SSD performance varies widely and thus so will 
the numbers, and I don't believe there's enough reports of the problem on 
SSDs to actually have good numbers, but as a WAG I'd not expect 
significant problems until northward of 8 gig and for high-speed SSDs 
(nearing SATA-3 6-gig speeds) perhaps 16 gig.  As such, I doubt it's in 
practice enough of a problem for most to need to worry about.  How many 
VMs are both over that and with enough writeback changes to trigger the 
problem?


To the larger questions of the thread, meanwhile...

FWIW, I have consistently used autodefrag on all my btrfs, which are all 
SSD.  I figure between the faster write speeds of SSD and the lower 
metadata load of tracking a file as one extent vs (potentially) several 
thousand, it's worth the cost in extra write-cycles.

My use-case, however, doesn't involve large VMs or anything else that 
would heavily benefit from NOCOW, tho I'd not hesitate to use it if I 
were to start using such VMs.

So I didn't respond to the thread initially, as it's not my use-case, and 
I didn't have enough information from other posts to have an informed 
opinion.  Sounds like it's safe on btrfs-recommended current kernels, 
however.

As for that patch, with the obligatory "I'm an admin and list regular, 
not a developer" disclaimer, this reminds me of the situation with the 
snapshot "cow1" case, where a write to a block after a snapshot must be 
COWed -- ONCE -- since the snapshot locked in place the existing copy of 
that block.  However, the nocow flag remains, and further writes to the 
same block will be rewritten in-place (where the first write COWed to)... 
unless/until another snapshot locks that one in place as well, of course.

Except in this case, because it's actually defrag that's doing it, the 
newly written file will be defraged, with the COW1 already having 
occurred and with further writes in-place on the defragged file, instead 
of setting up a situation where the first /future/ write to a block will 
COW1.

Remember, this is in the context of potential snapshots of the nocow 
file.  With (currently disabled due to scaling issues) snapshot-aware-
defrag, defrag would rewrite the pointers for all snapshots pointing to 
the moved extent when it did the defrag.  Without snapshot-aware-defrag 
(the current situation), defrag will only operate on what it's actually 
pointed at, breaking the link with previous snapshots, which will 
continue to point at the un_de_fragged extent (which might well be 
unfragmented for them anyway, if the modification-write that triggered 
the fragmentation in the first place, happened after the snapshot).

So if I'm reading things correctly, autodefrag doesn't so much disable 
nocow, as trigger a cow1/cow-once for the defrag, after which the file 
remains nocow, such that future writes will be in-place to the newly 
defragged extent(s), not the older, now fragmented, extents.

**BUT**, that situation will only occur in the context of a snapshot 
locking the previous copy in place and forcing a cow1 with the first 
write anyway, **OR** if the file was appended to beyond its original nocow 
size such that the new extent is separated from the old and must be 
defragged to combine.  Because in the general rewrite of a changed block 
into an existing file case, the existing nocow would have prevented the 
fragmentation in the first place, since the rewrite would have been in-
place.


So... this patch addresses what was already a bit of a corner-case, since 
btrfs doesn't claim to honor nocow unless it was set on the file before 
content was written to it, and nocow would normally prevent fragmentation 
when rewriting existing data, so the only way there would be 
fragmentation in the first place is (1) if a snapshot triggered a cow1, 
or (2) if the file grew beyond its original extent allocation, thus 
triggering further extents in other locations.

Well, there's actually a third case as well, that of the filesystem in 
general being so fragmented that the original nocow allocation was 
fragmentation-forced as there simply wasn't enough room to write it 
unfragmented.  However, on a btrfs where autodefrag has been used 
consistently from the time it first had data (as is the case with all my 
btrfs, I basically never mount /without/ autodefrag), that case should be 
relatively rare, as well, because autodefrag will be constantly policing 
and eliminating fragmentation, so (at least until the filesystem is near 
entirely full) the can't-find-anywhere-large-enough-to-write-the-
unfragmented-file case basically shouldn't occur.  Tho if the btrfs was 
already heavily fragmented before the autodefrag option was added, this 
case could definitely occur.



(Meanwhile, one more point of my-use-case-doesn't-trigger here.  For 
systemd/journald files, I have a hybrid configuration whereby I have 
journald set to same-session volatile/tmpfs storage only, so stuff like 
systemctl status <service> spits out the usual last-10 journal entries, 
etc, but syslog-ng handles the text-based logs I keep in non-volatile 
storage beyond the current session, configured such that "noise" messages 
never get written to the syslog-ng logs at all, and with routing to 
individual log files and/or the general messages log as I find 
appropriate for the service in question.  So journald doesn't write 
permanent journals and I have one less potential issue to worry about.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

