Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51125 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbaJ0XSK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 19:18:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XitY8-0006IB-EL
	for linux-btrfs@vger.kernel.org; Tue, 28 Oct 2014 00:18:08 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 00:18:08 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 00:18:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs unmountable: read block failed check_tree_block; Couldn't
 read tree root
Date: Mon, 27 Oct 2014 23:17:58 +0000 (UTC)
Message-ID: <pan$db558$7ef21104$8d3c61ca$273592f9@cox.net>
References: <544E4747.2000008@uni-osnabrueck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ansgar Hockmann-Stolle posted on Mon, 27 Oct 2014 14:23:19 +0100 as
excerpted:

> Hi!
> 
> My btrfs system partition went readonly. After reboot it doesnt mount
> anymore. System was openSUSE 13.1 Tumbleweed (kernel 3.17.??). Now I'm
> on openSUSE 13.2-RC1 rescue (kernel 3.16.3). I dumped (dd) the whole 250
> GB SSD to some USB file and tried some btrfs tools on another copy per
> loopback device. But everything failed with:
> 
> kernel: BTRFS: failed to read tree root on dm-2
> 
> See http://pastebin.com/raw.php?i=dPnU6nzg.
> 
> Any hints where to go from here?

Good job posting initial problem information.  =:^)  A lot of folks take 
2-3 rounds of request and reply before that much info is available on the 
problem.

While others may be able to assist you in restoring that filesystem to 
working condition, my focus is more on recovering what can be recovered 
from it and doing a fresh mkfs.

System partition, 250 GB, looks to be just under 231 GiB based on the 
total bytes from btrfs-show-super.

How recent is your backup, and/or being a system partition, is it simply 
the distro installation, possibly without too much customization, thus 
easily reinstalled?

IOW, if you were to call that partition a total loss and simply mkfs it, 
would you lose anything real valuable that's not backed up?  (Of course, 
the standard lecture at this point is that if it's not backed up, by 
definition you didn't consider it valuable enough to be worth the hassle, 
so by definition it's not valuable and you can simply blow it away, 
but...)

If you're in good shape in that regard, that's what I'd probably do at 
this point, keeping the dd image you made in case someone's interested in 
tracking the problem down and making btrfs handle that case.

If there's important files on there that you don't have backed up, or if 
you have a backup but it's older than you'd like and you want to try to 
recover current versions of what you can (the situation I was in a few 
months ago), then btrfs restore is what you're interested in.  Restore 
works on an /unmounted/ (and potentially unmountable, as here) 
filesystem, letting you retrieve files from it and copy them to other 
filesystems.  It does NOT write anything to the damaged filesystem 
itself, so no worries about making the problem worse.

There's a page on the wiki describing how to use btrfs restore along with 
btrfs-find-root in some detail, definitely more than is in the manpages 
or that I want to do here.

https://btrfs.wiki.kernel.org/index.php/Restore

Some useful hints that weren't originally clear to me as I used that page 
here:

* Generation and transid are the same thing, a sequentially increasing 
number that updates every time the root tree is written.  The generation 
recorded in your superblocks (from btrfs-show-super) is 663595, so the 
idea would be that generation/transid, falling back one to 663594 if 95 
isn't usable, then 93, then... etc.  The lower the number the further 
back in history you're going, so obviously, you want the closest to 
663595 that you can get, that still gives you access to a (nearly) whole 
filesystem, or at least the parts of it you are interested in.

* That page was written before restore's -D/--dry-run option was 
available.  This option can be quite helpful, and I recommend using it to 
see what will actually be restored at each generation and associated tree 
root (bytenr/byte-number).  Tho (with -v/verbose) the list of files 
restored will normally be too long to go thru in detail, you can either 
scan it or pipe the output to wc -l to get a general idea of how many 
files would be restored.

* Restore's -l/list-tree-roots option isn't listed on the page either.  
btrfs restore -l -t <bytenr> can be quite useful, giving you a nice list 
of trees available for the generation corresponding to that bytenr (as 
found using btrfs-find-root).  This is where the page's advice to pick 
the latest tree root with all or as many as possible of the filesystem 
trees in it, comes in, since this lets you easily see which trees each 
root has available.

* I don't use snapshots or subvolumes here, while I understand OpenSuSE 
uses them rather heavily (via snapper).  Thus I have no direct experience 
with restore's snapshot-related options.  Presumably you can either 
ignore the snapshots (the apparent default) or restore them either in 
general (using -s) or selectively (using -r, with the appropriate 
snapshot rootid).

* It's worth noting that restore simply lets you retrieve files.  It does 
*NOT* retrieve file ownership or permissions, with the restored files all 
being owned by the user you ran btrfs restore under (presumably root), 
with $UMASK permissions.  You'll have to restore ownership and 
permissions manually.

When I used restore here I had a backup, but the backup was old.  So I 
hacked up a bash scriptlet with a for loop, that went thru all the 
restored files recursively, comparing them against the old backup.  If 
the file existed in the old backup as well, the scriptlet did a chown and 
a chmod using the --reference option, setting the new file's ownership 
and permissions to that of the file in the backup.  That took care of 
most files, but of course anything created since that (old) backup was 
still left as root owned with default UMASK perms.  I then used
find -user root to go thru the files again, giving me a list of those 
which were still root, so I could manually do the chown and chmod on them 
as appropriate.  Of course if you don't have even an old backup, that 
could be quite a few files to have to update ownership and permissions 
for, but at least you do get the file data back!

* Similarly, restore seems to flat-out ignore symlinks.  It didn't 
restore any symlinks at all and I had to manually recreate them as 
necessary.

* I didn't use it here, but restore's --path-regex option could be quite 
useful if you decide you only want to restore some subset of the files, 
either due to space constraints or because you have backups for the 
others or they simply aren't worth the trouble.  You could use this for 
instance to restore all files in /etc to a safe location, then do a mkfs 
and a reinstall, before restoring your /etc files from that location, 
thereby recustomizing your system config.

Using the -D (dry-run) and --patch-regex options together could be useful 
to either make sure your regex does what you expect, or to check what 
files in a particular location of interest within the tree might be 
restored, and which files aren't there and thus are likely to be lost.

* I believe this is fixed in current btrfs-progs versions but when I ran 
restore a couple kernel cycles ago (3.15 I think, would have been progs 
3.14 or 3.14.1 I believe), if there were too many files in the same 
subdir, restore would decide it was taking too long and would give up.  I 
was able to overcome that by running restore repeatedly, pointing it at 
the same restore-to location each time, since it'll normally skip 
existing files.  That let it restore more files each time, and eventually 
I didn't get any more of the taking too long errors, meaning it had 
restored all it could find to restore.

IIRC the fix was to prompt the user whether they wanted to continue or 
not, with an override available to continually say yes, continue.  Of 
course I've not used the newer version so I don't know how well that 
actually works, but I guess it should be easier than my having to 
repeatedly rerun the restore to get all the files.

Hope that helps! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

