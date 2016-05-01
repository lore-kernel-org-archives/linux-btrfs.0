Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44823 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcEAKWw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 06:22:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1awoWY-0007A8-BN
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 12:22:50 +0200
Received: from ip5f5ae06c.dynamic.kabel-deutschland.de ([95.90.224.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 12:22:50 +0200
Received: from hurikhan77 by ip5f5ae06c.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 12:22:50 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: commands like "du", "df", and "btrfs fs sync" hang
Date: Sun, 1 May 2016 12:22:39 +0200
Message-ID: <20160501122239.6ba04ff8@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I'm not sure what triggeres this, neither if it is btrfs specific. The
filesystems have been recreated from scratch. Mainly during my rsync
backup (from btrfs to btrfs), but not necessarily limited to rsync
usage, my system experiences uninterruptable freezes of commands like
"df", "du", "btrfs fs sync", and probably more.

I created a backtrace in dmesg using sysrq+w. Here's the log:
(https://gist.github.com/kakra/8e6a2b7ac4047fa9e345648664f5667b)

[92481.503505] sysrq: SysRq : Show Blocked State
[92481.503511]   task                        PC stack   pid father
[92481.503603] ksysguardd      D 00000000000141c0     0 32516      1
0x00000004 [92481.503609]  ffff880231748c00 ffff88032a468000
ffff88032a467bc0 ffff880231748c00 [92481.503612]  ffff880403cd8f20
ffff880403cd8f00 0000000000000000 ffffffff817167cc [92481.503615]
7fffffffffffffff ffffffff817190df ffff88032a467bc0 ffffffff810b4d99
[92481.503617] Call Trace: [92481.503625]  [<ffffffff817167cc>] ?
schedule+0x2c/0x80 [92481.503630]  [<ffffffff817190df>] ?
schedule_timeout+0x13f/0x1a0 [92481.503635]  [<ffffffff810b4d99>] ?
finish_wait+0x29/0x60 [92481.503639]  [<ffffffff81718229>] ?
mutex_lock+0x9/0x30 [92481.503642]  [<ffffffff811e0e23>] ?
autofs4_wait+0x433/0x710 [92481.503646]  [<ffffffff81717012>] ?
wait_for_completion+0x92/0xf0 [92481.503649]  [<ffffffff810a2b80>] ?
wake_up_q+0x60/0x60 [92481.503652]  [<ffffffff811e1a4f>] ?
autofs4_expire_wait+0x5f/0x80 [92481.503654]  [<ffffffff811dfa36>] ?
autofs4_d_manage+0x56/0x150 [92481.503657]  [<ffffffff8117b811>] ?
follow_managed+0x91/0x2c0 [92481.503660]  [<ffffffff8117bcd2>] ?
lookup_fast+0x102/0x300 [92481.503662]  [<ffffffff8117d3f1>] ?
walk_component+0x31/0x450 [92481.503665]  [<ffffffff8117ddc8>] ?
path_lookupat+0x58/0x100 [92481.503667]  [<ffffffff811800d5>] ?
filename_lookup+0x95/0x110 [92481.503671]  [<ffffffff8115b55e>] ?
kmem_cache_alloc+0x10e/0x160 [92481.503674]  [<ffffffff8117fdeb>] ?
getname_flags+0x4b/0x170 [92481.503677]  [<ffffffff8119cc8a>] ?
user_statfs+0x2a/0x80 [92481.503679]  [<ffffffff8119ccf0>] ?
SYSC_statfs+0x10/0x30 [92481.503683]  [<ffffffff8103ea53>] ?
__do_page_fault+0x1a3/0x400 [92481.503686]  [<ffffffff81719cd7>] ?
entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503688] trash.so        D
00000000000141c0     0   449   1478 0x00000004 [92481.503691]
ffff8802ee5b1800 ffff88022c720000 ffff88022c71fb70 ffff8802ee5b1800
[92481.503694]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
ffffffff817167cc [92481.503697]  7fffffffffffffff ffffffff817190df
ffff88022c71fb70 ffffffff810b4d99 [92481.503699] Call Trace:
[92481.503702]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
[92481.503706]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
[92481.503709]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
[92481.503712]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
[92481.503714]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
[92481.503717]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
[92481.503720]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
[92481.503722]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
[92481.503724]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
[92481.503727]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
[92481.503729]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
[92481.503731]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
[92481.503734]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
[92481.503736]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
[92481.503738]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
[92481.503741]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
[92481.503743]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
[92481.503746]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
[92481.503749]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
[92481.503752]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
[92481.503754]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
[92481.503757]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
[92481.503760]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
[92481.503763]  [<ffffffff81719cd7>] ?
entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503766] ksysguardd      D
00000000000141c0     0  9869      1 0x00000004 [92481.503769]
ffff880092012400 ffff880203868000 ffff880203867bc0 ffff880092012400
[92481.503771]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
ffffffff817167cc [92481.503774]  7fffffffffffffff ffffffff817190df
ffff880203867bc0 ffffffff810b4d99 [92481.503776] Call Trace:
[92481.503779]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
[92481.503782]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
[92481.503786]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
[92481.503789]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
[92481.503791]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
[92481.503794]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
[92481.503797]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
[92481.503799]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
[92481.503801]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
[92481.503803]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
[92481.503806]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
[92481.503808]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
[92481.503810]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
[92481.503813]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
[92481.503815]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
[92481.503818]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
[92481.503820]  [<ffffffff8119cc8a>] ? user_statfs+0x2a/0x80
[92481.503822]  [<ffffffff8119ccf0>] ? SYSC_statfs+0x10/0x30
[92481.503825]  [<ffffffff8103ea53>] ? __do_page_fault+0x1a3/0x400
[92481.503827]  [<ffffffff81719cd7>] ?
entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503830] trash.so        D
0000000000000000     0 14351   1478 0x00000004 [92481.503833]
ffff8803072ac800 ffff8800438fc000 ffff8800438fbb70 ffff8803072ac800
[92481.503835]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
ffffffff817167cc [92481.503838]  7fffffffffffffff ffffffff817190df
0000000000000010 0000000000000287 [92481.503841] Call Trace:
[92481.503844]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
[92481.503847]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
[92481.503850]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
[92481.503852]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
[92481.503855]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
[92481.503858]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
[92481.503860]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
[92481.503862]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
[92481.503864]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
[92481.503866]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
[92481.503869]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
[92481.503871]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
[92481.503873]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
[92481.503876]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
[92481.503878]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
[92481.503880]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
[92481.503883]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
[92481.503886]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
[92481.503889]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
[92481.503891]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
[92481.503893]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
[92481.503895]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
[92481.503898]  [<ffffffff81719cd7>] ?
entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503901] trash.so        D
0000000000000000     0 17062   1478 0x00000004 [92481.503903]
ffff880350ee4800 ffff8801e4d5c000 ffff8801e4d5bb70 ffff880350ee4800
[92481.503906]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
ffffffff817167cc [92481.503908]  7fffffffffffffff ffffffff817190df
ffff8801e4d5bb70 ffffffff810b4d99 [92481.503911] Call Trace:
[92481.503914]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
[92481.503917]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
[92481.503920]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
[92481.503923]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
[92481.503925]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
[92481.503928]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
[92481.503931]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
[92481.503934]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
[92481.503936]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
[92481.503938]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
[92481.503940]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
[92481.503942]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
[92481.503945]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
[92481.503947]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
[92481.503949]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
[92481.503951]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
[92481.503954]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
[92481.503956]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
[92481.503959]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
[92481.503962]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
[92481.503964]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
[92481.503966]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
[92481.503969]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
[92481.503971]  [<ffffffff81719cd7>] ?
entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503973] df              D
00000000000141c0     0 20885  20797 0x00000004 [92481.503976]
ffff8803c42e6000 ffff8801001b4000 ffff8801001b3bd0 ffff8803c42e6000
[92481.503979]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
ffffffff817167cc [92481.503981]  7fffffffffffffff ffffffff817190df
ffff8801001b3bd0 ffffffff810b4d99 [92481.503984] Call Trace:
[92481.503987]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
[92481.503990]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
[92481.503993]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
[92481.503996]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
[92481.503999]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
[92481.504002]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
[92481.504005]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
[92481.504007]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
[92481.504009]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
[92481.504011]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
[92481.504013]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
[92481.504016]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
[92481.504018]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
[92481.504020]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
[92481.504023]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
[92481.504026]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
[92481.504028]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
[92481.504031]  [<ffffffff81176d9a>] ? SYSC_newstat+0x1a/0x40
[92481.504034]  [<ffffffff81719cd7>] ?
entry_SYSCALL_64_fastpath+0x12/0x6a


-- 
Regards,
Kai

Replies to list-only preferred.

