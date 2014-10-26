Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45155 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaJZMZg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 08:25:36 -0400
Date: Sun, 26 Oct 2014 13:25:34 +0100
From: Petr Janecek <janecek@ucw.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [BUG] fs/btrfs/delayed-inode.c: 1410
 btrfs_commit_transaction+0x388/0x950()
Message-ID: <20141026122533.GA22018@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> [$] uname -a
> Linux beplan 3.18.0-rc1-next-20141023-ARCH-dirty #1 SMP PREEMPT Sat
> Oct 25 22:19:01 FET 2014 x86_64 GNU/Linux
> 
> I have a custom config for kernel, and i disable debugs feature in
> kernel. If needed i can enable it and recompile kernel.
> 
> After this message, system boot continue and working good.
> I catch this message every time when i hard reset my system.

  I also got warnings in the same place during one boot, haven't seen
them ever after or before. I see four kinds of stack traces: first two
at the mount time:

[    5.712102] BTRFS: has skinny extents
[    5.746543] ------------[ cut here ]------------
[    5.751241] WARNING: CPU: 0 PID: 458 at fs/btrfs/delayed-inode.c:1410 btrfs_commit_transaction+0x386/0x88c [btrfs]()
[    5.761848] Modules linked in: btrfs xor raid6_pq sg sd_mod uas usb_storage hid_generic usbhid hid ahci libahci libata mpt2sas crc32c_intel raid_class scsi_transport_sas e1000e ptp scsi_mod ehci_pci pps_core ehci_hcd thermal fan thermal_sys usbcore usb_common
[    5.786890] CPU: 0 PID: 458 Comm: exe Not tainted 3.18.0-rc1 #12
[    5.793321] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0a 06/08/2012
[    5.801058]  0000000000000000 0000000000000009 ffffffff813aeaf1 0000000000000000
[    5.808820]  ffffffff8103b70a ffffe8ffffc0a3b0 ffffffffc05ad1d1 ffff8800d949fa00
[    5.816582]  ffff8800370a3000 ffff8800d949f980 0000000000000000 ffff8800d9458e10
[    5.824346] Call Trace:
[    5.826873]  [<ffffffff813aeaf1>] ? dump_stack+0x41/0x51
[    5.832253]  [<ffffffff8103b70a>] ? warn_slowpath_common+0x78/0x90
[    5.838512]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[    5.845991]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[    5.853479]  [<ffffffffc05e0495>] ? btrfs_recover_log_trees+0x2b3/0x314 [btrfs]
[    5.860878]  [<ffffffffc05def48>] ? replay_one_extent+0x4c4/0x4c4 [btrfs]
[    5.867748]  [<ffffffffc05ab22f>] ? open_ctree+0x1966/0x1d5c [btrfs]
[    5.874174]  [<ffffffffc058b9ef>] ? btrfs_mount+0x44d/0x5b4 [btrfs]
[    5.880514]  [<ffffffff810e885d>] ? pcpu_next_unpop+0x36/0x43
[    5.886337]  [<ffffffff810e9b2e>] ? pcpu_alloc+0x439/0x4f5
[    5.891889]  [<ffffffff8111cdad>] ? mount_fs+0x61/0x143
[    5.897194]  [<ffffffff811301ea>] ? vfs_kern_mount+0x62/0xe0
[    5.902929]  [<ffffffff811325a8>] ? do_mount+0x6bd/0x84e
[    5.908309]  [<ffffffff810e5e9d>] ? memdup_user+0x31/0x56
[    5.913786]  [<ffffffff81132970>] ? SyS_mount+0x6f/0x9d
[    5.919079]  [<ffffffff813b2df0>] ? tracesys_phase2+0xd4/0xd9
[    5.924892] ---[ end trace 1f31e98e3191d55c ]---
[    6.013990] ------------[ cut here ]------------
[    6.018691] WARNING: CPU: 0 PID: 458 at fs/btrfs/delayed-inode.c:1410 btrfs_commit_transaction+0x386/0x88c [btrfs]()
[    6.029294] Modules linked in: btrfs xor raid6_pq sg sd_mod uas usb_storage hid_generic usbhid hid ahci libahci libata mpt2sas crc32c_intel raid_class scsi_transport_sas e1000e ptp scsi_mod ehci_pci pps_core ehci_hcd thermal fan thermal_sys usbcore usb_common
[    6.054386] CPU: 0 PID: 458 Comm: exe Tainted: G        W      3.18.0-rc1 #12
[    6.061951] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0a 06/08/2012
[    6.069697]  0000000000000000 0000000000000009 ffffffff813aeaf1 0000000000000000
[    6.077458]  ffffffff8103b70a ffff8800d949f980 ffffffffc05ad1d1 ffff8800d949fa00
[    6.085228]  ffff8800370a3000 ffff8800d949f980 0000000000000000 ffff8800d9458e10
[    6.092992] Call Trace:
[    6.095510]  [<ffffffff813aeaf1>] ? dump_stack+0x41/0x51
[    6.100890]  [<ffffffff8103b70a>] ? warn_slowpath_common+0x78/0x90
[    6.107143]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[    6.114629]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[    6.122116]  [<ffffffffc05ab290>] ? open_ctree+0x19c7/0x1d5c [btrfs]
[    6.128543]  [<ffffffffc058b9ef>] ? btrfs_mount+0x44d/0x5b4 [btrfs]
[    6.134882]  [<ffffffff810e885d>] ? pcpu_next_unpop+0x36/0x43
[    6.140693]  [<ffffffff810e9b2e>] ? pcpu_alloc+0x439/0x4f5
[    6.146250]  [<ffffffff8111cdad>] ? mount_fs+0x61/0x143
[    6.151552]  [<ffffffff811301ea>] ? vfs_kern_mount+0x62/0xe0
[    6.157289]  [<ffffffff811325a8>] ? do_mount+0x6bd/0x84e
[    6.162675]  [<ffffffff810e5e9d>] ? memdup_user+0x31/0x56
[    6.168145]  [<ffffffff81132970>] ? SyS_mount+0x6f/0x9d
[    6.173438]  [<ffffffff813b2df0>] ? tracesys_phase2+0xd4/0xd9
[    6.179253] ---[ end trace 1f31e98e3191d55d ]---


then plenty of these:

[   42.769411] ------------[ cut here ]------------
[   42.774120] WARNING: CPU: 2 PID: 480 at fs/btrfs/delayed-inode.c:1410 btrfs_commit_transaction+0x386/0x88c [btrfs]()
[   42.784729] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc xfs libcrc32c loop raid10 md_mod x86_pkg_temp_thermal coretemp kvm_intel kvm crc32
aesni_intel i2c_i801 aes_x86_64 ablk_helper cryptd lrw gf128mul iTCO_wdt glue_helper iTCO_vendor_support psmouse i2c_core pcspkr serio_raw evdev microcode lpc_ich mfd_core battery ipmi_
_tis tpm acpi_cpufreq button processor ie31200_edac edac_core btrfs xor raid6_pq sg sd_mod uas usb_storage hid_generic usbhid hid ahci libahci libata mpt2sas crc32c_intel raid_class scs
csi_mod ehci_pci pps_core ehci_hcd thermal fan thermal_sys usbcore usb_common
[   42.853114] CPU: 2 PID: 480 Comm: btrfs-transacti Tainted: G        W      3.18.0-rc1 #12
[   42.861728] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0a 06/08/2012
[   42.869490]  0000000000000000 0000000000000009 ffffffff813aeaf1 0000000000000000
[   42.877268]  ffffffff8103b70a 0000000000000000 ffffffffc05ad1d1 ffff880406108a00
[   42.885084]  ffff8800370a3000 ffff880406108980 0000000000000000 ffff8800d9458d20
[   42.892899] Call Trace:
[   42.895426]  [<ffffffff813aeaf1>] ? dump_stack+0x41/0x51
[   42.900833]  [<ffffffff8103b70a>] ? warn_slowpath_common+0x78/0x90
[   42.907094]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[   42.914614]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[   42.922101]  [<ffffffffc05add5c>] ? start_transaction+0x36f/0x4d0 [btrfs]
[   42.928982]  [<ffffffff8107c2f9>] ? call_timer_fn+0xe5/0xe5
[   42.934629]  [<ffffffffc05ab719>] ? transaction_kthread+0xf4/0x1ab [btrfs]
[   42.941613]  [<ffffffffc05ab625>] ? open_ctree+0x1d5c/0x1d5c [btrfs]
[   42.948049]  [<ffffffffc05ab625>] ? open_ctree+0x1d5c/0x1d5c [btrfs]
[   42.954507]  [<ffffffff8105093d>] ? kthread+0x99/0xa1
[   42.959630]  [<ffffffff81050000>] ? add_sysfs_param.isra.2+0xa3/0x138
[   42.966171]  [<ffffffff81050000>] ? add_sysfs_param.isra.2+0xa3/0x138
[   42.972688]  [<ffffffff810508a4>] ? __kthread_parkme+0x58/0x58
[   42.978621]  [<ffffffff813b2b6c>] ? ret_from_fork+0x7c/0xb0
[   42.984263]  [<ffffffff810508a4>] ? __kthread_parkme+0x58/0x58
[   42.990198] ---[ end trace 1f31e98e3191d55e ]---


and one during subvolume creation on a newly created and mounted filesystem:

[  235.438726] BTRFS: device label BTR3 devid 1 transid 3 /dev/sde
[  235.446448] BTRFS: device label BTR3 devid 2 transid 3 /dev/sdf
[  235.454083] BTRFS: device label BTR3 devid 3 transid 3 /dev/sdg
[  235.461932] BTRFS: device label BTR3 devid 4 transid 3 /dev/sdh
[  235.963243] ------------[ cut here ]------------
[  235.967958] WARNING: CPU: 1 PID: 3646 at fs/btrfs/delayed-inode.c:1410 btrfs_commit_transaction+0x386/0x88c [btrfs]()
[  235.978657] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc xfs libcrc32c loop raid10 md_mod x86_pkg_temp_thermal coretemp kvm_intel kvm crc32
aesni_intel i2c_i801 aes_x86_64 ablk_helper cryptd lrw gf128mul iTCO_wdt glue_helper iTCO_vendor_support psmouse i2c_core pcspkr serio_raw evdev microcode lpc_ich mfd_core battery ipmi_
_tis tpm acpi_cpufreq button processor ie31200_edac edac_core btrfs xor raid6_pq sg sd_mod uas usb_storage hid_generic usbhid hid ahci libahci libata mpt2sas crc32c_intel raid_class scs
csi_mod ehci_pci pps_core ehci_hcd thermal fan thermal_sys usbcore usb_common
[  236.046561] CPU: 1 PID: 3646 Comm: btrfs Tainted: G        W      3.18.0-rc1 #12
[  236.054388] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0a 06/08/2012
[  236.062124]  0000000000000000 0000000000000009 ffffffff813aeaf1 0000000000000000
[  236.069875]  ffffffff8103b70a ffff8800d7313b78 ffffffffc05ad1d1 ffff880406288280
[  236.077630]  ffff8800d8a83000 ffff880406288200 0000000000000000 ffff88040632f000
[  236.085377] Call Trace:
[  236.087893]  [<ffffffff813aeaf1>] ? dump_stack+0x41/0x51
[  236.093281]  [<ffffffff8103b70a>] ? warn_slowpath_common+0x78/0x90
[  236.099542]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[  236.107026]  [<ffffffffc05ad1d1>] ? btrfs_commit_transaction+0x386/0x88c [btrfs]
[  236.114508]  [<ffffffffc0594870>] ? block_rsv_release_bytes+0xe2/0x101 [btrfs]
[  236.121821]  [<ffffffffc0607932>] ? create_subvol+0x585/0x5dd [btrfs]
[  236.128342]  [<ffffffffc05d50c7>] ? btrfs_mksubvol.isra.59+0x3b2/0x430 [btrfs]
[  236.135653]  [<ffffffffc05d51ec>] ? btrfs_ioctl_snap_create_transid+0xa7/0x17c [btrfs]
[  236.143660]  [<ffffffffc05d530f>] ? btrfs_ioctl_snap_create+0x4e/0x67 [btrfs]
[  236.150860]  [<ffffffff8127ac63>] ? tty_insert_flip_string_fixed_flag+0x44/0xad
[  236.158259]  [<ffffffffc05d7a4e>] ? btrfs_ioctl+0x6d9/0x211e [btrfs]
[  236.164679]  [<ffffffff8127bdd0>] ? pty_write+0x44/0x4e
[  236.169975]  [<ffffffff81063a03>] ? remove_wait_queue+0xf/0x48
[  236.175874]  [<ffffffff81277622>] ? n_tty_write+0x3d2/0x405
[  236.181516]  [<ffffffff811454e6>] ? fsnotify+0x237/0x273
[  236.186897]  [<ffffffff8112760e>] ? do_vfs_ioctl+0x3ec/0x435
[  236.192622]  [<ffffffff8105bf9e>] ? vtime_account_user+0x35/0x40
[  236.198696]  [<ffffffff811276a0>] ? SyS_ioctl+0x49/0x77
[  236.203990]  [<ffffffff813b2d91>] ? tracesys_phase2+0x75/0xd9
[  236.209806]  [<ffffffff813b2df0>] ? tracesys_phase2+0xd4/0xd9
[  236.215618] ---[ end trace 1f31e98e3191d564 ]---


Regards,

Petr
