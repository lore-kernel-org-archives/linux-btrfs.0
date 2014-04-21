Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51882 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbaDUWp6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 18:45:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WcMyK-0000LF-A1
	for linux-btrfs@vger.kernel.org; Tue, 22 Apr 2014 00:45:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 00:45:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 00:45:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Do quota groups cost noticeable performance in 3.14?
Date: Mon, 21 Apr 2014 22:45:43 +0000 (UTC)
Message-ID: <pan$32bc6$efdaee98$c580d086$1cd467bd@cox.net>
References: <20140420195901.GP7884@merlins.org>
	<pan$a2f12$b2daf6bc$70ff71c$1a6edc97@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Mon, 21 Apr 2014 05:44:54 +0000 as excerpted:

> Marc MERLIN posted on Sun, 20 Apr 2014 12:59:01 -0700 as excerpted:
> 
>> I was looking at using qgroups for my backup server, which will be
>> filled with millions of files in subvolumes with snapshots.
>> 
>> I read a warning that quota groups had performance issues, at least in
>> the past.
> 
> Yes.  Additionally, there were serious bugs [...]
> 
>> Is it still true?
> 
> Very good question.

New information.  See Josef Bacik's new thread:

Snapshot aware defrag and qgroups thoughts
Monday, 21 April, 7:55:46 -0700

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/34405

Looks like he's going to be rewriting qgroups accounting to rework 
sequence numbers, as part of his work to get a reasonable scalable 
snapshot-aware-defrag.  But he's on paternity leave ATM, so my guess is 
that's iffy for the 3.16 commit-window and thus may not make it until 
3.17, which @ ~10 weeks a kernel cycle and being ~2 weeks past the 3.15 
commit window (we're on rc2), leaves us ~18 weeks until 3.17-rc1, early 
September.

Anyway, with that rewrite coming, unless you're really itchy to get into 
qgroups now, I'd wait until after that to dive in.

Meanwhile, his explanation of the present interaction between qgroups and 
the (currently disabled) snapshot-aware-defrag was an entirely new thing 
for me.  As I haven't any current need for qgroups I had somewhat walled 
that area off as something I didn't mess with or need to know about at 
this time, but his explanation certainly goes quite some way to 
explaining why snapshot-aware-defrag was so horribly bad for some people, 
those unlucky enough to be doing heavy snapshotting, with qgroups active, 
on very active heavy-internal-rewrite-pattern files.

I was already (and still) recommending a good snapshot thinning program 
for those doing automated snapshotting, keeping the number of snapshots 
per subvolume under 500 and preferably 200-300 max (quite reasonable with 
a good thinning setup, even with originally per-minute snapshots).  And I 
was already recommending that people keep large (>1 GiB) heavy-internal-
rewrite-pattern files NOCOW, on dedicated subvolumes to avoid 
snapshotting (using conventional backup for them).  But I had no /idea/ 
qgroups threw another geometric-scaling factor into the mix!

That definitely adds a new recommendation to the set -- avoid qgroups on 
subvolumes with heavy-internal-rewrite-pattern files.  And if you MUST 
qgroup OR heavily snapshot, choose one OR the other, DEFINITELY NOT 
BOTH!  At least until that qgroups accounting rewrite gets done.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

