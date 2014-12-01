Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49713 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaLAFfA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 00:35:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvJdS-0006Nm-V7
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 06:34:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 06:34:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 06:34:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Considerations in snapshotting and send/receive of nocow files?
Date: Mon, 1 Dec 2014 05:34:46 +0000 (UTC)
Message-ID: <pan$8e3a5$18bdca38$99baa082$7c959fe@cox.net>
References: <CAH-HCWVmRUqSTX5_rMjDOxCysGfeZ47hyTN_ObRKomyxSTwK9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shriramana Sharma posted on Sun, 30 Nov 2014 19:17:42 +0530 as excerpted:

> Given that snapshotting effectively reduces the usefulness of nocow, I
> suppose the preferable model to snapshotting and send/receiving such
> files would be different than other files.
> 
> Should nocow files (for me only VBox images) preferably be:
> 
> 1) under a separate subvolume?
> 
> 2) said subvol snapshotted less often?
> 
> 3) sent/received any differently?

If you look back in the list history at the nocow threads, you'll see a 
lot of my answers to exactly this sort of question.

In general I'd say "yes" to 1 and 2, separate subvolume, in part to allow 
snapshotting it less often.  For 3, I don't deal directly with send/
receive for my own use case and it's complex enough that I've not become 
as familiar with it as I have the general fragmentation issue, but 
because send does require creating a read-only snapshot, I'd characterize 
#3 as depending on #2, and would thus suggest treating it differently to 
the extent that you keep send and therefore snapshotting to the low side 
of your reasonable range.

Here's the reasoning in a more detailed step-by-step fashion.  (I'll use 
lettered points here to avoid confusing them with your numbered points 
above, which I may wish to reference below as well.)

A) The basic issue in principle: As you've apparently found from your 
research, snapshotting and nocow can be used together but disrupt 
absolute nocow, because a snapshot locks in place the existing version of 
the file, forcing a COW on the initial change written to a (4 KiB) file 
block after a snapshot covering the same file.  The file does remain 
nocow, however, and further changes written to the same file block will 
be nocow -- until the next snapshot forces another lock-in-place, of 
course.

B) The biggest immediate practical problem leading from A is that of high-
frequency automated snapshotting -- some people are going wild and 
snapshotting as often as once a minute... at least until they see some of 
the issues that can cause (like snapshots happening nearly instantly but 
snapshot deletion often taking longer than a minute, and the current 
scaling issues involved once there's several hundreds or thousands of 
snapshots to deal with).  On a busy VM triggering change-writes with a 
similar 1 minute or lower frequency, the snapshotting very quickly 
eliminates much of the anti-fragmentation benefit of nocow in the first 
place.

C) On a more general level once again, it should be easily apparent that 
the more change-writes you can squeeze between snapshots, the more 
effective the nocow is going to be, because a higher percentage of them 
will still be nocow.

D) That leads pretty directly to your points 1 and 2, put the nocow files 
on their own subvolume so snapshotting the parent doesn't affect them, 
and then snapshot the nocow subvolume at a lower frequency, as low a 
frequency as can reasonably fit within your use-case target range.  For 
example, for a normally daily snapshot scenario you might snapshot the 
parent daily and the nocow subvolume every other day or twice a week.  
For a normal 4X-daily snapshot scenario (every six hours on a 24-hour 
schedule or every two hours on an 8-hour-shift schedule), you might 
snapshot the nocow subvolume only once or twice a day.  Tho of course if 
the primary goal is the snapshotting of the nocow files (the VMs in your 
case), then you may still be snapshotting it at a higher frequency than 
the parent, which you may not in fact be snapshotting at all.  The point 
remains, snapshot the nocow subvolume at as low a frequency as can 
reasonably fit your use-case/goals.

E) Regarding your point #3, since send must be done from a read-only 
snapshot, obviously you'll need to snapshot at a frequency that at 
minimum equals that of your sends.  However, if your VMs are low activity 
enough that there's a reasonable chance they won't have written any 
changes during the send, and the send is the primary reason for the 
snapshot in the first place, you may avoid /some/ of the issue by 
deleting most snapshots as soon after the send as possible.

It would work like this.  You'd do your initial full send, creating an 
initial reference on both sides, with that snapshot retained on both 
sides /as/ that initial reference.  At your primary sending frequency, 
say once a day, you'd do the send against the original parent and delete 
the sending snapshot as soon as the send completed, thus making each 
daily incremental against the original.  At a lower frequency, perhaps 
once a week or once a month, you'd retain the sending snapshot but use 
the mitigation measures discussed in F below, and could then delete older 
initially-retained-weeklies and the original full-reference, perhaps 
keeping say two quarterly snapshots on the send side.

Then if you needed to reverse the send/receive, you'd still have the last 
weekly as a reference on both sides and could replay the last daily 
parented against it that you deleted on the one side to get back to the 
current day.  If you lost the last weekly as well, you could similarly 
replay the last weekly from the last quarterly.  Of course if you lost 
everything and were doing a full restore, you'd simply do a full send 
from the backup, without a reference to a parent on the (now) receive 
side.

F) Snapshotting effect mitigation:  A number of people using a 
snapshotting scheme such as the above have reported that while the nocow 
files they had were over the size btrfs' autodefrag mount option could 
reasonably handle, by choosing a snapshotting frequency at the low end of 
their target range they were able to reduce but not eliminate 
fragmentation, such that periodic defrag was effective mitigation for the 
remaining fragmentation.

Using the same daily-snapshot/send/delete, weekly-snapshot/send/retain 
example scenario as in #E, a weekly or biweekly defrag of the files in 
the nocow subvolume should help keep operational snapshot-effect 
fragmentation from getting /too/ extreme, and as I said, a similar defrag 
schedule has been reported by a number of people to work reasonably well, 
keeping fragmentation-related performance loss within reasonable bounds.

G) Defrag caveat:  Note that due to scaling issues, btrfs' defrag is not 
snapshot-aware.  Thus a scheduled defrag such as that suggested in #F 
would defrag only the files in the mounted subvolume it was pointed at, 
leaving the same files in retained snapshots fragmented.  To the extent 
that defrag actually does anything, moving blocks around to defrag files 
and breaking the reflinks to the snapshotted version, it will thus 
duplicate the actual space required by those file blocks.  If a file 
isn't fragmented, of course, it won't need moved and thus won't break the 
snapshot reflinks and require additional data space.

Assuming your filesystem data usage is comfortably under 50% and that you 
are deleting snapshots in a timely manner, the multiplying data effect 
should remain reasonable and manageable, however.  It won't multiply 
without bounds as long as you're deleting old snapshots and thus the 
multiple separate (defrag-broken reflinks) copies of the snapshotted data 
in a timely manner.

In the given scenario, you'd be defraging say once a week, with a daily 
snapshot/send/delete parented against a weekly snapshot/send/retain, 
which in turn would be parented against a quarterly snapshot/send/retain, 
with the intervening weeklies deleted.  There would thus be a maximum of 
two quarterly retained snapshots plus a weekly and a daily.  But the 
defrag would only be weekly and could be scheduled before the weekly 
retained snapshot, so data usage would be capped at 4X, 2X for the 
quarterly snapshots given they're beyond the defrag frequency, the live/
defragged copy that would be shared by the weekly and daily snapshot/
sends because the defrag is done /before/ the weekly-retained-snapshot/
send, and a transient copy from during and immediately after the weekly 
defrag that would become the weekly copy as soon as the new weekly 
snapshot/send/retain was done and the previous one deleted.

Assuming the data in your nocow subvolume is only a small fraction of the 
operating (non-snapshot) data in the entire filesystem and that the 
filesystem is at least twice the size of the operating data, space 
shouldn't be an issue.

Worst-case, the nocow subvolume is near 100% of the filesystem's 
operating data, in which case you'd need a filesystem about five times 
that size in ordered to allow for that 4X-capped copies of the 
snapshotted and defragged data as described above, plus the metadata 
overhead, etc.

Clear as mud? =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

