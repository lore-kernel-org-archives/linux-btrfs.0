Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48424 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752903AbeAJEk3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 23:40:29 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eZ89Y-0006m0-BA
        for linux-btrfs@vger.kernel.org; Wed, 10 Jan 2018 05:38:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Wed, 10 Jan 2018 04:38:09 +0000 (UTC)
Message-ID: <pan$c820$53f2dc3f$a7c2e26e$ab6cc680@cox.net>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
        <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
        <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Cobb posted on Mon, 08 Jan 2018 18:17:13 +0000 as excerpted:

> On 08/01/18 16:34, Austin S. Hemmelgarn wrote:
>> Ideally, I think it should be as generic as reasonably possible,
>> possibly something along the lines of:
>> 
>> A: While not strictly necessary, running regular filtered balances (for
>> example `btrfs balance start -dusage=50 -dlimit=2 -musage=50
>> -mlimit=4`,
>> see `man btrfs-balance` for more info on what the options mean) can
>> help keep a volume healthy by mitigating the things that typically
>> cause ENOSPC errors.  Full balances by contrast are long and expensive
>> operations, and should be done only as a last resort.
> 
> That recommendation is similar to what I do and it works well for my use
> case. I would recommend it to anyone with my usage, but cannot say how
> well it would work for other uses. In my case, I run balances like that
> once a week: some weeks nothing happens, other weeks 5 or 10 blocks may
> get moved.


Why 50% usage, and why the rather low limits?

OK, so it rarely makes sense to go over 50% usage when the intent of the 
balance is to return chunks to the unallocated pool, because at 50% the 
payback ratio is one free chunk for two processed and it gets worse after 
that and MUCH worse after ~67-75%, where the ratios are 1:3 and 1:4 
respectively, but why so high especially for a suggested scheduled/
routine command?

I'd suggest a rather lower usage value, say 20/25/34%, for favorable 
payback ratios of 5:1, 4:1, and 3:1.  That should be reasonable for a 
generic recommendation for scheduled/routine balances.  If that's not 
enough, people can do more manually or increase the values from the 
generic recommendation for their specific use-case.

And I'd suggest either no limits or (for kernels that can handle it, 
4.4+, which at this point is everything within our recommended support 
range of the last two LTSs, thus now 4.9 earliest, anyway) range-limits, 
say 2..20, so it won't bother if there's less than enough to clear at 
least one chunk within the usage target (but see the observed behavior 
change noted below), but will do more than the low 2-4 in the above 
suggested limits if there is.  With the lower usage= values, processing 
should take less time per chunk, and if there's no more that fit the 
usage filter it won't use the higher range anyway, so the limit can and 
should be higher.


Meanwhile, for any recommendation of balance, I'd suggest also mentioning 
the negative effect that enabled quotas have on balance times, probably 
with a link to a fuller discussion where I'd suggest disabling them due 
to the scaling issues if the use-case doesn't require them, and if that's 
not possible due to the use-case, to at least consider temporarily 
disabling quotas before doing a balance so as to speed it up, after which 
they can be enabled again.  (I'm not sure if a manual quota rescan is 
required to update them at that point, or not.  I don't use quotas here 
or I'd test.)


And an additional observation...

I'm on ssd here and run many rather small independent btrfs instead of 
fewer larger ones, so I'm used to keeping an eye on usage, tho I've never 
found the need to schedule balances, partly because on ssd with 
relatively small btrfs, balances are fast enough they're not a problem to 
do "while I wait".

And I've definitely noticed an effect since the ssd option stopped using 
the 2 MiB spreading algorithm in 4.14.  In particular, while chunk usage 
was generally stable before that and I only occasionally needed to run 
balance to clear out empty chunks, now, balance with the usage filter 
will apparently actively fill in empty space in existing chunks, so while 
previously a usage-filtered balance that only rewrote one chunk didn't 
actually free anything, simply allocating a new chunk to replace the one 
it freed, so at least two chunks needed rewritten to actually free space 
back to unallocated...

Now, usage-filtered rewrites of only a single chunk routinely frees the 
allocated space, because it writes that small bit of data in the freed 
chunk into existing free space in other chunks.

At least I /presume/ that new balance-usage behavior is due to the ssd 
changes.  Maybe it's due to other patches.  Either way, it's an 
interesting and useful change. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

