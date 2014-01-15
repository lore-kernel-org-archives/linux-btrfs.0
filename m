Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52905 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaAOVv0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 16:51:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W3YMq-0001oV-7B
	for linux-btrfs@vger.kernel.org; Wed, 15 Jan 2014 22:51:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 22:51:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 22:51:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: why am  I getting "No space left on device" here?
Date: Wed, 15 Jan 2014 21:50:56 +0000 (UTC)
Message-ID: <pan$e064e$75bb4ca4$e88043e1$b42ec238@cox.net>
References: <20140115115543.790adafb@wpkg.org>
	<pan$6d4dc$e3f7651a$b8f89b4a$ecb5f643@cox.net>
	<2656163.prAmgAF69M@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Wed, 15 Jan 2014 20:40:29 +0100 as excerpted:

> Am Mittwoch, 15. Januar 2014, 19:05:41 schrieb Duncan:
>> But just as my already allocated mixed-mode chunks were just about full
>> and I needed another one allocated to complete the job, so your data
>> chunks are full or very close, according to btrfs fi df, and you need a
>> new one allocated (and if the file is greater than a gig in size,
>> likely more than one) to finish the job.
>> 
>> And in both our cases, there's plenty of unallocated space in the pool,
>> but for whatever reason, btrfs isn't allocating that new chunk when it
>> should!  Why, I can't say, but as I mentioned, I was able to work
>> around the problem here by trying the remaining files in a different
>> order, and at some point, btrfs figured out it needed that new chunk
>> allocated, and everything went fine after that.

> I think you can cause BTRFS to allocate a chunk or more by creating a
> file with the fallocate command. Unless BTRFS doesn´t do it due to a bug
> and errors out with no space left.
> 
> fallocate gives also an easy way to find out how much it might still
> allocate and at what point it fails – and that without writing tons of
> data first. fallocate just triggers allocation and does not write any
> actual data.

Good idea. =:^)

I don't have the problem ATM so I can't test it, but hopefully Tomasz can.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

