Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37387 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755100AbcK3RSV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 12:18:21 -0500
Received: from svh-gw.merlins.org ([173.11.111.145]:39718 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1cC8WN-0004nT-0a
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 09:18:20 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1cC8WM-00085j-G5
        for linux-btrfs@vger.kernel.org; Wed, 30 Nov 2016 09:18:14 -0800
Date: Wed, 30 Nov 2016 09:18:14 -0800
From: Marc MERLIN <marc@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20161130171814.3yrqzzoocg3kz4ki@merlins.org>
References: <20161118164643.g7ttuzgsj74d6fbz@merlins.org>
 <20161118184915.j6dlazbgminxnxzx@merlins.org>
 <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li>
 <alpine.LRH.2.11.1611291255350.1914@mail.ewheeler.net>
 <20161130164646.d6ejlv72hzellddd@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161130164646.d6ejlv72hzellddd@merlins.org>
Subject: Re: btrfs flooding the I/O subsystem and hanging the machine, with
 bcache cache turned off
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 08:46:46AM -0800, Marc MERLIN wrote:
> +btrfs mailing list, see below why
> 
> Ok, Linus helped me find a workaround for this problem:
> https://lkml.org/lkml/2016/11/29/667
> namely:
>    echo 2 > /proc/sys/vm/dirty_ratio
>    echo 1 > /proc/sys/vm/dirty_background_ratio
> (it's a 24GB system, so the defaults of 20 and 10 were creating too many
> requests in th buffers)

I'll remove the bcache list on this followup since I want to concentrate
here on the fact that btrfs does behave badly with the default
dirty_ratio values.
As a reminder, it's a btrfs send/receive copy between 2 swraid5 arrays
on spinning rust.
swraid5 < bcache < dmcrypt < btrfs

Copying with btrfs send/receive causes massive hangs on the system.
Please see this explanation from Linus on why the workaround was
suggested:
https://lkml.org/lkml/2016/11/29/667

The hangs that I'm getting with bcache cache turned off (i.e.
passthrough) are now very likely only due to btrfs and mess up anything
doing file IO that ends up timing out, break USB even as reads time out
in the middle of USB requests, interrupts lost, and so forth.

All of this mostly went away with Linus' suggestion:
echo 2 > /proc/sys/vm/dirty_ratio
echo 1 > /proc/sys/vm/dirty_background_ratio

But that's hiding the symptom which I think is that btrfs is piling up too many I/O
requests during btrfs send/receive and btrfs scrub (probably balance too) and not 
looking at resulting impact to system health.

Is there a way to stop flodding the entire system with I/O and causing
so much strain on it?
(I realize that if there is a caching layer underneath that just takes
requests and says thank you without giving other clues that underneath
bad things are happening, it may be hard, but I'm asking anyway :)


[10338.968912] perf: interrupt took too long (3927 > 3917), lowering kernel.perf_event_max_sample_rate to 50750

[12971.047705] ftdi_sio ttyUSB15: usb_serial_generic_read_bulk_callback - urb stopped: -32

[17761.122238] usb 4-1.4: USB disconnect, device number 39
[17761.141063] usb 4-1.4: usbfs: USBDEVFS_CONTROL failed cmd hub-ctrl rqt 160 rq 6 len 1024 ret -108
[17761.263252] usb 4-1: reset SuperSpeed USB device number 2 using xhci_hcd
[17761.938575] usb 4-1.4: new SuperSpeed USB device number 40 using xhci_hcd

[24130.574425] hpet1: lost 2306 rtc interrupts
[24156.034950] hpet1: lost 1628 rtc interrupts
[24173.314738] hpet1: lost 1104 rtc interrupts
[24180.129950] hpet1: lost 436 rtc interrupts
[24257.557955] hpet1: lost 4954 rtc interrupts
[24267.522656] hpet1: lost 637 rtc interrupts

[28034.954435] INFO: task btrfs:5618 blocked for more than 120 seconds.
[28034.975471]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[28035.000964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28035.025429] btrfs           D ffff91154d33fc70     0  5618   5372 0x00000080
[28035.047717]  ffff91154d33fc70 0000000000200246 ffff911842f880c0 ffff9115a4cf01c0
[28035.071020]  ffff91154d33fc58 ffff91154d340000 ffff91165493bca0 ffff9115623773f0
[28035.094252]  0000000000001000 0000000000000001 ffff91154d33fc88 ffffffffb86cf1a6
[28035.117538] Call Trace:
[28035.125791]  [<ffffffffb86cf1a6>] schedule+0x8b/0xa3
[28035.141550]  [<ffffffffb82bd18e>] btrfs_start_ordered_extent+0xce/0x122
[28035.162457]  [<ffffffffb809af6c>] ? wake_up_atomic_t+0x2c/0x2c
[28035.180891]  [<ffffffffb82bd434>] btrfs_wait_ordered_range+0xa9/0x10d
[28035.201723]  [<ffffffffb82aec04>] btrfs_truncate+0x40/0x24b
[28035.219269]  [<ffffffffb82af437>] btrfs_setattr+0x1da/0x2d7
[28035.237032]  [<ffffffffb81c7507>] notify_change+0x252/0x39c
[28035.254566]  [<ffffffffb81ad35b>] do_truncate+0x81/0xb4
[28035.271057]  [<ffffffffb81ad467>] vfs_truncate+0xd9/0xf9
[28035.287782]  [<ffffffffb81ad4ea>] do_sys_truncate+0x63/0xa7

[28155.781987] INFO: task btrfs:5618 blocked for more than 120 seconds.
[28155.802229]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[28155.827894] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28155.852479] btrfs           D ffff91154d33fc70     0  5618   5372 0x00000080
[28155.874761]  ffff91154d33fc70 0000000000200246 ffff911842f880c0 ffff9115a4cf01c0
[28155.898059]  ffff91154d33fc58 ffff91154d340000 ffff91165493bca0 ffff9115623773f0
[28155.921464]  0000000000001000 0000000000000001 ffff91154d33fc88 ffffffffb86cf1a6
[28155.944720] Call Trace:
[28155.953176]  [<ffffffffb86cf1a6>] schedule+0x8b/0xa3
[28155.968945]  [<ffffffffb82bd18e>] btrfs_start_ordered_extent+0xce/0x122
[28155.989811]  [<ffffffffb809af6c>] ? wake_up_atomic_t+0x2c/0x2c
[28156.008195]  [<ffffffffb82bd434>] btrfs_wait_ordered_range+0xa9/0x10d
[28156.028498]  [<ffffffffb82aec04>] btrfs_truncate+0x40/0x24b
[28156.046081]  [<ffffffffb82af437>] btrfs_setattr+0x1da/0x2d7
[28156.063621]  [<ffffffffb81c7507>] notify_change+0x252/0x39c
[28156.081667]  [<ffffffffb81ad35b>] do_truncate+0x81/0xb4
[28156.098732]  [<ffffffffb81ad467>] vfs_truncate+0xd9/0xf9
[28156.115489]  [<ffffffffb81ad4ea>] do_sys_truncate+0x63/0xa7
[28156.133389]  [<ffffffffb81ad63a>] SyS_truncate+0xe/0x10
[28156.149831]  [<ffffffffb80039ec>] do_syscall_64+0x61/0x72
[28156.167179]  [<ffffffffb86d2265>] entry_SYSCALL64_slow_path+0x25/0x25

[28397.436986] INFO: task btrfs:5618 blocked for more than 120 seconds.
[28397.456798]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[28397.482122] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28397.506359] btrfs           D ffff91154d33fc70     0  5618   5372 0x00000080
[28397.528494]  ffff91154d33fc70 0000000000200246 ffff911842fa41c0 ffff9115a4cf01c0
[28397.551645]  ffff91154d33fc58 ffff91154d340000 ffff91142ba20140 ffff9115ba3ad7e8
[28397.574829]  0000000000001000 0000000000000001 ffff91154d33fc88 ffffffffb86cf1a6
[28397.598015] Call Trace:
[28397.606120]  [<ffffffffb86cf1a6>] schedule+0x8b/0xa3
[28397.621772]  [<ffffffffb82bd18e>] btrfs_start_ordered_extent+0xce/0x122
[28397.642376]  [<ffffffffb809af6c>] ? wake_up_atomic_t+0x2c/0x2c
[28397.660661]  [<ffffffffb82bd434>] btrfs_wait_ordered_range+0xa9/0x10d
[28397.680801]  [<ffffffffb82aec04>] btrfs_truncate+0x40/0x24b
[28397.698281]  [<ffffffffb82af437>] btrfs_setattr+0x1da/0x2d7
[28397.715769]  [<ffffffffb81c7507>] notify_change+0x252/0x39c
[28397.733279]  [<ffffffffb81ad35b>] do_truncate+0x81/0xb4
[28397.749731]  [<ffffffffb81ad467>] vfs_truncate+0xd9/0xf9
[28397.766379]  [<ffffffffb81ad4ea>] do_sys_truncate+0x63/0xa7
[28397.783878]  [<ffffffffb81ad63a>] SyS_truncate+0xe/0x10
[28397.800319]  [<ffffffffb80039ec>] do_syscall_64+0x61/0x72
[28397.817286]  [<ffffffffb86d2265>] entry_SYSCALL64_slow_path+0x25/0x25

[28518.264522] INFO: task btrfs:5618 blocked for more than 120 seconds.
[28518.285084]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[28518.310600] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28518.335590] btrfs           D ffff91154d33fc70     0  5618   5372 0x00000080
[28518.357716]  ffff91154d33fc70 0000000000200246 ffff911842fa41c0 ffff9115a4cf01c0
[28518.380902]  ffff91154d33fc58 ffff91154d340000 ffff91142ba20140 ffff9115ba3ad7e8
[28518.404075]  0000000000001000 0000000000000001 ffff91154d33fc88 ffffffffb86cf1a6
[28518.427227] Call Trace:
[28518.435384]  [<ffffffffb86cf1a6>] schedule+0x8b/0xa3
[28518.451151]  [<ffffffffb82bd18e>] btrfs_start_ordered_extent+0xce/0x122
[28518.471821]  [<ffffffffb809af6c>] ? wake_up_atomic_t+0x2c/0x2c
[28518.490186]  [<ffffffffb82bd434>] btrfs_wait_ordered_range+0xa9/0x10d
[28518.510301]  [<ffffffffb82aec04>] btrfs_truncate+0x40/0x24b
[28518.527818]  [<ffffffffb82af437>] btrfs_setattr+0x1da/0x2d7
[28518.545320]  [<ffffffffb81c7507>] notify_change+0x252/0x39c
[28518.562924]  [<ffffffffb81ad35b>] do_truncate+0x81/0xb4
[28518.579434]  [<ffffffffb81ad467>] vfs_truncate+0xd9/0xf9
[28518.596132]  [<ffffffffb81ad4ea>] do_sys_truncate+0x63/0xa7
[28518.613687]  [<ffffffffb81ad63a>] SyS_truncate+0xe/0x10
[28518.630115]  [<ffffffffb80039ec>] do_syscall_64+0x61/0x72
[28518.647003]  [<ffffffffb86d2265>] entry_SYSCALL64_slow_path+0x25/0x25
[28518.667036] INFO: task kworker/u16:34:27172 blocked for more than 120 seconds.
[28518.689602]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[28518.715144] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28518.739569] kworker/u16:34  D ffff9117ec52bc80     0 27172      2 0x00000080
[28518.761628] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[28518.780669]  ffff9117ec52bc80 0000000000200246 ffff911842f9e180 ffff91157c386000
[28518.803719]  ffff9117ec52bc68 ffff9117ec52c000 ffff9115cbf779f0 ffff9115cbf77800
[28518.826783]  0000000000000000 ffff9116af353500 ffff9117ec52bc98 ffffffffb86cf1a6
[28518.849863] Call Trace:
[28518.858011]  [<ffffffffb86cf1a6>] schedule+0x8b/0xa3
[28518.873624]  [<ffffffffb82a364f>] wait_current_trans.isra.16+0xcc/0x107
[28518.894158]  [<ffffffffb809af6c>] ? wake_up_atomic_t+0x2c/0x2c
[28518.912370]  [<ffffffffb82a58e1>] start_transaction+0x2ba/0x418
[28518.930827]  [<ffffffffb82a5a8a>] btrfs_join_transaction+0x17/0x19
[28518.950105]  [<ffffffffb82ad3ec>] btrfs_finish_ordered_io+0x1e9/0x4db
[28518.970132]  [<ffffffffb8088000>] ? preempt_latency_start+0x34/0x5d
[28518.989640]  [<ffffffffb82ad946>] finish_ordered_fn+0x15/0x17
[28519.007579]  [<ffffffffb82cfd68>] btrfs_scrubparity_helper+0x10e/0x258
[28519.027844]  [<ffffffffb807b8c1>] ? pwq_activate_delayed_work+0x4d/0x5b
[28519.048420]  [<ffffffffb82cff40>] btrfs_endio_write_helper+0xe/0x10
[28519.067907]  [<ffffffffb807d068>] process_one_work+0x186/0x29d
[28519.086158]  [<ffffffffb807d66d>] worker_thread+0x1ea/0x2ba
[28519.103608]  [<ffffffffb807d483>] ? rescuer_thread+0x2d1/0x2d1
[28519.121783]  [<ffffffffb8081df3>] kthread+0xb4/0xbc
[28519.137100]  [<ffffffffb86d23df>] ret_from_fork+0x1f/0x40
[28519.153938]  [<ffffffffb8081d3f>] ? init_completion+0x24/0x24
[28519.171842] INFO: task kworker/u16:8:8909 blocked for more than 120 seconds.
[28519.193688]       Tainted: G     U          4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
[28519.218851] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[28519.243006] kworker/u16:8   D ffff9117b992fc80     0  8909      2 0x00000080
[28519.264933] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[28519.284037]  ffff9117b992fc80 0000000000200246 ffff911842f9e180 ffff91137ef54100
[28519.307073]  ffff9117b992fc68 ffff9117b9930000 ffff9115cbf779f0 ffff9115cbf77800
[28519.330159]  0000000000000000 ffff911282f35e60 ffff9117b992fc98 ffffffffb86cf1a6
[28519.353218] Call Trace:
[28519.361192]  [<ffffffffb86cf1a6>] schedule+0x8b/0xa3
[28519.376747]  [<ffffffffb82a364f>] wait_current_trans.isra.16+0xcc/0x107
[28519.397211]  [<ffffffffb809af6c>] ? wake_up_atomic_t+0x2c/0x2c
[28519.415378]  [<ffffffffb82a58e1>] start_transaction+0x2ba/0x418
[28519.433752]  [<ffffffffb82a5a8a>] btrfs_join_transaction+0x17/0x19
[28519.452929]  [<ffffffffb82ad3ec>] btrfs_finish_ordered_io+0x1e9/0x4db
[28519.472945]  [<ffffffffb8088000>] ? preempt_latency_start+0x34/0x5d
[28519.492434]  [<ffffffffb82ad946>] finish_ordered_fn+0x15/0x17
[28519.510364]  [<ffffffffb82cfd68>] btrfs_scrubparity_helper+0x10e/0x258
[28519.530582]  [<ffffffffb807b8c1>] ? pwq_activate_delayed_work+0x4d/0x5b
[28519.551062]  [<ffffffffb82cff40>] btrfs_endio_write_helper+0xe/0x10
[28519.570519]  [<ffffffffb807d068>] process_one_work+0x186/0x29d
[28519.588711]  [<ffffffffb807d66d>] worker_thread+0x1ea/0x2ba
[28519.606111]  [<ffffffffb807d483>] ? rescuer_thread+0x2d1/0x2d1
[28519.624269]  [<ffffffffb8081df3>] kthread+0xb4/0xbc
[28519.639539]  [<ffffffffb86d23df>] ret_from_fork+0x1f/0x40
[28519.656380]  [<ffffffffb8081d3f>] ? init_completion+0x24/0x24


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
