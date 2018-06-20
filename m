Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38673 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752725AbeFTIdi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 04:33:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fVYWT-0008Uw-3q
        for linux-btrfs@vger.kernel.org; Wed, 20 Jun 2018 10:31:25 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID56
Date: Wed, 20 Jun 2018 08:31:19 +0000 (UTC)
Message-ID: <pan$5b36b$e29a9693$2c5705da$6ebdcc0d@cox.net>
References: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gandalf Corvotempesta posted on Tue, 19 Jun 2018 17:26:59 +0200 as
excerpted:

> Another kernel release was made.
> Any improvements in RAID56?

<meta> Btrfs feature improvements come in "btrfs time".  Think long term, 
multiple releases, even multiple years (5 releases per year). </meta>

In fact, btrfs raid56 is a good example.  Originally it was supposed to 
be in kernel 3.6 (or even before, but 3.5 is when I really started 
getting into btrfs enough to know), but for various reasons primarily 
involving the complexity of the feature as well as btrfs itself and the 
number of devs actually working on btrfs, even partial raid56 support 
didn't get added until 3.9, and still-buggy full support for raid56 scrub 
and device replace wasn't there until 3.19, with 4.3 fixing some bugs 
while others remained hidden for many releases until they were finally 
fixed in 4.12.

Since 4.12, btrfs raid56 mode, as such, has the known major bugs fixed 
and is ready for "still cautious use"[1], but for rather technical 
reasons discussed below, may not actually meet people's general 
expectations for what btrfs raid56 should be in reliability terms.

And that's the long term 3+ years out bit that waxhead was talking about.

> I didn't see any changes in that sector, is something still being worked
> on or it's stuck waiting for something ?

Actually, if you look on the wiki page, there were indeed raid56 changes 
in 4.17.

https://btrfs.wiki.kernel.org/index.php/Changelog#v4.17_.28Jun_2018.29

<quote>
* raid56:
** make sure target is identical to source when raid56 rebuild fails 
after dev-replace
** faster rebuild during scrub, batch by stripes and not block-by-block
** make more use of cached data when rebuilding from a missing device
</quote>

Tho that's actually the small stuff, "ignoring the elephant in the room" 
raid56 reliability expectations mentioned earlier as likely taking years 
to deal with.

As for those long term issues...

The "elephant in the room" problem is simply the parity-raid "write hole" 
common to all parity-raid systems, unless they've taken specific measures 
to work around the issue in one way or another.


In simple terms, the "write hole" problem is just that parity-raid makes 
the assumption that an update to a stripe including its parity is atomic, 
it happens all at once, so that it's impossible for the parity to be out 
of sync with the data actually written on all the other stripe-component 
devices.  In "real life", that's an invalid assumption.  Should the 
system crash at the wrong time, in the middle of a stripe update, it's 
quite possible that the parity will not match what's actually written to 
the data devices in the stripe, because either the parity will have been 
updated while at least one data device was still writing at the time of 
the crash, or the data will be updated but the parity device won't have 
finished writing yet at the time of the crash.  Either way, the parity 
doesn't match the data that's actually in the stripe, and should a device 
be/go missing so the parity is actually needed to recover the missing 
data, that missing data will be calculated incorrectly because the parity 
doesn't match what the data actually was.

Now as I already stated, that's a known problem common to parity-raid in 
general, so it's not unique at all to btrfs.

The problem specific to btrfs, however, is that in general it's copy-on-
write, with checksumming to guard against invalid data, so in general, it 
provides higher guarantees of data integrity than does a normal update-in-
place filesystem, and it'd be quite reasonable for someone to expect 
those guarantees to extend to btrfs raid56 mode as well, but they don't.

They don't, because while btrfs in general is copy-on-write and thus 
atomic update (in the event of a crash you get either the data as it was 
before the write or the completely written data, not some unpredictable 
mix of before and after), btrfs parity-raid stripes are *NOT* copy-on-
write, they're update-in-place, meaning the write-hole problem applies, 
and in the event of a crash when the parity-raid was already degraded, 
the integrity of the data or metadata being parity-raid written at the 
time of the crash is not guaranteed, nor at present, with the current 
raid56 implementation, /can/ it be guaranteed.

But as I said, the write hole problem is common to parity-raid in 
general, so for people that understand the problem and are prepared to 
deal with the reliability implications it implies[3], btrfs raid56 mode 
should be reasonably ready for still cautious use, even tho it doesn't 
carry the same data integrity and reliability guarantees that btrfs in 
general does.

As for working around or avoiding the write-hole problem entirely, 
there's (at least) four possible solutions, each with their own drawbacks.

The arguably "most proper" but also longest term solution would be to 
rewrite btrfs raid56 mode so it does copy-on-write for partial-stripes in 
parity-mode as well (full-stripe-width writes are already COW, I 
believe).  This involves an on-disk format change and creation of a new 
stripe-metadata tree to track in-use stripes.  This tree, as the various 
other btrfs metadata trees, would be cascade-updated atomically, so at 
any transaction commit, either all tracked changes since the last commit 
would be complete and the new tree would be valid, or the last commit 
tree would remain active and none of the pending changes would be 
effective in the case of a crash and reboot with a new mount.

But that would be a major enough rewrite it would take years to write and 
then test again to current raid56 stability levels.

A second possible solution would be to enforce a "whole-stripe-write-
only" rule.  Partial stripes wouldn't be written, only full stripes 
(which are already COWed), thus avoiding the read-modify-write cycle of a 
partial stripe.  If there wasn't enough changed data to write a full 
stripe, the rest of it would be empty, wasting space.  A periodic 
rebalance would be needed to rewrite all these partially empty stripes to 
full stripes, and presumably a new balance filter would be created to 
rebalance /only/ partially empty stripes.

This would require less code and could be done sooner, but of course 
would require testing to stability of the new code that was written, and 
it has the significant negative of all that wasted space in the partially 
empty stripe writes and the periodic rebalance required to make space 
usage efficient again.

A third possible solution would allow stripes of less than the full 
possible width -- a small write could involve just two devices in raid5, 
three in raid6, just one data strip and the one or two parity strips.

This one's likely the easiest so far to implement since btrfs will 
already reduce stripe width in the mixed-device-size case when small 
devices fill up, and similarly, deals with less-than-full-width stripes 
when a new device is added, until a rebalance is done to rewrite existing 
stripes to full width including the new device.  So the code to deal with 
mixed-width stripes is already there and tested, and the only thing to be 
done for this one would be to change the allocator implementation to 
allow routine writing of less than than full width stripes (currently it 
always writes a stripe as wide as possible), and to choose the stripe 
width dynamically based on the amount of data to be written.

Of course these "short stripes" would waste space as well, since they'd 
still require the full one (raid5) or two (raid6) parity strips even if 
it was only one data strip written, and a periodic rebalance would be 
necessary to rewrite to full stripe width and regain the wasted space 
here too.

Solution #4 is the one I believe we've already seen RFC patches for.  
It's a pure workaround, not a fix, and involves a stripe-write log.  
Partial-stripe-width writes would be first written to the log, then 
rewritten to the destination stripe.  In this way it'd be much like ext3's 
data=journal mode, except that only partial stripe writes would need 
logged (full stripe writes are already COW and thus atomic).

This would arguably be the easiest to implement since it'd only involve 
writing the logging code, indeed, as I mentioned above I believe RFC 
level patches have already been posted, and the failure mode for bugs 
would at least in theory be simply the same situation we already have 
now.  And it wouldn't waste space or require rebalances to get it back 
like the two middle solutions, tho the partial-stripe log would take some 
space overhead.

But writing stuff twice is going to be slow, and the speed penalty would 
be taken on top of the already known to be slow parity-raid partial-
stripe-width read-modify-write cycle.

But as mentioned, parity-raid *is* already known to be slow, and admins 
with raid experience are already only going to chose it when top speed 
isn't their top priority, and the write-twice logging penalty would only 
apply to partial-stripe-writes, so it might actually be an acceptable 
trade-off, particularly when it's the likely quickest solution to the 
existing write-hole problem, and is very similar to the solution mdraid 
already took for its parity-raid write-hole problem.

But, given the speed at which btrfs feature additions occur, even the 
arguably fastest to implement and rfc-patches-posted logging choice is 
likely to take a number of kernel cycles to mainline and test to 
stability equivalent to the rest of the btrfs raid56 code.  And that's if 
it were agreed to be the correct solution, at least for the short term 
pending a longer term fix of one of the other choices, a question that 
I'm not sure has been settled yet.

> Based on official BTRFS status page, RAID56 is the only "unstable" item
> marked in red.
> No interested from Suse in fixing that?

As the above should make clear, it's _not_ a question as simple as 
"interest"!

> I think it's the real missing part for a feature-complete filesystem.
> Nowadays parity raid is mandatory, we can't only rely on mirroring.

"Nowdays"?  "Mandatory"?

Parity-raid is certainly nice, but mandatory, especially when there's 
already other parity solutions (both hardware and software) available 
that btrfs can be run on top of, should a parity-raid solution be /that/ 
necessary?  Of course btrfs isn't the only next-gen fs out there, either, 
there's other solutions such as zfs available too, if btrfs doesn't have 
the features required at the maturity required.

So I'd like to see the supporting argument to parity-raid being mandatory 
for btrfs, first, before I'll take it as a given.  Nice, sure.  
Mandatory?  Call me skeptical.

---
[1] "Still cautious" use:  In addition to the raid56-specific reliability 
issues described above, as well as to cover Waxhead's referral to my 
usual backups advice:

Sysadmin's[2] first rule of data value and backups:  The real value of 
your data is not defined by any arbitrary claims, but rather by how many 
backups you consider it worth having of that data.  No backups simply 
defines the data as of such trivial value that it's worth less than the 
time/trouble/resources necessary to do and have at least one level of 
backup.

With such a definition, data loss can never be a big deal, because even 
in the event of data loss, what was defined as of most importance, the 
time/trouble/resources necessary to have a backup (or at least one more 
level of backup, in the event there were backups but they failed too), 
was saved.  So regardless of whether the data was recoverable or not, you 
*ALWAYS* save what you defined as most important, either the data if you 
had a backup to retrieve it from, or the time/trouble/resources necessary 
to make that backup, if you didn't have it because saving that time/
trouble/resources was considered more important than making that backup.

Of course the sysadmin's second rule of backups is that it's not a 
backup, merely a potential backup, until you've tested that you can 
actually recover the data from it in similar conditions to those under 
which you'd need to recover it.  IOW, boot to the backup or to the 
recovery environment, and be sure the backup's actually readable and can 
be recovered from using only the resources available in the recovery 
environment, then reboot back to the normal or recovered environment and 
be sure that what you recovered from the recovery environment is actually 
bootable or readable in the normal environment.  Once that's done, THEN 
it can be considered a real backup.

"Still cautious use" is simply ensuring that you're following the above 
rules, as any good admin will be regardless, and that those backups are 
actually available and recoverable in a timely manner should that be 
necessary.  IOW, an only backup "to the cloud" that's going to take a 
week to download and recover to, isn't "still cautious use", if you can 
only afford a few hours down time.  Unfortunately, that's a real life 
scenario I've seen people say they're in here more than once.

[2] Sysadmin:  As used here, "sysadmin" simply refers to the person who 
has the choice of btrfs, as compared to say ext4, in the first place, 
that is, the literal admin of at least one system, regardless of whether 
that's administering just their own single personal system, or thousands 
of systems across dozens of locations in some large corporation or 
government institution.

[3] Raid56 mode reliability implications:  For raid56 data, this isn't 
/that/ big of a deal, tho depending on what's in the rest of the stripe, 
it could still affect files not otherwise written in some time.  For 
metadata, however, it's a huge deal, since an incorrectly reconstructed 
metadata stripe could take out much or all of the filesystem, depending 
on what metadata was actually in that stripe.  This is where waxhead's 
recommendation to use raid1/10 for metadata even if using raid56 for data 
comes in.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

