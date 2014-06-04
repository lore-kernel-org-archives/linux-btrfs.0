Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53737 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaFDJV6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 05:21:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ws7OM-0001Bx-1l
	for linux-btrfs@vger.kernel.org; Wed, 04 Jun 2014 11:21:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 11:21:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 11:21:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: All free space eaten during defragmenting (3.14)
Date: Wed, 4 Jun 2014 09:21:41 +0000 (UTC)
Message-ID: <pan$24193$91f49d0c$3e415aff$821f2f81@cox.net>
References: <1703083.hLnNuPsKpY@linux-suse.hu>
	<pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>
	<538B8F76.9090500@petezilla.co.uk>
	<pan$40c68$d9ca1c60$28b3a30c$43e8d611@cox.net>
	<538CE4A0.9020105@petezilla.co.uk>
	<pan$70d58$14dcbb11$e72f6493$4dc866e2@cox.net>
	<538E4A83.30903@petezilla.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Chant posted on Tue, 03 Jun 2014 23:21:55 +0100 as excerpted:

> On 06/03/2014 05:46 AM, Duncan wrote:
> 
>> Of course if you were using something like find and executing defrag on
>> each found entry, then yes it would recurse, as find would recurse
>> across filesystems and keep going (unless you told it not to using
>> find's -xdev option).
> 
> I did not know the recursive option existed.  However, I'd previously
> cursed the tools not having a recursive option or being recursive by
> default.  If there is now a recursive option it would be really perverse
> to use find to implement a recursive defrag.

Defrag's -r/recursive option is reasonably new, but checking the btrfs-
progs git tree (since I run the git version) says that was commit 
c2c5353b, which git describe says was v0.19-725, so it should be in btrfs-
progs v3.12.  So it's not /that/ new.  Anyone still running something 
earlier than that really should update. =:^)

But the wiki recommended using find from back before the builtin 
recursive option, and I can well imagine people with already working 
scripts not wanting to fix what isn't (for them) broken. =:^)  So I 
imagine there will be find-and-defrag users for some time, tho they 
should even now be on their way to becoming a rather small percentage,
at least for folks following the keep-current recommendations.

Meanwhile, this question is bugging me so let me just ask it.  The OP was 
from a different email address (szotsaki@gmail), and once I noticed that 
I've been assuming that you and the OP are different people, tho in my 
first reply to you I assumed you were the OP.  So just to clear things 
up, different people and I can't assume that what he wrote about his case 
applies to you, correct? =:^)

>> Meanwhile, you mention the autodefrag mount option.  Assuming you have
>> it on all the time, there should be that much to defrag, *EXCEPT* if
>> the -c/ compress option is used as well.  If you aren't also using the
>> compress mount option by default, then you are effectively telling
>> defrag to compress everything as it goes, so it will
>> defrag-and-compressed all files.  Which wouldn't be a problem with
>> snapshot-aware-defrag as it'd compress for all snapshots at the same
>> time too.  But with snapshot-aware-
>> defrag currently disabled, that would effectively force ALL files to be
>> rewritten in ordered to compress them, thereby breaking the COW link
>> with the other snapshots and duplicating ALL data.
> 
> I've got compress=lzo, options from fstab:
> device=/dev/sdb,device=/dev/sdc,autodefrag,defaults,inode_cache,noatime,
> compress=lzo
> 
> I'm running kernel 3.13.6.  Not sure if snapshot-aware-defrag is enabled
> or disabled in this version.

A git search says (linus' mainline tree) commit 8101c8db, merge commit 
878a876b, with git describe labeling the merge commit as v3.14-rc1-13, so 
it would be in v3.14-rc2.  However, the commit in question was CCed to 
stable@, so it should have made it into a 3.13.x stable release as well.  
Whether it's in 3.13.6 specifically, I couldn't say without checking the 
stable tree or changelog, which should be easier for you to do since 
you're actually running it.  (Hint, I simply searched on "defrag", here; 
it ended up being the third hit back from 3.14.0, I believe, so it 
shouldn't be horribly buried, at least.)

> Unfortunately I really don't understand how COW works here.
> I understand the basic idea but have no idea how it is implemented
> in btrfs or any other fs.

FWIW, I think only the kernel/filesystem or at least developer types 
/really/ understand COW, but I /think/ I have a reasonable sysadmin's-
level understanding of the practical effects in terms of btrfs, simply 
from watching the list.

Meanwhile, not that it has any bearing on this thread, but about your 
mount options, FWIW you may wish to remove that inode_cache option.  I 
don't claim to have a full understanding, but from what I've picked up 
from various dev remarks, it's not necessary at all on 64-bit systems 
(well, unless you have really small files filling an exabyte size 
filesystem!) since the inode-space is large enough finding free inode 
numbers isn't an issue, and while it can be of help in specific 
situations on 32-bit systems, there's two problems with it that make it 
not suitable for the general case: (1) on large filesystems (I'm not sure 
how large but I'd guess it's TiB scale) there's danger of inode-number-
collision due to 32-bit-overflow, and (2) it must be regenerated at every 
mount, which at least on TiB-scale spinning rust can trigger several 
minutes of intense drive activity while it does so.  (The btrfs wiki now 
says it's not recommended, but has a somewhat different explanation.  
While I'm not a coder and thus in no position to say for sure based on 
the code, I believe the wiki's explanation isn't quite correct, but 
either way, it's still not recommended.)

The use-cases where inode_cache might be worthwhile are thus all 32-bit, 
and include things like busy email servers with lots of files being 
constantly created/deleted.  If in doubt, disable it.

Oh, and while I'm at it, I might as well mention that the "defaults" 
mount option is normally not necessary, except as a field-holder in fstab 
if no non-default options are being used as well.  That's the whole point 
of "defaults", that they're default, and thus don't need passed.  Tho 
(unlike inode_cache) it does no harm.

>> If the data that you're trying to defrag is snapshotted, the defrag
>> will currently break the COW link and double usage.  However, as long
>> as you have the space to spare and are deleting the snapshots in a
>> reasonable time (as it sounds like you are since it seems you're doing
>> snapshots only to enable a stable backup), once you delete all the
>> snapshots from before the defrag, you should get the space back, so
>> it's not a permanent issue.
> 
> Hmm.  From your previous discussion I get the impression that it is not
> a problem if it has always compressed, or always not compressed, but it
> blows up if the compression setting is changed - e.g. the compressed
> file and uncompressed file are effectively completely different.

Yes.  Except that I'm not /absolutely/ sure that a "null defrag", that 
is, one that doesn't have anything to do since everything is already 
defragged and compression is the same either way, actually does nothing, 
thereby leaving the COW linkages intact.  I /believe/ that to be the 
case, and if it /is/ the case, a defrag with the same compression on 
already defragged (due to autodefrag) data /shouldn't/ blow up data usage 
against snapshots, since it wouldn't actually move anything, but I don't 
/know/ that for sure and not being a coder I can't so easily just go and 
look at the code to see, either.

And since I basically don't use snapshots, preferring actual backups, it 
wouldn't be that easy for me to check by simply trying a few GiBs of 
defrag (since I too use compress=lzo,autodefrag) and comparing before and 
after usage, since there's no snapshots that it'd be duplicating against.

But it should be a fairly easy thing to check.  (This is where I wonder 
if you're the OP.  Obviously if so, /something/ triggered that change in 
size.)

Assuming you're not the OP and you're more concerned about future 
behavior, since you're already using autodefrag and snapshots, a before 
and after btrfs filesystem df check, with a defrag of a few GiB between, 
enough to tick over a couple digits of data usage on the df should it be 
doubling things, should help prove one way or the other.  If that doesn't 
increase usage, the same test but with say -czlib, since you're currently 
using lzo, should force the COW-link breakage and double the usage for 
that few GiB, thereby proving both the leave-alone case of no change, and 
the COW-link breakage doubling.  It'd cost that few GiB of extra space 
usage, but should clear up the question, one way or the other.

> My 'main' backup is to rsync to a ext4 formatted drive.  I have a second
> backup (reminder to use it).  That is btrfs and uses snapshots. However,
> I rsync to it, I'm assuming that if my btrfs that I am backing up is
> corrupted then there is a danger that send/receive could propagate
> errors?  Without knowing any better it seems like something worth
> eliminating.

>From what I've seen onlist, if send/receive completes on both sides (send 
and receive) without error, you have a pretty reliable backup.  If 
there's anything wrong, one side or the other errors out.  Actually, due 
to various corner-case bugs they're still flushing out, send/receive can 
error out even if both sides are fine, too, just because something 
happened that nobody thought of yet.  One recently fixed bug, for 
example, was a scenario where two subdirs were originally nested B inside 
of A, but switched positions so A was inside B.  Until that fix, send/
receive couldn't make sense of that situation and would simply error out.

So as long as send/receive works it should be reliable.  The trouble 
isn't that it propagates filesystem corruption as it'll error out before 
it does that, but that at present there's still enough legitimate but 
strange corner-cases that it errors out on, that it isn't a reliable 
backup mechanism for /that/ reason, not because it'll propagate 
corruption.  So you can use it with confidence as long as it's working.  
Just be prepared for it to quit working without notice, even after it has 
been working reliably for awhile, and have a fallback backup method ready 
to go should that happen.

That said, since you're already using rsync, I'd suggest staying with 
that, for now.  There will be plenty of time to switch to the more 
efficient btrfs send/receive after both btrfs and send/receive have 
matured rather longer.

> I've amended my scripts so the toplevel subvol and snapshots are now
> only mounted during snapshot creation and deletion.
> 
>>> This is an interesting point.  The changes are not too radical, all I
>>> need to do is add code to my snapshot scripts to mount and unmount my
>>> toplevel btrfs tree when performing a snapshot. Not sure if this
>>> causes any sigificant time penulty as in slowing of the system with
>>> any heavy IO.  Since snapshots are run by cron then the time taken to
>>> complete is not critical, rather whether the act of mounting and
>>> unmounting causes any slowing due to heavy IO.
>> 
>> [U]nless there's something strange going on, mounts shouldn't
>> affect ongoing I/O much at all.  Umounts are slightly different, in
>> that on btrfs there can be some housekeeping that must be done before
>> the filesystem is fully unmounted that could in theory disrupt ongoing
>> I/O temporarily, but that's limited to writable mounts where some
>> serious write-activity occurred, such that if you're just mounting to
>> do a snapshot and umounting again, I don't believe that should be a
>> problem, since in the normal case there will be only a bit of metadata
>> to update from the process of doing the snapshot.
>> 
>> 
> This is an interesting point.  When I first modified my scripts to
> mount/umount the top-level sub-volume I found things slowing
> dramatically.  Heavy disk IO and usage of btrfs-cleaner, btrfs-transact
> and btrfs-submit for minutes on end.  Brief pauses whilst the system
> became usable.

That /might/ be the inode_cache thing.  Like I said, that's not 
recommended, with one of the down sides being high I/O at mount.  I 
definitely wasn't considering it when I said mounts shouldn't affect 
ongoing I/O!

So try without that, tho I can't say that's the /entire/ problem, but it 
certainly won't be helping things!

> Something else odd seems to be happening right now.  I'm cleaning out
> some directories to free up disk space, /tmp-old out of / and also
> associated snapshots.  This is on SSD but I can hear my traditional HDDs
> thrashing.  Separate btrfs file systems.  Presumably a coincidence.
> 
> Hopefully things will settle down.  Though the system is still doing a
> lot of disk io it is a lot more usable than earlier.

One other thing that might be part of it.  Currently, btrfs does a lot of 
re-scanning (effectively btrfs device scan) as neither the userspace nor 
the kernel properly caches and reuses active btrfs filesystem and device 
information.  So mounts and various btrfs userspace actions will rescan 
instead of caching, while OTOH, the kernel btrfs subsystem can sometimes 
be oblivious to device changes that other bits of the kernel already know 
about.  There have actually been some real recent patches targeting that, 
but I think they'll hit kernel and userspace v3.16, as at least some of 
them were too late for kernel v3.15.

But try without inode_cache as I suspect that may well be a good part of 
it right there, and I'd really like to know whether I'm right or wrong on 
that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

