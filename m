Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41073 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaHJIZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 04:25:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGOR6-00042Q-PO
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 10:25:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 10:25:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 10:25:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sun, 10 Aug 2014 08:24:53 +0000 (UTC)
Message-ID: <pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
	<CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jose Ildefonso Camargo Tolosa posted on Sat, 09 Aug 2014 22:58:37 -0500 as
excerpted:

> Do you think I will have better luck with 3.16? or maybe it is that this
> filesystem has so many errors (remember the btrfs check output) that it
> will take a really long time to mount because it is trying to correct
> this?

As a user I'd give up on that mount.

There are two critical patches in the pipeline ATM, that should hopefully 
hit 3.17-rc1 next weekend.  The one's already posted (See the Fix csum 
tree corruption patch first posted just under 12 hours ago as I type 
this), but that's a longer term fix.  The other was traced down late last 
week but I don't believe a proper patch has been posted yet.  That's the 
one you likely need here.  Of course you could cherrypick it when posted.

Tho either way I think it's likely that the filesystem is toast and 
you'll end up doing a mkfs on it, hopefully with those patches helping to 
prevent a repeat.

What I'd try at this point is btrfs restore, tho you'll need somewhere 
else to put the restored data, and you'll have to redo file ownership and 
permissions as that's not restored, only the data files.

Or restore from backup, your choice, but you said it was remote and 
you're looking at over a week's worth of downloading.

Either way, the question then comes up of what to use when you do a new 
mkfs.  My personal feeling?  Btrfs isn't yet fully stable, and there's a 
very real possibility that one may have to restore from backup, so one 
should be prepared for that.  Given the size of the data store you're 
working with and the remote nature of that backup, with access over 
limited-speed pipes, I wonder if btrfs is really an appropriate choice 
for you at this point.  If you believe the features of btrfs and the 
chance to work with something so leading/bleeding edge are worth the 
current pain and are prepared to redo that restore again should it be 
necessary, then yes, btrfs is a good choice.  OTOH, if you want something 
that reliably "just works" at this point, consider a more mature 
filesystem.  It may not have btrfs' bells and whistles, but a boring 
"just works, reliably", might be what you want.

I guess xfs is the standard recommendation for big-data sizes and it is 
said to be long past the "better have a UPS" days, or of course the 
default ext4.  Personally I've had real good luck with reiserfs (since 
data=ordered by default at least, the early data=writeback days were 
where it got its bad rep), but it's better adapted to smaller files, 
while I'd guess with 40 TB, your files are likely big as well.

You can of course try btrfs again in a year or so, when it should have 
matured quite a bit.  I actually did that after my first try at btrfs, 
leaving for a time then coming back, and was impressed at how much it had 
matured in the mean time.  Additionally, my use-case was different as the 
first time I tried it I was still on spinning rust; now all my btrfs are 
on SSD, and I still use reiserfs for my spinning rust -- tho I've nowhere 
near the double-digit TB scale you're doing.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

