Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60117 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2IQEID (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 00:08:03 -0400
Received: by bkwj10 with SMTP id j10so2239499bkw.19
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2012 21:08:01 -0700 (PDT)
MIME-Version: 1.0
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 17 Sep 2012 06:07:39 +0200
Message-ID: <CAPXgP104Cc1q6+TkG6R1VzbqxqMBrMWJfF6X6VYpWPkg8jyK=g@mail.gmail.com>
Subject: 'umount' of multi-device volume hangs until the device is physically un-plugged
To: btrfs <linux-btrfs@vger.kernel.org>
Cc: Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm currently playing around with native btrfs multi-device support in
systemd. There might be a few "hotplug issues" to solve, here is the
first one:

A mounted (otherwise unused) multi-device volume (USB multi-slot card
reader), hangs at:
  $ umount /mnt
with (fedora) kernel
  3.6.0-0.rc5.git0.1.fc18.x86_64

Any idea what to look for or what to try?

Thanks,
Kay

[  469.037785] umount          D ffff88011e253cc0     0  1403   1389 0x00000000
[  469.037790]  ffff880090ecf818 0000000000000082 ffff8800ccc3c530
ffff880090ecffd8
[  469.037796]  ffff880090ecffd8 ffff880090ecffd8 ffff8801172d9710
ffff8800ccc3c530
[  469.037801]  ffff880090ecf818 ffff8800ccc3c530 ffff88011e254560
0000000000000002
[  469.037807] Call Trace:
[  469.037814]  [<ffffffff8112a830>] ? __lock_page+0x70/0x70
[  469.037819]  [<ffffffff8161e899>] schedule+0x29/0x70
[  469.037824]  [<ffffffff8161e96f>] io_schedule+0x8f/0xd0
[  469.037831]  [<ffffffff8112a83e>] sleep_on_page+0xe/0x20
[  469.037838]  [<ffffffff8161d130>] __wait_on_bit+0x60/0x90
[  469.037845]  [<ffffffff8112a970>] wait_on_page_bit+0x80/0x90
[  469.037851]  [<ffffffff8107f660>] ? autoremove_wake_function+0x50/0x50
[  469.037858]  [<ffffffff8112af21>] filemap_fdatawait_range+0x101/0x190
[  469.037889]  [<ffffffffa057e4d8>] btrfs_wait_ordered_range+0x68/0x120 [btrfs]
[  469.037919]  [<ffffffffa059f412>] __btrfs_write_out_cache+0x772/0x990 [btrfs]
[  469.037942]  [<ffffffffa05573ce>] ? run_clustered_refs+0x1be/0xb50 [btrfs]
[  469.037972]  [<ffffffffa05a5278>] ? btrfs_find_ref_cluster+0x68/0x170 [btrfs]
[  469.037999]  [<ffffffffa059f6e1>] btrfs_write_out_cache+0xb1/0xf0 [btrfs]
[  469.038021]  [<ffffffffa055854f>]
btrfs_write_dirty_block_groups+0x50f/0x5e0 [btrfs]
[  469.038043]  [<ffffffffa0557f01>] ?
btrfs_run_delayed_refs+0x1a1/0x2e0 [btrfs]
[  469.038072]  [<ffffffffa05c2dd0>] commit_cowonly_roots+0x121/0x1eb [btrfs]
[  469.038099]  [<ffffffffa0569aad>]
btrfs_commit_transaction+0x59d/0xac0 [btrfs]
[  469.038105]  [<ffffffff8107f610>] ? wake_up_bit+0x40/0x40
[  469.038134]  [<ffffffffa05b4d46>] ? __btrfs_scrub_cancel+0x106/0x110 [btrfs]
[  469.038160]  [<ffffffffa0564aa6>] btrfs_commit_super+0x86/0x110 [btrfs]
[  469.038185]  [<ffffffffa0566358>] close_ctree+0x2c8/0x320 [btrfs]
[  469.038191]  [<ffffffff811aa067>] ? evict_inodes+0xb7/0x100
[  469.038208]  [<ffffffffa053d4b9>] btrfs_put_super+0x19/0x20 [btrfs]
[  469.038215]  [<ffffffff81191611>] generic_shutdown_super+0x61/0xe0
[  469.038222]  [<ffffffff81191726>] kill_anon_super+0x16/0x30
[  469.038239]  [<ffffffffa054134a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[  469.038246]  [<ffffffff81191aa7>] deactivate_locked_super+0x57/0x90
[  469.038252]  [<ffffffff8119265e>] deactivate_super+0x4e/0x70
[  469.038260]  [<ffffffff811acf37>] mntput_no_expire+0xd7/0x130
[  469.038267]  [<ffffffff811adf16>] sys_umount+0x76/0x390
[  469.038273]  [<ffffffff81627969>] system_call_fastpath+0x16/0x1b
