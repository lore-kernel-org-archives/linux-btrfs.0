Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60967 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab3GRAWg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 20:22:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UzbzO-0002nx-9z
	for linux-btrfs@vger.kernel.org; Thu, 18 Jul 2013 02:22:34 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 02:22:34 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 02:22:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What is the current status of defragmentation?
Date: Thu, 18 Jul 2013 00:22:16 +0000 (UTC)
Message-ID: <pan$51ece$57cdeac0$66b0922d$a0484ffc@cox.net>
References: <51E7182F.9020009@statystyka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Ryczkowski posted on Thu, 18 Jul 2013 00:18:23 +0200 as excerpted:

> Today I booted my linux-mint 14 into the latest 3.10.1 kernel to
> defragment the root btrfs filesystem on my ASUS N56VZ laptop with hybrid
> Seagate Momentus XT disk. I did something like
> 
>    find / -exec btrfs filesystem defrag {}

> [description of experience snipped] It clearly showed me, that
> defragmenting the filesystem is not that trivial, as it is for ext4.
> So I have quesions: [snipped]

> Does this command
> 
> find / -type f -o -type d -print0 | xargs --null --no-run-if-empty btrfs
> filesystem defragment -cv
> 
> look like a reasonable idiom for defragmenting the whole filesystem?

Given that you don't mention the btrfs wiki, and to a large extent your 
questions are covered there, I'll assume you're not familiar with it.

The short answer is that yes, a find of that nature, piped to xargs to 
run btrfs filesystem defrag, is the suggested solution.  However, you 
really need to read up on the wiki, and then ask any remaining questions 
you may have.  (I still had some questions myself.)

Bookmarking link:  https://btrfs.wiki.kernel.org/

Defrag is covered there in some detail, including a recommended find-
piped defrag command. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

