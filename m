Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45557 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbbBLCLL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 21:11:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YLjF0-0005wv-6a
	for linux-btrfs@vger.kernel.org; Thu, 12 Feb 2015 03:10:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 03:10:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 03:10:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Date: Thu, 12 Feb 2015 02:10:44 +0000 (UTC)
Message-ID: <pan$9532$65b1220e$320184ed$94bcf659@cox.net>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
	<pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net>
	<CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

P. Remek posted on Tue, 10 Feb 2015 18:44:33 +0100 as excerpted:

> In the test, I use --direct=1 parameter for fio which basically does
> O_DIRECT on target file. The O_DIRECT should guarantee that the
> filesystem cache is bypassed and IO is sent directly to the underlaying
> storage. Are you saying that btrfs buffers writes despite of O_DIRECT?

I'm out of my (admin, no claims at developer) league on that.  I see 
someone else replied, and would defer to them on this.

>> Those 70K IOPs are all the extra work the filesystem is doing in
>> ordered to track those 4 KiB COWed writes!
> 
> This sounds like you are thinking that getting 70K IOPs is a bad thing
> but I am testing performance which means higher IOPS = better result. In
> other words, after second run when that target file already existed, the
> performance improved significantly.

Perhaps I'm wrong (I /did/ emphasize "suspect") here, but what I was 
suggesting was...

Those higher IOPs are I believe fake, manufactured by the filesystem as a 
result of splitting up the few larger extents into many smaller extents 
due to COW-fragmentation.  If I'm correct, the physical device and the 
below-filesystem-level kernel levels (where I expect your IOPs measure is 
sourced) are seeing this orders of magnitude increased number of IOPs due 
to breaking one original filesystem operation into perhaps hundreds of 
effectively random individual 4k block operations, but the actual thruput 
at the above-filesystem-level is reduced.

There's certainly a potential in theory for such an effect on btrfs due 
to COWing rewrites and faced with those results, it is how I'd explain 
them in a rather hand-wavy not too low-level technical way.

But if it doesn't match reality, then my understanding is insufficient 
and I'm wrong.  Wouldn't be the first time. =:^P

>> I suppose you're already aware that you're running a rather outdated
>> userspace/btrfs-progs (what I assume you meant by tools).
> 
> I was hoping that btrfs-progs doesn't have any influence on runtime
> properties of the btrfs filesystem. As I am doing performance tests, I
> hope that btrfs-progs version doesn't have any impact on the results.

I was simply pointing out the mismatch, in case you intended to actually 
deploy, and potentially try to fix any problems with that old a 
userspace.  As long as you're aware of the issue and won't be trying to 
btrfs check --repair or the like with that old userspace, for runtime 
testing, indeed, it shouldn't matter.

So you're "hoping correctly". =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

