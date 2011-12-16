From: Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: Extreme slowdown
Date: Fri, 16 Dec 2011 09:45:19 +0530
Message-ID: <4EEAC5D7.80707@gmail.com>
References: <4EEA4124.20907@robotech.de> <CAG1y0sd1+kVcgXFPc-x9qFX03ix=4FLuhOniJyqGw-7=3wczug@mail.gmail.com> <CAAE6i0jL=mD=HU0GtfpJPLu__7NtV6WAuGb25CAWtV6N4f33wQ@mail.gmail.com>
Reply-To: nspmangalore@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: "Fajar A. Nugraha" <list@fajar.net>, Tobias <tracer@robotech.de>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0jL=mD=HU0GtfpJPLu__7NtV6WAuGb25CAWtV6N4f33wQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2011 09:14 AM, Chester wrote:
> On Thu, Dec 15, 2011 at 8:19 PM, Fajar A. Nugraha<list@fajar.net>  wrote:
>> On Fri, Dec 16, 2011 at 1:49 AM, Tobias<tracer@robotech.de>  wrote:
>>> Hi all!
>>>
>>> My BTRFS-FS ist getting really slow. Reading is ok, writing is slow and
>>> deleting is horrible slow.
>>>
>>> There are many files and many links on the FS.
>>>
>>> # btrfs filesystem df /srv/storage
>>> Data: total=3.09TB, used=3.07TB
>> this is ... what, over 99% full?
>> The slow down is normal, somewhat. Same thing happens on zfs, which
>> became slower when usage is above 80-90%.
> I don't think "total" actually means "total space available" it
> increases as you use up more space.
>>> Maybe it's because there is so much Metadata and it needs so many seeks on
>>> the discs when deleting?
>> I doubt it.
>>
>>> I'd like to delete some of the old Files but its so horrible slow that i
>>> think its maybe faster to copy all needed Data to a different Disc, killing
>>> the FS and move the Files back...
>>>
>>> The machine is a QuadCore with 8GB RAM. Kernel is "3.1+for-linus".
>>>
>>> Any hints how i could speed it up?
>> Try:
>> - mounting it with nodatacow:
>> https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html#Can_copy-on-write_be_turned_off_for_data_blocks.3F
>> - clobbering a big file:
>> https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html#if_your_device_is_large_.28.3E16gb.29
>>
>> ... until you have at least 20% free space available.
>>
>> --
>> Fajar
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Wouldn't it be more valuable to first collect enough info/data to debug 
the problem, before suggesting ways to get out of this situation?

AFAIK, the slowness could be due to several reasons:
1. Slow disk writes.
2. Too many things to commit to the disk.
3. Too many things to do to actually accomplish the writes.
4. Important threads suspending due to lack of resources.
5. Something else which I've missed above.

Is there some sort of profiling which we can enable, which can give us 
info about the speeds and quantities of read and write traffic on the fs?
Aren't there btrfs statistics that we can print out, which can give us 
these info? If not, we probably should think about adding some.

P.S: btrfs n00b talking!

Regards,
Shyam
