Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60131 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760140Ab3HNTnI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V9gyI-0006gr-N5
	for linux-btrfs@vger.kernel.org; Wed, 14 Aug 2013 21:43:06 +0200
Received: from 91-119-129-170.dynamic.xdsl-line.inode.at ([91.119.129.170])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 21:43:06 +0200
Received: from tim by 91-119-129-170.dynamic.xdsl-line.inode.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 21:43:06 +0200
To: linux-btrfs@vger.kernel.org
From: tim <tim@klingt.org>
Subject: Re: BUG at fs/btrfs/file.c:870
Date: Wed, 14 Aug 2013 21:42:52 +0200
Message-ID: <kugmjl$lnj$1@ger.gmane.org>
References: <kugg05$88d$1@ger.gmane.org> <20130814193337.GC26269@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130814193337.GC26269@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> trying to reproduce [1], i've came across another btrfs bug:
>>
> 
> You hit the strangest things.  I'm going to sit down and write a bunch of unit
> tests for this function to verify it is working properly.  Thanks,


glad to help. not sure if this is related, but i always have some
warnings about hung tasks, mainly when accessing the disk the first time:

[ 6234.211826] INFO: task AioMgr0-N:6041 blocked for more than 120 seconds.
[ 6234.211828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6234.211829] AioMgr0-N       D ffff880267f91b38     0  6041   5941
0x00000000
[ 6234.211832]  ffff880267f91aa8 0000000000000002 ffff880267f91fd8
0000000000004000
[ 6234.211833]  ffff880267f91fd8 ffff88041f176080 ffff880267f8e740
0000000000000246
[ 6234.211834]  0000000000000246 ffffffffa0247fbc ffff88041b522958
ffff88041cdc9800
[ 6234.211836] Call Trace:
[ 6234.211853]  [<ffffffffa0247fbc>] ? btrfs_queue_worker+0x1dc/0x310
[btrfs]
[ 6234.211860]  [<ffffffffa02251ee>] ? run_delalloc_range+0x19e/0x390
[btrfs]
[ 6234.211863]  [<ffffffff810d65d0>] ? __lock_page+0x70/0x70
[ 6234.211866]  [<ffffffff81591994>] schedule+0x24/0x70
[ 6234.211867]  [<ffffffff81591a6a>] io_schedule+0x8a/0xd0
[ 6234.211868]  [<ffffffff810d65d9>] sleep_on_page+0x9/0x10
[ 6234.211870]  [<ffffffff8158fc23>] __wait_on_bit_lock+0x53/0xb0
[ 6234.211871]  [<ffffffff810d65c2>] __lock_page+0x62/0x70
[ 6234.211873]  [<ffffffff810596a0>] ? autoremove_wake_function+0x30/0x30
[ 6234.211880]  [<ffffffffa023a007>]
extent_write_cache_pages.isra.34.constprop.51+0x377/0x3d0 [btrfs]
[ 6234.211882]  [<ffffffff810d6273>] ? find_get_pages_tag+0xe3/0x170
[ 6234.211888]  [<ffffffffa023a2d8>] extent_writepages+0x48/0x60 [btrfs]
[ 6234.211894]  [<ffffffffa0220e70>] ? btrfs_fiemap+0x60/0x60 [btrfs]
[ 6234.211899]  [<ffffffffa021fc63>] btrfs_writepages+0x23/0x30 [btrfs]
[ 6234.211901]  [<ffffffff810e1249>] do_writepages+0x19/0x40
[ 6234.211902]  [<ffffffff810d73e1>] __filemap_fdatawrite_range+0x51/0x60
[ 6234.211904]  [<ffffffff810d74c2>] filemap_write_and_wait_range+0x32/0x70
[ 6234.211905]  [<ffffffff810d758d>] generic_file_direct_write+0x8d/0x190
[ 6234.211907]  [<ffffffff8103e155>] ? current_fs_time+0x15/0x60
[ 6234.211913]  [<ffffffffa022ec22>] btrfs_file_aio_write+0x472/0x5b0
[btrfs]
[ 6234.211916]  [<ffffffff8122dce7>] ? security_file_permission+0x27/0xb0
[ 6234.211922]  [<ffffffffa022e7b0>] ?
__btrfs_buffered_write+0x340/0x340 [btrfs]
[ 6234.211924]  [<ffffffff81168d10>] do_io_submit+0x410/0x6f0
[ 6234.211926]  [<ffffffff81168ffb>] SyS_io_submit+0xb/0x10
[ 6234.211929]  [<ffffffff81598b8b>] tracesys+0xdd/0xe2


