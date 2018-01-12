Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35408 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965085AbeALTnp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 14:43:45 -0500
Received: by mail-it0-f49.google.com with SMTP id f143so10567892itb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 11:43:45 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Tom Worster <fsb@thefsb.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com>
 <71E230CA-4BE1-4089-8881-7811E7BAF3BC@thefsb.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <329f2e65-68ea-5933-781e-460d75dfe845@gmail.com>
Date: Fri, 12 Jan 2018 14:43:42 -0500
MIME-Version: 1.0
In-Reply-To: <71E230CA-4BE1-4089-8881-7811E7BAF3BC@thefsb.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-12 14:26, Tom Worster wrote:
> On 12 Jan 2018, at 13:24, Austin S. Hemmelgarn wrote:
> 
>> OK, I've gotten a lot of good feedback on this, and the general 
>> consensus seems to be:
>>
>> * If we're going to recommend regular balance, we should explain how 
>> it actually helps things.
>> * We should mention the performance interactions with qgroups, as well 
>> as warning people off of running other things like scrubs or defrag 
>> concurrently.
>> * The filters should be reasonably tame in terms of chunk selection.
>> * BTRFS should ideally get smarter about this kind of thing so the 
>> user doesn't have to be.
>>
>> To that end, I propose the following text for the FAQ:
>>
>> Q: Do I need to run a balance regularly?
>>
>> A: While not strictly necessary for normal operations, running a 
>> filtered balance regularly can help prevent your filesystem from 
>> ending up with ENOSPC issues.  The following command run daily on each 
>> BTRFS volume should be more than sufficient for most users:
>>
>> `btrfs balance start -dusage=25 -dlimit=2..10 -musage=25 -mlimit=2..10`
>>
>> If you are running a kernel older than version 4.4 and can't upgrade, 
>> the following should be used instead:
>>
>> `btrfs balance start -dusage=25 -musage=25`
>>
>> Both of these commands will effectively compact partially full chunks 
>> on the filesystem so that new chunks have more space to be allocated. 
>> For more information on what the commands actually mean, check out 
>> `man btrfs-balance`
>>
>> When run regularly, both of these should complete extremely fast on 
>> most BTRFS volumes.  Note that these may run significantly slower on 
>> volumes which have quotas enabled.  Additionally, it's best to make 
>> sure other things aren't putting a lot of load on the filesystem while 
>> running a balance, so try to make sure this doesn't run at the same 
>> time as a scrub or defrag.
>>
>> A full, unfiltered balance (one without any options passed in) is 
>> completely unnecessary for normal usage of a filesystem.
> 
> Hi Austin,
> 
>  From the discussion we've had I have the impression there might be 
> another way to answer this FAQ that is as valid as this one: monitor 
> usage. You may never need to balance, or hardly ever.
> 
> Your suggestion for regular balance has clear advantages: It's 
> set-and-forget. And to apply the advice the user doesn't need to 
> understand the allocator, interpret usage stats, or figure out filters.
> 
> On the other hand, not needing to run balance is quite appealing. So is 
> avoiding yet another cron/timer job if I don't really need it.
While I can understand some people may prefer that, it's also a lot more 
error prone, and I personally don't think it's a good idea to suggest 
it.  Recommendations where the user is required to regularly do 
something themself and evaluate the results tend to be bad ideas from a 
support perspective.  Yeah, it may be fine for you and me to just 
monitor things manually, but it's not really a good idea for someone who 
doesn't have any understanding of how things work under the hood.  It's 
also not likely to be what most distros end up standardizing on as best 
practices for handling this, and not matching up with that will look bad.
> 
> Question about your proposed text, "When run regularly, both of these 
> should complete extremely fast..." Does that imply that it might not be 
> fast if, say, you've never run balance before on a filesystem with a lot 
> of unused space in allocated chunks?
There's a very high potential that it will take a long time on the first 
run (or the first couple if things are particularly bad), but the 
filters still limit exactly how much data will get moved.  The 
recommended command with the limit filters for example shouldn't ever 
move more than about 15GB of data, and it will only do that much on 
pathologically bad multi-TB volumes, and thus it shouldn't take more 
than a few minutes on SSD's, or about 15-20 on traditional hard drives.
