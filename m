From: "K. Richard Pixley" <rich@noir.com>
Subject: synchronous removal?
Date: Sun, 01 Aug 2010 14:11:15 -0700
Message-ID: <4C55E2F3.3030202@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

  I have an application where I want to snapshot, then do something, and 
based on the result, snapshot either the result or the previous state 
and then repeat.

So far, so good.  But eventually my disk fills and I want to remove the 
oldest snapshots, as many as I need to in order to make room enough for 
the next cycle.

I notice that when I remove old snapshots and delete old directories, 
the free space on my disk, (according to df), doesn't rise immediately.  
But instead, I see an active btrfs_cleaner for a while and my free space 
rises while it runs.  I'm presuming that the removed files and snapshots 
aren't fully reclaimed immediately but rather wait for something akin to 
a garbage collection much the way modern berkeley file systems do.

How can I either:

a) wait for the cleaner to digest the free space
b) determine that the cleaner has digested all available free space for 
now, (if not I can sleep for a while)
c) synchronously force the cleaner to digest available free space
d) something else I haven't thought of yet

Basically, I want to check to see if there's enough space available.  If 
not, I want to remove some things, (including at least one snapshot), 
wait for the cleaner to digest, and then start over with the checking to 
see if there's enough space available and loop until I've removed enough 
things that there is enough space available.  How can I do that on a 
btrfs file system?

--rich
