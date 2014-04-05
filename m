Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54978 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaDEPju (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 11:39:50 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:40517 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WWSh5-0001FY-8D by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 08:39:49 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WWSh5-0000Ut-Md
	for linux-btrfs@vger.kernel.org; Sat, 05 Apr 2014 08:39:43 -0700
Date: Sat, 5 Apr 2014 08:39:43 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140405153943.GD12124@merlins.org>
References: <20140405153721.GC12124@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140405153721.GC12124@merlins.org>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:4324! (3.14-rc5)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 05, 2014 at 08:37:21AM -0700, Marc MERLIN wrote:
> static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
> 						unsigned long start_idx)
> {
> 	unsigned long index;
> 	unsigned long num_pages;
> 	struct page *page;
> 	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
> 
> >>>	BUG_ON(extent_buffer_under_io(eb));
> 
> 	num_pages = num_extent_pages(eb->start, eb->len);
> 	index = start_idx + num_pages;
> 	if (start_idx >= index)
> 		return;
 
After reboot, things went back to normal, I just got this on reboot:

BTRFS error (device dm-2): block group 535289659392 has wrong amount of free space
BTRFS error (device dm-2): failed to load free space cache for block group 535289659392
INFO: task btrfs-transacti:4080 blocked for more than 120 seconds.
      Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D ffff88020c42aa80     0  4080      2 0x00000000
 ffff8800c605bdc0 0000000000000046 ffff8800c605bfd8 ffff88020c42a550
 00000000000141c0 ffff88020c42a550 ffff8800c6e61ed0 ffff8802139601e8
 0000000000000000 ffff880213960000 ffff88020cf03100 ffff8800c605bdd0
Call Trace:
 [<ffffffff8160c331>] schedule+0x73/0x75
 [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff810850c9>] ? finish_wait+0x65/0x65
 [<ffffffff8122b812>] start_transaction+0x202/0x4f2
 [<ffffffff8122bb9e>] btrfs_attach_transaction+0x17/0x19
 [<ffffffff812277a8>] transaction_kthread+0xd6/0x1ab
 [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
