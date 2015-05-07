Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52895 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbbEGFAA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 01:00:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YqDuc-0006hA-5c
	for linux-btrfs@vger.kernel.org; Thu, 07 May 2015 06:59:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 06:59:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 06:59:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send using with copied snapshot
Date: Thu, 7 May 2015 04:59:44 +0000 (UTC)
Message-ID: <pan$b5688$65f0cf6a$6aabe859$ac18f622@cox.net>
References: <loom.20150506T155438-123@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sri posted on Wed, 06 May 2015 14:01:02 +0000 as excerpted:

> btrfs send has option -p to compare 2 snapshots and genereate output of
> diff and if btrfs receive is there it will get the diff.
> 
> lets say i have done my first backup /b1/s1 is my subvolume and snap1_s1
> is first snapshot
> 
> ran command:
> 
> btrfse send /b1/snap1_s1 | btrfs receive /backup
> 
> 
> then I will get my backup /backup/snap1_s1
> 
> next I have created 2nd snapshot /b1/snap2_s1
> 
> why cannot i do below
> 
> btrfs send -p /backup/snap1_s1 /b1/snap2_s1 |btrfs receive /backup
> 
> both sanp1_s1 and snap2_s2 are readonly
> 
> why there is a restriction of all snapshots should be under same root?
> can't I get the diff of copied snapshot i.e /backup/snap1_s1 (never
> changed) to new snapshot /b1/snap2_s1 ??

At a high/general level, the restriction is there because of the nature 
of btrfs as a COW (copy-on-write) filesystem, and how it uses that to 
support both snapshots and send-receive.  Note that if btrfs was not COW, 
neither snapshots nor send/receive could work as they do, since they /
depend/ on COW functionality to work.

At a lower, somewhat more specific level, what btrfs send finds and 
sends, and what btrfs receive recreates at the other end, when the parent 
switch is used to make it incremental, is exactly the places where the 
two snapshots don't share the same extents.

Where the data never changes between the two snapshots, the extent 
pointers both point to the same on-device extents.  Where the data has 
changed, due to btrfs' copy-on-write nature, the parent still has its 
reference to the old extents, but when the change was written out, the 
changed data now has its own extents, no longer sharing the extents of 
the parent because the new data is written to new extents.

So what send does is look at the two snapshots, and ignore anything where 
the two both point to the same extents, only sending the new extents 
along with metadata about exactly what it replaced, so when the process 
is finished, the new received snapshot will share exactly the same 
extents with the old received snapshot, as the new send snapshot shares 
with the old send snapshot, and the differences again are the same 
differences on both sides.

*BUT*

While /b1/snap1_s1 shares extents with /b1/snap2_s1 and thus one can be 
sent incrementally as only the changes (that is, where the extents are no 
longer shared) from the other, /backup is assumed to be an entirely 
different filesystem, and thus /backup/snap1_s1 doesn't share any extents 
at all with /b1/snap2_s1!

So even if one /were/ to try to use send with a snapshot under /backup as 
the parent of a snapshot under /b1, and send/receive allowed it (I'm not 
sure whether it actually does or not, as my use-case doesn't use send/
receive and thus I've never actually run it, myself), since no extents 
are shared, send would detect it as 100% different, and the effect would 
be exactly the same as if you'd done a non-incremental send without a 
parent.

> My case, i may not always keep previous snapshot but i have copied to
> backup using the snapshot.

If you don't have an identical snapshot at each end to reference as the 
parent, you can't use incremental send.

However, because snapshots of a common base share extents where nothing 
has changed between them, the only space they take up is that of the 
differences between them (well, plus a bit of metadata space to track the 
snapshot itself and where any changes actually are, but that's generally 
insignificant compared to the changes themselves), very nearly zero if 
nothing at all changed.

Which means keeping reference snapshots around to use as send/receive 
parents isn't a big deal.  Just do it... or use some other backup method 
that doesn't depend on btrfs COW mechanics if you prefer.

That said, while it might be useful to keep quite a few snapshots, say a 
quarter's worth of one a day and another quarter's worth of one a week, 
at say the backup end, you can delete some of the intervening ones on the 
other (working/send) end, and simply use the same parent reference for 
more than one incremental.  In the above 1/day for a quarter and 1/week 
for another quarter scenario, you might keep only one a week (say 
Sunday's) at the working/send end for the first quarter, using it as the 
parent reference for six daily snapshots and send/receives and then 
deleting the sent snapshot on the send side.


There is, however, an interesting alternative storage method, still using 
send and receive.

Note that btrfs send sends a serialized data stream, to a file or to 
stdout, while receive accordingly receives a serialized data stream, from 
a file or from stdin.

It is thus possible to store the results of a send in exactly that 
serialized form, as one large file stored either /as/ a file on some 
other filesystem, or written directly to a raw block device for storage.  
Similarly, it is possible to restore the results by feeding receive a 
serialized stream as read directly from a file or from a block device.  
The practical result is nearly identical to the way backup tape works, as 
it too is a serialized stream, with the backup software doing the 
serialization and recording, and the readback and deserialization.  Btrfs 
send/receive thus functions very much like tape-backup software, except 
it takes advantage of btrfs copy-on-write for its incrementals, instead 
of using older, more primitive methods.

So, you could if you wished, do the initial send either to a different 
btrfs as you normally would, or to one file that's effectively the size 
of the entire snapshot you're sending.  Then after that, you could do 
incrementals, using the original snapshot on the send side as the parent, 
and simply storing the send stream as a single file for each send.  To 
restore, you'd receive the original parent, and could then receive from 
whatever incremental file you wished, to get back that snapshot.

With this method, you'd effectively have to do a full restore at once, 
you couldn't do file-by-file.  But you'd get the same space conservation 
on both the saved incremental-send-files and any restores as if you'd 
used receive directly, except that you'd only have whatever snapshots 
restored that you chose to feed to receive, the others would remain 
stored as they were, until you deleted those snapshot-serialization files.

Over time as things changed, the difference between the original parent 
snapshot and each newer incremental would increase in size, and thus so 
would the size of the incremental snapshot serialization file.  Once it 
got to some reasonable fraction of the original, say 20% of the size (so 
five incrementals now take the same space as a full reference would), 
you'd create a new reference snapshot, and do further incrementals 
against it, bringing down the size of the incremental serialization files 
once again.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

