Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40210 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaB0XaV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 18:30:21 -0500
Received: from [216.239.55.198] (port=57891 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WJAPE-000091-GZ by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 15:30:20 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WJAPC-0003lI-Q2
	for linux-btrfs@vger.kernel.org; Thu, 27 Feb 2014 15:30:18 -0800
Date: Thu, 27 Feb 2014 15:30:18 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
Message-ID: <20140227233018.GB28338@merlins.org>
References: <20140227190656.GA28338@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140227190656.GA28338@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 27, 2014 at 11:06:56AM -0800, Marc MERLIN wrote:
> This does not happen consistently, but sometimes:
> 
> PM: Preparing system for mem sleep
> Freezing user space processes ... 
> (...)
>  Freezing of tasks failed after 20.002 seconds (1 tasks refusing to freeze, wq_busy=0):
>  btrfs           D ffff88017639c800     0 12239  12224 0x00000084
>   ffff880165ec1960 0000000000000086 ffff880165ec1fd8 ffff88017639c2d0
>   00000000000141c0 ffff88017639c2d0 ffff88007b874000 ffff8804062fa480
>   0000000000000000 ffff880175837ec0 ffff88007b874220 ffff880165ec1970
>  Call Trace:
>   [<ffffffff8160b0d9>] schedule+0x73/0x75
>   [<ffffffff8126e94c>] scrub_pages+0x27e/0x426
>   [<ffffffff81085062>] ? finish_wait+0x65/0x65
>   [<ffffffff81271732>] scrub_stripe+0xada/0xc9e
>   [<ffffffff812719cc>] scrub_chunk.isra.9+0xd6/0x10d
>   [<ffffffff81271c77>] scrub_enumerate_chunks+0x274/0x418
>   [<ffffffff81085000>] ? finish_wait+0x3/0x65
>   [<ffffffff812723bb>] btrfs_scrub_dev+0x254/0x3cb
>   [<ffffffff8116ddab>] ? __mnt_want_write+0x62/0x78
>   [<ffffffff81255c68>] btrfs_ioctl+0x1114/0x24b1
>   [<ffffffff81140698>] ? ____cache_alloc+0x1c/0x29b
>   [<ffffffff81140a06>] ? kmem_cache_alloc_node+0xef/0x179
>   [<ffffffff8160d7b3>] ? _raw_spin_unlock+0x17/0x2a
>   [<ffffffff81163ade>] do_vfs_ioctl+0x3d2/0x41d
>   [<ffffffff8116bd00>] ? __fget+0x6f/0x79
>   [<ffffffff81163b80>] SyS_ioctl+0x57/0x82
>   [<ffffffff8161426d>] system_call_fastpath+0x1a/0x1f
 
Some time later, I go this one, not sure if it's btrfs' fault or not:
usb 1-11: new full-speed USB device number 7 using xhci_hcd

Freezing of tasks failed after 20.006 seconds (1 tasks refusing to freeze, wq_busy=0):
laptop_mode     D ffff8800048c4a80     0  6657      1 0x00000084
 ffff880037f2bde0 0000000000000086 ffff880037f2bfd8 ffff8800048c4550
 00000000000141c0 ffff8800048c4550 ffff8804072280e8 ffff8804072280ec
 ffff8800048c4550 ffff8804072280f0 00000000ffffffff ffff880037f2bdf0
Call Trace:
 [<ffffffff8160b0d9>] schedule+0x73/0x75
 [<ffffffff8160b39a>] schedule_preempt_disabled+0x18/0x24
 [<ffffffff8160bed1>] __mutex_lock_slowpath+0x158/0x1cf
 [<ffffffff8160bf5f>] mutex_lock+0x17/0x27
 [<ffffffff8146b4d0>] control_store+0x44/0xb1
 [<ffffffff814623cd>] dev_attr_store+0x18/0x24
 [<ffffffff811b1598>] sysfs_kf_write+0x3e/0x40
 [<ffffffff811b47f5>] kernfs_fop_write+0xc2/0xff
 [<ffffffff81155417>] vfs_write+0xab/0x107
 [<ffffffff81155b19>] SyS_write+0x46/0x79
 [<ffffffff8161426d>] system_call_fastpath+0x1a/0x1f

Restarting tasks ... done.


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
