Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E466C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D946D20659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfANNNt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:13:49 -0500
Received: from aquinas.techsquare.com ([75.125.237.226]:46951 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726533AbfANNNt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:13:49 -0500
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1gj23k-0006sJ-KO; Mon, 14 Jan 2019 08:13:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Message-ID: <23612.35592.599043.773332@techsquare.com>
Date:   Mon, 14 Jan 2019 08:13:44 -0500
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     "Scott E. Blomquist" <sb@techsquare.com>, Jojo <jojo@automatix.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs hang on nfs?
In-Reply-To: <89a8a3a1-07bc-6cdc-1278-b9649f2b477e@suse.com>
References: <23605.54017.819143.292441@techsquare.com>
        <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
        <23605.63394.330818.203495@techsquare.com>
        <23607.12444.740949.683554@techsquare.com>
        <f95b63e3-9da5-ea60-3b4c-fbdf223f439c@suse.com>
        <23607.13250.659000.140295@techsquare.com>
        <23612.30105.728099.63687@techsquare.com>
        <89a8a3a1-07bc-6cdc-1278-b9649f2b477e@suse.com>
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Nikolay Borisov writes:
 > 
 > On 14.01.19 г. 13:42 ч., Scott E. Blomquist wrote:
 > > 
 <snip>
 > > 
 > > The file system hung again below is the sysrq output
 > > 
 > > Linux kanlabfs 4.19.13-custom #1 SMP Wed Jan 9 08:36:50 EST 2019 x86_64 x86_64 x86_64 GNU/Linux
 > > 
 > > btrfs-progs v4.19.1 
 > > 
 > > # btrfs fi df /export/
 > > Data, single: total=79.61TiB, used=79.61TiB
 > > System, single: total=36.00MiB, used=8.31MiB
 > > Metadata, single: total=192.01GiB, used=190.19GiB
 > > GlobalReserve, single: total=512.00MiB, used=0.00B
 > 
 > So this btrfs is hosted on your local machine but it is exported via
 > NFS, correct?

Correct and via samba also

 > > 
 > > #  btrfs fi show
 > > Label: '/export'  uuid: 8f92c2e4-86fe-48cb-b2d3-bc36da765f02
 > >         Total devices 3 FS bytes used 79.79TiB
 > >         devid    1 size 47.30TiB used 43.58TiB path /dev/sda1
 > >         devid    2 size 21.83TiB used 18.11TiB path /dev/sdb1
 > >         devid    3 size 21.83TiB used 18.11TiB path /dev/sdc1
 > 
 > What kind of disks are those, presumably spinning rust due to their size
 > but what model/make?
 > 

3 x raid 6 on a LSI MegaRAID SAS 9271-8i

 > > [Mon Jan 14 06:24:26 2019] sysrq: SysRq : Show Blocked State
 > 
 > <snip>
 > 
 > > [Mon Jan 14 06:24:26 2019] btrfs-transacti D    0  6808      2 0x80000000
 > > [Mon Jan 14 06:24:26 2019] Call Trace:
 > > [Mon Jan 14 06:24:26 2019]  ? __schedule+0x2ea/0x870
 > > [Mon Jan 14 06:24:26 2019]  schedule+0x32/0x80
 > > [Mon Jan 14 06:24:26 2019]  btrfs_start_ordered_extent+0xca/0x100 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  ? wait_woken+0x80/0x80
 > > [Mon Jan 14 06:24:26 2019]  btrfs_wait_ordered_range+0xbd/0x110 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  __btrfs_wait_cache_io+0x49/0x1a0 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  btrfs_write_dirty_block_groups+0xed/0x360 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  ? btrfs_run_delayed_refs+0x8b/0x1d0 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  commit_cowonly_roots+0x1ed/0x280 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  btrfs_commit_transaction+0x36e/0x8d0 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  ? start_transaction+0x9b/0x3f0 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  transaction_kthread+0x14d/0x180 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  kthread+0xf8/0x130
 > > [Mon Jan 14 06:24:26 2019]  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
 > > [Mon Jan 14 06:24:26 2019]  ? kthread_bind+0x10/0x10
 > > [Mon Jan 14 06:24:26 2019]  ret_from_fork+0x35/0x40
 > 
 > So the transaction is being committed as a result of that
 > btrfs_start_ordered_extent, which flushes data to disk. Since you've
 > compiled your kernel can you run the following command from the kernel's
 > source:
 > 
 > ./scripts/faddr2line  vmlinux  btrfs_start_ordered_extent+0xca/0x100
 > 
 > 'vmlinux' should be the kernel executable with debug info that results
 > from compiling the kernel. I want to figure out which line exactly
 > btrfs_start_ordered_extent+0xca/0x100 resolves to.

 <snip>

I'll have to rebuild the kernel with debug symbols.  Do I have to be
booted into the kernel for that command to be useful?

Cheers and Thanks,

sb. Scott Blomquist


