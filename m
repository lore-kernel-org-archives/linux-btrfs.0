Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C0CC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 11:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E08F20652
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 11:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfAILgu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:36:50 -0500
Received: from aquinas.techsquare.com ([75.125.237.226]:51565 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730111AbfAILgt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2019 06:36:49 -0500
X-Greylist: delayed 2511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2019 06:36:49 EST
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1ghBVh-0007xB-R2
        for linux-btrfs@vger.kernel.org; Wed, 09 Jan 2019 05:54:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23605.54017.819143.292441@techsquare.com>
Date:   Wed, 9 Jan 2019 05:54:57 -0500
To:     linux-btrfs@vger.kernel.org
Subject: btrfs hang on nfs?
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hi All,

I have a system that has been hanging/wedging frequently.  It seems to
be load dependent but have not been able to isolate the problem.  The
only option once the hang happens is to reboot via
/proc/sysreq_trigger

In dmesg I see this...

    [Tue Jan  8 16:03:40 2019] perf: interrupt took too long (3193 > 3176), lowering kernel.perf_event_max_sample_rate to 62500
    [Tue Jan  8 16:25:19 2019] perf: interrupt took too long (4013 > 3991), lowering kernel.perf_event_max_sample_rate to 49750
    [Tue Jan  8 17:01:20 2019] perf: interrupt took too long (5043 > 5016), lowering kernel.perf_event_max_sample_rate to 39500
    [Tue Jan  8 17:16:47 2019] INFO: task btrfs-transacti:2098 blocked for more than 120 seconds.
    [Tue Jan  8 17:16:47 2019]       Not tainted 4.17.14-custom #1
    [Tue Jan  8 17:16:47 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [Tue Jan  8 17:16:47 2019] btrfs-transacti D    0  2098      2 0x80000000
    [Tue Jan  8 17:16:47 2019] Call Trace:
    [Tue Jan  8 17:16:47 2019]  ? __schedule+0x2cf/0x850
    [Tue Jan  8 17:16:47 2019]  schedule+0x32/0x80
    [Tue Jan  8 17:16:47 2019]  btrfs_start_ordered_extent+0xca/0x100 [btrfs]
    [Tue Jan  8 17:16:47 2019]  ? wait_woken+0x80/0x80
    [Tue Jan  8 17:16:47 2019]  btrfs_wait_ordered_range+0xbd/0x110 [btrfs]
    [Tue Jan  8 17:16:47 2019]  __btrfs_wait_cache_io+0x49/0x1a0 [btrfs]
    [Tue Jan  8 17:16:47 2019]  btrfs_write_dirty_block_groups+0xed/0x360 [btrfs]
    [Tue Jan  8 17:16:47 2019]  ? btrfs_run_delayed_refs+0x93/0x1e0 [btrfs]
    [Tue Jan  8 17:16:47 2019]  commit_cowonly_roots+0x1f0/0x280 [btrfs]
    [Tue Jan  8 17:16:47 2019]  btrfs_commit_transaction+0x3a2/0x910 [btrfs]
    [Tue Jan  8 17:16:47 2019]  ? start_transaction+0x9b/0x3f0 [btrfs]
    [Tue Jan  8 17:16:47 2019]  transaction_kthread+0x14d/0x180 [btrfs]
    [Tue Jan  8 17:16:47 2019]  kthread+0xf8/0x130
    [Tue Jan  8 17:16:47 2019]  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
    [Tue Jan  8 17:16:47 2019]  ? kthread_bind+0x10/0x10
    [Tue Jan  8 17:16:47 2019]  ret_from_fork+0x35/0x40
    [Tue Jan  8 17:16:47 2019] INFO: task nfsd:4154 blocked for more than 120 seconds.
    [Tue Jan  8 17:16:47 2019]       Not tainted 4.17.14-custom #1
    [Tue Jan  8 17:16:47 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [Tue Jan  8 17:16:47 2019] nfsd            D    0  4154      2 0x80000000
    [Tue Jan  8 17:16:47 2019] Call Trace:
    [Tue Jan  8 17:16:47 2019]  ? __schedule+0x2cf/0x850
    [Tue Jan  8 17:16:47 2019]  ? iput+0x6f/0x1b0
    [Tue Jan  8 17:16:47 2019]  schedule+0x32/0x80
    [Tue Jan  8 17:16:47 2019]  rwsem_down_write_failed+0x1e0/0x350
    [Tue Jan  8 17:16:47 2019]  call_rwsem_down_write_failed+0x13/0x20
    [Tue Jan  8 17:16:47 2019]  down_write+0x29/0x40
    [Tue Jan  8 17:16:47 2019]  btrfs_file_write_iter+0xac/0x570 [btrfs]
    [Tue Jan  8 17:16:47 2019]  ? nfsd_setuser+0x103/0x270 [nfsd]
    [Tue Jan  8 17:16:47 2019]  do_iter_readv_writev+0xff/0x150
    [Tue Jan  8 17:16:47 2019]  do_iter_write+0x78/0x180
    [Tue Jan  8 17:16:47 2019]  nfsd_vfs_write+0xf0/0x440 [nfsd]
    [Tue Jan  8 17:16:47 2019]  nfsd_write+0x84/0x150 [nfsd]
    [Tue Jan  8 17:16:47 2019]  nfsd3_proc_write+0xcc/0x150 [nfsd]
    [Tue Jan  8 17:16:47 2019]  nfsd_dispatch+0xb7/0x250 [nfsd]
    [Tue Jan  8 17:16:47 2019]  svc_process_common+0x382/0x730 [sunrpc]
    [Tue Jan  8 17:16:47 2019]  svc_process+0xeb/0x100 [sunrpc]
    [Tue Jan  8 17:16:47 2019]  nfsd+0xe3/0x150 [nfsd]
    [Tue Jan  8 17:16:47 2019]  kthread+0xf8/0x130
    [Tue Jan  8 17:16:47 2019]  ? nfsd_destroy+0x60/0x60 [nfsd]
    [Tue Jan  8 17:16:47 2019]  ? kthread_bind+0x10/0x10
    [Tue Jan  8 17:16:47 2019]  ret_from_fork+0x35/0x40
    ....

here is the other relevant info...

Linux kanlabfs 4.17.14-custom #1 SMP Sun Aug 12 11:54:00 EDT 2018 x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.17.1

Label: '/export'  uuid: 8f92c2e4-86fe-48cb-b2d3-bc36da765f02
        Total devices 3 FS bytes used 75.72TiB
        devid    1 size 47.30TiB used 42.22TiB path /dev/sda1
        devid    2 size 21.83TiB used 16.76TiB path /dev/sdb1
        devid    3 size 21.83TiB used 16.76TiB path /dev/sdc1

btrfs fi df /export/
Data, single: total=75.55TiB, used=75.54TiB
System, single: total=36.00MiB, used=7.89MiB
Metadata, single: total=187.01GiB, used=185.65GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Thanks for any help,

Cheers,

sb.
