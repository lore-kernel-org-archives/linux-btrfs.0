Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33682 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbaFAIkl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Jun 2014 04:40:41 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 6CFFE440C25
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Jun 2014 10:40:38 +0200 (CEST)
Received: from s9 (34.Red-81-37-120.dynamicIP.rima-tde.net [81.37.120.34])
	by mailext.virtall.com (Postfix) with ESMTPSA id 20F1F440C21
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Jun 2014 10:40:38 +0200 (CEST)
Date: Sun, 1 Jun 2014 09:40:35 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: checksum failed followed by general protection fault and filesystem
 hang
Message-ID: <20140601094035.24021d72@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this with 3.14.4 - is it expected?

There was a balance running on this servers just a few hours ago (added device to fs and converted to RAID-1), which finished successfully.

Full trace at http://www.virtall.com/files/temp/btrfs.txt.

May 31 04:10:13 backup01 kernel: [1487611.493240] BTRFS info (device sdb4): csum failed ino 218676 extent 1145694257152 csum 853219236 wanted 3711160978 mirror 0
May 31 04:10:13 backup01 kernel: [1487611.493389] general protection fault: 0000 [#1] SMP
May 31 04:10:13 backup01 kernel: [1487611.493455] Modules linked in: vhost_net vhost macvtap macvlan tun ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables cpufreq_conservative cpufreq_powersave cpufreq_ondemand cpufreq_stats bridge stp llc ipv6 btrfs zlib_deflate ext3 jbd loop kvm_intel kvm ehci_pci i2c_i801 ehci_hcd i2c_core parport_pc parport pcspkr video lpc_ich button acpi_cpufreq mfd_core tpm_infineon tpm_tis tpm ext4 crc16 jbd2 mbcache aacraid 3w_9xxx 3w_xxxx raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 sata_nv sata_sil sata_via sg sd_mod ahci libahci libata scsi_mod r8169 mii
May 31 04:10:13 backup01 kernel: [1487611.494127] CPU: 1 PID: 3488 Comm: btrfs-endio-4 Not tainted 3.14.4 #1
May 31 04:10:13 backup01 kernel: [1487611.494194] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
May 31 04:10:13 backup01 kernel: [1487611.494324] task: ffff8802e074c800 ti: ffff8802aa1a8000 task.ti: ffff8802aa1a8000
May 31 04:10:13 backup01 kernel: [1487611.494450] RIP: 0010:[<ffffffff811b9e74>]  [<ffffffff811b9e74>] __crc32c_le+0x49/0xfd
May 31 04:10:13 backup01 kernel: [1487611.494586] RSP: 0018:ffff8802aa1a9c50  EFLAGS: 00010287
May 31 04:10:13 backup01 kernel: [1487611.494650] RAX: 00000000ffffffff RBX: ffff8802aa1a9ce8 RCX: 0000000000000000
May 31 04:10:13 backup01 kernel: [1487611.494771] RDX: 0000000000001000 RSI: ffe70a04e2bd9000 RDI: 0000000000000000
May 31 04:10:13 backup01 kernel: [1487611.494892] RBP: ffff8802aa1a9c58 R08: ffe70a04e2bd8ffc R09: 0000000000000200
May 31 04:10:13 backup01 kernel: [1487611.495013] R10: dead000000200200 R11: ffff88060c4d6ba8 R12: 0000000000001000
May 31 04:10:13 backup01 kernel: [1487611.495138] R13: 0000000000000000 R14: ffffffff816464f0 R15: ffff8802aa1a9ce8
May 31 04:10:13 backup01 kernel: [1487611.495261] FS:  0000000000000000(0000) GS:ffff88083fa40000(0000) knlGS:0000000000000000
May 31 04:10:13 backup01 kernel: [1487611.495383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May 31 04:10:13 backup01 kernel: [1487611.495449] CR2: 00007ffff90a3f78 CR3: 000000000160b000 CR4: 00000000000427e0
May 31 04:10:13 backup01 kernel: [1487611.495574] Stack:
May 31 04:10:13 backup01 kernel: [1487611.495632]  ffff8802aa1a9ce8 ffff8802aa1a9c78 ffffffff8118e1e6 0000000000000003
May 31 04:10:13 backup01 kernel: [1487611.495762]  1ffff1005543539d ffff8802aa1a9cd8 ffffffff8118b0f9 ffff88081f04ce00
May 31 04:10:13 backup01 kernel: [1487611.495887]  0000000000000001 ffff8803afeb5c48 ffff8807c59b7a10 ffff8802aa1a9cc8
May 31 04:10:13 backup01 kernel: [1487611.496016] Call Trace:
May 31 04:10:13 backup01 kernel: [1487611.496081]  [<ffffffff8118e1e6>] chksum_update+0x13/0x1c
May 31 04:10:13 backup01 kernel: [1487611.496148]  [<ffffffff8118b0f9>] crypto_shash_update+0xc2/0xd5
May 31 04:10:13 backup01 kernel: [1487611.496234]  [<ffffffffa0421979>] btrfs_crc32c+0x57/0x6a [btrfs]
May 31 04:10:13 backup01 kernel: [1487611.496313]  [<ffffffffa03c191a>] btrfs_csum_data+0x11/0x13 [btrfs]
May 31 04:10:13 backup01 kernel: [1487611.496399]  [<ffffffffa04001c1>] end_compressed_bio_read+0x77/0x219 [btrfs]
May 31 04:10:13 backup01 kernel: [1487611.496522]  [<ffffffff81120c31>] bio_endio+0x52/0x72
May 31 04:10:13 backup01 kernel: [1487611.496588]  [<ffffffff81120c5e>] bio_endio_nodec+0xd/0xf
May 31 04:10:13 backup01 kernel: [1487611.496666]  [<ffffffffa03c11a0>] end_workqueue_fn+0x33/0x38 [btrfs]
May 31 04:10:13 backup01 kernel: [1487611.496747]  [<ffffffffa03ed671>] worker_loop+0x15e/0x495 [btrfs]
May 31 04:10:13 backup01 kernel: [1487611.496826]  [<ffffffffa03ed513>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
May 31 04:10:13 backup01 kernel: [1487611.496898]  [<ffffffff81050d3e>] kthread+0xcd/0xd5
May 31 04:10:13 backup01 kernel: [1487611.496971]  [<ffffffff81050c71>] ? kthread_freezable_should_stop+0x43/0x43
May 31 04:10:13 backup01 kernel: [1487611.497042]  [<ffffffff8139a4fc>] ret_from_fork+0x7c/0xb0
May 31 04:10:13 backup01 kernel: [1487611.497109]  [<ffffffff81050c71>] ? kthread_freezable_should_stop+0x43/0x43
May 31 04:10:13 backup01 kernel: [1487611.497183] Code: c9 33 04 8d 80 65 60 81 48 ff ca 74 06 40 f6 c6 03 eb df 48 89 d7 49 89 d1 4c 8d 46 fc 83 e7 07 49 c1 e9 03 31 c9 e9 82 00 00 00 <8b> 14 ce 44 8b 5c ce 04 48 ff c1 31 c2 4c 89 db 0f b6 c2 41 89
May 31 04:10:13 backup01 kernel: [1487611.497446] RIP  [<ffffffff811b9e74>] __crc32c_le+0x49/0xfd
May 31 04:10:13 backup01 kernel: [1487611.497513]  RSP <ffff8802aa1a9c50>
May 31 04:10:13 backup01 kernel: [1487611.497929] ---[ end trace b3b58e5cee91bc55 ]---

-- 
Tomasz Chmielewski
http://www.sslrack.com
