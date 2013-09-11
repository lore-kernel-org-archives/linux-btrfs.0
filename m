Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53089 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab3IKFcb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 01:32:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VJd2T-0000pD-1z
	for linux-btrfs@vger.kernel.org; Wed, 11 Sep 2013 07:32:29 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:32:29 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:32:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-error
Date: Wed, 11 Sep 2013 05:32:06 +0000 (UTC)
Message-ID: <pan$11c4c$239d147c$43f8ab9b$7897c421@cox.net>
References: <CAGt=4JxkC0Y0wue6iHHVMhRc7ZNPK0EMBoxfddqpFmi4Z94Aig@mail.gmail.
	com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David O'Riley posted on Tue, 10 Sep 2013 18:04:20 +0100 as excerpted:

> I have been using ubuntu-gnome 13.04 for a couple of week with no issue.
> After a power failure my system fails to boot, error in rootfs.
> 
> If I boot from a live CD and try to mount /dev/sda6 the system crashed.
> 
> I have also tried btrfsck /dev/sda6 which gives the below error,
> 
> [...] *** Error in `btrfsck': double free or corruption [...]
> 
> Is there anything you would advise to try next?

Just a user and list regular, here, with a generic answer as I don't 
claim to read backtraces, etc...

The below link is to an archived post with the general btrfs repair steps 
and the recommended order in which to try them.  (This should be added to 
the wiki as well, but I haven't checked to see if it has been.)

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

However, before that, please do try with a current kernel and btrfs-tools 
-- I don't know how old the ubuntu kernel and tools are, but btrfs is 
still under heavy development and labeled experimental, which means 
anyone running it is choosing to be a tester, and each new kernel series 
brings bug fixes.  That means, if you're more than a single kernel stable 
series behind mainline you really ARE missing potentially critical 
bugfixes and really ARE unnecessarily risking your data, in addition to 
being able to provide rather less useful information when things do go 
wrong with your testing, than you could provide with a current kernel.

3.11 was recently released and we're in the pre-3.12-rc1 feature-commit 
phase, so ideally you'll be running 3.11 by now.  And I know for sure 
there were bug fixes in 3.11 that have helped people who were running 
earlier kernels so I'd definitely try it.  However, you should DEFINITELY 
be running at LEAST 3.10 series by now if you're testing btrfs, and if 
you're not prepared to do that, you should really reconsider whether  
running a developmental filesystem such as btrfs is appropriate for you 
at this point in the first place.

Same with btrfs-tools.  The latest full release is 0.19, but that's VERY 
old now.  There's a 0.20-rc1 out too, but even that's now old (from 2012 
I believe, and 358 commits behind).  For testing btrfs, you should really 
be running a reasonably new (definitely post 0.20-rc1) git snapshot (the 
latest commit seems to be from July 5, v0.20-rc1-358-g194aa4a, so ideally 
that commit or a snapshot dated after that), as development occurs on 
other branches and is merged to master only when it's ready, so current 
btrfs-tools git-master should always be the best version available.

Meanwhile, if you weren't aware of it yet, here's the wiki.  It's full of 
information (particularly the documentation section) you will almost 
certainly find rather useful as a btrfs tester! =:^)

https://btrfs.wiki.kernel.org 

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

