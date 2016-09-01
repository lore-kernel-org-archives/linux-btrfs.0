Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44381 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751167AbcIAKIz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 06:08:55 -0400
Subject: Re: [lkp] [btrfs] 18513091af: WARNING: CPU: 3 PID: 14091 at
 fs/btrfs/extent-tree.c:10008 btrfs_free_block_groups+0x29b/0x420 [btrfs]
To: kernel test robot <xiaolong.ye@intel.com>
References: <20160901083201.GB19474@yexl-desktop>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        <lkp@01.org>, <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57C7FD3C.5090206@cn.fujitsu.com>
Date: Thu, 1 Sep 2016 18:04:44 +0800
MIME-Version: 1.0
In-Reply-To: <20160901083201.GB19474@yexl-desktop>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for your report.
I've sent a patch to btrfs community to fix this issue, currently it's 
not merged.

Regards,
Xiaoguang Wang

On 09/01/2016 04:32 PM, kernel test robot wrote:
> FYI, we noticed the following commit:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 18513091af9483ba84328d42092bd4d42a3c958f ("btrfs: update btrfs_space_info's bytes_may_use timely")
>
> in testcase: xfstests
> with following parameters:
>
> 	disk: 4HDD
> 	fs: btrfs
> 	test: generic-quick1
>
>
> on test machine: qemu-system-x86_64 -enable-kvm -cpu qemu64,+ssse3 -smp 4 -m 4G
>
> caused below changes:
>
>
> +---------------------------------------------------------------------------+------------+------------+
> |                                                                           | 4824f1f412 | 18513091af |
> +---------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                            | 8          | 0          |
> | boot_failures                                                             | 0          | 4          |
> | WARNING:at_fs/btrfs/extent-tree.c:#btrfs_free_block_groups[btrfs]         | 0          | 4          |
> +---------------------------------------------------------------------------+------------+------------+
>
>
>
> [  279.132633] BTRFS info (device dm-0): has skinny extents
> [  279.242965] BTRFS info (device dm-0): checking UUID tree
> [  279.522977] ------------[ cut here ]------------
> [  279.524657] WARNING: CPU: 3 PID: 14091 at fs/btrfs/extent-tree.c:10008 btrfs_free_block_groups+0x29b/0x420 [btrfs]
> [  279.531051] Modules linked in: dm_flakey btrfs xor raid6_pq dm_mod rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver sg sr_mod cdrom ata_generic pata_acpi snd_pcm snd_timer ata_piix snd soundcore pcspkr ppdev serio_raw libata floppy i2c_piix4 parport_pc parport acpi_cpufreq
> [  279.550377] CPU: 3 PID: 14091 Comm: umount Not tainted 4.7.0-rc6-00087-g1851309 #1
> [  279.556229] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> [  279.562315]  0000000000000000 ffff880124b7fcf0 ffffffff8143669b 0000000000000000
> [  279.568558]  0000000000000000 ffff880124b7fd30 ffffffff8107d3fb 0000271800000000
> [  279.574784]  ffff88007e965288 ffff8800aacb4000 ffff88007e965200 ffff88007e964e00
> [  279.581047] Call Trace:
> [  279.582259]  [<ffffffff8143669b>] dump_stack+0x63/0x88
> [  279.587003]  [<ffffffff8107d3fb>] __warn+0xcb/0xf0
> [  279.588640]  [<ffffffff8107d4ed>] warn_slowpath_null+0x1d/0x20
> [  279.593536]  [<ffffffffa02a708b>] btrfs_free_block_groups+0x29b/0x420 [btrfs]
> [  279.598666]  [<ffffffffa02b9092>] close_ctree+0x192/0x370 [btrfs]
> [  279.600538]  [<ffffffff8121f1e9>] ? evict_inodes+0x189/0x1a0
> [  279.605395]  [<ffffffffa02899c9>] btrfs_put_super+0x19/0x20 [btrfs]
> [  279.610339]  [<ffffffff81203acf>] generic_shutdown_super+0x6f/0x100
> [  279.612236]  [<ffffffff81203df2>] kill_anon_super+0x12/0x20
> [  279.617083]  [<ffffffffa028a7a8>] btrfs_kill_super+0x18/0x110 [btrfs]
> [  279.622070]  [<ffffffff81203fa3>] deactivate_locked_super+0x43/0x70
> [  279.623980]  [<ffffffff8120448a>] deactivate_super+0x5a/0x60
> [  279.628770]  [<ffffffff8122288f>] cleanup_mnt+0x3f/0x90
> [  279.630304]  [<ffffffff81222922>] __cleanup_mnt+0x12/0x20
> [  279.634894]  [<ffffffff8109b138>] task_work_run+0x88/0xc0
> [  279.636419]  [<ffffffff81003312>] exit_to_usermode_loop+0xc2/0xd0
> [  279.638171]  [<ffffffff81003c31>] syscall_return_slowpath+0xa1/0xb0
> [  279.639841]  [<ffffffff8190d37a>] entry_SYSCALL_64_fastpath+0xa2/0xa4
> [  279.658835] ---[ end trace 4976d490d5aef958 ]---
> [  279.660401] BTRFS: space_info 1 has 8126464 free, is not full
>
>
>
> To reproduce:
>
>          git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>          cd lkp-tests
>          bin/lkp install job.yaml  # job file is attached in this email
>          bin/lkp run     job.yaml
>
>
>
> Thanks,
> Xiaolong
>
>



