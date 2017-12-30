Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41779 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdL3Ae1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 19:34:27 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eV54U-00028o-1c
        for linux-btrfs@vger.kernel.org; Sat, 30 Dec 2017 01:32:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs balance problems
Date: Sat, 30 Dec 2017 01:34:04 +0100
Message-ID: <sg3jhe-c9a.ln1@hurikhan77.spdns.de>
References: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
        <VI1PR08MB03368FD615EFAF0C3BB6195B92030@VI1PR08MB0336.eurprd08.prod.outlook.com>
        <CAAMvbhHV=BvRLv14U0JRrYmhiXeREOTNiVLPkuq=MO6dH4jDiQ@mail.gmail.com>
        <CAAMvbhG62rbphgWXQ_UiHHtH89wpsZXaLU0mut+4E+uuK2nbFw@mail.gmail.com>
        <pan$ef2b8$3487070c$fddf5d1f$59a5a7a2@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 28 Dec 2017 00:39:37 +0000 schrieb Duncan:

>> I can I get btrfs balance to work in the background, without adversely
>> affecting other applications?
> 
> I'd actually suggest a different strategy.
> 
> What I did here way back when I was still on reiserfs on spinning rust,
> where it made more difference than on ssd, but I kept the settings when
> I switched to ssd and btrfs, and at least some others have mentioned
> that similar settings helped them on btrfs as well, is...
> 
> Problem: The kernel virtual-memory subsystem's writeback cache was
> originally configured for systems with well under a Gigabyte of RAM, and
> the defaults no longer work so well on multi-GiB-RAM systems,
> particularly above 8 GiB RAM, because they are based on a percentage of
> available RAM, and will typically let several GiB of dirty writeback
> cache accumulate before kicking off any attempt to actually write it to
> storage.  On spinning rust, when writeback /does/ finally kickoff, this
> can result in hogging the IO for well over half a minute at a time,
> where 30 seconds also happens to be the default "flush it anyway" time.

This is somehow like the buffer bloat discussion for networking... Big 
buffers increase latency. There is more than one type of buffer.

Additionally to what Duncan wrote (first type of buffer), the kernel 
lately got a new option to fight this "buffer bloat": writeback-
throttling. It may help to enable that option.

The second type of buffer is the io queue.

So, you may also want to lower the io queue depth (nr_requests) of your 
devices. I think it defaults to 128 while most consumer drives only have 
a queue depth of 31 or 32 commands. Thus, reducing nr_requests for some 
of your devices may help you achieve better latency (but reduces 
throughput).

Especially if working with io schedulers that do not implement io 
priorities, you could simply lower nr_requests to around or below the 
native command queue depth of your devices. The device itself can handle 
it better in that case, especially on spinning rust, as the firmware 
knows when to pull certain selected commands from the queue during a 
rotation of the media. The kernel knows nothing about rotary positions, 
it can only use the queue to prioritize and reorder requests but cannot 
take advantage of rotary positions of the heads.

See

$ grep ^ /sys/block/*/queue/nr_requests


You may also get better results with increasing the nr_requests instead 
but at the cost of also adjusting the write buffer sizes, because with 
large nr_requests, you don't want blocking on writes so early, at least 
not when you need good latency. This probably works best for you with 
schedulers that care about latency, like deadline or kyber.

For testing, keep in mind that everything works in dependence to each 
other setting. So change one at a time, take your tests, then change 
another and see how that relates to the first change, even when the first 
change made your experience worse.

Another tip that's missing: Put different access classes onto different 
devices. That is, if you have a directory structure that's mostly written 
to, put it on it's own physical devices, with separate tuning and 
appropriate filesystem (log structured and cow filesystems are good at 
streaming writes). Put read mostly workloads also on their own device and 
filesystems. Put realtime workloads on their own device and filesystems. 
This gives you a much easier chance to succeed.


-- 
Regards,
Kai

Replies to list-only preferred.

