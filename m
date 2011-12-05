From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [BUG 3.2-rc4] kernel BUG at fs/btrfs/inode.c:2034!
Date: Mon, 05 Dec 2011 14:48:04 +0900
Message-ID: <4EDC5B14.4060103@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I encountered following kernel bug when running xfstests/083.

 FSTYP         -- btrfs
 PLATFORM      -- Linux/x86_64 luna 3.2.0-rc4
 MKFS_OPTIONS  -- /dev/sdc2
 MOUNT_OPTIONS -- /dev/sdc2 /test9


[ 8208.990166] btrfs: fail to dirty  inode 1195 error -28
[ 8208.990578] btrfs: fail to dirty  inode 1677 error -28
[ 8213.017379] ------------[ cut here ]------------
[ 8213.017600] kernel BUG at fs/btrfs/inode.c:2034!
[ 8213.017817] invalid opcode: 0000 [#1] SMP
[ 8213.018004] CPU 0
[ 8213.018004] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
[ 8213.018004]
[ 8213.018004] Pid: 21201, comm: fsstress Tainted: G        W    3.2.0-rc4 #1 FUJITSU-SV      PRIMERGY            /D2399
[ 8213.018004] RIP: 0010:[<ffffffffa0467bf5>]  [<ffffffffa0467bf5>] btrfs_orphan_add+0x10b/0x124 [btrfs]
[ 8213.018004] RSP: 0018:ffff880119a71dd8  EFLAGS: 00010282
[ 8213.018004] RAX: 00000000ffffffef RBX: ffff880195323000 RCX: 0000000001c3c694
[ 8213.018004] RDX: ffff880119a71d58 RSI: 000060fe600046c0 RDI: ffffea000530a400
[ 8213.018004] RBP: ffff880119a71e08 R08: ffffffffa0445e1d R09: ffff880119a71ba8
[ 8213.018004] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88018ab94920
[ 8213.018004] R13: ffff8800af1376c0 R14: 0000000000000000 R15: ffff8801449f6760
[ 8213.018004] FS:  00007f7e3a63e700(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
[ 8213.018004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8213.018004] CR2: 00007f7e340e3938 CR3: 0000000140b25000 CR4: 00000000000006f0
[ 8213.018004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8213.018004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8213.018004] Process fsstress (pid: 21201, threadinfo ffff880119a70000, task ffff880044325a80)
[ 8213.018004] Stack:
[ 8213.018004]  ffff880119a71e08 ffff8800af1376c0 ffff88012112b0c0 ffff88014f702ef0
[ 8213.018004]  ffff88018ab94920 ffff880195323000 ffff880119a71e58 ffffffffa04682d5
[ 8213.018004]  ffff88012112b0c0 ffff88012112b0c0 ffff880119a71e58 ffff88012112b0c0
[ 8213.018004] Call Trace:
[ 8213.018004]  [<ffffffffa04682d5>] btrfs_unlink+0x7d/0xac [btrfs]
[ 8213.018004]  [<ffffffff81124632>] vfs_unlink+0x78/0xdd
[ 8213.018004]  [<ffffffff81126aab>] do_unlinkat+0xdd/0x16c
[ 8213.018004]  [<ffffffff811232cd>] ? path_put+0x22/0x26
[ 8213.018004]  [<ffffffff810969bb>] ? audit_syscall_entry+0x11e/0x14a
[ 8213.018004]  [<ffffffff81126b50>] sys_unlink+0x16/0x18
[ 8213.018004]  [<ffffffff813b1d82>] system_call_fastpath+0x16/0x1b
[ 8213.018004] Code: 8b 94 24 78 fe ff ff 48 85 d2 74 0b 41 80 bc 24 80 fe ff ff 84 75 05 49 8b 54 24 40 48 89 de 4c 89 ef e8 e6 e6 01 00 85 c0 74 0b <0f> 0b eb fe b8 f4 ff ff ff eb 02 31 c0 5a 5b 41 5c 41 5d 41 5e
[ 8213.018004] RIP  [<ffffffffa0467bf5>] btrfs_orphan_add+0x10b/0x124 [btrfs]
[ 8213.018004]  RSP <ffff880119a71dd8>


1981 int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
1982 {
...
2031         /* insert an orphan item to track this unlinked/truncated file */
2032         if (insert >= 1) {
2033                 ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
2034                 BUG_ON(ret);
2035         }


RAX: 00000000ffffffef  (-17)
#define EEXIST          17      /* File exists */


  - Tsutomu

