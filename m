Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49113 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbcCQKwK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 06:52:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agVXC-0001ad-RD
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 11:52:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 11:52:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 11:52:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [4.4.1] btrfs-transacti frequent high CPU usage despite little
 fragmentation
Date: Thu, 17 Mar 2016 10:51:50 +0000 (UTC)
Message-ID: <pan$4920$33ddf09b$49bd87c9$2053e366@cox.net>
References: <56E92B38.10605@inoio.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ole Langbehn posted on Wed, 16 Mar 2016 10:45:28 +0100 as excerpted:

> Hi,
> 
> on my box, frequently, mostly while using firefox, any process doing
> disk IO freezes while btrfs-transacti has a spike in CPU usage for more
> than a minute.
> 
> I know about btrfs' fragmentation issue, but have a couple of questions:
> 
> * While btrfs-transacti is spiking, can I trace which files are the
> culprit somehow?
> * On my setup, with measured fragmentation, are the CPU spike durations
> and freezes normal?
> * Can I alleviate the situation by anything except defragmentation?
> 
> Any insight is appreciated.
> 
> Details:
> 
> I have a 1TB SSD with a large btrfs partition:
> 
> # btrfs filesystem usage /
> Overall:
>     Device size:                 915.32GiB
>     Device allocated:            915.02GiB
>     Device unallocated:          306.00MiB
>     Device missing:                  0.00B
>     Used:                        152.90GiB
>     Free (estimated):            751.96GiB      (min: 751.96GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:901.01GiB, Used:149.35GiB
>    /dev/sda2     901.01GiB
> 
> Metadata,single: Size:14.01GiB, Used:3.55GiB
>    /dev/sda2      14.01GiB
> 
> System,single: Size:4.00MiB, Used:128.00KiB
>    /dev/sda2       4.00MiB
> 
> Unallocated:
>    /dev/sda2     306.00MiB
> 
> 
> I've done the obvious and defragmented files. Some files were
> defragmented from 10k+ to still more than 100 extents. But the problem
> persisted or came back very quickly. Just now i re-ran defragmentation
> with the following results (only showing files with more than 100
> extents before fragmentation):
> 
> extents before / extents after / anonymized path
> 103 / 1 /home/foo/.mozilla/firefox/foo.default/formhistory.sqlite:
> 133 / 1
> /home/foo/.thunderbird/foo.default/ImapMail/imap.example.org/ml-btrfs:
> 155 / 1 /var/log/messages:
> 158 / 30
> /home/foo/.thunderbird/foo.default/ImapMail/mail.example.org/INBOX:
> 160 / 32 /home/foo/.thunderbird/foo.default/calendar-data/cache.sqlite:
> 255 / 255 /var/lib/docker/devicemapper/devicemapper/data:
> 550 / 1 /home/foo/.cache/chromium/Default/Cache/data_1:
> 627 / 1 /home/foo/.cache/chromium/Default/Cache/data_2:
> 1738 / 25 /home/foo/.cache/chromium/Default/Cache/data_3:
> 1764 / 77 /home/foo/.mozilla/firefox/foo.default/places.sqlite:
> 4414 / 284 /home/foo/.digikam/thumbnails-digikam.db:
> 6576 / 3 /home/foo/.digikam/digikam4.db:
> 
> So fragmentation came back quickly, and the firefox places.sqlite file
> could explain why the system freezes while browsing.

Have you tried the autodefrag mount option, then defragging?  That should 
help keep rewritten files from fragmenting so heavily, at least.  On 
spinning rust it doesn't play so well with large (half-gig plus) 
databases or VM images, but on ssds it should scale rather larger; on 
fast SSDs I'd not expect problems until 1-2 GiB, possibly higher.

For large dbs or VM images, too large for autodefrag to handle well, the 
nocow attribute is the usual suggestion, but I'll skip the details on 
that for now, as you may not need it with autodefrag on an ssd, unless 
your database and VM files are several gig apiece.

> BTW: I did a VACUUM on the sqlite db and afterwards it had 1 extent.
> Expected, just saying that vacuuming seems to be a good measure for
> defragmenting sqlite databases.

I know the concept, but out of curiousity, what tool do you use for 
that?  I imagine my firefox sqlite dbs could use some vacuuming as well, 
but don't have the foggiest idea how to go about it.

> I am using snapper and have about 40 snapshots going back for some
> months. Those are read only. Could that have any effect?

They could have some, but I don't expect it'd be much, not with only 40.


Other than autodefrag, and/or nocow on specific files (but research the 
latter before you do it, there's some interaction with snapshots you need 
to be aware of, and you can't just apply it to existing files and expect 
it to work right), there's a couple other things that may help.


Of *most* importance, you really *really* need to do something about that 
data chunk imbalance, and to a lessor extent that metadata chunk 
imbalance, because your unallocated space is well under a gig (306 MiB), 
with all that extra space, hundreds of gigs of it, locked up in unused or 
only partially used chunks.

The subject says 4.4.1, but it's unclear whether that's your kernel 
version or your btrfs-progs userspace version.  If that's your userspace 
version and you're running an old kernel, strongly consider upgrading to 
the LTS kernel 4.1 or 4.4 series if possible, or at least the LTS series 
before that, 3.18.  Those or the latest couple current kernel series, 4.5 
and 4.4, and 4.3 for the moment as 4.5 is /just/ out, are the recommended 
and best supported versions.

I say this because before 3.17, the btrfs kernelspace could allocate its 
own chunks, but didn't know how to free them, so one had to run balance 
fairly frequently to free up all the empty chunks, and it looks like you 
might have a bunch of empty chunks around.

With 3.17, the kernel learned how to delete entirely empty chunks, and 
running a balance to clear them isn't necessary these days.  But the 
kernel still only knows how to delete entirely empty chunks, and it's 
still possible over time, particularly with snapshots locking in place 
file extents that might be keeping otherwise empty chunks from being 
fully emptied and thus cleared by the kernel, for large imbalances to 
occur.

Either way, large imbalances is what you have ATM.  Copied from your post 
as quoted above:

> Data,single: Size:901.01GiB, Used:149.35GiB
>    /dev/sda2     901.01GiB
> 
> Metadata,single: Size:14.01GiB, Used:3.55GiB
>    /dev/sda2      14.01GiB

So 901 GiB of data chunks but under 150 GiB of it actually used.  That's 
nearly 750 GiB of free space tied up in empty or only partially filled 
data chunks.

14 GiB of metadata chunks, but under 4 GiB reported used.  That's about 
10 GiB of metadata chunks that should be freeable (tho the half GiB of 
global reserve comes from that metadata too but doesn't count as used, so 
usage is actually a bit over 4 GiB, so you may only free 9.5 GiB or so).

Try this:

btrfs balance start -dusage=0 -musage=0.

That should go pretty fast whether it works or not, but it might not 
work, if you don't actually have any entirely empty chunks.  If you do, 
it'll free them.

If that added some gigs to your unallocated total, good, as you're likely 
to have difficulty balancing data chunks anyway, without that, because 
data chunks are normally a gig or more in size and a new one has to be 
allocated in ordered to rewrite the content of others to try to release 
the unused space in the data chunks.

If it didn't do anything, as is likely if you're running a new kernel, it 
means you didn't have any zero-usage chunks, which a new kernel /should/ 
clean up but might not in some cases.

Then start with metadata, and up the usage numbers which are percentages, 
like this:

btrfs balance start -musage=5.

Then if it works up the number to 10, 20, etc.  By the time you get to 50 
or 70, you should have cleared several of those 9.5 or so potential gigs 
and can stop.  /Hopefully/ it'll let you do that with just the 300 MiB 
free you have, if the 0-usage balance didn't help free several gigs.  But 
on that large a filesystem, the normally 256 MiB metadata chunks may be a 
GiB, in which case you'd still run into trouble.

Once you have several gigs in unallocated, then try the same thing with 
data:

btrfs balance start -musage=5

And again, increase it in increments of 5 or 10% at a time, to 50 or 
70%.  With luck, you'll get most of that potential 750 GiB back into 
unallocated.

When you're done, total data should be much closer to the 150-ish gigs 
it's reporting as used, with most of that near 750 gigs spread from the 
current 900+ total moved to unallocated, and total metadata much closer 
to the about 4 gigs used, with 9 gigs or so of that spread moved to 
unallocated.

If the 0-usage thing doesn't give you anything and you can't balance even 
-musage=1, or don't get anything space returned until you get high enough 
to get an error, or if the metadata balance doesn't free enough space to 
unallocated to let the balance -dusage= work, then things get a bit more 
serious.  In that case, you can try one of two things, either delete your 
oldest snapshots to try and free up 100% of a few chunks so -dusage=0 
will free them, or temporarily btrfs device add a second device of a few 
gigs, a thumb drive can work, to give the balance somewhere to put the 
new chunk it needs to write in ordered to free up old ones.  Once you 
have enough space free on the original device, you can btrfs device 
delete the temporary one, to move all the chunks on it back to the main 
device and delete it from the filesystem.


Second thing, consider tweaking your trim/discard policy, since you're on 
ssd.  It could well be erase block management that's hitting you, if you 
haven't been doing regular trims or if the associated btrfs mount option 
(discard) is set incorrectly for your device.

See the btrfs (5) manpage (not btrfs (8)!) or the wiki for the discard 
mount option description, but the deal is that while most semi-recent ssds 
handle trim/discard, only fairly recently was it made a command-queued 
operation, and not even all recent ssds support it as command-queued.  
Without that, a trim kills the command-queue and thus can dramatically 
hurt performance.  Which is why it's not the btrfs ssd default and why 
it's not generally recommended for use with ssds, tho where the command 
is queued it should be a good thing.

But without trim/discard of /some/ sort, your ssd will slow down over 
time, when it no longer has a ready pool of unused erase blocks at hand 
to put new and wear-level-transferred blocks into.  Now mkfs.btrfs does 
do a trim as part of the filesystem creation process, but after that...

After that, barring an ssd that command-queues the trim command so you 
can add it to your mount options without affecting performance there, you 
can run the fstrim command from time to time.  Fstrim finds the unused 
space in the filesystem and issues trim commands for it, thus zeroing it 
out and telling the ssd firmware it can safely use those blocks for wear-
leveling and the like.

The recommendation is to put fstrim in a cron or systemd timer job, 
executing it weekly or similar, preferably at a time when all those 
unqueued trims won't affect your normal work.

Meanwhile, note that if you run fstrim manually, it outputs all the empty 
space it's trimming, but that running it repeatedly will show the same 
space every time, since it doesn't know what's already trimmed.  That's 
not a problem for the ssd, but it can confuse users who might think the 
trim isn't working, since it trims the same thing every time.

So if you have trim in your mount options, try taking it out and see if 
that helps.  But if you're not doing it there, be sure to setup an fstrim 
cron or systemd timer job to do it weekly or so.

Another strategy that some people use is to partition up most of the ssd, 
but leave 20% or so of it unpartitioned, or partitioned but without a 
filesystem if you prefer, thus giving the firmware that extra room to 
play with.  Once you have all those extra data and metadata chunks 
removed, you can shrink the filesystem, then the partition it's on, and 
let the ssd firmware have the now unpartitioned space.  Only thing is I 
don't know a tool to actually trim the now free space, and am not sure 
whether btrfs resize does it or not, so you might have to quickly create 
a new partition and filesystem in the space again but leave the 
filesystem empty, then fstrim it (or just make the filesystem btrfs, 
since mkfs.btrfs automatically does a trim if it detects an ssd where it 
can) to let the firmware have it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

