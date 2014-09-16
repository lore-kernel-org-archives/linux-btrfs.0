Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42674 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaIPEdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 00:33:11 -0400
Received: by mail-ob0-f176.google.com with SMTP id wo20so1223992obc.7
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 21:33:09 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Sep 2014 12:33:09 +0800
Message-ID: <CAMVG2svU-tbpgJ5MqjnS=XGBNZcwfPd0WGMkp1aN4W0M1ewm5A@mail.gmail.com>
Subject: 3.14.18 btrfs_set_item_key_safe BUG
From: Daniel J Blueman <daniel@quora.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3.14.18 with a BTRFS partition mounted
noatime,autodefrag,compress=lzo, I see the second assertion in
btrfs_set_item_key_safe() trip:

void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
                             struct btrfs_key *new_key)
{
        struct btrfs_disk_key disk_key;
        struct extent_buffer *eb;
        int slot;

        eb = path->nodes[0];
        slot = path->slots[0];
        if (slot > 0) {
                btrfs_item_key(eb, &disk_key, slot - 1);
                BUG_ON(comp_keys(&disk_key, new_key) >= 0);
        }
        if (slot < btrfs_header_nritems(eb) - 1) {
                btrfs_item_key(eb, &disk_key, slot + 1);
                BUG_ON(comp_keys(&disk_key, new_key) <= 0); <---
        }

Full backtrace:

kernel BUG at /home/apw/COD/linux/fs/btrfs/ctree.c:3215!
invalid opcode: 0000 [#1] SMP
Modules linked in: nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc
bonding psmouse serio_raw joydev video mac_hid lpc_ich lp parport
hid_generic usbhid hid bcache btrfs raid10 raid456 async_raid6_recov
async_pq raid6_pq async_xor ahci xor async_memcpy libahci async_tx
raid1 e1000e ptp pps_core raid0 multipath linear
CPU: 0 PID: 6742 Comm: btrfs-endio-wri Not tainted
3.14.18-031418-generic #201409060201
Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0b 09/17/2012
task: ffff880418609d70 ti: ffff880121e92000 task.ti: ffff880121e92000
RIP: 0010:[<ffffffffa01693f1>] [<ffffffffa01693f1>]
btrfs_set_item_key_safe+0x141/0x150 [btrfs]
RSP: 0018:ffff880121e93b28 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000011 RCX: 000000003e600000
RDX: 0000000000000000 RSI: ffff880121e93c67 RDI: ffff880121e93b07
RBP: ffff880121e93b88 R08: 0000000000001000 R09: ffff880121e93b48
R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88009ce9bcc0
R13: ffff880121e93c67 R14: ffff880121e93b47 R15: ffff8804145f7c60
FS: 0000000000000000(0000) GS:ffff88042fc00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff34a8d1890 CR3: 0000000001c0d000 CR4: 00000000001407f0
Stack:
 ffff880121e93b88 ffff880405ca0000 ffff8803140d1000 d900000000000000
 6c0000000000f6bf 000000003e600000 ffff880121e93b88 ffff8804145f7c60
 ffff88009ce9bcc0 000000003e5e0000 0000000000000001 0000000000000c46
Call Trace:
 [<ffffffffa01a1868>] __btrfs_drop_extents+0x5a8/0xc80 [btrfs]
 [<ffffffffa0165e00>] ? tree_mod_log_free_eb+0x240/0x260 [btrfs]
 [<ffffffffa0191d6b>]
insert_reserved_file_extent.constprop.60+0xab/0x310 [btrfs]
 [<ffffffffa018ee10>] ? start_transaction.part.35+0x80/0x540 [btrfs]
 [<ffffffffa0198565>] btrfs_finish_ordered_io+0x465/0x500 [btrfs]
 [<ffffffffa0198615>] finish_ordered_fn+0x15/0x20 [btrfs]
 [<ffffffffa01bd8f0>] worker_loop+0xa0/0x330 [btrfs]
 [<ffffffffa01bd850>] ? check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
 [<ffffffff810930c9>] kthread+0xc9/0xe0
 [<ffffffff81093000>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff81784abc>] ret_from_fork+0x7c/0xb0
 [<ffffffff81093000>] ? flush_kthread_worker+0xb0/0xb0
Code: 00 00 4c 89 f6 4c 89 e7 48 98 48 8d 04 80 48 8d 54 80 65 e8 b2
6c 04 00 4c 89 ee 4c 89 f7 e8 d7 f4 ff ff 85 c0 0f 8f 5c ff ff ff <0f>
0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55

After rebooting, btrfs check (btrfs-tools 3.14.1-1) shows:

checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 inode 16170969 errors 80, file extent overlap
root 5 inode 17592262 errors 100, file extent discount
found 752124326140 bytes used err is 1
total csum bytes: 2415994160
total tree bytes: 18200276992
total fs tree bytes: 14156120064
total extent tree bytes: 1240526848
btree space waste bytes: 2998597745
file data blocks allocated: 2473980772352
 referenced 2731118456832

Is it better to not trust compression, autodefrag, or is this
filesystem corruption from previous issues, so I should rebuild the
FS?

Thanks,
  Daniel
-- 
Daniel J Blueman
