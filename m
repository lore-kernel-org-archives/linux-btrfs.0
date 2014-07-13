Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47100 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaGMOql (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 10:46:41 -0400
Date: Sun, 13 Jul 2014 07:46:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: Konstantin Svist <fry.kun@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140713144631.GJ10641@merlins.org>
References: <53B6DDAD.20504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B6DDAD.20504@gmail.com>
Subject: Re: btrfs partition remounted read-only
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 10:00:29AM -0700, Konstantin Svist wrote:
> I have an overnight cron job with
> 
> /sbin/fstrim -v /
> /bin/bedup dedup --defrag
> 
> Every once in a while, it causes the FS to be remounted read-only.
> Problem is pretty intermittent so far (aside from a few kernel revisions
> a while ago).
> 
> Please advise.
> 
> Corresponding bugs:
> https://bugzilla.kernel.org/show_bug.cgi?id=71311

You probably want to post the traces here:

[107813.098088] CPU: 3 PID: 8368 Comm: bedup Not tainted 3.14.9-200.fc20.x86_64 #1
[107813.098089] Hardware name: LENOVO                           IdeaPad Z470    /KL6                             , BIOS 4ACN35WW   08/29/2011
[107813.098090]  0000000000000000 00000000bdb928a1 ffff880041bd9b08 ffffffff816ef90e
[107813.098092]  ffff880041bd9b50 ffff880041bd9b40 ffffffff8108a0fd 00000000ffffffe4
[107813.098094]  ffff880060d1a000 ffff880155c90280 ffffffffa024adc0 0000000000000c30
[107813.098096] Call Trace:
[107813.098101]  [<ffffffff816ef90e>] dump_stack+0x45/0x56
[107813.098106]  [<ffffffff8108a0fd>] warn_slowpath_common+0x7d/0xa0
[107813.098109]  [<ffffffff8108a17c>] warn_slowpath_fmt+0x5c/0x80
[107813.098117]  [<ffffffffa01a5ff0>] __btrfs_abort_transaction+0x50/0x110 [btrfs]
[107813.098129]  [<ffffffffa02042d7>] btrfs_clone+0xa07/0xab0 [btrfs]
[107813.098139]  [<ffffffffa02047bc>] btrfs_ioctl_clone+0x43c/0x460 [btrfs]
[107813.098149]  [<ffffffffa02080bc>] btrfs_ioctl+0x14cc/0x2b90 [btrfs]
[107813.098159]  [<ffffffffa01f4a03>] ? extent_fiemap+0x473/0x5b0 [btrfs]
[107813.098169]  [<ffffffffa01d7860>] ? btrfs_get_extent+0xb30/0xb30 [btrfs]
[107813.098172]  [<ffffffff811fcb20>] do_vfs_ioctl+0x2e0/0x4a0
[107813.098174]  [<ffffffff811fcd61>] SyS_ioctl+0x81/0xa0
[107813.098177]  [<ffffffff81121c36>] ? __audit_syscall_exit+0x1f6/0x2a0
[107813.098179]  [<ffffffff816ffc29>] system_call_fastpath+0x16/0x1b
[107813.098181] ---[ end trace 95cf16695eb777ef ]---
[107813.098183] BTRFS: error (device sda2) in btrfs_clone:3120: errno=-28 No space left
[107813.098185] BTRFS info (device sda2): forced readonly
[107813.099645] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.099681] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.099717] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.107011] ------------[ cut here ]------------
[107813.107043] WARNING: CPU: 2 PID: 296 at fs/btrfs/inode.c:4927 btrfs_invalidate_inodes+0x1b7/0x1c0 [btrfs]()
[107813.107044] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ccm btusb fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT 6lowpan_iphc xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iTCO_wdt iTCO_vendor_support ppdev x86_pkg_temp_thermal coretemp kvm_intel arc4 snd_hda_codec_hdmi kvm iwldvm crct10dif_pclmul snd_hda_codec_realtek crc32_pclmul snd_hda_codec_generic mac80211 crc32c_intel ghash_clmulni_intel uvcvideo videobuf2_vmalloc videobuf2_memops snd_hda_intel videobuf2_core snd_hda_codec videodev snd_hwdep
[107813.107067]  microcode media snd_seq snd_seq_device iwlwifi joydev snd_pcm serio_raw cfg80211 lpc_ich mfd_core i2c_i801 snd_timer snd shpchp soundcore mei_me mei wmi ideapad_laptop sparse_keymap parport_pc rfkill parport nfsd auth_rpcgss nfs_acl lockd binfmt_misc sunrpc btrfs xor raid6_pq i915 i2c_algo_bit drm_kms_helper drm r8169 mii i2c_core video
[107813.107085] CPU: 2 PID: 296 Comm: btrfs-transacti Tainted: G        W    3.14.9-200.fc20.x86_64 #1
[107813.107086] Hardware name: LENOVO                           IdeaPad Z470    /KL6                             , BIOS 4ACN35WW   08/29/2011
[107813.107088]  0000000000000000 00000000579278d6 ffff88022090dd68 ffffffff816ef90e
[107813.107090]  0000000000000000 ffff88022090dda0 ffffffff8108a0fd ffff88003654b4c0
[107813.107092]  ffff88003654b4d8 ffff88022090de20 ffff88003654b000 ffff8801a865c0f8
[107813.107094] Call Trace:
[107813.107099]  [<ffffffff816ef90e>] dump_stack+0x45/0x56
[107813.107104]  [<ffffffff8108a0fd>] warn_slowpath_common+0x7d/0xa0
[107813.107106]  [<ffffffff8108a22a>] warn_slowpath_null+0x1a/0x20
[107813.107117]  [<ffffffffa01ddcf7>] btrfs_invalidate_inodes+0x1b7/0x1c0 [btrfs]
[107813.107127]  [<ffffffffa01cddf5>] btrfs_cleanup_transaction+0x415/0x540 [btrfs]
[107813.107136]  [<ffffffffa01ce136>] transaction_kthread+0x216/0x250 [btrfs]
[107813.107146]  [<ffffffffa01cdf20>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[107813.107148]  [<ffffffff810ae1a8>] kthread+0xd8/0xf0
[107813.107150]  [<ffffffff810ae0d0>] ? insert_kthread_work+0x40/0x40
[107813.107153]  [<ffffffff816ffb7c>] ret_from_fork+0x7c/0xb0
[107813.107155]  [<ffffffff810ae0d0>] ? insert_kthread_work+0x40/0x40
[107813.107156] ---[ end trace 95cf16695eb777f0 ]---
[107813.108289] ------------[ cut here ]------------
[107813.108312] WARNING: CPU: 2 PID: 296 at fs/btrfs/inode.c:4927 btrfs_invalidate_inodes+0x1b7/0x1c0 [btrfs]()
[107813.108313] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ccm btusb fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT 6lowpan_iph
c xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_m
angle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_
mangle iptable_security iptable_raw iTCO_wdt iTCO_vendor_support ppdev x86_pkg_temp_thermal coretemp kvm_intel arc4 snd_hda_codec_hdmi kvm iwldvm crc
t10dif_pclmul snd_hda_codec_realtek crc32_pclmul snd_hda_codec_generic mac80211 crc32c_intel ghash_clmulni_intel uvcvideo videobuf2_vmalloc videobuf2
_memops snd_hda_intel videobuf2_core snd_hda_codec videodev snd_hwdep
[107813.108336]  microcode media snd_seq snd_seq_device iwlwifi joydev snd_pcm serio_raw cfg80211 lpc_ich mfd_core i2c_i801 snd_timer snd shpchp soun
dcore mei_me mei wmi ideapad_laptop sparse_keymap parport_pc rfkill parport nfsd auth_rpcgss nfs_acl lockd binfmt_misc sunrpc btrfs xor raid6_pq i915
 i2c_algo_bit drm_kms_helper drm r8169 mii i2c_core video
[107813.108352] CPU: 2 PID: 296 Comm: btrfs-transacti Tainted: G        W    3.14.9-200.fc20.x86_64 #1
[107813.108354] Hardware name: LENOVO                           IdeaPad Z470    /KL6                             , BIOS 4ACN35WW   08/29/2011
[107813.108355]  0000000000000000 00000000579278d6 ffff88022090dd68 ffffffff816ef90e
[107813.108357]  0000000000000000 ffff88022090dda0 ffffffff8108a0fd ffff88003654b4c0
[107813.108359]  ffff88003654b4d8 ffff88022090de20 ffff88003654b000 ffff8800c44088e8
[107813.108361] Call Trace:
[107813.108366]  [<ffffffff816ef90e>] dump_stack+0x45/0x56
[107813.108370]  [<ffffffff8108a0fd>] warn_slowpath_common+0x7d/0xa0
[107813.108372]  [<ffffffff8108a22a>] warn_slowpath_null+0x1a/0x20
[107813.108382]  [<ffffffffa01ddcf7>] btrfs_invalidate_inodes+0x1b7/0x1c0 [btrfs]
[107813.108392]  [<ffffffffa01cddf5>] btrfs_cleanup_transaction+0x415/0x540 [btrfs]
[107813.108401]  [<ffffffffa01ce136>] transaction_kthread+0x216/0x250 [btrfs]
[107813.108411]  [<ffffffffa01cdf20>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[107813.108413]  [<ffffffff810ae1a8>] kthread+0xd8/0xf0
[107813.108415]  [<ffffffff810ae0d0>] ? insert_kthread_work+0x40/0x40
[107813.108417]  [<ffffffff816ffb7c>] ret_from_fork+0x7c/0xb0
[107813.108419]  [<ffffffff810ae0d0>] ? insert_kthread_work+0x40/0x40
[107813.108420] ---[ end trace 95cf16695eb777f1 ]---
[107813.108827] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.108891] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.108933] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.108980] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109038] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109229] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109281] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109319] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109358] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109360] ------------[ cut here ]------------
[107813.109380] WARNING: CPU: 2 PID: 296 at fs/btrfs/inode.c:4927 btrfs_invalidate_inodes+0x1b7/0x1c0 [btrfs]()
[107813.109382] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ccm btusb fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT 6lowpan_iphc xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iTCO_wdt iTCO_vendor_support ppdev x86_pkg_temp_thermal coretemp kvm_intel arc4 snd_hda_codec_hdmi kvm iwldvm crct10dif_pclmul snd_hda_codec_realtek crc32_pclmul snd_hda_codec_generic mac80211 crc32c_intel ghash_clmulni_intel uvcvideo videobuf2_vmalloc videobuf2_memops snd_hda_intel videobuf2_core snd_hda_codec videodev snd_hwdep
[107813.109405]  microcode media snd_seq snd_seq_device iwlwifi joydev snd_pcm serio_raw cfg80211 lpc_ich mfd_core i2c_i801 snd_timer snd shpchp soundcore mei_me mei wmi ideapad_laptop sparse_keymap parport_pc rfkill parport nfsd auth_rpcgss nfs_acl lockd binfmt_misc sunrpc btrfs xor raid6_pq i915 i2c_algo_bit drm_kms_helper drm r8169 mii i2c_core video
[107813.109421] CPU: 2 PID: 296 Comm: btrfs-transacti Tainted: G        W    3.14.9-200.fc20.x86_64 #1
[107813.109423] Hardware name: LENOVO                           IdeaPad Z470    /KL6                             , BIOS 4ACN35WW   08/29/2011
[107813.109424]  0000000000000000 00000000579278d6 ffff88022090dd68 ffffffff816ef90e
[107813.109427] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109427]  0000000000000000 ffff88022090dda0 ffffffff8108a0fd ffff88003654b4c0
[107813.109430]  ffff88003654b4d8 ffff88022090de20 ffff88003654b000 ffff8802212a7490
[107813.109434] Call Trace:
[107813.109438]  [<ffffffff816ef90e>] dump_stack+0x45/0x56
[107813.109442]  [<ffffffff8108a0fd>] warn_slowpath_common+0x7d/0xa0
[107813.109444]  [<ffffffff8108a22a>] warn_slowpath_null+0x1a/0x20
[107813.109454]  [<ffffffffa01ddcf7>] btrfs_invalidate_inodes+0x1b7/0x1c0 [btrfs]
[107813.109463]  [<ffffffffa01cddf5>] btrfs_cleanup_transaction+0x415/0x540 [btrfs]
[107813.109472]  [<ffffffffa01ce136>] transaction_kthread+0x216/0x250 [btrfs]
[107813.109473] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109484]  [<ffffffffa01cdf20>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[107813.109486]  [<ffffffff810ae1a8>] kthread+0xd8/0xf0
[107813.109488]  [<ffffffff810ae0d0>] ? insert_kthread_work+0x40/0x40
[107813.109490]  [<ffffffff816ffb7c>] ret_from_fork+0x7c/0xb0
[107813.109492]  [<ffffffff810ae0d0>] ? insert_kthread_work+0x40/0x40
[107813.109493] ---[ end trace 95cf16695eb777f2 ]---
[107813.109510] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system
[107813.109549] systemd-journald[377]: Failed to truncate file to its own size: Read-only file system

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
