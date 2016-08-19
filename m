Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:32827 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753928AbcHSTjN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 15:39:13 -0400
Received: by mail-yw0-f193.google.com with SMTP id z8so1201102ywa.0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 12:39:12 -0700 (PDT)
Received: from ?IPv6:2001:470:8:414::10? (wolf.welp.gs. [2001:470:8:414::10])
        by smtp.googlemail.com with ESMTPSA id s145sm2253416ywg.47.2016.08.19.12.39.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Aug 2016 12:39:10 -0700 (PDT)
To: BTRFS <linux-btrfs@vger.kernel.org>
From: Dan Merillat <dan.merillat@gmail.com>
Subject: btrfs-transaction spins forever on -next-20160818
Message-ID: <1db5ba2a-95eb-0658-2fec-8d7b72fb315f@gmail.com>
Date: Fri, 19 Aug 2016 15:39:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried out -next to test the mm fixes, and immediately upon mounting my
array (11TB, 98% full at the time) the btrfs-transaction thread for it
spun at 100% CPU.

It acted like read-only, write-discarding media - deleted files
reappeared after a reboot every time.  I'm not sure about writes, since
it's running the crashplan backup target service - that resynchronizes,
but I don't know enough about it to see if it complained about writes
vanishing.

I tried multiple reboots before going back to 4.6.7, where everything
worked properly.  4.7 BTRFS works as well, but I was hitting the mm bug
that OOMs improperly under high IO loads.

The topology is 4x4GB drives in md-raid5, bcache'd with a 256gb SSD,
btrfs on the bcache0 block device.

(apologies for the quote, only way to convince Thunderbird to not mangle
log files)

> Aug 19 04:53:22 fileserver kernel: [  605.152050] INFO: task kworker/u4:1:22 blocked for more than 120 seconds.
> Aug 19 04:53:22 fileserver kernel: [  605.152097]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:53:22 fileserver kernel: [  605.152138] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:53:22 fileserver kernel: [  605.152175] kworker/u4:1    D ffff88022666bad8     0    22      2 0x00000000
> Aug 19 04:53:22 fileserver kernel: [  605.152286] Workqueue: btrfs-submit btrfs_submit_helper
> Aug 19 04:53:22 fileserver kernel: [  605.152357]  ffff88022666bad8 ffffffff81a65800 ffff880179694040 ffff880226666100
> Aug 19 04:53:22 fileserver kernel: [  605.152521]  ffff88022666bae0 ffff88022666c000 ffff880220510ac0 ffff88022666bb10
> Aug 19 04:53:22 fileserver kernel: [  605.152688]  ffff880220510ad8 ffff880220510000 ffff88022666baf0 ffffffff81888bfa
> Aug 19 04:53:22 fileserver kernel: [  605.152851] Call Trace:
> Aug 19 04:53:22 fileserver kernel: [  605.152892]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.152929]  [<ffffffff8188af15>] rwsem_down_read_failed+0xe5/0x120
> Aug 19 04:53:22 fileserver kernel: [  605.152970]  [<ffffffff81489008>] call_rwsem_down_read_failed+0x18/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.153006]  [<ffffffff8188a842>] down_read+0x12/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.153047]  [<ffffffff8167757e>] cached_dev_make_request+0x65e/0xd90
> Aug 19 04:53:22 fileserver kernel: [  605.153083]  [<ffffffff81457f8d>] generic_make_request+0xdd/0x190
> Aug 19 04:53:22 fileserver kernel: [  605.153122]  [<ffffffff814580b5>] submit_bio+0x75/0x140
> Aug 19 04:53:22 fileserver kernel: [  605.153159]  [<ffffffff8114610d>] ? mempool_free+0x2d/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.153202]  [<ffffffff810832a1>] ? preempt_count_sub+0x51/0x80
> Aug 19 04:53:22 fileserver kernel: [  605.153240]  [<ffffffff813a5d58>] run_scheduled_bios+0x258/0x580
> Aug 19 04:53:22 fileserver kernel: [  605.153283]  [<ffffffff8139f482>] ? end_bio_extent_readpage+0x202/0x5b0
> Aug 19 04:53:22 fileserver kernel: [  605.153322]  [<ffffffff813a6090>] pending_bios_fn+0x10/0x20
> Aug 19 04:53:22 fileserver kernel: [  605.153363]  [<ffffffff813b0f87>] btrfs_scrubparity_helper+0x77/0x340
> Aug 19 04:53:22 fileserver kernel: [  605.153403]  [<ffffffff813b1359>] btrfs_submit_helper+0x9/0x10
> Aug 19 04:53:22 fileserver kernel: [  605.153446]  [<ffffffff81076170>] process_one_work+0x1e0/0x480
> Aug 19 04:53:22 fileserver kernel: [  605.153484]  [<ffffffff81076453>] worker_thread+0x43/0x4e0
> Aug 19 04:53:22 fileserver kernel: [  605.153526]  [<ffffffff81076410>] ? process_one_work+0x480/0x480
> Aug 19 04:53:22 fileserver kernel: [  605.153564]  [<ffffffff8107bc94>] kthread+0xc4/0xe0
> Aug 19 04:53:22 fileserver kernel: [  605.153607]  [<ffffffff8188cddf>] ret_from_fork+0x1f/0x40
> Aug 19 04:53:22 fileserver kernel: [  605.153644]  [<ffffffff8107bbd0>] ? kthread_worker_fn+0x110/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.153701] INFO: task bcache_writebac:972 blocked for more than 120 seconds.
> Aug 19 04:53:22 fileserver kernel: [  605.153740]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:53:22 fileserver kernel: [  605.153780] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:53:22 fileserver kernel: [  605.153822] bcache_writebac D ffff880220bc3cd8     0   972      2 0x00000000
> Aug 19 04:53:22 fileserver kernel: [  605.153929]  ffff880220bc3cd8 ffff880220bc3cb0 ffffffff81083200 ffff8802248642c0
> Aug 19 04:53:22 fileserver kernel: [  605.154100]  ffff880220510000 ffff880220bc4000 ffff880220510ac0 ffff880220510ac0
> Aug 19 04:53:22 fileserver kernel: [  605.154274]  ffff880220510ad8 ffffffff00000001 ffff880220bc3cf0 ffffffff81888bfa
> Aug 19 04:53:22 fileserver kernel: [  605.154443] Call Trace:
> Aug 19 04:53:22 fileserver kernel: [  605.154484]  [<ffffffff81083200>] ? finish_task_switch+0x180/0x1d0
> Aug 19 04:53:22 fileserver kernel: [  605.154522]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.154563]  [<ffffffff8188b059>] rwsem_down_write_failed+0x109/0x280
> Aug 19 04:53:22 fileserver kernel: [  605.154602]  [<ffffffff81489037>] call_rwsem_down_write_failed+0x17/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.154644]  [<ffffffff81888c04>] ? schedule+0x44/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.154681]  [<ffffffff8188a87f>] down_write+0x1f/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.154723]  [<ffffffff81683ccc>] bch_writeback_thread+0x5c/0x8a0
> Aug 19 04:53:22 fileserver kernel: [  605.154762]  [<ffffffff81683c70>] ? write_dirty+0xb0/0xb0
> Aug 19 04:53:22 fileserver kernel: [  605.154803]  [<ffffffff8107bc94>] kthread+0xc4/0xe0
> Aug 19 04:53:22 fileserver kernel: [  605.154841]  [<ffffffff8188cddf>] ret_from_fork+0x1f/0x40
> Aug 19 04:53:22 fileserver kernel: [  605.154882]  [<ffffffff8107bbd0>] ? kthread_worker_fn+0x110/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.154967] INFO: task java:4669 blocked for more than 120 seconds.
> Aug 19 04:53:22 fileserver kernel: [  605.155005]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:53:22 fileserver kernel: [  605.155045] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:53:22 fileserver kernel: [  605.155086] java            D ffff88014d91fb08     0  4669      1 0x00000000
> Aug 19 04:53:22 fileserver kernel: [  605.155193]  ffff88014d91fb08 ffff88014d920000 ffff88014d91fa00 ffff88014d8da140
> Aug 19 04:53:22 fileserver kernel: [  605.155362]  ffff88022585a0b8 ffff88014d920000 ffff88022fc17900 7fffffffffffffff
> Aug 19 04:53:22 fileserver kernel: [  605.155534]  ffffffff818894d0 ffff88014d91fc60 ffff88014d91fb20 ffffffff81888bfa
> Aug 19 04:53:22 fileserver kernel: [  605.155705] Call Trace:
> Aug 19 04:53:22 fileserver kernel: [  605.155745]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.155783]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.155824]  [<ffffffff8188b83e>] schedule_timeout+0x2de/0x420
> Aug 19 04:53:22 fileserver kernel: [  605.155862]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.155903]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.155942]  [<ffffffff8135e695>] ? can_overcommit.part.35+0xc5/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.155984]  [<ffffffff810c1c9d>] ? ktime_get+0x4d/0xc0
> Aug 19 04:53:22 fileserver kernel: [  605.156052]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.156090]  [<ffffffff818883ef>] io_schedule_timeout+0x9f/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.156128]  [<ffffffff818894e6>] bit_wait_io+0x16/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.156166]  [<ffffffff818891d3>] __wait_on_bit+0x53/0x80
> Aug 19 04:53:22 fileserver kernel: [  605.156204]  [<ffffffff81142192>] wait_on_page_bit+0xb2/0xc0
> Aug 19 04:53:22 fileserver kernel: [  605.156242]  [<ffffffff8109b9d0>] ? autoremove_wake_function+0x30/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.156280]  [<ffffffff81391a73>] prepare_pages+0x163/0x1e0
> Aug 19 04:53:22 fileserver kernel: [  605.156318]  [<ffffffff813922b3>] __btrfs_buffered_write.isra.4+0x1f3/0x6e0
> Aug 19 04:53:22 fileserver kernel: [  605.156357]  [<ffffffff81395d46>] btrfs_file_write_iter+0x186/0x570
> Aug 19 04:53:22 fileserver kernel: [  605.156396]  [<ffffffff811ba751>] __vfs_write+0xc1/0x120
> Aug 19 04:53:22 fileserver kernel: [  605.156434]  [<ffffffff811bb45f>] vfs_write+0xbf/0x1a0
> Aug 19 04:53:22 fileserver kernel: [  605.156471]  [<ffffffff811bc84a>] SyS_write+0x4a/0xb0
> Aug 19 04:53:22 fileserver kernel: [  605.156509]  [<ffffffff8188cba9>] entry_SYSCALL_64_fastpath+0x1c/0xa7
> Aug 19 04:53:22 fileserver kernel: [  605.159736] INFO: task java:4691 blocked for more than 120 seconds.
> Aug 19 04:53:22 fileserver kernel: [  605.159785]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:53:22 fileserver kernel: [  605.159829] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:53:22 fileserver kernel: [  605.159870] java            D ffff880147f0bb08     0  4691      1 0x00000000
> Aug 19 04:53:22 fileserver kernel: [  605.159978]  ffff880147f0bb08 ffff880155d2e578 ffff88014d996040 ffff880147f021c0
> Aug 19 04:53:22 fileserver kernel: [  605.160171]  ffffffff8188c511 ffff880147f0c000 ffff88022fd17900 7fffffffffffffff
> Aug 19 04:53:22 fileserver kernel: [  605.160333]  ffffffff818894d0 ffff880147f0bc60 ffff880147f0bb20 ffffffff81888bfa
> Aug 19 04:53:22 fileserver kernel: [  605.160839] Call Trace:
> Aug 19 04:53:22 fileserver kernel: [  605.160885]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.160923]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.160965]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.161002]  [<ffffffff8188b83e>] schedule_timeout+0x2de/0x420
> Aug 19 04:53:22 fileserver kernel: [  605.161044]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.161082]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.161124]  [<ffffffff8135e695>] ? can_overcommit.part.35+0xc5/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.161163]  [<ffffffff810c1c9d>] ? ktime_get+0x4d/0xc0
> Aug 19 04:53:22 fileserver kernel: [  605.161204]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.161241]  [<ffffffff818883ef>] io_schedule_timeout+0x9f/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.161283]  [<ffffffff818894e6>] bit_wait_io+0x16/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.161321]  [<ffffffff818891d3>] __wait_on_bit+0x53/0x80
> Aug 19 04:53:22 fileserver kernel: [  605.161362]  [<ffffffff81142192>] wait_on_page_bit+0xb2/0xc0
> Aug 19 04:53:22 fileserver kernel: [  605.161401]  [<ffffffff8109b9d0>] ? autoremove_wake_function+0x30/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.161443]  [<ffffffff81391a73>] prepare_pages+0x163/0x1e0
> Aug 19 04:53:22 fileserver kernel: [  605.161481]  [<ffffffff813922b3>] __btrfs_buffered_write.isra.4+0x1f3/0x6e0
> Aug 19 04:53:22 fileserver kernel: [  605.161523]  [<ffffffff810b883e>] ? current_fs_time+0x1e/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.161562]  [<ffffffff811450ca>] ? generic_file_read_iter+0x5fa/0x6e0
> Aug 19 04:53:22 fileserver kernel: [  605.161605]  [<ffffffff81395d46>] btrfs_file_write_iter+0x186/0x570
> Aug 19 04:53:22 fileserver kernel: [  605.161644]  [<ffffffff811ba751>] __vfs_write+0xc1/0x120
> Aug 19 04:53:22 fileserver kernel: [  605.161685]  [<ffffffff811bb45f>] vfs_write+0xbf/0x1a0
> Aug 19 04:53:22 fileserver kernel: [  605.161723]  [<ffffffff811bc9cf>] SyS_pwrite64+0x7f/0xa0
> Aug 19 04:53:22 fileserver kernel: [  605.161764]  [<ffffffff8188cba9>] entry_SYSCALL_64_fastpath+0x1c/0xa7
> Aug 19 04:53:22 fileserver kernel: [  605.161831] INFO: task kworker/1:28:4864 blocked for more than 120 seconds.
> Aug 19 04:53:22 fileserver kernel: [  605.161870]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:53:22 fileserver kernel: [  605.161909] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:53:22 fileserver kernel: [  605.161950] kworker/1:28    D ffff8800030ebce8     0  4864      2 0x00000000
> Aug 19 04:53:22 fileserver kernel: [  605.162060] Workqueue: events update_writeback_rate
> Aug 19 04:53:22 fileserver kernel: [  605.162131]  ffff8800030ebce8 ffff88010dc02378 ffff88010dc02c00 ffff8800030e20c0
> Aug 19 04:53:22 fileserver kernel: [  605.162301]  ffff8800030ebcd0 ffff8800030ec000 ffff880220510ac0 ffff8800030ebd20
> Aug 19 04:53:22 fileserver kernel: [  605.162474]  ffff880220510ad8 ffff880220510b00 ffff8800030ebd00 ffffffff81888bfa
> Aug 19 04:53:22 fileserver kernel: [  605.162644] Call Trace:
> Aug 19 04:53:22 fileserver kernel: [  605.162685]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.162723]  [<ffffffff8188af15>] rwsem_down_read_failed+0xe5/0x120
> Aug 19 04:53:22 fileserver kernel: [  605.162765]  [<ffffffff8108c2c0>] ? update_curr+0x70/0x160
> Aug 19 04:53:22 fileserver kernel: [  605.162805]  [<ffffffff81489008>] call_rwsem_down_read_failed+0x18/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.162847]  [<ffffffff81076165>] ? process_one_work+0x1d5/0x480
> Aug 19 04:53:22 fileserver kernel: [  605.162888]  [<ffffffff8188a842>] down_read+0x12/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.162926]  [<ffffffff8168364b>] update_writeback_rate+0x2b/0x210
> Aug 19 04:53:22 fileserver kernel: [  605.162967]  [<ffffffff81076170>] process_one_work+0x1e0/0x480
> Aug 19 04:53:22 fileserver kernel: [  605.163005]  [<ffffffff81076453>] worker_thread+0x43/0x4e0
> Aug 19 04:53:22 fileserver kernel: [  605.163046]  [<ffffffff81076410>] ? process_one_work+0x480/0x480
> Aug 19 04:53:22 fileserver kernel: [  605.163084]  [<ffffffff8107bc94>] kthread+0xc4/0xe0
> Aug 19 04:53:22 fileserver kernel: [  605.163126]  [<ffffffff8188cddf>] ret_from_fork+0x1f/0x40
> Aug 19 04:53:22 fileserver kernel: [  605.163164]  [<ffffffff8107bbd0>] ? kthread_worker_fn+0x110/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.163248] INFO: task sync:5521 blocked for more than 120 seconds.
> Aug 19 04:53:22 fileserver kernel: [  605.163327]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:53:22 fileserver kernel: [  605.163365] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:53:22 fileserver kernel: [  605.163408] sync            D ffff88011671bbb8     0  5521   4816 0x00000000
> Aug 19 04:53:22 fileserver kernel: [  605.163512]  ffff88011671bbb8 ffff88011671bc18 ffffffff8141ae00 ffff88011671c2c0
> Aug 19 04:53:22 fileserver kernel: [  605.163684]  ffffea0007948640 ffff88011671c000 ffff88022fd17900 7fffffffffffffff
> Aug 19 04:53:22 fileserver kernel: [  605.163854]  ffffffff818894d0 ffff88011671bd18 ffff88011671bbd0 ffffffff81888bfa
> Aug 19 04:53:22 fileserver kernel: [  605.166269] Call Trace:
> Aug 19 04:53:22 fileserver kernel: [  605.166317]  [<ffffffff8141ae00>] ? avc_has_perm_noaudit+0x70/0xe0
> Aug 19 04:53:22 fileserver kernel: [  605.166367]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.166410]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.166448]  [<ffffffff8188b83e>] schedule_timeout+0x2de/0x420
> Aug 19 04:53:22 fileserver kernel: [  605.166491]  [<ffffffff8108d26b>] ? check_preempt_wakeup+0x11b/0x280
> Aug 19 04:53:22 fileserver kernel: [  605.166530]  [<ffffffff810c1c9d>] ? ktime_get+0x4d/0xc0
> Aug 19 04:53:22 fileserver kernel: [  605.166571]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.166608]  [<ffffffff818883ef>] io_schedule_timeout+0x9f/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.166650]  [<ffffffff818894e6>] bit_wait_io+0x16/0x60
> Aug 19 04:53:22 fileserver kernel: [  605.166688]  [<ffffffff818891d3>] __wait_on_bit+0x53/0x80
> Aug 19 04:53:22 fileserver kernel: [  605.166729]  [<ffffffff8114300e>] ? find_get_pages_tag+0x23e/0x280
> Aug 19 04:53:22 fileserver kernel: [  605.166768]  [<ffffffff81142192>] wait_on_page_bit+0xb2/0xc0
> Aug 19 04:53:22 fileserver kernel: [  605.166810]  [<ffffffff8109b9d0>] ? autoremove_wake_function+0x30/0x30
> Aug 19 04:53:22 fileserver kernel: [  605.166849]  [<ffffffff81142289>] __filemap_fdatawait_range+0xe9/0x140
> Aug 19 04:53:22 fileserver kernel: [  605.166891]  [<ffffffff81144a0b>] filemap_fdatawait_keep_errors+0x1b/0x20
> Aug 19 04:53:22 fileserver kernel: [  605.166930]  [<ffffffff811e8daf>] sync_inodes_sb+0x21f/0x270
> Aug 19 04:53:22 fileserver kernel: [  605.166972]  [<ffffffff811ed300>] ? SyS_tee+0x3f0/0x3f0
> Aug 19 04:53:22 fileserver kernel: [  605.167010]  [<ffffffff811ed310>] sync_inodes_one_sb+0x10/0x20
> Aug 19 04:53:22 fileserver kernel: [  605.167052]  [<ffffffff811bf058>] iterate_supers+0xb8/0x110
> Aug 19 04:53:22 fileserver kernel: [  605.167090]  [<ffffffff811ed620>] sys_sync+0x30/0x90
> Aug 19 04:53:22 fileserver kernel: [  605.167132]  [<ffffffff8188cba9>] entry_SYSCALL_64_fastpath+0x1c/0xa7
> Aug 19 04:55:23 fileserver kernel: [  725.984081] INFO: task kworker/u4:1:22 blocked for more than 120 seconds.
> Aug 19 04:55:23 fileserver kernel: [  725.984102]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:55:23 fileserver kernel: [  725.984118] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:55:23 fileserver kernel: [  725.984131] kworker/u4:1    D ffff88022666bad8     0    22      2 0x00000000
> Aug 19 04:55:23 fileserver kernel: [  725.984160] Workqueue: btrfs-submit btrfs_submit_helper
> Aug 19 04:55:23 fileserver kernel: [  725.984175]  ffff88022666bad8 ffffffff81a65800 ffff880179694040 ffff880226666100
> Aug 19 04:55:23 fileserver kernel: [  725.984204]  ffff88022666bae0 ffff88022666c000 ffff880220510ac0 ffff88022666bb10
> Aug 19 04:55:23 fileserver kernel: [  725.984235]  ffff880220510ad8 ffff880220510000 ffff88022666baf0 ffffffff81888bfa
> Aug 19 04:55:23 fileserver kernel: [  725.984263] Call Trace:
> Aug 19 04:55:23 fileserver kernel: [  725.984279]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:55:23 fileserver kernel: [  725.984289]  [<ffffffff8188af15>] rwsem_down_read_failed+0xe5/0x120
> Aug 19 04:55:23 fileserver kernel: [  725.984304]  [<ffffffff81489008>] call_rwsem_down_read_failed+0x18/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.984315]  [<ffffffff8188a842>] down_read+0x12/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.984329]  [<ffffffff8167757e>] cached_dev_make_request+0x65e/0xd90
> Aug 19 04:55:23 fileserver kernel: [  725.985211]  [<ffffffff81457f8d>] generic_make_request+0xdd/0x190
> Aug 19 04:55:23 fileserver kernel: [  725.985224]  [<ffffffff814580b5>] submit_bio+0x75/0x140
> Aug 19 04:55:23 fileserver kernel: [  725.985235]  [<ffffffff8114610d>] ? mempool_free+0x2d/0x90
> Aug 19 04:55:23 fileserver kernel: [  725.985249]  [<ffffffff810832a1>] ? preempt_count_sub+0x51/0x80
> Aug 19 04:55:23 fileserver kernel: [  725.985259]  [<ffffffff813a5d58>] run_scheduled_bios+0x258/0x580
> Aug 19 04:55:23 fileserver kernel: [  725.985273]  [<ffffffff8139f482>] ? end_bio_extent_readpage+0x202/0x5b0
> Aug 19 04:55:23 fileserver kernel: [  725.985284]  [<ffffffff813a6090>] pending_bios_fn+0x10/0x20
> Aug 19 04:55:23 fileserver kernel: [  725.985297]  [<ffffffff813b0f87>] btrfs_scrubparity_helper+0x77/0x340
> Aug 19 04:55:23 fileserver kernel: [  725.985307]  [<ffffffff813b1359>] btrfs_submit_helper+0x9/0x10
> Aug 19 04:55:23 fileserver kernel: [  725.985321]  [<ffffffff81076170>] process_one_work+0x1e0/0x480
> Aug 19 04:55:23 fileserver kernel: [  725.985331]  [<ffffffff81076453>] worker_thread+0x43/0x4e0
> Aug 19 04:55:23 fileserver kernel: [  725.985343]  [<ffffffff81076410>] ? process_one_work+0x480/0x480
> Aug 19 04:55:23 fileserver kernel: [  725.985354]  [<ffffffff8107bc94>] kthread+0xc4/0xe0
> Aug 19 04:55:23 fileserver kernel: [  725.985368]  [<ffffffff8188cddf>] ret_from_fork+0x1f/0x40
> Aug 19 04:55:23 fileserver kernel: [  725.985378]  [<ffffffff8107bbd0>] ? kthread_worker_fn+0x110/0x110
> Aug 19 04:55:23 fileserver kernel: [  725.985406] INFO: task bcache_writebac:972 blocked for more than 120 seconds.
> Aug 19 04:55:23 fileserver kernel: [  725.985416]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:55:23 fileserver kernel: [  725.985428] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:55:23 fileserver kernel: [  725.985441] bcache_writebac D ffff880220bc3cd8     0   972      2 0x00000000
> Aug 19 04:55:23 fileserver kernel: [  725.985464]  ffff880220bc3cd8 ffff880220bc3cb0 ffffffff81083200 ffff8802248642c0
> Aug 19 04:55:23 fileserver kernel: [  725.985492]  ffff880220510000 ffff880220bc4000 ffff880220510ac0 ffff880220510ac0
> Aug 19 04:55:23 fileserver kernel: [  725.985524]  ffff880220510ad8 ffffffff00000001 ffff880220bc3cf0 ffffffff81888bfa
> Aug 19 04:55:23 fileserver kernel: [  725.985551] Call Trace:
> Aug 19 04:55:23 fileserver kernel: [  725.985564]  [<ffffffff81083200>] ? finish_task_switch+0x180/0x1d0
> Aug 19 04:55:23 fileserver kernel: [  725.985574]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:55:23 fileserver kernel: [  725.985587]  [<ffffffff8188b059>] rwsem_down_write_failed+0x109/0x280
> Aug 19 04:55:23 fileserver kernel: [  725.985598]  [<ffffffff81489037>] call_rwsem_down_write_failed+0x17/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.985611]  [<ffffffff81888c04>] ? schedule+0x44/0x90
> Aug 19 04:55:23 fileserver kernel: [  725.985621]  [<ffffffff8188a87f>] down_write+0x1f/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.985634]  [<ffffffff81683ccc>] bch_writeback_thread+0x5c/0x8a0
> Aug 19 04:55:23 fileserver kernel: [  725.985645]  [<ffffffff81683c70>] ? write_dirty+0xb0/0xb0
> Aug 19 04:55:23 fileserver kernel: [  725.985658]  [<ffffffff8107bc94>] kthread+0xc4/0xe0
> Aug 19 04:55:23 fileserver kernel: [  725.985668]  [<ffffffff8188cddf>] ret_from_fork+0x1f/0x40
> Aug 19 04:55:23 fileserver kernel: [  725.985681]  [<ffffffff8107bbd0>] ? kthread_worker_fn+0x110/0x110
> Aug 19 04:55:23 fileserver kernel: [  725.985741] INFO: task java:4669 blocked for more than 120 seconds.
> Aug 19 04:55:23 fileserver kernel: [  725.985751]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:55:23 fileserver kernel: [  725.985762] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:55:23 fileserver kernel: [  725.985774] java            D ffff88014d91fb08     0  4669      1 0x00000000
> Aug 19 04:55:23 fileserver kernel: [  725.985798]  ffff88014d91fb08 ffff88014d920000 ffff88014d91fa00 ffff88014d8da140
> Aug 19 04:55:23 fileserver kernel: [  725.985826]  ffff88022585a0b8 ffff88014d920000 ffff88022fc17900 7fffffffffffffff
> Aug 19 04:55:23 fileserver kernel: [  725.985857]  ffffffff818894d0 ffff88014d91fc60 ffff88014d91fb20 ffffffff81888bfa
> Aug 19 04:55:23 fileserver kernel: [  725.985885] Call Trace:
> Aug 19 04:55:23 fileserver kernel: [  725.985897]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:55:23 fileserver kernel: [  725.985907]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:55:23 fileserver kernel: [  725.985919]  [<ffffffff8188b83e>] schedule_timeout+0x2de/0x420
> Aug 19 04:55:23 fileserver kernel: [  725.985929]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.985943]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.985953]  [<ffffffff8135e695>] ? can_overcommit.part.35+0xc5/0x110
> Aug 19 04:55:23 fileserver kernel: [  725.985967]  [<ffffffff810c1c9d>] ? ktime_get+0x4d/0xc0
> Aug 19 04:55:23 fileserver kernel: [  725.985977]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:55:23 fileserver kernel: [  725.985989]  [<ffffffff818883ef>] io_schedule_timeout+0x9f/0x110
> Aug 19 04:55:23 fileserver kernel: [  725.985999]  [<ffffffff818894e6>] bit_wait_io+0x16/0x60
> Aug 19 04:55:23 fileserver kernel: [  725.986012]  [<ffffffff818891d3>] __wait_on_bit+0x53/0x80
> Aug 19 04:55:23 fileserver kernel: [  725.986021]  [<ffffffff81142192>] wait_on_page_bit+0xb2/0xc0
> Aug 19 04:55:23 fileserver kernel: [  725.986035]  [<ffffffff8109b9d0>] ? autoremove_wake_function+0x30/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.986045]  [<ffffffff81391a73>] prepare_pages+0x163/0x1e0
> Aug 19 04:55:23 fileserver kernel: [  725.986058]  [<ffffffff813922b3>] __btrfs_buffered_write.isra.4+0x1f3/0x6e0
> Aug 19 04:55:23 fileserver kernel: [  725.986069]  [<ffffffff81395d46>] btrfs_file_write_iter+0x186/0x570
> Aug 19 04:55:23 fileserver kernel: [  725.986082]  [<ffffffff811ba751>] __vfs_write+0xc1/0x120
> Aug 19 04:55:23 fileserver kernel: [  725.986092]  [<ffffffff811bb45f>] vfs_write+0xbf/0x1a0
> Aug 19 04:55:23 fileserver kernel: [  725.986105]  [<ffffffff811bc84a>] SyS_write+0x4a/0xb0
> Aug 19 04:55:23 fileserver kernel: [  725.986115]  [<ffffffff8188cba9>] entry_SYSCALL_64_fastpath+0x1c/0xa7
> Aug 19 04:55:23 fileserver kernel: [  725.986130] INFO: task java:4691 blocked for more than 120 seconds.
> Aug 19 04:55:23 fileserver kernel: [  725.986139]       Not tainted 4.8.0-rc2-next-20160818 #15
> Aug 19 04:55:23 fileserver kernel: [  725.986151] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 19 04:55:23 fileserver kernel: [  725.986163] java            D ffff880147f0bb08     0  4691      1 0x00000000
> Aug 19 04:55:23 fileserver kernel: [  725.986186]  ffff880147f0bb08 ffff880155d2e578 ffff88014d996040 ffff880147f021c0
> Aug 19 04:55:23 fileserver kernel: [  725.986214]  ffffffff8188c511 ffff880147f0c000 ffff88022fd17900 7fffffffffffffff
> Aug 19 04:55:23 fileserver kernel: [  725.986245]  ffffffff818894d0 ffff880147f0bc60 ffff880147f0bb20 ffffffff81888bfa
> Aug 19 04:55:23 fileserver kernel: [  725.986272] Call Trace:
> Aug 19 04:55:23 fileserver kernel: [  725.986285]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.986295]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:55:23 fileserver kernel: [  725.986308]  [<ffffffff81888bfa>] schedule+0x3a/0x90
> Aug 19 04:55:23 fileserver kernel: [  725.986317]  [<ffffffff8188b83e>] schedule_timeout+0x2de/0x420
> Aug 19 04:55:23 fileserver kernel: [  725.986330]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.986340]  [<ffffffff8188c511>] ? _raw_spin_unlock+0x11/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.986353]  [<ffffffff8135e695>] ? can_overcommit.part.35+0xc5/0x110
> Aug 19 04:55:23 fileserver kernel: [  725.986363]  [<ffffffff810c1c9d>] ? ktime_get+0x4d/0xc0
> Aug 19 04:55:23 fileserver kernel: [  725.986376]  [<ffffffff818894d0>] ? bit_wait+0x60/0x60
> Aug 19 04:55:23 fileserver kernel: [  725.986386]  [<ffffffff818883ef>] io_schedule_timeout+0x9f/0x110
> Aug 19 04:55:23 fileserver kernel: [  725.986399]  [<ffffffff818894e6>] bit_wait_io+0x16/0x60
> Aug 19 04:55:23 fileserver kernel: [  725.986408]  [<ffffffff818891d3>] __wait_on_bit+0x53/0x80
> Aug 19 04:55:23 fileserver kernel: [  725.986421]  [<ffffffff81142192>] wait_on_page_bit+0xb2/0xc0
> Aug 19 04:55:23 fileserver kernel: [  725.986431]  [<ffffffff8109b9d0>] ? autoremove_wake_function+0x30/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.986444]  [<ffffffff81391a73>] prepare_pages+0x163/0x1e0
> Aug 19 04:55:23 fileserver kernel: [  725.986453]  [<ffffffff813922b3>] __btrfs_buffered_write.isra.4+0x1f3/0x6e0
> Aug 19 04:55:23 fileserver kernel: [  725.986468]  [<ffffffff810b883e>] ? current_fs_time+0x1e/0x30
> Aug 19 04:55:23 fileserver kernel: [  725.986478]  [<ffffffff811450ca>] ? generic_file_read_iter+0x5fa/0x6e0
> Aug 19 04:55:23 fileserver kernel: [  725.986491]  [<ffffffff81395d46>] btrfs_file_write_iter+0x186/0x570
> Aug 19 04:55:23 fileserver kernel: [  725.986501]  [<ffffffff811ba751>] __vfs_write+0xc1/0x120
> Aug 19 04:55:23 fileserver kernel: [  725.986514]  [<ffffffff811bb45f>] vfs_write+0xbf/0x1a0
> Aug 19 04:55:23 fileserver kernel: [  725.986523]  [<ffffffff811bc9cf>] SyS_pwrite64+0x7f/0xa0
> Aug 19 04:55:23 fileserver kernel: [  725.986537]  [<ffffffff8188cba9>] entry_SYSCALL_64_fastpath+0x1c/0xa7

