Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33834 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2LLNRR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 08:17:17 -0500
Date: Wed, 12 Dec 2012 21:15:30 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Joeri Vanthienen <mail@joerivanthienen.be>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:4052 (kernel 3.5.3)
Message-ID: <20121212131528.GB13944@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAPsrAuA0EdBGMd_dXX4RAKTp5eA156iaXAhOK8mUnncRDC228A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPsrAuA0EdBGMd_dXX4RAKTp5eA156iaXAhOK8mUnncRDC228A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 12, 2012 at 11:24:18AM +0100, Joeri Vanthienen wrote:
> Hi all,
> 
> Last week we had 2 times an "uncorrectable ecc memory error" crash on
> our server on the same memory module.
> After removing the faulty module and restarting the server, everything
> was working again.
> 
> However, yesterday we had a soft lockup and had to restart the server
> again. No warning or ecc error this time. Everything is working now,
> but we want to avoid this in the future ofcourse.
> 
>  Dec 11 17:49:04 SANOS1 kernel: kernel BUG at fs/btrfs/extent_io.c:4052!
> Dec 11 17:49:04 SANOS1 kernel: invalid opcode: 0000 [#1] SMP
> Dec 11 17:49:04 SANOS1 kernel: CPU 4
> Dec 11 17:49:04 SANOS1 kernel: Modules linked in: iscsi_scst(O)
> scst_vdisk(O) scst(O) btrfs zlib_deflate libcrc32c
> cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
> mperf sg(O) ses(O) ixg
> be mdio igb lpc_ich mfd_core enclosure mptctl(O) coretemp kvm_intel
> kvm crc32c_intel serio_raw pcspkr i2c_i801 i7core_edac ioatdma
> edac_core dca button edd microcode autofs4 processor thermal_sys
> scsi_dh_emc
> (O) scsi_dh_rdac(O) scsi_dh_alua(O) scsi_dh_hp_sw(O) scsi_dh(O)
> mptsas(O) mptscsih(O) mptbase(O) scsi_transport_sas(O) ata_generic
> ata_piix [last unloaded: scst]
> Dec 11 17:49:04 SANOS1 kernel:
> Dec 11 17:49:04 SANOS1 kernel: Pid: 10716, comm: btrfs-endio-wri
> Tainted: G           O 3.5.3-2.10-desktop #3 Supermicro
> X8DTN+-F/X8DTN+-F
> Dec 11 17:49:04 SANOS1 kernel: RIP: 0010:[<ffffffffa025c3de>]
> [<ffffffffa025c3de>]
> btrfs_release_extent_buffer_page.constprop.47+0x11e/0x130 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel: RSP: 0018:ffff8804d7cbf900  EFLAGS: 00010202
> Dec 11 17:49:04 SANOS1 kernel: RAX: 0000000000000001 RBX:
> ffff88080e3e80e0 RCX: ffff880497cb74b0
> Dec 11 17:49:04 SANOS1 kernel: RDX: 0000000000000000 RSI:
> 0000000015644868 RDI: ffff88080e3e80e0
> Dec 11 17:49:04 SANOS1 kernel: RBP: ffff8804d7cbf930 R08:
> 0000000000000028 R09: ffff8804d7cbf808
> Dec 11 17:49:04 SANOS1 kernel: R10: 0000000000000000 R11:
> 0000000000000000 R12: ffff880497cb4c10
> Dec 11 17:49:04 SANOS1 kernel: R13: ffff8804cca63eb0 R14:
> ffff88080e3e80e0 R15: 0000000000000005
> Dec 11 17:49:04 SANOS1 kernel: FS:  0000000000000000(0000)
> GS:ffff88083fc00000(0000) knlGS:0000000000000000
> Dec 11 17:49:04 SANOS1 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Dec 11 17:49:04 SANOS1 kernel: CR2: 00007f5519e56600 CR3:
> 0000000001a0c000 CR4: 00000000000007e0
> Dec 11 17:49:04 SANOS1 kernel: DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Dec 11 17:49:04 SANOS1 kernel: DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Dec 11 17:49:04 SANOS1 kernel: Process btrfs-endio-wri (pid: 10716,
> threadinfo ffff8804d7cbe000, task ffff8807be802280)
> Dec 11 17:49:04 SANOS1 kernel: Stack:
> Dec 11 17:49:04 SANOS1 kernel:  ffff8804d7cbf950 ffff88080e3e80e0
> ffff880497cb4c10 ffff8804cca63eb0
> Dec 11 17:49:04 SANOS1 kernel:  000002ce2aa53000 ffff8804a65ab000
> ffff8804d7cbf950 ffffffffa025c60f
> Dec 11 17:49:04 SANOS1 kernel:  ffff88080e3e80e0 ffff8804cca63eb0
> ffff8804d7cbf970 ffffffffa02616b2
> Dec 11 17:49:04 SANOS1 kernel: Call Trace:
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa025c60f>]
> release_extent_buffer.isra.38+0x3f/0xc0 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa02616b2>]
> free_extent_buffer+0x32/0x90 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa02197aa>]
> btrfs_release_path+0x2a/0xb0 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa0219aa6>]
> btrfs_free_path+0x16/0x30 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa0232df0>]
> btrfs_del_csums+0x2b0/0x300 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa0227149>]
> __btrfs_free_extent+0x639/0x7b0 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa022b34e>]
> run_clustered_refs+0x2be/0xa50 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa022bc76>]
> btrfs_run_delayed_refs+0x196/0x4c0 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa025cac8>] ?
> merge_state+0xd8/0x150 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa025c949>] ?
> free_extent_state+0x19/0x20 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa025d476>] ?
> clear_extent_bit+0x216/0x380 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa023d56a>]
> __btrfs_end_transaction+0x9a/0x350 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa023d880>]
> btrfs_end_transaction+0x10/0x20 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa02433c5>]
> btrfs_finish_ordered_io+0x175/0x400 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffff8104ebd0>] ? usleep_range+0x40/0x40
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa0243660>]
> finish_ordered_fn+0x10/0x20 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa026cd97>]
> worker_loop+0x157/0x550 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffffa026cc40>] ?
> btrfs_queue_worker+0x310/0x310 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffff81061bde>] kthread+0x8e/0xa0
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffff81590594>]
> kernel_thread_helper+0x4/0x10
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffff81061b50>] ?
> flush_kthread_worker+0x70/0x70
> Dec 11 17:49:04 SANOS1 kernel:  [<ffffffff81590590>] ? gs_change+0x13/0x13
> Dec 11 17:49:04 SANOS1 kernel: Code: 20 a8 04 75 2c 48 8b 03 a8 10 75
> 23 48 8b 03 f6 c4 20 75 19 f0 80 63 01 f7 48 c7 43 30 00 00 00 00 48
> 89 df e8 24 c6 ea e0 eb c0 <0f> 0b 0f 0b 0f 0b 0f 0b 66 2e 0f 1f 84
> 00 00 00 00 00 55 48 c1
> Dec 11 17:49:04 SANOS1 kernel: RIP  [<ffffffffa025c3de>]
> btrfs_release_extent_buffer_page.constprop.47+0x11e/0x130 [btrfs]
> Dec 11 17:49:04 SANOS1 kernel:  RSP <ffff8804d7cbf900>
> Dec 11 17:49:04 SANOS1 kernel: ---[ end trace ea1d29e10378231c ]---
> Dec 11 17:49:29 SANOS1 kernel: BUG: soft lockup - CPU#1 stuck for 22s!
> [btrfs-endio-wri:2846]
> 
> 
> Today I've finished a scrub on the btrfs filesystem. No errors.
> SANOS1:~ # btrfs scrub status -d /dev/sde
> scrub status for 517e8cfa-4275-4589-8da4-6a46ad613daa
> scrub device /dev/sde (id 1) history
>         scrub started at Wed Dec 12 09:28:44 2012 and finished after
> 4149 seconds
>         total bytes scrubbed: 338.19GB with 0 errors
> 
> What could be the cause of the soft lockup ? Thanks in advance.

Just FYI, I once hit similar soft lockup on extent buffer
while tracking bugs about tree modify log code, but we've
fixed them in the latest btrfs.

thanks,
liubo
