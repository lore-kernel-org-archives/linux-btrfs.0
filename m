Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56501 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbdGOBW3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 21:22:29 -0400
Date: Fri, 14 Jul 2017 18:22:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Kai Krakow <hurikhan77@gmail.com>, bepi@adria.it, matt@techsquare.com,
        mh@zugschlus.de, mkaganer@gmail.com, david@codepoets.co.uk,
        tch@virtall.com, somethingsome2000@gmail.com
Cc: Chris Mason <clm@fb.com>, bo.li.liu@oracle.com, fdmanana@suse.com,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>
Message-ID: <20170715012216.njq6az3y34qyomtb@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170715004828.f4bom5wq34abe4lz@merlins.org>
 <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Chris and other developers,

Can you look at this bug which has been happening since 2012 on apparently all kernels between at least
3.4 and 4.11.
I didn't look in detail at each thread (took long enough to even find them all and paste here), but they seem pretty
similar although the reasons how they got there may be different, or at least not as benign as a race condition
between snapshot creation and deletion for those who do hourly snapshot rotations like me.

On the plus side, it looks like ever since 3.4 the code was already
smart enough not to crash you and just remounted the device read only.

On Mon, Jul 10, 2017 at 11:21:55PM -0700, Marc MERLIN wrote:
> Looks like btrfs has decided to give me hell.
> I'm still recovering my system.
> The biggest filesystem seems to work, but I just had it go read only:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 5 PID: 3734 at fs/btrfs/extent-tree.c:2960 btrfs_run_delayed_refs+0xb6/0x1dc
> BTRFS: Transaction aborted (error -17)
> Modules linked in: udp_diag tcp_diag inet_diag veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_
> fmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_
> ptable_mangle iptable_filter pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
> e_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd
> da_codec snd_cmipci rc_ati_x10 asus_wmi snd_hda_core snd_mpu401_uart snd_opl3_lib snd_hwdep snd_rawmidi snd_seq_device spars
> l tpm_infineon snd tpm_tis hwmon tpm_tis_core usbnet rc_core i2c_i801 usbserial libphy soundcore wmi i915 lpc_ich mfd_cor
> s evdev pcspkr parport_pc battery mei_me parport i2c_smbus e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_
> r async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common aesni_intel aes_x86_64 lrw glue_helper ablk_helper cryp
> 4 thermal usbcore mvsas libsas fjes scsi_transport_sas fan r8169 mii usb_common [last unloaded: ftdi_sio]
> CPU: 1 PID: 3734 Comm: btrfs-transacti Tainted: G     U  W       4.8.10-amd64-preempt-sysrq-20161121vb3tj1 #12
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>  0000000000200286 000000003f87d529 ffff9dcc9838fd00 ffffffffbb39e738
>  ffff9dcc9838fd50 0000000000000000 ffff9dcc9838fd40 ffffffffbb066e08
>  00000b909838fdc0 ffff9dc94fdc9be0 0000000000000000 ffff9dcca0d93000
> Call Trace:
>  [<ffffffffbb39e738>] dump_stack+0x63/0x7f
>  [<ffffffffbb066e08>] __warn+0xc2/0xdd
>  [<ffffffffbb066e7d>] warn_slowpath_fmt+0x5a/0x76
>  [<ffffffffbb291dc2>] btrfs_run_delayed_refs+0xb6/0x1dc
>  [<ffffffffbb2a4d1d>] btrfs_commit_transaction+0x5b/0x965
>  [<ffffffffbb2a030e>] transaction_kthread+0xf5/0x19f
>  [<ffffffffbb2a0219>] ? btrfs_cleanup_transaction+0x47b/0x47b
>  [<ffffffffbb081df3>] kthread+0xb4/0xbc
>  [<ffffffffbb6d23df>] ret_from_fork+0x1f/0x40
>  [<ffffffffbb081d3f>] ? init_completion+0x24/0x24
> ---[ end trace feb4b95c83ac065f ]---
> BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
> BTRFS info (device dm-2): forced readonly

Ok, please try this search in gmail or whatever archive you have
"btrfs_run_delayed_refs" "BTRFS: Transaction aborted" "Object already exists" 
 
I had a look in the archives. I'm wrong, I did have the bug with 4.11 (pasted below)
and plenty of others have had it too, actually plenty of other people, going all the way back to 3.4 (2012)
if all the reports I just found and pasted are ultimately the same problem (they may not be)
Me, it happens at snapshot rotation time, others triggered this other ways I think


Kai Krakow <hurikhan77@gmail.com> 2016/08/28
[4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
[44819.903435] ------------[ cut here ]------------
[44819.903443] WARNING: CPU: 3 PID: 2787 at fs/btrfs/extent-tree.c:2963 btrfs_run_delayed_refs+0x26c/0x290
[44819.903444] BTRFS: Transaction aborted (error -17)
[44819.903484] CPU: 3 PID: 2787 Comm: BrowserBlocking Tainted: P           O    4.7.2-gentoo #2
[44819.903485] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
[44819.903487]  0000000000000000 ffffffff8130af2d ffff8800b7d03d20 0000000000000000
[44819.903489]  ffffffff810865fa ffff880409374428 ffff8800b7d03d70 ffff8803bf299760
[44819.903491]  0000000000000000 00000000ffffffef ffff8803f677f000 ffffffff8108666a
[44819.903493] Call Trace:
[44819.903496]  [<ffffffff8130af2d>] ? dump_stack+0x46/0x59
[44819.903500]  [<ffffffff810865fa>] ? __warn+0xba/0xe0
[44819.903502]  [<ffffffff8108666a>] ? warn_slowpath_fmt+0x4a/0x50
[44819.903504]  [<ffffffff8121351c>] ? btrfs_run_delayed_refs+0x26c/0x290
[44819.903507]  [<ffffffff811feb1e>] ? btrfs_release_path+0xe/0x80
[44819.903509]  [<ffffffff81216afa>] ? btrfs_start_dirty_block_groups+0x2da/0x420
[44819.903511]  [<ffffffff812279f3>] ? btrfs_commit_transaction+0x143/0x990
[44819.903514]  [<ffffffff8116a2c5>] ? kmem_cache_free+0x165/0x180
[44819.903516]  [<ffffffff8124396c>] ? btrfs_wait_ordered_range+0x7c/0x110
[44819.903518]  [<ffffffff8123ecf6>] ? btrfs_sync_file+0x286/0x360
[44819.903522]  [<ffffffff811ae343>] ? do_fsync+0x33/0x60
[44819.903524]  [<ffffffff811ae57a>] ? SyS_fdatasync+0xa/0x10
[44819.903528]  [<ffffffff8162299b>] ? entry_SYSCALL_64_fastpath+0x13/0x8f
[44819.903529] ---[ end trace 6944811e170a0e57 ]---
[44819.903531] BTRFS: error (device bcache2) in btrfs_run_delayed_refs:2963: errno=-17 Object already exists
[44819.903533] BTRFS info (device bcache2): forced readonly


Me 2017/06/20
4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
[846332.977964] ------------[ cut here ]------------
[846332.992285] WARNING: CPU: 4 PID: 4095 at fs/btrfs/free-space-cache.c:1476 tree_insert_offset+0x78/0xb1
[846333.402648] CPU: 4 PID: 4095 Comm: btrfs-transacti Tainted: G     U          4.11.3-amd64-preempt-sysrq-20170406 #5
[846333.434917] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[846333.463597] Call Trace:
[846333.469942] usb 2-1-port4: device 2-1.4 not suspended yet
[846333.489639]  dump_stack+0x61/0x7d
[846333.500480]  __warn+0xc2/0xdd
[846333.510956]  warn_slowpath_null+0x1d/0x1f
[846333.524103]  tree_insert_offset+0x78/0xb1
[846333.537337]  link_free_space+0x2c/0x41
[846333.549991]  __btrfs_add_free_space+0x89/0x3aa
[846333.564236]  ? kmem_cache_free+0x3d/0x92
[846333.577702]  btrfs_add_free_space+0x1d/0x1f
[846333.591179]  unpin_extent_range+0xf3/0x2b0
[846333.605220]  btrfs_finish_extent_commit+0xda/0x1d4
[846333.621324]  btrfs_commit_transaction+0x629/0x79a
[846333.637205]  ? add_wait_queue+0x44/0x44
[846333.649680]  transaction_kthread+0xe2/0x178
[846333.663201]  ? btrfs_cleanup_transaction+0x3e8/0x3e8
[846333.679033]  kthread+0xfb/0x100
[846333.690261]  ? init_completion+0x24/0x24
[846333.703239]  ? do_fast_syscall_32+0xb7/0xfe
[846333.717649]  ret_from_fork+0x2c/0x40
[846333.729656] ---[ end trace 27aa532d1886e536 ]---
[846333.744721] BTRFS critical (device dm-1): unable to add free space :-17

[847312.529660] BTRFS: Transaction aborted (error -17)
[847312.912784] CPU: 6 PID: 4094 Comm: btrfs-cleaner Tainted: G     U  W       4.11.3-amd64-preempt-sysrq-20170406 #5
[847312.913132] usb 2-1-port4: device 2-1.4 not suspended yet
[847312.962394] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[847312.990936] Call Trace:
[847312.999347]  dump_stack+0x61/0x7d
[847313.010383]  __warn+0xc2/0xdd
[847313.020351]  warn_slowpath_fmt+0x5a/0x76
[847313.033274]  btrfs_run_delayed_refs+0xb1/0x1cc
[847313.047655]  btrfs_should_end_transaction+0x50/0x57
[847313.063910]  btrfs_drop_snapshot+0x38a/0x6c4
[847313.078619]  ? btrfs_kill_all_delayed_nodes+0x5f/0xd7
[847313.094916]  ? _raw_spin_lock+0x15/0x17
[847313.108325]  btrfs_clean_one_deleted_snapshot+0xce/0xdc
[847313.125493]  cleaner_kthread+0x91/0x14b
[847313.138228]  ? btrfs_destroy_pinned_extent+0xd2/0xd2
[847313.154308]  kthread+0xfb/0x100
[847313.164900]  ? init_completion+0x24/0x24
[847313.177781]  ? do_fast_syscall_32+0xb7/0xfe
[847313.191490]  ret_from_fork+0x2c/0x40
[847313.203432] ---[ end trace 27aa532d1886e537 ]---
[847313.218391] BTRFS: error (device dm-1) in btrfs_run_delayed_refs:2961: errno=-17 Object already exists
[847313.247668] BTRFS info (device dm-1): forced readonly


Giuseppe Della Bianca 2016/12/18, 4.8.8
[CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
------------[ cut here ]------------
WARNING: CPU: 1 PID: 4325 at fs/btrfs/extent-tree.c:2960 btrfs_run_delayed_refs+0x283/0x2b0 [btrfs]
BTRFS: Transaction aborted (error -17)
Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns nf_conntrack_br
 soundcore acpi_cpufreq tpm_tis tpm_tis_core tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc ata_generic nouveau vide
CPU: 1 PID: 4325 Comm: umount Tainted: G        W       4.8.8-100.fc23.x86_64 #1
Hardware name: System manufacturer System Product Name/M2N, BIOS 0902    02/16/2009
 0000000000000286 00000000dd260fac ffff8ffa0d25bb60 ffffffffbc3e493e
 ffff8ffa0d25bbb0 0000000000000000 ffff8ffa0d25bba0 ffffffffbc0a0ecb
 00000b9000000049 ffff8ff9e61b40a0 ffff8ffa2da77800 ffffffffffffffff
Call Trace:
 [<ffffffffbc3e493e>] dump_stack+0x63/0x85
 [<ffffffffbc0a0ecb>] __warn+0xcb/0xf0
 [<ffffffffbc0a0f4f>] warn_slowpath_fmt+0x5f/0x80
 [<ffffffffc07eb4e3>] btrfs_run_delayed_refs+0x283/0x2b0 [btrfs]
 [<ffffffffc07d62ec>] ?  btrfs_cow_block+0x10c/0x1e0 [btrfs]
 [<ffffffffc07ff62e>] commit_cowonly_roots+0xae/0x2e0 [btrfs]
 [<ffffffffc07eb466>] ?  btrfs_run_delayed_refs+0x206/0x2b0 [btrfs]
 [<ffffffffc08706b4>] ?  btrfs_qgroup_account_extents+0x84/0x180 [btrfs]
 [<ffffffffc0802187>] btrfs_commit_transaction+0x547/0xa40 [btrfs]
 [<ffffffffc07faa9f>] btrfs_commit_super+0x8f/0xa0 [btrfs]
 [<ffffffffc07fcbcb>] close_ctree+0x2db/0x380 [btrfs]
 [<ffffffffbc26d3da>] ?  evict_inodes+0x15a/0x180
 [<ffffffffc07ccf29>] btrfs_put_super+0x19/0x20 [btrfs]
 [<ffffffffbc2520bf>] generic_shutdown_super+0x6f/0xf0
 [<ffffffffbc2523b2>] kill_anon_super+0x12/0x20
 [<ffffffffc07cdd98>] btrfs_kill_super+0x18/0x110 [btrfs]
 [<ffffffffbc252763>] deactivate_locked_super+0x43/0x70
 [<ffffffffbc2527ec>] deactivate_super+0x5c/0x60
 [<ffffffffbc2711bf>] cleanup_mnt+0x3f/0x90
 [<ffffffffbc271252>] __cleanup_mnt+0x12/0x20
 [<ffffffffbc0bf0ce>] task_work_run+0x7e/0xa0
 [<ffffffffbc0032d2>] exit_to_usermode_loop+0xc2/0xd0
 [<ffffffffbc003bf1>] syscall_return_slowpath+0xa1/0xb0
 [<ffffffffbc7ffb3a>] entry_SYSCALL_64_fastpath+0xa2/0xa4
---[ end trace f7eb2e818f727168 ]---
BTRFS: error (device sda3) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
BTRFS info (device sda3): forced readonly
BTRFS warning (device sda3): Skipping commit of aborted transaction.
BTRFS: error (device sda3) in cleanup_transaction:1854: errno=-17 Object already exists


Matt McKinnon <matt@techsquare.com> 2017/08/09 kernel 4.7
BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963: errno=-17 Object already exists
------------[ cut here ]------------
WARNING: CPU: 6 PID: 269 at fs/btrfs/extent-tree.c:2963 btrfs_run_delayed_refs+0x292/0x2d0 [btrfs]
BTRFS: Transaction aborted (error -17)
Modules linked in: ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables ipmi_devintf nfsd auth_rpcgss nfs_acl nfs lockd grace sunrpc fscache sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd dm_multipath joydev lpc_ich mei_me mei ioatdma wmi ipmi_si ipmi_msghandler shpchp mac_hid btrfs lp parport ses enclosure scsi_transport_sas raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor igb raid6_pq libcrc32c i2c_algo_bit raid1 hid_generic dca usbhid raid0 ptp hid ahci megaraid_sas multipath libahci pps_core linear dm_mirror dm_region_hash dm_log
CPU: 6 PID: 269 Comm: kworker/u18:5 Not tainted 4.7.0-custom #1
Hardware name: Supermicro X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
 0000000000000000 ffff88086a057ca0 ffffffff813b816c ffff88086a057cf0
 0000000000000000 ffff88086a057ce0 ffffffff8107a321 00000b9325288170
 ffff8808519eb000 ffff880825288170 ffff88086b2c1000 0000000000000020
Call Trace:
 [<ffffffff813b816c>] dump_stack+0x63/0x87
 [<ffffffff8107a321>] __warn+0xd1/0xf0
 [<ffffffff8107a38f>] warn_slowpath_fmt+0x4f/0x60
 [<ffffffffc01c6e52>] btrfs_run_delayed_refs+0x292/0x2d0 [btrfs]
 [<ffffffffc01c6f24>] delayed_ref_async_start+0x94/0xb0 [btrfs]
 [<ffffffffc020f780>] normal_work_helper+0xc0/0x2d0 [btrfs]
 [<ffffffff81091082>] ? pwq_activate_delayed_work+0x42/0xb0
 [<ffffffffc020fbc2>] btrfs_extent_refs_helper+0x12/0x20 [btrfs]
 [<ffffffff81093173>] process_one_work+0x153/0x3f0
 [<ffffffff8109392b>] worker_thread+0x12b/0x4b0
 [<ffffffff81093800>] ? rescuer_thread+0x340/0x340
 [<ffffffff81099109>] kthread+0xc9/0xe0
 [<ffffffff817db85f>] ret_from_fork+0x1f/0x40
 [<ffffffff81099040>] ? kthread_park+0x60/0x60
---[ end trace e2b0b8dc37502011 ]---
BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963: errno=-17 Object already exists
BTRFS info (device sda1): forced readonly


Marc Haber <mh+linux-btrfs@zugschlus.de> 2015/12/11
Transaction aborted (error -17) during balance
WARNING: CPU: 4 PID: 5545 at /build/linux-eGTGmU/linux-4.3/fs/btrfs/extent-tree.c:2093 __btrfs_inc_extent_ref.isra.52+0x20e/0x280 [btrfs]()
BTRFS: Transaction aborted (error -17)
Modules linked in: ctr ccm tun rfcomm cpufreq_userspace binfmt_misc cpufreq_stats cpufreq_powersave cpufreq_conservative nf_conntrack_netlink nfnetlink bnep ip6table_filter ip6_tables xt_TCPMSS xt_tcpudp iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables bridge stp llc joydev arc4 iTCO_wdt iwldvm iTCO_vendor_support mac80211 snd_hda_codec_conexant intel_rapl snd_hda_codec_generic iosf_mbi x86_pkg_temp_thermal btusb intel_powerclamp btrtl snd_hda_intel iwlwifi btbcm kvm_intel snd_hda_codec btintel kvm snd_hda_core psmouse bluetooth snd_hwdep snd_pcm_oss pcspkr serio_raw i2c_i801 sg cfg80211 snd_mixer_oss lpc_ich snd_pcm mfd_core snd_timer mei_me shpchp mei thinkpad_acpi nvram
 tpm_tis snd tpm soundcore rfkill evdev battery ac processor coretemp loop drbd lru_cache libcrc32c parport_pc ppdev lp parport autofs4 btrfs xor raid6_pq ext4 crc16 mbcache jbd2 algif_skcipher af_alg dm_crypt dm_mod md_mod hid_generic hid_logitech_hidpp hid_logitech_dj usbhid hid sd_mod uas usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel jitterentropy_rng sha256_ssse3 sha256_generic hmac drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper i915 ahci ablk_helper cryptd libahci sdhci_pci i2c_algo_bit libata ehci_pci drm_kms_helper sdhci ehci_hcd scsi_mod mmc_core e1000e usbcore ptp usb_common drm pps_core thermal wmi video button
CPU: 4 PID: 5545 Comm: kworker/u16:1 Not tainted 4.3.0-trunk-amd64 #1 Debian 4.3-1~exp2
Hardware name: LENOVO 4240CTO/4240CTO, BIOS 8AET63WW (1.43 ) 05/08/2013
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
 ffffffffa0627250 ffffffff812c5319 ffff88020dc23ba0 ffffffff8106ebcd
 ffff880406146000 ffff88020dc23bf0 ffff8803c90b9410 0000000000000000
 0000000000000106 ffffffff8106ec4c ffffffffa0627420 ffffffff00000020
Call Trace:
 [<ffffffff812c5319>] ? dump_stack+0x40/0x57
 [<ffffffff8106ebcd>] ? warn_slowpath_common+0x7d/0xb0
 [<ffffffff8106ec4c>] ? warn_slowpath_fmt+0x4c/0x50
 [<ffffffffa058bdc9>] ? insert_tree_block_ref+0x49/0x60 [btrfs]
 [<ffffffffa058fc6e>] ? __btrfs_inc_extent_ref.isra.52+0x20e/0x280 [btrfs]
 [<ffffffffa0594e77>] ? __btrfs_run_delayed_refs+0xc47/0x1050 [btrfs]
 [<ffffffff8101d3b5>] ? sched_clock+0x5/0x10
 [<ffffffff81094130>] ? check_preempt_curr+0x50/0x90
 [<ffffffff81094184>] ? ttwu_do_wakeup+0x14/0xc0
 [<ffffffffa0597e98>] ? btrfs_run_delayed_refs+0x78/0x2a0 [btrfs]
 [<ffffffffa05980f2>] ? delayed_ref_async_start+0x32/0x80 [btrfs]
 [<ffffffffa05daeb8>] ? btrfs_scrubparity_helper+0xc8/0x260 [btrfs]
 [<ffffffff810851df>] ? process_one_work+0x19f/0x3d0
 [<ffffffff8108545d>] ? worker_thread+0x4d/0x450
 [<ffffffff81085410>] ? process_one_work+0x3d0/0x3d0
 [<ffffffff8108af5d>] ? kthread+0xbd/0xe0
 [<ffffffff8108aea0>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff81553d0f>] ? ret_from_fork+0x3f/0x70
 [<ffffffff8108aea0>] ? kthread_create_on_node+0x170/0x170
---[ end trace 6671e30ac2882b40 ]---
BTRFS: error (device dm-11) in __btrfs_inc_extent_ref:2093: errno=-17 Object already exists
BTRFS info (device dm-11): forced readonly
BTRFS: error (device dm-11) in btrfs_run_delayed_refs:2851: errno=-17 Object already exists


Mordechay Kaganer <mkaganer@gmail.com> 2015/11/16 kernel 4.2
Transaction aborted (error -17) after crash
[  836.026606] BTRFS warning (device md1): block group 12969790406656 has wrong amount of free space
[  836.026610] BTRFS warning (device md1): failed to load free space cache for block group 12969790406656, rebuild it now
[ 1033.619798] BTRFS warning (device md1): block group 15322358743040 has wrong amount of free space
[ 1033.619801] BTRFS warning (device md1): failed to load free space cache for block group 15322358743040, rebuild it now
[ 2052.843713] ------------[ cut here ]------------
[ 2052.843756] WARNING: CPU: 2 PID: 1725 at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:2781 btrfs_run_delayed_refs.part.73+0x242/0x270 [btrfs]()
[ 2052.843758] BTRFS: Transaction aborted (error -17)
[ 2052.843827] CPU: 2 PID: 1725 Comm: btrfs-transacti Not tainted 4.2.5-040205-generic #201510270124
[ 2052.843829] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./EPC602D8A, BIOS P1.20 04/16/2014
[ 2052.843832]  0000000000000000 00000000df907816 ffff8808414dfcb8 ffffffff817d8d6d
[ 2052.843836]  0000000000000000 ffff8808414dfd10 ffff8808414dfcf8 ffffffff8107b3c6
[ 2052.843839]  0000000000001a0c ffff88049c5fe8a0 ffff88085577d800 ffff88082932cb80
[ 2052.843843] Call Trace:
[ 2052.843852]  [<ffffffff817d8d6d>] dump_stack+0x45/0x57
[ 2052.843858]  [<ffffffff8107b3c6>] warn_slowpath_common+0x86/0xc0
[ 2052.843862]  [<ffffffff8107b455>] warn_slowpath_fmt+0x55/0x70
[ 2052.843878]  [<ffffffffc022ecf2>] btrfs_run_delayed_refs.part.73+0x242/0x270 [btrfs]
[ 2052.843882]  [<ffffffff810e54bc>] ? del_timer_sync+0x4c/0x60
[ 2052.843897]  [<ffffffffc022ed35>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
[ 2052.843915]  [<ffffffffc0243756>] btrfs_commit_transaction+0x56/0xb20 [btrfs]
[ 2052.843931]  [<ffffffffc023ee19>] transaction_kthread+0x229/0x240 [btrfs]
[ 2052.843945]  [<ffffffffc023ebf0>] ?  btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[ 2052.843949]  [<ffffffff8109a798>] kthread+0xd8/0xf0
[ 2052.843953]  [<ffffffff8109a6c0>] ? kthread_create_on_node+0x1b0/0x1b0
[ 2052.843957]  [<ffffffff817dff9f>] ret_from_fork+0x3f/0x70
[ 2052.843960]  [<ffffffff8109a6c0>] ? kthread_create_on_node+0x1b0/0x1b0
[ 2052.843962] ---[ end trace 6575cf272a151e61 ]---
[ 2052.843966] BTRFS: error (device md1) in
btrfs_run_delayed_refs:2781: errno=-17 Object already exists
[ 2052.844024] BTRFS info (device md1): forced readonly
[ 2052.848397] pending csums is 7327744

David Goodwin <david@codepoets.co.uk>  2015/07/25 kernel 4.2
WARNING: CPU: 2 PID: 31502 at fs/btrfs/extent-tree.c:2025 __btrfs_inc_extent_ref.isra.51+0x210/0x280 [btrfs]()
BTRFS: Transaction aborted (error -17)
CPU: 2 PID: 31502 Comm: kworker/u16:1 Tainted: G           O 4.2.0-rc3-dg1 #1
Hardware name: System manufacturer System Product Name/M5A88-M, BIOS 1101    03/16/2012
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
 0000000000000000 ffffffffa02b98a7 ffffffff81540a6f ffff880107383b28
 ffffffff8106dfa1 ffff88040c955800 ffff8801003612f8 ffff8800441bfda0
 00000a6f8acba000 0000000000003fa4 ffffffff8106e01a ffffffffa02bbc48
Call Trace:
 [<ffffffff81540a6f>] ? dump_stack+0x40/0x50
 [<ffffffff8106dfa1>] ? warn_slowpath_common+0x81/0xb0
 [<ffffffff8106e01a>] ? warn_slowpath_fmt+0x4a/0x50
 [<ffffffffa0222390>] ? __btrfs_inc_extent_ref.isra.51+0x210/0x280 [btrfs]
 [<ffffffffa0229e1f>] ? __btrfs_run_delayed_refs+0xd1f/0x10a0 [btrfs]
 [<ffffffff8101cc65>] ? sched_clock+0x5/0x10
 [<ffffffff811bd0c2>] ? __sb_start_write+0x42/0xe0
 [<ffffffffa022e26a>] ? btrfs_run_delayed_refs.part.73+0x6a/0x280 [btrfs]
 [<ffffffffa022e518>] ? delayed_ref_async_start+0x78/0x90 [btrfs]
 [<ffffffffa026eb6c>] ? normal_work_helper+0xbc/0x260 [btrfs]
 [<ffffffff81084e01>] ? process_one_work+0x151/0x3d0
 [<ffffffff81085805>] ? worker_thread+0x65/0x470
 [<ffffffff8154226d>] ? __schedule+0x28d/0x8a0
 [<ffffffff810857a0>] ? rescuer_thread+0x310/0x310
 [<ffffffff8108ac23>] ? kthread+0xd3/0xf0
 [<ffffffff8108ab50>] ? kthread_create_on_node+0x180/0x180
 [<ffffffff8154699f>] ? ret_from_fork+0x3f/0x70
 [<ffffffff8108ab50>] ? kthread_create_on_node+0x180/0x180
---[ end trace cc878b7b9dc6406e ]---
BTRFS: error (device sdc1) in __btrfs_inc_extent_ref:2025: errno=-17 Object already exists
BTRFS info (device sdc1): forced readonly
BTRFS: error (device sdc1) in btrfs_run_delayed_refs:2781: errno=-17 Object already exists


It keeps going, I ran out of motivation for pasting them all

Tomasz Chmielewski <tch@virtall.com> / 2013/12/20 kernel 3.13:
BTRFS debug (device sdb5): run_one_delayed_ref returned -17
------------[ cut here ]------------
WARNING: CPU: 0 PID: 15042 at fs/btrfs/super.c:254 __btrfs_abort_transaction+0x4d/0xff [btrfs]()
btrfs: Transaction aborted (error -17)
CPU: 0 PID: 15042 Comm: btrfs-transacti Tainted: G        W    3.13.0-rc4 #1
Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
 0000000000000009 ffff8800374ddc48 ffffffff8138a37d 0000000000000006
 ffff8800374ddc98 ffff8800374ddc88 ffffffff810370a9 ffff8800374ddd80
 ffffffffa020d524 00000000ffffffef ffff8807ead7d800 ffff8807ff0cc8c0
Call Trace:
 [<ffffffff8138a37d>] dump_stack+0x46/0x58
 [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
 [<ffffffffa020d524>] ? __btrfs_abort_transaction+0x4d/0xff [btrfs]
 [<ffffffff81037157>] warn_slowpath_fmt+0x41/0x43
 [<ffffffffa020d524>] __btrfs_abort_transaction+0x4d/0xff [btrfs]
 [<ffffffffa02226ed>] btrfs_run_delayed_refs+0x253/0x46f [btrfs]
 [<ffffffffa022fdec>] btrfs_commit_transaction+0x36d/0x7df [btrfs]
 [<ffffffffa022e345>] transaction_kthread+0xef/0x1c2 [btrfs]
 [<ffffffffa022e256>] ? open_ctree+0x1ac7/0x1ac7 [btrfs]
 [<ffffffff8104ee9a>] kthread+0xcd/0xd5
 [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
 [<ffffffff8138f17c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
---[ end trace b552aca9a0cff3cb ]---
BTRFS error (device sdb5) in btrfs_run_delayed_refs:2730: errno=-17 Object already exists
BTRFS info (device sdb5): forced readonly
BTRFS warning (device sdb5): Skipping commit of aborted transaction.
BTRFS error (device sdb5) in cleanup_transaction:1553: errno=-17 Object already exists


Chester <somethingsome2000@gmail.com> / 2012/06/26
btrfs volume suddenly becomes read-only
btrfs: run_one_delayed_ref returned -17
------------[ cut here ]------------
WARNING: at fs/btrfs/super.c:221 __btrfs_abort_transaction+0x40/0x9d()
Hardware name: HP Pavilion dv6 Notebook PC
btrfs: Transaction aborted
Pid: 4491, comm: btrfs-endio-wri Not tainted 3.4.0-00091-gcb77fcd #1
Call Trace:
 [<ffffffff8106382f>] warn_slowpath_common+0x7e/0x96
 [<ffffffff810638db>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff8125e626>] __btrfs_abort_transaction+0x40/0x9d
 [<ffffffff8126dd55>] btrfs_run_delayed_refs+0x267/0x34b
 [<ffffffff8111e2f3>] ? virt_to_head_page+0x9/0x2c
 [<ffffffff8127c241>] __btrfs_end_transaction+0x7f/0x21b
 [<ffffffff8127c426>] btrfs_end_transaction+0x10/0x12
 [<ffffffff812810c0>] btrfs_finish_ordered_io+0x295/0x2e5
 [<ffffffff8167ce58>] ? schedule_timeout+0x9c/0xb6
 [<ffffffff8106eb22>] ? usleep_range+0x3d/0x3d
 [<ffffffff81281120>] finish_ordered_fn+0x10/0x12
 [<ffffffff812a3256>] worker_loop+0x169/0x4a3
 [<ffffffff812a30ed>] ? btrfs_queue_worker+0x283/0x283
 [<ffffffff8107d0c0>] kthread+0x86/0x8e
 [<ffffffff81685c64>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107d03a>] ? kthread_freezable_should_stop+0x43/0x43
 [<ffffffff81685c60>] ? gs_change+0x13/0x13
---[ end trace fe73a333f7c68c2e ]---
BTRFS error (device sda6) in btrfs_run_delayed_refs:2454: Object already exists
btrfs is forced readonly
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
