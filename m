Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55633 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaFKXO6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 19:14:58 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <3216820.JOp565CquS@grover>
References: <5395CFE6.10804@oracle.com>
	<5395D9D6.3080101@fb.com>
	<5395DE2E.7080700@oracle.com>
	<3216820.JOp565CquS@grover>
Date: Thu, 12 Jun 2014 00:14:56 +0100
Message-ID: <CAL3q7H66cWoE0LzHZQ4bQV4h_WrnvXZ6sABjhtWfr6Ktuo8pFQ@mail.gmail.com>
Subject: Re: btrfs: hang on boot due to tests
From: Filipe David Manana <fdmanana@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Sasha Levin <sasha.levin@oracle.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 10, 2014 at 12:14 PM, Ed Tomlinson <edt@aei.ca> wrote:
> On Monday 09 June 2014 12:17:50 Sasha Levin wrote:
>> On 06/09/2014 11:59 AM, Chris Mason wrote:
>> > On 06/09/2014 11:16 AM, Sasha Levin wrote:
>> >> > Hi all,
>> >> >
>> >> > It seems that some recent changes to btrfs tests make it hang during boot:
>> >> >
>> >> > [   49.730033] NMI watchdog: BUG: soft lockup - CPU#34 stuck for 23s! [swapper/0:1]
>> >> > [   49.730033] Modules linked in:
>> >> > [   49.730033] hardirqs last enabled at (6389143): restore_args (arch/x86/kernel/entry_64.S:829)
>> >> > [   49.730033] hardirqs last disabled at (6389144): apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
>> >> > [   49.730033] softirqs last enabled at (6389142): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
>> >> > [   49.730033] softirqs last disabled at (6389139): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
>> >> > [   49.730033] CPU: 34 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #597
>> >
>> > This is 3.15-rc8 + linux-next?  I'll try to reproduce here, but the
>> > tests were working for me.
>>
>> Yes, it's the latest -next tree available.
>>
>> Also note that it doesn't happen every time, so might be some sort of a race?
>
> I've noticed that with -rc8 and now .15 btrfs fails to automount (or mount) about 1 in 2 times requiring a reboot to get it to work.
> I have not seen anything in logs.  Might this be related?

Hi Ed,

I think I ran into this too.
This patch should help you too:  https://patchwork.kernel.org/patch/4338641/

thanks

>
> Thanks,
>
> Ed Tomlinson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
