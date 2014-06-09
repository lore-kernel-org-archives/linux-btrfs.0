Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46797 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaFIQR6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jun 2014 12:17:58 -0400
Message-ID: <5395DE2E.7080700@oracle.com>
Date: Mon, 09 Jun 2014 12:17:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, jbacik@fb.com
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs: hang on boot due to tests
References: <5395CFE6.10804@oracle.com> <5395D9D6.3080101@fb.com>
In-Reply-To: <5395D9D6.3080101@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2014 11:59 AM, Chris Mason wrote:
> On 06/09/2014 11:16 AM, Sasha Levin wrote:
>> > Hi all,
>> > 
>> > It seems that some recent changes to btrfs tests make it hang during boot:
>> > 
>> > [   49.730033] NMI watchdog: BUG: soft lockup - CPU#34 stuck for 23s! [swapper/0:1]
>> > [   49.730033] Modules linked in:
>> > [   49.730033] hardirqs last enabled at (6389143): restore_args (arch/x86/kernel/entry_64.S:829)
>> > [   49.730033] hardirqs last disabled at (6389144): apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
>> > [   49.730033] softirqs last enabled at (6389142): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
>> > [   49.730033] softirqs last disabled at (6389139): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
>> > [   49.730033] CPU: 34 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #597
> 
> This is 3.15-rc8 + linux-next?  I'll try to reproduce here, but the
> tests were working for me.

Yes, it's the latest -next tree available.

Also note that it doesn't happen every time, so might be some sort of a race?


Thanks,
Sasha
