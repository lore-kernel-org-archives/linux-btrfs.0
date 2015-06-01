Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbbFARv0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jun 2015 13:51:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YzTrw-0006nK-HI
	for linux-btrfs@vger.kernel.org; Mon, 01 Jun 2015 19:51:24 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 19:51:24 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 19:51:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: howto create subvolume at top level?
Date: Mon, 1 Jun 2015 17:51:19 +0000 (UTC)
Message-ID: <pan$bc8b8$574d5213$341e3921$d2025f4a@cox.net>
References: <mki4j1$vvo$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Neal Becker posted on Mon, 01 Jun 2015 13:25:52 -0400 as excerpted:

> [nbecker@nbecker2 ~]$ sudo btrfs subvolume create /home2
> Create subvolume '//home2'
> [nbecker@nbecker2 ~]$ sudo btrfs subvolume list /
> ID 257 gen 66376 top level 5 path root
> ID 316 gen 66376 top level 257 path home2
> 
> This created home2 under root.  How do I create home2 with top level as
> top level 5, at the same level as root?
> 
> IOW:
> 
> ID 257 gen 66376 top level 5 path root
> ID 316 gen 66376 top level 5 path home2

Briefly stated, you don't.  Just like / is the top of a Unix style 
directory tree, the root subvolume is the top of a btrfs subvolume tree.  
You can't go higher than that, and that's what the top level /is/.

But what are you actually trying to do?  You _can_ change the default 
subvolume pointer so a subvolume other than root/5 is mounted by default, 
and you can nest subvolumes, so for most purposes, you can /pretend/ that 
some arbitrarily named subvolume is your top subvolume.  Alternatively, 
you can of course mount subvolumes wherever you want in the directory 
tree.

Also see the subvolumes discussion and related FAQs on the wiki if you 
haven't.

https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

