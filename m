Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49306 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeAAFXr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jan 2018 00:23:47 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eVsXT-00062p-8e
        for linux-btrfs@vger.kernel.org; Mon, 01 Jan 2018 06:21:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
Date: Mon, 1 Jan 2018 05:21:19 +0000 (UTC)
Message-ID: <pan$61851$35f92f40$b7544793$147901a@cox.net>
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stirling Westrup posted on Sun, 31 Dec 2017 19:48:15 -0500 as excerpted:

> Okay, I want to start this post with a HUGE THANK YOU THANK YOU THANK
> YOU to Nikolay Borisov and most especially to Qu Wenruo!
> 
> Thanks to their tireless help in answering all my dumb questions I have
> managed to get my BTRFS working again! As I speak I have the full,
> non-degraded, quad of drives mounted and am updating my latest backup of
> their contents.

I'm glad you were able to fix it.  Hopefully, some of what was learned 
from the experience can hope the devs make btrfs better, as well as, for 
you, reinforcing the sysadmin's first rule of backups that I'm rather 
known for quoting around here: The *real* value of data to an admin is 
defined not by any flimsy claims as to its value, but rather, by the 
number of backups an admin considers it worth having of that data.  If 
there's no backups, or none beyond level N, that's simply defining the 
data as not worth the time/trouble/resources necessary to do those 
backups (beyond level N), or flipped around, defining the time/trouble/
resources saved in /not/ doing the backups to be worth more than the data.

Thus, it can *always* be said that what was defined to be of most value 
was saved, either the data, if it was worth the trouble making the 
backup, or the time/trouble/resources necessary to make it if there was 
no backup.

Of course you had backups, but they weren't current.  However, the same 
rule applies then to the data in the delta between the backup and current 
state.  If it wasn't worth freshening your backups to capture backups of 
that delta as well, then by definition the data was worth less than the 
time/trouble/resources necessary to do that freshening.

... And FWIW, after finding myself in similar situations regarding backup 
updates here, but fortunately with btrfs' readable by btrfs restore...
I recently decided it was worth the money to upgrade to ssd backups as 
well as ssd working copies... precisely to lower the trouble threshold to 
updating those backups... and I'm happy to report that it's had exactly 
the effect I had hoped... I'm doing much more regular backups, keeping 
that maximum delta between working copy and first-line backup much 
smaller (days to weeks) than it was before (months to over a year (!!), 
so I'm walking the talk and holding myself to the same rules I preach! 
=:^)

> I had a 4-drive setup with 2x4T and 2x2T drives and one of the 2T drives
> failed, and with help I was able to make a 100% recovery of the lost
> data. I do have some observations on what I went through though. Take
> this as constructive criticism, or as a point for discussing additions
> to the recovery tools:
> 
> 1) I had a 2T drive die with exactly 3 hard-sector errors and those 3
> errors exactly coincided with the 3 super-blocks on the drive. The odds
> against this happening as random independent events is so unlikely as to
> be mind-boggling. (Something like odds of 1 in 10^26) So, I'm going to
> guess this wasn't random chance. Its possible that something inside the
> drive's layers of firmware is to blame, but it seems more likely to me
> that there must be some BTRFS process that can, under some conditions,
> try to update all superblocks as quickly as possible. I think it must be
> that a drive failure during this window managed to corrupt all three
> superblocks. It may be better to perform an update-readback-compare on
> each superblock before moving onto the next, so as to avoid this
> particular failure in the future. I doubt this would slow things down
> much as the superblocks must be cached in memory anyway.

I'd actually suspect something in the drive firmware or hardware... 
didn't like the fact that btrfs was *constantly* rewriting the *exact* 
same place, the copies of the superblock.

Because otherwise, as you say, the odds are simply too high that it would 
be /exactly/ those three blocks, not, say, two superblocks, and something 
else.

"They say" it's SSDs that work that way, not spinning rust, which is 
supposed to "not care" about how many times a particular block is 
rewritten, but more about spinning hours, etc.  However, I'd argue that 
the same rules that have applied to "spinning rust" for decades... don't 
necessarily hold any longer as the area of each bit or byte gets smaller 
and smaller, and /particularly/ so with the new point-heat-recording and 
shingled designs.  Indeed, I had already wondered personally about media-
point longevity given repeated point-heat-recording cycles, and the fact 
that btrfs superblocks are the /one/ thing that's not constantly COWed to 
different locations at every write, but remain at the exact same media 
address, rewritten for /every/ btrfs commit cycle, as they /must/ be, 
given the way btrfs works.

Of course that's why ssds have the FTL/firmware-translation-layer between 
the actual physical media and the filesystem layer, doing that COW at the 
device level, so no single hotspot address is rewritten many more times 
than the coldspot addresses.

And of course spinning rust has its firmware as well, tho at least in the 
public domain, they don't COW a sector until it actually dies.  But I 
actually suspect that some of them do SSD-like wear-leveling anyway, 
because I just don't see how the smaller and smaller physical bit-write 
areas can stand up to the repeated rewrite wear, otherwise.

But either there was something buggy with yours, that btrfs triggered 
with its superblock write pattern, or it simply didn't have the level of 
protection it needed, or perhaps some of both.

Anyway, as I said, the odds are simply too great.  There's simply no 
other explanation for it being the /exact/ three superblocks, spaced as 
they are precisely to /avoid/ ending up in the same physical weak-spot 
area by accident, that went out.

Which has significant implications for the below...

> 2) The recovery tools seem too dumb while thinking they are smarter than
> they are. There should be some way to tell the various tools to consider
> some subset of the drives in a system as worth considering. Not knowing
> that a superblock was a single 4096-byte sector, I had primed my
> recovery by copying a valid superblock from one drive to the clone of my
> broken drive before starting the ddrescue of the failing drive. I had
> hoped that I could piece together a valid superblock from a good drive,
> and whatever I could recover from the failing one. In the end this
> turned out to be a useful strategy, but meanwhile I had two drives that
> both claimed to be drive 2 of 4, and no drive claiming to be drive 1 of
> 4. The tools completely failed to deal with this case and were
> consistently preferring to read the bogus drive 2 instead of the real
> drive 2, and it wasn't until I deliberately patched over the magic in
> the cloned drive that I could use the various recovery tools without
> bizarre and spurious errors. I understand how this was never an
> anticipated scenario for the recovery process, but if its happened once,
> it could happen again. Just dealing with a failing drive and its clone
> both available in one system could cause this.

Of course btrfs has known problems with clones that duplicate the GUID, 
as many cloning tools do, where both the clone and the working copy are 
available to btrfs at the same time.  This is because btrfs, unlike most 
filesystems being multi-device, needed /some/ way to uniquely identify 
each filesystem, and as here, each device of each filesystem, and the 
"Globally Unique Identification", aka GUID, aka UUID (universally unique 
ID), was taken as *exactly* what it says in the name, globally/
universally unique.  That's one of the design assumptions of btrfs, 
written into the code at a level that really can't be changed at this 
late date, many years into the process.  And btrfs really /does/ have 
known data corruption potential when those IDs don't turn out to be 
unique after all.

Which is why admins that have done their due diligence researching the 
filesystems they're trusting with the integrity of their data, know that 
if they're using replication methods that expose multiple devices with 
the same GUIDs/UUIDs, they *MUST* take care to expose to btrfs only one 
instance of those UUIDs/GUIDs at a time.  Because there's a very real 
danger of data corruption if btrfs sees two supposedly "unique" IDs, as 
it can and sometimes does get /very/ confused by that.

Unfortunately, as btrfs becomes more widespread and common-place, beyond 
the level of admin that really researches a filesystem before they put 
their trust in it, a lot of btrfs-using admins are ending up learning 
this the hard way... unfortunately.

Tho arguably, the good part of it is that just as admins coming from the 
MS side of things had to learn all about mounting and unmounting, and 
what to avoid to avoid the trap of data corruption due to pulling a 
(removable) device without cleanly unmounting it, as btrfs becomes more 
common, people will eventually learn the btrfs rules of safe data 
behavior as well.

Tho equally arguably, that among several reasons may be enough to keep 
btrfs from ever becoming the mainstream replacement for and successor to 
the ext* line that it was intended to be.  Oh, well...  Every filesystem 
has its strengths and weaknesses, and a good admin will learn to 
appreciate them and use a filesystem appropriate to the use-case, while 
not so good admins... generally end up suffering more than necessary, as 
they fight with filesystems in use-cases that they are simply not the 
best choice out there at supporting.

Of course the alternative would be a limited-choice ecosystem like MS, 
where there's only basically two FS choices, some version of the 
venerable FAT, or some version of NTFS, both choices among many others 
available to Linux/*IX users, as well.  Fine for some, but "No thanks, 
I'll keep my broad array of choices, thank you very much!" for me. =:^)

> 3) There don't appear to be any tools designed for dumping a full
> superblock in hex notation, or for patching a superblock in place.
> Seeing as I was forced to use a hex editor to do exactly that, and then
> go through hoops to generate a correct CSUM for the patched block, I
> would certainly have preferred there to be some sort of utility to do
> the patching for me.

100% agreed, here.  Of course that's one reason among many that btrfs 
remains "still stabilizing, not yet fully stable and mature", precisely 
because there's various holes like this one remaining in the btrfs 
toolset.

It is said that the air force jocks of some nations semi-euphemistically 
describe a situation in which they are vastly outnumbered as a "target 
rich environment."  Whatever the truth of /that/, by analogy it's 
definitely the case that btrfs remains a "development-opportunity rich 
environment" in terms of improvement possibilities remaining to be 
developed.  There's certainly more ideas for improvement than there is 
time and devs to implement, test, bugfix, and test some more, all those 
ideas, and this is one more that it'd definitely be nice to have!

But given how closely you worked with the devs to get your situation 
fixed, and thus the knowledge of your specific tool-case they now have, 
the chances of actually getting this implemented in something approaching 
reasonably useful time, is better than most. =:^)

> 4) Despite having lost all 3 superblocks on one drive in a 4-drive setup
> (RAID0 Data with RAID1 Metadata), it was possible to derive all missing
> information needed to rebuild the lost superblock from the existing good
> drives. I don't know how often it can be done, or if it was due to some
> peculiarity of the particular RAID configuration I was using, or what.
> But seeing as this IS possible at least under some circumstances, it
> would be useful to have some recovery tools that knew what those
> circumstances were, and could make use of them.

Of course raid0 in any form is considered among admins to be for the 
"don't-care-if-we-lose-it, it's throw-away-data", either because it 
actually /is/ throw-away data, or because there's at least one extra 
level of backups in case the raid0 /does/ die, use-case.

By that argument there's limited benefit to any investment in raid0 mode 
recovery, because nobody sane uses it for anything of greater than "throw-
away" value anyway.

Tho OTOH, given that raid1-metadata/single-data (which roughly equates to 
raid0-data) is the btrfs-multi-device effective default... arguably, 
either that default should be changed to raid1/10 for data as well as 
metadata, or at least there's /some/ support for prioritizing 
implementation of tools such as those that would have helped automate the 
process, here.

Personally, I'd argue for changing the default to raid1 2-3 device, raid10 
4+ device, but maybe that's just me...

> 5) Finally, I want to comment on the fact that each drive only stored up
> to 3 superblocks. Knowing how important they are to system integrity, I
> would have been happy to have had 5 or 10 such blocks, or had each drive
> keep one copy of each superblock for each other drive. At 4K per
> superblock, this would seem a trivial amount to store even in a huge
> raid with 64 or 128 drives in it. Could there be some method introduced
> for keeping far more redundant metainformation around? I admit I'm
> unclear on what the optimal numbers of these things would be. Certainly
> if I hadn't lost all 3 superblocks at once, I might have thought that
> number adequate.

If indeed I'm correct that the odds of it being ALL three of the 
superblocks that failed, and ONLY the superblocks, strongly indicate a 
mismatch between hardware/firmware and the btrfs superblock constant 
rewrite to the /exact/ same address pattern, then...

Making it 5 or 10 or 100 or 1000 such blocks won't help much.

OTOH, I'm rather intrigued by the idea of keeping one copy of each of 
the /other/ devices' superblocks on all devices.  I'd consider that idea 
worth further discussion anyway, tho it's quite possible that performance 
or other considerations make it simply impractical to implement, and even 
if practical to implement in the general sense, it'd certainly require an 
on-device format update, and those aren't done lightly or often, as all 
formats from the original mainlined one must be supported going forward.  
But it's definitely an idea I'd like to see further discussed, even if 
it's simply to point out the holes in the idea I'm just not seeing, from 
my viewpoint that's definitely much closer to admin than dev.

Tho while I do rather like the idea, given the above, even keeping 
additional superblock copies on all the other devices isn't necessarily 
going to help much, particularly when it's all similar devices, 
presumably with similar firmware and media weak-points.

But other-device superblocks very well could have helped in a situation 
like yours, where there were two different device sizes and potentially 
brands...

> Anyway, I hope no one takes these criticisms the wrong way. I'm a huge
> fan of BTRFS and its potential, and I know its still early days for the
> code base, and it's yet to fully mature in its recovery and diagnostic
> tools. I'm just hoping that these points can contribute in some small
> way and give back some of the help I got in fixing my system!

I believe you've very likely done just that. =:^)

And even if your case doesn't result in tools to automate superblock 
restoration in cases such as yours in the immediate to near-term (say to 
three years out), it has very definitely already resulted in regulars 
that now have experience with the problem and should now find it /much/ 
easier to tackle a similar problem the next time it comes up!  And as you 
say, it almost certainly /will/ come up again, because it's not /that/ 
unreasonable or uncommon a situation to find oneself in, after all!

But definitely, the best-case would be if it results in the tools 
learning how to automate the process so people that have no clue what a 
hex editor even is can still have at least /some/ chance of recovering 
from it, where we're just lucky here that someone with the technical 
skill and just as importantly the time/motivation/determination to either 
get a fix or know exactly why it /could-not/ be fixed, happened to have 
the problem, not someone more like me that /might/ have the technical 
skill, but would be far more likely to just accept the damage as reality 
and fall back to the backups such as they are, than actually invest the 
time in either getting that fix or knowing for sure that it /can't/ be 
fixed.

The signature I've seen, something about the unreasonable man refusing to 
accept reality, thereby making his own, and /thereby/, changing it for 
the good, for everyone, thus progress depending on the unreasonable man, 
comes to mind. =:^)

Yes, I suppose I /did/ just call you "unreasonable", but that's a rather 
extreme compliment, in this case! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

