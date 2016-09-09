Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from washoe.dartmouth.edu ([129.170.30.229]:32964 "EHLO
        smtp.onerussian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbcIIMNL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 08:13:11 -0400
Received: from smtp.onerussian.com ([192.168.100.6] helo=washoe.onerussian.com)
        by smtp.onerussian.com with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80)
        (envelope-from <yoh@onerussian.com>)
        id 1biKg8-0001oB-J0
        for linux-btrfs@vger.kernel.org; Fri, 09 Sep 2016 08:13:08 -0400
Received: from yoh by washoe.onerussian.com with local (Exim 4.84)
        (envelope-from <yoh@onerussian.com>)
        id 1biKg8-0001o6-Co
        for linux-btrfs@vger.kernel.org; Fri, 09 Sep 2016 08:13:08 -0400
Date: Fri, 9 Sep 2016 08:13:08 -0400
From: Yaroslav Halchenko <yoh@onerussian.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: recent complete stalls of btrfs (4.7.0-rc2+) -- any advice?
Message-ID: <20160909121308.GA3204@onerussian.com>
References: <20160610234114.GB11174@onerussian.com>
 <CAJCQCtS1UTBx1-GELqUTbrdcxmncN3bv7X3OjGGrjvzom28m+w@mail.gmail.com>
 <20160612151531.GA28826@hopa.kiewit.dartmouth.edu>
 <20160809221951.GA26923@onerussian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160809221951.GA26923@onerussian.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Tue, 09 Aug 2016, Yaroslav Halchenko wrote:

> The beast has died on me today's morning :-/  Last kern.log msg was

>     (Fixing recursive fault but reboot is needed!)

locked down again but this time seems to be different stack (and no above
msg) from before:

(full list of oopses since boot at
http://www.onerussian.com/tmp/journal-20160909-oopses.log
)

Sep 09 02:18:33 smaug kernel: ------------[ cut here ]------------
Sep 09 02:18:33 smaug kernel: WARNING: CPU: 4 PID: 2189174 at lib/list_debug.c:33 __list_add+0x86/0xb0
Sep 09 02:18:33 smaug kernel: list_add corruption. prev->next should be next (ffff8820079d6308), but was ffff88181e7e0d28. (prev=ffff8810b209fe10).
Sep 09 02:18:33 smaug kernel: Modules linked in: veth xt_addrtype ipt_MASQUERADE nf_nat_masquerade_ipv4 bridge stp llc pci_stub cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave xt_pkttype nf_log_ipv4 nf_log_common xt_tcpudp ip6table_mangle nfsd auth_rpcgss oid_registry nfs_acl iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_TCPMSS xt_LOG ipt_REJECT nf_reject_ipv4 iptable_mangle xt_multiport xt_state xt_limit xt_conntrack nf_conntrack_ftp nfs lockd grace nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables fscache sunrpc binfmt_misc ipmi_watchdog intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_poweroff ipmi_devintf kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iTCO_wdt iTCO_vendor_support drbg
Sep 09 02:18:33 smaug kernel:  ansi_cprng snd_pcm snd_timer aesni_intel snd aes_x86_64 soundcore lrw fuse gf128mul glue_helper ablk_helper cryptd pcspkr ast ttm drm_kms_helper joydev drm mei_me evdev i2c_algo_bit i2c_i801 mei shpchp lpc_ich ioatdma mfd_core ipmi_si wmi ipmi_msghandler tpm_tis tpm acpi_pad acpi_power_meter button ecryptfs cbc sha256_ssse3 sha256_generic hmac encrypted_keys autofs4 ext4 crc16 jbd2 mbcache btrfs dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 md_mod sg ses enclosure sd_mod hid_generic usbhid hid crc32c_intel ahci libahci mpt3sas raid_class scsi_transport_sas ehci_pci xhci_pci xhci_hcd ehci_hcd libata ixgbe dca usbcore usb_common scsi_mod ptp pps_core mdio fjes [last unloaded: vboxdrv]
Sep 09 02:18:33 smaug kernel: CPU: 4 PID: 2189174 Comm: git-annex Tainted: G        W IO    4.7.0-rc2+ #1
Sep 09 02:18:33 smaug kernel: Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 1.0b 09/17/2014
Sep 09 02:18:33 smaug kernel:  0000000000000286 000000000ab947c2 ffffffff8130c605 ffff881292cfbd28
Sep 09 02:18:33 smaug kernel:  0000000000000000 ffffffff8107a314 ffff881292cfbe10 ffff881292cfbd80
Sep 09 02:18:33 smaug kernel:  ffff8810b209fe10 ffff881037a07a98 ffff881f24b1a800 ffff881037a07800
Sep 09 02:18:33 smaug kernel: Call Trace:
Sep 09 02:18:33 smaug kernel:  [<ffffffff8130c605>] ? dump_stack+0x5c/0x77
Sep 09 02:18:33 smaug kernel:  [<ffffffff8107a314>] ? __warn+0xc4/0xe0
Sep 09 02:18:33 smaug kernel:  [<ffffffff8107a38f>] ? warn_slowpath_fmt+0x5f/0x80
Sep 09 02:18:33 smaug kernel:  [<ffffffffa0407495>] ? btrfs_write_marked_extents+0x95/0x130 [btrfs]
Sep 09 02:18:33 smaug kernel:  [<ffffffff81329f86>] ? __list_add+0x86/0xb0
Sep 09 02:18:33 smaug kernel:  [<ffffffffa044c459>] ? btrfs_sync_log+0x249/0xa80 [btrfs]
Sep 09 02:18:33 smaug kernel:  [<ffffffffa04211ba>] ? btrfs_sync_file+0x39a/0x3e0 [btrfs]
Sep 09 02:18:33 smaug kernel:  [<ffffffff81225318>] ? do_fsync+0x38/0x60
Sep 09 02:18:33 smaug kernel:  [<ffffffff8122559f>] ? SyS_fdatasync+0xf/0x20
Sep 09 02:18:33 smaug kernel:  [<ffffffff815c81f6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
Sep 09 02:18:33 smaug kernel: ---[ end trace 125800d45db3ce41 ]---
Sep 09 02:18:34 smaug kernel: general protection fault: 0000 [#1] SMP
Sep 09 02:18:34 smaug kernel: Modules linked in: veth xt_addrtype ipt_MASQUERADE nf_nat_masquerade_ipv4 bridge stp llc pci_stub cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave xt_pkttype nf_log_ipv4 nf_log_common xt_tcpudp ip6table_mangle nfsd auth_rpcgss oid_registry nfs_acl iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_TCPMSS xt_LOG ipt_REJECT nf_reject_ipv4 iptable_mangle xt_multiport xt_state xt_limit xt_conntrack nf_conntrack_ftp nfs lockd grace nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables fscache sunrpc binfmt_misc ipmi_watchdog intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_poweroff ipmi_devintf kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iTCO_wdt iTCO_vendor_support drbg
Sep 09 02:18:34 smaug kernel:  ansi_cprng snd_pcm snd_timer aesni_intel snd aes_x86_64 soundcore lrw fuse gf128mul glue_helper ablk_helper cryptd pcspkr ast ttm drm_kms_helper joydev drm mei_me evdev i2c_algo_bit i2c_i801 mei shpchp lpc_ich ioatdma mfd_core ipmi_si wmi ipmi_msghandler tpm_tis tpm acpi_pad acpi_power_meter button ecryptfs cbc sha256_ssse3 sha256_generic hmac encrypted_keys autofs4 ext4 crc16 jbd2 mbcache btrfs dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 md_mod sg ses enclosure sd_mod hid_generic usbhid hid crc32c_intel ahci libahci mpt3sas raid_class scsi_transport_sas ehci_pci xhci_pci xhci_hcd ehci_hcd libata ixgbe dca usbcore usb_common scsi_mod ptp pps_core mdio fjes [last unloaded: vboxdrv]
Sep 09 02:18:34 smaug kernel: CPU: 5 PID: 2189174 Comm: git-annex Tainted: G        W IO    4.7.0-rc2+ #1
Sep 09 02:18:34 smaug kernel: Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 1.0b 09/17/2014
Sep 09 02:18:34 smaug kernel: task: ffff8810eedb8000 ti: ffff881292cf8000 task.ti: ffff881292cf8000
Sep 09 02:18:34 smaug kernel: RIP: 0010:[<ffffffffa03dce1c>]  [<ffffffffa03dce1c>] btrfs_root_node+0xc/0x50 [btrfs]
Sep 09 02:18:34 smaug kernel: RSP: 0018:ffff881292cfbcd0  EFLAGS: 00010246
Sep 09 02:18:34 smaug kernel: RAX: 0000000000000008 RBX: ffff881033a07800 RCX: ae07f824b05dfc14
Sep 09 02:18:34 smaug kernel: RDX: ffff881292cfbd9f RSI: 0000000000000000 RDI: ffff881033a07800
Sep 09 02:18:34 smaug kernel: RBP: ffff881033a07800 R08: 00000000ffffffff R09: 00000000ffffffff
Sep 09 02:18:34 smaug kernel: R10: 0000000000000001 R11: 00000000ffffffff R12: 0000160000000000
Sep 09 02:18:34 smaug kernel: R13: ffff881033a07800 R14: ffff880000000000 R15: ffff8813031dc820
Sep 09 02:18:34 smaug kernel: FS:  00007efea04d2740(0000) GS:ffff88207fc40000(0000) knlGS:0000000000000000
Sep 09 02:18:34 smaug kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 09 02:18:34 smaug kernel: CR2: 00007f40b5389710 CR3: 0000001b4f38b000 CR4: 00000000001406e0
Sep 09 02:18:34 smaug kernel: Stack:
Sep 09 02:18:34 smaug kernel:  ffff8815e5ff6700 ffffffffa03dce84 ffff8815e5ff6700 0000000000000000
Sep 09 02:18:34 smaug kernel:  ffffffffa03e1f96 ffffffffa03dfe9c ffff881292cfbe1c ffff881292cfbd9f
Sep 09 02:18:34 smaug kernel:  ffff8813031dc820 0000000000000001 0000000200000002 1ffff1020100f7ac
Sep 09 02:18:34 smaug kernel: Call Trace:
Sep 09 02:18:34 smaug kernel:  [<ffffffffa03dce84>] ? btrfs_read_lock_root_node+0x24/0x40 [btrfs]
Sep 09 02:18:34 smaug kernel:  [<ffffffffa03e1f96>] ? btrfs_search_slot+0x726/0x9e0 [btrfs]
Sep 09 02:18:34 smaug kernel:  [<ffffffffa03dfe9c>] ? btrfs_leaf_free_space+0x4c/0xa0 [btrfs]
Sep 09 02:18:34 smaug kernel:  [<ffffffffa02801e6>] ? crc32c_pcl_intel_update+0x26/0x60 [crc32c_intel]
Sep 09 02:18:34 smaug kernel:  [<ffffffffa03fa979>] ? btrfs_lookup_dir_item+0x79/0xc0 [btrfs]
Sep 09 02:18:34 smaug kernel:  [<ffffffffa040f365>] ? __btrfs_unlink_inode+0xb5/0x4a0 [btrfs]
Sep 09 02:18:34 smaug kernel:  [<ffffffffa0413077>] ? btrfs_unlink_inode+0x17/0x40 [btrfs]
Sep 09 02:18:34 smaug kernel:  [<ffffffffa04136a2>] ? btrfs_rmdir+0xf2/0x140 [btrfs]
Sep 09 02:18:34 smaug kernel:  [<ffffffff811feccc>] ? vfs_rmdir+0xac/0x120
Sep 09 02:18:34 smaug kernel:  [<ffffffff812028c0>] ? do_rmdir+0x1e0/0x200
Sep 09 02:18:34 smaug kernel:  [<ffffffff815c81f6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
Sep 09 02:18:34 smaug kernel: Code: ff ff 48 89 de 48 8b 3d 93 bc 0c 00 5b e9 8d 81 df e0 f3 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 48 89 fb 48 8b 0b <8b> 71 24 85 f6 74 33 44 8d 46 01 48 8d 79 24 89 f0 f0 44 0f b1 
Sep 09 02:18:34 smaug kernel: RIP  [<ffffffffa03dce1c>] btrfs_root_node+0xc/0x50 [btrfs]
Sep 09 02:18:34 smaug kernel:  RSP <ffff881292cfbcd0>
Sep 09 02:18:34 smaug kernel: ---[ end trace 125800d45db3ce42 ]---

Anything hinting about the problem?

I guess I have to rebuild bleeding edge version and try again... heh heh

Please CC replies
-- 
Yaroslav O. Halchenko
Center for Open Neuroscience     http://centerforopenneuroscience.org
Dartmouth College, 419 Moore Hall, Hinman Box 6207, Hanover, NH 03755
Phone: +1 (603) 646-9834                       Fax: +1 (603) 646-1419
WWW:   http://www.linkedin.com/in/yarik        
