Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD645C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A91920659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfANLmX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:42:23 -0500
Received: from aquinas.techsquare.com ([75.125.237.226]:45634 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726460AbfANLmW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 06:42:22 -0500
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1gj0dF-00038Q-R4; Mon, 14 Jan 2019 06:42:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23612.30105.728099.63687@techsquare.com>
Date:   Mon, 14 Jan 2019 06:42:17 -0500
To:     "Scott E. Blomquist" <sb@techsquare.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jojo <jojo@automatix.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs hang on nfs?
In-Reply-To: <23607.13250.659000.140295@techsquare.com>
References: <23605.54017.819143.292441@techsquare.com>
        <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
        <23605.63394.330818.203495@techsquare.com>
        <23607.12444.740949.683554@techsquare.com>
        <f95b63e3-9da5-ea60-3b4c-fbdf223f439c@suse.com>
        <23607.13250.659000.140295@techsquare.com>
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Scott E. Blomquist writes:
 > Nikolay Borisov writes:
 > 
 > Thanks.  I have not seen the free space cache message with the new
 > kernel.
 > 
 > Next time the hang pops up I'll echo w > /proc/sysrq-trigger and send
 > it along.
 > 
 > I am hoping that the new kernel will magically fix the problem.
 > 
 > Thanks again,
 > 
 > sb. Scott Blomquist

The file system hung again below is the sysrq output

Linux kanlabfs 4.19.13-custom #1 SMP Wed Jan 9 08:36:50 EST 2019 x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.19.1 

# btrfs fi df /export/
Data, single: total=79.61TiB, used=79.61TiB
System, single: total=36.00MiB, used=8.31MiB
Metadata, single: total=192.01GiB, used=190.19GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

#  btrfs fi show
Label: '/export'  uuid: 8f92c2e4-86fe-48cb-b2d3-bc36da765f02
        Total devices 3 FS bytes used 79.79TiB
        devid    1 size 47.30TiB used 43.58TiB path /dev/sda1
        devid    2 size 21.83TiB used 18.11TiB path /dev/sdb1
        devid    3 size 21.83TiB used 18.11TiB path /dev/sdc1

[Mon Jan 14 06:24:26 2019] sysrq: SysRq : Show Blocked State
[Mon Jan 14 06:24:26 2019]   task                        PC stack   pid father
[Mon Jan 14 06:24:26 2019] nmbd            D    0   944      1 0x00000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  schedule_timeout+0x14d/0x2e0
[Mon Jan 14 06:24:26 2019]  ? __next_timer_interrupt+0xd0/0xd0
[Mon Jan 14 06:24:26 2019]  io_schedule_timeout+0x19/0x40
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages+0x726/0x90e
[Mon Jan 14 06:24:26 2019]  ? __wake_up_common_lock+0x77/0x90
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages_ratelimited+0x254/0x3b0
[Mon Jan 14 06:24:26 2019]  fault_dirty_shared_page.isra.83+0x4a/0x90
[Mon Jan 14 06:24:26 2019]  do_wp_page+0x3e1/0x4d0
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  __handle_mm_fault+0x6ff/0x13a0
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  handle_mm_fault+0xfa/0x210
[Mon Jan 14 06:24:26 2019]  __do_page_fault+0x1fd/0x4f0
[Mon Jan 14 06:24:26 2019]  ? page_fault+0x8/0x30
[Mon Jan 14 06:24:26 2019]  page_fault+0x1e/0x30
[Mon Jan 14 06:24:26 2019] RIP: 0033:0x7f7032a41aba
[Mon Jan 14 06:24:26 2019] Code: Bad RIP value.
[Mon Jan 14 06:24:26 2019] RSP: 002b:00007fff0d205978 EFLAGS: 00010206
[Mon Jan 14 06:24:26 2019] RAX: ffffd6dd41976d84 RBX: 0000564d782587e0 RCX: 0000000000004058
[Mon Jan 14 06:24:26 2019] RDX: 000000000000202c RSI: 0000564d7825cdb0 RDI: 00007f70368e4000
[Mon Jan 14 06:24:26 2019] RBP: 0000000000000000 R08: 00002922be684248 R09: 00002922be684238
[Mon Jan 14 06:24:26 2019] R10: 00002922be684228 R11: 0000000000000201 R12: 000000000000202c
[Mon Jan 14 06:24:26 2019] R13: 0000000000003000 R14: 0000564d782587e0 R15: 0000564d7825cdb0
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1448      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? iput+0x6f/0x1b0
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  rwsem_down_write_failed+0x1ca/0x330
[Mon Jan 14 06:24:26 2019]  call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 14 06:24:26 2019]  down_write+0x29/0x40
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0xac/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1449      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? iput+0x6f/0x1b0
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  rwsem_down_write_failed+0x1ca/0x330
[Mon Jan 14 06:24:26 2019]  call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 14 06:24:26 2019]  down_write+0x29/0x40
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0xac/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1450      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? iput+0x6f/0x1b0
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  rwsem_down_write_failed+0x1ca/0x330
[Mon Jan 14 06:24:26 2019]  call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 14 06:24:26 2019]  down_write+0x29/0x40
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0xac/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1451      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? iput+0x6f/0x1b0
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  rwsem_down_write_failed+0x1ca/0x330
[Mon Jan 14 06:24:26 2019]  call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 14 06:24:26 2019]  down_write+0x29/0x40
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0xac/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1452      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? iput+0x6f/0x1b0
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  rwsem_down_write_failed+0x1ca/0x330
[Mon Jan 14 06:24:26 2019]  call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 14 06:24:26 2019]  down_write+0x29/0x40
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0xac/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1453      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? iput+0x6f/0x1b0
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  rwsem_down_write_failed+0x1ca/0x330
[Mon Jan 14 06:24:26 2019]  call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 14 06:24:26 2019]  down_write+0x29/0x40
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0xac/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1454      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? iput+0x6f/0x1b0
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  rwsem_down_write_failed+0x1ca/0x330
[Mon Jan 14 06:24:26 2019]  call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 14 06:24:26 2019]  down_write+0x29/0x40
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0xac/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nfsd            D    0  1455      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x263/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_cont_expand+0x3e6/0x580 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_file_write_iter+0x3e8/0x560 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_iter_readv_writev+0x110/0x170
[Mon Jan 14 06:24:26 2019]  do_iter_write+0x78/0x180
[Mon Jan 14 06:24:26 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_write+0x84/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd3_proc_write+0xd9/0x160 [nfsd]
[Mon Jan 14 06:24:26 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
[Mon Jan 14 06:24:26 2019]  svc_process_common+0x382/0x730 [sunrpc]
[Mon Jan 14 06:24:26 2019]  svc_process+0xeb/0x100 [sunrpc]
[Mon Jan 14 06:24:26 2019]  nfsd+0xe3/0x150 [nfsd]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] nscd            D    0  1508      1 0x00000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  schedule_timeout+0x14d/0x2e0
[Mon Jan 14 06:24:26 2019]  ? __next_timer_interrupt+0xd0/0xd0
[Mon Jan 14 06:24:26 2019]  io_schedule_timeout+0x19/0x40
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages+0x726/0x90e
[Mon Jan 14 06:24:26 2019]  ? __wake_up_common_lock+0x77/0x90
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages_ratelimited+0x254/0x3b0
[Mon Jan 14 06:24:26 2019]  fault_dirty_shared_page.isra.83+0x4a/0x90
[Mon Jan 14 06:24:26 2019]  do_wp_page+0x3e1/0x4d0
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  __handle_mm_fault+0x6ff/0x13a0
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  handle_mm_fault+0xfa/0x210
[Mon Jan 14 06:24:26 2019]  __do_page_fault+0x1fd/0x4f0
[Mon Jan 14 06:24:26 2019]  ? page_fault+0x8/0x30
[Mon Jan 14 06:24:26 2019]  page_fault+0x1e/0x30
[Mon Jan 14 06:24:26 2019] RIP: 0033:0x556ee8b26a90
[Mon Jan 14 06:24:26 2019] Code: Bad RIP value.
[Mon Jan 14 06:24:26 2019] RSP: 002b:00007fb600dd2af0 EFLAGS: 00010246
[Mon Jan 14 06:24:26 2019] RAX: 00007fb606fa06b8 RBX: 00000000ffffffff RCX: 00007fb606fa0848
[Mon Jan 14 06:24:26 2019] RDX: 00000000000002c0 RSI: 0000556ee8d3a228 RDI: 00007fb600dd2af0
[Mon Jan 14 06:24:26 2019] RBP: 00007fb600dd2d90 R08: 0000000000000079 R09: 0000000000000079
[Mon Jan 14 06:24:26 2019] R10: 000000005c3c70bd R11: 0000556ee8d3ade8 R12: 0000000000000000
[Mon Jan 14 06:24:26 2019] R13: 0000000000000000 R14: 00007fb606fa03c8 R15: 000000005c3c7103
[Mon Jan 14 06:24:26 2019] nscd            D    0  1509      1 0x00000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  schedule_timeout+0x14d/0x2e0
[Mon Jan 14 06:24:26 2019]  ? __next_timer_interrupt+0xd0/0xd0
[Mon Jan 14 06:24:26 2019]  io_schedule_timeout+0x19/0x40
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages+0x726/0x90e
[Mon Jan 14 06:24:26 2019]  ? __wake_up_common_lock+0x77/0x90
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages_ratelimited+0x254/0x3b0
[Mon Jan 14 06:24:26 2019]  fault_dirty_shared_page.isra.83+0x4a/0x90
[Mon Jan 14 06:24:26 2019]  do_wp_page+0x3e1/0x4d0
[Mon Jan 14 06:24:26 2019]  __handle_mm_fault+0x6ff/0x13a0
[Mon Jan 14 06:24:26 2019]  handle_mm_fault+0xfa/0x210
[Mon Jan 14 06:24:26 2019]  __do_page_fault+0x1fd/0x4f0
[Mon Jan 14 06:24:26 2019]  ? page_fault+0x8/0x30
[Mon Jan 14 06:24:26 2019]  page_fault+0x1e/0x30
[Mon Jan 14 06:24:26 2019] RIP: 0033:0x556ee8b21cf3
[Mon Jan 14 06:24:26 2019] Code: Bad RIP value.
[Mon Jan 14 06:24:26 2019] RSP: 002b:00007fb600bd1340 EFLAGS: 00010246
[Mon Jan 14 06:24:26 2019] RAX: 0000000000000019 RBX: 00007fb600bd1350 RCX: 00007fb602fd5e10
[Mon Jan 14 06:24:26 2019] RDX: 00000000000000ea RSI: 00007fb602fd5e6e RDI: 00007fb600bd13ae
[Mon Jan 14 06:24:26 2019] RBP: 00007fb600bd1570 R08: 0000000000000008 R09: 00007fb600bd139d
[Mon Jan 14 06:24:26 2019] R10: 00007fb600bd139d R11: 00007fb60dd70150 R12: 00007fb600bd1a20
[Mon Jan 14 06:24:26 2019] R13: 0000000000000001 R14: 00007fb600bd139d R15: 0000000000000001
[Mon Jan 14 06:24:26 2019] btrfs-transacti D    0  6808      2 0x80000000
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  btrfs_start_ordered_extent+0xca/0x100 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  btrfs_wait_ordered_range+0xbd/0x110 [btrfs]
[Mon Jan 14 06:24:26 2019]  __btrfs_wait_cache_io+0x49/0x1a0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_write_dirty_block_groups+0xed/0x360 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? btrfs_run_delayed_refs+0x8b/0x1d0 [btrfs]
[Mon Jan 14 06:24:26 2019]  commit_cowonly_roots+0x1ed/0x280 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_commit_transaction+0x36e/0x8d0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? start_transaction+0x9b/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  transaction_kthread+0x14d/0x180 [btrfs]
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] rsync           D    0 17161  16189 0x00000004
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_dirty_inode+0x49/0xe0 [btrfs]
[Mon Jan 14 06:24:26 2019]  touch_atime+0x8a/0xb0
[Mon Jan 14 06:24:26 2019]  generic_file_read_iter+0x835/0xa30
[Mon Jan 14 06:24:26 2019]  ? page_cache_tree_insert+0xa0/0xa0
[Mon Jan 14 06:24:26 2019]  __vfs_read+0xea/0x150
[Mon Jan 14 06:24:26 2019]  vfs_read+0x89/0x130
[Mon Jan 14 06:24:26 2019]  ksys_read+0x42/0x90
[Mon Jan 14 06:24:26 2019]  do_syscall_64+0x55/0x110
[Mon Jan 14 06:24:26 2019]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[Mon Jan 14 06:24:26 2019] RIP: 0033:0x7fa5c0c8c360
[Mon Jan 14 06:24:26 2019] Code: Bad RIP value.
[Mon Jan 14 06:24:26 2019] RSP: 002b:00007ffca2f09c18 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[Mon Jan 14 06:24:26 2019] RAX: ffffffffffffffda RBX: 0000000008060840 RCX: 00007fa5c0c8c360
[Mon Jan 14 06:24:26 2019] RDX: 0000000000040000 RSI: 000000001008d420 RDI: 0000000000000003
[Mon Jan 14 06:24:26 2019] RBP: 0000000000040000 R08: 00000000000c0031 R09: 00007fa5c0f5f7b8
[Mon Jan 14 06:24:26 2019] R10: 00007fa5c0f5f7b8 R11: 0000000000000246 R12: 0000000000000000
[Mon Jan 14 06:24:26 2019] R13: 0000000000040000 R14: 0000000000000000 R15: 0000000000000000
[Mon Jan 14 06:24:26 2019] kworker/u18:4   D    0  5653      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:3   D    0  6259      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:1   D    0  7082      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:5   D    0  7413      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u16:1   D    0  7415      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-freespace-write btrfs_freespace_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  schedule_timeout+0x14d/0x2e0
[Mon Jan 14 06:24:26 2019]  ? __next_timer_interrupt+0xd0/0xd0
[Mon Jan 14 06:24:26 2019]  io_schedule_timeout+0x19/0x40
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages+0x726/0x90e
[Mon Jan 14 06:24:26 2019]  balance_dirty_pages_ratelimited+0x254/0x3b0
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x3d3/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x14/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:0   D    0  7644      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:6   D    0  7695      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:7   D    0  7696      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:9   D    0  7698      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_finish_ordered_io+0x453/0x7c0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  ? syscall_return_via_sysret+0x13/0x83
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x40/0x70
[Mon Jan 14 06:24:26 2019]  ? __switch_to_asm+0x34/0x70
[Mon Jan 14 06:24:26 2019]  normal_work_helper+0xcc/0x310 [btrfs]
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
[Mon Jan 14 06:24:26 2019] kworker/u18:10  D    0  7700      2 0x80000000
[Mon Jan 14 06:24:26 2019] Workqueue: writeback wb_workfn (flush-btrfs-1)
[Mon Jan 14 06:24:26 2019] Call Trace:
[Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
[Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
[Mon Jan 14 06:24:26 2019]  wait_current_trans+0x87/0xd0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
[Mon Jan 14 06:24:26 2019]  start_transaction+0x1ef/0x3f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  find_free_extent+0xf96/0x1080 [btrfs]
[Mon Jan 14 06:24:26 2019]  btrfs_reserve_extent+0xf6/0x1f0 [btrfs]
[Mon Jan 14 06:24:26 2019]  cow_file_range.isra.68+0x119/0x440 [btrfs]
[Mon Jan 14 06:24:26 2019]  run_delalloc_range+0xff/0x380 [btrfs]
[Mon Jan 14 06:24:26 2019]  writepage_delalloc+0xfb/0x150 [btrfs]
[Mon Jan 14 06:24:26 2019]  __extent_writepage+0xdf/0x2b0 [btrfs]
[Mon Jan 14 06:24:26 2019]  ? invalid_page_referenced_vma+0x90/0x90
[Mon Jan 14 06:24:26 2019]  extent_write_cache_pages+0x22f/0x3d0 [btrfs]
[Mon Jan 14 06:24:26 2019]  extent_writepages+0x3f/0x60 [btrfs]
[Mon Jan 14 06:24:26 2019]  do_writepages+0x1a/0x70
[Mon Jan 14 06:24:26 2019]  __writeback_single_inode+0x3d/0x340
[Mon Jan 14 06:24:26 2019]  ? update_load_avg+0x94/0x5e0
[Mon Jan 14 06:24:26 2019]  writeback_sb_inodes+0x224/0x480
[Mon Jan 14 06:24:26 2019]  __writeback_inodes_wb+0x87/0xb0
[Mon Jan 14 06:24:26 2019]  wb_writeback+0x258/0x2f0
[Mon Jan 14 06:24:26 2019]  wb_workfn+0x190/0x430
[Mon Jan 14 06:24:26 2019]  process_one_work+0x165/0x370
[Mon Jan 14 06:24:26 2019]  worker_thread+0x49/0x3e0
[Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
[Mon Jan 14 06:24:26 2019]  ? rescuer_thread+0x2f0/0x2f0
[Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
[Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40

Thanks for any help.

sb. Scott Blomquist
