Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41238 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbaEFTt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 15:49:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whkqo-0006hB-6p
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 21:16:26 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:16:26 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:16:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How does Suse do live filesystem revert with btrfs?
Date: Tue, 6 May 2014 16:26:48 +0000 (UTC)
Message-ID: <pan$4eac3$a2d76a4$a81e0fed$b4b18c9e@cox.net>
References: <20140504005257.GF9061@merlins.org>
	<20140504232645.GQ9061@merlins.org> <20140505003639.GO24298@carfax.org.uk>
	<20140505050459.GF10159@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 04 May 2014 22:04:59 -0700 as excerpted:

> On Mon, May 05, 2014 at 01:36:39AM +0100, Hugo Mills wrote:
>>    I'm guessing it involves reflink copies of files from the snapshot
>> back to the "original", and then restarting affected services. That's
>> about the only other thing that I can think of, but it's got load of
>> race conditions in it (albeit difficult to hit in most cases, I
>> suspect).
> 
> Aaah, right, you can use a script to see the file differences between
> two snapshots, and then restore that with reflink if you can truly get a
> list of all changed files.
> However, that is indeed not atomic at all, even if faster than rsync.

Would send/receive help in such a script?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

