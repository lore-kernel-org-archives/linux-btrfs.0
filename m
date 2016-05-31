Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37051 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbcEaMtJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 08:49:09 -0400
Received: by mail-it0-f51.google.com with SMTP id z123so50149923itg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 31 May 2016 05:49:09 -0700 (PDT)
Subject: Re: Reducing impact of periodic btrfs balance
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <573C6E47.2080109@cobb.uk.net>
 <d40d8fc7-3766-1ccc-3253-9f870a0f4f85@cn.fujitsu.com>
 <574774DB.4020507@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <074cdb6e-5eee-ae85-c275-605a1d9bb177@gmail.com>
Date: Tue, 31 May 2016 08:49:03 -0400
MIME-Version: 1.0
In-Reply-To: <574774DB.4020507@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-26 18:12, Graham Cobb wrote:
> On 19/05/16 02:33, Qu Wenruo wrote:
>>
>>
>> Graham Cobb wrote on 2016/05/18 14:29 +0100:
>>> A while ago I had a "no space" problem (despite fi df, fi show and fi
>>> usage all agreeing I had over 1TB free).  But this email isn't about
>>> that.
>>>
>>> As part of fixing that problem, I tried to do a "balance -dusage=20" on
>>> the disk.  I was expecting it to have system impact, but it was a major
>>> disaster.  The balance didn't just run for a long time, it locked out
>>> all activity on the disk for hours.  A simple "touch" command to create
>>> one file took over an hour.
>>
>> It seems that balance blocked a transaction for a long time, which makes
>> your touch operation to wait for that transaction to end.
>
> I have been reading volumes.c.  But I don't have a feel for which
> transactions are likely to be the things blocking for a really long time
> (hours).
>
> If this can occur, I think the warnings to users about balance need to
> be extended to include this issue.  Currently the user mode code warns
> users that unfiltered balances may take a long time, but it doesn't warn
> that the disk may be unusable during that time.
Whether or not the disk is usable depends on a number of factors.  I 
have no issues using my disks while they're being balanced (even hen 
doing a full balance), but they also all support command queuing, and 
are either fast disks, or on really good storage controllers.
>
>>> 3) My btrfs-balance-slowly script would work better if there was a
>>> time-based limit filter for balance, not just the current count-based
>>> filter.  I would like to be able to say, for example, run balance for no
>>> more than 10 minutes (completing the operation in progress, of course)
>>> then return.
>>
>> As btrfs balance is done in block group unit, I'm afraid such thing
>> would be a little tricky to implement.
>
> It would be really easy to add a jiffies-based limit into the checks in
> should_balance_chunk.  Of course, this would only test the limit in
> between block groups but that is what I was looking for -- a time-based
> version of the current limit filter.
>
> On the other hand, the time limit could just be added into the user mode
> code: after the timer expires it could issue a "balance pause".  Would
> the effect be identical in terms of timing, resources required, etc?
This is entirely userspace policy, and thus should be done in userspace. 
  Pretty much everything that has a filter already can't be entirely 
implemented in userspace, despite technically being policy, because it 
requires specific knowledge of the filesystem internals.  Having a time 
limited mode requires no such knowledge, and thus could be done in 
userspace.  Putting it in userspace also would make it easier to debug, 
and less likely to cause other fallout in the rest of the balance code.
>
> Would it be better to do a "balance pause" or a "balance cancel"?  The
> goal would be to suspend balance processing and allow the system to do
> something else for a while (say 20 minutes) and then go back to doing
> more balance later.  What is the difference between resuming a paused
> balance compared to starting a new balance? Bearing in mind that this is
> a heavily used disk so we can expect lots of transactions to have
> happened in the meantime (otherwise we wouldn't need this capability)?
The difference between resuming a paused balance and starting a balance 
after canceling one is pretty simple.  Resuming a paused balance will 
not re-process chunks that were already processed, starting a new one 
after canceling may or may not (depending on what other filters are 
involved).  I think having the option to do either would be a good 
thing, cancel makes a bit more sense if you're going long periods of 
time between each run and are using other limiting filters (like usage 
filtering), whereas pause makes more sense if doing a full balance or 
only pausing for a short time between each run.

Depending on how the balance ioctl reacts to being interrupted with a 
signal, this would in theory not be hard to implement either.

