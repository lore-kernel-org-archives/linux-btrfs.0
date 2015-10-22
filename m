Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbbJVXEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 19:04:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B2CF720861
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 23:04:00 +0000 (UTC)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com [209.85.213.176])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 5D3D920854
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 23:03:58 +0000 (UTC)
Received: by igbdj2 with SMTP id dj2so5005161igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 16:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dcd25fcdebd0f4f12176cac0d49304a4@all.all>
References: <1445503918-22398-1-git-send-email-fdmanana@kernel.org>
	<5628AD20.4060900@cn.fujitsu.com>
	<CAL3q7H6GauCUEyFFVf_50B4WM-GV5nfjmquBAWR0N+O5phUUUg@mail.gmail.com>
	<CAL3q7H5UaNNjNOv+72c6ZCdkf0X9oW3Mwbgg=5tOvXBt0BRtbQ@mail.gmail.com>
	<70d472fe30931a09115ac0f4051802d1@all.all>
	<CAL3q7H688TPcDnZp4y1M8jaE3ErxXPLoy+968vri+87iLgyfKA@mail.gmail.com>
	<2d0339cab42ba3c7579b5516a885d0aa@all.all>
	<dcd25fcdebd0f4f12176cac0d49304a4@all.all>
Date: Fri, 23 Oct 2015 00:03:57 +0100
Message-ID: <CAL3q7H4tx54gGWWtXmCScZV4VEbK3kkQmxeFyMT9gp24sEqCtg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix regression when running delayed references
From: Filipe Manana <fdmanana@kernel.org>
To: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 22, 2015 at 11:38 PM, Stéphane Lesimple
<stephane_btrfs@lesimple.fr> wrote:
>>>> [ ... thread cleanup ... ]
>>>>
>>>> Don't hesitate to ask if you need me to debug or even ftrace something.
>>>
>>>
>>> Thanks Stéphane. I haven't seen that crash yet (still running tests
>>> for 2 consecutive days now).
>>> Can you please try the following patch, which works on top of mine,
>>> and enable ftrace before running balance:
>>>
>>> Debug patch:  https://friendpaste.com/5s3dItRpcpq3dH1E4KUJor
>>>
>>> Enable ftrace:
>>>
>>>     $ echo > /sys/kernel/debug/tracing/trace
>>>     $ echo "nop" > /sys/kernel/debug/tracing/current_tracer
>>>     $ echo 100000 > /sys/kernel/debug/tracing/buffer_size_kb   # if
>>> you can use larger buffer size, even better
>>>     $ echo > /sys/kernel/debug/tracing/set_ftrace_filter
>>>     $ echo 1 > /sys/kernel/debug/tracing/tracing_on
>>>
>>>     $ run balance... wait until it finishes with IO error or the
>>> patch's printk message shows up in dmesg/syslog
>>>
>>>     $ echo 0 > /sys/kernel/debug/tracing/tracing_on
>>>
>>>     $ cat /sys/kernel/debug/tracing/trace > some_file.txt
>>>
>>> Then send is some_file.txt for debugging, hopefully it will give some
>>> useful information. Note that it might produce tons of messages,
>>> depending on how long it takes for you to hit the BUG_ON.
>>>
>>> Thanks a lot for this.
>>
>>
>> I'm compiling it now (using your v2 of the friendpaste diff).
>>
>> I took the liberty to add a tracing_off() right before the return -EIO
>> so that the trace tail ends exactly at the right place.
>>
>> Last time I tried to use ftrace to diagnose the bug we're trying to
>> fix, the system crashes so hard that usually it's complicated to get
>> the trace contents written somewhere before the system is unusable.
>> But I'll eventually work around it by using
>> /sys/kernel/debug/tracing/trace_pipe to send the trace live to another
>> machine over the LAN.
>>
>> This series of bugs are so easy to trigger on my system that we'll
>> hopefully get something useful out of the trace. I guess that's a good
>> thing !
>
>
> So, this time it took a little over an hour to get the crash, but it did
> reach the -EIO condition eventually.
> The ftrace log (2M gzipped) is available here :
> http://www.speed47.net/tmp2/btrfs-4.3rc6p7463161-ftrace1.log.gz
>
> The associated kernel log is as follows :
>
> [ 2880.178589] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 2880.178600]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 2880.178603] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 3088.829429] Out of memory: Kill process 9449 (df-complex2simp) score 246
> or sacrifice child
> [ 3088.829435] Killed process 9449 (df-complex2simp) total-vm:964732kB,
> anon-rss:943764kB, file-rss:0kB
> [ 3600.197642] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 3600.197657]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 3600.197660] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 3840.204146] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 3840.204180]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 3840.204219] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 3993.671982] Out of memory: Kill process 11357 (df-complex2simp) score 227
> or sacrifice child
> [ 3993.671989] Killed process 11357 (df-complex2simp) total-vm:891608kB,
> anon-rss:870704kB, file-rss:60kB
> [ 4080.210324] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 4080.210336]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 4080.210339] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 4320.215635] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 4320.215662]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 4320.215667] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 4560.221119] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 4560.221146]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 4560.221148] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 4800.226884] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 4800.226898]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 4800.226902] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 4890.116131] Out of memory: Kill process 13377 (df-complex2simp) score 207
> or sacrifice child
> [ 4890.116138] Killed process 13377 (df-complex2simp) total-vm:834976kB,
> anon-rss:793272kB, file-rss:48kB
> [ 5785.793580] Out of memory: Kill process 15285 (df-complex2simp) score 201
> or sacrifice child
> [ 5785.793586] Killed process 15285 (df-complex2simp) total-vm:802208kB,
> anon-rss:772172kB, file-rss:4kB
> [ 6480.269728] INFO: task btrfs-transacti:7358 blocked for more than 120
> seconds.
> [ 6480.269738]       Not tainted 4.3.0-rc6p7463161+ #3
> [ 6480.269740] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 7081.967354] BTRFS: here, ref_mod != 1, bytenr 12090260504576, ref_mod 2,
> seq 0 action 1
> [ 7081.967784] BTRFS: error (device dm-3) in btrfs_run_delayed_refs:2872:
> errno=-5 IO failure
>
> The OOM conditions are unrelated, this is an rrdtool cron script that
> apparently takes too much memory from time to time, I'll disable it for
> further tests to get noise out of the way.
>
> If I can be of some more help, just ask.

That's great Stéphane.
I'll take a look tomorrow morning at the logs and then get back to you.

Thanks a lot for that.

>
> Thanks,
>
> --
> Stéphane.
>
