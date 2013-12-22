Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48200 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3LVLgX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Dec 2013 06:36:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VuhKY-0001mh-6n
	for linux-btrfs@vger.kernel.org; Sun, 22 Dec 2013 12:36:22 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Dec 2013 12:36:22 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Dec 2013 12:36:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
Date: Sun, 22 Dec 2013 11:35:53 +0000 (UTC)
Message-ID: <pan$ba575$c4e4093$f5b3203$522a159c@cox.net>
References: <52B2BBE1.8090306@gmail.com>
	<CAN05THTwCnmMGh=A0zpgEHqDvoKmokNStfN6wyfVNaFoLxNxBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ronnie sahlberg posted on Sat, 21 Dec 2013 17:15:33 -0800 as excerpted:

> Similar things happened to me. (See my unanswered posts ~1Sep, this fs
> is not really ready for production I think)

No "I think" about that one.  Known fact.  Btrfs is not yet fully stable 
and is still under heavy development, and there are public warnings about 
having backups and being prepared to use them before testing it, too.

[snip]

> Then  depending on how important your data is, you start making backups
> regularely, or switch to a less fragile and unrepairable fs.

Of course, if the data's /that/ important, backups that are tested and 
ready to use have been done already, even if it's on a stable filesystem; 
certainly even more so if it's on a development filesystem.  Otherwise, 
the data simply isn't that important, no matter what people might claim, 
as their actions belie their words!

While the btrfs kernel config option no longer (as of 3.12 IIRC) directly 
calls the filesystem unstable, it /does/ say the disk format is "no 
longer expected to change", which doesn't exactly sound entirely stable, 
either (you don't see that sort of qualifier on ext4, for instance, let 
alone ext3, or reiserfs, the generation of filesystem that some of the 
folks who /really/ value their data are either still on or have just 
recently upgraded from).  Further, it points to 
http://btrfs.wiki.kernel.org , which on the main page under stability 
status has this to say:

>>>> The Btrfs code base is under heavy development.

... And under getting started, it says:

>>>> Note also that btrfs is still considered experimental. While many
>>>> people use it reliably, there are still problems being found.

... and (offset in red even)...

>>>> You should keep and test backups of your data, and be prepared to
>>>> use them.

So no doubt about it or secret there; people should have TESTED backups 
they are PREPARED TO USE before they stick anything on btrfs in the first 
place.

Failure to do that simply demonstrates in action if not in word that the 
data isn't considered valuable enough to bother reading and following the 
warnings about keeping tested backups they're prepared to use, while 
placing it on a filesystem known to be under heavy development and not 
fully stable yet, that being the reason for such warnings in the first 
place!

And the "but I didn't know" excuse isn't valid either, for the same 
reason.  If they care about their data, they have backups even on stable 
filesystems, and if they care /enough/, they've made it their business to 
know the stability of the entire system, including the filesystem, that 
data is on, too.

Anything else... simply demonstrates by their actions that they didn't 
care about their data as much as they might have said they did after 
all.  And when people play the odds on the safety of their data, instead 
of having redundant backups to a level of safety matching the level of 
value they claim to place on that data,  sometimes they lose.  It's as 
simple as that.

(Not that I'm always perfect about keeping current backups either, but if 
I lost the working copy and didn't have a current backup, I'd know 
exactly who to point the finger at... myself!  Meanwhile, while it's not 
always current, for the data I value I do tend to have multiple layers of 
backup, to the degree that if I lose them all, it'll mean something 
drastic enough has happened that I'll have more important things to worry 
about than recovering my data for awhile... like surviving whatever 
disaster took all those levels of backup away at once!  Other than that, 
if I lose the working copy and perhaps the first level of backup, yeah 
I'll be mad at myself for not having kept up with the backups, but oh, 
well, I'll pick up with the backups I have and life will go on.  I've 
done it before and if it comes to it I'll do it again!)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

