Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41570 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2GCKft (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 06:35:49 -0400
Received: by obbuo13 with SMTP id uo13so9634801obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2012 03:35:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120702124937.GC6185@localhost.localdomain>
References: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
	<20120625192632.GF7404@localhost.localdomain>
	<CAHf9xvYGWvOCCUUte8Y29RG+G0aXAbKkE3up7r=2SDRLCRQKwg@mail.gmail.com>
	<CAHf9xvb2iGtyBY_28JexHa4w==Haiy4BN_e0qc2Df6Q+rBG98Q@mail.gmail.com>
	<20120627134633.GA2819@localhost.localdomain>
	<CAHf9xvY7eoDA6BSAwz+-Nbn0hzC89N5EPS-KJ=qXfvyJ2q2b5A@mail.gmail.com>
	<20120702124937.GC6185@localhost.localdomain>
Date: Tue, 3 Jul 2012 13:35:48 +0300
Message-ID: <CAHf9xvYGFayuyhL9T3vcxeiqNA=XBSJ-O6FxHX91rvkKj2ShRQ@mail.gmail.com>
Subject: Re: fio reports data corruption with btrfs
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
tested with your "master" branch, commit
157331741ba010ffcb2212b88342fb21ae140636.
fio compiled from tag fio-2.0.8 (commit
cf9a74c8bd63d9db5256f1362885c740e11a1fe5).

Result: some kernel warnings about hung tasks, fio segfault and
mismatch errors. Below are some outputs... I will try some more tests,
changing different components.

Alex.


Kernel log:
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.740135] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.741878] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742881] df
  D ffffffff8180cae0     0  3113   3112 0x00000000
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742887]
ffff88004668fcb8 0000000000000086 ffff880119b72e28 ffff88011fc13930
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742891]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742894]
ffffffff81c13440 ffff8801194544d0 ffff88011fc138c0 7fffffffffffffff
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742896] Call Trace:
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742912]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742916]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742920]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742940]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742952]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742956]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742960]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742963]
[<ffffffff811a830d>] writeback_inodes_sb_nr+0x7d/0xa0
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742967]
[<ffffffff811a857e>] writeback_inodes_sb+0x2e/0x40
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742970]
[<ffffffff811afb0e>] __sync_filesystem+0x4e/0x90
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742973]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742984]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742988]
[<ffffffff811afc20>] sys_sync+0x30/0x70
Jul  3 00:02:12 vsa-00000018-vc-1 kernel: [ 9000.742993]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.740290] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.741252] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742282] df
  D ffffffff8180cae0     0  3113   3112 0x00000000
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742299]
ffff88004668fcb8 0000000000000086 ffff880119b72e28 ffff88011fc13930
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742303]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742307]
ffffffff81c13440 ffff8801194544d0 ffff88011fc138c0 7fffffffffffffff
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742308] Call Trace:
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742324]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742328]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742332]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742340]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742347]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742350]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742354]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742358]
[<ffffffff811a830d>] writeback_inodes_sb_nr+0x7d/0xa0
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742361]
[<ffffffff811a857e>] writeback_inodes_sb+0x2e/0x40
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742364]
[<ffffffff811afb0e>] __sync_filesystem+0x4e/0x90
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742368]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742373]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742376]
[<ffffffff811afc20>] sys_sync+0x30/0x70
Jul  3 00:04:12 vsa-00000018-vc-1 kernel: [ 9120.742381]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.740133] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.741191] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742103] df
  D ffffffff8180cae0     0  3113   3112 0x00000000
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742109]
ffff88004668fcb8 0000000000000086 ffff880119b72e28 ffff88011fc13930
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742113]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742117]
ffffffff81c13440 ffff8801194544d0 ffff88011fc138c0 7fffffffffffffff
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742119] Call Trace:
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742134]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742139]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742143]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742151]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742157]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742161]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742164]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742168]
[<ffffffff811a830d>] writeback_inodes_sb_nr+0x7d/0xa0
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742172]
[<ffffffff811a857e>] writeback_inodes_sb+0x2e/0x40
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742175]
[<ffffffff811afb0e>] __sync_filesystem+0x4e/0x90
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742178]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742183]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742187]
[<ffffffff811afc20>] sys_sync+0x30/0x70
Jul  3 00:06:12 vsa-00000018-vc-1 kernel: [ 9240.742191]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.740160] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.741617] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743043] df
  D ffffffff8180cae0     0  3113   3112 0x00000000
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743049]
ffff88004668fcb8 0000000000000086 ffff880119b72e28 ffff88011fc13930
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743053]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743056]
ffffffff81c13440 ffff8801194544d0 ffff88011fc138c0 7fffffffffffffff
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743058] Call Trace:
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743074]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743078]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743083]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743091]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743097]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743101]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743104]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743108]
[<ffffffff811a830d>] writeback_inodes_sb_nr+0x7d/0xa0
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743111]
[<ffffffff811a857e>] writeback_inodes_sb+0x2e/0x40
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743115]
[<ffffffff811afb0e>] __sync_filesystem+0x4e/0x90
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743118]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743123]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743127]
[<ffffffff811afc20>] sys_sync+0x30/0x70
Jul  3 00:08:12 vsa-00000018-vc-1 kernel: [ 9360.743131]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.740164] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.741309] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742519] df
  D ffffffff8180cae0     0  3113   3112 0x00000000
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742525]
ffff88004668fcb8 0000000000000086 ffff880119b72e28 ffff88011fc13930
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742529]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742532]
ffffffff81c13440 ffff8801194544d0 ffff88011fc138c0 7fffffffffffffff
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742534] Call Trace:
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742547]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742551]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742555]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742562]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742568]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742571]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742575]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742579]
[<ffffffff811a830d>] writeback_inodes_sb_nr+0x7d/0xa0
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742582]
[<ffffffff811a857e>] writeback_inodes_sb+0x2e/0x40
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742586]
[<ffffffff811afb0e>] __sync_filesystem+0x4e/0x90
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742589]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742594]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742597]
[<ffffffff811afc20>] sys_sync+0x30/0x70
Jul  3 00:10:12 vsa-00000018-vc-1 kernel: [ 9480.742601]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.740152] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.741373] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742515] df
  D ffffffff8180cae0     0  3113   3112 0x00000000
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742521]
ffff88004668fcb8 0000000000000086 ffff880119b72e28 ffff88011fc13930
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742524]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742528]
ffffffff81c13440 ffff8801194544d0 ffff88011fc138c0 7fffffffffffffff
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742530] Call Trace:
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742546]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742550]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742554]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742562]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742569]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742572]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742576]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742580]
[<ffffffff811a830d>] writeback_inodes_sb_nr+0x7d/0xa0
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742583]
[<ffffffff811a857e>] writeback_inodes_sb+0x2e/0x40
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742586]
[<ffffffff811afb0e>] __sync_filesystem+0x4e/0x90
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742589]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742595]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742598]
[<ffffffff811afc20>] sys_sync+0x30/0x70
Jul  3 00:12:12 vsa-00000018-vc-1 kernel: [ 9600.742603]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.740156] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.741421] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742641] df
  D 0000000000000000     0  3113   3112 0x00000000
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742647]
ffff88004668fcd8 0000000000000086 ffff88004668fcb8 ffffffff8108e50b
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742651]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742654]
ffff88011603c4d0 ffff8801194544d0 00000000000138c0 7fffffffffffffff
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742657] Call Trace:
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742671]
[<ffffffff8108e50b>] ? check_preempt_wakeup+0x14b/0x270
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742680]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742684]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742690]
[<ffffffff81085f56>] ? ttwu_do_activate.constprop.85+0x66/0x70
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742693]
[<ffffffff81086036>] ? ttwu_queue+0xd6/0xf0
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742697]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742704]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742708]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742711]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742715]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742718]
[<ffffffff811a84de>] sync_inodes_sb+0x8e/0xc0
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742734]
[<ffffffff811afb48>] __sync_filesystem+0x88/0x90
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742738]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742744]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742747]
[<ffffffff811afc37>] sys_sync+0x47/0x70
Jul  3 00:16:12 vsa-00000018-vc-1 kernel: [ 9840.742752]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.740208] INFO: task
fio:2975 blocked for more than 120 seconds.
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.741633] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743001] fio
  D 0000000000000000     0  2975   2706 0x00000000
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743007]
ffff8800d8bffac8 0000000000000082 0000000009bf6ad8 ffffffff81c1d980
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743011]
ffff8800d8bfffd8 ffff8800d8bfffd8 ffff8800d8bfffd8 00000000000138c0
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743014]
ffff880117660000 ffff8801175b44d0 ffff8800d8bffaa8 ffff88011fc14158
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743016] Call Trace:
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743045]
[<ffffffff81121e50>] ? __lock_page+0x70/0x70
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743055]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743058]
[<ffffffff81679d4f>] io_schedule+0x8f/0xd0
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743062]
[<ffffffff81121e5e>] sleep_on_page+0xe/0x20
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743066]
[<ffffffff8167861f>] __wait_on_bit+0x5f/0x90
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743069]
[<ffffffff81121fb8>] wait_on_page_bit+0x78/0x80
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743078]
[<ffffffff81076ca0>] ? autoremove_wake_function+0x40/0x40
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743110]
[<ffffffffa03197f0>] prepare_pages.isra.14+0x240/0x370 [btrfs]
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743123]
[<ffffffffa02f7758>] ? btrfs_delalloc_reserve_metadata+0x1f8/0x380
[btrfs]
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743127]
[<ffffffff8167ab9e>] ? _raw_spin_lock+0xe/0x20
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743145]
[<ffffffffa031a2cd>] __btrfs_buffered_write+0x17d/0x330 [btrfs]
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743164]
[<ffffffffa031a6bd>] btrfs_file_aio_write+0x23d/0x4c0 [btrfs]
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743168]
[<ffffffff811242ef>] ? generic_file_aio_read+0xef/0x280
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743173]
[<ffffffff81181042>] do_sync_write+0xd2/0x110
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743187]
[<ffffffff812e0a38>] ? apparmor_file_permission+0x18/0x20
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743199]
[<ffffffff812a76ec>] ? security_file_permission+0x2c/0xb0
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743202]
[<ffffffff811815d1>] ? rw_verify_area+0x61/0xf0
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743205]
[<ffffffff81181933>] vfs_write+0xb3/0x180
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743208]
[<ffffffff81181c5a>] sys_write+0x4a/0x90
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743212]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.743219] INFO: task
df:3113 blocked for more than 120 seconds.
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.744750] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746723] df
  D 0000000000000000     0  3113   3112 0x00000000
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746730]
ffff88004668fcd8 0000000000000086 ffff88004668fcb8 ffffffff8108e50b
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746735]
ffff88004668ffd8 ffff88004668ffd8 ffff88004668ffd8 00000000000138c0
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746740]
ffff88011603c4d0 ffff8801194544d0 00000000000138c0 7fffffffffffffff
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746742] Call Trace:
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746752]
[<ffffffff8108e50b>] ? check_preempt_wakeup+0x14b/0x270
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746759]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746764]
[<ffffffff81678395>] schedule_timeout+0x2a5/0x320
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746772]
[<ffffffff81085f56>] ? ttwu_do_activate.constprop.85+0x66/0x70
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746776]
[<ffffffff81086036>] ? ttwu_queue+0xd6/0xf0
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746782]
[<ffffffff81679acf>] wait_for_common+0xdf/0x180
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746791]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746796]
[<ffffffff81088c60>] ? try_to_wake_up+0x200/0x200
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746801]
[<ffffffff811afb50>] ? __sync_filesystem+0x90/0x90
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746807]
[<ffffffff81679c4d>] wait_for_completion+0x1d/0x20
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746812]
[<ffffffff811a84de>] sync_inodes_sb+0x8e/0xc0
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746817]
[<ffffffff811afb48>] __sync_filesystem+0x88/0x90
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746822]
[<ffffffff811afb6f>] sync_one_sb+0x1f/0x30
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746826]
[<ffffffff81184a91>] iterate_supers+0x101/0x110
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746830]
[<ffffffff811afc37>] sys_sync+0x47/0x70
Jul  3 00:18:12 vsa-00000018-vc-1 kernel: [ 9960.746833]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.744121] INFO: task
fio:2975 blocked for more than 120 seconds.
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.745759] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747269] fio
  D 0000000000000000     0  2975   2706 0x00000000
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747283]
ffff8800d8bffac8 0000000000000082 0000000009bf6ad8 ffffffff81c1d980
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747288]
ffff8800d8bfffd8 ffff8800d8bfffd8 ffff8800d8bfffd8 00000000000138c0
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747291]
ffff880117660000 ffff8801175b44d0 ffff8800d8bffaa8 ffff88011fc14158
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747293] Call Trace:
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747307]
[<ffffffff81121e50>] ? __lock_page+0x70/0x70
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747317]
[<ffffffff81679c79>] schedule+0x29/0x70
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747320]
[<ffffffff81679d4f>] io_schedule+0x8f/0xd0
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747324]
[<ffffffff81121e5e>] sleep_on_page+0xe/0x20
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747328]
[<ffffffff8167861f>] __wait_on_bit+0x5f/0x90
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747332]
[<ffffffff81121fb8>] wait_on_page_bit+0x78/0x80
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747337]
[<ffffffff81076ca0>] ? autoremove_wake_function+0x40/0x40
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747369]
[<ffffffffa03197f0>] prepare_pages.isra.14+0x240/0x370 [btrfs]
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747383]
[<ffffffffa02f7758>] ? btrfs_delalloc_reserve_metadata+0x1f8/0x380
[btrfs]
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747386]
[<ffffffff8167ab9e>] ? _raw_spin_lock+0xe/0x20
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747405]
[<ffffffffa031a2cd>] __btrfs_buffered_write+0x17d/0x330 [btrfs]
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747423]
[<ffffffffa031a6bd>] btrfs_file_aio_write+0x23d/0x4c0 [btrfs]
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747428]
[<ffffffff811242ef>] ? generic_file_aio_read+0xef/0x280
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747433]
[<ffffffff81181042>] do_sync_write+0xd2/0x110
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747440]
[<ffffffff812e0a38>] ? apparmor_file_permission+0x18/0x20
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747446]
[<ffffffff812a76ec>] ? security_file_permission+0x2c/0xb0
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747449]
[<ffffffff811815d1>] ? rw_verify_area+0x61/0xf0
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747452]
[<ffffffff81181933>] vfs_write+0xb3/0x180
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747455]
[<ffffffff81181c5a>] sys_write+0x4a/0x90
Jul  3 00:20:12 vsa-00000018-vc-1 kernel: [10080.747460]
[<ffffffff816833e9>] system_call_fastpath+0x16/0x1b
Jul  3 03:10:22 vsa-00000018-vc-1 kernel: [20291.040538]
show_signal_msg: 2310 callbacks suppressed
Jul  3 03:10:22 vsa-00000018-vc-1 kernel: [20291.040552] fio[2973]:
segfault at 1cef000 ip 0000000000429f7a sp 00007fff49697cf0 error 4 in
fio[400000+52000]

fio output:
job0: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job1: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job2: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job3: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job4: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job5: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job6: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job7: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job8: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
job9: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=sync, iodepth=1
fio-2.0.8
Starting 10 processes
job0: Laying out IO file(s) (1000 file(s) / 5100MB)
job1: Laying out IO file(s) (1000 file(s) / 5075MB)
job2: Laying out IO file(s) (1000 file(s) / 5027MB)
job3: Laying out IO file(s) (1000 file(s) / 4914MB)
job4: Laying out IO file(s) (1000 file(s) / 4981MB)
job5: Laying out IO file(s) (1000 file(s) / 4931MB)
job6: Laying out IO file(s) (1000 file(s) / 4891MB)
job7: Laying out IO file(s) (1000 file(s) / 5163MB)
job8: Laying out IO file(s) (1000 file(s) / 4853MB)
job9: Laying out IO file(s) (999 file(s) / 5117MB)
fio: pid=2973, got signal=11

job0: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2971
  read : io=2491.5MB, bw=134829 B/s, iops=9 , runt=19375884msec
    clat (usec): min=0 , max=857708 , avg=20919.57, stdev=30157.57
     lat (usec): min=0 , max=857709 , avg=20920.44, stdev=30157.52
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2320], 10.00th=[ 3312], 20.00th=[ 4896],
     | 30.00th=[ 6816], 40.00th=[ 8160], 50.00th=[10176], 60.00th=[13504],
     | 70.00th=[18560], 80.00th=[29056], 90.00th=[49920], 95.00th=[76288],
     | 99.00th=[152576], 99.50th=[189440], 99.90th=[276480], 99.95th=[317440],
     | 99.99th=[415744]
    bw (KB/s)  : min=    0, max= 1289, per=100.00%, avg=145.73, stdev=125.40
  write: io=2471.9MB, bw=133771 B/s, iops=9 , runt=19375848msec
    clat (usec): min=10 , max=12106K, avg=85756.30, stdev=175488.75
     lat (usec): min=10 , max=12106K, avg=85756.84, stdev=175488.75
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   43], 10.00th=[ 4256], 20.00th=[ 8640],
     | 30.00th=[12608], 40.00th=[17792], 50.00th=[26752], 60.00th=[44800],
     | 70.00th=[91648], 80.00th=[207872], 90.00th=[224256], 95.00th=[244736],
     | 99.00th=[333824], 99.50th=[423936], 99.90th=[2998272], 99.95th=[3588096],
     | 99.99th=[5079040]
    bw (KB/s)  : min=    0, max= 1098, per=100.00%, avg=137.70, stdev=72.17
    lat (usec) : 2=0.01%, 4=0.20%, 10=1.61%, 20=0.55%, 50=2.16%
    lat (usec) : 100=0.37%, 250=0.02%, 500=0.01%, 1000=0.01%
    lat (msec) : 2=0.25%, 4=6.56%, 10=24.60%, 20=20.93%, 50=18.76%
    lat (msec) : 100=7.95%, 250=13.86%, 500=2.03%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.10%
  cpu          : usr=0.08%, sys=0.18%, ctx=511723, majf=0, minf=5044
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=181562/w=181084/d=0, short=r=0/w=0/d=0
job1: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2972
  read : io=2465.6MB, bw=136017 B/s, iops=9 , runt=19006854msec
    clat (usec): min=0 , max=676890 , avg=19367.84, stdev=25668.39
     lat (usec): min=0 , max=676890 , avg=19368.44, stdev=25668.36
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2416], 10.00th=[ 3440], 20.00th=[ 4896],
     | 30.00th=[ 6432], 40.00th=[ 7904], 50.00th=[10176], 60.00th=[13376],
     | 70.00th=[18560], 80.00th=[27776], 90.00th=[45824], 95.00th=[68096],
     | 99.00th=[127488], 99.50th=[156672], 99.90th=[228352], 99.95th=[264192],
     | 99.99th=[329728]
    bw (KB/s)  : min=    0, max= 1336, per=100.00%, avg=146.62, stdev=123.92
  write: io=2468.1MB, bw=136204 B/s, iops=9 , runt=19006833msec
    clat (usec): min=9 , max=14876K, avg=85672.50, stdev=176996.64
     lat (usec): min=9 , max=14876K, avg=85673.03, stdev=176996.64
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   53], 10.00th=[ 4576], 20.00th=[ 8640],
     | 30.00th=[12608], 40.00th=[18304], 50.00th=[27520], 60.00th=[44800],
     | 70.00th=[90624], 80.00th=[207872], 90.00th=[222208], 95.00th=[238592],
     | 99.00th=[309248], 99.50th=[419840], 99.90th=[2965504], 99.95th=[3489792],
     | 99.99th=[4882432]
    bw (KB/s)  : min=    0, max= 1075, per=100.00%, avg=139.90, stdev=71.91
    lat (usec) : 2=0.01%, 4=0.14%, 10=1.56%, 20=0.46%, 50=2.03%
    lat (usec) : 100=0.34%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.19%, 4=6.34%, 10=25.21%, 20=20.78%, 50=19.56%
    lat (msec) : 100=7.77%, 250=13.85%, 500=1.63%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.10%
  cpu          : usr=0.09%, sys=0.18%, ctx=508804, majf=0, minf=5022
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=180153/w=180433/d=0, short=r=0/w=0/d=0
job2: (groupid=0, jobs=1): err= 0: pid=2973
    lat (usec) : 2=0.01%, 4=0.12%, 10=1.59%, 20=0.43%, 50=2.12%
    lat (usec) : 100=0.35%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.18%, 4=6.01%, 10=25.66%, 20=21.21%, 50=19.36%
    lat (msec) : 100=7.43%, 250=13.83%, 500=1.57%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.09%
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=177564/w=177672/d=0, short=r=0/w=0/d=0
job3: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2974
  read : io=2390.2MB, bw=140347 B/s, iops=9 , runt=17857819msec
    clat (usec): min=0 , max=887053 , avg=17706.34, stdev=22150.19
     lat (usec): min=0 , max=887053 , avg=17707.05, stdev=22150.29
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2384], 10.00th=[ 3408], 20.00th=[ 4832],
     | 30.00th=[ 6304], 40.00th=[ 7776], 50.00th=[ 9792], 60.00th=[12864],
     | 70.00th=[17536], 80.00th=[25472], 90.00th=[41216], 95.00th=[60160],
     | 99.00th=[109056], 99.50th=[134144], 99.90th=[189440], 99.95th=[218112],
     | 99.99th=[276480]
    bw (KB/s)  : min=    0, max= 1320, per=100.00%, avg=148.80, stdev=127.62
  write: io=2383.6MB, bw=139959 B/s, iops=9 , runt=17857809msec
    clat (usec): min=9 , max=8970.8K, avg=84432.85, stdev=154437.54
     lat (usec): min=9 , max=8970.8K, avg=84433.38, stdev=154437.55
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   49], 10.00th=[ 4512], 20.00th=[ 8640],
     | 30.00th=[12480], 40.00th=[18048], 50.00th=[26752], 60.00th=[43264],
     | 70.00th=[93696], 80.00th=[207872], 90.00th=[222208], 95.00th=[236544],
     | 99.00th=[292864], 99.50th=[415744], 99.90th=[2703360], 99.95th=[3260416],
     | 99.99th=[4177920]
    bw (KB/s)  : min=    0, max= 1120, per=100.00%, avg=142.03, stdev=74.82
    lat (usec) : 2=0.01%, 4=0.15%, 10=1.65%, 20=0.47%, 50=2.11%
    lat (usec) : 100=0.36%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.19%, 4=6.20%, 10=25.65%, 20=21.48%, 50=19.38%
    lat (msec) : 100=6.86%, 250=13.95%, 500=1.44%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.08%
  cpu          : usr=0.09%, sys=0.18%, ctx=493832, majf=2, minf=4827
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=173997/w=174260/d=0, short=r=0/w=0/d=0
job4: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2975
  read : io=2400.2MB, bw=132928 B/s, iops=9 , runt=18933247msec
    clat (usec): min=0 , max=862323 , avg=17747.97, stdev=21405.61
     lat (usec): min=0 , max=862324 , avg=17748.77, stdev=21405.65
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2448], 10.00th=[ 3472], 20.00th=[ 4960],
     | 30.00th=[ 6496], 40.00th=[ 7904], 50.00th=[10048], 60.00th=[13120],
     | 70.00th=[17792], 80.00th=[25728], 90.00th=[41728], 95.00th=[60160],
     | 99.00th=[105984], 99.50th=[127488], 99.90th=[173056], 99.95th=[197632],
     | 99.99th=[240640]
    bw (KB/s)  : min=    0, max= 1237, per=100.00%, avg=148.37, stdev=123.43
  write: io=2434.1MB, bw=134855 B/s, iops=9 , runt=18933206msec
    clat (usec): min=10 , max=584767K, avg=89479.53, stdev=1404088.00
     lat (usec): min=10 , max=584767K, avg=89480.07, stdev=1404088.00
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   47], 10.00th=[ 4576], 20.00th=[ 8512],
     | 30.00th=[12480], 40.00th=[18048], 50.00th=[26752], 60.00th=[43264],
     | 70.00th=[89600], 80.00th=[209920], 90.00th=[222208], 95.00th=[238592],
     | 99.00th=[329728], 99.50th=[428032], 99.90th=[3031040], 99.95th=[3489792],
     | 99.99th=[5013504]
    bw (KB/s)  : min=    0, max= 1263, per=100.00%, avg=143.23, stdev=70.67
    lat (usec) : 2=0.01%, 4=0.15%, 10=1.59%, 20=0.49%, 50=2.18%
    lat (usec) : 100=0.35%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.16%, 4=6.00%, 10=25.52%, 20=21.50%, 50=19.68%
    lat (msec) : 100=7.07%, 250=13.58%, 500=1.59%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.10%
  cpu          : usr=0.08%, sys=0.18%, ctx=499570, majf=0, minf=4868
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=174353/w=176293/d=0, short=r=0/w=0/d=0
job5: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2976
  read : io=2391.2MB, bw=133960 B/s, iops=9 , runt=18716957msec
    clat (usec): min=0 , max=891313 , avg=17602.87, stdev=21152.14
     lat (usec): min=1 , max=891314 , avg=17603.74, stdev=21152.97
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2416], 10.00th=[ 3472], 20.00th=[ 4896],
     | 30.00th=[ 6432], 40.00th=[ 7840], 50.00th=[ 9920], 60.00th=[13120],
     | 70.00th=[17792], 80.00th=[25472], 90.00th=[41216], 95.00th=[59136],
     | 99.00th=[104960], 99.50th=[125440], 99.90th=[171008], 99.95th=[193536],
     | 99.99th=[236544]
    bw (KB/s)  : min=    0, max= 1581, per=100.00%, avg=148.09, stdev=122.04
  write: io=2395.2MB, bw=134185 B/s, iops=9 , runt=18716860msec
    clat (usec): min=11 , max=386265K, avg=89290.72, stdev=977978.29
     lat (usec): min=11 , max=386265K, avg=89291.25, stdev=977978.29
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   48], 10.00th=[ 4576], 20.00th=[ 8512],
     | 30.00th=[12480], 40.00th=[18048], 50.00th=[27008], 60.00th=[43776],
     | 70.00th=[93696], 80.00th=[209920], 90.00th=[222208], 95.00th=[238592],
     | 99.00th=[317440], 99.50th=[423936], 99.90th=[2932736], 99.95th=[3424256],
     | 99.99th=[4751360]
    bw (KB/s)  : min=    0, max= 1385, per=100.00%, avg=141.05, stdev=64.15
    lat (usec) : 2=0.01%, 4=0.16%, 10=1.63%, 20=0.48%, 50=2.14%
    lat (usec) : 100=0.35%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.17%, 4=6.01%, 10=25.63%, 20=21.42%, 50=19.63%
    lat (msec) : 100=6.95%, 250=13.69%, 500=1.59%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.10%
  cpu          : usr=0.08%, sys=0.18%, ctx=497146, majf=0, minf=4853
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=174488/w=174566/d=0, short=r=0/w=0/d=0
job6: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2977
  read : io=2385.6MB, bw=139486 B/s, iops=9 , runt=17932764msec
    clat (usec): min=0 , max=1125.3K, avg=17923.32, stdev=22716.56
     lat (usec): min=0 , max=1125.3K, avg=17927.72, stdev=22731.16
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2416], 10.00th=[ 3440], 20.00th=[ 4896],
     | 30.00th=[ 6368], 40.00th=[ 7776], 50.00th=[ 9792], 60.00th=[12992],
     | 70.00th=[17536], 80.00th=[25728], 90.00th=[41728], 95.00th=[61696],
     | 99.00th=[112128], 99.50th=[136192], 99.90th=[189440], 99.95th=[211968],
     | 99.99th=[264192]
    bw (KB/s)  : min=    0, max= 1299, per=100.00%, avg=148.31, stdev=124.58
  write: io=2370.9MB, bw=138631 B/s, iops=9 , runt=17932561msec
    clat (usec): min=9 , max=8897.9K, avg=85392.70, stdev=157427.16
     lat (usec): min=10 , max=8897.9K, avg=85393.23, stdev=157427.17
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   49], 10.00th=[ 4576], 20.00th=[ 8640],
     | 30.00th=[12480], 40.00th=[18048], 50.00th=[27008], 60.00th=[44288],
     | 70.00th=[96768], 80.00th=[207872], 90.00th=[222208], 95.00th=[238592],
     | 99.00th=[296960], 99.50th=[419840], 99.90th=[2736128], 99.95th=[3260416],
     | 99.99th=[4358144]
    bw (KB/s)  : min=    0, max=  973, per=100.00%, avg=140.76, stdev=70.43
    lat (usec) : 2=0.01%, 4=0.14%, 10=1.60%, 20=0.48%, 50=2.11%
    lat (usec) : 100=0.34%, 250=0.03%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.20%, 4=6.19%, 10=25.72%, 20=21.31%, 50=19.25%
    lat (msec) : 100=7.05%, 250=14.00%, 500=1.50%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.08%
  cpu          : usr=0.09%, sys=0.18%, ctx=491998, majf=0, minf=4825
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=173755/w=172811/d=0, short=r=0/w=0/d=0
job7: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2978
  read : io=2505.2MB, bw=137126 B/s, iops=9 , runt=19162681msec
    clat (usec): min=0 , max=529888 , avg=17997.31, stdev=22709.91
     lat (usec): min=1 , max=529888 , avg=17998.78, stdev=22710.20
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2384], 10.00th=[ 3408], 20.00th=[ 4832],
     | 30.00th=[ 6368], 40.00th=[ 7776], 50.00th=[ 9792], 60.00th=[12864],
     | 70.00th=[17536], 80.00th=[25728], 90.00th=[42240], 95.00th=[61696],
     | 99.00th=[113152], 99.50th=[138240], 99.90th=[197632], 99.95th=[220160],
     | 99.99th=[280576]
    bw (KB/s)  : min=    0, max= 1299, per=100.00%, avg=150.86, stdev=123.59
  write: io=2504.4MB, bw=137035 B/s, iops=9 , runt=19162649msec
    clat (usec): min=9 , max=384337K, avg=87058.85, stdev=918383.55
     lat (usec): min=10 , max=384337K, avg=87059.40, stdev=918383.55
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   51], 10.00th=[ 4512], 20.00th=[ 8384],
     | 30.00th=[12352], 40.00th=[17792], 50.00th=[26240], 60.00th=[42240],
     | 70.00th=[86528], 80.00th=[207872], 90.00th=[222208], 95.00th=[238592],
     | 99.00th=[321536], 99.50th=[423936], 99.90th=[2965504], 99.95th=[3489792],
     | 99.99th=[4816896]
    bw (KB/s)  : min=    0, max= 1412, per=100.00%, avg=143.60, stdev=69.52
    lat (usec) : 2=0.01%, 4=0.19%, 10=1.59%, 20=0.50%, 50=2.06%
    lat (usec) : 100=0.35%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.18%, 4=6.43%, 10=25.73%, 20=21.31%, 50=19.41%
    lat (msec) : 100=7.09%, 250=13.43%, 500=1.60%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.10%
  cpu          : usr=0.08%, sys=0.18%, ctx=517322, majf=0, minf=5020
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=182283/w=181812/d=0, short=r=0/w=0/d=0
job8: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2979
  read : io=2356.8MB, bw=133678 B/s, iops=9 , runt=18486492msec
    clat (usec): min=0 , max=1035.4K, avg=19644.75, stdev=26623.29
     lat (usec): min=1 , max=1035.4K, avg=19645.98, stdev=26623.37
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2416], 10.00th=[ 3440], 20.00th=[ 4896],
     | 30.00th=[ 6432], 40.00th=[ 7904], 50.00th=[10048], 60.00th=[13376],
     | 70.00th=[18560], 80.00th=[27776], 90.00th=[46848], 95.00th=[70144],
     | 99.00th=[132096], 99.50th=[160768], 99.90th=[232448], 99.95th=[272384],
     | 99.99th=[366592]
    bw (KB/s)  : min=    0, max= 1434, per=100.00%, avg=142.83, stdev=121.65
  write: io=2361.8MB, bw=133961 B/s, iops=9 , runt=18486447msec
    clat (usec): min=8 , max=15642K, avg=87303.80, stdev=168164.18
     lat (usec): min=8 , max=15642K, avg=87304.33, stdev=168164.18
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   50], 10.00th=[ 4576], 20.00th=[ 8640],
     | 30.00th=[12736], 40.00th=[18560], 50.00th=[28544], 60.00th=[47360],
     | 70.00th=[103936], 80.00th=[209920], 90.00th=[222208], 95.00th=[240640],
     | 99.00th=[305152], 99.50th=[419840], 99.90th=[2899968], 99.95th=[3358720],
     | 99.99th=[4358144]
    bw (KB/s)  : min=    0, max=  989, per=100.00%, avg=136.59, stdev=68.79
    lat (usec) : 2=0.01%, 4=0.14%, 10=1.60%, 20=0.43%, 50=2.13%
    lat (usec) : 100=0.32%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.20%, 4=6.24%, 10=25.19%, 20=20.55%, 50=19.11%
    lat (msec) : 100=7.77%, 250=14.50%, 500=1.69%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.10%
  cpu          : usr=0.08%, sys=0.18%, ctx=486694, majf=0, minf=4834
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=172010/w=172407/d=0, short=r=0/w=0/d=0
job9: (groupid=0, jobs=1): err=84 (file:io_u.c:1487,
func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide
character): pid=2980
  read : io=2492.4MB, bw=134240 B/s, iops=9 , runt=19467910msec
    clat (usec): min=0 , max=561451 , avg=20419.23, stdev=29312.48
     lat (usec): min=0 , max=561452 , avg=20419.83, stdev=29312.44
    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[ 2224], 10.00th=[ 3184], 20.00th=[ 4704],
     | 30.00th=[ 6432], 40.00th=[ 7904], 50.00th=[ 9792], 60.00th=[13120],
     | 70.00th=[18304], 80.00th=[28544], 90.00th=[49408], 95.00th=[74240],
     | 99.00th=[146432], 99.50th=[181248], 99.90th=[264192], 99.95th=[309248],
     | 99.99th=[382976]
    bw (KB/s)  : min=    0, max= 1492, per=100.00%, avg=146.12, stdev=123.90
  write: io=2489.9MB, bw=134107 B/s, iops=9 , runt=19467892msec
    clat (usec): min=10 , max=131194K, avg=86442.14, stdev=357275.36
     lat (usec): min=10 , max=131194K, avg=86442.68, stdev=357275.37
    clat percentiles (usec):
     |  1.00th=[   20],  5.00th=[   40], 10.00th=[ 3952], 20.00th=[ 8096],
     | 30.00th=[12096], 40.00th=[17024], 50.00th=[25984], 60.00th=[44288],
     | 70.00th=[91648], 80.00th=[207872], 90.00th=[224256], 95.00th=[244736],
     | 99.00th=[346112], 99.50th=[428032], 99.90th=[3031040], 99.95th=[3522560],
     | 99.99th=[5079040]
    bw (KB/s)  : min=    0, max=  923, per=100.00%, avg=138.94, stdev=71.74
    lat (usec) : 2=0.01%, 4=0.22%, 10=1.63%, 20=0.57%, 50=2.18%
    lat (usec) : 100=0.36%, 250=0.02%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.38%, 4=7.25%, 10=24.95%, 20=20.41%, 50=18.16%
    lat (msec) : 100=7.87%, 250=13.83%, 500=2.02%, 750=0.01%, 1000=0.01%
    lat (msec) : 2000=0.01%, >=2000=0.10%
  cpu          : usr=0.08%, sys=0.18%, ctx=515307, majf=0, minf=5046
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=182023/w=181629/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=21879MB, aggrb=1KB/s, minb=0KB/s, maxb=137KB/s,
mint=17857819msec, maxt=18501748936msec
  WRITE: io=21881MB, aggrb=1KB/s, minb=0KB/s, maxb=136KB/s,
mint=17857809msec, maxt=18501748936msec
fio: file hash not empty on exit

fio crash:
(gdb) bt
#0  0x0000000000429f7a in fio_md5_update (mctx=0x7fff49698040,
data=0x1ceefc8 "", len=<optimized out>) at
/usr/include/x86_64-linux-gnu/bits/string3.h:52
#1  0x0000000000419077 in fill_md5 (len=472, p=0x1ceef48,
hdr=0x1ceef20) at verify.c:850
#2  populate_hdr (td=0x7fbe446f2460, io_u=0x7fff49698250,
hdr=0x1ceef20, header_num=88, header_len=<optimized out>) at
verify.c:875
#3  0x000000000041967b in fill_pattern_headers (use_seed=1,
seed=<optimized out>, io_u=0x7fff49698250, td=0x7fbe446f2460) at
verify.c:100
#4  dump_verify_buffers (vc=0x7fff496984d0, hdr=<optimized out>) at verify.c:277
#5  0x000000000041aadd in verify_io_u_md5 (vc=0x7fff496984d0,
hdr=0xc9bc90) at verify.c:588
#6  verify_io_u (td=0x7fbe446f2460, io_u=0xc7b530) at verify.c:713
#7  0x000000000041e896 in io_completed (td=0x7fbe446f2460,
io_u=0xc7b530, icd=0x7fff49698710) at io_u.c:1423
#8  0x000000000041ebb9 in io_u_sync_complete (td=0x7fbe446f2460,
io_u=0xc7b530, bytes=0x0) at io_u.c:1481
#9  0x0000000000438b17 in do_verify (td=0x7fbe446f2460) at backend.c:476
#10 thread_main (data=0x7fbe446f2460) at backend.c:1136
#11 0x000000000043918a in fork_main (offset=2, shmid=<optimized out>)
at backend.c:1250
#12 run_threads () at backend.c:1492
#13 0x00000000004395fd in fio_backend () at backend.c:1662
#14 0x00007fbe4942576d in __libc_start_main () from
/lib/x86_64-linux-gnu/libc.so.6
#15 0x0000000000407ead in _start ()


48      __extern_always_inline void *
49      __NTH (memcpy (void *__restrict __dest, __const void *__restrict __src,
50                     size_t __len))
51      {
52        return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
53      }



On Mon, Jul 2, 2012 at 3:49 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Jul 02, 2012 at 05:48:43AM -0600, Alex Lyakas wrote:
>> Hi Josef,
>> which branch from your (or another?) repo should I try this on:
>>
>
> Master, and make sure you've checked out a more recent fio from git to make sure
> it's not a bug in fio.  Thanks,
>
> Josef
