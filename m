Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5992 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbbGaCet (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 22:34:49 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>, <linux-btrfs@vger.kernel.org>,
        <georgi-georgiev-btrfs@japannext.co.jp>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55BADEC4.3020409@cn.fujitsu.com>
Date: Fri, 31 Jul 2015 10:34:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



John Ettedgui wrote on 2015/07/29 18:55 +0000:
> Hello,
> I have the same issue and would like to add myself to this thread.
> My btrfs partition is about 10tb on top of lvm2 and has been taking about a minute to mount in the past few months.
>
>> Qu Wenruo <quwenruo <at>cn.fujitsu.com <http://cn.fujitsu.com>> writes:
>>
>> Quite common, especial when it grows large.
>> But it would be much better to use ftrace to show which btrfs operation
>> takes the most time.
>
>
> I have got a trace file running this command:
> trace-cmd record -e btrfs mount <PARTITION>
>
> Since it is fairly big for an email I have gzipped it.
>
> Thanks!
> John
>
Hi John,
Thanks for the trace output.

But it seems that, your root partition is also btrfs, causing a lot of 
btrfs trace from your systemd journal.

Would you mind re-collecting the ftrace without such logging system 
caused btrfs trace?

BTW, although I'm not quite familiar with ftrace, would you please 
consider collect ftrace with function_graph tracer?
That would help a lot to find which takes the most time.
But it may trace too much things and maybe hard to read.

Thanks,
Qu
