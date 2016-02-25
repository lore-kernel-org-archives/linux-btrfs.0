Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47043 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbcBYESq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 23:18:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aYnNy-0000E8-KT
	for linux-btrfs@vger.kernel.org; Thu, 25 Feb 2016 05:18:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 05:18:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 05:18:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fun BTRFS Stuff:
Date: Thu, 25 Feb 2016 04:18:35 +0000 (UTC)
Message-ID: <pan$82aac$c47b9e27$853df747$d57f4d4c@cox.net>
References: <56CB737D.1020403@polarismail.net>
	<20160222211142.GD4913@merlins.org> <20160222211845.GA14504@carfax.org.uk>
	<pan$a88ba$a1bf6bdd$c5860865$1a0b0320@cox.net>
	<CAPmG0jYQgWcv1cGS5ZPBXj819OTU97tVzZ+KxRg1sQsCpy+jCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Thu, 25 Feb 2016 03:07:12 +0100 as excerpted:

> On Tue, Feb 23, 2016 at 1:19 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> I've not seen anyone else explicitly list the following as a practical
>> btrfs send/receive backup strategy, but it does rather directly follow
>> from the STDOUT/STDIN usage of the tools as practical, at least in
>> theory.  My primary worry would be the general one of btrfs maturity,
>> that it and the tools including btrfs send and receive are still
>> stabilizing and maturing, with occasional bugs being found, and the
>> following strategy won't find the receive bugs until restore time, at
>> which point you might be depending on it working, so the strategy is
>> really only appropriate once btrfs has settled down and matured
>> somewhat more.
>>
>> So here's the idea.
>>
>> 1) Btrfs send directly to files on some other filesystem, perhaps xfs,
>> intended to be used with larger files.  This can either be non-
>> incremental, or (much like full and incremental tape backups) initial
>> full, plus incremental sends.
> 
> I had not thought of the tape-archive method, interesting :)
> I am using this more or less, although not fully automated. It looks
> like:
> 
> btrfs send -p snap_base snap_last | tee
> /path-on-non-btrfs-fs/snap_base..snap_last.btrfs | btrfs receive
> /path-on-btrfs-fs/
> 
> The key thing is to keep diff as small as possible to that I can
> transport them over ~1 Mbps internet. But sometime the diff is huge,
> for example when an upgrade of an OS in a VM has been done. So then I
> carry the snap_last.btrfs 'by hand'.
> 
> If you mean sort of :  xfs receive /path-on-xfs-fs/  for the last step
> in the commadline pipe then this 'xfs receive'  implementation would
> face quite some challenges I think, but not impossible I think

No, I meant pretty much what you are doing, except just directing to a 
file, instead of using tee and sending it to btrfs receive as well, as 
the usage of tee is a variant I hadn't thought of, but is actually a 
quite creative solution to the problem you describe. =:^)

The reason I suggested xfs is that, based on what I know at least, xfs is 
supposed to be real good at handling large files, generally using a large 
block size, etc.  Perfect for long-term storage of likely multi-gig 
serialized backup streams.  But something like fat32, setup with a large 
block size, should work well too, and its lack of ownership metadata 
shouldn't really be an issue when the files are all simply rather large 
stream backups.

And actually, to make the parallel to tape backup even more direct, I 
/believe/ you could potentially use tar or the like for its original 
purpose as a tape-archive, feeding the streams via tar directly to raw 
device without a filesystem at all, just tar, which I /believe/ would 
provide indexing and let you later write a second (incremental) btrfs 
send file after the first one, and later a third after the second, etc.  
Except I'm not actually familiar with using tar that way, and it's quite 
possible tar doesn't work the way I think it does in that regard and/or 
simply isn't the best tool for that job.  But in theory at least, as long 
as you either manually tracked the blocks used for each send stream, or 
had something like tar doing it automatically, you wouldn't even need a 
proper filesystem and could use a raw device, either block device like a 
big multi-terabyte disk, or even a char/stream device like an archiving 
tape-drive.

>> 2) Store the backups as those send files, much like tape backup
>> archives.  One option would be to do the initial full send, and then
>> incremental sends as new files, until the multi-TB drive containing the
>> backups is full, at which point replace it and start with a new full
>> send to the fresh xfs or whatever on the new drive.
> 
> The issue here is that at the point you do a new full backup, you will
> need more than double the space of the original in order to still have a
> valid backup all the time. If it is backing up 'small SSD' to 'big HDD',
> then not such an issue

The idea here would be to rotate backup media.  But you are correct, in 
simplest form you'd need larger backup media than the original being 
backed up, tho that might be small ssd to big hdd, or simply 1 TB hdd to 
say one of those huge 8 TB SMR drives, which I believe are actually 
/intended/ for long-term archiving in this manner.

So taking that 1 TB hdd to 8 TB SMR archiving hdd example, you wouldn't 
let the 1 TB get totally full, so say 700 GB of data in the original full 
send.  Then say incrementals average 50 GB.  (We're using units-of-ten 
here instead of GiB/TiB just to make it easier.  After all, this is only 
an illustration.)

8 TB - 700 GB = 7.3 TB = 7300 GB left.  7300 GB / 50 GB = space for 146 
incrementals averaging 50 GB each.  So say that's 50 GB per day average 
with daily incrementals.  That'll fill roughly 2.5 8 TB archive drives 
per year, so to make the numbers nice and round, say five drives in 
rotation, keeping two year's worth of backups.

And each time you switch out archive drives, at least twice a year, you 
start with a full send, so you have it conveniently there on the same 
device as the incrementals and don't have to worry about tracking a 
second drive with the full send before you can replay your incrementals.

Of course if your primary/working and backup media are closer to the same 
size, perhaps a 4 device by 4 GB btrfs raid10, 8 GB usable space, working 
copy, 8 GB archive backups, with a correspondingly larger average 
incremental send size as well, you'd use pairs of backup devices, one for 
the full send, one for the backups, and rotate in a second 8 GB each 
device pair when the first pair got full.  And there's all sorts of 
individual variants on the same theme.

> 
> 
>> 3) When a restore is needed, then and only then, play back those
>> backups to a newly created btrfs using btrfs receive.  If the above
>> initial full plus incrementals until the backup media is full strategy
>> is used, the incrementals can be played back against the initial full,
>> just as the send was originally done.
> 
> Yes indeed. My motivation for this method was/is that unpacking (so
> doing the  btrfs receive ) takes time if is is a huge number of small
> files on a HDD

And the advantage, until a restore is actually needed, no playback is 
done.  So in the above five archive devices over two years case, if the 
production copy continues working for two years, that's say four full 
sends and 146*4 incrementals that will never need played back at all, 
thus reclaiming the time and energy that would have been unnecessarily 
spent maintaining the played back copy over that period.

>> Seems to me this should work fine, except as I said, that receive
>> errors would only be caught at the time receive is actually run, which
>> would be on restore.  But as most of those errors tend to be due to
>> incremental bugs, doing full sends all the time would eliminate them,
>> at the cost of much higher space usage over time, of course.  And if
>> incrementals /are/ done, with any luck, replay won't be for quite some
>> time and thus using a much newer and hopefully more mature btrfs
>> receive, with fewer bugs due to the bugs caught in the intervening
>> time.  Additionally, with any luck,
>> several generations of full backup plus incrementals will have been
>> done before the need to replay even one set, thus sparing the need to
>> reply the intervening sets entirely.
> 
> On the other hand, not replaying them makes it that they cannot be used
> for a lower performance backup or clone server and there is no way to
> check the actual state.  And there could also be silent send errors.
> If you do playback immediately, creating a writable snapshot on master
> and clone(s) sides allows online checking potential diffs (rsync -c )
> and copying the differences.

That being the primary disadvantage I suggested, and the reason one 
probably would not want to use this method until btrfs including send/
receive are fully stabilized, because simply put, it's not yet stable 
enough to actually trust without verification, that it'd actually receive 
properly, at this point.

But once btrfs is fully stable and people are routinely using send/
receive without known bugs for quite some time, then this scenario may 
well be quite viable.

> Using   btrfs sub find-new , I once then discovered some 100 MB
> difference in a multi-TB data set. It were only 2 OS/VM image files,
> on different clones. It probably has happened sometime early 2015, but
> quite unsure, so not sure which kernel/tools.

To my knowledge, there has been exactly one such known bug, since the 
initial feature introduction bugs were worked thru anyway, where a 
successful send and receive didn't produce a valid copy, and AFAIK, that 
didn't actually turn out to be a send/receive bug, but ultimately traced 
to a more general btrfs bug, and it was simply send/receive that happened 
to catch it.

So it'd be interesting to have more information about that event and 
track down what happened.  But it's likely to be way too late, with way 
too little reliable information about it still available, to do anything 
about it now.


Meanwhile, most of the bugs I'm aware of anyway have been in receive 
processing various corner-cases.  And as I pointed out, if you aren't 
replaying/receiving immediately, but instead, archiving the raw send 
streams to be replayed later, in the event you /do/ need to replay that 
stream to receive, receive will have matured further in the mean time, 
compared to if you played back the stream to a receive of the same 
version as the send used to produce the stream.  If it's two years later, 
that's two years worth of further bugs that have been fixed in the mean 
time, so in theory at least, chances for a successful replay and receive 
should better after waiting than they would have been had the replay been 
done immediately.

Which /somewhat/ counteracts the problem of btrfs receive in particular 
not yet being totally mature.  However, it doesn't entirely counteract 
the problem, and I'd still consider this solution to be too dangerous to 
use in practice at the current time.  Tho in say five years, it should be 
a much more reasonably viable solution to consider.


But I /really/ like your tee idea in this regard. =:^)  For people doing 
multiple levels of backup, that lets them enjoy the best of both worlds, 
while effectively taking care of two levels of backup at the same time.  
By teeing and replaying immediately (or simply replaying the stored send 
stream immediately, then keeping it instead of deleting it), you test 
that it works, and end up with the working btrfs level of backup.  By 
then continuing to archive the now tested send stream, you have a second 
level of backup, that can be replayed again, should something happen to 
both the production version and the btrfs level backup that you were 
replaying to for testing and primary backup.

That effectively gives you the best of both worlds. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

