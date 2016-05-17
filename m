Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38226 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbcEQLcP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 07:32:15 -0400
Received: by mail-ig0-f174.google.com with SMTP id m9so7942482ige.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 04:32:15 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: Ferry Toth <ftoth@exalondelft.nl>, linux-btrfs@vger.kernel.org
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
Date: Tue, 17 May 2016 07:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <nhedk2$dpq$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-17 02:27, Ferry Toth wrote:
> Op Mon, 16 May 2016 01:05:24 +0200, schreef Kai Krakow:
>
>> Am Sun, 15 May 2016 21:11:11 +0000 (UTC)
>> schrieb Duncan <1i5t5.duncan@cox.net>:
>>
>>> Ferry Toth posted on Sun, 15 May 2016 12:12:09 +0000 as excerpted:
>>>
> <snip>
>>
>> You can go there with only one additional HDD as temporary storage. Just
>> connect it, format as bcache, then do a "btrfs dev replace". Now wipe
>> that "free" HDD (use wipefs), format as bcache, then... well, you get
>> the point. At the last step, remove the remaining HDD. Now add your
>> SSDs, format as caching device, and attach each individual HDD backing
>> bcache to each SSD caching bcache.
>>
>> Devices don't need to be formatted and created at the same time. I'd
>> also recommend to add all SSDs only in the last step to not wear them
>> early with writes during device replacement.
>>
>> If you want, you can add one additional step to get the temporary hard
>> disk back. But why not simply replace the oldest hard disk with the
>> newest. Take a look at smartctl to see which is the best candidate.
>>
>> I went a similar route but without one extra HDD. I had three HDDs in
>> mraid1/draid0 and enough spare space. I just removed one HDD, prepared
>> it for bcache, then added it back and removed the next.
>>
> That's what I mean, a lot of work. And it's still a cache, with
> unnecessary copying from the ssd to the hdd.
On the other hand, it's actually possible to do this all online with 
BTRFS because of the reshaping and device replacement tools.

In fact, I've done even more complex reprovisioning online before (for 
example, my home server system has 2 SSD's and 4 HDD's, running BTRFS on 
top of LVM, I've at least twice completely recreated the LVM layer 
online without any data loss and minimal performance degradation).
>
> And what happens when either a hdd or ssd starts failing?
I have absolutely no idea how bcache handles this, but I doubt it's any 
better than BTRFS.
