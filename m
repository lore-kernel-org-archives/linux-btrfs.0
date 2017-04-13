Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:49260 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755949AbdDMIpV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 04:45:21 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
        (envelope-from <mh+linux-btrfs@zugschlus.de>)
        id 1cyaNJ-0004tC-4C
        for linux-btrfs@vger.kernel.org; Thu, 13 Apr 2017 10:45:09 +0200
Date: Thu, 13 Apr 2017 10:45:09 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs won't mount any more
Message-ID: <20170413084509.GH3699@torres.zugschlus.de>
References: <20170411071531.GK3699@torres.zugschlus.de>
 <20170411161502.ol4tjl3agqnlerab@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170411161502.ol4tjl3agqnlerab@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 06:15:02PM +0200, Adam Borowski wrote:
> On Tue, Apr 11, 2017 at 09:15:31AM +0200, Marc Haber wrote:
> > I have wrecked another btrfs file system, probably for good this time.
> > 
> > It's a 80 GB filesystem from 2015, in my secondary notebook, on an
> > encrypted SSD. The btrfs holds the root filesystem and the rest of the
> > system as well.
> > 
> > I have a cronjob that makes snapshots of the system directories daily,
> > and of /home every ten minutes. A second cronjob cleans up old snapshots
> > so that the number of snapshots present is about between 400 and 600.
> > This is the key feature that made me decide for btrfs in the first
> > place.
> > 
> > Last week (I was on kernel 4.10.8 with Debian unstable), I was forced to
> > promote the secondary laptop to the primary one which resulted in
> > serious work being done on the first time. Over time, the filesystem
> > filled up without me noticing and was finally 100% full.
> 
> CoW and log-structured filesystems in general tend to take 100% full
> conditions far worse than traditional filesystems, but it still should
> result only in performance degradation and/or metadata-vs-data issues rather
> than a fatal error.  So if this is the cause, you obviously hit a bug.

Given that btrfs has a reputation of not gracefully handling out of
space situations, the trouble was expected.

> > I then cleaned up about four gigs by deleting a couple of redundant ISO
> > images and some snapshots that were not due for regular deletion yet. I
> > then started a btrfs balance / -d50, unfortunately without stopping the
> > snapshot-making cronjob. This resulted in the notebook becoming
> > unuseable for extended periods of time, without even being able to log
> > in. After running for some 30 hours, the notebook ran out of battery
> > (don't ask, stupid me).
> 
> Ouch, this is generally harmless unless your disk lies about barriers. 
> Btrfs absolutely depends on them, and tends to suffer catastrophic
> corruption if writes were reordered when they shouldn't.

So if the disk would actually lie, I would have had much trouble even
earlier. It's an SSD from 2013 or 2014, I think from Kingston. The box
is offline and remote at the moment, so I cannot give the exact type.

Between the btrfs and the actual disk there was a dm-crypt/LUKS layer
and LVM, but I can reproduce the crash from an image on a different host
now.

> Even in such a case, using an older root would help, although that
> possibility is almost certainly gone now.

How would I try that? A pointer to the docs is fine.

> > After rebooting, the btrfs balance proceeded immediately after mounting
> > the root fs. System unuseable again. After a day, I finally had a root
> > shell and was able to issue a btrfs cancel /. Unfortunately, the system
> > didn't care about that command and happily continued to balance. After
> > some more 30 hours, I lost patience and resetted the system.
> 
> Mounting with -o skip_balance may help.

No, same issue.

> Two years old is not much, the format nor its use hasn't changed noticeably
> since then.  You run the very latest upstream stable kernel, with its almost
> freshest version (4.10.9 was tagged Saturday).  400-600 snapshots is nothing
> remarkable, it's the usual range.  The only thing differing from the most
> typical usage is your snapshot frequency, and even that is nothing
> frightening.

Doesn't SuSE's snapper do snapshots every ten minutes?

I can reproduce the crash on 4.10.10 now.

> Thus, a failure like yours in mainstream use is certainly interesting.
> 
> However, I have a piece of advice for now: could you make a copy of the
> filesystem?  80GB is _nothing_: it's way below the accuracy of du -h on a
> modern HDD, and not a burden for a typical SSD.  Being able to investigate
> it from a bigger machine would be convenient, and having a copy would let
> you use dangerous rescue methods without any risk.  And debugging oopses on
> a laptop with no working serial or netconsole sucks; if you have no other
> machine at hand then running the victim kernel in qemu-kvm might offer a
> poor-man's console.

qemu-kvm is also a good idea, up to now I have logs from a physical box
mounting the btrfs image loopback.

> For advice for your specific case, we can't do much without seeing the
> actual error messages.

I do have a dd copy of the device now.

$ sudo losetup --find --show ./dropbtr0.btrfs
$ sudo mount -o skip_balance -t btrfs /dev/loop0 /mnt/tempdisk

does immediately result in:

Apr 12 22:37:48 fan kernel: [  124.742104] loop: module loaded
Apr 12 22:37:48 fan kernel: [  124.784727] BTRFS: device label dropbtr0 devid 1 transid 1530529 /dev/loop0
Apr 12 22:38:07 fan kernel: [  143.120268] BTRFS info (device loop0): disk space caching is enabled
Apr 12 22:38:07 fan kernel: [  143.207872] BUG: unable to handle kernel NULL pointer dereference at 00000000000001f0
Apr 12 22:38:07 fan kernel: [  143.223536] IP: can_overcommit+0x20/0x100 [btrfs]
Apr 12 22:38:07 fan kernel: [  143.232936] PGD 0 
Apr 12 22:38:07 fan kernel: [  143.232936] 
Apr 12 22:38:07 fan kernel: [  143.239939] Oops: 0000 [#1] SMP
Apr 12 22:38:07 fan kernel: [  143.246211] Modules linked in: loop ebtable_filter ebtables ip6table_filter ip6_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave bridge stp llc iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack amd64_edac_mod edac_mce_amd edac_core snd_hda_codec_realtek snd_hda_codec_generic kvm_amd ipt_REJECT nf_reject_ipv4 snd_hda_codec_hdmi kvm snd_hda_intel xt_tcpudp snd_cmipci snd_hda_codec snd_mpu401_uart snd_hda_core snd_opl3_lib snd_rawmidi snd_hwdep irqbypass input_leds snd_seq_device pcspkr k10temp snd_pcm_oss snd_mixer_oss sg iptable_filter snd_pcm snd_timer snd soundcore asus_atk0110 shpchp acpi_cpufreq evdev tpm_tis tpm_tis_core tpm ip_tables x_tables autofs4 btrfs ext4 crc16 jbd2 fscrypto mbcache ecb crypto_simd glue_helper cryptd aes_x86_64 xts gf128mul algif_skcipher
Apr 12 22:38:07 fan kernel: [  143.388923]  af_alg dm_crypt raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod hid_generic usbhid hid usb_storage dm_mod sr_mod cdrom sd_mod ohci_pci amdkfd radeon r8169 mii ahci libahci i2c_algo_bit ttm sym53c8xx xhci_pci drm_kms_helper ohci_hcd ehci_pci scsi_transport_spi libata xhci_hcd i2c_piix4 ehci_hcd drm usbcore scsi_mod usb_common i2c_core button
Apr 12 22:38:07 fan kernel: [  143.468706] CPU: 1 PID: 145 Comm: kworker/u16:3 Not tainted 4.10.10-zgws1 #2
Apr 12 22:38:07 fan kernel: [  143.482779] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Apr 12 22:38:07 fan kernel: [  143.501548] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
Apr 12 22:38:07 fan kernel: [  143.516314] task: ffff88041a2bae40 task.stack: ffffc90001f9c000
Apr 12 22:38:07 fan kernel: [  143.528147] RIP: 0010:can_overcommit+0x20/0x100 [btrfs]
Apr 12 22:38:07 fan kernel: [  143.538570] RSP: 0018:ffffc90001f9fde8 EFLAGS: 00010296
Apr 12 22:38:07 fan kernel: [  143.549004] RAX: 0000000001000000 RBX: ffff8803f24dbe00 RCX: 0000000000000002
Apr 12 22:38:07 fan kernel: [  143.563251] RDX: 0000000000600000 RSI: 0000000000000000 RDI: 0000000000000000
Apr 12 22:38:07 fan kernel: [  143.577496] RBP: ffff8803f24dbe00 R08: 0000000000000000 R09: 0000000000000000
Apr 12 22:38:07 fan kernel: [  143.591744] R10: ffff88042fc52780 R11: 0000002157da2b60 R12: 0000000000600000
Apr 12 22:38:07 fan kernel: [  143.605990] R13: ffff88017fc0b800 R14: 0000000000000000 R15: ffff8803f24dbeb8
Apr 12 22:38:07 fan kernel: [  143.620238] FS:  0000000000000000(0000) GS:ffff88042fc40000(0000) knlGS:0000000000000000
Apr 12 22:38:07 fan kernel: [  143.636391] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 12 22:38:07 fan kernel: [  143.647866] CR2: 00000000000001f0 CR3: 00000003fc3e0000 CR4: 00000000000006e0
Apr 12 22:38:07 fan kernel: [  143.662112] Call Trace:
Apr 12 22:38:07 fan kernel: [  143.667016]  ? btrfs_async_reclaim_metadata_space+0x371/0x440 [btrfs]
Apr 12 22:38:07 fan kernel: [  143.679882]  ? process_one_work+0x17d/0x460
Apr 12 22:38:07 fan kernel: [  143.688232]  ? worker_thread+0x48/0x490
Apr 12 22:38:07 fan kernel: [  143.695895]  ? kthread+0xef/0x120
Apr 12 22:38:07 fan kernel: [  143.702514]  ? process_one_work+0x460/0x460
Apr 12 22:38:07 fan kernel: [  143.710870]  ? kthread_create_on_node+0x40/0x40
Apr 12 22:38:07 fan kernel: [  143.719919]  ? ret_from_fork+0x26/0x40
Apr 12 22:38:07 fan kernel: [  143.727403] Code: 90 66 2e 0f 1f 84 00 00 00 00 00 f6 46 58 01 0f 85 ef 00 00 00 41 57 41 56 41 55 41 54 49 89 d4 55 53 48 89 f3 31 f6 48 83 ec 08 <4c> 8b bf f0 01 00 00 89 4c 24 04 49 3b 7f 38 4d 8d af 48 01 00 
Apr 12 22:38:07 fan kernel: [  143.765077] RIP: can_overcommit+0x20/0x100 [btrfs] RSP: ffffc90001f9fde8
Apr 12 22:38:07 fan kernel: [  143.778445] CR2: 00000000000001f0
Apr 12 22:38:07 fan kernel: [  143.804936] ---[ end trace e2274712b9039680 ]---

and a few seconds later

Apr 12 22:38:29 fan kernel: [  164.826083] INFO: rcu_sched self-detected stall on CPU
Apr 12 22:38:29 fan kernel: [  164.830123] INFO: rcu_sched detected stalls on CPUs/tasks:
Apr 12 22:38:29 fan kernel: [  164.830137]      4-...: (5250 ticks this GP) idle=03b/140000000000001/0 softirq=8337/8337 fqs=2498 
Apr 12 22:38:29 fan kernel: [  164.830138]      (detected by 2, t=5252 jiffies, g=4002, c=4001, q=2016)
Apr 12 22:38:29 fan kernel: [  164.830145] Task dump for CPU 4:
Apr 12 22:38:29 fan kernel: [  164.830147] mount           R  running task        0  4874   4870 0x00000008
Apr 12 22:38:29 fan kernel: [  164.830153] Call Trace:
Apr 12 22:38:29 fan kernel: [  164.830168]  ? __alloc_pages_nodemask+0xea/0x240
Apr 12 22:38:29 fan kernel: [  164.830178]  ? chksum_update+0xe/0x15 [crc32c_generic]
Apr 12 22:38:29 fan kernel: [  164.830184]  ? crypto_shash_update+0x3a/0x110
Apr 12 22:38:29 fan kernel: [  164.830189]  ? cache_grow_end+0x119/0x140
Apr 12 22:38:29 fan kernel: [  164.830233]  ? __load_free_space_cache+0x1cb/0x6b0 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830266]  ? setup_cluster_no_bitmap+0x167/0x2c0 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830299]  ? tree_insert_offset+0x8c/0xd0 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830331]  ? setup_cluster_no_bitmap+0x19a/0x2c0 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830338]  ? native_queued_spin_lock_slowpath+0x16b/0x190
Apr 12 22:38:29 fan kernel: [  164.830344]  ? _raw_spin_lock+0x18/0x20
Apr 12 22:38:29 fan kernel: [  164.830374]  ? find_free_extent.isra.67+0xa21/0x1110 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830404]  ? btrfs_reserve_extent+0xa6/0x210 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830432]  ? btrfs_alloc_tree_block+0x109/0x4b0 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830458]  ? __btrfs_cow_block+0x144/0x570 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830484]  ? btrfs_cow_block+0xf9/0x1a0 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830510]  ? btrfs_search_slot+0x1fa/0xa00 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830514]  ? cache_grow_end+0x119/0x140
Apr 12 22:38:29 fan kernel: [  164.830547]  ? btrfs_truncate_inode_items+0x188/0xe30 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830581]  ? btrfs_evict_inode+0x478/0x590 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830586]  ? evict+0xb9/0x1c0
Apr 12 22:38:29 fan kernel: [  164.830618]  ? btrfs_orphan_cleanup+0x1d7/0x410 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830651]  ? btrfs_recover_relocation+0x377/0x430 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830682]  ? btrfs_cleanup_fs_roots+0x133/0x150 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830714]  ? open_ctree+0x1fa1/0x2430 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830740]  ? btrfs_mount+0xd13/0xe50 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830744]  ? pcpu_alloc_area+0x20b/0x3e0
Apr 12 22:38:29 fan kernel: [  164.830747]  ? pcpu_next_unpop+0x36/0x50
Apr 12 22:38:29 fan kernel: [  164.830750]  ? pcpu_alloc+0x3ce/0x660
Apr 12 22:38:29 fan kernel: [  164.830756]  ? mount_fs+0x31/0x150
Apr 12 22:38:29 fan kernel: [  164.830759]  ? vfs_kern_mount+0x5d/0x120
Apr 12 22:38:29 fan kernel: [  164.830785]  ? btrfs_mount+0x17e/0xe50 [btrfs]
Apr 12 22:38:29 fan kernel: [  164.830788]  ? pcpu_alloc_area+0x20b/0x3e0
Apr 12 22:38:29 fan kernel: [  164.830791]  ? pcpu_alloc+0x3ce/0x660
Apr 12 22:38:29 fan kernel: [  164.830796]  ? mount_fs+0x31/0x150
Apr 12 22:38:29 fan kernel: [  164.830799]  ? vfs_kern_mount+0x5d/0x120
Apr 12 22:38:29 fan kernel: [  164.830803]  ? do_mount+0x1a2/0xc30
Apr 12 22:38:29 fan kernel: [  164.830808]  ? _copy_from_user+0x44/0x70
Apr 12 22:38:29 fan kernel: [  164.830812]  ? SyS_mount+0x79/0xd0
Apr 12 22:38:29 fan kernel: [  164.830817]  ? entry_SYSCALL_64_fastpath+0x1a/0xa9
Apr 12 22:38:29 fan kernel: [  165.255984]      4-...: (5250 ticks this GP) idle=03b/140000000000001/0 softirq=8337/8337 fqs=2548 
Apr 12 22:38:29 fan kernel: [  165.255985]       (t=5358 jiffies g=4002 c=4001 q=2490)
Apr 12 22:38:29 fan kernel: [  165.255998] Task dump for CPU 4:
Apr 12 22:38:29 fan kernel: [  165.256001] mount           R  running task        0  4874   4870 0x00000008
Apr 12 22:38:29 fan kernel: [  165.256007] Call Trace:
Apr 12 22:38:29 fan kernel: [  165.256011]  <IRQ>
Apr 12 22:38:29 fan kernel: [  165.256021]  ? sched_show_task+0xc6/0x130
Apr 12 22:38:29 fan kernel: [  165.256026]  ? rcu_dump_cpu_stacks+0x8d/0xad
Apr 12 22:38:29 fan kernel: [  165.256032]  ? rcu_check_callbacks+0x7b8/0x910
Apr 12 22:38:29 fan kernel: [  165.256039]  ? tick_sched_handle.isra.15+0x50/0x50
Apr 12 22:38:29 fan kernel: [  165.256043]  ? update_process_times+0x23/0x50
Apr 12 22:38:29 fan kernel: [  165.256047]  ? tick_sched_handle.isra.15+0x1b/0x50
Apr 12 22:38:29 fan kernel: [  165.256051]  ? tick_sched_timer+0x33/0x60
Apr 12 22:38:29 fan kernel: [  165.256055]  ? __hrtimer_run_queues+0xe7/0x260
Apr 12 22:38:29 fan kernel: [  165.256059]  ? hrtimer_interrupt+0xa1/0x1f0
Apr 12 22:38:29 fan kernel: [  165.256063]  ? smp_apic_timer_interrupt+0x2f/0x40
Apr 12 22:38:29 fan kernel: [  165.256070]  ? apic_timer_interrupt+0x82/0x90
Apr 12 22:38:29 fan kernel: [  165.256071]  </IRQ>
Apr 12 22:38:29 fan kernel: [  165.256077]  ? native_queued_spin_lock_slowpath+0x16b/0x190
Apr 12 22:38:29 fan kernel: [  165.256081]  ? _raw_spin_lock+0x18/0x20
Apr 12 22:38:29 fan kernel: [  165.256124]  ? find_free_extent.isra.67+0xa21/0x1110 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256154]  ? btrfs_reserve_extent+0xa6/0x210 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256183]  ? btrfs_alloc_tree_block+0x109/0x4b0 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256209]  ? __btrfs_cow_block+0x144/0x570 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256235]  ? btrfs_cow_block+0xf9/0x1a0 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256261]  ? btrfs_search_slot+0x1fa/0xa00 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256266]  ? cache_grow_end+0x119/0x140
Apr 12 22:38:29 fan kernel: [  165.256299]  ? btrfs_truncate_inode_items+0x188/0xe30 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256333]  ? btrfs_evict_inode+0x478/0x590 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256338]  ? evict+0xb9/0x1c0
Apr 12 22:38:29 fan kernel: [  165.256370]  ? btrfs_orphan_cleanup+0x1d7/0x410 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256403]  ? btrfs_recover_relocation+0x377/0x430 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256434]  ? btrfs_cleanup_fs_roots+0x133/0x150 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256466]  ? open_ctree+0x1fa1/0x2430 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256491]  ? btrfs_mount+0xd13/0xe50 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256495]  ? pcpu_alloc_area+0x20b/0x3e0
Apr 12 22:38:29 fan kernel: [  165.256499]  ? pcpu_next_unpop+0x36/0x50
Apr 12 22:38:29 fan kernel: [  165.256502]  ? pcpu_alloc+0x3ce/0x660
Apr 12 22:38:29 fan kernel: [  165.256507]  ? mount_fs+0x31/0x150
Apr 12 22:38:29 fan kernel: [  165.256511]  ? vfs_kern_mount+0x5d/0x120
Apr 12 22:38:29 fan kernel: [  165.256537]  ? btrfs_mount+0x17e/0xe50 [btrfs]
Apr 12 22:38:29 fan kernel: [  165.256540]  ? pcpu_alloc_area+0x20b/0x3e0
Apr 12 22:38:29 fan kernel: [  165.256543]  ? pcpu_alloc+0x3ce/0x660
Apr 12 22:38:29 fan kernel: [  165.256548]  ? mount_fs+0x31/0x150
Apr 12 22:38:29 fan kernel: [  165.256551]  ? vfs_kern_mount+0x5d/0x120
Apr 12 22:38:29 fan kernel: [  165.256555]  ? do_mount+0x1a2/0xc30
Apr 12 22:38:29 fan kernel: [  165.256560]  ? _copy_from_user+0x44/0x70
Apr 12 22:38:29 fan kernel: [  165.256564]  ? SyS_mount+0x79/0xd0
Apr 12 22:38:29 fan kernel: [  165.256569]  ? entry_SYSCALL_64_fastpath+0x1a/0xa9

followed by a row of

Apr 12 22:38:56 fan kernel: [  192.656441] NMI watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [mount:4874]
Apr 12 22:38:56 fan kernel: [  192.670868] Modules linked in: loop ebtable_filter ebtables ip6table_filter ip6_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave bridge stp llc iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack amd64_edac_mod edac_mce_amd edac_core snd_hda_codec_realtek snd_hda_codec_generic kvm_amd ipt_REJECT nf_reject_ipv4 snd_hda_codec_hdmi kvm snd_hda_intel xt_tcpudp snd_cmipci snd_hda_codec snd_mpu401_uart snd_hda_core snd_opl3_lib snd_rawmidi snd_hwdep irqbypass input_leds snd_seq_device pcspkr k10temp snd_pcm_oss snd_mixer_oss sg iptable_filter snd_pcm snd_timer snd soundcore asus_atk0110 shpchp acpi_cpufreq evdev tpm_tis tpm_tis_core tpm ip_tables x_tables autofs4 btrfs ext4 crc16 jbd2 fscrypto mbcache ecb crypto_simd glue_helper cryptd aes_x86_64 xts gf128mul algif_skcipher
Apr 12 22:38:56 fan kernel: [  192.813641]  af_alg dm_crypt raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod hid_generic usbhid hid usb_storage dm_mod sr_mod cdrom sd_mod ohci_pci amdkfd radeon r8169 mii ahci libahci i2c_algo_bit ttm sym53c8xx xhci_pci drm_kms_helper ohci_hcd ehci_pci scsi_transport_spi libata xhci_hcd i2c_piix4 ehci_hcd drm usbcore scsi_mod usb_common i2c_core button
Apr 12 22:38:56 fan kernel: [  192.893475] CPU: 4 PID: 4874 Comm: mount Tainted: G      D         4.10.10-zgws1 #2
Apr 12 22:38:56 fan kernel: [  192.893477] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Apr 12 22:38:56 fan kernel: [  192.893480] task: ffff8803fbbdd200 task.stack: ffffc900047d4000
Apr 12 22:38:56 fan kernel: [  192.893487] RIP: 0010:native_queued_spin_lock_slowpath+0x169/0x190
Apr 12 22:38:56 fan kernel: [  192.893498] RSP: 0018:ffffc900047d7550 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff10
Apr 12 22:38:56 fan kernel: [  192.893502] RAX: 0000000000000101 RBX: ffff8803fbae9400 RCX: 0000000000000001
Apr 12 22:38:56 fan kernel: [  192.893504] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff8803f24dbe00
Apr 12 22:38:56 fan kernel: [  192.893506] RBP: ffff8803f24dbe00 R08: 0000000000000101 R09: 0000000000000000
Apr 12 22:38:56 fan kernel: [  192.893509] R10: 000000196463d000 R11: ffffffff81649b40 R12: 000000196463d000
Apr 12 22:38:56 fan kernel: [  192.893511] R13: ffff8803db120000 R14: ffff8803f24dbe00 R15: ffff8803db120b98
Apr 12 22:38:56 fan kernel: [  192.893514] FS:  00007f41b7aeb480(0000) GS:ffff88042fd00000(0000) knlGS:0000000000000000
Apr 12 22:38:56 fan kernel: [  192.893517] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 12 22:38:56 fan kernel: [  192.893519] CR2: 000055c2409df550 CR3: 000000041b16f000 CR4: 00000000000006e0
Apr 12 22:38:56 fan kernel: [  192.893521] Call Trace:
Apr 12 22:38:56 fan kernel: [  192.893527]  ? _raw_spin_lock+0x18/0x20
Apr 12 22:38:56 fan kernel: [  192.893559]  ? find_free_extent.isra.67+0xa21/0x1110 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893589]  ? btrfs_reserve_extent+0xa6/0x210 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893618]  ? btrfs_alloc_tree_block+0x109/0x4b0 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893645]  ? __btrfs_cow_block+0x144/0x570 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893671]  ? btrfs_cow_block+0xf9/0x1a0 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893697]  ? btrfs_search_slot+0x1fa/0xa00 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893701]  ? cache_grow_end+0x119/0x140
Apr 12 22:38:56 fan kernel: [  192.893734]  ? btrfs_truncate_inode_items+0x188/0xe30 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893767]  ? btrfs_evict_inode+0x478/0x590 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893772]  ? evict+0xb9/0x1c0
Apr 12 22:38:56 fan kernel: [  192.893805]  ? btrfs_orphan_cleanup+0x1d7/0x410 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893837]  ? btrfs_recover_relocation+0x377/0x430 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893869]  ? btrfs_cleanup_fs_roots+0x133/0x150 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893900]  ? open_ctree+0x1fa1/0x2430 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893926]  ? btrfs_mount+0xd13/0xe50 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893930]  ? pcpu_alloc_area+0x20b/0x3e0
Apr 12 22:38:56 fan kernel: [  192.893933]  ? pcpu_next_unpop+0x36/0x50
Apr 12 22:38:56 fan kernel: [  192.893936]  ? pcpu_alloc+0x3ce/0x660
Apr 12 22:38:56 fan kernel: [  192.893941]  ? mount_fs+0x31/0x150
Apr 12 22:38:56 fan kernel: [  192.893945]  ? vfs_kern_mount+0x5d/0x120
Apr 12 22:38:56 fan kernel: [  192.893970]  ? btrfs_mount+0x17e/0xe50 [btrfs]
Apr 12 22:38:56 fan kernel: [  192.893973]  ? pcpu_alloc_area+0x20b/0x3e0
Apr 12 22:38:56 fan kernel: [  192.893977]  ? pcpu_alloc+0x3ce/0x660
Apr 12 22:38:56 fan kernel: [  192.893982]  ? mount_fs+0x31/0x150
Apr 12 22:38:56 fan kernel: [  192.893985]  ? vfs_kern_mount+0x5d/0x120
Apr 12 22:38:56 fan kernel: [  192.893988]  ? do_mount+0x1a2/0xc30
Apr 12 22:38:56 fan kernel: [  192.893993]  ? _copy_from_user+0x44/0x70
Apr 12 22:38:56 fan kernel: [  192.893997]  ? SyS_mount+0x79/0xd0
Apr 12 22:38:56 fan kernel: [  192.894002]  ? entry_SYSCALL_64_fastpath+0x1a/0xa9
Apr 12 22:38:56 fan kernel: [  192.894003] Code: c2 89 d0 66 31 c0 41 39 c0 74 e6 4d 85 c9 c6 07 01 74 2d 41 c7 41 08 01 00 00 00 e9 53 ff ff ff 83 fa 01 74 17 8b 07 84 c0 74 08 <f3> 90 8b 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 c3 f3 c3 f3 90 

This repeats a number of times and then the system becomes unresponsive
and is ripe for reboot. This behavior is reproducible.

Does this help?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
