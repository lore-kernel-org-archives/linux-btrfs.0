Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43299 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaKFMzB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 07:55:01 -0500
Received: from [101.8.25.145] (port=33766 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1XmMaa-0005be-EQ by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Thu, 06 Nov 2014 04:55:00 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1XmMaX-0005OD-6m
	for linux-btrfs@vger.kernel.org; Thu, 06 Nov 2014 04:54:57 -0800
Date: Thu, 6 Nov 2014 04:54:56 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.16.3 hung on btrfs_evict_inode+0x13e/0x3fd
Message-ID: <20141106125456.GN25518@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

INFO: task jhead:16654 blocked for more than 120 seconds.
      Tainted: G        W  O  3.16.3-amd64-i915-preempt-20140714fm1 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jhead           D ffff8802f7e6d060     0 16654  15616 0x20020080
 ffff88023c797d00 0000000000000086 ffff88016da19c60 ffff88023c797fd8
 ffff8801cc9da2d0 00000000000140c0 ffff88016da19c60 ffff8801dbbdb0a4
 0000000000178000 ffff88023c797d78 ffff8801dbbdb088 ffff88023c797d10
Call Trace:
 [<ffffffff8163ab89>] schedule+0x6e/0x70
 [<ffffffff8124c492>] lock_extent_bits+0x10a/0x192
 [<ffffffff81087b7c>] ? finish_wait+0x65/0x65
 [<ffffffff8123e03e>] btrfs_evict_inode+0x13e/0x3fd
 [<ffffffff8117556a>] evict+0xac/0x153
 [<ffffffff81175b8d>] iput+0x129/0x132
 [<ffffffff8116c9d2>] do_unlinkat+0x135/0x1ce
 [<ffffffff810a4aba>] ? current_kernel_time+0xe/0x32
 [<ffffffff810cb5e0>] ? __audit_syscall_entry+0xa6/0xc8
 [<ffffffff8101acdf>] ? syscall_trace_enter+0x184/0x1fd
 [<ffffffff8116d79f>] SyS_unlink+0x16/0x18
 [<ffffffff81640929>] ia32_do_call+0x13/0x13

sysrq dump here if that helps:
http://marc.merlins.org/tmp/sysrq-3.16.3.txt

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
