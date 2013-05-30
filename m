Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from amber.ccs.neu.edu ([129.10.116.51]:35636 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967232Ab3E3Ddr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:33:47 -0400
Received: from zimbra.ccs.neu.edu ([129.10.116.59])
	by amber.ccs.neu.edu with esmtp (Exim 4.69)
	(envelope-from <nam@ccs.neu.edu>)
	id 1Uht1b-0006CH-RQ
	for linux-btrfs@vger.kernel.org; Wed, 29 May 2013 22:55:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by zimbra.ccs.neu.edu (Postfix) with ESMTP id C7DB297001F
	for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 22:55:35 -0400 (EDT)
Received: from zimbra.ccs.neu.edu ([127.0.0.1])
	by localhost (zimbra.ccs.neu.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WKrwgABhXB0G for <linux-btrfs@vger.kernel.org>;
	Wed, 29 May 2013 22:55:31 -0400 (EDT)
Received: from zimbra.ccs.neu.edu (zimbra.ccs.neu.edu [129.10.116.59])
	by zimbra.ccs.neu.edu (Postfix) with ESMTP id A61C2970012
	for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 22:55:31 -0400 (EDT)
Date: Wed, 29 May 2013 22:55:31 -0400 (EDT)
From: Alex Marquez <nam@ccs.neu.edu>
To: linux-btrfs@vger.kernel.org
Message-ID: <23702077.2218441369882531514.JavaMail.root@zimbra>
In-Reply-To: <10857957.2218421369882515345.JavaMail.root@zimbra>
Subject: Btrfs metadata corruption; unmountable FS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not entirely sure what went completely wrong.  Three possibilities are most likely, and they're listed below.
For reference, here are supplemental materials split out into their own pastebins:
* btrfs-debug-tree -R log http://pastebin.com/7ePy9sin
* dmesg log http://pastebin.com/s1sdJRyd
(btrfs tools are git head)
Mounting with "recovery,ro" is no use.
I've also taken a metadata dump with btrfs-image, though it completed with errors, so the dump may be incomplete.  It's also 5 GBs, but I'm more than willing to make it publicly downloadable if it would help the cause.

************** 1
Firstly, I have a raid1 (and, as I'll explain, partially raid10) array of 8 raw drives.  A couple experience a controller error every once in a while.  So it /may/ be the case that the hardware itself caused this problem, but I find it less likely than the following other two possibilities.  (However, in part 3's log there is some mention of sdf giving IO errors...)

************** 2
A couple of months ago I was doing a balance, trying to convert from raid10 to raid1.  At the time, it was on the 3.6 kernel.

I kept getting enospc errors (even with plenty of space), so I went from doing a soft conversion to a hard one.  Of course, in the process my server was hard-rebooted by accident.  When back online, I used btrfsck and it showed a bunch of extent vs. csum problems, which I used --repair to attempt to deal with. 

Though I can't recall the problems exactly, I do remember that it triggered an odd check regarding csums existing for extents that were freed.
The commit which introduced this printf was https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=580ccf9e2ef4607f5b67b531190e7842c4b2b0db

Since then, every once in a while I would do another balance (sometimes soft, sometimes hard) in an attempt to complete the conversion -- to no avail, but seemingly to no harm.

************** 3
Now, 2 weeks ago I (foolishly) thought I'd try the new skinny extents feature (mistaking it as available in 3.9) in order to see if it might alleviate the issues I've had with trying to finish that conversion.  I enabled it via btrfstune, but quickly noted that my 3.9 kernel wouldn't mount the filesystem anymore (because of the incompatible feature).

However, nothing had changed on-disk (given I wasn't running 3.10) but the flag...  So I looked into clearing that flag, but btrfstune provided me no recourse.  So I did something very dangerous and foolish:  I went into btrfstune.c and changed the setting of the flag to clear the flag instead, then reran it.  I mounted again, fingers crossed, and lo and behold, it was fine!

Unfortunately, after some use, the filesystem failed and went read-only.  That's when I got scared and decided it was time to stop trying to fix things myself (of course, far too late).

The actual log is at http://pastebin.com/s1sdJRyd
On line 85 you can see where I tried to mount it
Line 87 is where I remounted after my btrfstune hack
