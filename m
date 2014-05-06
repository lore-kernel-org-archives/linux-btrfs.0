Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33097 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbaEFUXl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 16:23:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhlOZ-0006a9-7G
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 21:51:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:51:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:51:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
Date: Tue, 6 May 2014 19:39:12 +0000 (UTC)
Message-ID: <pan$43f87$1b04f612$26876f7$5d505a6d@cox.net>
References: <pan$a3b93$98e8eca3$3f96ad92$ba13c4f@cox.net>
	<20140505012719.GD10159@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 04 May 2014 18:27:19 -0700 as excerpted:

> The original reason why I was asking myself this question and trying to
> figure out how much better -m raid1 -d raid0 was over -m raid0 -d raid0
> 
> I think the summary is that in the first case, you're going to to be
> abel to recover all/most small files (think maildir) if you lose one
> device, whereas in the 2nd case, with half the metadata missing, your FS
> is pretty much fully gone.
> Fair to say that?

Yes. =:^)

> Now, if I don't care about speed, but wouldn't mind recovering a few
> bits should something happen (actually in my case mostly knowing the
> state of the filesystem when a drive was lost so that I can see how many
> new files showed up since my last backup), it sounds like it wouldn't be
> bad to use:
> -m raid1 -d linear

Well, assuming that by -d linear you meant -d single. Btrfs doesn't call 
it linear, tho at the data safety level, btrfs single is actually quite 
comparable to mdadm linear.  =:^)  

(I had to check.  I knew I didn't remember btrfs having linear as an 
option, and hadn't seen any patches float by on the list that would add 
it, but since I'm not a dev I don't follow patches /that/ closely, and 
thought I might have missed it.  So I thought I better go check to see 
what this possible new linear option actually was, if indeed I had missed 
it.  Turns out I didn't miss it after all; there's still no linear option 
that I can see, unless it's there and simply not documented.  =:^)

> This will not give me the speed boost from raid0 which I don't care
> about, it will give me metadata redundancy, and due to linear, there is
> a decent chance that half my files are intact on the remaining drive
> (depending on their size apparently).

Yes. =:^)

> So one place I use it is not for speed but for one FS that gives me more
> space without redundancy (rotating buffer streaming video from security
> cams).
> At the time I used -m raid1 -d raid0, but it sounds for slightly extra
> recoverability, I should have ued -m raid1 -d linear (and yes, I
> undertand that one should not consider a -d linear recoverable when a
> drive went missing).

That appears to be a very good use of either -d raid0 or -d single, yes.  
And since you're apparently not streaming such high resolution video that 
you NEED the raid0, single does indeed give you a somewhat better chance 
at recovery.

Tho with streaming video I wonder what your filesizes are as video files 
tend to be pretty big.  If they're over the 1 GiB btrfs data chunk size, 
particularly if you're only running a two-device btrfs, you'd probably 
lose near all files anyway.

Assuming single data mode and file sizes between a GiB and 2 GiB, 
statistically you should lose near 100% on a two device btrfs with one 
dropping out, 67% on a three device btrfs with a single device dropout, 
50% on four devices, 40% on five devices...

If file sizes are 2-3 GiB, you should lose near 100% on 2-3 devices, 75% 
on four devices, 60% on five, 50% on six...

With raid0 data stats would be similar but I believe starting at 16 MiB 
with 4 MiB intervals.  Due to many files under 16 MiB being stored in the 
metadata, you'd lose few of them, but that'd jump to 100% loss at 16 MiB 
until you had 5+ devices in the raid0, with 16-20 MiB file loss chance on 
a 5-device raid0 80%, since chances would be 80% of one strip of the 
stripe being on the lost device.  (That's assuming my 4 MiB strip size 
assumption is correct, it could be smaller than that, possibly 64 KiB.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

