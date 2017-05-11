Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36664 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756338AbdEKTxB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 15:53:01 -0400
Received: by mail-qk0-f170.google.com with SMTP id u75so31681359qka.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 12:53:01 -0700 (PDT)
Message-ID: <1494532377.2771.3.camel@redhat.com>
Subject: Re: btrfs list corruption and soft lockups while testing writeback
 error handling
From: Jeff Layton <jlayton@redhat.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Liu Bo <bo.li.liu@oracle.com>
Date: Thu, 11 May 2017 15:52:57 -0400
In-Reply-To: <1494501232.2625.3.camel@redhat.com>
References: <1494501232.2625.3.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2017-05-11 at 07:13 -0400, Jeff Layton wrote:
> I finally got my writeback error handling test to work on btrfs (thanks,
> Chris!), by making the filesystem stripe the data and mirror the
> metadata across two devices. The test passes now, but on one run, I got
> the following list corruption warning and then a soft lockup (which is
> probably fallout from the list corruption).
> 
> I ran the test several times before and since then without this failure,
> so I don't have a clear reproducer. The kernel in this instance is
> basically a v4.11 kernel with my pile of writeback error handling
> patches on top:
> 
>     https://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/wberr
> 
> It may be that they are a contributing factor, but this smells more like
> a bug down in btrfs. Let me know if you need other info:
> 
> ------------------------------8<-----------------------------------
> 
> [  438.341942] run fstests generic/999 at 2017-05-11 07:03:39
> [  439.453293] BTRFS: device fsid 08e9b22b-44a1-4954-a1b0-03c7c0537831 devid 1 transid 3 /dev/vda8
> [  439.465918] BTRFS: device fsid 08e9b22b-44a1-4954-a1b0-03c7c0537831 devid 2 transid 3 /dev/vda7
> [  439.603578] device-mapper: ioctl: device doesn't appear to be in the dev hash table.
> [  439.762422] BTRFS info (device dm-4): disk space caching is enabled
> [  439.763808] BTRFS info (device dm-4): has skinny extents
> [  439.764979] BTRFS info (device dm-4): flagging fs with big metadata feature
> [  439.785879] BTRFS info (device dm-4): creating UUID tree
> [  439.974266] BTRFS info (device dm-4): disk space caching is enabled
> [  439.975783] BTRFS info (device dm-4): has skinny extents
> [  440.229263] Buffer I/O error on dev dm-4, logical block 2621424, async page read
> [  440.239970] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> [  440.242459] ------------[ cut here ]------------
> [  440.243276] WARNING: CPU: 0 PID: 5162 at lib/list_debug.c:28 __list_add_valid+0x69/0xa0
> [  440.244338] list_add corruption. prev->next should be next (ffff8dd531056b08), but was ffffa93242807e90. (prev=ffffa93242807e90).
> [  440.245939] Modules linked in: btrfs xor raid6_pq binfmt_misc ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_broute bridge stp llc ebtable_nat ip6table_mangle ip6table_security ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw iptable_mangle iptable_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core crct10dif_pclmul crc32_pclmul nfsd ghash_clmulni_intel ppdev snd_hwdep snd_pcm acpi_cpufreq snd_timer tpm_tis snd parport_pc tpm_tis_core parport pcspkr tpm i2c_piix4 auth_rpcgss soundcore floppy joydev qemu_fw_cfg virtio_balloon nfs_acl lockd grace sunrpc xfs libcrc32c qxl drm_kms_helper virtio_net
> [  440.254739]  virtio_blk virtio_console virtio_rng ttm drm crc32c_intel virtio_pci virtio_ring ata_generic virtio serio_raw pata_acpi
> [  440.256352] CPU: 0 PID: 5162 Comm: fsync-err Not tainted 4.11.0+ #52
> [  440.257534] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
> [  440.258584] Call Trace:
> [  440.259096]  dump_stack+0x63/0x86
> [  440.259618]  __warn+0xcb/0xf0
> [  440.260116]  warn_slowpath_fmt+0x5a/0x80
> [  440.260798]  ? check_parent_dirs_for_sync+0x109/0x140 [btrfs]
> [  440.261755]  __list_add_valid+0x69/0xa0
> [  440.262442]  btrfs_log_inode_parent+0x25c/0x9f0 [btrfs]
> [  440.263323]  ? btrfs_releasepage+0x20/0x20 [btrfs]
> [  440.264059]  ? wait_current_trans+0x2e/0xf0 [btrfs]
> [  440.264792]  ? kmem_cache_alloc+0x195/0x1b0
> [  440.265455]  ? join_transaction+0x27/0x420 [btrfs]
> [  440.266175]  btrfs_log_dentry_safe+0x60/0x80 [btrfs]
> [  440.266965]  btrfs_sync_file+0x2b7/0x400 [btrfs]
> [  440.267655]  vfs_fsync_range+0x49/0xb0
> [  440.268266]  do_fsync+0x3d/0x70
> [  440.268806]  SyS_fsync+0x10/0x20
> [  440.269347]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> [  440.270033] RIP: 0033:0x7f7983af1b70
> [  440.270607] RSP: 002b:00007ffe13b3aa18 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
> [  440.271661] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f7983af1b70
> [  440.272623] RDX: 0000000000010401 RSI: 00000000023ef030 RDI: 0000000000000004
> [  440.273696] RBP: 00007ffe13b3cc77 R08: 0000000000000000 R09: 00007f79845364c8
> [  440.274808] R10: 0000000000000008 R11: 0000000000000246 R12: 00000000023ef030
> [  440.275873] R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
> [  440.276995] ---[ end trace 878ee9789ed2d63b ]---
> [  440.278476] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
> [  440.282362] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
> [  440.300180] BTRFS warning (device dm-4): lost page write due to IO error on /dev/mapper/error-test
> [  440.301502] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
> [  467.922777] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [fsync-err:5162]
> [  467.923930] Modules linked in: btrfs xor raid6_pq binfmt_misc ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_broute bridge stp llc ebtable_nat ip6table_mangle ip6table_security ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw iptable_mangle iptable_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core crct10dif_pclmul crc32_pclmul nfsd ghash_clmulni_intel ppdev snd_hwdep snd_pcm acpi_cpufreq snd_timer tpm_tis snd parport_pc tpm_tis_core parport pcspkr tpm i2c_piix4 auth_rpcgss soundcore floppy joydev qemu_fw_cfg virtio_balloon nfs_acl lockd grace sunrpc xfs libcrc32c qxl drm_kms_helper virtio_net
> [  467.932783]  virtio_blk virtio_console virtio_rng ttm drm crc32c_intel virtio_pci virtio_ring ata_generic virtio serio_raw pata_acpi
> [  467.934561] CPU: 0 PID: 5162 Comm: fsync-err Tainted: G        W       4.11.0+ #52
> [  467.935662] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
> [  467.936838] task: ffff8dd524511d40 task.stack: ffffa93242804000
> [  467.937724] RIP: 0010:__list_del_entry_valid+0x40/0xc0
> [  467.938518] RSP: 0018:ffffa93242807d28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
> [  467.939540] RAX: 0000000000000001 RBX: ffffa93242807e78 RCX: ffffa93242807e90
> [  467.940510] RDX: dead000000000200 RSI: ffffa93242807e90 RDI: ffffa93242807e90
> [  467.941487] RBP: ffffa93242807e20 R08: ffffa93242807e90 R09: 0000000000000000
> [  467.942457] R10: ffffa93242807c40 R11: 00000000000001b5 R12: 0000000000000000
> [  467.943424] R13: ffffa93242807e78 R14: ffff8dd531056b08 R15: ffffa93242807e90
> [  467.944391] FS:  00007f7984520800(0000) GS:ffff8dd53fc00000(0000) knlGS:0000000000000000
> [  467.945458] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  467.946271] CR2: 000055d401203460 CR3: 000000007134f000 CR4: 00000000000406f0
> [  467.947232] Call Trace:
> [  467.947738]  ? btrfs_sync_log+0x434/0xc00 [btrfs]
> [  467.948482]  btrfs_sync_file+0x3b8/0x400 [btrfs]
> [  467.949216]  ? btrfs_sync_file+0x3b8/0x400 [btrfs]
> [  467.949941]  vfs_fsync_range+0x49/0xb0
> [  467.950496]  do_fsync+0x3d/0x70
> [  467.950992]  SyS_fsync+0x10/0x20
> [  467.951496]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> [  467.952121] RIP: 0033:0x7f7983af1b70
> [  467.952657] RSP: 002b:00007ffe13b3aa18 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
> [  467.953610] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f7983af1b70
> [  467.954592] RDX: 0000000000010401 RSI: 00000000023ef030 RDI: 0000000000000004
> [  467.955586] RBP: 00007ffe13b3cc77 R08: 0000000000000000 R09: 00007f79845364c8
> [  467.956640] R10: 0000000000000008 R11: 0000000000000246 R12: 00000000023ef030
> [  467.957649] R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
> [  467.958639] Code: 48 39 d0 74 27 48 ba 00 02 00 00 00 00 ad de 49 39 d0 74 3a 4d 8b 00 4c 39 c7 75 51 4c 8b 40 08 4c 39 c7 75 67 b8 01 00 00 00 5d <c3> 49 89 c0 48 89 f9 48 c7 c2 c8 ca c8 81 be 2f 00 00 00 48 c7 
> [  470.383161] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
> [  470.384834] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
> [  470.386505] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
> [  470.388133] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
> [  470.392267] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
> [  470.393876] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
> [  470.397574] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 11, rd 0, flush 0, corrupt 0, gen 0
> [  470.399134] BTRFS error (device dm-4): bdev /dev/mapper/error-test errs: wr 12, rd 0, flush 0, corrupt 0, gen 0
> 
> 

(cc'ing Liu Bo since we were discussing this earlier this week)

I can't reproduce this on stock v4.11, so I think this is a bug in my
series.

I think this is due to the differences in how errors are being reported
from filemap_fdatawait_range now causing some transactions to end up
being freed while they're still on the log_ctxs list. I'm working on
hunting down the problem now.

Sorry for the noise!
-- 
Jeff Layton <jlayton@redhat.com>
