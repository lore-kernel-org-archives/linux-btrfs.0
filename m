Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53897 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaACJTS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 04:19:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vz0uR-00084K-Jl
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 10:19:15 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 10:19:15 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 10:19:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Fri, 3 Jan 2014 09:18:51 +0000 (UTC)
Message-ID: <pan$ce611$d2dfc4df$982de663$6d9e3ddf@cox.net>
References: <52C2AE7C.5020601@gmx.at>
	<pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
	<loom.20140101T204832-543@post.gmane.org>
	<pan$d8c7$6644fca2$fe85bee2$cc84b5d0@cox.net>
	<h2ghpa-u74.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Fri, 03 Jan 2014 02:24:01 +0100 as excerpted:

> Duncan <1i5t5.duncan@cox.net> schrieb:
> 
>> But because a full balance rewrites everything anyway, it'll
>> effectively defrag too.
> 
> Is that really true? I thought it just rewrites each distinct extent and
> shuffels chunks around... This would mean it does not merge extents
> together.

While I'm not a coder and they're free to correct me if I'm wrong...

With a full balance (there are now options allowing one to do only data, 
or only metadata, or for that matter only system, and do other filtering, 
say to rebalance only chunks less than 10% used or only those not yet 
converted to a new raid level, if desired, but we're talking a full 
balance here), all chunks are rewritten, merging data (or metadata) into 
fewer chunks if possible, eliminating the then unused chunks and 
returning the space they took to the unallocated pool.

Given that everything is being rewritten anyway, a process that can take 
hours or even days on multi-terabyte spinning rust filesystems, /not/ 
doing a file defrag as part of the process would be stupid.

So doing a separate defrag and balance isn't necessary.  And while we're 
at it, doing a separate scrub and balance isn't necessary, for the same 
reason.  (If one copy of the data is invalid and there's another, it'll 
be used for the rewrite and redup if necessary during the balance and the 
invalid copy will simply be erased.  If there's no valid copy, then there 
will be balance errors and I believe the chunks containing the bad data 
are simply not rewritten at all, tho the valid data from them might be 
rewritten, leaving only the bad data (I'm not sure which, on that), thus 
allowing the admin to try other tools to clean up or recover from the 
damage as necessary.)

That's one reason why the balance operation can take so much longer than 
a straight sequential read/write of the data might indicate, because it's 
doing all that extra work behind the scenes as well.

Tho I'm not sure that it defrags across chunks, particularly if a file's 
fragments reach across enough chunks that they'd not have been processed 
by the time a written chunk is full and the balance progresses to the 
next one.  However, given that data chunks are 1 GiB in size, that should 
still cut down a multi-thousand-extent file to perhaps a few dozen 
extents, one each per rewritten chunk.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

