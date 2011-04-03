From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs balancing start - and stop?
Date: 03 Apr 2011 21:35:00 +0200
Message-ID: <Bj8nJL4D1uB@helmut.hullen.de>
References: <20110403185341.GA11024@yahoo.fr>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110403185341.GA11024@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Stephane,

Du meintest am 03.04.11:

>>>> balancing about 2 TByte needed about 20 hours.

[...]

>> Hugo has explained the limits of regarding
>>
>>         dmesg | grep relocating
>>
>> or (more simple) the last lines of "dmesg" and looking for the
>> "relocating" lines. But: what do these lines tell now? What is the
>> (pessimistic) estimation when you extrapolate the data?

[...]

> 4.7 more days to go. And I reckon it will have written about 9
> TB to disk by that time (which is the total size of the volume,
> though only 3.8TB are occupied).

Yes - that's the pessimistic estimation. As Hugo has explained it can  
finish faster - just look to the data tomorrow again.

Viele Gruesse!
Helmut
