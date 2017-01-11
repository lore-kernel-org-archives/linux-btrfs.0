Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54294 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932954AbdAKNHO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 08:07:14 -0500
Date: Wed, 11 Jan 2017 14:07:08 +0100
From: Petr Janecek <janecek@ucw.cz>
To: linux-btrfs@vger.kernel.org
Subject: Re: BUG at mount time on v4.8.10 (and 4.9.2)
Message-ID: <20170111130708.GA7214@atrey.karlin.mff.cuni.cz>
References: <20170106043600.GB4502@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170106043600.GB4502@atrey.karlin.mff.cuni.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> > I just got a BUG on mount of a raid10 fs. /dev/sde was added to
> > the fs recently and balance has been started. After reboot (balance
> > still running), the fs can not be mounted any more.
> 
> 
> Try the skip_balance mount option (as described on the wiki or in the 
> btrfs (5) manpage).

  unfortunately, I get almost same trace with "-o skip_balance".
Same thing happens on 4.9.2. Mounting "ro,skip_balance" works, so I can
recover the data. But balance was supposed to be working, and running a
balance after adding a device to almost full fs is imho exactly what one
whould do.

[...]
> I'm just a user and list regular, not a dev, so dumps such as the below 
> don't mean much to me.  Often, about the only thing useful I can pick out 
> of them is the kernel version (which matches what you provided in the 
> subject, 4.8.10), but in this case, there's something additional...
> 
> > [ 1380.872569] BUG: unable to handle kernel paging request at
> > fffffffffffffd60
> > [ 1380.879592] IP: [<ffffffffc045cf6f>]
> > qgroup_fix_relocated_data_extents+0x1f/0x2a0 [btrfs]
> 
> qgroup?  You're using btrfs quotas?  

  No, I confirmed that after the successful readonly mount.
>From btrfs_recover_relocation(), qgroup_fix_relocated_data_extent() is
called unconditionally, except for some error conditions before.
Maybe that is the problem? Log from 4.9.2 is below.


Regards

Petr



[  135.044216] BUG: unable to handle kernel paging request at fffffffffffffd60
[  135.051531] IP: [<ffffffffc06ef0ef>] qgroup_fix_relocated_data_extents+0x1f/0x2b0 [btrfs]
[  135.059953] PGD 1d5809067 [  135.062597] PUD 1d580b067 
PMD 0 [  135.066153] 
[  135.067858] Oops: 0000 [#1] SMP
[  135.071109] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc xfs libcrc32c crc32c_generic x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass crc32_pclmul iTCO_wdt ghash_clmulni_intel iTCO_vendor_support aesni_intel aes_x86_64 ablk_helper cryptd lrw loop mei_me i2c_i801 gf128mul ipmi_watchdog glue_helper pcspkr i2c_smbus mei raid10 acpi_cpufreq tpm_tis ie31200_edac tpm_tis_core md_mod evdev tpm battery video shpchp acpi_power_meter edac_core button processor ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler autofs4 btrfs xor raid6_pq sg sd_mod hid_generic usbhid hid xhci_pci ahci igb xhci_hcd libahci i2c_algo_bit i2c_core mpt3sas dca raid_class usbcore libata scsi_transport_sas ptp crc32c_intel pps_core usb_common scsi_mod fan thermal
[  135.149994] CPU: 5 PID: 1180 Comm: mount Not tainted 4.9.2 #11
[  135.155932] Hardware name: Supermicro Super Server/X11SSL-CF, BIOS 1.0a 01/29/2016
[  135.163606] task: ffff97b615f271c0 task.stack: ffffb90f03db4000
[  135.169653] RIP: 0010:[<ffffffffc06ef0ef>]  [<ffffffffc06ef0ef>] qgroup_fix_relocated_data_extents+0x1f/0x2b0 [btrfs]
[  135.180548] RSP: 0018:ffffb90f03db7a00  EFLAGS: 00010246
[  135.185981] RAX: 0000000000000000 RBX: ffff97b6162be000 RCX: 0000000000007ce5
[  135.193239] RDX: ffff97b60c07aa90 RSI: ffff97b60703e000 RDI: ffff97b60c07aa00
[  135.200501] RBP: ffff97b60ae46000 R08: ffff97b6162be000 R09: ffff97b60c07aa00
[  135.207764] R10: 0000000000000000 R11: 0000000000000001 R12: ffffb90f03db7a98
[  135.215027] R13: ffff97b60c07aa00 R14: ffff97b60703e000 R15: 0000000000000000
[  135.222292] FS:  00007f748468d840(0000) GS:ffff97b637940000(0000) knlGS:0000000000000000
[  135.230525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  135.236399] CR2: fffffffffffffd60 CR3: 000000085651b000 CR4: 00000000003406e0
[  135.243654] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  135.250909] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  135.258171] Stack:
[  135.260304]  0000000000000000 ffff97b60c07aa00 0000000000000801 ffff97b60ae80000
[  135.268309]  ffff97b60c07aa00 0000000000000801 ffffffffc069ca08 ffff97b615f271c0
[  135.276317]  0000000000000000 0000000000000246 ffff97b614ca72a0 ffff97b60ae46000
[  135.284335] Call Trace:
[  135.286917]  [<ffffffffc069ca08>] ? start_transaction+0x98/0x4a0 [btrfs]
[  135.293762]  [<ffffffffc06f2cc3>] ? btrfs_recover_relocation+0x3b3/0x440 [btrfs]
[  135.301321]  [<ffffffffc06995aa>] ? open_ctree+0x214a/0x2600 [btrfs]
[  135.307817]  [<ffffffffc066d41b>] ? btrfs_mount+0xd0b/0xe40 [btrfs]
[  135.314215]  [<ffffffff8314c7d7>] ? pcpu_alloc_area+0x2a7/0x3d0
[  135.320265]  [<ffffffff834f373f>] ? __mutex_unlock_slowpath+0x9f/0x130
[  135.326921]  [<ffffffff8314d423>] ? pcpu_alloc+0x323/0x620
[  135.332535]  [<ffffffff83199fb1>] ? mount_fs+0x31/0x160
[  135.337884]  [<ffffffff83094047>] ? __init_waitqueue_head+0x17/0x30
[  135.344281]  [<ffffffff831b4c9d>] ? vfs_kern_mount+0x5d/0x110
[  135.350153]  [<ffffffffc066c8b4>] ? btrfs_mount+0x1a4/0xe40 [btrfs]
[  135.356545]  [<ffffffff8314d423>] ? pcpu_alloc+0x323/0x620
[  135.362151]  [<ffffffff83199fb1>] ? mount_fs+0x31/0x160
[  135.367499]  [<ffffffff83094047>] ? __init_waitqueue_head+0x17/0x30
[  135.373886]  [<ffffffff831b4c9d>] ? vfs_kern_mount+0x5d/0x110
[  135.379755]  [<ffffffff831b7814>] ? do_mount+0x1b4/0xc30
[  135.385190]  [<ffffffff831b857f>] ? SyS_mount+0x7f/0xc0
[  135.390535]  [<ffffffff83001b5a>] ? do_syscall_64+0x6a/0x240
[  135.396320]  [<ffffffff834f6246>] ? entry_SYSCALL64_slow_path+0x25/0x25
[  135.403062] Code: 00 00 5b 5d c3 0f 0b 0f 1f 44 00 00 41 57 41 56 41 55 41 54 55 53 48 83 ec 50 48 8b 46 08 4c 8b 7e 10 48 8b 98 f0 01 00 00 31 c0 <49> 8b af 60 fd ff ff 48 8b 53 20 83 e2 40 74 09 80 be d8 05 00 
[  135.429926] RIP  [<ffffffffc06ef0ef>] qgroup_fix_relocated_data_extents+0x1f/0x2b0 [btrfs]
[  135.438474]  RSP <ffffb90f03db7a00>
[  135.442082] CR2: fffffffffffffd60
[  135.445526] ---[ end trace 603287b5bf87e6dd ]---

