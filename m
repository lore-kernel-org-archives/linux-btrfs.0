Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43600 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdIKUgP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 16:36:15 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1drVR4-0005sg-8E
        for linux-btrfs@vger.kernel.org; Mon, 11 Sep 2017 22:36:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs_remove_chunk call trace?
Date: Mon, 11 Sep 2017 20:35:46 +0000 (UTC)
Message-ID: <pan$189d9$b081e2b5$d8e128c5$16f4d94f@cox.net>
References: <CAG+QAKXZwsTmrNFYNk9RmbL1DZGZ-oAe1GykVRdBOFxkLTwH9g@mail.gmail.com>
        <CAG+QAKXNhA3YCjLAp5yOam05-egoHgY4YszR3XJFF=vUC-+Cdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Rauenzahn posted on Sun, 10 Sep 2017 22:45:50 -0700 as excerpted:

> ...and can it be related to the Samsung 840 SSD's not supporting NCQ
> Trim?  (Although I can't tell which device this trace is from -- it
> could be a mechanical Western Digital.)
> 
> On Sun, Sep 10, 2017 at 10:16 PM, Rich Rauenzahn <rrauenza@gmail.com>
> wrote:
>> Is this something to be concerned about?
>>
>> I'm running the latest mainline kernel on CentOS 7.
>>
>> [ 1338.891412] CPU: 2 PID: 790 Comm: btrfs-cleaner
>> Tainted: G        W     4.13.1-1.el7.elrepo.x86_64 #1

As a Samsung ssd (tho 850) owner myself, who looked into mounting with 
the discard mount option on my new ssds here...

Samsung ssds lack of queued-trim shouldn't be a problem on anything close 
to a current kernel, obviously including the 4.13.1 you're running above, 
because the kernel block layer has blacklisted queued-trim on all Samsung 
SSDs for at least several kernel cycles (not sure when it went in, but 
there was a time in the 3.x kernel era when queued-trim on samsung ssds 
was causing problems, thus the blacklisting).

So the only way that could be a problem would be if that blacklisting is 
somehow being bypassed, and that indeed would be a *BIG* problem, well 
beyond btrfs.


That said, enabling the discard mount option isn't recommended in 
general, because unless queued-trim /is/ supported it lowers 
performance.  Additionally, there have been btrfs data corruption level 
bugs related to trim handling in the past, altho AFAIK all such known 
bugs are now fixed.  The option is there for those who know their device 
supports queued-trim and want to use it, but it isn't recommended 
otherwise, and because of that it's less well tested than the more 
mainstream options, which means there's at least some additional risk in 
enabling it, even if there's no known issues on current kernels other 
than the performance issue, if your device doesn't support queued-trim.

The recommended alternative is periodic/scheduled use of the fstrim 
command.  Most reasonably current distros will have a scheduled cron or 
systemd-timer job for that, tho you may or may not need to enable it.  
Weekly should be fine for most users, tho for ssds nearing capacity, 
daily may be useful.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

