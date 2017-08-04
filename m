Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36470 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbdHDL0f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 07:26:35 -0400
Received: by mail-io0-f172.google.com with SMTP id g35so4824385ioi.3
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Aug 2017 04:26:35 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Brendan Hide <brendan@swiftspirit.co.za>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <fb2cf0a6-12b2-9356-657a-ffd58b375c75@dirtcellar.net>
 <1501784952.4789.3.camel@scientia.net>
 <fd0875d1-c96c-b1ac-0284-50613af0bd76@gmail.com>
 <ce5ca6f1-19ef-3bfc-541b-90d526e29e5c@swiftspirit.co.za>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ae2377bf-9108-c0ff-4228-e73ac4b0dd2b@gmail.com>
Date: Fri, 4 Aug 2017 07:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <ce5ca6f1-19ef-3bfc-541b-90d526e29e5c@swiftspirit.co.za>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-03 16:45, Brendan Hide wrote:
> 
> 
> On 08/03/2017 09:22 PM, Austin S. Hemmelgarn wrote:
>> On 2017-08-03 14:29, Christoph Anton Mitterer wrote:
>>> On Thu, 2017-08-03 at 20:08 +0200, waxhead wrote:
>>> There are no higher-level management tools (e.g. RAID
>>> management/monitoring, etc.)...
> [snip]
> 
>> As far as 'higher-level' management tools, you're using your system 
>> wrong if you _need_ them.  There is no need for there to be a GUI, or 
>> a web interface, or a DBus interface, or any other such bloat in the 
>> main management tools, they work just fine as is and are mostly on par 
>> with the interfaces provided by LVM, MD, and ZFS (other than the lack 
>> of machine parseable output).  I'd also argue that if you can't 
>> reassemble your storage stack by hand without using 'higher-level' 
>> tools, you should not be using that storage stack as you don't 
>> properly understand it.
>>
>> On the subject of monitoring specifically, part of the issue there is 
>> kernel side, any monitoring system currently needs to be 
>> polling-based, not event-based, and as a result monitoring tends to be 
>> a very system specific affair based on how much overhead you're 
>> willing to tolerate. The limited stuff that does exist is also trivial 
>> to integrate with many pieces of existing monitoring infrastructure 
>> (like Nagios or monit), and therefore the people who care about it a 
>> lot (like me) are either monitoring by hand, or are just using the 
>> tools with their existing infrastructure (for example, I use monit 
>> already on all my systems, so I just make sure to have entries in the 
>> config for that to check error counters and scrub results), so there's 
>> not much in the way of incentive for the concerned parties to reinvent 
>> the wheel.
> 
> To counter, I think this is a big problem with btrfs, especially in 
> terms of user attrition. We don't need "GUI" tools. At all. But we do 
> need that btrfs is self-sufficient enough that regular users don't get 
> burnt by what they would view as unexpected behaviour.  We have 
> currently a situation where btrfs is too demanding on inexperienced users.
> 
> I feel we need better worst-case behaviours. For example, if *I* have a 
> btrfs on its second-to-last-available chunk, it means I'm not 
> micro-managing properly. But users shouldn't have to micro-manage in the 
> first place. Btrfs (or a management tool) should just know to balance 
> the least-used chunk and/or delete the lowest-priority snapshot, etc. It 
> shouldn't cause my services/apps to give diskspace errors when, clearly, 
> there is free space available.
That's not just an issue with BTRFS, it's an issue with the distros too. 
  The only one that ships any kind of scheduled regular maintenance as 
far as I know is SUSE.  We don't need some daemon, or even special 
handling in the kernel, we just need to provide people with standard 
maintenance tools, and proper advice for monitoring.  I've been meaning 
to write up some wrappers and a couple of cron files to handle this a 
bit better, but just haven't had time.  I may look at getting that done 
either today or early next week.
> 
> The other "high-level" aspect would be along the lines of better 
> guidance and standardisation for distros on how best to configure btrfs. 
> This would include guidance/best practices for things like appropriate 
> subvolume mountpoints and snapshot paths, sensible schedules or logic 
> (or perhaps even example tools/scripts) for balancing and scrubbing the 
> filesystem.
There are currently three standards for this:
1. The snapper way, used by at least SUSE and Ubuntu, which IMO ends up 
being way too complicated for not much benefit.
2. The traditional filesystem way, used by most other distros, which 
doesn't use subvolumes at all.
3. The user choice way, used by stuff like Arch and Gentoo, which pretty 
much says the rest of the OS could care less how the filesystems and 
subvolumes are organized, as long as things work.

Overall, other than the first one, this is no different than with 
regular filesystems.
> 
> I don't have all the answers. But I also don't want to have to tell 
> people they can't adopt it because a) they don't (or never will) 
> understand it; and b) they're going to resent me for their irresponsibly 
> losing their own data.
> 

