From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: WARNING: at fs/btrfs/extent-tree.c:124
Date: Mon, 07 Nov 2011 14:10:29 +0900
Message-ID: <4EB76845.90703@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@Oracle.COM>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In for-linus branch, when xfstests was executed, the following warning
messages were output.

Thanks,
Tsutomu

===========================================================================

Nov  7 13:51:00 luna kernel: [  824.063444] device fsid 2f0ad8a9-93d5-4c99-837f-9db99543133b devid 1 transid 1822 /dev/sdd4
Nov  7 13:51:00 luna kernel: [  824.063946] btrfs: disk space caching is enabled
Nov  7 13:51:00 luna kernel: [  824.097652] block group 1103101952 has an wrong amount of free space
Nov  7 13:51:00 luna kernel: [  824.097873] btrfs: failed to load free space cache for block group 1103101952
Nov  7 13:51:01 luna kernel: [  824.413821] ------------[ cut here ]------------
Nov  7 13:51:01 luna kernel: [  824.413855] WARNING: at fs/btrfs/extent-tree.c:124 btrfs_put_block_group+0x4f/0x67 [btrfs]()
Nov  7 13:51:01 luna kernel: [  824.413858] Hardware name: PRIMERGY
Nov  7 13:51:01 luna kernel: [  824.413860] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
Nov  7 13:51:01 luna kernel: [  824.413915] Pid: 7472, comm: umount Not tainted 3.1.0mod+ #1
Nov  7 13:51:01 luna kernel: [  824.413917] Call Trace:
Nov  7 13:51:01 luna kernel: [  824.413925]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
Nov  7 13:51:01 luna kernel: [  824.413929]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
Nov  7 13:51:01 luna kernel: [  824.413943]  [<ffffffffa043691c>] btrfs_put_block_group+0x4f/0x67 [btrfs]
Nov  7 13:51:01 luna kernel: [  824.413956]  [<ffffffffa043710c>] btrfs_free_block_groups+0xde/0x258 [btrfs]
Nov  7 13:51:01 luna kernel: [  824.413973]  [<ffffffffa0447a59>] close_ctree+0x22c/0x325 [btrfs]
Nov  7 13:51:01 luna kernel: [  824.413978]  [<ffffffff8112e426>] ? dispose_list+0x3e/0x4f
Nov  7 13:51:01 luna kernel: [  824.413989]  [<ffffffffa042cb7d>] btrfs_put_super+0x1d/0x2c [btrfs]
Nov  7 13:51:01 luna kernel: [  824.413994]  [<ffffffff8111bcdc>] generic_shutdown_super+0x5b/0xba
Nov  7 13:51:01 luna kernel: [  824.413998]  [<ffffffff8111bdba>] kill_anon_super+0x16/0x22
Nov  7 13:51:01 luna kernel: [  824.414002]  [<ffffffff8111c5b2>] deactivate_locked_super+0x26/0x57
Nov  7 13:51:01 luna kernel: [  824.414006]  [<ffffffff8111cfe5>] deactivate_super+0x45/0x4c
Nov  7 13:51:01 luna kernel: [  824.414010]  [<ffffffff81132237>] mntput_no_expire+0x143/0x14c
Nov  7 13:51:01 luna kernel: [  824.414822]  [<ffffffff81132de3>] sys_umount+0x2d9/0x304
Nov  7 13:51:01 luna kernel: [  824.414838]  [<ffffffff81122c69>] ? path_put+0x22/0x26
Nov  7 13:51:01 luna kernel: [  824.414846]  [<ffffffff813af4c2>] system_call_fastpath+0x16/0x1b
Nov  7 13:51:01 luna kernel: [  824.414852] ---[ end trace 1167c1ef9b771b7f ]---
Nov  7 13:51:01 luna kernel: [  824.418017] ------------[ cut here ]------------
Nov  7 13:51:01 luna kernel: [  824.418039] WARNING: at fs/btrfs/extent-tree.c:7158 btrfs_free_block_groups+0x220/0x258 [btrfs]()
Nov  7 13:51:01 luna kernel: [  824.418042] Hardware name: PRIMERGY
Nov  7 13:51:01 luna kernel: [  824.418044] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
Nov  7 13:51:01 luna kernel: [  824.418107] Pid: 7472, comm: umount Tainted: G        W   3.1.0mod+ #1
Nov  7 13:51:01 luna kernel: [  824.418110] Call Trace:
Nov  7 13:51:01 luna kernel: [  824.418117]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
Nov  7 13:51:01 luna kernel: [  824.418121]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
Nov  7 13:51:01 luna kernel: [  824.418137]  [<ffffffffa043724e>] btrfs_free_block_groups+0x220/0x258 [btrfs]
Nov  7 13:51:01 luna kernel: [  824.418157]  [<ffffffffa0447a59>] close_ctree+0x22c/0x325 [btrfs]
Nov  7 13:51:01 luna kernel: [  824.418161]  [<ffffffff8112e426>] ? dispose_list+0x3e/0x4f
Nov  7 13:51:01 luna kernel: [  824.418175]  [<ffffffffa042cb7d>] btrfs_put_super+0x1d/0x2c [btrfs]
Nov  7 13:51:01 luna kernel: [  824.418180]  [<ffffffff8111bcdc>] generic_shutdown_super+0x5b/0xba
Nov  7 13:51:01 luna kernel: [  824.418185]  [<ffffffff8111bdba>] kill_anon_super+0x16/0x22
Nov  7 13:51:01 luna kernel: [  824.418190]  [<ffffffff8111c5b2>] deactivate_locked_super+0x26/0x57
Nov  7 13:51:01 luna kernel: [  824.418194]  [<ffffffff8111cfe5>] deactivate_super+0x45/0x4c
Nov  7 13:51:01 luna kernel: [  824.418199]  [<ffffffff81132237>] mntput_no_expire+0x143/0x14c
Nov  7 13:51:01 luna kernel: [  824.418203]  [<ffffffff81132de3>] sys_umount+0x2d9/0x304
Nov  7 13:51:01 luna kernel: [  824.418207]  [<ffffffff81122c69>] ? path_put+0x22/0x26
Nov  7 13:51:01 luna kernel: [  824.418212]  [<ffffffff813af4c2>] system_call_fastpath+0x16/0x1b
Nov  7 13:51:01 luna kernel: [  824.418215] ---[ end trace 1167c1ef9b771b80 ]---
Nov  7 13:51:01 luna kernel: [  824.418219] space_info 1 has 1892356096 free, is not full
Nov  7 13:51:01 luna kernel: [  824.418223] space_info total=2155872256, used=263507968, pinned=0, reserved=8192, may_use=0, readonly=0

