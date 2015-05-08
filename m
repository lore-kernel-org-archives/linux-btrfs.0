Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41500 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403AbbEHU6p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 May 2015 16:58:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YqpM3-0004lN-HS
	for linux-btrfs@vger.kernel.org; Fri, 08 May 2015 22:58:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 22:58:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 22:58:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel Dump scanning directory
Date: Fri, 8 May 2015 20:58:28 +0000 (UTC)
Message-ID: <pan$ef76f$1decf414$ca28dae0$217ae55f@cox.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net>
	<4B045A3B-60E2-4151-86E7-029E79585886@plack.net>
	<60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net>
	<EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anthony Plack posted on Fri, 08 May 2015 11:44:39 -0500 as excerpted:

> Maybe I am over hoping for a COW transaction system to actually have the
> ability to fix transaction issues since there is little to no
> documentation other than zero the log.  I am also wondering why we have
> a log in the file system if the fix is to just flush it.

I'm not a coder, but for quite some time wondered the same thing, plus 
why a log at all if it was COW and atomic commits... which you may know, 
at least at the level I was wondering about it.

Then a dev chanced a comment that made it much clearer to me.  Hopefully 
I didn't misunderstand something and the below clarifies things for you 
as it did for me, or at least for others reading if being a coder, you 
already had this high level of understanding and were talking about 
details of the implementation...

Btrfs is indeed atomic commit, but in the interest of efficiency, it 
doesn't commit every little change /all/ the way up the tree.  Instead, 
commit time is every 30 seconds by default, with the log collecting 
changes between commits, ideally at least, allowing a replay of 
everything that been partially written since the last commit that hasn't 
been committed yet -- the changes should be on device in a partially 
written tree, and the log should allow that partially written tree to be 
fully committed, thus saving all but perhaps the last actually in-process 
write at the moment of the crash.

With that, the log actually made sense to me, it's just a log of what 
hasn't been fully committed yet, given that in the interest of 
efficiency, a full commit is only done every 30 seconds.

And then I wasn't quite so concerned either about losing something 
critical in the log, or the safety of simply blowing it away, since by 
design, the log only deals with what hasn't been committed yet, and the 
commits are themselves designed to be atomic and leave the filesystem in 
a known good state.


But beyond that, at my non-coding sysadmin level anyway, I agree with 
where you seem to be taking this.  Currently, there's little to nothing 
documented or in the output about that log, and it's either keep it all 
or blow it away.  How much nicer it might be to have a bit more detail 
available, and to be able to actually trace the log and apply or blow 
away individual partial transactions as necessary, with the trace 
available so at least coder-level folks could trace exactly why the 
replay either committed or discarded each between-commits partial 
transaction, repairing the log instead of whole-hog commit or delete.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

