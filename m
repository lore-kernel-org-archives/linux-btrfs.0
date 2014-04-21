Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56257 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbaDUWN0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 18:13:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WcMSq-0004xf-OT
	for linux-btrfs@vger.kernel.org; Tue, 22 Apr 2014 00:13:24 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 00:13:24 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 00:13:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Snapshot aware defrag and qgroups thoughts
Date: Mon, 21 Apr 2014 22:13:11 +0000 (UTC)
Message-ID: <pan$56a39$b0e4f3ef$30bd4a1b$c3f6fabf@cox.net>
References: <53553172.9030309@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik posted on Mon, 21 Apr 2014 07:55:46 -0700 as excerpted:

[Near the bottom, point #4 immediately before conclusion.]

> You still have to post-process merge to make sure, but you are far more
> likely to merge everything in real-time since you are only changing the
> sequence number every once and a while instead of for every new sequence
> number.

Much of this is above my head, which is OK as I'm not a btrfs dev, but...

...only changing the sequence number... for every new sequence number?

Something's wrong with that. No WONDER the system live-locked! =:^)

My above-my-head guess is that in place of for every new sequence number 
there, you meant for every delayed ref.

Meanwhile, thanks for putting this all down.  I already said I don't 
understand much of it, but I certainly have a better appreciation for the 
complexities of snapshot-aware-defrag.  I hadn't considered what qgroups 
could do to it at all!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

