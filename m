Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59821 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab2FMRSK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 13:18:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SerCn-0006Cc-MQ
	for linux-btrfs@vger.kernel.org; Wed, 13 Jun 2012 19:18:05 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 19:18:05 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 19:18:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Moving top level to a subvolume
Date: Wed, 13 Jun 2012 17:17:50 +0000 (UTC)
Message-ID: <pan.2012.06.13.17.17.50@cox.net>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
	<pan.2012.06.12.01.53.23@cox.net> <1477951.uUzcAEg64Z@when>
	<CAG1y0sfRE502A1vEGyNUz9O9XdNZ+iu4bKs0=OKsWGtoSZKT_w@mail.gmail.com>
	<pan.2012.06.13.07.23.04@cox.net>
	<CAG1y0setJcXT-ncyvQJhCeSdfRKXksx9azVHih7Tpe6UxGkMgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha posted on Wed, 13 Jun 2012 16:08:40 +0700 as excerpted:

>> My system's old and has a bit of a problem with overheating in the
>> Phoenix summer, so has been suffering SATA resets
> 
>> it's exactly this sort of corner-case that filesystems need to be able
>> to deal with
> 
> IIRC XFS had corruption problems when used on top of LVM (or other block
> device that doesn't support barriers correctly), while using ext2/3/4 on
> the same block device will be "fine". Yet XFS doesn't have the mark of
> "unstable, highly experimental, do not use". People simply use the right
> (for them) fs for the right job.

It /does/ have a reputation of "don't use for a normal home system or 
other location without a suitably dependable UPS on fully stable 
hardware", however.  (From what I've read however, much like reiserfs has 
been for me here after data=ordered, xfs is vastly improved now, and said 
reputation likely no longer applies.)

If btrfs is to replace ext3/4, then that sort of reputation isn't what 
its devs will be shooting for.  We have at least the two filesystems 
(reiserfs and xfs) with serious reputation problems from their earlier 
life, and my big concern is that if enough people fail to consider btrfs' 
current development state and end up with data loss as a result, btrfs 
will end up with a very similar reputation, which will similarly live 
many years longer than the reality that created it.  But the other two 
weren't shooting for the ext* mantle, and btrfs is.  If its reputation is 
damaged to that extent and it becomes the assumed Linux default as ext3/4 
is now, that will be the Linux reputation.

> My point is yes, btrfs is new. And it's being developed at much faster
> rate than any other more-mature fs out there. And there are known cases
> of data loss on certain configuration of corner cases/"buggy" hardware
> and/or old version of kernel. But when used in the correct environment,
> btrfs can be a good choice, even for critical data.

Of course, critical data is backed up, or by definition you don't REALLY 
consider it so critical after all.  (There was a time when drives were 
small enough and expensive enough, as were the alternatives, that wasn't 
the case.  That time is long gone, for first and second world usage, 
anyway.  Even a home user with a single drive can split it into multiple 
partitions, with backup data on separate partitions, at least, with the 
real critical data on a thumb-drive too.)

But while people can and do unfortunately go without backups and are 
often lucky, doing so on btrfs at this stage in its development is 
"doubly insane", to channel Linus (actually being nice that day =:^) 
describing a recent commit, in his revert.

But there's obviously "doubly insane" people out there! =:^\

> Of course IF the data were REALLY critical, and I REALLY need btrfs'
> features, and it were on an enterprise environment, I would've bought
> support from oracle linux (or SLES 12, when it's out, or whatever
> enterprise distro supporting btrfs which sells support contract) so I
> can have someone to turn to in case of problems, and (in some cases)
> transfer the risk/blame :D

That's a good point.  Of course, as many people find out, such "support" 
often /does/ really come down to "someone else to blame".  Yes, they'll 
help with recovery if it comes to it, but if your $100K+ an hour business 
is down in the mean time... and you didn't have those backups and at 
/least/ "cold" failover... they'll be finding someone to blame as well!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

