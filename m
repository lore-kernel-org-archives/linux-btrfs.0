From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: synchronous removal?
Date: Mon, 2 Aug 2010 08:25:01 -0700
Message-ID: <C76A65F2-765A-44EB-977C-0268049A82F7@noir.com>
References: <4C55E2F3.3030202@noir.com> <AANLkTin=o404zv6qtgfzdbV2KoHkDxTaHEifk26XWnCY@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8A306)
Content-Type: text/plain;
	charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=o404zv6qtgfzdbV2KoHkDxTaHEifk26XWnCY@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

How would you determine whether to remove another snapshot or to wait for previously removed space to be digested?

If you simply remove snapshots then you'll end up removing all if your snapshots and df will still say you don't have enough space. Btdt. What I'm doing right now is removing a snapshot and immediately sleeping for 60 seconds in hopes that it will be digested in that time. Judicious use of df and log lines tell me that some of the space is digested in that time but I have no way, (that I know of), to determine whether all of it has been.

--rich

On Aug 2, 2010, at 4:35, Leonidas Spyropoulos <artafinde@gmail.com> wrote:

> I think a cron job checking the output of df could do that.
> The shell script will check if there is enough space to create a snapshot
> otherwise remove a snapshot.
> 
> How about that?
> 
> On Sun, Aug 1, 2010 at 10:11 PM, K. Richard Pixley <rich@noir.com> wrote:
>>  I have an application where I want to snapshot, then do something, and
>> based on the result, snapshot either the result or the previous state and
>> then repeat.
>> 
>> So far, so good.  But eventually my disk fills and I want to remove the
>> oldest snapshots, as many as I need to in order to make room enough for the
>> next cycle.
>> 
>> I notice that when I remove old snapshots and delete old directories, the
>> free space on my disk, (according to df), doesn't rise immediately.  But
>> instead, I see an active btrfs_cleaner for a while and my free space rises
>> while it runs.  I'm presuming that the removed files and snapshots aren't
>> fully reclaimed immediately but rather wait for something akin to a garbage
>> collection much the way modern berkeley file systems do.
>> 
>> How can I either:
>> 
>> a) wait for the cleaner to digest the free space
>> b) determine that the cleaner has digested all available free space for now,
>> (if not I can sleep for a while)
>> c) synchronously force the cleaner to digest available free space
>> d) something else I haven't thought of yet
>> 
>> Basically, I want to check to see if there's enough space available.  If
>> not, I want to remove some things, (including at least one snapshot), wait
>> for the cleaner to digest, and then start over with the checking to see if
>> there's enough space available and loop until I've removed enough things
>> that there is enough space available.  How can I do that on a btrfs file
>> system?
>> 
>> --rich
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> 
> 
> -- 
> Caution: breathing may be hazardous to your health.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
