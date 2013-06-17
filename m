Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab3FQReZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 13:34:25 -0400
Date: Mon, 17 Jun 2013 09:49:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
Message-ID: <20130617134955.GB15861@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hit this while running this script in a loop..
https://github.com/kernelslacker/io-tests/blob/master/setup.sh

[34385.251507] ------------[ cut here ]------------
[34385.254068] WARNING: at fs/btrfs/inode.c:7961 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
[34385.257275] Modules linked in: vmw_vsock_vmci_transport vmw_vmci vsock bridge 8021q garp stp mrp raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 xfs btrfs xor raid6_pq libcrc32c zlib_deflate tun hidp fuse cmtp kernelcapi rfcomm bnep l2tp_ppp l2tp_netlink l2tp_core nfnetlink ipt_ULOG can_raw phonet scsi_transport_iscsi ipx p8023 p8022 irda af_802154 caif_socket caif crc_ccitt rds af_key appletalk psnap pppoe pppox af_rxrpc ppp_generic slhc nfc rose netrom atm llc2 ax25 llc can_bcm x25 can raid0 kvm_amd snd_hda_codec_realtek kvm snd_hda_intel snd_hda_codec microcode snd_pcm pcspkr serio_raw btusb edac_core snd_page_alloc snd_timer bluetooth snd soundcore rfkill r8169 mii sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
[34385.287768] CPU: 3 PID: 1677385 Comm: umount Not tainted 3.10.0-rc6+ #6 [loadavg: 21.16 26.58 27.93 2/170 1677389]
[34385.290479] Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
[34385.292974]  ffffffffa05eaffa ffff88011fed3cd8 ffffffff816aee0f ffff88011fed3d10
[34385.295432]  ffffffff810432b0 ffff8801101172b8 ffff8801101172b8 ffff8800a3cb1148
[34385.297745]  ffffffffa05e47a0 ffff8800bbe1c020 ffff88011fed3d20 ffffffff8104339a
[34385.300664] Call Trace:
[34385.302368]  [<ffffffff816aee0f>] dump_stack+0x19/0x1b
[34385.305202]  [<ffffffff810432b0>] warn_slowpath_common+0x70/0xa0
[34385.308010]  [<ffffffff8104339a>] warn_slowpath_null+0x1a/0x20
[34385.310529]  [<ffffffffa057f7d5>] btrfs_destroy_inode+0x265/0x2e0 [btrfs]
[34385.313020]  [<ffffffff811ccd78>] destroy_inode+0x38/0x60
[34385.315214]  [<ffffffff811cceae>] evict+0x10e/0x1a0
[34385.317198]  [<ffffffff811cd7f5>] iput+0x105/0x190
[34385.319169]  [<ffffffffa055c77f>] btrfs_put_block_group_cache+0x8f/0xc0 [btrfs]
[34385.321464]  [<ffffffffa0569794>] close_ctree+0xe4/0x290 [btrfs]
[34385.323603]  [<ffffffff811cdc8c>] ? evict_inodes+0xfc/0x110
[34385.326237]  [<ffffffffa053eb69>] btrfs_put_super+0x19/0x20 [btrfs]
[34385.328880]  [<ffffffff811b2f71>] generic_shutdown_super+0x61/0xf0
[34385.331527]  [<ffffffff811b31c2>] kill_anon_super+0x12/0x20
[34385.334146]  [<ffffffffa0540dc6>] btrfs_kill_super+0x16/0x90 [btrfs]
[34385.336457]  [<ffffffff811b371d>] deactivate_locked_super+0x4d/0x80
[34385.338666]  [<ffffffff811b3796>] deactivate_super+0x46/0x60
[34385.340782]  [<ffffffff811d3b27>] mntput_no_expire+0xd7/0x130
[34385.342899]  [<ffffffff811d49ec>] SyS_umount+0x9c/0x3b0
[34385.345778]  [<ffffffff816bf3d4>] tracesys+0xdd/0xe2
[34385.348560] ---[ end trace 0d6b7f873e402e88 ]---

