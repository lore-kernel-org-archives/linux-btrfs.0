Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:41578 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932732AbeAKMuJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 07:50:09 -0500
Received: by mail-it0-f44.google.com with SMTP id b77so3978696itd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 04:50:09 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: waxhead@dirtcellar.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <8a80ff4a-07ef-f442-0730-9be659177c7c@dirtcellar.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8d9609fa-69ce-0bf0-9d8c-5b123677db29@gmail.com>
Date: Thu, 11 Jan 2018 07:50:03 -0500
MIME-Version: 1.0
In-Reply-To: <8a80ff4a-07ef-f442-0730-9be659177c7c@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-10 16:37, waxhead wrote:
> Austin S. Hemmelgarn wrote:
>> So, for a while now I've been recommending small filtered balances to
>> people as part of regular maintenance for BTRFS filesystems under the
>> logic that it does help in some cases and can't really hurt (and if done
>> right, is really inexpensive in terms of resources).  This ended up
>> integrated partially in the info text next to the BTRFS charts on
>> netdata's dashboard, and someone has now pointed out (correctly I might
>> add) that this is at odds with the BTRFS FAQ entry on balances.
>>
>> For reference, here's the bit about it in netdata:
>>
>> You can keep your volume healthy by running the `btrfs balance` command
>> on it regularly (check `man btrfs-balance` for more info).
>>
>>
>> And here's the FAQ entry:
>>
>> Q: Do I need to run a balance regularly?
>>
>> A: In general usage, no. A full unfiltered balance typically takes a
>> long time, and will rewrite huge amounts of data unnecessarily. You may
>> wish to run a balance on metadata only (see Balance_Filters) if you find
>> you have very large amounts of metadata space allocated but unused, but
>> this should be a last resort.
>>
>>
>> I've commented in the issue in netdata's issue tracker that I feel that
>> the FAQ entry could be better worded (strictly speaking, you don't
>> _need_ to run balances regularly, but it's usually a good idea). Looking
>> at both though, I think they could probably both be improved, but I
>> would like to get some input here on what people actually think the best
>> current practices are regarding this (and ideally why they feel that
>> way) before I go and change anything.
>>
>> So, on that note, how does anybody else out there feel about this?  Is
>> balancing regularly with filters restricting things to small numbers of
>> mostly empty chunks a good thing for regular maintenance or not?
>> -- 
> As just a regular user I would think that the first thing you would need 
> is an analyze that can tell you if it is a good idea to balance or not 
> in the first place.
In an ideal situation, the only reason it should ever be a bad idea to 
run a balance is the performance impact (which is of course why we have 
filters).  Beyond that though, there's too much involved for even a 
computer to reliably tell you if it will be beneficial to run a balance 
or not.  It depends not just on how the data looks on the filesystem, 
but also how you are going to be using the filesystem in the near future 
(for example, if you've got a number of large blocks of empty space 
within data chunks, it might make sense to balance, but not if you're 
likely to be adding a bunch of new files in the very near future (they 
will just end up packed into that empty space in existing chunks, and 
your actual layout on disk shouldn't be all that different from if you 
had run a balance)).
> 
> Scrub seems like a great place to start - e.g. scrub could auto-analyze 
> and report back need to balance. I also think that scrub should 
> optionally autobalance if needed.
> 
> Balance may not be needed, but if one can determine that balancing would 
> speed up things a bit I don't see why this as an option can't be 
> scheduled automatically. Ideally there should be a "scrub and polish" 
> option that would scrub, balance and perhaps even defragment in one go.
In this case, the recommendation isn't as much about speed as it is 
about trying to keep things from getting into a state where you get 
ENOSPC but conventional tools report lots of free space.  As a general 
rule, unless things are pathologically bad to begin with, balancing a 
filesystem won't usually have any measurable impact on performance.
> 
> In fact, the way I see it btrfs should idealy by itself keep track on 
> each data/metadata chunk and it should know , when was this chunk last 
> affected by a scrub, balance, defrag etc and perform the required 
> operations by itself based on a configuration or similar. Some may 
> disagree for good reasons , but for me this is my wishlist for a 
> filesystem :) e.g. a pool that just works and only annoys you with the 
> need of replacing a bad disk every now and then :)
Long-term, that type of things is a goal, but I doubt that we're going 
to go that far with automation (even ZFS doesn't go that far, you still 
have to schedule scrubs and similar things).

