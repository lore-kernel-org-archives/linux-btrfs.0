Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48420 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbbDTGHR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 02:07:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yk4rT-0004Aq-DT
	for linux-btrfs@vger.kernel.org; Mon, 20 Apr 2015 08:07:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 08:07:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 08:07:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: The FAQ on fsync/O_SYNC
Date: Mon, 20 Apr 2015 06:07:09 +0000 (UTC)
Message-ID: <pan$f3383$b95d8948$e810e90b$680e5c5d@cox.net>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
	<49296740.rPqQP4vAjc@merkaba>
	<CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
	<20150420042731.GA20194@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Mon, 20 Apr 2015 00:27:31 -0400 as excerpted:

> Normal writes to btrfs filesystems using the versioned filesystem tree
> are consistent(ish), atomic, and durable; however, they have high
> latency as the filesystem normally delays commit until triggered by a
> periodic timer (or sync()--not fsync), then writes all outstanding dirty
> pages in memory.
> 
> btrfs handles fsync separately from the main versioned filesystem tree
> in order to decrease the latency of fsync operations.  There is a 'log
> tree' which behaves like a journal and contains data flushed with
> fsync() since the last fully committed btrfs root.  After a crash,
> assuming no bugs, the log is replayed over the last committed version of
> the filesystem tree to implement fsync durability.
> 
> Unfortunately, in my experience, the log tree's most noticeable effect
> at the moment seems to be to add a crapton of special-case code paths,
> many of which do contain bugs, which are being fixed one at a time by
> btrfs developers.  :-/

Thanks, Zygo.  That's the clearest explanation I've seen on why the 
supposedly atomic-commit btrfs still has a log, and what it actually 
does.  I wasn't entirely clear on that, myself.

Meanwhile, yes, log-replay bugs do seem to be one of the sore spots ATM.  
I'm glad it's getting some focus now.  It needed it.

>> >> Is that statement still true in recent BTRFS versions (3.18, etc)?
> 
> 3.18 was released 133 days ago.  It has only been 49 days since the last
> commit that fixes a btrfs data loss bug involving fsync (3a8b36f on Mar
> 1, appearing in mainline as of v4.0-rc3), and 27 days since a commit
> that fixes a problem involving fsync and discard (dcc82f4 on Mar 23,
> queued for v4.1).
> 
> There has been a stream of fsync fixes in the past year, but it would be
> naive to believe that there are not still more bugs to be found given
> the frequency and recentness of fixes.

Telling commentary on what is "recent" in btrfs context, vs. what is 
"recent" in many distro's context, particularly in "enterprise" distro 
context. =8^0

4.0 is out.  There's reason people may want to stick one version back by 
default, to 3.19 currently, since it can take a few weeks for early 
reports to develop into a coherent problem, and sticking one stable 
series back allows for that, and deciding exactly when one is comfortable 
upgrading.  But in btrfs context anyway, with 4.0 out, if you're not on 
at least 3.19 yet, you should be able to point to the bug explaining
/why/.  If you can't, arguably, you should be either upgrading yesterday 
if not sooner, or you really should choose some other filesystem, as 
btrfs simply isn't at the stability required for your use-case yet, and 
you unnecessarily risk data loss to already found and fixed bugs as a 
result.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

