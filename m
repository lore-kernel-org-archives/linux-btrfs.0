Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41814 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120AbbGaFkO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 01:40:14 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
 <55BAFEF9.1070107@cn.fujitsu.com>
 <CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55BB0A39.1050208@cn.fujitsu.com>
Date: Fri, 31 Jul 2015 13:40:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



John Ettedgui wrote on 2015/07/30 22:15 -0700:
> On Thu, Jul 30, 2015 at 9:52 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> I'm not familiar with ftrace either, but your trace is good enough already,
>> the only thing needed is to avoid using btrfs as root partition(at least
>> /var/).
> I've stopped all journaling services for now, I hope that's enough/
>>
>> My personal recommendation is to use a liveCD or rescue media to do the
>> trace dump.
>>
> If not I'll have to do that, but this computer has no CD drive.
It seems that you're using Chromium while doing the dump. :)

If no CD drive, I'll recommend to use Archlinux installation iso to make 
a bootable USB stick and do the dump.
(just download and dd would do the trick)
As its kernel and tools is much newer than most distribution.

It's better to provide two trace.
One is the function tracer one, with "btrfs:*" as set_event.
The other is the function_graph one. with "btrfs_mount" as 
set_graph_function.

Thanks for your patient to help improving btrfs.
Although I may not be able to check the trace until next Monday... :(

Thanks,
Qu

>> Other recommendation is to enable all btrfs trace point, and it seems that
>> you have already done it while collecting the trace.
>>>>
>> This LWN article should help you, as I'm not so familiar with it either.
>>
>> https://lwn.net/Articles/370423/
>> <The function_graph tracer> paragraph.
>>
>> And the graph_function is btrfs_mount.
> That actually helped a lot!
> I've been trying to get it working since I sent the previous email,
> but never realized I needed the supply the function and that's
> probably it never worked (or used too much space before crashing)
>>
>> Thanks,
>> Qu
>>
> I hope this is better.
>
> John
>
