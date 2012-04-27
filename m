From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 0/5] btrfs: snapshot deletion via readahead
Date: Fri, 27 Apr 2012 08:13:26 +0200
Message-ID: <4F9A3906.1030002@gmx.net>
References: <cover.1334241664.git.sensille@gmx.net> <4F87A034.3030607@cn.fujitsu.com> <4F87CD6D.5040100@gmx.net> <4F87D157.4040607@cn.fujitsu.com> <4F87D368.5070807@gmx.net> <4F87D924.6080501@cn.fujitsu.com> <4F8D1D49.1060404@gmx.net> <4F9A0F94.3030409@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F9A0F94.3030409@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu Bo,

thanks for testing :)

so one block reserve ran out of space. Did you use the same test as
before? On SSD?

Thanks,
Arne

On 27.04.2012 05:16, Liu Bo wrote:
> 
> Sorry for the long delay.
> 
> I've tested the droptree patch (1/5->5/5) on the latest upstream 3.4-rc4
> along with the missed patch "btrfs: fix race in reada".
> 
> And I've got several different bugs and hangs, one of them is the following:
> 
> Btrfs loaded
> device fsid e7b013a1-0d11-4162-83de-8404360f520a devid 1 transid 4 /dev/sdb6
> btrfs: disk space caching is enabled
> Btrfs detected SSD devices, enabling SSD mode
> device fsid e7b013a1-0d11-4162-83de-8404360f520a devid 1 transid 8 /dev/sdb6
> btrfs: disk space caching is enabled
> Btrfs detected SSD devices, enabling SSD mode
> device fsid e7b013a1-0d11-4162-83de-8404360f520a devid 1 transid 2011 /dev/sdb6
> btrfs: disk space caching is enabled
> Btrfs detected SSD devices, enabling SSD mode
> btrfs: block rsv returned -28
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:6220 btrfs_alloc_free_block+0x353/0x370 [btrfs]()
> Hardware name: QiTianM7150
> Modules linked in: btrfs(O) zlib_deflate libcrc32c ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables ipt_REJECT bridge stp llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm ppdev sg parport_pc parport coretemp hwmon i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support sky2 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm_km
 s_helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]
> Pid: 4605, comm: btrfs-transacti Tainted: G           O 3.4.0-rc4+ #11
> Call Trace:
>  [<ffffffff8104d6df>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8104d73a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffa0726b43>] btrfs_alloc_free_block+0x353/0x370 [btrfs]
>  [<ffffffffa0755c71>] ? read_extent_buffer+0xd1/0x130 [btrfs]
>  [<ffffffffa072e04a>] ? btree_read_extent_buffer_pages.clone.2+0xca/0x140 [btrfs]
>  [<ffffffffa0710a62>] __btrfs_cow_block+0x142/0x570 [btrfs]
>  [<ffffffffa07130dd>] ? read_block_for_search+0x14d/0x3e0 [btrfs]
>  [<ffffffffa0711492>] btrfs_cow_block+0x102/0x210 [btrfs]
>  [<ffffffffa0716b5c>] btrfs_search_slot+0x42c/0x960 [btrfs]
>  [<ffffffffa07853b9>] btrfs_delete_delayed_items+0x99/0x340 [btrfs]
>  [<ffffffff81152662>] ? kmem_cache_alloc+0x152/0x190
>  [<ffffffffa0786212>] btrfs_run_delayed_items+0x112/0x160 [btrfs]
>  [<ffffffffa07346df>] btrfs_commit_transaction+0x36f/0xa80 [btrfs]
>  [<ffffffffa07351c2>] ? start_transaction+0x92/0x320 [btrfs]
>  [<ffffffff8106fb60>] ? wake_up_bit+0x40/0x40
>  [<ffffffffa072fb5b>] transaction_kthread+0x26b/0x2e0 [btrfs]
>  [<ffffffffa072f8f0>] ? btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
>  [<ffffffffa072f8f0>] ? btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
>  [<ffffffff8106f4be>] kthread+0x9e/0xb0
>  [<ffffffff814fc864>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8106f420>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff814fc860>] ? gs_change+0x13/0x13
> ---[ end trace 504e7bc5e13ed457 ]---
> btrfs: block rsv returned -28
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:6220 btrfs_alloc_free_block+0x353/0x370 [btrfs]()
> Hardware name: QiTianM7150
> Modules linked in: btrfs(O) zlib_deflate libcrc32c ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables ipt_REJECT bridge stp llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm ppdev sg parport_pc parport coretemp hwmon i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support sky2 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm_km
 s_helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]
> Pid: 4605, comm: btrfs-transacti Tainted: G        W  O 3.4.0-rc4+ #11
> Call Trace:
>  [<ffffffff8104d6df>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8104d73a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffa0726b43>] btrfs_alloc_free_block+0x353/0x370 [btrfs]
>  [<ffffffffa0755c71>] ? read_extent_buffer+0xd1/0x130 [btrfs]
>  [<ffffffffa072e04a>] ? btree_read_extent_buffer_pages.clone.2+0xca/0x140 [btrfs]
>  [<ffffffffa0710a62>] __btrfs_cow_block+0x142/0x570 [btrfs]
>  [<ffffffffa07130dd>] ? read_block_for_search+0x14d/0x3e0 [btrfs]
>  [<ffffffffa0711492>] btrfs_cow_block+0x102/0x210 [btrfs]
>  [<ffffffffa0716b5c>] btrfs_search_slot+0x42c/0x960 [btrfs]
>  [<ffffffffa07853b9>] btrfs_delete_delayed_items+0x99/0x340 [btrfs]
>  [<ffffffff81152662>] ? kmem_cache_alloc+0x152/0x190
>  [<ffffffffa0786212>] btrfs_run_delayed_items+0x112/0x160 [btrfs]
>  [<ffffffffa07346df>] btrfs_commit_transaction+0x36f/0xa80 [btrfs]
>  [<ffffffffa07351c2>] ? start_transaction+0x92/0x320 [btrfs]
>  [<ffffffff8106fb60>] ? wake_up_bit+0x40/0x40
>  [<ffffffffa072fb5b>] transaction_kthread+0x26b/0x2e0 [btrfs]
>  [<ffffffffa072f8f0>] ? btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
>  [<ffffffffa072f8f0>] ? btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
>  [<ffffffff8106f4be>] kthread+0x9e/0xb0
>  [<ffffffff814fc864>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8106f420>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff814fc860>] ? gs_change+0x13/0x13
> ---[ end trace 504e7bc5e13ed458 ]---
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/transaction.c:1550!
> invalid opcode: 0000 [#1] SMP 
> CPU 1 
> Modules linked in: btrfs(O) zlib_deflate libcrc32c ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables ipt_REJECT bridge stp llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm ppdev sg parport_pc parport coretemp hwmon i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support sky2 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm_km
 s_helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]
> 
> Pid: 4604, comm: btrfs-cleaner Tainted: G        W  O 3.4.0-rc4+ #11 LENOVO QiTianM7150/To be filled by O.E.M.
> RIP: 0010:[<ffffffffa0732de0>]  [<ffffffffa0732de0>] btrfs_clean_old_snapshots+0x1d0/0x1e0 [btrfs]
> RSP: 0018:ffff880057113df0  EFLAGS: 00010286
> RAX: 00000000ffff8800 RBX: ffff880057113e10 RCX: ffff880052166780
> RDX: ffff880057113e10 RSI: ffff880057113e10 RDI: ffff880052166780
> RBP: ffff880057113e60 R08: ffff880057113e10 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff880000000000
> R13: 0000160000000000 R14: ffff880079ecb800 R15: ffff880057113e20
> FS:  0000000000000000(0000) GS:ffff88007da80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003842cd3ac0 CR3: 00000000542eb000 CR4: 00000000000407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process btrfs-cleaner (pid: 4604, threadinfo ffff880057112000, task ffff880075d60b30)
> Stack:
>  ffff880052166780 ffff880076918000 ffff880057113fd8 ffff880052166400
>  ffff880052166780 ffff880052166780 ffff880052166f80 ffff880079f16f80
>  ffff880057113e80 ffff880079ecb800 ffff880057113e80 ffff880057113e98
> Call Trace:
>  [<ffffffffa072d360>] cleaner_kthread+0x160/0x1c0 [btrfs]
>  [<ffffffffa072d200>] ? btrfs_bio_wq_end_io+0x90/0x90 [btrfs]
>  [<ffffffffa072d200>] ? btrfs_bio_wq_end_io+0x90/0x90 [btrfs]
>  [<ffffffff8106f4be>] kthread+0x9e/0xb0
>  [<ffffffff814fc864>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8106f420>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff814fc860>] ? gs_change+0x13/0x13
> Code: 22 b2 e0 31 c9 31 f6 ba 01 00 00 00 4c 89 e7 e8 47 24 ff ff 48 39 5d b0 75 d9 48 83 c4 48 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 
> RIP  [<ffffffffa0732de0>] btrfs_clean_old_snapshots+0x1d0/0x1e0 [btrfs]
>  RSP <ffff880057113df0>
> ---[ end trace 504e7bc5e13ed459 ]---
> 
> 
> kernel BUG at fs/btrfs/transaction.c:1550!
> refers to 
> int btrfs_clean_old_snapshots(struct btrfs_root *root)
> {
> [...]
>         while (!list_empty(&list)) {
> [...]
>                 BUG_ON(ret < 0);    ---> the bug
>         }
> 
> thanks,
> liubo

