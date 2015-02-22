Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36136 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbbBVR6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Feb 2015 12:58:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YPanL-0005yN-3l
	for linux-btrfs@vger.kernel.org; Sun, 22 Feb 2015 18:58:19 +0100
Received: from pd953e69f.dip0.t-ipconnect.de ([217.83.230.159])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2015 18:58:19 +0100
Received: from holger.hoffstaette by pd953e69f.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Feb 2015 18:58:19 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: New: seeing 100% CPU / unkillable tasks
Date: Sun, 22 Feb 2015 17:58:04 +0000 (UTC)
Message-ID: <pan.2015.02.22.17.58.04@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


kernel: 3.18.7 + all patches since 3.19 + the daily Filipe ;)

For the last few days I've been getting an awful lot of stuck tasks
after mundane operations like simple rsync'ing, an fallocate or just
doign a manual "sync".

Symptom is always 100% CPU use and the task (user-space fallocate, sync
or the [btrfs-transaction] kthread on eventual tx commit) hanging.

This happens even without stress (idle single-disk fs/system, no mem pressure)
and very irregularly. Today I got particularly unlucky and could trigger it
repeatedly, simply by doing a bunch of small fallocates on a fresh subvolume:
the first few would work and then - boom.

A full collection of several SysRq traces is at:
https://gist.github.com/hhoffstaette/c54ca2813cd47439c4c1

I've inserted spaces between different runs and SysRq segments to make
it a bit easier to read.

Common theme is almost always:

Feb 22 12:44:03 tux kernel: [<ffffffff812baa36>] ? __percpu_counter_add+0x56/0x80
Feb 22 12:44:03 tux kernel: [<ffffffffa07b566c>] ? find_first_extent_bit_state+0x2c/0x80 [btrfs]
Feb 22 12:44:03 tux kernel: [<ffffffff8108bb1b>] ? lock_timer_base.isra.36+0x2b/0x50
Feb 22 12:44:03 tux kernel: [<ffffffff81075023>] ? prepare_to_wait_event+0x83/0x100
Feb 22 12:44:03 tux kernel: [<ffffffffa07980ff>] wait_current_trans.isra.17+0x9f/0x100 [btrfs]
Feb 22 12:44:03 tux kernel: [<ffffffff81075130>] ? __wake_up_sync+0x20/0x20
Feb 22 12:44:03 tux kernel: [<ffffffffa0799ad8>] start_transaction+0x318/0x5a0 [btrfs]
Feb 22 12:44:03 tux kernel: [<ffffffffa0799e17>] btrfs_attach_transaction+0x17/0x20 [btrfs]
Feb 22 12:44:03 tux kernel: [<ffffffffa079486b>] transaction_kthread+0x8b/0x260 [btrfs]
Feb 22 12:44:03 tux kernel: [<ffffffffa07947e0>] ? btrfs_cleanup_transaction+0x520/0x520 [btrfs]
Feb 22 12:44:03 tux kernel: [<ffffffff810685eb>] kthread+0xdb/0x100
Feb 22 12:44:03 tux kernel: [<ffffffff81068510>] ? kthread_create_on_node+0x180/0x180
Feb 22 12:44:03 tux kernel: [<ffffffff8153f1ec>] ret_from_fork+0x7c/0xb0
Feb 22 12:44:03 tux kernel: [<ffffffff81068510>] ? kthread_create_on_node+0x180/0x180

or this:

Feb 22 14:08:45 tux kernel: [<ffffffffa056a809>] btrfs_set_path_blocking+0x49/0x90 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffffa056a8a5>] btrfs_clear_path_blocking+0x55/0xe0 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffffa056f657>] btrfs_search_slot+0x1f7/0xa60 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffffa0585955>] btrfs_update_root+0x55/0x270 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffffa060b4fd>] commit_cowonly_roots+0x1e5/0x285 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffffa0594135>] btrfs_commit_transaction+0x525/0xbb0 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffffa05d671d>] ? btrfs_log_dentry_safe+0x6d/0x80 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffffa05a9f5c>] btrfs_sync_file+0x1fc/0x330 [btrfs]
Feb 22 14:08:45 tux kernel: [<ffffffff81191531>] do_fsync+0x51/0x80
Feb 22 14:08:45 tux kernel: [<ffffffff811602e7>] ? SyS_fallocate+0x47/0x80
Feb 22 14:08:45 tux kernel: [<ffffffff811917d0>] SyS_fsync+0x10/0x20 

Clearly something is going into endless active loops and not terminating as it
should.

I realize this is vague but wanted to check if
- anyone is seeing this/something similar recently
- might have a suspect?

I've already backtracked a bit and can rule out Filipe's recent inode handling/fsync
stuff. The problem must have snuck in recently (last 2-3 weeks).

Grateful for any suggestions!

-h

