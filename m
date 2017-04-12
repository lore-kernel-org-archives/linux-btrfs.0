Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33367 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754419AbdDLWtB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 18:49:01 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cyR4H-0000e9-GL
        for linux-btrfs@vger.kernel.org; Thu, 13 Apr 2017 00:48:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS as a GlusterFS storage back-end, and what I've learned from
 using it as such.
Date: Wed, 12 Apr 2017 22:48:45 +0000 (UTC)
Message-ID: <pan$ea378$cb1a6397$cb89db25$92b1a470@cox.net>
References: <7e63733a-6ab5-d92d-f9b2-f129ebd81f36@gmail.com>
        <e31fb17b-3331-b168-e96a-72398ea8af62@cn.fujitsu.com>
        <45e228aa-c650-98a6-f23a-095eb690a181@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 12 Apr 2017 07:18:44 -0400 as
excerpted:

> On 2017-04-12 01:49, Qu Wenruo wrote:
>>
>> At 04/11/2017 11:40 PM, Austin S. Hemmelgarn wrote:
>>>
>>> 4. Depending on other factors, compression can actually slow you down
>>> pretty significantly.  In the particular case I saw this happen (all
>>> cores completely utilized by userspace software), LZO compression
>>> actually caused around 5-10% performance degradation compared to no
>>> compression.  This is somewhat obvious once it's explained, but it's
>>> not exactly intuitive  and as such it's probably worth documenting in
>>> the man pages that compression won't always make things better.  I may
>>> send a patch to add this at some point in the near future.
>>
>> This seems interesting.
>> Maybe it's CPU limiting the performance?

> In this case, I'm pretty certain that that's the cause.  I've only ever
> seen this happen though when the CPU was under either full or more than
> full load (so pretty much full utilization of all the cores), and it
> gets worse as the CPU load increases.

This seems blatantly obvious to me, no explanation needed, at least 
assuming people understand what compression is and does.  It certainly 
doesn't seem btrfs specific to me.

Which makes my wonder if I'm missing something that would seem to 
counteract the obvious, but doesn't in this case.

Compression at its most basic can be described as a tradeoff of CPU 
cycles to decrease data size (by tracking and eliminating internal 
redundancy), and thus transfer time of the data.

In conditions where the bottleneck is (seek and) transfer time, as on hdds 
with mostly idle CPUs, compression therefore tends to be a pretty big 
performance boost because the lower size of the compressed data means 
fewer seeks and lower transfer time, and because that's where the 
bottleneck is, making it more efficient increases the performance of the 
entire thing.

But the context here is SSDs, with 0 seek time and fast transfer speeds, 
and already 100% utilized CPUs, so the bottleneck is the 100% utilized 
CPUs and the increased CPU cycles necessary for the compression/
decompression simply increases the CPU bottleneck.

So far from a mystery, this seems so basic to me that the simplest 
dunderhead should get it, at least as long as they aren't /so/ simple 
they can't understand the tradeoff inherent in the simplest compression 
basics.

But that's not the implication of the discussion quoted above, and the 
participants are both what I'd consider far more qualified to understand 
and deal with this sort of thing than I, so I /gotta/ be missing 
something that despite my correct ultimate conclusion, means I haven't 
reached it using a correct logic train, and that there /must/ be some 
logic steps in there that I've left out that would intuitively switch the 
logic, making this a rather less intuitive conclusion than I'm thinking.

So what am I missing?

Or is it simply that the tradeoff between CPU usage and data size and 
minimum transit time isn't as simple and basic for most people as I'm 
assuming here, such that it isn't obviously giving more work to an 
already bottlenecked CPU, reducing the performance when it /is/ the CPU 
that's bottlenecked?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

