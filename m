Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54331 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdDHHKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 03:10:15 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cwkVS-0007iL-9K
        for linux-btrfs@vger.kernel.org; Sat, 08 Apr 2017 09:09:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Sat, 8 Apr 2017 07:09:46 +0000 (UTC)
Message-ID: <pan$73f5d$10db2186$e68658ee$e4c80b71@cox.net>
References: <572D0C8B.8010404@mendix.com>
        <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
        <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Fri, 07 Apr 2017 23:25:29 +0200 as
excerpted:

> So, this is why putting your /var/log, /var/lib/mailman and /var/spool
> on btrfs is a terrible idea.
> 
> Because the allocator keeps walking forward every file that is created
> and then removed leaves a blank spot behind.
> 
> Autodefrag makes the situation only a little bit better, changing the
> resulting pattern from a sky full of stars into a snowstorm. The result
> of taking a few small writes and rewriting them again is that again the
> small parts of free space are left behind.

> [... B]ecause of the pattern we end
> up with, a large write apparently fails (the files downloaded when doing
> apt-get update by daily cron) which causes a new chunk allocation. This
> is clearly visible in the videos. Directly after that, the new chunk
> gets filled with the same pattern, because the extent allocator now
> continues there and next day same thing happens again etc...

> Now, another surprise:
> 
> From the exact moment I did mount -o remount,nossd on this filesystem,
> the problem vanished.

That large write in the middle of small writes pattern might be why I've 
not seen the problem on my btrfs', on ssd, here.

Remember, I'm the guy who keeps advocating multiple independent small 
btrfs on partitioned-up larger devices, with the splits between 
independent btrfs' based on tasks.

So I have a quite tiny sub-GiB independent log btrfs handling those slow 
incremental writes to generally smaller files, a separate / with the main 
system on it that's mounted read-only unless I'm actively updating it, a 
separate home with my reasonably small size but written at-once non-media 
user files, a separate media partition/fs with my much larger but very 
seldom rewritten media files, and a separate update partition/fs with the 
local cache of the distro tree and overlays, sources (since it's gentoo), 
built binpkg cache, etc, with small to medium-large files that are 
comparatively frequently replaced.

So the relatively small slow-written and frequently rotated log files are 
isolated to their own partition/fs, undisturbed by the much larger update-
writes to the updates and / partitions/fs, isolating them from the update-
trigger that triggers the chunk allocations on your larger single general 
purpose filesystem/image, amongst all those fragmenting slow logfile 
writes.

Very interesting and informative thread, BTW.  I'm learning quite a bit. 
=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

