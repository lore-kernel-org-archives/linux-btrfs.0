Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38302 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbaKHChG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 21:37:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xmvtf-0004Tc-MM
	for linux-btrfs@vger.kernel.org; Sat, 08 Nov 2014 03:37:03 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Nov 2014 03:37:03 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Nov 2014 03:37:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Quota question
Date: Sat, 8 Nov 2014 02:36:51 +0000 (UTC)
Message-ID: <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr>
	<F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr>
	<pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net>
	<CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cyril Scetbon posted on Fri, 07 Nov 2014 20:06:40 +0100 as excerpted:

> I've made some tests with a newer version of btrfs, and I still have
> issues :(
> 
> http://pastebin.com/cycu08LG
> 
> I have 2 directories with quotas and a parent qgroup. All have quotas
> limits but something goes wrong. When the parent limit is exceeded I
> have a "Disk quota exceeded" which is what was expecting. However, after
> some tests I can exceed the limits (see line 80 and 84), but after that
> I can nolonger write to disk without getting an error and even if I just
> want to suppress the data !
> 
> FYI I'm using this kernel
> https://launchpad.net/ubuntu/+source/linux/3.16.0-25.33
> 
> Any idea ? Bug ?

Again admitting that because I don't use quotas personally and don't 
follow them closely on btrfs, I'm not exactly the ideal person to be 
answering questions on them... but in the absence of someone more 
informed taking a shot (which I'd greet with great relief as I'm 
definitely out of my comfortable knowledge range at this point)...

Two comments:

1) As I said earlier I believe the btrfs quota rewrite was in the 3.16 
kernel series timeframe.  Unfortunately I don't know its current status.  
You say kernel 3.16.0 (-25.33, which means nothing to me, what I know is 
about the mainline Linus kernel and to a bit less of an extent the 
official mainline stable kernels), but is the rewrite in that, or in 
3.17, or in the coming 3.18, or not yet entirely there at all... that I 
simply don't know.

2) What I *DO* know and *CAN* say with quite some confidence is this:

With btrfs being in general a copy-on-write filesystem, even deletes 
normally require /some/ space, because the metadata pointing at the file 
in question must be rewritten, and that requires free space in ordered to 
happen.

IOW, regardless of whether it's quotas or full filesystem constraints 
that are limiting space and provoking ENOSPC errors, depending on how bad 
an out-of-space condition actually is, even deleting files in ordered to 
free more space may be impossible, because the act of deleting files 
requires a rewrite and thus triggers a copy-on-write of the metadata 
involved, which itself requires some space.

At least in the case of full filesystem ENOSPC errors, the space-related 
questions in the FAQ on the btrfs wiki suggest truncating a file first.  
Find an existing file that either doesn't matter or that you have a 
backup of elsewhere, and echo > filename (or echo >| filename if you have 
noclobber set), therefore truncating the existing file.  A few of those 
and with luck you'll free enough space to do some actual deletions.

While to some extent I'm guessing here since I'm not directly familiar 
with quotas myself, it sounds as if such a severe ENOSPC condition, due 
in your case to quotas instead of the general filesystem limits I'm more 
familiar with, might be what you are seeing, particularly since in your 
tests you first triggered the limit, then found a way to write a bit more 
anyway, and only THEN found yourself unable to write anything.

If that's the case, then try the truncate trick and see if it helps.

In the generic filesystem case, if the truncate trick doesn't help, 
another possible trick is to temporarily add another device of several 
gigs capacity to the filesystem, enough to let a balance work and 
hopefully reduce the data/metadata imbalance, after which there should be 
enough chunk-unallocated free space left on the original device, to do a 
btrfs device delete of the temporary device, generally still leaving 
space left, since the balance should have reclaimed some otherwise wasted 
chunk allocation.

I can't see how that'd apply to quotas, however, and suspect that the 
corresponding quota-system solution would be to temporarily up the quota 
for the affected user, only long enough to let them do the deletions they 
need to do.  But beyond that I can't go, since I simply don't know enough 
about the quota domain to further speculate, at this point.

While admittedly limited due to my lack of quota-domain knowledge, 
perhaps that sheds at least some light on what happened and why, and 
hopefully on how to get out of the situation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

