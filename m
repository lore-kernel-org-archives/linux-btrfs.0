Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57239 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbdAFEhB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jan 2017 23:37:01 -0500
Date: Fri, 6 Jan 2017 05:36:01 +0100
From: Petr Janecek <janecek@ucw.cz>
To: linux-btrfs@vger.kernel.org
Subject: BUG at mount time on v4.8.10
Message-ID: <20170106043600.GB4502@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
      I just got a BUG on mount of a raid10 fs. /dev/sde was added to
the fs recently and balance has been started. After reboot (balance
still running), the fs can not be mounted any more.

# btrfs fi sh
Label: 'BTR0'  uuid: 0ec83db3-4574-4e40-8d57-ebbe9fe246e1
	Total devices 5 FS bytes used 5.45TiB
	devid    1 size 2.73TiB used 2.64TiB path /dev/sdk
	devid    2 size 2.73TiB used 2.64TiB path /dev/sdj
	devid    3 size 2.73TiB used 2.64TiB path /dev/sda
	devid    4 size 2.73TiB used 2.64TiB path /dev/sdb
	devid    5 size 2.73TiB used 356.03GiB path /dev/sde


[ 1291.115237] BTRFS info (device sdb): disk space caching is enabled
[ 1291.121456] BTRFS info (device sdb): has skinny extents
[ 1380.872569] BUG: unable to handle kernel paging request at fffffffffffffd60
[ 1380.879592] IP: [<ffffffffc045cf6f>] qgroup_fix_relocated_data_extents+0x1f/0x2a0 [btrfs]
[ 1380.887822] PGD 2fb807067 PUD 2fb809067 PMD 0 
[ 1380.892349] Oops: 0000 [#1] SMP
[ 1380.895497] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc xfs libcrc32c crc32c_generic x86_pkg_temp_thermal coretemp kvm_intel iTCO_wdt kvm iTCO_vendor_support irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul glue_helper i2c_i801 pcspkr i2c_smbus loop ipmi_watchdog raid10 acpi_cpufreq mei_me tpm_tis tpm_tis_core mei md_mod evdev battery video tpm acpi_power_meter ie31200_edac button shpchp edac_core processor ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler autofs4 btrfs xor raid6_pq sg hid_generic usbhid hid sd_mod xhci_pci igb ahci xhci_hcd i2c_algo_bit i2c_core libahci dca mpt3sas raid_class libata ptp scsi_transport_sas usbcore crc32c_intel pps_core usb_common scsi_mod fan thermal
[ 1380.966236] CPU: 0 PID: 1214 Comm: mount Not tainted 4.8.10 #9
[ 1380.972075] Hardware name: Supermicro Super Server/X11SSL-CF, BIOS 1.0a 01/29/2016
[ 1380.979652] task: ffff9587d6274100 task.stack: ffff9587c5654000
[ 1380.985579] RIP: 0010:[<ffffffffc045cf6f>]  [<ffffffffc045cf6f>] qgroup_fix_relocated_data_extents+0x1f/0x2a0 [btrfs]
[ 1380.996263] RSP: 0018:ffff9587c5657a00  EFLAGS: 00010246
[ 1381.001601] RAX: 0000000000000000 RBX: ffff9587caab1b60 RCX: 0000000000000000
[ 1381.008763] RDX: ffff9587cda38270 RSI: ffff9587c17c8000 RDI: ffff9587cda381e0
[ 1381.015922] RBP: ffff9587c5658000 R08: 0000000000000000 R09: ffff9587cda381e0
[ 1381.023082] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9587c5657a98
[ 1381.030241] R13: 0000000000000000 R14: ffff9587c17c8000 R15: 00000000cda381e0
[ 1381.037407] FS:  00007fad760e9840(0000) GS:ffff9587f7800000(0000) knlGS:0000000000000000
[ 1381.045540] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1381.051316] CR2: fffffffffffffd60 CR3: 0000000845623000 CR4: 00000000003406f0
[ 1381.058478] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1381.065638] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1381.072796] Stack:
[ 1381.074831]  0000000000000000 ffff9587cda381e0 0000000000000801 ffff9587cdf07000
[ 1381.082360]  ffff9587cda381e0 0000000000000801 ffffffffc040a834 ffff9587d6274100
[ 1381.089890]  0000000000000000 0000000000000246 ffff9587caab1b60 ffff9587d1170000
[ 1381.097423] Call Trace:
[ 1381.099908]  [<ffffffffc040a834>] ? start_transaction+0x94/0x4c0 [btrfs]
[ 1381.106658]  [<ffffffffc0460b03>] ? btrfs_recover_relocation+0x3b3/0x440 [btrfs]
[ 1381.114114]  [<ffffffffc0407384>] ? open_ctree+0x2164/0x2620 [btrfs]
[ 1381.120513]  [<ffffffffc03db44a>] ? btrfs_mount+0xcfa/0xe30 [btrfs]
[ 1381.126810]  [<ffffffffa6149ec7>] ? pcpu_alloc_area+0x2a7/0x3d0
[ 1381.132755]  [<ffffffffa64e942f>] ? __mutex_unlock_slowpath+0x9f/0x130
[ 1381.139309]  [<ffffffffa614ab13>] ? pcpu_alloc+0x323/0x620
[ 1381.144822]  [<ffffffffa6197691>] ? mount_fs+0x31/0x160
[ 1381.150081]  [<ffffffffa60921c7>] ? __init_waitqueue_head+0x17/0x30
[ 1381.156375]  [<ffffffffa61b201d>] ? vfs_kern_mount+0x5d/0x110
[ 1381.162150]  [<ffffffffc03da8f4>] ? btrfs_mount+0x1a4/0xe30 [btrfs]
[ 1381.168447]  [<ffffffffa614ab13>] ? pcpu_alloc+0x323/0x620
[ 1381.173956]  [<ffffffffa6197691>] ? mount_fs+0x31/0x160
[ 1381.179209]  [<ffffffffa60921c7>] ? __init_waitqueue_head+0x17/0x30
[ 1381.185503]  [<ffffffffa61b201d>] ? vfs_kern_mount+0x5d/0x110
[ 1381.191275]  [<ffffffffa61b4a54>] ? do_mount+0x1b4/0xc30
[ 1381.196613]  [<ffffffffa6146698>] ? memdup_user+0x38/0x60
[ 1381.202040]  [<ffffffffa61b57af>] ? SyS_mount+0x7f/0xc0
[ 1381.207292]  [<ffffffffa6001b68>] ? do_syscall_64+0x68/0x220
[ 1381.212977]  [<ffffffffa64eb9bc>] ? entry_SYSCALL64_slow_path+0x25/0x25
[ 1381.219617] Code: 00 00 5b 5d c3 0f 0b 0f 1f 44 00 00 41 57 41 56 41 55 41 54 55 53 48 83 ec 50 48 8b 46 08 4c 8b 6e 10 48 8b a8 f0 01 00 00 31 c0 <4d> 8b a5 60 fd ff ff f6 85 f0 10 00 00 01 74 09 80 be d8 05 00 
[ 1381.240041] RIP  [<ffffffffc045cf6f>] qgroup_fix_relocated_data_extents+0x1f/0x2a0 [btrfs]
[ 1381.248385]  RSP <ffff9587c5657a00>
[ 1381.251897] CR2: fffffffffffffd60
[ 1381.256043] ---[ end trace 97955e79aea6d1af ]---



Regards

Petr
