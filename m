Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52066 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbcARDwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 22:52:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aL0rH-0006L3-Gj
	for linux-btrfs@vger.kernel.org; Mon, 18 Jan 2016 04:51:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:51:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:51:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)?
 Explain like I'm five pls.
Date: Mon, 18 Jan 2016 03:51:54 +0000 (UTC)
Message-ID: <pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
	<569C41B1.1090206@cn.fujitsu.com>
	<pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
	<569C58FB.70407@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 18 Jan 2016 11:16:11 +0800 as excerpted:

> Duncan wrote on 2016/01/18 03:10 +0000:
>>
>> Doesn't the kernel write cache get synced by timeout as well as
>> memory pressure and manual sync, with the timeouts found in
>> /proc/sys/vm/dirty_*_centisecs, with defaults of 5 seconds
>> background and 30 seconds higher priority foreground expiry?
>>
> Yep, I forgot timeout. It can also be specified by per fs mount
> option "commit=".
> 
> But I never /proc/sys/vm/dirty_* interface before... I'd better
> check the code or add some debug pr_info to learn such behavior.

Checking a bit more my understanding, since you brought up the
btrfs "commit=" mount option.

I knew about the option previously, and obviously knew it worked in the 
same context as the page-cache stuff, but in my understanding the btrfs 
"commit=" mount option operates at the filesystem layer, not the general 
filesystem-vm layer controlled by /proc/sys/vm/dirty_*.  In my 
understanding, therefore, the two timeouts could effectively be added, 
yielding a maximum 1 minute (30 seconds btrfs default commit time plus 30 
seconds vm expiry) commit time.

But that has always been an unverified on my part fuzzy assumption.  The 
two times could be the same layer, with the btrfs mount option being a 
per-filesystem method of controlling the same thing that /proc/sys/vm/
dirty_expire_centisecs controls globally (as you seemed to imply above), 
or the two could be different layers but with the countdown times 
overlapping, both of which would result in a 30-second total timeout, 
instead of the 30+30=60 that I had assumed.

And while we're at it, how does /proc/sys/vm/vfs_cache_pressure play into 
all this?  I know the dirty_* and how the dirty_*bytes vs. dirty_*ratio 
vs. dirty_*centisecs thing works, but don't quite understand how 
vfs_cache_pressure fits in with dirty_*.

Of course if there's already a good writeup on the dirty_* vs 
vfs_cache_pressure question somewhere, a link would be fine.  But I doubt 
there's good info on how the btrfs commit= mount option fits into it all, 
as the btrfs option is relatively newer and it's likely I'd have seen 
that all ready, if it was out there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

