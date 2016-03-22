Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbcCVDIz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 23:08:55 -0400
Date: Tue, 22 Mar 2016 11:08:53 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: check for general protection fault traces in
 _check_dmesg
Message-ID: <20160322030853.GG11419@eguan.usersys.redhat.com>
References: <1458588218-30878-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458588218-30878-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 07:23:38PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> While writing a test case for overlayfs I noticed that _check_dmesg()
> did not detect general protection fault traces like the following:
> 
> [15277.026108] run fstests overlay/002 at 2016-03-21 18:42:27
> [15277.933179] general protection fault: 0000 [#11] PREEMPT SMP DEBUG_PAGEALLOC
> [15277.935427] Modules linked in: btrfs overlay ppdev crc32c_generic evdev xor raid6_pq psmouse pcspkr sg serio_raw acpi_cpufreq parport_pc parport tpm_tis i2c_piix4
> [15277.936011] CPU: 15 PID: 22762 Comm: xfs_io Tainted: G      D         4.5.0-rc6-btrfs-next-26+ #1
> [15277.936011] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS by qemu-project.org 04/01/2014
> [15277.936011] task: ffff88001f6f1340 ti: ffff88000a3f8000 task.ti: ffff88000a3f8000
> [15277.936011] RIP: 0010:[<ffffffffa030b7ab>]  [<ffffffffa030b7ab>] btrfs_sync_file+0x11b/0x3e9 [btrfs]
> [15277.936011] RSP: 0018:ffff88000a3fbe40  EFLAGS: 00010286
> [15277.936011] RAX: 0000000080000000 RBX: ffff8800b0152c88 RCX: 0000000000000001
> [15277.936011] RDX: 0000000000000001 RSI: ffffffff8148fec0 RDI: 00000000ffffffff
> [15277.936011] RBP: ffff88000a3fbec0 R08: 0000000000000001 R09: 0000000000000000
> [15277.936011] R10: ffff88000a3fbe40 R11: 0000000000000246 R12: 6e756f635f657269
> [15277.936011] R13: 0000000000000000 R14: 00000000014655a0 R15: ffff88017dd25e40
> [15277.936011] FS:  00007f27f0e1f700(0000) GS:ffff88023ede0000(0000) knlGS:0000000000000000
> [15277.936011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15277.936011] CR2: 00007f27f0e2f000 CR3: 000000013aadf000 CR4: 00000000000006e0
> [15277.936011] Stack:
> [15277.936011]  ffffffff8108b5cc ffff88000a3fbec0 0000000000000246 ffff880125abaed0
> [15277.936011]  ffff8800b0152d60 8000000000000000 7fffffffffffffff 0000000000000246
> [15277.936011]  0000000000000246 ffffffff81074f9b ffffffff8104357c ffff88017dd25e40
> [15277.936011] Call Trace:
> [15277.936011]  [<ffffffff8108b5cc>] ? arch_local_irq_save+0x9/0xc
> [15277.936011]  [<ffffffff81074f9b>] ? ___might_sleep+0xce/0x217
> [15277.936011]  [<ffffffff8104357c>] ? __do_page_fault+0x3c0/0x43a
> [15277.936011]  [<ffffffff811a2351>] vfs_fsync_range+0x8c/0x9e
> [15277.936011]  [<ffffffff811a237f>] vfs_fsync+0x1c/0x1e
> [15277.936011]  [<ffffffff811a24d6>] do_fsync+0x31/0x4a
> [15277.936011]  [<ffffffff811a2700>] SyS_fsync+0x10/0x14
> [15277.936011]  [<ffffffff81493617>] entry_SYSCALL_64_fastpath+0x12/0x6b
> [15277.936011] Code: 85 c0 0f 85 e2 02 00 00 48 8b 45 b0 31 f6 4c 29 e8 48 ff c0 48 89 45 a8 48 8d 83 d8 00 00 00 48 89 c7 48 89 45 a0 e8 fc 43 18 e1 <f0> 41 ff 84 24
> [15277.936011] RIP  [<ffffffffa030b7ab>] btrfs_sync_file+0x11b/0x3e9 [btrfs]
> [15277.936011]  RSP <ffff88000a3fbe40>
> [15277.974598] ---[ end trace 721e14960eb939c1 ]---
> 
> So teach it to look out for such traces.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

> ---
>  common/rc | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/rc b/common/rc
> index 16f5a43..51d9753 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3420,6 +3420,7 @@ _check_dmesg()
>  	     -e "Internal error" \
>  	     -e "INFO: suspicious RCU usage" \
>  	     -e "INFO: possible circular locking dependency detected" \
> +	     -e "general protection fault:" \
>  	     $seqres.dmesg
>  	if [ $? -eq 0 ]; then
>  		echo "_check_dmesg: something found in dmesg (see $seqres.dmesg)"
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
