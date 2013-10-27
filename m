Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61822 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3J0VIw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 17:08:52 -0400
Received: by mail-wi0-f180.google.com with SMTP id ey11so3140752wid.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 14:08:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHCKNJhbBk-4LbFfEVM4ULiHzRgqA0ZD1Hi-qXnEGKkYqN7TVg@mail.gmail.com>
References: <CAHCKNJj2=qfWEpWWUOBit5cJakwd+oFr1U-xj8MS-w9oQo6YQg@mail.gmail.com>
	<20131024084756.14051.61595@localhost.localdomain>
	<CAHCKNJhbBk-4LbFfEVM4ULiHzRgqA0ZD1Hi-qXnEGKkYqN7TVg@mail.gmail.com>
Date: Sun, 27 Oct 2013 21:08:50 +0000
Message-ID: <CAHCKNJiyycwegGY90iwm39MpzfaxY+mfTFmpQ5zvoHuSyhp5ug@mail.gmail.com>
Subject: Re: 3.11 and 3.12rc continual hard lock ups
From: Sean Clarke <sean.clarke@sec-consulting.co.uk>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, hard another crash this afternoon - I had "dmesg -n7" set and this
time (unusually) I had something in the logs:

Oct 27 14:48:15 enterprise kernel: [23752.263442] INFO: task nfsd:1537
blocked for more than 120 seconds.
Oct 27 14:48:15 enterprise kernel: [23752.263452]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:48:21 enterprise kernel: [23752.263460] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:48:21 enterprise kernel: [23752.263469] nfsd            D
0000000000000000     0  1537      2 0x00000000
Oct 27 14:48:21 enterprise kernel: [23752.263484]  ffff8800ba29db38
0000000000000046 ffff880036bcc1a0 ffff88003602b800
Oct 27 14:48:21 enterprise kernel: [23752.263503]  ffff8800ba29dfd8
ffff8800ba29dfd8 ffff8800ba29dfd8 00000000000144c0
Oct 27 14:48:21 enterprise kernel: [23752.263513]  ffff880329daaf60
ffff8800ba1a17b0 ffff8800ba29db48 ffff88032b893430
Oct 27 14:48:21 enterprise kernel: [23752.263523] Call Trace:
Oct 27 14:48:21 enterprise kernel: [23752.263531]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:48:21 enterprise kernel: [23752.263557]
[<ffffffffa01642f1>] wait_current_trans.isra.33+0xc1/0x120 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.263566]
[<ffffffff8108cc40>] ? add_wait_queue+0x60/0x60
Oct 27 14:48:21 enterprise kernel: [23752.263580]
[<ffffffffa016615e>] start_transaction.part.35+0x2ee/0x510 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.263594]
[<ffffffffa01663a9>] start_transaction+0x29/0x30 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.263607]
[<ffffffffa01665fb>] btrfs_start_transaction+0x1b/0x20 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.263622]
[<ffffffffa01744b6>] btrfs_create+0x46/0x220 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.263628]
[<ffffffff812fb7fc>] ? security_inode_permission+0x1c/0x30
Oct 27 14:48:21 enterprise kernel: [23752.263634]
[<ffffffff811cc0b5>] vfs_create+0xb5/0x120
Oct 27 14:48:21 enterprise kernel: [23752.263643]
[<ffffffffa065941c>] do_nfsd_create+0x50c/0x5f0 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263653]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263660]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263673]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.263685]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.263692]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263699]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263704]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:48:21 enterprise kernel: [23752.263709]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.263715]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.263720]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.263725] INFO: task nfsd:1539
blocked for more than 120 seconds.
Oct 27 14:48:21 enterprise kernel: [23752.263729]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:48:21 enterprise kernel: [23752.263733] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:48:21 enterprise kernel: [23752.263737] nfsd            D
0000000000000000     0  1539      2 0x00000000
Oct 27 14:48:21 enterprise kernel: [23752.263744]  ffff88032d783c38
0000000000000046 ffff88032d783be8 ffffffff81094340
Oct 27 14:48:21 enterprise kernel: [23752.263753]  ffff88032d783fd8
ffff88032d783fd8 ffff88032d783fd8 00000000000144c0
Oct 27 14:48:21 enterprise kernel: [23752.263764]  ffff88032e5ddec0
ffff8800ba1a4710 ffff88032d783c18 ffff8802f2573408
Oct 27 14:48:21 enterprise kernel: [23752.263773] Call Trace:
Oct 27 14:48:21 enterprise kernel: [23752.263778]
[<ffffffff81094340>] ? set_groups+0x40/0x60
Oct 27 14:48:21 enterprise kernel: [23752.263783]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:48:21 enterprise kernel: [23752.263788]
[<ffffffff8174509e>] schedule_preempt_disabled+0xe/0x10
Oct 27 14:48:21 enterprise kernel: [23752.263794]
[<ffffffff81743024>] __mutex_lock_slowpath+0x114/0x1b0
Oct 27 14:48:21 enterprise kernel: [23752.263800]
[<ffffffff817430e3>] mutex_lock+0x23/0x40
Oct 27 14:48:21 enterprise kernel: [23752.263807]
[<ffffffffa0659088>] do_nfsd_create+0x178/0x5f0 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263816]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263824]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263835]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.263846]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.263853]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263860]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.263865]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:48:21 enterprise kernel: [23752.263870]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.263875]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.263880]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.263884] INFO: task nfsd:1540
blocked for more than 120 seconds.
Oct 27 14:48:21 enterprise kernel: [23752.263888]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:48:21 enterprise kernel: [23752.263892] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:48:21 enterprise kernel: [23752.263896] nfsd            D
0000000000000000     0  1540      2 0x00000000
Oct 27 14:48:21 enterprise kernel: [23752.263903]  ffff88032c35db38
0000000000000046 ffff880036bcc1a0 ffff88003602d800
Oct 27 14:48:21 enterprise kernel: [23752.263912]  ffff88032c35dfd8
ffff88032c35dfd8 ffff88032c35dfd8 00000000000144c0
Oct 27 14:48:21 enterprise kernel: [23752.263920]  ffff88032e5ddec0
ffff8800ba1a5ec0 ffff88032c35db48 ffff88032b893430
Oct 27 14:48:21 enterprise kernel: [23752.263929] Call Trace:
Oct 27 14:48:21 enterprise kernel: [23752.264156]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:48:21 enterprise kernel: [23752.264620]
[<ffffffffa01642f1>] wait_current_trans.isra.33+0xc1/0x120 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.265110]
[<ffffffff8108cc40>] ? add_wait_queue+0x60/0x60
Oct 27 14:48:21 enterprise kernel: [23752.265601]
[<ffffffffa016615e>] start_transaction.part.35+0x2ee/0x510 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.266081]
[<ffffffffa01663a9>] start_transaction+0x29/0x30 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.266556]
[<ffffffffa01665fb>] btrfs_start_transaction+0x1b/0x20 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.267031]
[<ffffffffa01744b6>] btrfs_create+0x46/0x220 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.267541]
[<ffffffff812fb7fc>] ? security_inode_permission+0x1c/0x30
Oct 27 14:48:21 enterprise kernel: [23752.267949]
[<ffffffff811cc0b5>] vfs_create+0xb5/0x120
Oct 27 14:48:21 enterprise kernel: [23752.268420]
[<ffffffffa065941c>] do_nfsd_create+0x50c/0x5f0 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.268883]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.269398]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.269868]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.270329]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.270782]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.271234]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.271698]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:48:21 enterprise kernel: [23752.272099]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.272557]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.273071]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.273465] INFO: task nfsd:1542
blocked for more than 120 seconds.
Oct 27 14:48:21 enterprise kernel: [23752.273934]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:48:21 enterprise kernel: [23752.274439] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:48:21 enterprise kernel: [23752.274903] nfsd            D
0000000000000000     0  1542      2 0x00000000
Oct 27 14:48:21 enterprise kernel: [23752.275386]  ffff88032bf51b38
0000000000000046 ffff880036bcc1a0 ffff88032af0d800
Oct 27 14:48:21 enterprise kernel: [23752.275815]  ffff88032bf51fd8
ffff88032bf51fd8 ffff88032bf51fd8 00000000000144c0
Oct 27 14:48:21 enterprise kernel: [23752.276296]  ffffffff81c144a0
ffff8800baab4710 ffff88032bf51b48 ffff88032b893430
Oct 27 14:48:21 enterprise kernel: [23752.276779] Call Trace:
Oct 27 14:48:21 enterprise kernel: [23752.277252]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:48:21 enterprise kernel: [23752.277740]
[<ffffffffa01642f1>] wait_current_trans.isra.33+0xc1/0x120 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.278214]
[<ffffffff8108cc40>] ? add_wait_queue+0x60/0x60
Oct 27 14:48:21 enterprise kernel: [23752.278704]
[<ffffffffa016615e>] start_transaction.part.35+0x2ee/0x510 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.279239]
[<ffffffffa01663a9>] start_transaction+0x29/0x30 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.279680]
[<ffffffffa01665fb>] btrfs_start_transaction+0x1b/0x20 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.280162]
[<ffffffffa01744b6>] btrfs_create+0x46/0x220 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.280628]
[<ffffffff812fb7fc>] ? security_inode_permission+0x1c/0x30
Oct 27 14:48:21 enterprise kernel: [23752.281101]
[<ffffffff811cc0b5>] vfs_create+0xb5/0x120
Oct 27 14:48:21 enterprise kernel: [23752.281571]
[<ffffffffa065941c>] do_nfsd_create+0x50c/0x5f0 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.282051]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.282520]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.282997]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.283518]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.283949]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.284421]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.284891]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:48:21 enterprise kernel: [23752.285363]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.285836]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.286310]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.286782] INFO: task nfsd:1543
blocked for more than 120 seconds.
Oct 27 14:48:21 enterprise kernel: [23752.287311]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:48:21 enterprise kernel: [23752.287747] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:48:21 enterprise kernel: [23752.288235] nfsd            D
0000000000000000     0  1543      2 0x00000000
Oct 27 14:48:21 enterprise kernel: [23752.288731]  ffff88032b46bb38
0000000000000046 ffff880036bcc1a0 ffff88032cced800
Oct 27 14:48:21 enterprise kernel: [23752.289235]  ffff88032b46bfd8
ffff88032b46bfd8 ffff88032b46bfd8 00000000000144c0
Oct 27 14:48:21 enterprise kernel: [23752.289740]  ffff88032e5ddec0
ffff8800baab5ec0 ffff88032b46bb48 ffff88032b893430
Oct 27 14:48:21 enterprise kernel: [23752.290247] Call Trace:
Oct 27 14:48:21 enterprise kernel: [23752.290740]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:48:21 enterprise kernel: [23752.291288]
[<ffffffffa01642f1>] wait_current_trans.isra.33+0xc1/0x120 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.291724]
[<ffffffff8108cc40>] ? add_wait_queue+0x60/0x60
Oct 27 14:48:21 enterprise kernel: [23752.292220]
[<ffffffffa016615e>] start_transaction.part.35+0x2ee/0x510 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.292712]
[<ffffffffa01663a9>] start_transaction+0x29/0x30 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.293200]
[<ffffffffa01665fb>] btrfs_start_transaction+0x1b/0x20 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.293695]
[<ffffffffa01744b6>] btrfs_create+0x46/0x220 [btrfs]
Oct 27 14:48:21 enterprise kernel: [23752.294173]
[<ffffffff812fb7fc>] ? security_inode_permission+0x1c/0x30
Oct 27 14:48:21 enterprise kernel: [23752.294660]
[<ffffffff811cc0b5>] vfs_create+0xb5/0x120
Oct 27 14:48:21 enterprise kernel: [23752.295148]
[<ffffffffa065941c>] do_nfsd_create+0x50c/0x5f0 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.295652]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.296113]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.296603]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.297086]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:48:21 enterprise kernel: [23752.297564]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.298046]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:48:21 enterprise kernel: [23752.298522]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:48:21 enterprise kernel: [23752.299002]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.299498]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:48:21 enterprise kernel: [23752.299957]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.257224] INFO: task nfsd:1536
blocked for more than 120 seconds.
Oct 27 14:50:15 enterprise kernel: [23872.257489]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:50:15 enterprise kernel: [23872.257716] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:50:15 enterprise kernel: [23872.258178] nfsd            D
0000000000000000     0  1536      2 0x00000000
Oct 27 14:50:15 enterprise kernel: [23872.258683]  ffff8800ba19bc38
0000000000000046 ffff8800ba19bbe8 ffffffff81094340
Oct 27 14:50:15 enterprise kernel: [23872.259190]  ffff8800ba19bfd8
ffff8800ba19bfd8 ffff8800ba19bfd8 00000000000144c0
Oct 27 14:50:15 enterprise kernel: [23872.259699]  ffff88032e08af60
ffff8800ba1a0000 ffff8800ba19bc18 ffff8802f2573408
Oct 27 14:50:15 enterprise kernel: [23872.260201] Call Trace:
Oct 27 14:50:15 enterprise kernel: [23872.260703]
[<ffffffff81094340>] ? set_groups+0x40/0x60
Oct 27 14:50:15 enterprise kernel: [23872.261198]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:50:15 enterprise kernel: [23872.261680]
[<ffffffff8174509e>] schedule_preempt_disabled+0xe/0x10
Oct 27 14:50:15 enterprise kernel: [23872.262169]
[<ffffffff81743024>] __mutex_lock_slowpath+0x114/0x1b0
Oct 27 14:50:15 enterprise kernel: [23872.262655]
[<ffffffff817430e3>] mutex_lock+0x23/0x40
Oct 27 14:50:15 enterprise kernel: [23872.263138]
[<ffffffffa0659088>] do_nfsd_create+0x178/0x5f0 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.263616]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.264095]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.264579]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.265145]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.265526]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.265996]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.266463]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:50:15 enterprise kernel: [23872.266929]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.267395]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.267862]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.268326] INFO: task nfsd:1537
blocked for more than 120 seconds.
Oct 27 14:50:15 enterprise kernel: [23872.268793]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:50:15 enterprise kernel: [23872.269377] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:50:15 enterprise kernel: [23872.269746] nfsd            D
0000000000000000     0  1537      2 0x00000000
Oct 27 14:50:15 enterprise kernel: [23872.270233]  ffff8800ba29db38
0000000000000046 ffff880036bcc1a0 ffff88003602b800
Oct 27 14:50:15 enterprise kernel: [23872.270731]  ffff8800ba29dfd8
ffff8800ba29dfd8 ffff8800ba29dfd8 00000000000144c0
Oct 27 14:50:15 enterprise kernel: [23872.271226]  ffff880329daaf60
ffff8800ba1a17b0 ffff8800ba29db48 ffff88032b893430
Oct 27 14:50:15 enterprise kernel: [23872.271722] Call Trace:
Oct 27 14:50:15 enterprise kernel: [23872.272206]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:50:15 enterprise kernel: [23872.272706]
[<ffffffffa01642f1>] wait_current_trans.isra.33+0xc1/0x120 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.273293]
[<ffffffff8108cc40>] ? add_wait_queue+0x60/0x60
Oct 27 14:50:15 enterprise kernel: [23872.273683]
[<ffffffffa016615e>] start_transaction.part.35+0x2ee/0x510 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.274178]
[<ffffffffa01663a9>] start_transaction+0x29/0x30 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.274670]
[<ffffffffa01665fb>] btrfs_start_transaction+0x1b/0x20 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.275158]
[<ffffffffa01744b6>] btrfs_create+0x46/0x220 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.275632]
[<ffffffff812fb7fc>] ? security_inode_permission+0x1c/0x30
Oct 27 14:50:15 enterprise kernel: [23872.276105]
[<ffffffff811cc0b5>] vfs_create+0xb5/0x120
Oct 27 14:50:15 enterprise kernel: [23872.276585]
[<ffffffffa065941c>] do_nfsd_create+0x50c/0x5f0 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.277120]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.277545]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.278021]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.278498]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.278970]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.279435]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.279902]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:50:15 enterprise kernel: [23872.280365]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.280834]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.281410]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.281763] INFO: task nfsd:1538
blocked for more than 120 seconds.
Oct 27 14:50:15 enterprise kernel: [23872.282230]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:50:15 enterprise kernel: [23872.282697] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:50:15 enterprise kernel: [23872.283175] nfsd            D
0000000000000000     0  1538      2 0x00000000
Oct 27 14:50:15 enterprise kernel: [23872.283659]  ffff8800ba397c38
0000000000000046 ffff8800ba397be8 ffffffff81094340
Oct 27 14:50:15 enterprise kernel: [23872.284152]  ffff8800ba397fd8
ffff8800ba397fd8 ffff8800ba397fd8 00000000000144c0
Oct 27 14:50:15 enterprise kernel: [23872.284648]  ffff88032a21dec0
ffff8800ba1a2f60 ffff8800ba397c18 ffff8802f2573408
Oct 27 14:50:15 enterprise kernel: [23872.285242] Call Trace:
Oct 27 14:50:15 enterprise kernel: [23872.285621]
[<ffffffff81094340>] ? set_groups+0x40/0x60
Oct 27 14:50:15 enterprise kernel: [23872.286102]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:50:15 enterprise kernel: [23872.286585]
[<ffffffff8174509e>] schedule_preempt_disabled+0xe/0x10
Oct 27 14:50:15 enterprise kernel: [23872.287073]
[<ffffffff81743024>] __mutex_lock_slowpath+0x114/0x1b0
Oct 27 14:50:15 enterprise kernel: [23872.287559]
[<ffffffff817430e3>] mutex_lock+0x23/0x40
Oct 27 14:50:15 enterprise kernel: [23872.288037]
[<ffffffffa0659088>] do_nfsd_create+0x178/0x5f0 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.288512]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.288982]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.289563]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.289918]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.290383]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.290848]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.291307]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:50:15 enterprise kernel: [23872.291769]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.292234]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.292699]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.293270] INFO: task nfsd:1539
blocked for more than 120 seconds.
Oct 27 14:50:15 enterprise kernel: [23872.293631]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:50:15 enterprise kernel: [23872.294100] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:50:15 enterprise kernel: [23872.294577] nfsd            D
0000000000000000     0  1539      2 0x00000000
Oct 27 14:50:15 enterprise kernel: [23872.295063]  ffff88032d783c38
0000000000000046 ffff88032d783be8 ffffffff81094340
Oct 27 14:50:15 enterprise kernel: [23872.295557]  ffff88032d783fd8
ffff88032d783fd8 ffff88032d783fd8 00000000000144c0
Oct 27 14:50:15 enterprise kernel: [23872.296048]  ffff88032e5ddec0
ffff8800ba1a4710 ffff88032d783c18 ffff8802f2573408
Oct 27 14:50:15 enterprise kernel: [23872.296537] Call Trace:
Oct 27 14:50:15 enterprise kernel: [23872.297018]
[<ffffffff81094340>] ? set_groups+0x40/0x60
Oct 27 14:50:15 enterprise kernel: [23872.297615]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:50:15 enterprise kernel: [23872.297988]
[<ffffffff8174509e>] schedule_preempt_disabled+0xe/0x10
Oct 27 14:50:15 enterprise kernel: [23872.298476]
[<ffffffff81743024>] __mutex_lock_slowpath+0x114/0x1b0
Oct 27 14:50:15 enterprise kernel: [23872.298960]
[<ffffffff817430e3>] mutex_lock+0x23/0x40
Oct 27 14:50:15 enterprise kernel: [23872.299441]
[<ffffffffa0659088>] do_nfsd_create+0x178/0x5f0 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.299916]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.300385]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.300858]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.301437]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.301792]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.302256]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.302717]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:50:15 enterprise kernel: [23872.303178]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.303635]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.304092]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.304549] INFO: task nfsd:1540
blocked for more than 120 seconds.
Oct 27 14:50:15 enterprise kernel: [23872.305006]       Not tainted
3.12.0-999-generic #201310210405
Oct 27 14:50:15 enterprise kernel: [23872.305563] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 27 14:50:15 enterprise kernel: [23872.305938] nfsd            D
0000000000000000     0  1540      2 0x00000000
Oct 27 14:50:15 enterprise kernel: [23872.306415]  ffff88032c35db38
0000000000000046 ffff880036bcc1a0 ffff88003602d800
Oct 27 14:50:15 enterprise kernel: [23872.306899]  ffff88032c35dfd8
ffff88032c35dfd8 ffff88032c35dfd8 00000000000144c0
Oct 27 14:50:15 enterprise kernel: [23872.307380]  ffff88032e5ddec0
ffff8800ba1a5ec0 ffff88032c35db48 ffff88032b893430
Oct 27 14:50:15 enterprise kernel: [23872.307865] Call Trace:
Oct 27 14:50:15 enterprise kernel: [23872.308340]
[<ffffffff81744d79>] schedule+0x29/0x70
Oct 27 14:50:15 enterprise kernel: [23872.308823]
[<ffffffffa01642f1>] wait_current_trans.isra.33+0xc1/0x120 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.309383]
[<ffffffff8108cc40>] ? add_wait_queue+0x60/0x60
Oct 27 14:50:15 enterprise kernel: [23872.309783]
[<ffffffffa016615e>] start_transaction.part.35+0x2ee/0x510 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.310266]
[<ffffffffa01663a9>] start_transaction+0x29/0x30 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.310754]
[<ffffffffa01665fb>] btrfs_start_transaction+0x1b/0x20 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.311245]
[<ffffffffa01744b6>] btrfs_create+0x46/0x220 [btrfs]
Oct 27 14:50:15 enterprise kernel: [23872.311722]
[<ffffffff812fb7fc>] ? security_inode_permission+0x1c/0x30
Oct 27 14:50:15 enterprise kernel: [23872.312205]
[<ffffffff811cc0b5>] vfs_create+0xb5/0x120
Oct 27 14:50:15 enterprise kernel: [23872.312694]
[<ffffffffa065941c>] do_nfsd_create+0x50c/0x5f0 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.313259]
[<ffffffffa06608ad>] nfsd3_proc_create+0x16d/0x250 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.313648]
[<ffffffffa0651d65>] nfsd_dispatch+0xe5/0x230 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.314117]
[<ffffffffa05dbf55>] svc_process_common+0x345/0x680 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.314584]
[<ffffffffa05dc5e3>] svc_process+0x103/0x160 [sunrpc]
Oct 27 14:50:15 enterprise kernel: [23872.315052]
[<ffffffffa06518cf>] nfsd+0xbf/0x130 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.315519]
[<ffffffffa0651810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 27 14:50:15 enterprise kernel: [23872.315983]
[<ffffffff8108c0e0>] kthread+0xc0/0xd0
Oct 27 14:50:15 enterprise kernel: [23872.316446]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.316913]
[<ffffffff8174f6fc>] ret_from_fork+0x7c/0xb0
Oct 27 14:50:15 enterprise kernel: [23872.317470]
[<ffffffff8108c020>] ? flush_kthread_worker+0xb0/0xb0
Oct 27 15:19:10 enterprise CRON[4310]: (root) CMD (   cd / &&
run-parts --report /etc/cron.hourly)
Oct 27 16:07:32 enterprise kernel: [28472.130147] rpcbind invoked
oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
Oct 27 16:07:32 enterprise kernel: [28472.130376] rpcbind cpuset=/
mems_allowed=0
Oct 27 16:07:32 enterprise kernel: [28472.130593] CPU: 0 PID: 891
Comm: rpcbind Not tainted 3.12.0-999-generic #201310210405
Oct 27 16:07:32 enterprise kernel: [28472.131065] Hardware name:
System manufacturer System Product Name/P6T SE, BIOS 0805
02/24/2010
Oct 27 16:07:32 enterprise kernel: [28472.131559]  0000000000000000
ffff8800363c9378 ffffffff81739f5f 0000000000000007
Oct 27 16:07:32 enterprise kernel: [28472.132066]  ffff88032cc0c710
ffff8800363c93c8 ffffffff8172f2f3 ffff880000000000
Oct 27 16:07:32 enterprise kernel: [28472.132573]  000200da8137e978
ffff88032dcd97b0 ffff88032a110000 0000000000000000
Oct 27 16:07:32 enterprise kernel: [28472.133072] Call Trace:
Oct 27 16:07:32 enterprise kernel: [28472.133572]
[<ffffffff81739f5f>] dump_stack+0x46/0x58
Oct 27 16:07:32 enterprise kernel: [28472.134165]
[<ffffffff8172f2f3>] dump_header+0x7e/0xbd
Oct 27 16:07:32 enterprise kernel: [28472.134564]
[<ffffffff8172f389>] oom_kill_process.part.6+0x57/0x2d4
Oct 27 16:07:32 enterprise kernel: [28472.135068]
[<ffffffff81151eed>] oom_kill_process+0x4d/0x50
Oct 27 16:07:32 enterprise kernel: [28472.135565]
[<ffffffff81152225>] out_of_memory+0x145/0x1d0
Oct 27 16:07:32 enterprise kernel: [28472.136056]
[<ffffffff811580f9>] __alloc_pages_nodemask+0xa19/0xa30
Oct 27 16:07:32 enterprise kernel: [28472.136541]
[<ffffffff8119adf3>] alloc_pages_vma+0xa3/0x150
Oct 27 16:07:32 enterprise kernel: [28472.137023]
[<ffffffff8118cf7b>] read_swap_cache_async+0x10b/0x190
Oct 27 16:07:32 enterprise kernel: [28472.137502]
[<ffffffff8118d09e>] swapin_readahead+0x9e/0xf0
Oct 27 16:07:32 enterprise kernel: [28472.138030]
[<ffffffff81177df5>] do_swap_page.isra.49+0x125/0x600

Nothing - complete hard lockup, no ping responses etc. until 19:30
when the system was restarted.


Regards
Sean Clarke
---------------------------------------------
SEC Consulting Limited
Phone: +44 (0)23 8040 5599
Website: http://www.sec-consulting.co.uk
Email: sean.clarke@sec-consulting.co.uk


On Sun, Oct 27, 2013 at 9:06 AM, Sean Clarke
<sean.clarke@sec-consulting.co.uk> wrote:
> Hi Chris,
>    I set dmesg -n7 and didn't see anything extra logged (I had to use
> sudo to enable it. I am not familiar with sysrq-w and sysrq-t, however
> you ask "while it is locked", this is a "real" hard lock. everything
> is unresponsive and the machine even fails to respond to ping request.
> It happened again over night and again the only clues where the
> btrfs-transaction and btrfs-flush_del going ballistic.
>
> Regards
> Sean Clarke
> ---------------------------------------------
> SEC Consulting Limited
> Phone: +44 (0)23 8040 5599
> Website: http://www.sec-consulting.co.uk
> Email: sean.clarke@sec-consulting.co.uk
>
>
> On Thu, Oct 24, 2013 at 9:47 AM, Chris Mason <chris.mason@fusionio.com> wrote:
>> Quoting Sean Clarke (2013-10-23 15:26:15)
>>> Hi,
>>>    I have an Intel Core i7 based fileserver with 18TB BTRFS in a 6x
>>> 3TB RAID 1+0 configuration. The system was working fine running Ubuntu
>>> 13.04 (kernel 3.11.0-12-generic). The system was upgraded to Ubuntu
>>> 13.10 (kernel 3.11) and began to lock up daily, sometimes every couple
>>> of hours. Previously it never crashed and was only taken down for
>>> maintenance so a bug was files on launchpad
>>> (https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1237794).
>>
>> Does your kernel  config include the softlockup detector?  If you could
>> please do sysrq-w and sysrq-t while it is locked, it'll help us track it
>> down.
>>
>> It will be much easier if you have a serial console or network console,
>> and you've increased your kernel logging level to the highest value
>> (dmesg -n7)
>>
>> -chris
