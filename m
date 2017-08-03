Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:38703 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdHCTXC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 15:23:02 -0400
Received: by mail-io0-f170.google.com with SMTP id g71so10632991ioe.5
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 12:23:02 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <fb2cf0a6-12b2-9356-657a-ffd58b375c75@dirtcellar.net>
 <1501784952.4789.3.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fd0875d1-c96c-b1ac-0284-50613af0bd76@gmail.com>
Date: Thu, 3 Aug 2017 15:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <1501784952.4789.3.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-03 14:29, Christoph Anton Mitterer wrote:
> On Thu, 2017-08-03 at 20:08 +0200, waxhead wrote:
>> Brendan Hide wrote:
>>> The title seems alarmist to me - and I suspect it is going to be
>>> misconstrued. :-/
>>>
>>>  From the release notes at
>>> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Li
>>> nux/7/html/7.4_Release_Notes/chap-Red_Hat_Enterprise_Linux-
>>> 7.4_Release_Notes-Deprecated_Functionality.html
>>> "Btrfs has been deprecated
>>>
> 
> Wow... not that this would have any direct effect... it's still quite
> alarming, isn't it?
> 
> This is not meant as criticism, but I often wonder myself where the
> btrfs is going to!? :-/
> 
> It's in the kernel now since when? 2009? And while the extremely basic
> things (snapshots, etc.) seem to work quite stable... other things seem
> to be rather stuck (RAID?)... not to talk about many things that have
> been kinda "promised" (fancy different compression algos, n-parity-
> raid).
I assume you mean the erasure coding the devs and docs call raid56 when 
you're talking about stuck features, and you're right, it has been 
stuck, but it arguably should have been better tested and verified 
before being merged at all.  As far as other 'raid' profiles, raid1 and 
raid0 work fine, and raid10 is mostly fine once you wrap your head 
around the implications of the inconsistent component device ordering.
> There are no higher-level management tools (e.g. RAID
> management/monitoring, etc.)... there are still some kinda serious
> issues (the attacks/corruptions likely possible via UUID collisions)...
The UUID collision issue is present in almost all volume managers and 
filesystems, it just does more damage in BTRFS, and is exacerbated by 
the brain-dead 'scan everything for BTRFS' policy in udev.

As far as 'higher-level' management tools, you're using your system 
wrong if you _need_ them.  There is no need for there to be a GUI, or a 
web interface, or a DBus interface, or any other such bloat in the main 
management tools, they work just fine as is and are mostly on par with 
the interfaces provided by LVM, MD, and ZFS (other than the lack of 
machine parseable output).  I'd also argue that if you can't reassemble 
your storage stack by hand without using 'higher-level' tools, you 
should not be using that storage stack as you don't properly understand it.

On the subject of monitoring specifically, part of the issue there is 
kernel side, any monitoring system currently needs to be polling-based, 
not event-based, and as a result monitoring tends to be a very system 
specific affair based on how much overhead you're willing to tolerate. 
The limited stuff that does exist is also trivial to integrate with many 
pieces of existing monitoring infrastructure (like Nagios or monit), and 
therefore the people who care about it a lot (like me) are either 
monitoring by hand, or are just using the tools with their existing 
infrastructure (for example, I use monit already on all my systems, so I 
just make sure to have entries in the config for that to check error 
counters and scrub results), so there's not much in the way of incentive 
for the concerned parties to reinvent the wheel.
> One thing that I miss since long would be the checksumming with
> nodatacow.
It has been stated multiple times on the list that this is not possible 
without making nodatacow prone to data loss.
> Also it has always been said that the actual performance tunning would
> still lay ahead?!
While there hasn't been anything touted specifically as performance 
tuning, performance has improved slightly since I started using BTRFS.
> 
> 
> I really like btrfs and use it on all my personal systems... and I
> haven't had any data loss since then (only a number of seriously
> looking false positives due to bugs in btrfs check ;-) )... but one
> still reads every now and then from people here on the list who seem to
> suffer from more serious losses.
And this brings up part of the issue with uptake.  People are quick to 
post about issues, but not successes.  I've been running BTRFS on almost 
everything (I don't use it in VM's because of the performance 
implications of having multiple CoW layers) since around kernel 3.9, 
have had no critical issues (ones resulting in data loss) since about 
3.16, and have actually survived quite a few pieces of marginal or 
failed hardware as a result of BTRFS.
> 
> 
> 
> So is there any concrete roadmap? Or priority tasks? Is there a lack of
> developers?
In order, no, in theory yes but not in practice, and somewhat.

As a general rule, all FOSS projects are short on developers.  Most of 
the work that is occurring on BTRFS is being sponsored by SUSE, 
Facebook, or Fujitsu (at least, I'm pretty sure those are the primary 
sponsors), and their priorities will not necessarily coincide with 
normal end-user priorities.  I'd say though that testing and review are 
just as much short on manpower as development.
