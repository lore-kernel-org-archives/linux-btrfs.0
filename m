Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:51046 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbeA2Vyt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 16:54:49 -0500
Reply-To: waxhead@dirtcellar.net
Subject: Re: degraded permanent mount option
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <dd2863d2-6f50-47b4-06a9-f34e7b341f2f@gmail.com>
 <f97f4e60-47fb-f1d6-dc09-0b46638a9eb4@gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <f8f72b3e-e0c0-cccb-a52a-8c8568e103ba@dirtcellar.net>
Date: Mon, 29 Jan 2018 22:54:46 +0100
MIME-Version: 1.0
In-Reply-To: <f97f4e60-47fb-f1d6-dc09-0b46638a9eb4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Austin S. Hemmelgarn wrote:
> On 2018-01-29 12:58, Andrei Borzenkov wrote:
>> 29.01.2018 14:24, Adam Borowski пишет:
>> ...
>>>
>>> So any event (the user's request) has already happened.  A rc system, of
>>> which systemd is one, knows whether we reached the "want root 
>>> filesystem" or
>>> "want secondary filesystems" stage.  Once you're there, you can issue 
>>> the
>>> mount() call and let the kernel do the work.
>>>
>>>> It is a btrfs choice to not expose compound device as separate one 
>>>> (like
>>>> every other device manager does)
>>>
>>> Btrfs is not a device manager, it's a filesystem.
>>>
>>>> it is a btrfs drawback that doesn't provice anything else except for 
>>>> this
>>>> IOCTL with it's logic
>>>
>>> How can it provide you with something it doesn't yet have?  If you 
>>> want the
>>> information, call mount().  And as others in this thread have mentioned,
>>> what, pray tell, would you want to know "would a mount succeed?" for 
>>> if you
>>> don't want to mount?
>>>
>>>> it is a btrfs drawback that there is nothing to push assembling into 
>>>> "OK,
>>>> going degraded" state
>>>
>>> The way to do so is to timeout, then retry with -o degraded.
>>>
>>
>> That's possible way to solve it. This likely requires support from
>> mount.btrfs (or btrfs.ko) to return proper indication that filesystem is
>> incomplete so caller can decide whether to retry or to try degraded 
>> mount.
> We already do so in the accepted standard manner.  If the mount fails 
> because of a missing device, you get a very specific message in the 
> kernel log about it, as is the case for most other common errors (for 
> uncommon ones you usually just get a generic open_ctree error).  This is 
> really the only option too, as the mount() syscall (which the mount 
> command calls) returns only 0 on success or -1 and an appropriate errno 
> value on failure, and we can't exactly go about creating a half dozen 
> new error numbers just for this (well, technically we could, but I very 
> much doubt that they would be accepted upstream, which defeats the 
> purpose).
>>
>> Or may be mount.btrfs should implement this logic internally. This would
>> really be the most simple way to make it acceptable to the other side by
>> not needing to accept anything :)
> And would also be another layering violation which would require a 
> proliferation of extra mount options to control the mount command itself 
> and adjust the timeout handling.
> 
> This has been done before with mount.nfs, but for slightly different 
> reasons (primarily to allow nested NFS mounts, since the local directory 
> that the filesystem is being mounted on not being present is treated 
> like a mount timeout), and it had near zero control.  It works there 
> because they push the complicated policy decisions to userspace (namely, 
> there is no support for retrying with different options or trying a 
> different server).
> 
I just felt like commenting a bit on this from a regular users point of 
view.

Remember that at some point BTRFS will probably be the default 
filesystem for the average penguin.
BTRFS big selling point is redundance and a guarantee that whatever you 
write is the same that you will read sometime later.

Many users will probably build their BTRFS system on a redundant array 
of storage devices. As long as there are sufficient (not necessarily 
all) storage devices present they expect their system to come up and 
work. If the system is not able to come up in a fully operative state it 
must at least be able to limp until the issue is fixed.

Starting a argument about what init system is the most sane or most 
shiny is not helping. The truth is that systemd is not going away 
sometime soon and one might as well try to become friends if nothing 
else for the sake of having things working which should be a common goal 
regardless of the religion.

I personally think the degraded mount option is a mistake as this 
assumes that a lightly degraded system is not able to work which is false.
If the system can mount to some working state then it should mount 
regardless if it is fully operative or not. If the array is in a bad 
state you need to learn about it by issuing a command or something. The 
same goes for a MD array (and yes, I am aware of the block layer vs 
filesystem thing here).
