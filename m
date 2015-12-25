Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42017 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbbLYIGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 03:06:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aCNOQ-0005BN-2a
	for linux-btrfs@vger.kernel.org; Fri, 25 Dec 2015 09:06:30 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 09:06:30 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 09:06:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs Check - "type mismatch with chunk"
Date: Fri, 25 Dec 2015 08:06:19 +0000 (UTC)
Message-ID: <pan$c92dd$6a940cd1$f625da64$e4be62fc@cox.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com>
	<pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
	<9871.1451021289@ccs.covici.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

covici posted on Fri, 25 Dec 2015 00:28:09 -0500 as excerpted:

> Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> How long have you had the filesystem?  Was it likely created with the
>> mkfs.btrfs from btrfs-progs v4.1.1 (July, 2015) as I suspect?  If so,
>> you have a problem, as that mkfs.btrfs was buggy and created invalid
>> filesystems.

[Different "you", Zach F, not covici.]

> Hmmm, I just used the 4.1 mkfs.btrfs to create some of the file systems
> I have, because that was on the cd I booted with because I had to do
> this offline.  So, can I fix things, ro do I have to find a cd with the
> 4.3.1 programs, or can I put the mkfs.btrfs binary on a USB drive, copy
> the files off, recreate the file systems and do a copy back? grrrr!

I wasn't personally sure if 4.1 itself was affected or not, but the wiki 
says don't use 4.1.1 as it's broken with this bug, with the quick-fix in 
4.1.2, so I /think/ 4.1 itself is fine.  A scan with a current btrfs 
check should tell you for sure.  But if you meant 4.1.1 and only typed 
4.1, then yes, better redo.


Meanwhile, minor correction, not on the primary mkfs.btrfs bug, but of 
discussion of the detection in btrfs check.  I got the btrfs check 
patches mixed up in my head, and AFAIK, the check for this one was always 
correct, but it still can't be fixed.

The one I got it mixed up with was one triggered by btrfs-convert not 
mkfs.btrfs, detect stripes crossing stripe boundary.  _That_ was the one 
where the initial check patch (or more accurately IIRC, the merge process 
for the patch) had an off-by-one error, triggering all sorts of false-
positives.  The affected btrfs check, according to the wiki changelog, 
was 4.2 (Sept 2015), with the fix in 4.2.1 (also Sept 2015).

But my mixup may also apply to the OP/Zach's case as there's a third 
element I mixed up as well, so the rest of this post is primarily aimed 
at him, tho of course it's available for others, including lurkers and 
googlers who come upon it later, as well. =:^)

Just as the one bug was only triggered by one version of mkfs.btrfs and 
the filesystem should be fine otherwise, the one here is triggered by 
btrfs-convert, and shouldn't appear otherwise.  Unfortunately, the btrfs-
convert bug isn't as nailed down, but btrfs-convert has a warning up on 
the wiki anyway, as currently being buggy and not reliable.

While they're working on a rewrite that should fix the btrfs-convert 
issues, even with it fixed I'd neither use it myself, nor recommend its 
use to others.  Here's why:

1) Sysadmin's rule of backups:  For any level of backup, you either have 
it because you consider the data valuable enough to be worth the trouble, 
modified by the risk factor that you might need to actually use that 
backup, or the fact that you don't have it means that by your actions, 
you are declaring that data _not_ to be worth the hassle factor of that 
backup, modified by the chance that you might need to use it.  Despite 
any after-the-loss protests to the contrary, your before-the-loss actions 
declared the time, hassle and resources saved by not making the backup to 
be more valuable than the data that would have been saved had you made 
it, so by definition, backup or not, you saved what was most important to 
you, either the data if you had the backup, or your time and resources if 
you didn't.

With btrfs itself "stabilizing, but not yet fully stable or mature", that 
risk factor is higher than it would be for a fully stable filesystem, so 
the relative value of the data that's valuable enough to backup will be 
lower.

Meanwhile, the hassle factor of doing the conversion, deleting the saved 
subvolume with the ext* rollback, then doing the recommended defrag and 
balance, is non-zero as well, so it already indicates you place SOME 
value on the data, or it'd be simpler just to blow it away with a 
mkfs.btrfs and start over.  Arguably, then, it's worth a backup if it's 
worth converting.

And starting with a fresh mkfs.btrfs on a different device (or set of 
devices, since unlike with btrfs-convert, with mkfs.btrfs you can start 
with a multi-device filesystem if you like), then copying over your data 
from the existing ext*, automatically gives you that existing ext* copy 
as a backup, without any further work! =:^)

Meanwhile...

2) Any filesystem conversion, by definition, will have to make 
compromises, because if the filesystems were exactly the same format, 
there'd be no need for conversion in the first place, which means that by 
definition, the converted filesystem isn't going to be as good a layout 
as a freshly created filesystem, with the data then copied into it so it 
can use its own native layout.  That's in addition to any limitations on 
format that the convert method forces on to you, like the loss of the 
multi-device choice that you can have from the beginning if you use 
mkfs.btrfs.


Between the two of these, it makes far *far* more sense to keep your 
existing ext* as a backup, create a new btrfs on different device(s) 
using mkfs.btrfs and your choice of options, and then copy the data from 
your ext* backup onto the new btrfs, than it does to try to use convert, 
even when convert is working and there's no chance of additional problems 
using it.  It should actually be faster as well, since while you'll have 
to copy the data over from the ext* backup, you won't have to go thru the 
recommended defrag and balance steps that try to mitigate some of the 
compromises made by the initial convert.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

