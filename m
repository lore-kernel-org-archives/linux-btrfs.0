Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:35853 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3A2SmX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 13:42:23 -0500
Message-ID: <510817C6.5070007@sandia.gov>
Date: Tue, 29 Jan 2013 11:41:10 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: "Josef Bacik" <jbacik@fusionio.com>
cc: "Liu Bo" <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
In-Reply-To: <20130128212331.GG3257@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/28/2013 02:23 PM, Josef Bacik wrote:
> On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
>> Hi Josef,
>>
>> Thanks for the patch - sorry for the long delay in testing...
>>
> 
> Jim,
> 
> I've been trying to reason out how this happens, could you do a btrfs fi df on
> the filesystem thats giving you trouble so I can see if what I think is
> happening is what's actually happening.  Thanks,

Here's an example, using a slightly different kernel than
my previous report.  It's your btrfs-next master branch
(commit 8f139e59d5 "Btrfs: use bit operation for ->fs_state")
with ceph 3.8 for-linus (commit 0fa6ebc600 from linus' tree).


Here I'm finding the file system in question:

# ls -l /dev/mapper | grep dm-93
lrwxrwxrwx 1 root root       8 Jan 29 11:13 cs53s19p2 -> ../dm-93

# df -h | grep -A 1 cs53s19p2
/dev/mapper/cs53s19p2
                      896G  1.1G  896G   1% /ram/mnt/ceph/data.osd.522


Here's the info you asked for:

# btrfs fi df /ram/mnt/ceph/data.osd.522
Data: total=2.01GB, used=1.00GB
System: total=4.00MB, used=64.00KB
Metadata: total=8.00MB, used=7.56MB


And here's the backtrace that had trouble on dm-93.
It's a little different to my previous report:

[  705.496463] ------------[ cut here ]------------
[  705.501123] WARNING: at fs/btrfs/super.c:256 __btrfs_abort_transaction+0x60/0x110 [btrfs]()
[  705.509751] Hardware name: X8DTH-i/6/iF/6F
[  705.513862] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput sg joydev sd_mod hid_generic iTCO_wdt iTCO_vendor_support coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core ata_piix libata mpt2sas scsi_transport_sas raid_class scsi_mod cxgb4 i2c_i801 i2c_core button lpc_ich mfd_core ehci_hcd uhci_hcd i7core_edac edac_core dm_mod ioatdma nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[  705.580232] Pid: 33025, comm: ceph-osd Not tainted 3.7.0-00269-gd9acbfd #492
[  705.587488] Call Trace:
[  705.589957]  [<ffffffff8103ff04>] warn_slowpath_common+0x94/0xc0
[  705.596108]  [<ffffffffa055331a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[  705.602685]  [<ffffffff8103ffe6>] warn_slowpath_fmt+0x46/0x50
[  705.608563]  [<ffffffffa054c730>] __btrfs_abort_transaction+0x60/0x110 [btrfs]
[  705.615994]  [<ffffffffa05a2058>] __btrfs_alloc_chunk+0x678/0x710 [btrfs]
[  705.622945]  [<ffffffffa05a214e>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[  705.629635]  [<ffffffffa055edb1>] ? check_system_chunk+0x71/0x130 [btrfs]
[  705.637079]  [<ffffffffa055f15c>] do_chunk_alloc+0x2ec/0x370 [btrfs]
[  705.643451]  [<ffffffffa055b199>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[  705.650951]  [<ffffffffa0561d1c>] btrfs_check_data_free_space+0x13c/0x2b0 [btrfs]
[  705.658446]  [<ffffffffa0564a70>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
[  705.665882]  [<ffffffffa058980e>] __btrfs_buffered_write+0x15e/0x340 [btrfs]
[  705.672952]  [<ffffffffa0589e29>] btrfs_file_aio_write+0x309/0x450 [btrfs]
[  705.679889]  [<ffffffffa0589b20>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
[  705.686934]  [<ffffffff811626f4>] do_sync_readv_writev+0x94/0xe0
[  705.692942]  [<ffffffff811637b3>] do_readv_writev+0xe3/0x1e0
[  705.698604]  [<ffffffff81180c42>] ? fget_light+0x122/0x170
[  705.704093]  [<ffffffff811638f6>] vfs_writev+0x46/0x60
[  705.709239]  [<ffffffff81163a2f>] sys_writev+0x5f/0xc0
[  705.714388]  [<ffffffff812637ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  705.720827]  [<ffffffff814b7882>] system_call_fastpath+0x16/0x1b
[  705.726829] ---[ end trace 6e889d6d939ca116 ]---
[  705.731459] BTRFS warning (device dm-93): __btrfs_alloc_chunk:3787: Aborting unused transaction(error 28).
[  705.741187] btrfs: mapping failed logical 1099431936 bio len 524288 len 65536
[  705.741192] BTRFS warning (device dm-93): find_free_extent:5948: Aborting unused transaction(Object already exists).
[  705.759185] ------------[ cut here ]------------
[  705.763929] kernel BUG at fs/btrfs/volumes.c:4891!
[  705.768990] invalid opcode: 0000 [#1] SMP 
[  705.773561] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput sg joydev sd_mod hid_generic iTCO_wdt iTCO_vendor_support coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core ata_piix libata mpt2sas scsi_transport_sas raid_class scsi_mod cxgb4 i2c_i801 i2c_core button lpc_ich mfd_core ehci_hcd uhci_hcd i7core_edac edac_core dm_mod ioatdma nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[  705.845121] CPU 22 
[  705.847114] Pid: 21317, comm: btrfs-worker-1 Tainted: G        W    3.7.0-00269-gd9acbfd #492 Supermicro X8DTH-i/6/iF/6F/X8DTH
[  705.858886] RIP: 0010:[<ffffffffa05a2f0d>]  [<ffffffffa05a2f0d>] btrfs_map_bio+0x8d/0x300 [btrfs]
[  705.867928] RSP: 0018:ffff880610ce7c58  EFLAGS: 00010296
[  705.873363] RAX: 0000000000000041 RBX: ffff88061c368480 RCX: 0000000000009291
[  705.880692] RDX: 0000000000000091 RSI: 0000000000000001 RDI: ffffffff81a21a40
[  705.888315] RBP: ffff880610ce7d08 R08: 0000000000000001 R09: 0000000000000001
[  705.895805] R10: 00000000000007ca R11: 0000000000000001 R12: 0000000041880000
[  705.903139] R13: 0000000000080000 R14: ffff880c12621468 R15: ffff880c12621458
[  705.910467] FS:  0000000000000000(0000) GS:ffff880c3fd40000(0000) knlGS:0000000000000000
[  705.918978] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  705.925036] CR2: ffffffffff600400 CR3: 0000000001a0b000 CR4: 00000000000007e0
[  705.932406] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  705.939818] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  705.947461] Process btrfs-worker-1 (pid: 21317, threadinfo ffff880610ce6000, task ffff880613b1bec0)
[  705.957264] Stack:
[  705.959806]  ffff8805e0f64000 ffff8808e5b12188 ffff880613b1c578 000004aa11555000
[  705.970044]  ffff880c00000000 ffff880c126214b0 0000000100000000 ffff8805eddd2000
[  705.979630]  0000000000000001 0000000100000411 ffff880610ce7d28 0000000000000246
[  705.989568] Call Trace:
[  705.992386]  [<ffffffffa05a3cf0>] ? run_ordered_completions+0x40/0xd0 [btrfs]
[  706.000651]  [<ffffffffa057bd43>] __btrfs_submit_bio_done+0x23/0x40 [btrfs]
[  706.008210]  [<ffffffffa0570ba1>] run_one_async_done+0xc1/0xd0 [btrfs]
[  706.015049]  [<ffffffffa05a3d33>] run_ordered_completions+0x83/0xd0 [btrfs]
[  706.022246]  [<ffffffffa05a4868>] worker_loop+0x1b8/0x410 [btrfs]
[  706.028930]  [<ffffffffa05a46b0>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
[  706.037561]  [<ffffffff81067561>] kthread+0xe1/0xf0
[  706.042896]  [<ffffffff81067480>] ? __init_kthread_worker+0x70/0x70
[  706.049524]  [<ffffffff814b77dc>] ret_from_fork+0x7c/0xb0
[  706.055314]  [<ffffffff81067480>] ? __init_kthread_worker+0x70/0x70
[  706.062429] Code: 56 02 00 00 48 8b 45 c0 48 8b 4d c8 8b 50 28 49 39 cd 89 55 9c 76 1f 4c 89 ea 4c 89 e6 48 c7 c7 e8 a6 5e a0 31 c0 e8 93 84 f0 e0 <0f> 0b 90 eb fe 66 0f 1f 44 00 00 48 89 58 10 48 8b 53 48 48 8b 
[  706.090905] RIP  [<ffffffffa05a2f0d>] btrfs_map_bio+0x8d/0x300 [btrfs]
[  706.098098]  RSP <ffff880610ce7c58>
[  706.102125] ---[ end trace 6e889d6d939ca117 ]---

-- Jim

> 
> Josef
> 
> 


