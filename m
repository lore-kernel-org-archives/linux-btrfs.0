Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:34974 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbcESMr5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 08:47:57 -0400
Received: by mail-ig0-f196.google.com with SMTP id jn6so7370323igb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 05:47:57 -0700 (PDT)
Subject: Re: [PATCH V2] Btrfs: introduce ticketed enospc infrastructure
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
References: <1458926760-17563-8-git-send-email-jbacik@fb.com>
 <1463506255-15918-1-git-send-email-jbacik@fb.com>
 <1ff146f2-c8e6-1f84-bb03-1f73cc716177@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0918d068-79ef-9772-313c-5dcd9a346f76@gmail.com>
Date: Thu, 19 May 2016 08:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <1ff146f2-c8e6-1f84-bb03-1f73cc716177@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-18 07:24, Austin S. Hemmelgarn wrote:
> On 2016-05-17 13:30, Josef Bacik wrote:
>> Our enospc flushing sucks.  It is born from a time where we were early
>> enospc'ing constantly because multiple threads would race in for the same
>> reservation and randomly starve other ones out.  So I came up with
>> this solution
>> to block any other reservations from happening while one guy tried to
>> flush
>> stuff to satisfy his reservation.  This gives us pretty good
>> correctness, but
>> completely crap latency.
>>
>> The solution I've come up with is ticketed reservations.  Basically we
>> try to
>> make our reservation, and if we can't we put a ticket on a list in
>> order and
>> kick off an async flusher thread.  This async flusher thread does the
>> same old
>> flushing we always did, just asynchronously.  As space is freed and
>> added back
>> to the space_info it checks and sees if we have any tickets that need
>> satisfying, and adds space to the tickets and wakes up anything we've
>> satisfied.
>>
>> Once the flusher thread stops making progress it wakes up all the current
>> tickets and tells them to take a hike.
>>
>> There is a priority list for things that can't flush, since the async
>> flusher
>> could do anything we need to avoid deadlocks.  These guys get priority
>> for
>> having their reservation made, and will still do manual flushing
>> themselves in
>> case the async flusher isn't running.
>>
>> This patch gives us significantly better latencies.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
> I've had this running on my test system (which is _finally_ working
> again) for about 16 hours now, nothing is breaking, and a number of the
> tests are actually completing marginally faster, so you can add:
>
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Hmm, this is troubling, I just did some manual testing, and hit the 
exact same warning that David did, so it looks like I need to go do some 
more thorough testing of my test system...

FWIW though, everything else does appear to be working correctly.
