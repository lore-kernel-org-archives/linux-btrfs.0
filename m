Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:42299 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab2JZGfp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 02:35:45 -0400
Received: from [IPv6:2a01:238:e100:320:7271:bcff:fe43:2d12]
	([2a01:238:e100:320:7271:bcff:fe43:2d12])
	by smtp.strato.de (josoe mo13) (RZmta 30.20 AUTH)
	with ESMTPA id y02d8eo9Q6P2cE for <linux-btrfs@vger.kernel.org>;
	Fri, 26 Oct 2012 08:35:43 +0200 (CEST)
Message-ID: <508A2F3F.3030500@jan-o-sch.net>
Date: Fri, 26 Oct 2012 08:35:43 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: BUG in btrfs_set_item_key_safe
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while running extensive qgroup and tree mod log tests I got to the following
BUG, which is probably not related to tree mod log:

[71793.530286] ------------[ cut here ]------------
[71793.585407] kernel BUG at fs/btrfs/ctree.c:3166!
[71793.640487] invalid opcode: 0000 [#1] PREEMPT SMP
[71793.697953] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class [last unloaded: btrfs]
[71793.804482] CPU 3
[71793.826370] Pid: 31128, comm: fsstress Tainted: G        W    3.6.0+ #2 Supermicro X8SIL/X8SIL
[71793.931342] RIP: 0010:[<ffffffffa050a348>]  [<ffffffffa050a348>] btrfs_set_item_key_safe+0x1d8/0x250 [btrfs]
[71794.048765] RSP: 0018:ffff8801cfd0fa28  EFLAGS: 00010246
[71794.112142] RAX: ffff8801cfd0fb68 RBX: ffff8801cfd0fa38 RCX: 000000000000006c
[71794.197304] RDX: 0000000000000132 RSI: 00000000000f6000 RDI: 00000000000f6000
[71794.282467] RBP: ffff8801cfd0fa88 R08: 0000000000000000 R09: ffff8801cfd0fa40
[71794.367629] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880231425000
[71794.452790] R13: ffff88023125f000 R14: 0000000000000000 R15: ffff8801d25f9ce0
[71794.537951] FS:  00007f4d458fc700(0000) GS:ffff880236c00000(0000) knlGS:0000000000000000
[71794.634523] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[71794.703088] CR2: 00007f4d44d76cdc CR3: 00000001cfe57000 CR4: 00000000000007e0
[71794.788250] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[71794.873410] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[71794.958573] Process fsstress (pid: 31128, threadinfo ffff8801cfd0e000, task ffff88023273c500)
[71795.060330] Stack:
[71795.084294]  ffff8801cfd0fb68 ffff8802315fb000 0000000000000132 000000000f60006c
[71795.172981]  0000000000000000 ffff8801d0307000 ffff8801cfd0fa88 ffff880231425000
[71795.261668]  ffff8801d25f9ce0 0000000000105000 00000000000a8000 0000000000000002
[71795.350357] Call Trace:
[71795.379520]  [<ffffffffa05452ec>] __btrfs_drop_extents+0x5bc/0xba0 [btrfs]
[71795.461564]  [<ffffffffa0511c94>] ? btrfs_search_slot+0xb34/0xb40 [btrfs]
[71795.542581]  [<ffffffffa0569679>] btrfs_log_changed_extents+0x659/0x6f0 [btrfs]
[71795.629816]  [<ffffffffa056ca6c>] btrfs_log_inode+0x4dc/0x650 [btrfs]
[71795.706774]  [<ffffffff811b0b00>] ? d_hash_and_lookup+0x30/0x70
[71795.777735]  [<ffffffffa056cd70>] btrfs_log_inode_parent+0x190/0x4b0 [btrfs]
[71795.862367]  [<ffffffff811b0b57>] ? dget_parent+0x17/0xd0
[71795.927105]  [<ffffffffa056d13f>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
[71796.008427]  [<ffffffffa0543611>] btrfs_sync_file+0x121/0x290 [btrfs]
[71796.085695]  [<ffffffff811c7f73>] vfs_fsync_range+0x23/0x30
[71796.152496]  [<ffffffff811c7f97>] vfs_fsync+0x17/0x20
[71796.213098]  [<ffffffff811c81c4>] do_fsync+0x34/0x60
[71796.272615]  [<ffffffff811c81fe>] sys_fdatasync+0xe/0x20
[71796.336305]  [<ffffffff8193f5a2>] system_call_fastpath+0x16/0x1b
[71796.408292] Code: 7d f8 c9 c3 0f 1f 80 00 00 00 00 72 1e 0f b6 48 08 40 38 ce 76 0d 48 8b 70 09 e9 5f ff ff ff 0f 1f 40 00 73 36 66 0f 1f 44 00 00 <0f> 0b 66 0f 1f 44 00 00 eb f8 66 0f 1f 44 00 00 48 3b 48 09 0f
[71796.642304] RIP  [<ffffffffa050a348>] btrfs_set_item_key_safe+0x1d8/0x250 [btrfs]
[71796.732134]  RSP <ffff8801cfd0fa28>
[71796.774296] ---[ end trace f2639a7e4750b6d5 ]---

Due to added printk statements, my line numbers are shifted. The corresponding
BUG is:

3150 void btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
3151                              struct btrfs_root *root, struct btrfs_path *path,
3152                              struct btrfs_key *new_key)
3153 {
3154         struct btrfs_disk_key disk_key;
3155         struct extent_buffer *eb;
3156         int slot;
3157
3158         eb = path->nodes[0];
3159         slot = path->slots[0];
3160         if (slot > 0) {
3161                 btrfs_item_key(eb, &disk_key, slot - 1);
3162                 BUG_ON(comp_keys(&disk_key, new_key) >= 0);
3163         }
3164         if (slot < btrfs_header_nritems(eb) - 1) {
3165                 btrfs_item_key(eb, &disk_key, slot + 1);
3166                 BUG_ON(comp_keys(&disk_key, new_key) <= 0);
3167         }

-Jan
