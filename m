Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:41194 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751031AbdLAVvE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 16:51:04 -0500
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
 <pan$6609d$15863533$48f08c08$b3eb21f1@cox.net>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <113cba02-2557-d1e8-193f-fab4437f1199@techsquare.com>
Date: Fri, 1 Dec 2017 16:50:59 -0500
MIME-Version: 1.0
In-Reply-To: <pan$6609d$15863533$48f08c08$b3eb21f1@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: btrfs-transacti hammering the system
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well, it's at zero now...

# btrfs fi df /export/
Data, single: total=30.45TiB, used=30.25TiB
System, DUP: total=32.00MiB, used=3.62MiB
Metadata, DUP: total=66.50GiB, used=65.16GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


On 01/12/17 16:47, Duncan wrote:
> Hans van Kranenburg posted on Fri, 01 Dec 2017 18:06:23 +0100 as
> excerpted:
> 
>> On 12/01/2017 05:31 PM, Matt McKinnon wrote:
>>> Sorry, I missed your in-line reply:
>>>
>>>
>>>> 2) How big is this filesystem? What does your `btrfs fi df
>>>> /mountpoint` say?
>>>>
>>>
>>> # btrfs fi df /export/
>>> Data, single: total=30.45TiB, used=30.25TiB
>>> System, DUP: total=32.00MiB, used=3.62MiB
>>> Metadata, DUP: total=66.50GiB, used=65.08GiB
>>> GlobalReserve, single: total=512.00MiB, used=53.69MiB
>>
>> Multi-TiB filesystem, check. total/used ratio looks healthy.
> 
> Not so healthy, from here.  Data/metadata are healthy, yes,
> but...
> 
> Any usage at all of global reserve is a red flag indicating that
> something in the filesystem thinks, or thought when it resorted
> to global reserve, that space is running out.
> 
> Global reserve usage doesn't really hint what the problem is,
> but it's definitely a red flag that there /is/ a problem, and
> it's easily overlooked, as it apparently was here.
> 
> It's likely indication of a bug, possibly one of the ones fixed
> right around 4.12/4.13.  I'll let the devs and better experts take
> it from there, but I'd certainly be worried until global reserve
> drops to zero usage.
> 
