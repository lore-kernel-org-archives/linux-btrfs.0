Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35253 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbLNJKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 04:10:53 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: safety of journal based fs (was: Re: still kworker at 100% =?UTF-8?B?Y3B14oCmKQ==?=
Date: Mon, 14 Dec 2015 10:10:51 +0100
Message-ID: <1936131.2NX0AhU8Tu@merkaba>
In-Reply-To: <566E827A.2020604@cn.fujitsu.com>
References: <8336788.myI8ELqtIK@merkaba> <5373860.W0QrVGf34G@merkaba> <566E827A.2020604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Using a different subject for the journal fs related things which are off 
topic, but still interesting. Might make sense to move to fsdevel-ml or ext4/
XFS mailing lists? Otherwise, I suggest we focus on BTRFS here. Still wanted 
to reply.

Am Montag, 14. Dezember 2015, 16:48:58 CET schrieb Qu Wenruo:
> Martin Steigerwald wrote on 2015/12/14 09:18 +0100:
> > Am Montag, 14. Dezember 2015, 10:08:16 CET schrieb Qu Wenruo:
> >> Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
[…]
> >>> I am seriously consider to switch to XFS for my production laptop again.
> >>> Cause I never saw any of these free space issues with any of the XFS or
> >>> Ext4 filesystems I used in the last 10 years.
> >> 
> >> Yes, xfs and ext4 is very stable for normal use case.
> >> 
> >> But at least, I won't recommend xfs yet, and considering the nature or
> >> journal based fs, I'll recommend backup power supply in crash recovery
> >> for both of them.
> >> 
> >> Xfs already messed up several test environment of mine, and an
> >> unfortunate double power loss has destroyed my whole /home ext4
> >> partition years ago.
> > 
> > Wow. I have never seen this. Actual I teach journal filesystems being
> > quite
> > safe on power losses as long as cache flushes (former barrier)
> > functionality is active and working. With one caveat: It relies on one
> > sector being either completely written or not. I never seen any
> > scientific proof for that on usual storage devices.
> 
> The journal is used to be safe against power loss.
> That's OK.
> 
> But the problem is, when recovering journal, there is no journal of
> journal, to keep journal recovering safe from power loss.

But the journal should be safe due to a journal commit being one sector? Of 
course for the last changes without a journal commit its: The stuff is gone.

> And that's the advantage of COW file system, no need of journal completely.
> Although Btrfs is less safe than stable journal based fs yet.
> 
> >> [xfs story]
> >> After several crash, xfs makes several corrupted file just to 0 size.
> >> Including my kernel .git directory. Then I won't trust it any longer.
> >> No to mention that grub2 support for xfs v5 is not here yet.
> > 
> > That is no filesystem metadata structure crash. It is a known issue with
> > delayed allocation. Same with Ext4. I teach this as well in my performance
> > analysis & tuning course.
> 
> Unfortunately, it's not about delayed allocation, as it's not a new
> file, it's file already here with contents in previous transaction.
> The workload should only rewrite the files.(Not sure though)

For what I know the overwriting after truncating case is also related to the 
delayed allocation, deferred write thing: File has been truncated to zero 
bytes in journal, while no data has been written.

But well for Ext4 / XFS it doesn´t need to reallocate in this case.

> And for ext4 case, I'll see corrupted files, but not truncated to 0 size.
> So IMHO it may be related to xfs recovery behavior.
> But not sure as I never read xfs codes.

Journals online provide *metadata* consistency. Unless you use Ext4 with 
data=journal, which is supposed to be much slower, but in some workloads its 
actually faster. Even Andrew Morton had not explaination for that, however I 
do have an idea about it. Also data=journal is interesting, if you put journal 
for harddisk based Ext4 onto an SSD or an SSD RAID 1 or so.

> > Also BTRFS in principle has this issue I believe.  As far as I am aware it
> > has a fix for the rename case, not using delayed allocation in the case.
> > Due to its COW nature it may not be affected at all however, I don´t
> > know.
> Anyway for rewrite case, none of these fs should truncate fs size to 0.
> However, it seems xfs doesn't follow the way though.
> Although I'm not 100% sure, as after that disaster I reinstall my test
> box using ext4.
> 
> (Maybe next time I should try btrfs, at least when it fails, I have my
> chance to submit new patches to kernel or btrfsck)

I do think its the applications doing that on overwriting a file. Rewriting a 
config file for example. Its either write new file, rename to old, or truncate 
to zero bytes and rewrite.

Of course, its different for databases or other files written into without 
rewriting them. But there you need data=journal on Ext4. XFS doesn´t guarentee 
file consistency at all in that case, unless the application serializes 
changes with fsync() properly by using an in application journal for the data 
to write.

> >> [ext4 story]
> >> For ext4, when recovering my /home partition after a power loss, a new
> >> power loss happened, and my home partition is doomed.
> >> Only several non-sense files are savaged.
> > 
> > During a fsck? Well that is quite a special condition I´d say. Of course I
> > think aborting an fsck should be safe at all time, but I wouldn´t be
> > surprised if it wasn´t.
> 
> Not only a fsck, any timing doing journal replay will be affected, like
> mounting a dirty fs.
> 
> But you're right, the case is quite minor, and even myself only
> encountered it once.

Hmmm, okay, but still not nice. I thought a journal reply should be safe. 
Cause:

If will check last log entry with commit marker, only these are 1) complete, 
2) not fully applied. It will apply all changes that are not yet applied or 
even reapply those that where already I am not sure about that. And then it 
will remove commit marker which should be an atomic operation.

It least I thought that this is the whole point of using a journal in the 
first place.

Thanks,
-- 
Martin
