Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02058C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 12:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A101920825
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 12:39:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A101920825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbeKEV7a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:59:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:38622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727048AbeKEV7a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 16:59:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C011AD07;
        Mon,  5 Nov 2018 12:39:53 +0000 (UTC)
Subject: Re: [PATCH] Btrfs: fix infinite loop on inode eviction after
 deduplication of eof block
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181105111405.11752-1-fdmanana@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ad1c1b09-fa05-631f-f4da-f3b131c0fca8@suse.com>
Date:   Mon, 5 Nov 2018 14:39:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181105111405.11752-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 5.11.18 г. 13:14 ч., fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we attempt to deduplicate the last block of a file A into the middle of
> a file B, and file A's size is not a multiple of the block size, we end
> rounding the deduplication length to 0 bytes, to avoid the data corruption
> issue fixed by commit de02b9f6bb65 ("Btrfs: fix data corruption when
> deduplicating between different files"). However a length of zero will
> cause the insertion of an extent state with a start value greater (by 1)
> then the end value, leading to a corrupt extent state that will trigger a
> warning and cause chaos such as an infinite loop during inode eviction.
> Example trace:
> 
>  [96049.833585] ------------[ cut here ]------------
>  [96049.833714] WARNING: CPU: 0 PID: 24448 at fs/btrfs/extent_io.c:436 insert_state+0x101/0x120 [btrfs]
>  [96049.833767] CPU: 0 PID: 24448 Comm: xfs_io Not tainted 4.19.0-rc7-btrfs-next-39 #1
>  [96049.833768] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
>  [96049.833780] RIP: 0010:insert_state+0x101/0x120 [btrfs]
>  [96049.833783] RSP: 0018:ffffafd2c3707af0 EFLAGS: 00010282
>  [96049.833785] RAX: 0000000000000000 RBX: 000000000004dfff RCX: 0000000000000006
>  [96049.833786] RDX: 0000000000000007 RSI: ffff99045c143230 RDI: ffff99047b2168a0
>  [96049.833787] RBP: ffff990457851cd0 R08: 0000000000000001 R09: 0000000000000000
>  [96049.833787] R10: ffffafd2c3707ab8 R11: 0000000000000000 R12: ffff9903b93b12c8
>  [96049.833788] R13: 000000000004e000 R14: ffffafd2c3707b80 R15: ffffafd2c3707b78
>  [96049.833790] FS:  00007f5c14e7d700(0000) GS:ffff99047b200000(0000) knlGS:0000000000000000
>  [96049.833791] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [96049.833792] CR2: 00007f5c146abff8 CR3: 0000000115f4c004 CR4: 00000000003606f0
>  [96049.833795] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [96049.833796] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  [96049.833796] Call Trace:
>  [96049.833809]  __set_extent_bit+0x46c/0x6a0 [btrfs]
>  [96049.833823]  lock_extent_bits+0x6b/0x210 [btrfs]
>  [96049.833831]  ? _raw_spin_unlock+0x24/0x30
>  [96049.833841]  ? test_range_bit+0xdf/0x130 [btrfs]
>  [96049.833853]  lock_extent_range+0x8e/0x150 [btrfs]
>  [96049.833864]  btrfs_double_extent_lock+0x78/0xb0 [btrfs]
>  [96049.833875]  btrfs_extent_same_range+0x14e/0x550 [btrfs]
>  [96049.833885]  ? rcu_read_lock_sched_held+0x3f/0x70
>  [96049.833890]  ? __kmalloc_node+0x2b0/0x2f0
>  [96049.833899]  ? btrfs_dedupe_file_range+0x19a/0x280 [btrfs]
>  [96049.833909]  btrfs_dedupe_file_range+0x270/0x280 [btrfs]
>  [96049.833916]  vfs_dedupe_file_range_one+0xd9/0xe0
>  [96049.833919]  vfs_dedupe_file_range+0x131/0x1b0
>  [96049.833924]  do_vfs_ioctl+0x272/0x6e0
>  [96049.833927]  ? __fget+0x113/0x200
>  [96049.833931]  ksys_ioctl+0x70/0x80
>  [96049.833933]  __x64_sys_ioctl+0x16/0x20
>  [96049.833937]  do_syscall_64+0x60/0x1b0
>  [96049.833939]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>  [96049.833941] RIP: 0033:0x7f5c1478ddd7
>  [96049.833943] RSP: 002b:00007ffe15b196a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
>  [96049.833945] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5c1478ddd7
>  [96049.833946] RDX: 00005625ece322d0 RSI: 00000000c0189436 RDI: 0000000000000004
>  [96049.833947] RBP: 0000000000000000 R08: 00007f5c14a46f48 R09: 0000000000000040
>  [96049.833948] R10: 0000000000000541 R11: 0000000000000202 R12: 0000000000000000
>  [96049.833949] R13: 0000000000000000 R14: 0000000000000004 R15: 00005625ece322d0
>  [96049.833954] irq event stamp: 6196
>  [96049.833956] hardirqs last  enabled at (6195): [<ffffffff91b00663>] console_unlock+0x503/0x640
>  [96049.833958] hardirqs last disabled at (6196): [<ffffffff91a037dd>] trace_hardirqs_off_thunk+0x1a/0x1c
>  [96049.833959] softirqs last  enabled at (6114): [<ffffffff92600370>] __do_softirq+0x370/0x421
>  [96049.833964] softirqs last disabled at (6095): [<ffffffff91a8dd4d>] irq_exit+0xcd/0xe0
>  [96049.833965] ---[ end trace db7b05f01b7fa10c ]---
>  [96049.935816] R13: 0000000000000000 R14: 00005562e5259240 R15: 00007ffff092b910
>  [96049.935822] irq event stamp: 6584
>  [96049.935823] hardirqs last  enabled at (6583): [<ffffffff91b00663>] console_unlock+0x503/0x640
>  [96049.935825] hardirqs last disabled at (6584): [<ffffffff91a037dd>] trace_hardirqs_off_thunk+0x1a/0x1c
>  [96049.935827] softirqs last  enabled at (6328): [<ffffffff92600370>] __do_softirq+0x370/0x421
>  [96049.935828] softirqs last disabled at (6313): [<ffffffff91a8dd4d>] irq_exit+0xcd/0xe0
>  [96049.935829] ---[ end trace db7b05f01b7fa123 ]---
>  [96049.935840] ------------[ cut here ]------------
>  [96049.936065] WARNING: CPU: 1 PID: 24463 at fs/btrfs/extent_io.c:436 insert_state+0x101/0x120 [btrfs]
>  [96049.936107] CPU: 1 PID: 24463 Comm: umount Tainted: G        W         4.19.0-rc7-btrfs-next-39 #1
>  [96049.936108] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
>  [96049.936117] RIP: 0010:insert_state+0x101/0x120 [btrfs]
>  [96049.936119] RSP: 0018:ffffafd2c3637bc0 EFLAGS: 00010282
>  [96049.936120] RAX: 0000000000000000 RBX: 000000000004dfff RCX: 0000000000000006
>  [96049.936121] RDX: 0000000000000007 RSI: ffff990445cf88e0 RDI: ffff99047b2968a0
>  [96049.936122] RBP: ffff990457851cd0 R08: 0000000000000001 R09: 0000000000000000
>  [96049.936123] R10: ffffafd2c3637b88 R11: 0000000000000000 R12: ffff9904574301e8
>  [96049.936124] R13: 000000000004e000 R14: ffffafd2c3637c50 R15: ffffafd2c3637c48
>  [96049.936125] FS:  00007fe4b87e72c0(0000) GS:ffff99047b280000(0000) knlGS:0000000000000000
>  [96049.936126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [96049.936128] CR2: 00005562e52618d8 CR3: 00000001151c8005 CR4: 00000000003606e0
>  [96049.936129] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [96049.936131] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  [96049.936131] Call Trace:
>  [96049.936141]  __set_extent_bit+0x46c/0x6a0 [btrfs]
>  [96049.936154]  lock_extent_bits+0x6b/0x210 [btrfs]
>  [96049.936167]  btrfs_evict_inode+0x1e1/0x5a0 [btrfs]
>  [96049.936172]  evict+0xbf/0x1c0
>  [96049.936174]  dispose_list+0x51/0x80
>  [96049.936176]  evict_inodes+0x193/0x1c0
>  [96049.936180]  generic_shutdown_super+0x3f/0x110
>  [96049.936182]  kill_anon_super+0xe/0x30
>  [96049.936189]  btrfs_kill_super+0x13/0x100 [btrfs]
>  [96049.936191]  deactivate_locked_super+0x3a/0x70
>  [96049.936193]  cleanup_mnt+0x3b/0x80
>  [96049.936195]  task_work_run+0x93/0xc0
>  [96049.936198]  exit_to_usermode_loop+0xfa/0x100
>  [96049.936201]  do_syscall_64+0x17f/0x1b0
>  [96049.936202]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>  [96049.936204] RIP: 0033:0x7fe4b80cfb37
>  [96049.936206] RSP: 002b:00007ffff092b688 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>  [96049.936207] RAX: 0000000000000000 RBX: 00005562e5259060 RCX: 00007fe4b80cfb37
>  [96049.936208] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00005562e525faa0
>  [96049.936209] RBP: 00005562e525faa0 R08: 00005562e525f770 R09: 0000000000000015
>  [96049.936210] R10: 00000000000006b4 R11: 0000000000000246 R12: 00007fe4b85d1e64
>  [96049.936211] R13: 0000000000000000 R14: 00005562e5259240 R15: 00007ffff092b910
>  [96049.936211] R13: 0000000000000000 R14: 00005562e5259240 R15: 00007ffff092b910
>  [96049.936216] irq event stamp: 6616
>  [96049.936219] hardirqs last  enabled at (6615): [<ffffffff91b00663>] console_unlock+0x503/0x640
>  [96049.936219] hardirqs last disabled at (6616): [<ffffffff91a037dd>] trace_hardirqs_off_thunk+0x1a/0x1c
>  [96049.936222] softirqs last  enabled at (6328): [<ffffffff92600370>] __do_softirq+0x370/0x421
>  [96049.936222] softirqs last disabled at (6313): [<ffffffff91a8dd4d>] irq_exit+0xcd/0xe0
>  [96049.936223] ---[ end trace db7b05f01b7fa124 ]---
> 
> The second stack trace, from inode eviction, is repeated forever due to
> the infinite loop during eviction.
> 
> This is the same type of problem fixed way back in 2015 by commit
> 113e8283869b ("Btrfs: fix inode eviction infinite loop after extent_same
> ioctl") and commit ccccf3d67294 ("Btrfs: fix inode eviction infinite loop
> after cloning into it").
> 
> So fix this by returning immediately if the deduplication range length
> gets rounded down to 0 bytes, as there is nothing that needs to be done in
> such case.
> 
> Example reproducer:
> 
>  $ mkfs.btrfs -f /dev/sdb
>  $ mount /dev/sdb /mnt
> 
>  $ xfs_io -f -c "pwrite -S 0xe6 0 100" /mnt/foo
>  $ xfs_io -f -c "pwrite -S 0xe6 0 1M" /mnt/bar
> 
>  # Unmount the filesystem and mount it again so that we start without any
>  # extent state records when we ask for the deduplication.
>  $ umount /mnt
>  $ mount /dev/sdb /mnt
> 
>  $ xfs_io -c "dedupe /mnt/foo 0 500K 100" /mnt/bar
> 
>  # This unmount triggers the infinite loop.
>  $ umount /mnt
> 
> A test case for fstests will follow soon.
> 
> Fixes: de02b9f6bb65 ("Btrfs: fix data corruption when deduplicating between different files")
> CC: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d60b6caf09e8..f3134fc69880 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3486,6 +3486,8 @@ static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
>  			const u64 sz = BTRFS_I(src)->root->fs_info->sectorsize;
>  
>  			len = round_down(i_size_read(src), sz) - loff;
> +			if (len == 0)
> +				return 0;
>  			olen = len;
>  		}
>  	}
> 
