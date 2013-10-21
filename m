Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54513 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab3JUJ6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 05:58:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VYCFq-0002AT-4u
	for linux-btrfs@vger.kernel.org; Mon, 21 Oct 2013 11:58:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 11:58:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 11:58:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Lots of trouble hanging when rm files with many extents
Date: Mon, 21 Oct 2013 09:58:10 +0000 (UTC)
Message-ID: <pan$e420$3893a0c4$44863293$c1ca576c@cox.net>
References: <20131021133644.172387f5@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Mon, 21 Oct 2013 13:36:44 +0900 as excerpted:

>> > I'll do some more tests with lots of extents to see if it's
>> > reproducible here as well.
>> 
>> Interestingly, I've generally had qgroups enabled here as well,
>> possibly on all of these systems.  Could that be the culprit?
> 
> Possibly.
> 
> Is there a reliable way to create files with many extents? I've tried
> playing with fallocate, but couldn't create files with too many extents
> with it.

While the absense of both qgroups and the problem here doesn't prove 
anything, it's a datapoint.  However, I /am/ a bit suspicious of them, as 
it just seems people keep reporting weird problems and the common thread 
often seems to be qgroups.  I'm not a coder let alone a kernel/btrfs 
coder so take this with a suitably sized grain of salt, but my intuition 
says qgroups add more stress to the system and likely some as yet 
unresolved race-points, and they raise the possibility of triggering 
otherwise unrelated problems that already exist, along with any issues 
they themselves might have.

That would fit with the many-thousands-of-extents issues here as well, 
since especially on spinning rust that's going to create all sorts of 
stress on the drive and filesystem and all sorts of potential to trigger 
race conditions.  If both of them increase stress and open up the 
critical sections during which races are possible, putting the two 
together is an effective torture-test likely indeed to bring out 
otherwise extremely small window race conditions that might otherwise 
very seldom trigger.

Meanwhile, on the extents issue I believe creating a large enough file 
and then writing into random locations within it, saving, writing some 
more, should do it, given btrfs' copy-on-write defaults.

Working with an almost full filesystem is likely to create worse 
fragmentation too, since at some point btrfs just gives up trying to 
create single-extent files and writes anywhere it can find space.

Finally, btrfs compression is said to look like fragmentation to 
filefrag.  I'm not sure whether it /acts/ like fragmentation or not, but 
any suitably large file that gets btrfs compression will look fragmented 
I believe because the compression blocks (128KB IIRC) are reported to 
filefrag as individual extents due to the way btrfs handles and tracks 
them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

