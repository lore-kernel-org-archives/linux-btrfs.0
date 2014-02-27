Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37878 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbaB0THk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 14:07:40 -0500
Received: from [216.239.55.198] (port=56699 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WJ6J1-0000hn-G3 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 11:07:39 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WJ6IV-0004FC-AZ
	for linux-btrfs@vger.kernel.org; Thu, 27 Feb 2014 11:07:07 -0800
Date: Thu, 27 Feb 2014 11:06:56 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to sleep
Message-ID: <20140227190656.GA28338@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This does not happen consistently, but sometimes:

PM: Preparing system for mem sleep
Freezing user space processes ... 
(...)
 Freezing of tasks failed after 20.002 seconds (1 tasks refusing to freeze, wq_busy=0):
 btrfs           D ffff88017639c800     0 12239  12224 0x00000084
  ffff880165ec1960 0000000000000086 ffff880165ec1fd8 ffff88017639c2d0
  00000000000141c0 ffff88017639c2d0 ffff88007b874000 ffff8804062fa480
  0000000000000000 ffff880175837ec0 ffff88007b874220 ffff880165ec1970
 Call Trace:
  [<ffffffff8160b0d9>] schedule+0x73/0x75
  [<ffffffff8126e94c>] scrub_pages+0x27e/0x426
  [<ffffffff81085062>] ? finish_wait+0x65/0x65
  [<ffffffff81271732>] scrub_stripe+0xada/0xc9e
  [<ffffffff812719cc>] scrub_chunk.isra.9+0xd6/0x10d
  [<ffffffff81271c77>] scrub_enumerate_chunks+0x274/0x418
  [<ffffffff81085000>] ? finish_wait+0x3/0x65
  [<ffffffff812723bb>] btrfs_scrub_dev+0x254/0x3cb
  [<ffffffff8116ddab>] ? __mnt_want_write+0x62/0x78
  [<ffffffff81255c68>] btrfs_ioctl+0x1114/0x24b1
  [<ffffffff81140698>] ? ____cache_alloc+0x1c/0x29b
  [<ffffffff81140a06>] ? kmem_cache_alloc_node+0xef/0x179
  [<ffffffff8160d7b3>] ? _raw_spin_unlock+0x17/0x2a
  [<ffffffff81163ade>] do_vfs_ioctl+0x3d2/0x41d
  [<ffffffff8116bd00>] ? __fget+0x6f/0x79
  [<ffffffff81163b80>] SyS_ioctl+0x57/0x82
  [<ffffffff8161426d>] system_call_fastpath+0x1a/0x1f


And then I end up with a hot laptop and a mostly dead battery in my backpack.

As far as I know, this was not happening with 3.13, unless I'm doing
something differently without knowing.

My laptop went to sleep just fine while I was typing this Email, so I'm guessing
it's only btrfs scrub that causes the problem with sleep.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
