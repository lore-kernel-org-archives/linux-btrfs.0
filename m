From: Tobias <tracer@robotech.de>
Subject: Re: Extreme slowdown
Date: Fri, 16 Dec 2011 09:51:56 +0100
Message-ID: <4EEB06AC.4070500@robotech.de>
References: <4EEA4124.20907@robotech.de> <4EEAA86C.4080706@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EEAA86C.4080706@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 16.12.2011 03:09, schrieb Liu Bo:
> On 12/16/2011 02:49 AM, Tobias wrote:
>> Any hints how i could speed it up?
>>
>
> I recommend to run defragment on your files,
> it should help you, although defrag maybe slow, too.
>

When deleting files does it matter if the data is fragmented?

When i do normal file-access the speed of reading is ok so until not i 
didn't care about fragmentation. Especially because the data isn't 
changes after the first write.

Can i do a defrag on the metadata only?

Tobias


