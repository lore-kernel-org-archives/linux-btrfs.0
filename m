Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60649 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbaBYTaK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WINhb-0006BT-Nu
	for linux-btrfs@vger.kernel.org; Tue, 25 Feb 2014 20:30:04 +0100
Received: from 131-028-005-185.ip-addr.ew-goldbach-hoesbach.de ([84.19.169.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 20:30:03 +0100
Received: from jannis_achstetter by 131-028-005-185.ip-addr.ew-goldbach-hoesbach.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 20:30:03 +0100
To: linux-btrfs@vger.kernel.org
From: Jannis Achstetter <jannis_achstetter@web.de>
Subject: Re: [RFC PATCH v8 00/14] Online(inband) data deduplication
Date: Tue, 25 Feb 2014 19:22:28 +0000 (UTC)
Message-ID: <loom.20140225T201641-262@post.gmane.org>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Liu, hello list,

Liu Bo <bo.li.liu <at> oracle.com> writes:
> Here is the New Year patch bomb 

I tried yout btrfs deduplication patches today (on top of 3.13.2-gentoo) and
it seems that the deduplication works great (when copying the same or
similar data to the file system, the used size reported by df -h grows less
than the data that is copied to it on the second time).
However, there are disturbing messages in the kernel log:
[46620.519741] btrfs-delalloc-: page allocation failure: order:5, mode:0x104050
[46620.519743] CPU: 1 PID: 25246 Comm: btrfs-delalloc- Tainted: G          
O 3.13.2-gentoo #4
[46620.519744] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS
V1.12 10/06/2011
[46620.519745]  ffff880098881b38 ffffffff81920b14 0000000000104050
ffffffff81145927
[46620.519747]  0000000000000000 ffff880237ffc800 0000000000000000
0000000000000005
[46620.519749]  0000000000000001 ffffffff8191ce20 ffff880237ffc808
0000000000000002
[46620.519750] Call Trace:
[46620.519752]  [<ffffffff81920b14>] ? dump_stack+0x49/0x6a
[46620.519754]  [<ffffffff81145927>] ? warn_alloc_failed+0xe7/0x140
[46620.519757]  [<ffffffff8191ce20>] ? __alloc_pages_direct_compact+0xa2/0x1b0
[46620.519759]  [<ffffffff81148fa4>] ? __alloc_pages_nodemask+0x7f4/0x970
[46620.519761]  [<ffffffff8118376f>] ? alloc_pages_current+0xaf/0x180
[46620.519763]  [<ffffffff81144cc5>] ? __get_free_pages+0x5/0x40
[46620.519765]  [<ffffffff8115fb1b>] ? kmalloc_order_trace+0x3b/0xe0
[46620.519767]  [<ffffffff813291f5>] ? run_delalloc_dedup+0x685/0xba0
[46620.519769]  [<ffffffff813280ae>] ? run_locked_range.constprop.66+0xce/0xd0
[46620.519771]  [<ffffffff8109fd90>] ? detach_if_pending+0x100/0x100
[46620.519773]  [<ffffffff81329785>] ? async_cow_start+0x75/0xa0
[46620.519775]  [<ffffffff8134da99>] ? worker_loop+0x149/0x550
[46620.519777]  [<ffffffff8134d950>] ? btrfs_queue_worker+0x2f0/0x2f0
[46620.519779]  [<ffffffff810b4481>] ? kthread+0xc1/0xe0
[46620.519781]  [<ffffffff810b43c0>] ? kthread_create_on_node+0x190/0x190
[46620.519783]  [<ffffffff819286bc>] ? ret_from_fork+0x7c/0xb0
[46620.519785]  [<ffffffff810b43c0>] ? kthread_create_on_node+0x190/0x190

(many of them, as to be seen here: http://bpaste.net/show/182698/ )

I use btrfs with lzo compression:
/dev/sdc2 on /mnt/steamdir type btrfs (rw,compress=lzo)

Kernel config is here:
http://bpaste.net/show/182706/

If you need any more info, just let me know!

Thanks for your work and all the best,
     Jannis Achstetter

