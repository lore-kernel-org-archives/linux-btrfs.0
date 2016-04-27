Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44567 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbcD0M0C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 08:26:02 -0400
Received: from localhost
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <borntraeger@de.ibm.com>;
	Wed, 27 Apr 2016 13:26:00 +0100
To: linux-btrfs@vger.kernel.org
From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: 4.6.0-rc3+: WARNING: CPU: 16 PID: 17257 at fs/btrfs/inode.c:9261
 btrfs_destroy_inode
Cc: linux-kernel@vger.kernel.org
Message-ID: <5720AFCE.7060302@de.ibm.com>
Date: Wed, 27 Apr 2016 14:25:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Folks,

I can sometimes trigger the following bug

[  244.493534] ------------[ cut here ]------------
[  244.493624] WARNING: CPU: 16 PID: 17257 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x288/0x2b0 [btrfs]
[  244.493626] Kernel panic - not syncing: panic_on_warn set ...

[  244.493629] CPU: 16 PID: 17257 Comm: dwz Not tainted 4.6.0-rc3+ #56
[  244.493631]        000000fb3d8a3790 000000fb3d8a3820 0000000000000002 0000000000000000 
       000000fb3d8a38c0 000000fb3d8a3838 000000fb3d8a3838 0000000000239364 
       0000000000528488 000000000080e46e 00000000007f02c8 000000000000000b 
       000000fb3d8a3880 000000fb3d8a3820 0000000000000000 0000000000000000 
       040003ff8185a39e 0000000000113c1e 000000fb3d8a3820 000000fb3d8a3880 
[  244.493641] Call Trace:
[  244.493646] ([<0000000000113b0a>] show_trace+0x62/0x78)
[  244.493647] ([<0000000000113bd2>] show_stack+0x72/0xf0)
[  244.493650] ([<000000000040a8ca>] dump_stack+0x9a/0xd8)
[  244.493652] ([<0000000000238b9e>] panic+0xf6/0x230)
[  244.493656] ([<00000000001398e2>] __warn+0x11a/0x120)
[  244.493657] ([<000000000040a010>] report_bug+0x90/0xf8)
[  244.493658] ([<0000000000100a4a>] do_report_trap+0xea/0x108)
[  244.493660] ([<0000000000100bcc>] illegal_op+0xd4/0x150)
[  244.493662] ([<000000000067b760>] pgm_check_handler+0x15c/0x1a4)
[  244.493678] ([<000003ff817d0ff0>] btrfs_destroy_inode+0x288/0x2b0 [btrfs])
[  244.493680] ([<000000fb42aff1c8>] 0xfb42aff1c8)
[  244.493683] ([<00000000002de5b6>] __dentry_kill+0x1c6/0x238)
[  244.493684] ([<00000000002de7fc>] dput+0x1d4/0x298)
[  244.493687] ([<00000000002c6d24>] __fput+0x144/0x1e8)
[  244.493689] ([<000000000015a806>] task_work_run+0xc6/0xe8)
[  244.493714] ([<000000000010923a>] do_notify_resume+0x5a/0x60)
[  244.493715] ([<000000000067b45c>] system_call+0xdc/0x24c)

The WARN_ON is
        WARN_ON(BTRFS_I(inode)->csum_bytes);

The file system is shared on 4 multipath target on scsi disks.
In seem to be able to reproduce it on kvm/next (4.6.0-rc3+) but 4.5.0 seems fine.
Any ideas?

Christian

