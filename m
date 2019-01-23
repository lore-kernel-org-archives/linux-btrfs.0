Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6EBC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB0821019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfAWPux (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 10:50:53 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:35701 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfAWPux (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 10:50:53 -0500
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id 580FA5204; Wed, 23 Jan 2019 16:50:46 +0100 (CET)
Date:   Wed, 23 Jan 2019 16:50:46 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel traces
Message-ID: <20190123155046.GA8995@cuci.nl>
References: <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
 <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
 <20181228150016.GB13717@cuci.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181228150016.GB13717@cuci.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Stephen R. van den Berg wrote:
>Qu Wenruo wrote:
>>On 2018/12/28 ??????9:40, Stephen R. van den Berg wrote:
>>>> It's caused by qgroup, and a dead lock on btrfs_drop_snapshot().

>>>> This is one of the easiest way to trigger an ABBA deadlock.

>>>> Please either disable qgroup or apply this patch to solve it:
>>>> https://patchwork.kernel.org/patch/10725371/

>Ok, booting the system in v4.20 with this patch.  I'll report back if
>it does not resolve the problem.

I now have a stuck btrfs receive again:
[    0.000000] INFO: task btrfs:1850 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0  1850   1845 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:1850 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0  1850   1845 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] conftest[24422]: segfault at 7ffe21547e90 ip 000055ebaef881c4 sp 00007ffe21547e90 error 6 in conftest[55ebaef88000+1000]
[    0.000000] Code: 1f 80 00 00 00 00 e9 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 48 81 ec f8 ff 00 00 8b 05 8f 2e 00 00 48 8d 35 40 0e 00 00 <48> 89 3c 24 48 8b 3d 81 2e 00 00 8d 90 00 00 01 00 31 c0 89 15 6f
[    0.000000] perf: interrupt took too long (3977 > 3961), lowering kernel.perf_event_max_sample_rate to 50200
[    0.000000] perf: interrupt took too long (4975 > 4971), lowering kernel.perf_event_max_sample_rate to 40200
[    0.000000] conftest[4747]: segfault at 7ffd0e0fb540 ip 00005567d53c61c4 sp 00007ffd0e0fb540 error 6 in conftest[5567d53c6000+1000]
[    0.000000] Code: 1f 80 00 00 00 00 e9 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 48 81 ec f8 ff 00 00 8b 05 8f 2e 00 00 48 8d 35 40 0e 00 00 <48> 89 3c 24 48 8b 3d 81 2e 00 00 8d 90 00 00 01 00 31 c0 89 15 6f
[    0.000000] perf: interrupt took too long (6222 > 6218), lowering kernel.perf_event_max_sample_rate to 32100
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    0.000000] INFO: task btrfs:16752 blocked for more than 120 seconds.
[    0.000000]       Not tainted 94.20.0-srb-asrock-00002-gfb1bd063cc72 #141
[    0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[    0.000000] btrfs           D    0 16752  16745 0x00000000
[    0.000000] Call Trace:
[    0.000000]  ? __schedule+0x4db/0x524
[    0.000000]  ? schedule+0x60/0x71
[    0.000000]  ? btrfs_start_ordered_extent+0xd3/0x105
[    0.000000]  ? finish_wait+0x60/0x60
[    0.000000]  ? btrfs_wait_ordered_range+0xa4/0x100
[    0.000000]  ? unmap_mapping_pages+0x64/0x113
[    0.000000]  ? btrfs_setattr+0x20b/0x499
[    0.000000]  ? notify_change+0x268/0x347
[    0.000000]  ? do_truncate+0x82/0xb6
[    0.000000]  ? kmem_cache_alloc+0x9a/0x100
[    0.000000]  ? vfs_truncate+0xbc/0xda
[    0.000000]  ? do_sys_truncate+0x60/0xa9
[    0.000000]  ? do_syscall_64+0x4e/0x5b
[    0.000000]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

Running 4.20.0 including the special patch mentioned earlier in this
thread.
-- 
Stephen.
