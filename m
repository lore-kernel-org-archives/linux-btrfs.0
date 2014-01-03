Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58409 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaACA3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 19:29:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VysdO-00034U-Fp
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 01:29:06 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:29:06 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:29:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Managing large volumes
Date: Fri, 3 Jan 2014 00:28:42 +0000 (UTC)
Message-ID: <pan$e9843$2e84789c$a742e093$bb80e589@cox.net>
References: <CAAKzf7kB90qOG8yNuLUyfd2w61kVeeo+d+vs=ecURYqm=rjxgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tim Cuthbertson posted on Thu, 02 Jan 2014 16:28:33 -0600 as excerpted:

> I am a bit confused and I have probably managed to outsmart myself. For
> about 15 months, I have been running my system on a single, large btrfs
> volume. It is RAID-0 on two SATA-III HDD's for a total of 1.9 TB. This
> is a home system running Siduction (Debian Sid) Linux. While I have
> root, home, and a special data directory each as separate subvolumes, I
> am beginning to wonder whether I should have made each of these on
> separate partitions and separate btrfs filesystems.
> 
> Am am at a point where I would like to do a fresh install of my OS
> without losing my home and data contents. And I do not think separate
> btrfs subvolumes will help me on that. Is that correct? Is there a way
> to prevent an OS installation from formatting the /home and /data
> subvolumes while completely replacing the root subvolume? Or do I need
> to completely repartition my drives so I don't get into this situation,
> again?

I'm not running Debian so won't attempt to answer that side of the 
question.  However, count me firmly on the side of independent 
partitions, here.  My thinking isn't so much with reinstallation (I run 
gentoo so that's not an issue), but on the fact that with subvolumes, 
it's still the same single huge filesystem tree, and that's *ALL* my data 
eggs in one filesystem basket!  What's worse is that said filesystem 
basket is still under development and thus even more than the always good 
sysadmin practice, I must be prepared with tested backups of anything I 
care about in that filesystem basket, should it turn out to be buggy.

Smaller individual filesystems are easier to manage from a backup 
perspective, especially if only one fails, and take less time to btrfs 
balance/scrub/whatever as well, so it's easier to keep them in reasonably 
good health.

That said, I know there are people that prefer either subvolumes or 
putting everything on LVM, as well, primarily because one doesn't have to 
worry about getting the size exactly correct or having too much space on 
one partition and too much data on another.  They have their valid 
reasons for what they do, too.  I just happen to know what I have found 
works best for me, after several decades of experience, over which I have 
had to deal with various disaster recovery situations.  I prefer to 
strictly limit my risk even when playing with still under development 
filesystems such as btrfs, and independent partitions is simply the most 
effective way I've found to do that for my own systems and use-cases, but 
that doesn't mean other people's approaches aren't better for their 
systems and their use-cases.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

