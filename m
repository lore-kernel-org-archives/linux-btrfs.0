Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:53295 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbcEZWMr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 18:12:47 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id C7F189B928
	for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 23:12:43 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id 9F3045FB89
	for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 23:12:43 +0100 (BST)
Subject: Re: Reducing impact of periodic btrfs balance
To: linux-btrfs@vger.kernel.org
References: <573C6E47.2080109@cobb.uk.net>
 <d40d8fc7-3766-1ccc-3253-9f870a0f4f85@cn.fujitsu.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <574774DB.4020507@cobb.uk.net>
Date: Thu, 26 May 2016 23:12:43 +0100
MIME-Version: 1.0
In-Reply-To: <d40d8fc7-3766-1ccc-3253-9f870a0f4f85@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/16 02:33, Qu Wenruo wrote:
> 
> 
> Graham Cobb wrote on 2016/05/18 14:29 +0100:
>> A while ago I had a "no space" problem (despite fi df, fi show and fi
>> usage all agreeing I had over 1TB free).  But this email isn't about
>> that.
>>
>> As part of fixing that problem, I tried to do a "balance -dusage=20" on
>> the disk.  I was expecting it to have system impact, but it was a major
>> disaster.  The balance didn't just run for a long time, it locked out
>> all activity on the disk for hours.  A simple "touch" command to create
>> one file took over an hour.
> 
> It seems that balance blocked a transaction for a long time, which makes
> your touch operation to wait for that transaction to end.

I have been reading volumes.c.  But I don't have a feel for which
transactions are likely to be the things blocking for a really long time
(hours).

If this can occur, I think the warnings to users about balance need to
be extended to include this issue.  Currently the user mode code warns
users that unfiltered balances may take a long time, but it doesn't warn
that the disk may be unusable during that time.

>> 3) My btrfs-balance-slowly script would work better if there was a
>> time-based limit filter for balance, not just the current count-based
>> filter.  I would like to be able to say, for example, run balance for no
>> more than 10 minutes (completing the operation in progress, of course)
>> then return.
> 
> As btrfs balance is done in block group unit, I'm afraid such thing
> would be a little tricky to implement.

It would be really easy to add a jiffies-based limit into the checks in
should_balance_chunk.  Of course, this would only test the limit in
between block groups but that is what I was looking for -- a time-based
version of the current limit filter.

On the other hand, the time limit could just be added into the user mode
code: after the timer expires it could issue a "balance pause".  Would
the effect be identical in terms of timing, resources required, etc?

Would it be better to do a "balance pause" or a "balance cancel"?  The
goal would be to suspend balance processing and allow the system to do
something else for a while (say 20 minutes) and then go back to doing
more balance later.  What is the difference between resuming a paused
balance compared to starting a new balance? Bearing in mind that this is
a heavily used disk so we can expect lots of transactions to have
happened in the meantime (otherwise we wouldn't need this capability)?

Graham
