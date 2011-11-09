From: dima <dolenin@parallels.com>
Subject: Re: How to remount btrfs without compression?
Date: Wed, 9 Nov 2011 10:01:13 +0900
Message-ID: <4EB9D0D9.1000009@parallels.com>
References: <4EB72C1B.1030702@parallels.com> <201111071319.14493.Martin@lichtvoll.de> <4EB87E01.1040704@parallels.com> <4EB880A0.1030304@gmail.com> <CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com> <4EB88BC9.7020509@gmail.com> <4EB88D4A.5050908@parallels.com> <20111108150151.GA4954@shiny> <20111108151208.GB4954@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111108151208.GB4954@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/09/2011 12:12 AM, Chris Mason wrote:
> On Tue, Nov 08, 2011 at 10:01:51AM -0500, Chris Mason wrote:
>> On Tue, Nov 08, 2011 at 11:00:42AM +0900, dima wrote:
>>> On 11/08/2011 10:54 AM, Eric Griffith wrote:
>>>> On 11/7/2011 8:52 PM, Fajar A. Nugraha wrote:
>>>>> On Tue, Nov 8, 2011 at 8:06 AM, Eric Griffith<egriffith92@gmail.com>
>>>>> wrote:
>>>>>> Edit your
>>>>>> fstab, remove the compress flag, reboot. Tell btrfs to rebalance the
>>>>>> system,
>>>>>> reboot again. And I -THINK- that'll decompress all the files
>>>>>
>>>>> I think the original question was how to force uncompressed mode,
>>>>> whether specific to a file or to a whole filesystem, without having to
>>>>> reboot :)
>>>>>
>>>>> AFAIK there's no way to do that.
>>>>>
>>>>
>>>> Whoops! Misunderstood the question haha. Yeah, as far as decompressing
>>>> just a single file; from what I've read, thats impossible.
>>>
>>>
>>> Eric, Fajar,
>>> Thanks. Understood.
>>>
>>> Yes, it is possible to remove the compress flag from fstab, reboot
>>> and even do not do any defragmentation/rebalancing - just re-save
>>> the file and it will be saved uncompressed. This works. But only
>>> with reboot...
>>
>> chattr -c on the file should work (followed by defrag or rewriting the
>> file).  I just retested and it seems to be broken right now.
>>
>> I'll track it down.
>
> Ok, I had forgotten.  chattr -c clears the compression flag bug doesn't
> set the no compress flag.  We looks like we need to patch chattr for
> this.
>
> -chris
>


Just for the record - I could find a solution thanks to the btrfs wiki 
being online again. In Gotchas it says

mount -o nodatacow also disables compression

and indeed it does. Remounting with this option and re-saving the file 
makes it uncompressed. However, I could not find how to remount the 
filesystem afterwards without nodatacow.

~dima
