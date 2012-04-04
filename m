From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: weekend of btrfs findings
Date: Wed, 4 Apr 2012 04:52:45 +0000 (UTC)
Message-ID: <pan.2012.04.04.04.52.44@cox.net>
References: <4F7B4B5E.4050902@hosman.xs4all.nl>
	<pan.2012.04.04.04.45.23@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Wed, 04 Apr 2012 04:45:24 +0000 as excerpted:

> Oh, and one more thing.  Because btrfs /is/ experimental, (a) be
> prepared to lose any data you put on it (but by your comments you
> probably understand that bit already), and (b) running current kernels
> is critical, as each one still includes a lot of fixes from the one
> before. That means at *LEAST* 3.2.  There's apparently a regression for
> some people in 3.3 but you'd normally be expected to be upgrading to it
> about now, and many testers run the mainline Linus rc kernels (3.4-rc1
> currently), or even newer not-yet-in-linus-tree btrfs.  Again, see the
> wiki for more.

... And 3.4-rc1 has a regression too, see the btrfs io erros on 3.4rc1 
thread.  But that one should be fixed well before 3.4 full release.  Of 
course if you're testing btrfs, following this list is helpful, and you 
can see and apply the patch yourself, or check when Linus applies it in 
his tree.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

