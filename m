Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45289 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201AbbKTGTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 01:19:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zzf2j-0002pX-NB
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 07:19:33 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 07:19:33 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 07:19:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Self-destruct of btrfs RAID6 array
Date: Fri, 20 Nov 2015 06:19:22 +0000 (UTC)
Message-ID: <pan$45d17$6b1fcbdd$1bef940d$802fc012@cox.net>
References: <564E9D62.4050306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paul Loewenstein posted on Thu, 19 Nov 2015 20:11:14 -0800 as excerpted:

> I have just had an apparently catastrophic collapse of a large RAID6
> array.  I was hoping that the dual-redundancy of a RAID6 array would
> compensate for having no backup media large enough to back it up!

Well...

First, while btrfs in general is "stabilizing" and is noticeably better 
than it was a year ago, it remains "not yet fully stable or mature."

There's a sysadmin's rule of backups, that if it's not backed up, you 
value the data it contains less than the time/trouble/resources of making 
a backup, and thus, should it fail, regardless of any loss of data you've 
saved what your actions defined as /really/ valuable, the time/trouble/
resources saved by not doing the backup, and thus should be happy as you 
saved the real important stuff.

Because btrfs isn't yet fully stable, having backups is even more 
important than it would be on a fully stable filesystem like xfs, ext*, 
or reiserfs (my previous favorite and what I still use on spinning rust 
and for backups), so that sysadmin's rule of backups applies double.

Of course some distros are choosing to deploy and support btrfs as if 
it's already fully stable, and that's their risk and their business for 
doing so, but by the same token, for that you'd get support from them, 
not from the upstream list (here), where btrfs is still considered to be 
"stabilizing, not yet fully stable".

Second, btrfs raid56 mode is much newer than btrfs in general, and isn't 
yet close to even the "stabilizing, good enough provided you have good 
backups or are using throw-away data" general level of btrfs.  Nominal 
code-completion was only kernel 3.19, and there were very significant 
bugs with it and 4.0, into the early 4.1 cycle, tho by 4.1 release the 
worst and known bugs were fixed.  But as a btrfs user and list regular, I 
and others have repeatedly recommended that people not consider btrfs 
raid56 mode as "stabilizing-stable" as btrfs in general is, for at least 
a year (five kernel cycles) after nominal code completion in 3.19, and 
even then, people thinking about using btrfs raid56 should check the list 
for recent bugs and consider, before deploying in anything but throw-away-
data (which can be because it's backed up data) test mode.  Of course 
that would be kernel 4.4, which is currently in development.

And as it happens, kernel 4.4 has been announced as a long-term-stable 
series, so things look to be working out reasonably well for those 
interested in first-opportunity-stablish btrfs raid56 deployment on it. 
=:^)

Since we're obviously not at 4.4 release yet, and in fact you're 
apparently running 4.1 stable series, that means btrfs raid56 mode must 
still be considered less stable than btrfs as a whole, which as I said is 
itself "still stabilizing, not fully stable and mature", so now we're at 
double-the-already-doubled-strength, 4 times the normal strength, of the 
sysadmin's backup rule.

So it's four-times self-evident that if you didn't have backups for data 
on raid56 mode btrfs, by your actions you placed a *REALLY* low value on 
that data!  So losing it is /very/ trivial, at least compared to the time 
and resources you can be happy you saved by not having a backup. =:^)

That said, there's still hope...

First, because btrfs raid56 mode /is/ so new and not yet stable, you 
really need to be working with the absolute latest tools in ordered to 
have the best chance at recovery.  That means kernel 4.3 and btrfs-progs 
4.3.1, if at all possible.  You can use earlier, but it might mean losing 
what's actually recoverable using the latest tools.

> Any suggestions for repairing this array, at least to the point of
> mounting it read-only?  I am thinking of trying to mount it degraded
> with different devices missing, but I don't know if that will be an
> exercise in futility.
> 
> btrfs fi show still works!
> 
> Label: 'btrfsdata'  uuid: ccde0a00-e50b-4154-977f-ac591ab580a5
>          Total devices 6 FS bytes used 9.62TiB
>          devid   10 size 3.64TiB  used 2.41TiB path /dev/sdg
>          devid   11 size 3.64TiB used 2.41TiB path /dev/sda
>          devid   12 size 3.64TiB used 2.41TiB path /dev/sdb
>          devid   13 size 3.64TiB used 2.41TiB path /dev/sdc
>          devid   14 size 3.64TiB used 2.41TiB path /dev/sdd
>          devid   15 size 3.64TiB used 2.41TiB path /dev/sde
> 
> It spontaneously (I believe it was after it successfully mounted rw on
> boot, but I can't check for sure without looking at the last file
> creation time).  After another reboot it won't mount at all.

You say mount, but there's no hint of the options you've tried.

If you've not yet read up on the user documentation on the wiki,
https://btrfs.wiki.kernel.org , I suggest you do so.  There's a lot of 
useful background information there, including discussion of mount 
options and recovery.

What you will want to try here if you haven't already is a degraded,ro 
mount, possibly with the recovery option as well (try it without first, 
then with, if necessary).

If you've not tried degraded writable yet, there's a possibility mounting 
degraded, writable, will work, but if it does, you want to do device 
replaces/deletes to get undegraded as soon as possible, preferably with 
as little other writing to the filesystem as possible, as if new chunks 
need allocated to do further writes they may be allocated in single mode, 
and there's currently a bug which won't allow degraded read-write mount 
after that, because btrfs sees the single-mode chunks on a degraded 
filesystem and thinks there may be others on the missing devices, without 
actually checking.  As a result, you often get just one shot at a 
writable mount to undegrade, and if that doesn't work, the filesystem is 
often only read-only mountable after that.  (This bug applies to all 
redundant/parity raid modes so to raid1 and raid10 as well, not just 
raid56.)

If you /had/ tried degraded mounting, that bug may be why you're now 
unable to mount again, writable, but degraded,ro, is likely to still 
work.  There's actually a patch for the bug, that makes btrfs check the 
actual chunk allocation to see if all are accounted for on the existing 
devices, allowing writable mounting if so, but it's definitely not in 4.1 
or 4.2, tho I think it might have made 4.3.  (If so it could possibly be 
backported to stable-series 4.1 at least, but it's unlikely to be there 
yet.)


If the various degraded,recovery,ro options don't work, the next thing to 
try is btrfs restore.  This works with an unmounted filesystem using the 
userspace code, so a current btrfs-progs, preferably 4.3.0 or 4.3.1, is 
recommended for the best chance at success.

What btrfs restore does is try to read the unmounted filesystem and 
retrieve files from it, writing them to some other mounted filesystem 
location.  Newer btrfs restore versions have options to save ownership/
permissions and timestamp data, and rewrite symlinks as well, otherwise 
the files are written as the executing user (root) using its umask.  
There's options to write only selective parts of the filesystem, and/or 
to restore specific snapshots (which are otherwise ignored), as well. 
Obviously you'll need space at wherever you point restore at to write 
whatever you intend to restore, but if you didn't have a current backup, 
as people considering this option obviously didn't, this is basically 
replacing the space you would have otherwise dedicated to backups, so 
it's not too horrible.

With a bit of luck, restore will work without further trouble.  If it 
doesn't, there's more damage, but btrfs does keep a history of main 
roots, and btrfs-find-root can be used to list them, with btrfs restore 
able to take a root by its bytenr, using the -t option.  Here's the wiki 
page link with further instructions, tho last I looked it was a bit dated.

https://btrfs.wiki.kernel.org/index.php/Restore

A hint, in case it's not obvious from the wiki page, generation, and 
transid/transaction-id, are the same thing. =:^)

Of course, also see the btrfs-restore manpage, which now actually lists 
the wiki link for more info.  As I said the wiki page was a bit dated 
last I looked, so definitely check the manpage, and pay attention to the 
newer options such as -l (list roots, useful with -t to see if that root 
is a good restore candidate), -D (dry run), and -m and -S, metadata and 
symlinks, without which files will be restored as the writing user (root) 
using the present umask, with current timestamps, and no symlinks.


If btrfs restore fails you, then getting a dev interested in the specific 
errors you have and patches to fix them, is your only hope.  But of 
course, since you already saved what was most important to you, the time 
and resources you would have otherwise spent to do the backup, and what 
might be lost here is as explained above at most valued at 4X-trivial, 
you can still be happy that you saved the really important stuff and any 
loss really /is/ trivial. 

(Seriously, when you compare the loss of a bit of data to what those 
folks in France lost recently, or what those Syrian refugees are risking 
and at times losing, their lives, or what the folks in 9/11 lost... in 
perspective, losing a bit of data here really *is* trivial.  The fact 
that we're both here at all, along with the others on the list, 
discussing this, makes us all pretty lucky, all things considered!  
Sometimes it does help to step back and get some /real/ perspective! =:^)

> Looking back in the journal (I shall now be setting up journal
> monitoring), I found lots of errors, starting last September, only a few
> weeks after converting from RAID1 to RAID6.
> Blank lines precede reboots and for the first log indicate the omission
> of over 30K entries!  The first log must represent some software bug,
> because /dev/sdh is NOT a btrfs device!

That very possibly indicates either a different device-detection order 
and thus device letter assignment on boot, such that one of the other 
devices appeared as /dev/sdh at that boot, or a device dropping out and 
reappearing as sdh, instead of whatever letter it had previously.  On 
today's hardware, such device reordering isn't uncommon, thus the switch 
to mounting by UUID or filesystem labels, for instance, as opposed to the 
now somewhat unpredictable /dev/sdX devices names, since the X can change!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

