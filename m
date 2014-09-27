Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50910 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaI0ERi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 00:17:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XXjRx-0005RK-EY
	for linux-btrfs@vger.kernel.org; Sat, 27 Sep 2014 06:17:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 06:17:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 06:17:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Backup: Compare sent snapshots
Date: Sat, 27 Sep 2014 04:17:30 +0000 (UTC)
Message-ID: <pan$2cf2e$b466e32e$8c5d4ef4$9a82294f@cox.net>
References: <8465933.4bvG1Xk5zJ@linuxpc>
	<pan$92371$cf7e2c62$a94a9382$e3e154b@cox.net>
	<CAOsFrTfQHZjUbBcMkx9e30x6fdi216PAMPRo+QoVmqAR0pZH1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

G EO posted on Fri, 26 Sep 2014 18:15:33 +0200 as excerpted:

> Okay I have a couple of questions again regarding the lost local
> reference part:

Please quote, then reply in context.  Trying to figure this out cold-
context is no fun, tho the context was at the bottom, but then I'm paging 
back and forth to see it...

Meanwhile, to keep /this/ in context, let me be clear that my own use 
case doesn't involve send/receive at all, so what I know of it is from 
the list and wiki, not my own experience.  At the time I wrote the 
previous reply they were still having problems with exotic corner-cases 
and send/receive.  I'm not sure if that has been worked thru for the most 
part or not, tho as I said, from everything I've seen, when there /were/ 
problems it would error out, not silently fail to do a reliable copy.

> How was the reverse btrfs send/receive meant? should I simply do
> 
> "btrfs send /mnt/backup-partition/snapshot_name | btrfs receive
> /mnt/root-partition/"

This is effectively a full send/receive, what you'd do if you did a fresh 
mkfs on the receive side and wanted to repopulate it.

> or should I use btrfs send -p and compare to some newly created local
> snapshot? When I send back  the lost reference from the backup drive
> will that write the incremental part that has changed since then or will
> it allocate space the size of the snapshot?

What I had in mind was this (again, with the caveat that I'm not actually 
using send/receive myself, so I'd suggest testing or getting confirmation 
from someone that is, before depending on this):

On the main filesystem, you did the first full send, we'll call it A.  
Then you did an incremental send with a new snapshot, B, using A as its 
parent, and later another, C, using B as its parent.

On the backup, assuming you didn't delete anything and that the receives 
completed without error, you'd then have copies of all three, A, B, C.  
Now let's say you decide A is old and you no longer need it, so you 
delete it on both sides, leaving you with B and C.

Now back on the main machine C is damaged.  But you still have B on both 
machines and C on the backup machine.

What I was suggesting was that you could reverse the last send/receive, 
sending C from the backup with B as its parent (since B exists undamaged 
on both sides, with C undamaged on the backup but damaged or missing on 
the main machine), thereby restoring a valid copy of C on the main 
machine once again.

Once you have a valid copy of C on the main machine again, you can now do 
normal incremental send/receive D, using C as its parent, just as you 
would have if C had never been damaged in the first place, because you 
restored a valid C reference on your main machine in ordered to be able 
to do so.


Snapshot size?  That's not as well defined as you might think.  Do you 
mean the size of everything in that snapshot, including blocks shared 
with other snapshots, or do you mean just the size of what isn't shared, 
in effect, the space you'd get back if you deleted that snapshot?  Or do 
you mean include the blocks shared, but divide that by the number of 
snapshots sharing each block, in effect apportioning each snapshot its 
fair share, but with the not necessarily expected side effect that if you 
delete another snapshot that shared some of the blocks, suddenly the size 
of this one increases, because there's less snapshots sharing the same 
data, now?

Of course anyone who has attempted a reasonable discussion of Linux 
memory usage, accounting for shared object libraries, should see the 
direct parallel to that discussion as well.  The same basic concepts 
apply to both, and either subject is considerably more complex than it 
might at first seem, because all three approaches have some merits and 
some disadvantages, depending on what you're trying to actually measure 
with the term "size".

I'm /guessing/ that you mean the full size of all data and metadata in 
the snapshot.  In that case, using the above "reverse" send/receive to 
recover the damaged or missing reference /should/ not require the full 
"size" of the snapshot, no.  OTOH, if you mean the size of the data and 
metadata exclusive to that snapshot, the amount you'd get back if you 
deleted it on the backup machine, then yes, it'll require that much space 
on the main machine as well.

Of course that's with the caveat that you haven't done anything to 
reduplicate the data, breaking the sharing between snapshots.  The big 
factor there is defrag.  While snapshot-aware-defrag was introduced in I 
think kernel 3.9, that implementation turned out not to scale well AT 
ALL, and it was using 10s of GiB of RAM and taking days to defrag what 
should have been done in a few hours.  So they ended up disabling 
snapshot-aware-defrag again, until they can fix the scaling issues.  That 
means that when you defrag, you're defragging /just/ the snapshot you 
happened to point defrag at, and anything it moves in that defrag is 
effect duplicated, since other snapshots previously sharing that data 
aren't defragged along with it so they keep a reference to the old, 
undefragged version, thus doubling the required space for anything moved.

Thus defrag will, obviously, have implications in terms of space 
required.  And actually, tho I didn't think of it until just now as I'm 
writing this, it's going to have send/receive implications as well, since 
the defragged blocks will no longer be shared with the reference/parent 
snapshot, thus requiring sending all that data over again.  OUCH!


> In https://btrfs.wiki.kernel.org/index.php/Incremental_Backup there is
> the talk of "Efficiently determining and streaming the differences
> between two snapshots if they are either snapshots of the same
> underlying subvolume, or have a parent-child relationship." Wont that
> required part get lost be reversely sending the last local reference?

No, because the previous reference, B in my example above, remains the 
parent reference on both sides.  As long as there's a common reference on 
both sides, the relationship should be maintained.

Think of it this way, if that relationship would be lost in a "reverse" 
send/receive, it would have been lost in the original send/receive to the 
backup machine, as well.  It's exactly the same concept in both 
instances; you're simply reversing the roles so that the machine that was 
the sending machine is now receiving, while the receiving machine is now 
the sender.  If the relationship would get lost, it'd get lost in both 
cases, and if it got lost in the original case, then incremental send/
receive would be broken and simply wouldn't work.  The ONLY way it can 
work is if the same relationship that exists on the sender always gets 
recreated on the receiver as well, and if that's the case, then as long 
as you still have the parent on what was the sender, you can still use 
that parent in the receiving role as well.

> What would you do in the case of a new install? You import your last
> home snapshot (as your primary home subvolume) using "btrfs send
> /mnt/backup-partition/home_timestamp | btrfs receive
> /mnt/root-partition/". Now you have imported your snapshot but its still
> read only. How to make it writable? I simply did this for now by making
> a snapshot of the read only snapshot and renamed that snapshot to
> "home". Is that the right way to do it?

Yes, that's the way it's done.  You can't directly make a read-only 
snapshot writable, but you can take another snapshot of the read-only 
snapshot, and make it writable when you take it. =:^)

Then depending what you have in mind you can delete the read-only 
snapshot (tho if you're using it as a send/receive reference you probably 
don't want to do that), just keeping the writable one.

I had thought I saw that mentioned on the wiki somewhere, but I sure 
can't seem to find it now!

> Now on the new install we want to continue doing our backups using the
> old backup drive. Since we have the readonly snapshot we imported (and
> we took a writeable snapshot of it that is now our primary snapshot) we
> can simply cotinue doing the incremental step without the bootstrap step
> right?

Correct.

> You would really hep me in a great manner if you could answer some of
> the questions.

Hope that helps. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

