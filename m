Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34288 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbdDJMj2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 08:39:28 -0400
Received: by mail-io0-f173.google.com with SMTP id a103so28351752ioj.1
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 05:39:28 -0700 (PDT)
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
 <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
 <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
Cc: Josef Bacik <jbacik@fb.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
Date: Mon, 10 Apr 2017 08:39:23 -0400
MIME-Version: 1.0
In-Reply-To: <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-09 19:23, Hans van Kranenburg wrote:
> On 04/08/2017 01:16 PM, Hans van Kranenburg wrote:
>> On 04/07/2017 11:25 PM, Hans van Kranenburg wrote:
>>> Ok, I'm going to revive a year old mail thread here with interesting new
>>> info:
>>>
>>> [...]
>>>
>>> Now, another surprise:
>>>
>>> From the exact moment I did mount -o remount,nossd on this filesystem,
>>> the problem vanished.
>>>
>>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-07-ichiban-munin-nossd.png
>>>
>>> I don't have a new video yet, but I'll set up a cron tonight and post it
>>> later.
>>>
>>> I'm going to send another mail specifically about the nossd/ssd
>>> behaviour and other things I found out last week, but that'll probably
>>> be tomorrow.
>>
>> Well, there it is:
>>
>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4
>>
>> Amazing... :) I'll update the file later with extra frames.
>
> Added all new pngs up until now to the video, same link to the mp4.
>
> Looks great! It just keeps reusing the same spots of space all the time.
>
> When looking at this, I can understand that this is an unwanted write
> pattern on a low-end ssd that was available for sale in 2008.
>
> But, how does this apply to an SSD you can buy in 2017?
>
Depends on what brand and how cheap you go.  For a decent brand (Intel, 
Samsung, Crucial) and a reasonably good SSD (I'm partial to the Crucial 
MX series), this really don't hurt as much as it used to.

I've got a couple of Crucial MX300's (released middle of last year IIRC) 
which see roughly 200kB/s of writes constantly 24/7 (average write IOPS 
is about 15-20, so most of the writes are around 16kB), and after about 
6 months of this none of their wear-out indicators have changed since I 
first checked them when I installed them.  They've been running BTRFS 
with LZO compression, the SSD allocator, atime disabled, and mtime 
updates deferred (lazytime mount option) the whole time, so it may be a 
slightly different use case than the OP from this thread.

Given this though, combined with the fact that Crucial SSD's are decent 
(they're not quite on par with Samsung EVO's or the good Intel SSD's, 
but they're still pretty good for the price), I'd be willing to say that 
they're not anywhere near as workload sensitive as they used to be.
