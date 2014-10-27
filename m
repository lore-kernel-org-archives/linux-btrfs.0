Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37688 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaJ0GpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 02:45:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xie3C-00075x-K3
	for linux-btrfs@vger.kernel.org; Mon, 27 Oct 2014 07:45:10 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 07:45:10 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 07:45:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Heavy nocow'd VM image fragmentation
Date: Mon, 27 Oct 2014 06:44:55 +0000 (UTC)
Message-ID: <pan$4e84a$ffedf07b$87004c5f$2b46a75a@cox.net>
References: <5449898B.4090708@nuclearwinter.com>
	<20141024114916.GI12554@merlins.org> <544B0DDC.1020102@pobox.com>
	<pan$37631$612ebdea$68e82275$b6e96b7b@cox.net>
	<544D2D6D.6050301@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Larkin Lowrey posted on Sun, 26 Oct 2014 12:20:45 -0500 as excerpted:

> One unusual property of my setup is I have my fs on top of bcache. More
> specifically, the stack is md raid6  -> bcache -> lvm -> btrfs. When the
> fs mounts it has mount option 'ssd' due to the fact that bcache sets
> /sys/block/bcache0/queue/rotational to 0.
> 
> Is there any reason why either the 'ssd' mount option or being backed by
> bcache could be responsible?

Bcache... Some kernel cycles ago btrfs on bcache had known issues but IDR 
the details.  I /think/ that was fixed, but if you don't know what I'm 
referring to, I'd suggest looking back in the btrfs list archives (and 
assuming there's a bcache list, there's too), to see what it was, whether 
it was fixed, and (presumably on the bcache list) current status.

... Actually just did a bcache keyword search in my archive and see you 
on a thread, saying it was working fine for you, so never mind, looks 
like you are aware of that thread, and actually know more about the 
status than I do...

I don't believe the ssd mount option /should/ be triggering 
fragmentation; I use it here on real ssd, but as I said, I don't have 
that sort of large-internal-write-pattern file to worry about and have 
autodefrag set too, plus compress=lzo so filefrag's reports aren't 
trustworthy here anyway.

But what I DO know is that there's a nossd mount option available if the 
detection's going whacky and it's adding the ssd mount option 
inappropriately.  That has been there for a couple kernel cycles now.  
See the btrfs (5) manpage for the mount options.

So you could try the nossd mount option and see if it makes a difference.


Meanwhile, that's quite a stack you have there.  Before I switched to 
btrfs and btrfs raid, I was running mdraid here, and for a period ran lvm 
on top of mdraid.  But as an admin I decided that was simply too complex 
a setup for me to be confident in my own ability to properly handle 
disaster recovery.  And because I could feed the appropriate root on 
mdraid parameters directly to the kernel and didn't need an initr* for 
it, while I did for lvm, I kept mdraid, and actually had a few chances to 
practice disaster recovery on mdraid over time, becoming quite 
comfortable with it.

But not only do you have that, you have bcache thrown in too, and in 
place of the traditional reiserfs I was using (and still use on my second 
backups and media partitions on spinning rust as I've had very good 
results with reiserfs since data=ordered became the default, even thru 
various hardware issues... I'll avoid the stories), you're using btrfs, 
which has its own raid modes, altho I suppose you're not using them.

So that is indeed quite a stack.  If you're comfortable with your ability 
to properly handle disaster recovery at all those levels, wow, you 
definitely have my respect.  Or do you just have it all backed up and 
figure if it blows up and disaster recovery isn't going to be trivial you 
simply rebuild and restore from backup?  I guess with btrfs not yet fully 
stable and mature that's the best idea at its level anyway, and if you 
have it backed up for that, then you have it backed up for the others 
and /can/ simply rebuild your stack and restore from backup, should you 
need to.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

