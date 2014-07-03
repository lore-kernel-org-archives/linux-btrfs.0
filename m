Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57847 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbaGCHrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 03:47:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X2bjc-00066q-Ao
	for linux-btrfs@vger.kernel.org; Thu, 03 Jul 2014 09:47:12 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 09:47:12 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 09:47:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
Date: Thu, 3 Jul 2014 07:47:00 +0000 (UTC)
Message-ID: <pan$cc322$c9ff4b20$3248418d$bde8209@cox.net>
References: <20140702204152.GI20961@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Wed, 02 Jul 2014 13:41:52 -0700 as excerpted:

> This got triggered by an rsync I think. I'm not sure which of my btrfs
> FS has the issue yet since BUG_ON isn't very helpful as discussed
> earlier.
> 
> [160562.925463] parent transid verify failed on 2776298520576
> wanted 41015 found 18120
> [160562.950297] ------------[ cut here ]------------
> [160562.965904] kernel BUG at fs/btrfs/locking.c:269!
> 
> But shouldn't messages like 'parent transid verify failed' print which
> device this happened on to give the operator a hint on where the problem
> is?
> 
> Could someone do a pass at those and make sure they all print the device
> ID/name?

kernel 3.16 series here, rc2+ when this happened, rc3+ now.  IOW it's 
3.15 series (Marc) and 3.16 series (me) both known affected.

FWIW, I'm not sure what originally triggered it, but I recently had a 
couple bad shutdowns -- systemd would say it was turning off the system 
but it wouldn't shut off, and on manual shutoff and later reboot, the 
read-write-mounted btrfs (two separate filesystems, home and log, root, 
including the rest of the system, is read-only by default, here) failed 
to mount.

The mount failures triggered on the above parent transid failed errors 
with kernel BUG at fs/btrs/locking.c -- I /believe/ 269, but I couldn't 
swear to it.

The biggest difference here (other than the fact that it happened on 
mount of critical filesystems at boot, so probably double-digit seconds 
in since boot at most) was that the parent transid numbers were only a 
few off, something like wanted nnnn, found nnnn-2.

[End of technical stuff.  The rest is discussion of my recovery 
experience, both because it might be of help to others and because it 
lets me tell my experience. =:^) ]

I have backups but they weren't as current as I would have liked, so I 
decided to try recovery.

My rootfs is btrfs as well, a /separate/ btrfs, but it remains mounted 
read-only by default and is only mounted read-write for updates, so 
wasn't damaged.  That includes the bits of /var that I can get away with 
being read-only, with various /var/lib/* subdirs being symlinks to
/home/var/lib/* subdirs, where they need to be writable, and of course 
/var/log being a separate dedicated filesystem -- one of the two that was 
damaged, and the usual /var/run and /var/lock symlinks to /run and 
/run/lock (with /run being a tmpfs mount on standard systemd 
configurations).  As a result, the rootfs mounted from the initramfs and 
systemd on it was invoked as the new PID 1 init in the transfer from 
initramfs.  Systemd was in turn able to start early boot services and 
anything that didn't have a dependency on home (including the bits of /
var/lib symlinked into home) or log being mounted.  But that of course 
left a number of critical services failing due to dependency on the home 
and/or log mounts, since those mounts were failing.

Fortunately, while some of the time the errors would trigger a full 
kernel lockup with the above parent transid and locking BUG, other times 
the mount attempt would simply error out, and systemd would drop me to 
the emergency-mode root-login prompt.  (If it hadn't, I'd have had to 
switch to booting the backup.)

Since the main rootfs including /usr, /etc and much of /var was already 
mounted and safely read-only so I wasn't too worried about damaging it, 
that left me with only a partly working system, but access to all the 
normal recovery tools, manpages, etc, I'd normally have.  The only big 
thing (other than X/kde, of course) initially was network access, due to 
dependencies on the unmountable filesystems for local DNS and I think 
iptables logging.  I could have reconfigured that if I had to, but after 
I got log back up, I found I had network access (presumably with fallback 
to the ISP DNS), and was able to get to the wiki to research recovery of 
home a bit further.

I decided to tackle log (/var/log) before home since it was smaller and I 
figured I could use anything I learned in that process to help me save 
more of home.  My policy is no backup log partition, since I don't do 
backups regularly enough for the logs thereon to be of much likely 
usefulness.  That left me trying to repair or recover what I could and 
then doing a mkfs.btrfs on it.  The various repair options I tried didn't 
help -- they either died without helpful output or triggered the same 
lockup.  Mount with the recovery or recovery,ro wouldn't work, and 
neither would btrfs check.

Btrfs rescue didn't look useful, as I couldn't find useful documentation 
on chunk-recover and the supers looked fine (btrfs-show-super) so super-
recover was unnecessary.  I tried btrfs-zero-log on the log partition, 
but it didn't make the problem better and might have made it worse, so 
didn't try it on home.

That left btrfs restore.  I used it on log without really understanding 
what I was doing, and lost an entire directory worth of logs.
=:^(  Fortunately, I was able to learn a bit, however, and the home 
restore went rather better, with no permanent loss AFAIK.

FWIW I also tried btrfs-image but it couldn't get anywhere at all -- the 
result was a zero-byte image.

The *OTHER* thing I learned, which in hind sight I should have known but 
didn't think about until after I was beyond fixing it, was that if one 
wants to experiment with a filesystem and thus does a direct dd image of 
the device to a file for later dd back, if necessary, for btrfs raid1, dd 
*ALL* devices to separate images, not just one of two, figuring the other 
is raid1-identical anyway, because it's NOT.

I had dd-ed one device of the btrfs raid1 log btrfs and verified matching 
md5sums on the device and image to be sure, before I tried btrfs-zero-
log, figuring I could simply dd the image back if that didn't help.  But 
since it was raid1 and the images were of course somewhat large being 
whole-partition images, I thought I only needed one of the two, and made 
the mistake of neither dd-ing the second one, nor md5sum verifying my it-
turned-out-invalid assumption that the second device matched the first 
(which of course it doesn't, the data and metadata may or may not be 
identical but there's device specific info I suppose in the supers, at 
least).  So after I found out btrfs-zero-log wasn't going to help, I had 
only one image of the two to dd back in ordered to try something 
different.

It's possible that had I actually dd-ed both images and could thus have 
dd-ed both back after btrfs-zero-log didn't help, I could have recovered 
more of the log files on that filesystem than I did, because I'd have had 
the raid1 second copy to work from as well.  But anyway, logs have only a 
certain value to me, and if I'm to lose files, log files are what I'd 
choose to lose.  And I learned to dd *BOTH* images next time and indeed 
did just that for home, so all in all, I'm prepared to say that it was a 
worthwhile trade, a few log files destroyed for the knowledge and 
experience gained. =:^)

Moving on... After I btrfs restored what I could from the damaged log 
btrfs, I mkfs.btrfs-ed it and copied what log files I had recovered back 
to the new filesystem.  A reboot later and I had confirmed that systemd 
could mount the new filesystem at boot again now, and I tackled home.  
Except by this time I was sleepy and I had work the next day, so shut 
back down and went to bed, saving the home challenge for a day later.

Upon reboot after work the next day, I found that the network was working 
again, and I could access the wiki to reread about btrfs-find-root and 
btrfs restore, on the wiki.

While it took me a bit of experimentation (I'm going to try to update the 
wiki to reflect what I learned, as the page covering restore and fine-
root is still a bit vague, mentioning information it isn't exactly clear 
how to get, maybe this'll be what it takes to actually get me to get a 
wiki account so I /can/ do such updates), eventually I figured out that  
generation and transid effectively refer to the same thing (which the 
wiki does suggest), and that the tree roots which the wiki mentions you 
should look to see that there are as many as possible of, are enumerated 
on the restore -l (list tree roots) report.  That last bit the wiki 
currently doesn't mention at all -- I had to find -l by myself.

Meanwhile, at this point the pieces began to all fall together, and I 
figured out that the very same parent transid verify failed numbers 
mentioned in the found/wanted as output by the kernel traces, were the 
generation numbers as well, AND how btrfs-find-root and btrfs restore as 
well as the kernel traces all fit together on this generation/transid 
thing.  Further, this generation/transid thing increases serially as it 
is in effect tracking the root-tree-root commit count -- the times the 
filesystem has actually been fully atomically updated and had a new root-
tree-root committed.

These transaction ID verify faileds I was seeing in the logs referred to 
these same transid/generation numbers (simple enough to infer when the 
found/wanted were only a couple commits different, as I was seeing but as 
is NOT the case above), and I could actually tell restore to look for 
different roots that it could still find, based on the associated bytenr 
reported by btrfs-find-root.

Suddenly a lot of those logs I've seen posted with found/wanted 
generation/transid numbers actually make some sort of sense!

So after figuring all that out, it turned out that both the generation/
transid recorded in the supers as current, and the one 1-commit back, 
were both nearly entirely whole.  Only a handful of found/wanted errors 
on the restore, tho I had to run it several times to fill in additional 
files as it kept deciding it was looping too much in the big dirs and 
wasn't making progress.

And as far as I can tell, the only missing files in the restore are the 
last few rss/atom feed updates that my feed reader pulled.  The other 
possibilities would be news (nntp) updates, but my client would show the 
messages as unread again if it lost them and that didn't happen, and 
mail, but while my servers are POP3 only, my client is configured to 
download but not delete for a week, just in case something like this 
/does/ happen and I lose a few messages locally, so again, I'd get 
messages shown as new again, and I didn't.  So AFAIK, the rss/atom feed 
was the only thing affected, and like the logs, that's only of limited 
value to me and no big loss.

So after the restore, again I did a new mkfs.btrfs to recreate a new 
filesystem, mounted and copied everything back from the restore.

**BUT**  One OTHER thing I learned about btrfs restore!  The --help 
output (and manpage) suggest that -x is used to restore extended 
attributes.  What it does *NOT* say is that evidently, "extended 
attributes" in this case includes file ownership and standard *ix 
permissions.  Either that or restore never restores those in any case, 
I'm not sure which.

Anyway, while restore seemed to give me back nearly all my files, they 
were all root/root ownership, root umask-modified perms (644, 744 for 
dirs).  THAT metadata was a HEADACHE to restore -- manually!

Fortunately I was able to hack up a find -exec script to compare 
ownership and perms on the backup (which as I mentioned I had tho it was 
a bit less current than I would have liked), doing a
chown/chmod --reference to the file in the backup, where the file existed 
in the backup.  That covered most files, but there were still a few left 
root/root/644.  But a bit of admin time with mc to find and figure out 
appropriate ownership/perms for each (recursive) case and those were  
corrected as well.

So, umm... while I hope there isn't a next time, at least I actually have 
some idea/experience how restore works now, and I know a couple things 
NOT to do next time, as well to try -x on btrfs restore and hope that 
restores ownership/perms too.  If not, then I guess we need an improved 
restore that can, because having everything restored as root/root/644 
SUCKS, tho obviously not as much as not having it restored AT ALL would 
suck!.

And, hopefully some users find this experience helpful.  I know if 
someone would have posted it before, I'd have definitely read it with 
interest, retaining at least some of it, and would have likely saved it 
for later reference, just in case.  So it would have helped me, and 
here's hoping it can help someone else as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

