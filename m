Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34684 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbbGaEwN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 00:52:13 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55BAFEF9.1070107@cn.fujitsu.com>
Date: Fri, 31 Jul 2015 12:52:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



John Ettedgui wrote on 2015/07/30 21:09 -0700:
> On Thu, Jul 30, 2015 at 7:34 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Hi John,
>> Thanks for the trace output.
> You are welcome, thank you for looking at it!
>>
>> But it seems that, your root partition is also btrfs, causing a lot of btrfs
>> trace from your systemd journal.
>>
> Oh yes sorry about that.
> I actually have 3 partition in btrfs, the problematic one being the
> only big one.
>> Would you mind re-collecting the ftrace without such logging system caused
>> btrfs trace?
> Sure, how would I do that?
> This is my first time using ftrace.

I'm not familiar with ftrace either, but your trace is good enough 
already, the only thing needed is to avoid using btrfs as root 
partition(at least /var/).

My personal recommendation is to use a liveCD or rescue media to do the 
trace dump.

Other recommendation is to enable all btrfs trace point, and it seems 
that you have already done it while collecting the trace.
>>
>> BTW, although I'm not quite familiar with ftrace, would you please consider
>> collect ftrace with function_graph tracer?
> Sure, how would I do that one as well?
> (I'll look these up in the meantime, I just want to make sure to not
> give you something not useful again).

This LWN article should help you, as I'm not so familiar with it either.

https://lwn.net/Articles/370423/
<The function_graph tracer> paragraph.

And the graph_function is btrfs_mount.

Thanks,
Qu

>> That would help a lot to find which takes the most time.
>> But it may trace too much things and maybe hard to read.
>>
>> Thanks,
>> Qu
>
> Great, thank you!
> John
>
