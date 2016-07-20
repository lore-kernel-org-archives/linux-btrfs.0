Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56055 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751448AbcGTGdw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 02:33:52 -0400
Subject: Re: ENOSPC / no space on very large devices
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1659eb11-0025-d9d4-c590-2a4d721bb299@profihost.ag>
CC: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Jannik Winkel <j.winkel@profihost.ag>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <578F1AB0.6090000@cn.fujitsu.com>
Date: Wed, 20 Jul 2016 14:31:12 +0800
MIME-Version: 1.0
In-Reply-To: <1659eb11-0025-d9d4-c590-2a4d721bb299@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/20/2016 01:31 PM, Stefan Priebe - Profihost AG wrote:
> Hi list,
>
> while i didn't had the problem for some month i'm now getting ENOSPC on
> a regular basis on one host.
>
> It would be great if someone can help me debugging this.
>
> Some basic informations:
> # touch /vmbackup/abc
> touch: cannot touch `/vmbackup/abc': No space left on device
When touch operation failed, would you please change dir to
/sys/fs/btrfs/UUID/allocation/data/ and show me these files' value.
And also files in /sys/fs/btrfs/UUID/allocation/metadata. thanks.
Here UUID is your real uuid :)

Regards,
Xiaoguang Wang

> # df -h /vmbackup/
> Filesystem                    Size  Used Avail Use% Mounted on
> /dev/mapper/stripe0-vmbackup   37T   28T  8,5T  77% /vmbackup
>
> # btrfs filesystem df /vmbackup/
> Data, single: total=27.87TiB, used=27.39TiB
> System, DUP: total=8.00MiB, used=4.34MiB
> Metadata, DUP: total=286.50GiB, used=199.91GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> # btrfs filesystem show /vmbackup/
> Label: none  uuid: c8c3abf7-8280-4baa-bb51-a8c599e48002
>          Total devices 1 FS bytes used 27.59TiB
>          devid    1 size 36.38TiB used 28.43TiB path
> /dev/mapper/stripe0-vmbackup
>
> # mount | grep vmbackup
> /dev/mapper/stripe0-vmbackup on /vmbackup type btrfs
> (rw,noatime,compress-force=zlib,nossd,noacl,space_cache=v2,clear_cache,commit=300,subvolid=5,subvol=/)
>
> dmesg is empty.
>
> if i umount the volume i get traces (i already did a clear_cache 4 days
> ago to recalculate the space_tree):
>
> [545031.675797] ------------[ cut here ]------------
> [545031.725166] WARNING: CPU: 1 PID: 17711 at
> fs/btrfs/extent-tree.c:5710 btrfs_free_block_groups+0x35a/0x400 [btrfs]()
> [545031.778329] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4
> mpt3sas raid_class scsi_transport_sas xt_multiport iptable_filter
> ip_tables x_tables 8021q garp bonding coretemp loop i40e(O) vxlan
> ip6_udp_tunnel usbhid udp_tunnel sb_edac ehci_pci edac_core ehci_hcd
> i2c_i801 i2c_core usbcore shpchp usb_common ipmi_si ipmi_msghandler
> button btrfs dm_mod raid1 raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx xor raid6_pq md_mod ixgbe mdio sg sd_mod
> ahci ptp libahci megaraid_sas pps_core
> [545032.081037] CPU: 1 PID: 17711 Comm: umount Tainted: G           O
> 4.4.15+43-ph #1
> [545032.145078] Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c
> 02/18/2015
> [545032.210238]  0000000000000000 ffff88010c40bcd8 ffffffffbd3c712f
> 0000000000000000
> [545032.275650]  ffffffffc03ec603 ffff88010c40bd18 ffffffffbd0837e7
> 00000047a0000000
> [545032.341525]  0000000000000000 ffff88105e0ea400 ffff881054a76088
> ffff881054a76000
> [545032.408500] Call Trace:
> [545032.475272]  [<ffffffffbd3c712f>] dump_stack+0x63/0x84
> [545032.543620]  [<ffffffffbd0837e7>] warn_slowpath_common+0x97/0xe0
> [545032.612900]  [<ffffffffbd08384a>] warn_slowpath_null+0x1a/0x20
> [545032.682026]  [<ffffffffc034a17a>]
> btrfs_free_block_groups+0x35a/0x400 [btrfs]
> [545032.750297]  [<ffffffffc035ba4b>] close_ctree+0x15b/0x330 [btrfs]
> [545032.817085]  [<ffffffffc03291f9>] btrfs_put_super+0x19/0x20 [btrfs]
> [545032.883439]  [<ffffffffbd1cd33f>] generic_shutdown_super+0x6f/0x100
> [545032.949302]  [<ffffffffbd1cd866>] kill_anon_super+0x16/0x30
> [545033.014327]  [<ffffffffc032f96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
> [545033.079031]  [<ffffffffbd1cda31>] deactivate_locked_super+0x51/0x90
> [545033.143275]  [<ffffffffbd1ce42e>] deactivate_super+0x4e/0x70
> [545033.206535]  [<ffffffffbd1e9373>] cleanup_mnt+0x43/0x90
> [545033.268842]  [<ffffffffbd1e9412>] __cleanup_mnt+0x12/0x20
> [545033.331629]  [<ffffffffbd09ef8e>] task_work_run+0x7e/0xa0
> [545033.393350]  [<ffffffffbd07e550>] exit_to_usermode_loop+0x66/0x95
> [545033.454685]  [<ffffffffbd002a56>] syscall_return_slowpath+0xa6/0xf0
> [545033.515485]  [<ffffffffbd6b6f4c>] int_ret_from_sys_call+0x25/0x8f
> [545033.575890] ---[ end trace bd985b05cc90617c ]---
> [545033.636708] ------------[ cut here ]------------
> [545033.696339] WARNING: CPU: 1 PID: 17711 at
> fs/btrfs/extent-tree.c:5711 btrfs_free_block_groups+0x3f4/0x400 [btrfs]()
> [545033.758031] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4
> mpt3sas raid_class scsi_transport_sas xt_multiport iptable_filter
> ip_tables x_tables 8021q garp bonding coretemp loop i40e(O) vxlan
> ip6_udp_tunnel usbhid udp_tunnel sb_edac ehci_pci edac_core ehci_hcd
> i2c_i801 i2c_core usbcore shpchp usb_common ipmi_si ipmi_msghandler
> button btrfs dm_mod raid1 raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx xor raid6_pq md_mod ixgbe mdio sg sd_mod
> ahci ptp libahci megaraid_sas pps_core
> [545034.095188] CPU: 1 PID: 17711 Comm: umount Tainted: G        W  O
> 4.4.15+43-ph #1
> [545034.166070] Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c
> 02/18/2015
> [545034.236259]  0000000000000000 ffff88010c40bcd8 ffffffffbd3c712f
> 0000000000000000
> [545034.307690]  ffffffffc03ec603 ffff88010c40bd18 ffffffffbd0837e7
> 00000047a0000000
> [545034.379596]  0000000000000000 ffff88105e0ea400 ffff881054a76088
> ffff881054a76000
> [545034.452542] Call Trace:
> [545034.525286]  [<ffffffffbd3c712f>] dump_stack+0x63/0x84
> [545034.599643]  [<ffffffffbd0837e7>] warn_slowpath_common+0x97/0xe0
> [545034.674894]  [<ffffffffbd08384a>] warn_slowpath_null+0x1a/0x20
> [545034.750338]  [<ffffffffc034a214>]
> btrfs_free_block_groups+0x3f4/0x400 [btrfs]
> [545034.826354]  [<ffffffffc035ba4b>] close_ctree+0x15b/0x330 [btrfs]
> [545034.900758]  [<ffffffffc03291f9>] btrfs_put_super+0x19/0x20 [btrfs]
> [545034.973612]  [<ffffffffbd1cd33f>] generic_shutdown_super+0x6f/0x100
> [545035.044589]  [<ffffffffbd1cd866>] kill_anon_super+0x16/0x30
> [545035.113505]  [<ffffffffc032f96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
> [545035.180769]  [<ffffffffbd1cda31>] deactivate_locked_super+0x51/0x90
> [545035.246451]  [<ffffffffbd1ce42e>] deactivate_super+0x4e/0x70
> [545035.311231]  [<ffffffffbd1e9373>] cleanup_mnt+0x43/0x90
> [545035.374958]  [<ffffffffbd1e9412>] __cleanup_mnt+0x12/0x20
> [545035.437806]  [<ffffffffbd09ef8e>] task_work_run+0x7e/0xa0
> [545035.500554]  [<ffffffffbd07e550>] exit_to_usermode_loop+0x66/0x95
> [545035.563108]  [<ffffffffbd002a56>] syscall_return_slowpath+0xa6/0xf0
> [545035.625033]  [<ffffffffbd6b6f4c>] int_ret_from_sys_call+0x25/0x8f
> [545035.686864] ---[ end trace bd985b05cc90617d ]---
> [545035.748727] ------------[ cut here ]------------
> [545035.810850] WARNING: CPU: 1 PID: 17711 at
> fs/btrfs/extent-tree.c:9990 btrfs_free_block_groups+0x2a4/0x400 [btrfs]()
> [545035.875894] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4
> mpt3sas raid_class scsi_transport_sas xt_multiport iptable_filter
> ip_tables x_tables 8021q garp bonding coretemp loop i40e(O) vxlan
> ip6_udp_tunnel usbhid udp_tunnel sb_edac ehci_pci edac_core ehci_hcd
> i2c_i801 i2c_core usbcore shpchp usb_common ipmi_si ipmi_msghandler
> button btrfs dm_mod raid1 raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx xor raid6_pq md_mod ixgbe mdio sg sd_mod
> ahci ptp libahci megaraid_sas pps_core
> [545036.227082] CPU: 1 PID: 17711 Comm: umount Tainted: G        W  O
> 4.4.15+43-ph #1
> [545036.300440] Hardware name: Supermicro X10DRH/X10DRH-iT, BIOS 1.0c
> 02/18/2015
> [545036.374617]  0000000000000000 ffff88010c40bcd8 ffffffffbd3c712f
> 0000000000000000
> [545036.449929]  ffffffffc03ec603 ffff88010c40bd18 ffffffffbd0837e7
> ffff88105e112c30
> [545036.525514]  0000000000000038 0000000000000000 ffff88105e0ea888
> ffff881054a76000
> [545036.601698] Call Trace:
> [545036.677124]  [<ffffffffbd3c712f>] dump_stack+0x63/0x84
> [545036.753379]  [<ffffffffbd0837e7>] warn_slowpath_common+0x97/0xe0
> [545036.829845]  [<ffffffffbd08384a>] warn_slowpath_null+0x1a/0x20
> [545036.905507]  [<ffffffffc034a0c4>]
> btrfs_free_block_groups+0x2a4/0x400 [btrfs]
> [545036.981923]  [<ffffffffc035ba4b>] close_ctree+0x15b/0x330 [btrfs]
> [545037.056759]  [<ffffffffc03291f9>] btrfs_put_super+0x19/0x20 [btrfs]
> [545037.130024]  [<ffffffffbd1cd33f>] generic_shutdown_super+0x6f/0x100
> [545037.201434]  [<ffffffffbd1cd866>] kill_anon_super+0x16/0x30
> [545037.270737]  [<ffffffffc032f96a>] btrfs_kill_super+0x1a/0xb0 [btrfs]
> [545037.338382]  [<ffffffffbd1cda31>] deactivate_locked_super+0x51/0x90
> [545037.404449]  [<ffffffffbd1ce42e>] deactivate_super+0x4e/0x70
> [545037.469597]  [<ffffffffbd1e9373>] cleanup_mnt+0x43/0x90
> [545037.533686]  [<ffffffffbd1e9412>] __cleanup_mnt+0x12/0x20
> [545037.596915]  [<ffffffffbd09ef8e>] task_work_run+0x7e/0xa0
> [545037.660027]  [<ffffffffbd07e550>] exit_to_usermode_loop+0x66/0x95
> [545037.722960]  [<ffffffffbd002a56>] syscall_return_slowpath+0xa6/0xf0
> [545037.785270]  [<ffffffffbd6b6f4c>] int_ret_from_sys_call+0x25/0x8f
> [545037.847443] ---[ end trace bd985b05cc90617e ]---
> [545037.909700] BTRFS: space_info 4 has 18446743523026157568 free, is
> not full
> [545037.973447] BTRFS: space_info total=307627032576, used=214654500864,
> pinned=0, reserved=0, may_use=643655794688, readonly=131072
>
> The workload on the FS is basically:
> - Write file1 (50GB - 500GB)
>
> - cp --reflink=always file1 to file2
> - apply changes to file2 (100MB - 5GB)
>
> - cp --reflink=always file2 to file3
> - apply changes to file3 (100MB - 5GB)
>
> ...
>
> - delete file1
>
> - cp --reflink=always file3 to file4
> - apply changes to file4 (100MB - 5GB)
>
> - delete file2
>
> ...
>
> And this for around 300 files a day. btrfs balance with dusage=5 and
> musage=5 is running daily.
>
> The kernel is something special - i'm using this one from holger:
> https://github.com/hhoffstaette/kernel-patches
>
> which is basically a 4.4.15 + several patches especially a lot of btrfs
> patches up to 4.8 i think.
>
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



