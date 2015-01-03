Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59943 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbbACKao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Jan 2015 05:30:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7Lyj-0006mu-M3
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 11:30:41 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 11:30:41 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 11:30:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: possible bug in balance
Date: Sat, 3 Jan 2015 10:30:30 +0000 (UTC)
Message-ID: <pan$e75b1$a4dba2e8$4e6523ad$73f0cde8@cox.net>
References: <1377898232.24181420209516734.JavaMail.root@shiva>
	<1256750348.24201420209749292.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

luvar posted on Fri, 02 Jan 2015 15:42:29 +0100 as excerpted:

> root@blackdawn:/home/luvar# uname -a
> [...] 3.13.0-30-generic [...]
> 
> root@blackdawn:/home/luvar# btrfs v
> Btrfs v0.20-rc1-189-g704a08c
> 
> 
> Am I doing something forbidden [...]

Those versions are your problem.  Do you know how fast btrfs is 
improving, how old those are (hint, there are about five kernel release 
series a year and we're now on the 3.19 development series with 3.18 
stable, so 3.13 is... about five releases back and thus about a year old!
), and how many bugs have been fixed since then?

Try something newer than the paleolithic age, say a current 3.18.x stable 
series kernel or a 3.19-rc, and the recent btrfs-progs 3.18.0, and you 
should see rather better results.  There are valid reasons to stick to 
old and stable, but they simply don't mix well with a new and still not 
completely stable filesystem that still sees regular bug fixes, and not 
just for code introduced in the last kernel, either!  Therefore, if you 
want old and stable, choose a different filesystem; while if you want to 
run btrfs, staying current is strongly recommended.

Meanwhile, if you haven't yet, you may want to spend some time on the 
wiki reading up.  Take a look at the stuff under section 5.1, Guides and 
usage information, especially.  It'll answer a lot of questions and could 
save your data too. =:^)

https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

