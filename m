Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:40633 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEIPlo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 11:41:44 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so4061307wes.6
        for <linux-btrfs@vger.kernel.org>; Fri, 09 May 2014 08:41:42 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 9 May 2014 20:41:42 +0500
Message-ID: <CAKAA-n=_jMyWFbfcGvMsMDJg3t7VpRegDDDybEeQ5oxof8graA@mail.gmail.com>
Subject: Sending incremental backup causes deadlock (3.14.3)
From: Abbas <mickylmartin@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Has anyone else experienced a deadlock while doing an incremental send
/ receive?

# uname -r
3.14.3-1.el6.elrepo.x86_64

# btrfs version
Btrfs v3.14.1

Initial send works well but sending incremental snapshots just HALTS:

# btrfs send -vvvv -p test/snap-2014-05-09-13:29:04
test/snap-2014-05-09-13:32:58 | btrfs receive -vvvv backup/test
At subvol test/snap-2014-05-09-13:32:58
At snapshot snap-2014-05-09-13:32:58
receiving snapshot snap-2014-05-09-13:32:58
uuid=8cde86f7-6ded-5046-a55c-3a0d40e7a2fc, ctransid=0
parent_uuid=1a2a9dc2-c271-524f-bd01-b671da630446, parent_ctransid=0
...

Here's the dmesg:

INFO: task btrfs:16204 blocked for more than 120 seconds.
      Not tainted 3.14.3-1.el6.elrepo.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs           D ffffffff8181d240     0 16204  23963 0x00000080
 ffff88003c8abc38 0000000000000086 ffff88003c8abbd8 ffff88003c8aa010
 0000000000014440 0000000000014440 ffff880004b40250 ffffffff81c13480
 ffff88003c8abc48 ffff880036b46960 ffff880037bf5800 ffff88003c8abc68
Call Trace:
 [<ffffffff81636649>] schedule+0x29/0x70
 [<ffffffffa011f235>] btrfs_commit_transaction+0x335/0x9e0 [btrfs]
 [<ffffffff810b2e50>] ? bit_waitqueue+0xe0/0xe0
 [<ffffffffa014fb45>] create_snapshot+0x265/0x280 [btrfs]
 [<ffffffffa0150403>] btrfs_mksubvol+0x153/0x1f0 [btrfs]
 [<ffffffffa015063c>] btrfs_ioctl_snap_create_transid+0x19c/0x1b0 [btrfs]
 [<ffffffffa01507d8>] btrfs_ioctl_snap_create_v2+0x108/0x160 [btrfs]
 [<ffffffff811d395a>] ? do_filp_open+0x4a/0xa0
 [<ffffffffa015728a>] btrfs_ioctl+0x45a/0x950 [btrfs]
 [<ffffffff8126215d>] ? inode_has_perm+0x2d/0x40
 [<ffffffff81262202>] ? file_has_perm+0x92/0xa0
 [<ffffffff811d4f53>] do_vfs_ioctl+0x73/0x380
 [<ffffffff81263e6f>] ? selinux_file_ioctl+0x4f/0xf0
 [<ffffffff811d5301>] SyS_ioctl+0xa1/0xb0
 [<ffffffff81642de9>] system_call_fastpath+0x16/0x1b
