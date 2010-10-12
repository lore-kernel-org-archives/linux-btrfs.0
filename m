From: David Brown <david@westcontrol.com>
Subject: Re: converting one-disk btrfs into RAID-1?
Date: Tue, 12 Oct 2010 14:19:21 +0200
Message-ID: <i91jor$2gs$1@dough.gmane.org>
References: <4CB2FF03.8090608@wpkg.org> <m3ocb0irqj.fsf@pullcord.laptop.org> <i919v8$n91$1@dough.gmane.org> <20101012093431.GC30730@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101012093431.GC30730@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2010 11:34, Tomasz Torcz wrote:
> On Tue, Oct 12, 2010 at 11:32:07AM +0200, David Brown wrote:
>> On 11/10/2010 19:06, Chris Ball wrote:
>>> Hi,
>>>
>>>     >   Is it possible to turn a 1-disk (partition) btrfs filesystem into
>>>     >   RAID-1?
>>>
>>> Not yet, but I'm pretty sure it's on the roadmap.
>>>
>>> - Chris.
>>
>> Is it possible to view the raid levels of data and meta data for an
>> existing btrfs filesystem?  It's easy to pick them when creating the
>> system, but I couldn't find any way to view them afterwards.
>
>    "btrfs f df" will show them, except for few kernel releases when the ioctl()
> was broken.
>

I guess it's time to update my System Rescue CD to a version with the 
btrfs command rather than just btrfsctl etc.  Thanks!


