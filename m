Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35372 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbcFTSOa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 14:14:30 -0400
Received: by mail-ob0-f178.google.com with SMTP id c3so907229obc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 11:14:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5767B5EE.30409@gmail.com>
References: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca>
	<CAJCQCtTcns_Oq=ku2zx_Dhm8hbfJBDzj57ybDLDZ2=fQ1W0Vow@mail.gmail.com>
	<25284905.4oL6MYjT0a@whitehead.beowulf.uwo.ca>
	<CAJCQCtQ8yPE5CSyrZ2k0ZCT6Wp5VYo9iSxe9znKv=Q04cXzODw@mail.gmail.com>
	<5767B5EE.30409@gmail.com>
Date: Mon, 20 Jun 2016 12:06:25 -0600
Message-ID: <CAJCQCtQyEkyO=ggDq_gwQpDDc-R93zFk9bqukun32xzcxXjXYQ@mail.gmail.com>
Subject: Re: Scrub aborts on newer kernels
From: Chris Murphy <lists@colorremedies.com>
To: Tyson Whitehead <twhitehead@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 3:22 AM, Tyson Whitehead <twhitehead@gmail.com> wrote:
> On 17/06/16 06:18 PM, Chris Murphy wrote:
>>
>> On Fri, Jun 17, 2016 at 8:45 AM, Tyson Whitehead <twhitehead@gmail.com>
>> wrote:
>>>
>>> On May 27, 2016 12:12:54 PM Chris Murphy wrote:
>>>>
>>>> On Thu, May 26, 2016 at 11:55 AM, Tyson Whitehead <twhitehead@gmail.com>
>>>> wrote:
>>>>>
>>>>> Under the last several kernels versions (4.6 and I believe 4.4 and,
>>>>> 4.5) btrfs scrub aborts before completing.
>>>>
>>>>
>>>> I can't reproduce this with btrfs-progs 4.5.2 and kernel 4.6.0.
>>>>
>>>> I think the bigger issue is the lack of information why a scrub is
>>>> aborted.
>>>
>>>
>>> Thanks for checking into this Chris.
>>>
>>> Any advice on how to get some more information out of the scrub process?
>>
>>
>> Next you need to find out why this one device has so many errors. Put the
>> output from smartctl -x /dev/sdb somewhere, maybe even attach it to the bug
>> report since it's somewhat related. Either that device is simply unreliable,
>> or you've got a bad cable connection.
>
>
> The device is okay.  The errors were caused by me running it for a period
> with only one of the devices present.
>
> In more detail.  My desktop has a BTRFS RAID 1 setup.  I needed to access to
> it on the road, so I just shut the desktop down, grabbed one of the drives,
> and used it in my laptop in degraded mode.
>
> When I got back I recombined them (the one I left in my office was never
> booted by itself) and started a scrub.  That is when I discovered scrub
> aborted on newer kernels but completed okay on older ones.
>
> Cheers!  -Tyson

Are you absolutely positively certain that only one of the two devices
was ever written to while mounted degraded? As in you're 100% certain,
not 99% or less certain?


-- 
Chris Murphy
