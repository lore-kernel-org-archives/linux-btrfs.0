Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42340 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdKVTWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 14:22:22 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC098AAC5
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 19:22:20 +0000 (UTC)
Date: Wed, 22 Nov 2017 20:20:25 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH] btrfs: switch uuid tree semaphore to mutex
Message-ID: <20171122192025.GS3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106182402.11500-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106182402.11500-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 07:24:02PM +0100, David Sterba wrote:
> The uuid_tree_rescan_sem is used as a mutex (initialized with value 1
> and with at most one active user), no reason to obscure that as a
> semaphore.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

[  136.287143] ------------[ cut here ]------------
[  136.291962] DEBUG_LOCKS_WARN_ON(depth <= 0)
[  136.292033] WARNING: CPU: 0 PID: 1762 at kernel/locking/lockdep.c:3766 lock_release+0x253/0x3a0
[  136.305245] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc fscache af_packet br_netfilter bridge stp llc iscsi_ibft iscsi_boot_sysfs btrfs xor zstd_decompress zstd_c
ompress xxhash zlib_deflate i2c_algo_bit raid6_pq drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops dm_mod ttm dax drm tg3 kvm_amd ptp pps_core tpm_infineon libphy kvm mptctl shpchp tpm_tis tpm_tis_c
ore i2c_piix4 tpm acpi_cpufreq irqbypass k10temp pcspkr button ext4 mbcache jbd2 sr_mod cdrom ohci_pci ehci_pci ohci_hcd ehci_hcd mptsas scsi_transport_sas mptscsih serio_raw ata_generic mptbase sata_svw usbcor
e pata_serverworks sg scsi_dh_rdac scsi_dh_emc scsi_dh_alua
[  136.366011] CPU: 0 PID: 1762 Comm: btrfs-uuid Not tainted 4.14.0-1.ge195904-vanilla+ #91
[  136.374300] Hardware name: empty empty/S3993, BIOS PAQEX0-3 02/24/2008
[  136.380954] task: ffff895de4e45140 task.stack: ffffabc901ea8000
[  136.387005] RIP: 0010:lock_release+0x253/0x3a0
[  136.391574] RSP: 0018:ffffabc901eabc80 EFLAGS: 00010082
[  136.396932] RAX: 000000000000001f RBX: ffff895de4e45140 RCX: ffff895de4e45140
[  136.404189] RDX: ffff895de4e45140 RSI: 0000000000000001 RDI: ffffffff8b0edca0
[  136.411473] RBP: ffff895dd4723470 R08: 0000000000000000 R09: 0000000000000000
[  136.418725] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000282
[  136.425987] R13: ffffffffc103b852 R14: 0000000000000000 R15: 0000000000000000
[  136.433259] FS:  0000000000000000(0000) GS:ffff895defc00000(0000) knlGS:0000000000000000
[  136.441543] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  136.447408] CR2: 00007f0f708bf000 CR3: 000000022290f000 CR4: 00000000000006f0
[  136.454682] Call Trace:
[  136.457320]  ? btrfs_search_forward+0x168/0x320 [btrfs]
[  136.462682]  __mutex_unlock_slowpath+0x3b/0x260
[  136.467368]  btrfs_uuid_scan_kthread+0x242/0x350 [btrfs]
[  136.472849]  kthread+0x13e/0x170
[  136.476241]  ? get_chunk_map+0xc0/0xc0 [btrfs]
[  136.480821]  ? kthread_stop+0x300/0x300
[  136.484786]  ret_from_fork+0x24/0x30
[  136.507678] ---[ end trace cd10910755287819 ]---

this apparently relies on the semantics of a semaphore where up and down do not
pair the same way as is required for a mutex. I'm going to drop this
patch and eventually replace it with a clearer waiting logic.
