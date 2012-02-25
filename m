From: Christian Robert <christian.robert@polymtl.ca>
Subject: btrfs: block rsv returned -28
Date: Fri, 24 Feb 2012 21:26:41 -0500
Message-ID: <4F4846E1.50307@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I ran a quite heavy script who create 10,000 subvolumes and then delete
thoses 10,000 subvolumes.

No problems in the "create" part, but at the "delete" part
I got several traceback from the kernel:

[  977.095799] Btrfs loaded
[  985.847955] device fsid 8375b14f-116e-4507-b523-607c2e04f485 devid 1 transid 55592 /dev/mapper/Data_snap
[  985.848307] btrfs: enabling inode map caching
[  985.848309] btrfs: disk space caching is enabled
[ 1076.785592] btrfs: block rsv returned -28
[ 1076.785594] ------------[ cut here ]------------
[ 1076.785613] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1076.785615] Hardware name: VMware Virtual Platform
[ 1076.785617] Modules linked in: btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1076.785638] Pid: 13418, comm: btrfs-transacti Not tainted 3.3.0-rc4 #1
[ 1076.785639] Call Trace:
[ 1076.785652]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1076.785655]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1076.785663]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1076.785674]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1076.785681]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1076.785688]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1076.785694]  [<ffffffffa023aa7d>] ? unlock_up+0xbd/0xee [btrfs]
[ 1076.785701]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1076.785710]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1076.785719]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1076.785726]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1076.785736]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1076.785745]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1076.785751]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1076.785760]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1076.785768]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1076.785775]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1076.785778]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1076.785782]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1076.785785]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1076.785787]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1076.785789] ---[ end trace 1cb873a5ec9cba8d ]---
[ 1076.785814] btrfs: block rsv returned -28
[ 1076.785816] ------------[ cut here ]------------
[ 1076.785823] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1076.785825] Hardware name: VMware Virtual Platform
[ 1076.785826] Modules linked in: btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1076.785840] Pid: 13418, comm: btrfs-transacti Tainted: G        W    3.3.0-rc4 #1
[ 1076.785842] Call Trace:
[ 1076.785844]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1076.785847]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1076.785854]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1076.785864]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1076.785870]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1076.785877]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1076.785883]  [<ffffffffa023aa7d>] ? unlock_up+0xbd/0xee [btrfs]
[ 1076.785889]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1076.785898]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1076.786003]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1076.786006]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1076.786015]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1076.786023]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1076.786026]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1076.786034]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1076.786042]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1076.786049]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1076.786051]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1076.786054]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1076.786057]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1076.786059]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1076.786061] ---[ end trace 1cb873a5ec9cba8e ]---
[ 1089.872305] hdparm: sending ioctl 330 to a partition!
[ 1089.872309] hdparm: sending ioctl 330 to a partition!
[ 1089.877585] hdparm: sending ioctl 330 to a partition!
[ 1089.877590] hdparm: sending ioctl 330 to a partition!
[ 1089.904504] hdparm: sending ioctl 330 to a partition!
[ 1089.904508] hdparm: sending ioctl 330 to a partition!
[ 1089.904510] hdparm: sending ioctl 330 to a partition!
[ 1090.155788] Bridge firewalling registered
[ 1091.585205] parted: sending ioctl 1261 to a partition!
[ 1091.585210] parted: sending ioctl 1261 to a partition!
[ 1091.585213] parted: sending ioctl 1261 to a partition!
[ 1102.369204] scsi_verify_blk_ioctl: 3 callbacks suppressed
[ 1102.369208] hdparm: sending ioctl 330 to a partition!
[ 1102.369212] hdparm: sending ioctl 330 to a partition!
[ 1102.374779] hdparm: sending ioctl 330 to a partition!
[ 1102.374783] hdparm: sending ioctl 330 to a partition!
[ 1102.401972] hdparm: sending ioctl 330 to a partition!
[ 1102.401976] hdparm: sending ioctl 330 to a partition!
[ 1102.401978] hdparm: sending ioctl 330 to a partition!
[ 1103.844640] parted: sending ioctl 1261 to a partition!
[ 1103.844644] parted: sending ioctl 1261 to a partition!
[ 1103.844646] parted: sending ioctl 1261 to a partition!
[ 1136.857984] use_block_rsv: 5 callbacks suppressed
[ 1136.857989] btrfs: block rsv returned -28
[ 1136.857991] ------------[ cut here ]------------
[ 1136.858007] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1136.858010] Hardware name: VMware Virtual Platform
[ 1136.858012] Modules linked in: bridge stp llc btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1136.858041] Pid: 13418, comm: btrfs-transacti Tainted: G        W    3.3.0-rc4 #1
[ 1136.858044] Call Trace:
[ 1136.858055]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1136.858059]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1136.858068]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1136.858081]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1136.858090]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1136.858098]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1136.858106]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1136.858117]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1136.858128]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1136.858132]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1136.858143]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1136.858154]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1136.858159]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1136.858168]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1136.858178]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1136.858186]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1136.858190]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1136.858195]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1136.858199]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1136.858202]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1136.858205] ---[ end trace 1cb873a5ec9cba8f ]---
[ 1139.454651] scsi_verify_blk_ioctl: 3 callbacks suppressed
[ 1139.454651] hdparm: sending ioctl 330 to a partition!
[ 1139.454651] hdparm: sending ioctl 330 to a partition!
[ 1139.462947] hdparm: sending ioctl 330 to a partition!
[ 1139.462953] hdparm: sending ioctl 330 to a partition!
[ 1139.498530] hdparm: sending ioctl 330 to a partition!
[ 1139.498534] hdparm: sending ioctl 330 to a partition!
[ 1139.498537] hdparm: sending ioctl 330 to a partition!
[ 1140.599323] parted: sending ioctl 1261 to a partition!
[ 1140.599327] parted: sending ioctl 1261 to a partition!
[ 1140.599329] parted: sending ioctl 1261 to a partition!
[ 1196.968820] btrfs: block rsv returned -28
[ 1196.968823] ------------[ cut here ]------------
[ 1196.968839] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1196.968841] Hardware name: VMware Virtual Platform
[ 1196.968842] Modules linked in: bridge stp llc btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1196.968865] Pid: 13418, comm: btrfs-transacti Tainted: G        W    3.3.0-rc4 #1
[ 1196.968867] Call Trace:
[ 1196.968873]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1196.968873]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1196.968873]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1196.968873]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1196.968873]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1196.968873]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1196.968873]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1196.968873]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1196.968873]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1196.968873]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1196.968885]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1196.968896]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1196.968911]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1196.968923]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1196.968934]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1196.968944]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1196.968950]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1196.968956]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1196.968962]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1196.968967]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1196.968970] ---[ end trace 1cb873a5ec9cba90 ]---
[ 1199.790756] scsi_verify_blk_ioctl: 3 callbacks suppressed
[ 1199.790759] hdparm: sending ioctl 330 to a partition!
[ 1199.790762] hdparm: sending ioctl 330 to a partition!
[ 1199.796137] hdparm: sending ioctl 330 to a partition!
[ 1199.796141] hdparm: sending ioctl 330 to a partition!
[ 1199.823128] hdparm: sending ioctl 330 to a partition!
[ 1199.823132] hdparm: sending ioctl 330 to a partition!
[ 1199.823135] hdparm: sending ioctl 330 to a partition!
[ 1200.905032] parted: sending ioctl 1261 to a partition!
[ 1200.905036] parted: sending ioctl 1261 to a partition!
[ 1200.905038] parted: sending ioctl 1261 to a partition!
[ 1257.101762] use_block_rsv: 3 callbacks suppressed
[ 1257.101766] btrfs: block rsv returned -28
[ 1257.101767] ------------[ cut here ]------------
[ 1257.101783] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1257.101785] Hardware name: VMware Virtual Platform
[ 1257.101786] Modules linked in: bridge stp llc btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1257.101810] Pid: 13418, comm: btrfs-transacti Tainted: G        W    3.3.0-rc4 #1
[ 1257.101812] Call Trace:
[ 1257.101819]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1257.101823]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1257.101831]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1257.101843]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1257.101851]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1257.101858]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1257.101866]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1257.101876]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1257.101885]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1257.101889]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1257.101899]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1257.101908]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1257.101913]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1257.101922]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1257.101930]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1257.101938]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1257.101941]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1257.101945]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1257.101949]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1257.101951]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1257.101953] ---[ end trace 1cb873a5ec9cba91 ]---
[ 1257.101981] btrfs: block rsv returned -28
[ 1257.101982] ------------[ cut here ]------------
[ 1257.101991] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1257.101992] Hardware name: VMware Virtual Platform
[ 1257.101993] Modules linked in: bridge stp llc btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1257.102010] Pid: 13418, comm: btrfs-transacti Tainted: G        W    3.3.0-rc4 #1
[ 1257.102011] Call Trace:
[ 1257.102014]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1257.102017]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1257.102025]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1257.102035]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1257.102042]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1257.102049]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1257.102056]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1257.102065]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1257.102075]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1257.102077]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1257.102086]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1257.102095]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1257.102098]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1257.102107]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1257.102115]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1257.102122]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1257.102125]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1257.102128]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1257.102131]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1257.102134]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1257.102135] ---[ end trace 1cb873a5ec9cba92 ]---
[ 1259.606979] scsi_verify_blk_ioctl: 3 callbacks suppressed
[ 1259.606983] hdparm: sending ioctl 330 to a partition!
[ 1259.606986] hdparm: sending ioctl 330 to a partition!
[ 1259.612797] hdparm: sending ioctl 330 to a partition!
[ 1259.612801] hdparm: sending ioctl 330 to a partition!
[ 1259.640576] hdparm: sending ioctl 330 to a partition!
[ 1259.640580] hdparm: sending ioctl 330 to a partition!
[ 1259.640583] hdparm: sending ioctl 330 to a partition!
[ 1260.804133] parted: sending ioctl 1261 to a partition!
[ 1260.804137] parted: sending ioctl 1261 to a partition!
[ 1260.804140] parted: sending ioctl 1261 to a partition!
[ 1265.979700] scsi_verify_blk_ioctl: 3 callbacks suppressed
[ 1265.979703] hdparm: sending ioctl 330 to a partition!
[ 1265.979706] hdparm: sending ioctl 330 to a partition!
[ 1265.987022] hdparm: sending ioctl 330 to a partition!
[ 1265.987027] hdparm: sending ioctl 330 to a partition!
[ 1266.016577] hdparm: sending ioctl 330 to a partition!
[ 1266.016581] hdparm: sending ioctl 330 to a partition!
[ 1266.016584] hdparm: sending ioctl 330 to a partition!
[ 1266.997715] parted: sending ioctl 1261 to a partition!
[ 1266.997718] parted: sending ioctl 1261 to a partition!
[ 1266.997720] parted: sending ioctl 1261 to a partition!
[ 1317.198945] use_block_rsv: 1 callbacks suppressed
[ 1317.198948] btrfs: block rsv returned -28
[ 1317.198950] ------------[ cut here ]------------
[ 1317.198965] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1317.198967] Hardware name: VMware Virtual Platform
[ 1317.198968] Modules linked in: bridge stp llc btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1317.198992] Pid: 13418, comm: btrfs-transacti Tainted: G        W    3.3.0-rc4 #1
[ 1317.198993] Call Trace:
[ 1317.199001]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1317.199004]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1317.199013]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1317.199025]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1317.199033]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1317.199040]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1317.199047]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1317.199058]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1317.199068]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1317.199071]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1317.199082]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1317.199091]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1317.199095]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1317.199105]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1317.199113]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1317.199121]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1317.199124]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1317.199128]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1317.199131]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1317.199133]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1317.199332] ---[ end trace 1cb873a5ec9cba93 ]---
[ 1317.199363] btrfs: block rsv returned -28
[ 1317.199365] ------------[ cut here ]------------
[ 1317.199375] WARNING: at fs/btrfs/extent-tree.c:6164 btrfs_alloc_free_block+0x100/0x2c7 [btrfs]()
[ 1317.199378] Hardware name: VMware Virtual Platform
[ 1317.199380] Modules linked in: bridge stp llc btrfs zlib_deflate libcrc32c fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput ppdev e1000 parport_pc parport vmw_balloon microcode raid0 pcspkr i2c_piix4 i2c_core shpchp floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: btrfs]
[ 1317.199417] Pid: 13418, comm: btrfs-transacti Tainted: G        W    3.3.0-rc4 #1
[ 1317.199420] Call Trace:
[ 1317.199424]  [<ffffffff8103db71>] warn_slowpath_common+0x85/0x9d
[ 1317.199429]  [<ffffffff8103dba3>] warn_slowpath_null+0x1a/0x1c
[ 1317.199438]  [<ffffffffa024c569>] btrfs_alloc_free_block+0x100/0x2c7 [btrfs]
[ 1317.199450]  [<ffffffffa028aa6e>] ? tree_insert+0x18a/0x1a3 [btrfs]
[ 1317.199459]  [<ffffffffa023d904>] __btrfs_cow_block+0x125/0x3ce [btrfs]
[ 1317.199490]  [<ffffffffa023e094>] btrfs_cow_block+0x108/0x153 [btrfs]
[ 1317.199499]  [<ffffffffa023fdd8>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 1317.199511]  [<ffffffffa0292ba7>] btrfs_delete_delayed_items+0x92/0x2bc [btrfs]
[ 1317.199523]  [<ffffffffa0293ace>] btrfs_run_delayed_items+0x92/0xfd [btrfs]
[ 1317.199528]  [<ffffffff8106335d>] ? __wake_up+0x44/0x4d
[ 1317.199539]  [<ffffffffa0257938>] btrfs_commit_transaction+0x24e/0x73e [btrfs]
[ 1317.199550]  [<ffffffffa0257f08>] ? join_transaction+0x2b/0x25c [btrfs]
[ 1317.199555]  [<ffffffff810594aa>] ? wake_up_bit+0x2a/0x2a
[ 1317.199565]  [<ffffffffa025261b>] transaction_kthread+0x177/0x221 [btrfs]
[ 1317.199576]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1317.199585]  [<ffffffffa02524a4>] ? try_to_freeze+0x2f/0x2f [btrfs]
[ 1317.199590]  [<ffffffff8105901c>] kthread+0x89/0x91
[ 1317.199596]  [<ffffffff814ad3e4>] kernel_thread_helper+0x4/0x10
[ 1317.199601]  [<ffffffff81058f93>] ? kthread_freezable_should_stop+0x5d/0x5d
[ 1317.199606]  [<ffffffff814ad3e0>] ? gs_change+0x13/0x13
[ 1317.199609] ---[ end trace 1cb873a5ec9cba94 ]---
[ 1319.792163] scsi_verify_blk_ioctl: 3 callbacks suppressed
[ 1319.792167] hdparm: sending ioctl 330 to a partition!
[ 1319.792169] hdparm: sending ioctl 330 to a partition!
[ 1319.799333] hdparm: sending ioctl 330 to a partition!
[ 1319.799338] hdparm: sending ioctl 330 to a partition!
[ 1319.831399] hdparm: sending ioctl 330 to a partition!
[ 1319.831404] hdparm: sending ioctl 330 to a partition!
[ 1319.831407] hdparm: sending ioctl 330 to a partition!
[ 1321.109665] parted: sending ioctl 1261 to a partition!
[ 1321.109669] parted: sending ioctl 1261 to a partition!
[ 1321.109671] parted: sending ioctl 1261 to a partition!
[ 1326.438618] scsi_verify_blk_ioctl: 3 callbacks suppressed
[ 1326.438621] hdparm: sending ioctl 330 to a partition!
[ 1326.438624] hdparm: sending ioctl 330 to a partition!
[ 1326.444554] hdparm: sending ioctl 330 to a partition!
[ 1326.444558] hdparm: sending ioctl 330 to a partition!
[ 1326.479212] hdparm: sending ioctl 330 to a partition!
[ 1326.479217] hdparm: sending ioctl 330 to a partition!
[ 1326.479219] hdparm: sending ioctl 330 to a partition!
[ 1327.639153] parted: sending ioctl 1261 to a partition!
[ 1327.639157] parted: sending ioctl 1261 to a partition!
[ 1327.639160] parted: sending ioctl 1261 to a partition!




and finally the partition cannot be unmounted and I had to reboot.

well, it's probably not that important, who the hell will be deleting 10,000 subvolumes
in a 2 minutes timeframe ?


The script: (ps: the parallel program is not required, doing all this on a bash loop with one thread also trigger the problem for me)

#!/bin/bash

#
# Script to reproduce a problem dismounting a filesystem
# after having created 10,000 subvolume, and deleted thoses 10,000
# subvolumes.
#

which parallel &> /dev/null

if [ $? -ne 0 ]
then
   echo "You need the GNU \"parallel\" program. ( http://www.gnu.org/software/parallel/ )"
   exit 1
fi

cd /data  || exit 1   # should be in a btrfs filesystem

mkdir test &&
(
   cd test

   parallel 'btrfs subv create' ::: $(seq 0 9999 | awk '{printf("subv_%04d ",$1);}')
   sleep 5

   # Nothing appear in dmesg while creating the 10,000 subvolumes above

   parallel 'btrfs subv delete' ::: *
   sleep 5

   # Usually several kernel backtrace while running the deletes

)
rmdir test

echo
echo "Now try to unmount the partition. never worked for me."
echo

cd -


