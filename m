From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: 3.0-rcX BUG at fs/btrfs/ioctl.c:432 - bisected
Date: Fri, 10 Jun 2011 11:18:56 +0800
Message-ID: <4DF18D20.3020409@cn.fujitsu.com>
References: <4DF140AB.4030805@sandia.gov>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4DF140AB.4030805@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, 9 Jun 2011 15:52:43 -0600, Jim Schutt wrote:
> Jun  9 15:14:50 an1 [  299.446615] ------------[ cut here ]------------
> Jun  9 15:14:50 an1 [  299.447357] kernel BUG at fs/btrfs/ioctl.c:432!
> Jun  9 15:14:50 an1 [  299.447357] invalid opcode: 0000 [#1] SMP
> Jun  9 15:14:50 an1 [  299.447357] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> Jun  9 15:14:50 an1 [  299.447357] CPU 2
> Jun  9 15:14:50 an1 [  299.447357] Modules linked in: btrfs zlib_deflate lzo_compress ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd scsi_transport_iscsi rds ib_ipoib rdma_ucm rdma_cm ib_ucm ib_uverbs ib_umad ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod video sbs sbshc pci_slot battery acpi_pad ac kvm sg ses sd_mod enclosure ide_cd_mod cdrom megaraid_sas qla2xxx ib_mthca scsi_transport_fc scsi_tgt ib_mad ib_core button serio_raw ata_piix libata scsi_mod tpm_tis tpm dcdbas tpm_bios iTCO_wdt ioatdma iTCO_vendor_support ehci_hcd i5k_amb dca uhci_hcd hwmon i5000_edac edac_core pcspkr rtc nfs nfs_acl auth_rpcgss fsc
 ache lockd sunrpc tg3 bnx2 e1000 [last unloaded: freq_table]
> Jun  9 15:14:50 an1 [  299.447357]
> Jun  9 15:14:50 an1 [  299.447357] Pid: 6047, comm: cosd Not tainted 2.6.39-00001-g16cdcec #24 Dell Inc. PowerEdge 1950/0DT097
> Jun  9 15:14:50 an1 [  299.447357] RIP: 0010:[<ffffffffa0709b96>]  [<ffffffffa0709b96>] create_subvol+0x36a/0x440 [btrfs]
> Jun  9 15:14:50 an1 [  299.447357] RSP: 0018:ffff88021b163c48  EFLAGS: 00010206
> Jun  9 15:14:50 an1 [  299.447357] RAX: 0000000019b201a0 RBX: ffff88022402d800 RCX: ffff88019206c028
> Jun  9 15:14:50 an1 [  299.447357] RDX: ffff88021884f618 RSI: 00000000fffffff4 RDI: ffff88019206c048
> Jun  9 15:14:50 an1 [  299.447357] RBP: ffff88021b163de8 R08: ffff88021b163bb8 R09: ffff88019206c048
> Jun  9 15:14:50 an1 [  299.447357] R10: ffffffffa06c7ed7 R11: ffff88021b163bb8 R12: ffff88021b163d88
> Jun  9 15:14:50 an1 [  299.447357] R13: 0000000000000000 R14: ffff880222fac000 R15: ffff8801e8b6e280
> Jun  9 15:14:50 an1 [  299.447357] FS:  00007fa5aa04d710(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
> Jun  9 15:14:50 an1 [  299.447357] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jun  9 15:14:50 an1 [  299.447357] CR2: 0000000001d45000 CR3: 000000021bd42000 CR4: 00000000000006e0
> Jun  9 15:14:50 an1 [  299.447357] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Jun  9 15:14:50 an1 [  299.447357] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jun  9 15:14:50 an1 [  299.447357] Process cosd (pid: 6047, threadinfo ffff88021b162000, task ffff8801dee243e0)
> Jun  9 15:14:50 an1 [  299.447357] Stack:
> Jun  9 15:14:50 an1 [  299.447357]  ffff880200000002 0000000000000003 0000000000000000 ffff8801e8b6d000
> Jun  9 15:14:50 an1 [  299.447357]  0000000000000000 000000071b163c80 ffff8801d6af9008 ffff880192075000
> Jun  9 15:14:50 an1 [  299.447357]  ffff8801e898eb40 ffff880219b201a0 0000000000000001 0000000000000000
> Jun  9 15:14:50 an1 [  299.447357] Call Trace:
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffff810362ec>] ? need_resched+0x23/0x2d
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffffa0709d7a>] btrfs_mksubvol+0x10e/0x167 [btrfs]
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffffa070a29f>] btrfs_ioctl_snap_create_transid+0x9c/0x121 [btrfs]
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffffa070a45e>] btrfs_ioctl_snap_create+0x50/0x67 [btrfs]
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffffa070bc5a>] btrfs_ioctl+0x1d0/0x2c6 [btrfs]
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffff8111fe12>] vfs_ioctl+0x1d/0x34
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffff8112048d>] do_vfs_ioctl+0x171/0x17a
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffff811130a2>] ? fget_light+0x69/0x81
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffff811204f2>] sys_ioctl+0x5c/0x7c
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffff8111d48d>] ? putname+0x33/0x37
> Jun  9 15:14:50 an1 [  299.447357]  [<ffffffff813b21eb>] system_call_fastpath+0x16/0x1b
> Jun  9 f6 4c 89 ff 01 c0 48 98 48 03 82 c8 00 00 00 48 89 82 c8 00 00 00 48 89 42 c0 48 8b 95 a8 fe ff ff e8 5e d5 fd ff 85 c0 74 04 <0f> 0b eb fe 48 8b 85 a8 fe ff ff 49 8b 8e 17 01 00 00 4c 89 ff
> Jun  9 15:14:50 an1 [  299.447357] RIP  [<ffffffffa0709b96>] create_subvol+0x36a/0x440 [btrfs]
> Jun  9 15:14:50 an1 [  299.447357]  RSP <ffff88021b163c48>
> Jun  9 15:14:50 an1 [  299.767860] ---[ end trace 10d1f43d69984a37 ]---
> Jun  9 15:15:23 an1 [  333.037241] ------------[ cut here ]------------
> 
> 
> It bisects to the following commit:
> 
> 16cdcec736cd214350cdb591bf1091f8beedefa0 is the first bad commit
> commit 16cdcec736cd214350cdb591bf1091f8beedefa0
> Author: Miao Xie <miaox@cn.fujitsu.com>
> Date:   Fri Apr 22 18:12:22 2011 +0800
> 
>     btrfs: implement delayed inode items operation
> 
> Please let me know what other information I can provide, or
> any testing I can do, that will help to resolve this issue.

Thanks for your report. Could you tell me the reproduce steps and the top commit
id in detail? I can't reproduce this bug now.

Thanks
Miao

> 
> Thanks -- Jim
> 
> 
> 

