Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54834 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbAaGl4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Jan 2015 01:41:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YHRkf-0002ky-MI
	for linux-btrfs@vger.kernel.org; Sat, 31 Jan 2015 07:41:53 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Jan 2015 07:41:53 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Jan 2015 07:41:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: rolling back to ext4 doesn't work if rebalanced
Date: Sat, 31 Jan 2015 06:41:48 +0000 (UTC)
Message-ID: <pan$166d3$48f4b8e8$54ea1743$1bd7f7b4@cox.net>
References: <CAO5K3OefHFj6sQx9ZwNcDJWWTTaRf62U4eDp0Gxyf+kFk4Wyew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vytautas D posted on Fri, 30 Jan 2015 16:41:11 +0000 as excerpted:

> Is it possible to automate btrfs-convert so that it would defrag and
> balance the disk without loosing ability to roll back to ext4 partition
> ?
> 
> i.e:
> btrfs-convert /dev/sda3
> # I can still rollback using btrfs-convert -r /dev/sda3
> 
> btrfs filesystem defrag -r /
> # I can still rollback using btrfs-convert -r /dev/sda3
> 
> btrfs balance start /
> # I can no longer rollback to ext4

Mostly no, tho in theory there's also a very narrow and limited yes.

(Semi-)technical background:

The ext* fs layout is quite a bit different than btrfs' native layout, 
metadata more so than data.  What the conversion actually does is leave 
the ext* data in-place, along with its metadata, and in the free space 
that still existed on the ext* filesystem, create new btrfs metadata 
pointing at the still-in-place ext* file data.

Because btrfs is copy-on-write (COW), and the conversion process creates 
a special btrfs snapshot containing the ext* data and metadata so btrfs 
won't remove it if it updates files, you can write new data and changes 
to the existing data on the btrfs side, and btrfs will write that to a 
different location, leaving the ext* data and metadata in that special 
snapshot as they were.

It is for that reason that any changes made while the filesystem is btrfs 
won't be retained if you convert back to ext*.  You get the ext* 
filesystem as it was at the time of the conversion to btrfs.

If you decide to stay with btrfs, the first thing to do is remove that 
special ext*_saved (IIRC that's the name, something like that) snapshot, 
then defrag and balance what remains, obliterating the ext* metadata and 
final-converting all the data to native btrfs format.

The key concept to understand here is that btrfs itself doesn't 
understand or deal with the ext* metadata at all.  The (userspace) 
conversion process simply creates new btrfs metadata pointing at the 
existing ext* data, and takes advantage of btrfs' COW nature to create a 
snapshot that btrfs shouldn't touch, so as to keep the ext* metadata and 
data intact, and along with it, the ability to rollback to that ext* 
filesystem as it was at the time of the conversion.

That's the background.  Now to answer your question.

What (btrfs) defrag and balance do are two different stages of btrfs-
specific optimization.  That btrfs-specific optimization simply cannot be 
done without disrupting the ext* layout, thus the overall no.

Actually, even the btrfs fi defrag would normally destroy the ability to 
rollback, but for one hopefully temporary issue.  Ideally, btrfs defrag 
is snapshot aware, and defragging files in one snapshot will defrag them, 
to the extent that they are the same, in other snapshots as well.  
However, the original btrfs snapshot-aware defrag was found not to scale 
at all well, requiring huge amounts of memory and taking days and 
sometimes weeks to get thru a defrag in the presence of large numbers of 
snapshots (with btrfs quotas being another complicating factor at the 
time).  Thus, snapshot-aware-defrag was disabled (hopefully) temporarily, 
while they rewrote both the multi-snapshot handling code and the quota 
handling code with a view toward *MUCH* better scaling.  At least some of 
that work has been done and scaling is definitely better now, but 
apparently not good enough yet that they feel comfortable reenabling 
snapshot-aware-defrag.

Thus, at least for the time being, btrfs defrag is not snapshot aware, 
and only rewrites the snapshot-instance of the files it's actually 
pointed at, using COW so anything that's defragged is actually rewritten, 
leaving other snapshots of the same files in place, as fragmented as they 
were before.  This does the defrag for whatever it's pointed at, but 
obviously, if the snapshotted files were heavily fragmented, it's going 
to about double the space taken up, because the snapshotted versions will 
still exist, while the defrag writes new, defragmented copies, for 
whatever mounted snapshot you pointed the defrag at.

That's why you could btrfs defrag and still successfully roll-back to 
ext*, because the ext* is its own snapshot, and with snapshot-aware-
defrag temporarily disabled, the defrag rewrote any files it defragged, 
creating a new copy of them, while leaving the existing ext* special 
snapshot alone.  When snapshot-aware-defrag is reenabled, that won't 
(normally) work any more, as the files in the snapshot would be btrfs 
defragged as well, thereby moving them out from under the ext* metadata 
pointing at the old copies.


All that said, at least in theory, balance and defrag could be taught to 
special-case the ext* snapshot, leaving it alone, while balancing and 
defragging the btrfs metadata, along with any files added or changed 
since the btrfs conversion, which thus exist on the btrfs side.  That's 
the very limited yes I mentioned above.

But that's only theory, and in practice it'd hardly be worth the bother 
to implement.  Why?

Because the entire idea of the conversion and being able to rollback is 
that users will only keep the rollback snapshot very temporarily, perhaps 
a few days' worth of normal filesystem writes at the longest, since the 
ext* side remains as it is and will quickly become outdated, with all 
changes since then lost if the rollback option /is/ exercised.

Also, remember that immediately after the conversion, all files are still 
in ext* form, with native btrfs versions of the files only created as the 
files change.

So if btrfs defrag and balance were taught to ignore the ext* saved 
snapshot, there really wouldn't be a lot left for them to do.  The btrfs 
metadata would be newly written by the conversion and thus very limited 
optimization could be done to it at least as long as it's still pointing 
at ext* format data, and other than that, there'd only be any new or 
changed files, freshly written in native btrfs mode, to optimize.  Given 
that the rollback snapshot is supposed to be very temporary in the first 
place, and that it should be relatively quickly either deleted and a 
defrag and balance done to fully optimize the formerly ext* layout for 
btrfs, or the rollback option should be exercised and all changes made 
while the filesystem was btrfs lost, it's hardly worth the trouble to 
teach btrfs defrag and balance to special-case-ignore the special-case 
ext* snapshot, since there really shouldn't be much for them to do as 
long as that snapshot exists.

So as I said at the top, in general, no, it's not possible.  In theory 
there's a very narrow-case yes, but in practice, it's so narrow-case and 
should exist for such a short period, that it's hardly worth the trouble 
to implement.


Meanwhile, a variant of the same question, with a slightly different 
answer:  Would it be possible to optimize convert such that it did the 
defrag and balance optimization at the same time as the conversion?

Yes, it /would/ be possible, but again, it's hardly worth it, tho now for 
a different reason.  If the optimization happens at the same time, it's 
by definition no-rollback since optimizing to btrfs layout loses the ext* 
layout, so using that would mean no-rollbacks.

And what then if things went wrong, the biggest reason to allow rollbacks 
in the first place?  No rollback and failed conversion means lost data.  
Which would mean you could do that only if you either didn't care about 
losing the data, or if you had full (tested) backups of everything you 
cared about.

And if you had backups or didn't care about the data, there's already a 
*MUCH* more straightforward way to do the same thing -- simply blow away 
the old ext* with a clean mkfs.btrfs.  If you don't care about the data, 
no loss and it's far faster and more efficient than a conversion.  And if 
you do care about the data, you simply restore from backup onto the 
freshly mkfs-ed btrfs, STILL faster and more efficient than a conversion.

So the ability to rollback either due to problems with the conversion or 
because you decide you don't like btrfs, is critical to the whole convert-
in-place concept in the first place.  Which means you can't optimize the 
conversion/defrag/balance steps by combining them, because in so doing 
you lose the ability to rollback, and without that, you might as well 
simply start with a clean mkfs.btrfs in the first place, restoring from 
backup after that if desired, and forget about the whole convert-in-place 
entirely.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

