Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53272 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966339AbbDWQeT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 12:34:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlK4u-0007a4-1T
	for linux-btrfs@vger.kernel.org; Thu, 23 Apr 2015 18:34:16 +0200
Received: from p4ff58852.dip0.t-ipconnect.de ([79.245.136.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 18:34:16 +0200
Received: from holger.hoffstaette by p4ff58852.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 18:34:16 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times
 during commit
Date: Thu, 23 Apr 2015 16:34:05 +0000 (UTC)
Message-ID: <pan.2015.04.23.16.34.05@googlemail.com>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
	<mh8h3f$l3u$1@ger.gmane.org> <pan.2015.04.22.16.37.38@googlemail.com>
	<5537D27E.3080609@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 22 Apr 2015 12:55:26 -0400, Chris Mason wrote:

> Great to hear.  I recommend just using my for-linus-4.1 branch, since it
> has all the good things  in one place.

Even with the latest patch for xfstests/049 I reproducibly get:

[  405.052123] =============================================================================
[  405.052125] BUG btrfs_transaction (Not tainted): Objects remaining in btrfs_transaction on kmem_cache_close()
[  405.052126] -----------------------------------------------------------------------------
[  405.052127] Disabling lock debugging due to kernel taint
[  405.052129] INFO: Slab 0xffffea000fea1e00 objects=22 used=1 fp=0xffff8803fa879d88 flags=0x20000000004080
[  405.052131] CPU: 0 PID: 3625 Comm: rmmod Tainted: G    B           4.0.0 #1
[  405.052132] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
[  405.052133]  ffff88040c03e300 ffff88040cd37d48 ffffffff8154c085 0000000000000007
[  405.052136]  ffffea000fea1e00 ffff88040cd37e18 ffffffff811557a0 0000000000000020
[  405.052137]  ffff88040cd37e28 ffff88040cd37dd8 656a624f00000202 616d657220737463
[  405.052139] Call Trace:
[  405.052145]  [<ffffffff8154c085>] dump_stack+0x45/0x57
[  405.052148]  [<ffffffff811557a0>] slab_err+0xa0/0xb0
[  405.052151]  [<ffffffff8110de00>] ? free_hot_cold_page_list+0x30/0xa0
[  405.052153]  [<ffffffff811561de>] ? __free_slab+0xce/0x1a0
[  405.052155]  [<ffffffff81157d7a>] ? __kmalloc+0x16a/0x1b0
[  405.052163]  [<ffffffff81159462>] ? free_partial+0xc2/0x230
[  405.052165]  [<ffffffff81159482>] free_partial+0xe2/0x230
[  405.052166]  [<ffffffff81156fd0>] ? deactivate_slab+0x580/0x580
[  405.052168]  [<ffffffff811596de>] __kmem_cache_shutdown+0x5e/0xb0
[  405.052170]  [<ffffffff811286b0>] kmem_cache_destroy+0x90/0x110
[  405.052192]  [<ffffffffa04683f1>] btrfs_destroy_cachep+0x41/0x80 [btrfs]
[  405.052197]  [<ffffffffa04d0466>] exit_btrfs_fs+0x9/0x5c [btrfs]
[  405.052199]  [<ffffffff810a69e1>] SyS_delete_module+0x171/0x240
[  405.052202]  [<ffffffff81002ccd>] ? do_notify_resume+0x6d/0x70
[  405.052205]  [<ffffffff81551272>] system_call_fastpath+0x12/0x17
[  405.052207] INFO: Object 0xffff8803fa878168 @offset=360
[  405.052208] kmem_cache_destroy btrfs_transaction: Slab cache still has objects
[  405.052209] CPU: 0 PID: 3625 Comm: rmmod Tainted: G    B           4.0.0 #1
[  405.052210] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
[  405.052210]  ffff88040cd37eb8 ffff88040cd37ea8 ffffffff8154c085 0000000000000007
[  405.052212]  ffff88040c03e300 ffff88040cd37ee8 ffffffff81128721 ffff88040cd37eb8
[  405.052213]  ffff88040cd37eb8 0000000000000800 ffffffffa04e9a00 00007ffd13de7932
[  405.052215] Call Trace:
[  405.052217]  [<ffffffff8154c085>] dump_stack+0x45/0x57
[  405.052218]  [<ffffffff81128721>] kmem_cache_destroy+0x101/0x110
[  405.052225]  [<ffffffffa04683f1>] btrfs_destroy_cachep+0x41/0x80 [btrfs]
[  405.052229]  [<ffffffffa04d0466>] exit_btrfs_fs+0x9/0x5c [btrfs]
[  405.052230]  [<ffffffff810a69e1>] SyS_delete_module+0x171/0x240
[  405.052232]  [<ffffffff81002ccd>] ? do_notify_resume+0x6d/0x70
[  405.052234]  [<ffffffff81551272>] system_call_fastpath+0x12/0x17

After a clean unmount (with a fresh space_cache but no inode_cache) & rmmod.
This used to work. :)

-h

