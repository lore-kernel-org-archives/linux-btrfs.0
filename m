Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458AbaJUV5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 17:57:45 -0400
Date: Tue, 21 Oct 2014 17:57:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: [3.18rc1] btrfs triggering vm bug_on
Message-ID: <20141021215731.GA10296@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

page:ffffea00088aa1c0 count:4 mapcount:0 mapping:ffff88009901e2d8 index:0x0
flags: 0x2ffc0000000806(error|referenced|private)
page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
------------[ cut here ]------------
kernel BUG at mm/filemap.c:747!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: fuse snd_seq_dummy tun binfmt_misc usb_debug bnep rfcomm nfnetlink scsi_transport_iscsi hidp af_key llc2 can_bcm can_raw nfc caif_socket caif 
af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose sctp libcrc32c x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 c
fg80211 rfkill btrfs xor coretemp hwmon x86_pkg_temp_thermal kvm_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi kvm snd_hda_intel snd_hda_controller snd_h
da_codec snd_hwdep crct10dif_pclmul snd_seq crc32c_intel ghash_clmulni_intel e1000e snd_seq_device raid6_pq snd_pcm microcode snd_timer serio_raw snd pcspkr ptp pps_core shpchp
 soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
CPU: 3 PID: 6466 Comm: trinity-c402 Not tainted 3.18.0-rc1+ #72 
task: ffff88003ec22f00 ti: ffff88006f3ac000 task.ti: ffff88006f3ac000
RIP: 0010:[<ffffffffbb1a06df>]  [<ffffffffbb1a06df>] unlock_page+0x7f/0x90
RSP: 0018:ffff88006f3afa08  EFLAGS: 00010292
RAX: 0000000000000036 RBX: 0000000000001000 RCX: 0000000000000006
RDX: 0000000000000000 RSI: ffffffffbb843c53 RDI: ffffffffbb0e399e
RBP: ffff88006f3afa08 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000c2b
R13: 0000000000000000 R14: ffffea00088aa1c0 R15: 0000000000000000
FS:  00007f7e30942740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7e2d8b8000 CR3: 0000000098e56000 CR4: 00000000001407e0
DR0: 000000000219e000 DR1: 0000000000de8000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff88006f3afb28 ffffffffc05adf78 ffffffffc05ae375 ffff88006f3afa70
 ffffffffbb03d193 ffffffffbb0b25c5 ffffffffc05adb10 0000000000000000
 00000000211ce98b 0000000000000000 ffff88006f3afbd0 ffff880222a87000
Call Trace:
 [<ffffffffc05adf78>] __do_readpage+0x468/0x7a0 [btrfs]
 [<ffffffffc05ae375>] ? __extent_read_full_page+0xc5/0xe0 [btrfs]
 [<ffffffffbb03d193>] ? prepare_ftrace_return+0x73/0xe0
 [<ffffffffbb0b25c5>] ? preempt_count_sub+0x5/0x100
 [<ffffffffc05adb10>] ? extent_write_cache_pages.isra.30.constprop.48+0x440/0x440 [btrfs]
 [<ffffffffc0590290>] ? btrfs_writepage_end_io_hook+0x360/0x360 [btrfs]
 [<ffffffffbb0b263b>] ? preempt_count_sub+0x7b/0x100
 [<ffffffffbb8567ba>] ? ftrace_graph_caller+0x5a/0x85
 [<ffffffffc05ae375>] __extent_read_full_page+0xc5/0xe0 [btrfs]
 [<ffffffffc0590290>] ? btrfs_writepage_end_io_hook+0x360/0x360 [btrfs]
 [<ffffffffbb8567ba>] ? ftrace_graph_caller+0x5a/0x85
 [<ffffffffc05af426>] extent_read_full_page+0x46/0x80 [btrfs]
 [<ffffffffc058d265>] btrfs_readpage+0x25/0x30 [btrfs]
 [<ffffffffc059da78>] prepare_uptodate_page+0x38/0xa0 [btrfs]
 [<ffffffffc059dbec>] prepare_pages.isra.19+0x10c/0x1a0 [btrfs]
 [<ffffffffc059ed54>] __btrfs_buffered_write+0x1e4/0x5f0 [btrfs]
 [<ffffffffbb8567ba>] ? ftrace_graph_caller+0x5a/0x85
 [<ffffffffc059f52e>] btrfs_file_write_iter+0x3ce/0x550 [btrfs]
 [<ffffffffbb341060>] ? cap_inode_getsecid+0x20/0x20
 [<ffffffffbb21aad0>] ? new_sync_read+0xd0/0xd0
 [<ffffffffbb21ab5e>] new_sync_write+0x8e/0xd0
 [<ffffffffbb8567ba>] ? ftrace_graph_caller+0x5a/0x85
 [<ffffffffbb21b53a>] vfs_write+0xba/0x1f0
 [<ffffffffbb21c048>] SyS_write+0x58/0xd0
 [<ffffffffbb854689>] tracesys_phase2+0xd4/0xd9
Code: 48 8d 0c 92 48 8d 0c 4a 48 8b 96 98 00 00 00 48 89 c6 48 8d 3c ca 31 d2 e8 df d5 f2 ff 5d c3 48 c7 c6 38 81 c7 bb e8 01 ff 02 00 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 e8 6b 60 6b 

