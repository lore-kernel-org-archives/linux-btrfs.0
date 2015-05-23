Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57887 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961AbbEWQwb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 May 2015 12:52:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YwCez-0005v1-IS
	for linux-btrfs@vger.kernel.org; Sat, 23 May 2015 18:52:29 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2015 18:52:29 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2015 18:52:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
Date: Sat, 23 May 2015 16:52:19 +0000 (UTC)
Message-ID: <pan$9da5d$8559e11b$1dc0dccb$67ad3c9d@cox.net>
References: <554F6D43.2060806@googlemail.com>
	<554F7232.9080804@googlemail.com> <5557F490.5000606@googlemail.com>
	<pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net>
	<1432385390.4187.15.camel@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Philip Seeger posted on Sat, 23 May 2015 14:49:50 +0200 as excerpted:

> Is this a known side effect, that files could get corrupted if no
> balance is run (not counting the balance with 4.0 which doesn't work due
> to that commit) after an ext4 conversion?

I'm not sure.

What I am sure of is that I'd not trust a btrfs converted from ext* until 
the saved subvol is deleted, and a defrag and balance run.  Even then, 
I'd personally be more comfortable with a fresh mkfs.btrfs, and copy over 
from backup, tho I know reality is that btrfs /needs/ a working 
conversion program or it'll never take off as the default successor to 
the ext* crown, as it wants to be.  I simply don't trust that conversion, 
as I've seen too many people have problems with their btrfs after doing 
the conversion from ext*.

Balance-conversions between raid modes of btrfs are a little different, 
and somewhat more trustworthy... to me, anyway.

To be fair, it might well be a personal bias of mine against ext* in the 
first place, as I never really was comfortable with it for various 
reasons.  Among others, I think enough kernel devs see ext* as simple 
enough to meddle with that it gets more changes than it really should 
have, ext3's period with data=writeback as the default being a primary 
example.  Reiserfs, my personal favorite, and xfs, and now btrfs, all 
seem to be different enough that the hacking is left to the folks that 
really know the filesystem, with others leaving it to the experts as 
they're afraid to touch it, at least more so than ext*.  Anyway, it's 
quite possible I have enough of a bias there that it taints anything 
converted from it more than it should as well.  Either way, I personally 
just don't trust ext* conversions, and would rather see people do 
mkfs.btrfs and copy over from backup, as I think the filesystem is 
cleanly native btrfs that way, and has less problems as a result.

But you really need a second opinion before trusting /that/, because as I 
said, it might simply be my personal bias talking.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

