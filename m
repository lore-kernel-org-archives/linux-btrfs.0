Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:45041 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750929AbbJWOfu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 10:35:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 23 Oct 2015 16:35:47 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix regression when running delayed references
In-Reply-To: <a7ecfd0bc1159d211a6ed3c5731bf229@all.all>
References: <1445503918-22398-1-git-send-email-fdmanana@kernel.org>
 <5628AD20.4060900@cn.fujitsu.com>
 <CAL3q7H6GauCUEyFFVf_50B4WM-GV5nfjmquBAWR0N+O5phUUUg@mail.gmail.com>
 <CAL3q7H5UaNNjNOv+72c6ZCdkf0X9oW3Mwbgg=5tOvXBt0BRtbQ@mail.gmail.com>
 <70d472fe30931a09115ac0f4051802d1@all.all>
 <CAL3q7H688TPcDnZp4y1M8jaE3ErxXPLoy+968vri+87iLgyfKA@mail.gmail.com>
 <2d0339cab42ba3c7579b5516a885d0aa@all.all>
 <dcd25fcdebd0f4f12176cac0d49304a4@all.all>
 <CAL3q7H4tx54gGWWtXmCScZV4VEbK3kkQmxeFyMT9gp24sEqCtg@mail.gmail.com>
 <CAL3q7H4YCPvxd4S2iuzbsGA8q+Jeon3auMVyos2saFoTiFc7Ag@mail.gmail.com>
 <a7ecfd0bc1159d211a6ed3c5731bf229@all.all>
Message-ID: <4f45136d52f3ae0249ecf985416263cd@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-10-23 12:59, Stéphane Lesimple a écrit :
> Le 2015-10-23 12:11, Filipe Manana a écrit :
>> On Fri, Oct 23, 2015 at 12:03 AM, Filipe Manana <fdmanana@kernel.org> 
>> wrote:
>>> On Thu, Oct 22, 2015 at 11:38 PM, Stéphane Lesimple
>>> <stephane_btrfs@lesimple.fr> wrote:
>>>>>>> [ ... thread cleanup ... ]
>>>>>>> 
>>>>>>> Don't hesitate to ask if you need me to debug or even ftrace 
>>>>>>> something.
>>>>>> 
>>>>>> 
>>>>>> Thanks Stéphane. I haven't seen that crash yet (still running 
>>>>>> tests
>>>>>> for 2 consecutive days now).
>>>>>> Can you please try the following patch, which works on top of 
>>>>>> mine,
>>>>>> and enable ftrace before running balance:
>>>>>> 
>>>>>> Debug patch:  https://friendpaste.com/5s3dItRpcpq3dH1E4KUJor
>>>>>> 
>>>>>> Enable ftrace:
>>>>>> 
>>>>>>     $ echo > /sys/kernel/debug/tracing/trace
>>>>>>     $ echo "nop" > /sys/kernel/debug/tracing/current_tracer
>>>>>>     $ echo 100000 > /sys/kernel/debug/tracing/buffer_size_kb   # 
>>>>>> if
>>>>>> you can use larger buffer size, even better
>>>>>>     $ echo > /sys/kernel/debug/tracing/set_ftrace_filter
>>>>>>     $ echo 1 > /sys/kernel/debug/tracing/tracing_on
>>>>>> 
>>>>>>     $ run balance... wait until it finishes with IO error or the
>>>>>> patch's printk message shows up in dmesg/syslog
>>>>>> 
>>>>>>     $ echo 0 > /sys/kernel/debug/tracing/tracing_on
>>>>>> 
>>>>>>     $ cat /sys/kernel/debug/tracing/trace > some_file.txt
>>>>>> 
>>>>>> Then send is some_file.txt for debugging, hopefully it will give 
>>>>>> some
>>>>>> useful information. Note that it might produce tons of messages,
>>>>>> depending on how long it takes for you to hit the BUG_ON.
>>>>>> 
>>>>>> Thanks a lot for this.
>>>>> 
>>>>> 
>>>>> I'm compiling it now (using your v2 of the friendpaste diff).
>>>>> 
>>>>> I took the liberty to add a tracing_off() right before the return 
>>>>> -EIO
>>>>> so that the trace tail ends exactly at the right place.
>>>>> 
>>>>> Last time I tried to use ftrace to diagnose the bug we're trying to
>>>>> fix, the system crashes so hard that usually it's complicated to 
>>>>> get
>>>>> the trace contents written somewhere before the system is unusable.
>>>>> But I'll eventually work around it by using
>>>>> /sys/kernel/debug/tracing/trace_pipe to send the trace live to 
>>>>> another
>>>>> machine over the LAN.
>>>>> 
>>>>> This series of bugs are so easy to trigger on my system that we'll
>>>>> hopefully get something useful out of the trace. I guess that's a 
>>>>> good
>>>>> thing !
>>>> 
>>>> 
>>>> So, this time it took a little over an hour to get the crash, but it 
>>>> did
>>>> reach the -EIO condition eventually.
>>>> The ftrace log (2M gzipped) is available here :
>>>> http://www.speed47.net/tmp2/btrfs-4.3rc6p7463161-ftrace1.log.gz
>>>> 
>>>> The associated kernel log is as follows :
>>>> 
>>>> [ 2880.178589] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 2880.178600]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 2880.178603] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 3088.829429] Out of memory: Kill process 9449 (df-complex2simp) 
>>>> score 246
>>>> or sacrifice child
>>>> [ 3088.829435] Killed process 9449 (df-complex2simp) 
>>>> total-vm:964732kB,
>>>> anon-rss:943764kB, file-rss:0kB
>>>> [ 3600.197642] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 3600.197657]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 3600.197660] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 3840.204146] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 3840.204180]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 3840.204219] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 3993.671982] Out of memory: Kill process 11357 (df-complex2simp) 
>>>> score 227
>>>> or sacrifice child
>>>> [ 3993.671989] Killed process 11357 (df-complex2simp) 
>>>> total-vm:891608kB,
>>>> anon-rss:870704kB, file-rss:60kB
>>>> [ 4080.210324] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 4080.210336]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 4080.210339] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 4320.215635] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 4320.215662]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 4320.215667] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 4560.221119] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 4560.221146]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 4560.221148] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 4800.226884] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 4800.226898]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 4800.226902] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 4890.116131] Out of memory: Kill process 13377 (df-complex2simp) 
>>>> score 207
>>>> or sacrifice child
>>>> [ 4890.116138] Killed process 13377 (df-complex2simp) 
>>>> total-vm:834976kB,
>>>> anon-rss:793272kB, file-rss:48kB
>>>> [ 5785.793580] Out of memory: Kill process 15285 (df-complex2simp) 
>>>> score 201
>>>> or sacrifice child
>>>> [ 5785.793586] Killed process 15285 (df-complex2simp) 
>>>> total-vm:802208kB,
>>>> anon-rss:772172kB, file-rss:4kB
>>>> [ 6480.269728] INFO: task btrfs-transacti:7358 blocked for more than 
>>>> 120
>>>> seconds.
>>>> [ 6480.269738]       Not tainted 4.3.0-rc6p7463161+ #3
>>>> [ 6480.269740] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
>>>> disables
>>>> this message.
>>>> [ 7081.967354] BTRFS: here, ref_mod != 1, bytenr 12090260504576, 
>>>> ref_mod 2,
>>>> seq 0 action 1
>>>> [ 7081.967784] BTRFS: error (device dm-3) in 
>>>> btrfs_run_delayed_refs:2872:
>>>> errno=-5 IO failure
>>>> 
>>>> The OOM conditions are unrelated, this is an rrdtool cron script 
>>>> that
>>>> apparently takes too much memory from time to time, I'll disable it 
>>>> for
>>>> further tests to get noise out of the way.
>>>> 
>>>> If I can be of some more help, just ask.
>>> 
>>> That's great Stéphane.
>>> I'll take a look tomorrow morning at the logs and then get back to 
>>> you.
>>> 
>>> Thanks a lot for that.
>> 
>> Stéphane, can you do the balance again but with the following new 
>> debug patch:
>> 
>> https://friendpaste.com/3NXzDFGcK4Hxi0yiypMgRO
>> 
>> (I added your tracing_off(); call)
>> 
>> It applies on top of my fix.
>> Also, are you by chance using qgroups (btrfs quotas)? If you are I
>> think I know what's the problem, but either way please run with this
>> new debug patch, so that I can confirm my ideas.
> 
> I am indeed using qgroups (use case for me is to be able to tell how
> much real space are taking snapshots).
> 
> I'm applying your patch and resuming the balance, will keep you posted 
> as usual!
> 
>> Many thanks, much appreciated!
> 
> And thanks for taking the time to look into this :)

Okay, the system crashed as expected but after ~30 minutes this time. 
I'm lucky on this run because the NMI watchdog successfully kicked in, 
panicked the kernel nicely and autorebooted without physical 
intervention :)

The kernel log is as follows :

[ 1537.855455] BTRFS: here, ref_mod != 1, bytenr 12089671335936, ref_mod 
2, seq 0 action 1
[ 1537.855591] BTRFS: error (device dm-3) in 
btrfs_run_delayed_refs:2877: errno=-5 IO failure
[ 1561.908656] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! 
[btrfs:6297]
[ 1561.909839] Kernel panic - not syncing: softlockup: hung tasks
[ 1561.909861] CPU: 1 PID: 6297 Comm: btrfs Tainted: G        W    L  
4.3.0-rc6p7463161+ #3
[ 1561.909883] Hardware name: ASUS All Series/H87I-PLUS, BIOS 1005 
01/06/2014
[ 1561.909903]  ffff8800b49ddb00 ffff88011fb03e30 ffffffff813a12cd 
ffffffff81ac0dfa
[ 1561.909930]  ffff88011fb03ea8 ffffffff811753fe 0000000000000008 
ffff88011fb03eb8
[ 1561.909955]  ffff88011fb03e58 ffff88011fb03e98 0000000000000000 
0000000000000100
[ 1561.909982] Call Trace:
[ 1561.909990]  <IRQ>  [<ffffffff813a12cd>] dump_stack+0x44/0x57
[ 1561.910011]  [<ffffffff811753fe>] panic+0xc8/0x205
[ 1561.910027]  [<ffffffff8112931b>] watchdog_timer_fn+0x1db/0x1f0
[ 1561.910044]  [<ffffffff81129140>] ? watchdog+0x40/0x40
[ 1561.910062]  [<ffffffff810e2394>] __hrtimer_run_queues+0xe4/0x200
[ 1561.910080]  [<ffffffff810e27c8>] hrtimer_interrupt+0xa8/0x1a0
[ 1561.910099]  [<ffffffff8104e105>] 
local_apic_timer_interrupt+0x35/0x60
[ 1561.910118]  [<ffffffff817ae5fd>] smp_apic_timer_interrupt+0x3d/0x60
[ 1561.910136]  [<ffffffff817ac462>] apic_timer_interrupt+0x82/0x90
[ 1561.910153]  <EOI>  [<ffffffffc090e2f0>] ? 
__del_reloc_root+0xd0/0x100 [btrfs]
[ 1561.910187]  [<ffffffffc090e276>] ? __del_reloc_root+0x56/0x100 
[btrfs]
[ 1561.910211]  [<ffffffffc090e250>] ? __del_reloc_root+0x30/0x100 
[btrfs]
[ 1561.910235]  [<ffffffffc090e341>] free_reloc_roots+0x21/0x30 [btrfs]
[ 1561.910257]  [<ffffffffc091190a>] merge_reloc_roots+0x16a/0x230 
[btrfs]
[ 1561.910280]  [<ffffffffc0911dc5>] relocate_block_group+0x3f5/0x610 
[btrfs]
[ 1561.910304]  [<ffffffffc0912185>] 
btrfs_relocate_block_group+0x1a5/0x290 [btrfs]
[ 1561.910330]  [<ffffffffc08e8217>] 
btrfs_relocate_chunk.isra.36+0x47/0xd0 [btrfs]
[ 1561.910356]  [<ffffffffc08e99a0>] btrfs_balance+0x7d0/0xea0 [btrfs]
[ 1561.910379]  [<ffffffffc08f58de>] btrfs_ioctl_balance+0x17e/0x540 
[btrfs]
[ 1561.910404]  [<ffffffffc08f80a7>] btrfs_ioctl+0x567/0x2440 [btrfs]
[ 1561.910422]  [<ffffffff81186637>] ? 
lru_cache_add_active_or_unevictable+0x27/0x90
[ 1561.910443]  [<ffffffff811a6850>] ? handle_mm_fault+0xb90/0x17d0
[ 1561.910461]  [<ffffffff811aa929>] ? vma_link+0xb9/0xc0
[ 1561.910476]  [<ffffffff8120192d>] do_vfs_ioctl+0x2cd/0x4b0
[ 1561.910492]  [<ffffffff81064797>] ? __do_page_fault+0x1b7/0x430
[ 1561.910509]  [<ffffffff81201b89>] SyS_ioctl+0x79/0x90
[ 1561.910524]  [<ffffffff817ab6f6>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 1561.910554] Kernel Offset: disabled
[ 1561.917367] Rebooting in 5 seconds..
[ 1566.951784] ACPI MEMORY or I/O RESET_REG.

The gzipped ftrace log is less that 4M and available here : 
http://www.speed47.net/tmp2/btrfs-4.3rc6p7463161-ftrace2.log.gz

Thanks,

-- 
Stéphane.



