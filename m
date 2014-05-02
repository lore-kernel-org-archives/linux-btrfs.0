Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33509 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750795AbaEBCX5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 May 2014 22:23:57 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:64371 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wg38l-004Djk-Vb
	for linux-btrfs@vger.kernel.org; Thu, 01 May 2014 20:23:56 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unable to rebuild a 3 drive raid1 - blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <460175EE-093C-44D8-B561-596D1D71FAAF@colorremedies.com>
Date: Thu, 1 May 2014 20:23:54 -0600
Message-Id: <0233AD56-FDDF-4B6A-A32B-26F9F8D66FA2@colorremedies.com>
References: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com> <460175EE-093C-44D8-B561-596D1D71FAAF@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs device add hang is reproduced with 3.15.0-0.rc3.git3.1.fc21.x86_64 which has some debugging options enabled; although btrfs options are the same as the non-debug kernel. There is slightly more information in the stack traces however.

# grep -i btrfs config-3.15.0-0.rc3.git3.1.fc21.x86_64
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set

If btrfs debug set is useful for this let me know and I'll build a kernel with it enabled.

Full dmesg with sysrq-w is here:
https://drive.google.com/file/d/0B_2Asp8DGjJ9UDN3OUFTUXplNlk/edit?usp=sharing

Partial:
[  224.724955] SysRq : Show Blocked State
[  224.725024]   task                        PC stack   pid father
[  224.725131] btrfs-transacti D ffff88008571cd40  6456  1162      2 0x00000080
[  224.725131]  ffff880085769d20 0000000000000046 ffff88008571cd40 00000000001d5dc0
[  224.725131]  ffff880085769fd8 00000000001d5dc0 ffff880099194d40 ffff8800966ea210
[  224.725131]  ffff8800854331e8 ffff880085433000 ffff8800854331e8 0000000000000000
[  224.725131] Call Trace:
[  224.725131]  [<ffffffff817ec479>] schedule+0x29/0x70
[  224.725131]  [<ffffffffa00ca01f>] wait_current_trans.isra.19+0xcf/0x120 [btrfs]
[  224.725131]  [<ffffffff810eed10>] ? abort_exclusive_wait+0xb0/0xb0
[  224.725131]  [<ffffffffa00cb988>] start_transaction+0x3f8/0x650 [btrfs]
[  224.725131]  [<ffffffffa00cbc97>] btrfs_attach_transaction+0x17/0x20 [btrfs]
[  224.725131]  [<ffffffffa00c6b5e>] transaction_kthread+0x1de/0x290 [btrfs]
[  224.725131]  [<ffffffffa00c6980>] ? btrfs_cleanup_transaction+0x630/0x630 [btrfs]
[  224.725131]  [<ffffffff810c3348>] kthread+0x108/0x120
[  224.725131]  [<ffffffff810dbaa8>] ? sched_clock_cpu+0x98/0xc0
[  224.725131]  [<ffffffff810f8f6d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  224.725131]  [<ffffffff810c3240>] ? insert_kthread_work+0x80/0x80
[  224.725131]  [<ffffffff817fc97c>] ret_from_fork+0x7c/0xb0
[  224.725131]  [<ffffffff810c3240>] ? insert_kthread_work+0x80/0x80
[  224.725131] btrfs           D ffff880089053380  2624  1165    997 0x00000080
[  224.725131]  ffff8800850b57f8 0000000000000046 ffff880089053380 00000000001d5dc0
[  224.725131]  ffff8800850b5fd8 00000000001d5dc0 ffff880099194d40 ffff88009d9d6758
[  224.725131]  ffff88009e3e34a8 0000000000000002 ffffffff811b0850 ffff8800850b5870
[  224.725131] Call Trace:
[  224.725131]  [<ffffffff811b0850>] ? wait_on_page_read+0x60/0x60
[  224.725131]  [<ffffffff817ec80f>] io_schedule+0xaf/0x150
[  224.725131]  [<ffffffff811b085e>] sleep_on_page+0xe/0x20
[  224.725131]  [<ffffffff817ecc43>] __wait_on_bit+0x83/0xa0
[  224.725131]  [<ffffffff811b1ab2>] ? find_get_pages_tag+0x2d2/0x370
[  224.725131]  [<ffffffff811b05e9>] wait_on_page_bit+0x89/0xa0
[  224.725131]  [<ffffffff810eed50>] ? autoremove_wake_function+0x40/0x40
[  224.725131]  [<ffffffff811b06f9>] filemap_fdatawait_range+0xf9/0x1c0
[  224.725131]  [<ffffffffa00e6a3c>] btrfs_wait_ordered_range+0x6c/0x150 [btrfs]
[  224.725131]  [<ffffffffa01108a0>] __btrfs_write_out_cache+0x640/0x860 [btrfs]
[  224.725131]  [<ffffffffa011144d>] btrfs_write_out_cache+0x8d/0xe0 [btrfs]
[  224.725131]  [<ffffffffa00ba1f1>] btrfs_write_dirty_block_groups+0x691/0x730 [btrfs]
[  224.725131]  [<ffffffffa0142539>] commit_cowonly_roots+0x17a/0x234 [btrfs]
[  224.725131]  [<ffffffffa00caf5b>] btrfs_commit_transaction+0x44b/0xa80 [btrfs]
[  224.725131]  [<ffffffffa00fa734>] btrfs_init_new_device+0x884/0xeb0 [btrfs]
[  224.725131]  [<ffffffff811dfcae>] ? might_fault+0x5e/0xc0
[  224.725131]  [<ffffffff811dfd09>] ? might_fault+0xb9/0xc0
[  224.725131]  [<ffffffffa010392c>] btrfs_ioctl+0xc4c/0x2aa0 [btrfs]
[  224.725131]  [<ffffffff8135e8f2>] ? avc_has_perm+0x142/0x350
[  224.725131]  [<ffffffff810dbaa8>] ? sched_clock_cpu+0x98/0xc0
[  224.725131]  [<ffffffff810dbb26>] ? local_clock+0x16/0x30
[  224.725131]  [<ffffffff810f5a7f>] ? lock_release_holdtime.part.28+0xf/0x200
[  224.725131]  [<ffffffff8135e90a>] ? avc_has_perm+0x15a/0x350
[  224.725131]  [<ffffffff8135e7e4>] ? avc_has_perm+0x34/0x350
[  224.725131]  [<ffffffff81360f01>] ? inode_has_perm.isra.47+0x51/0x90
[  224.725131]  [<ffffffff812513e0>] do_vfs_ioctl+0x2f0/0x520
[  224.725131]  [<ffffffff81251691>] SyS_ioctl+0x81/0xa0
[  224.725131]  [<ffffffff81155eac>] ? __audit_syscall_entry+0x9c/0xf0
[  224.725131]  [<ffffffff817fca29>] system_call_fastpath+0x16/0x1b
[  224.725131] Sched Debug Version: v0.11, 3.15.0-0.rc3.git3.1.fc21.x86_64 #1

