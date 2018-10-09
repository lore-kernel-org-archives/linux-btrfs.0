Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAB7C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D810F2087D
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D810F2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbeJIXTh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:19:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:50666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726418AbeJIXTh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 19:19:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47D02B06E;
        Tue,  9 Oct 2018 16:01:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 302E4DAD2B; Tue,  9 Oct 2018 18:01:56 +0200 (CEST)
Date:   Tue, 9 Oct 2018 18:01:56 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix warning when replaying log after fsync of a
 tmpfile
Message-ID: <20181009160156.GJ29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181008101255.17110-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008101255.17110-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 08, 2018 at 11:12:55AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When replaying a log which contains a tmpfile (which necessarily has a
> link count of 0) we end up calling inc_nlink(), at
> fs/btrfs/tree-log.c:replay_one_buffer(), which produces a warning like
> the following:
> 
>   [195191.943673] WARNING: CPU: 0 PID: 6924 at fs/inode.c:342 inc_nlink+0x33/0x40
>   [195191.943674] Modules linked in: btrfs dm_flakey dm_mod xor raid6_pq libcrc32c kvm_intel bochs_drm ttm kvm drm_kms_helper drm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd cryptd glue_helper joydev sg button evdev pcspkr qemu_fw_cfg serio_raw parport_pc ppdev lp parport ip_tables x_tables autofs4 ext4 crc32c_generic crc16 mbcache jbd2 fscrypto sd_mod virtio_scsi ata_generic virtio_pci virtio_ring virtio ata_piix floppy crc32c_intel libata psmouse e1000 scsi_mod i2c_piix4 [last unloaded: btrfs]
>   [195191.943723] CPU: 0 PID: 6924 Comm: mount Not tainted 4.19.0-rc6-btrfs-next-38 #1
>   [195191.943724] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
>   [195191.943726] RIP: 0010:inc_nlink+0x33/0x40
>   [195191.943727] Code: c0 74 07 83 c0 01 89 47 48 c3 f6 87 d1 00 00 00 04 74 17 48 8b 47 28 f0 48 83 a8 70 07 00 00 01 8b 47 48 83 c0 01 89 47 48 c3 <0f> 0b eb e5 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 65 ff 05 54
>   [195191.943728] RSP: 0018:ffffb96e425e3870 EFLAGS: 00010246
>   [195191.943730] RAX: 0000000000000000 RBX: ffff8c0d1e6af4f0 RCX: 0000000000000006
>   [195191.943731] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8c0d1e6af4f0
>   [195191.943731] RBP: 0000000000000097 R08: 0000000000000001 R09: 0000000000000000
>   [195191.943732] R10: 0000000000000000 R11: 0000000000000000 R12: ffffb96e425e3a60
>   [195191.943733] R13: ffff8c0d10cff0c8 R14: ffff8c0d0d515348 R15: ffff8c0d78a1b3f8
>   [195191.943735] FS:  00007f570ee24480(0000) GS:ffff8c0dfb200000(0000) knlGS:0000000000000000
>   [195191.943736] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [195191.943737] CR2: 00005593286277c8 CR3: 00000000bb8f2006 CR4: 00000000003606f0
>   [195191.943739] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   [195191.943740] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   [195191.943741] Call Trace:
>   [195191.943778]  replay_one_buffer+0x797/0x7d0 [btrfs]
>   [195191.943802]  walk_up_log_tree+0x1c1/0x250 [btrfs]
>   [195191.943809]  ? rcu_read_lock_sched_held+0x3f/0x70
>   [195191.943825]  walk_log_tree+0xae/0x1d0 [btrfs]
>   [195191.943840]  btrfs_recover_log_trees+0x1d7/0x4d0 [btrfs]
>   [195191.943856]  ? replay_dir_deletes+0x280/0x280 [btrfs]
>   [195191.943870]  open_ctree+0x1c3b/0x22a0 [btrfs]
>   [195191.943887]  btrfs_mount_root+0x6b4/0x800 [btrfs]
>   [195191.943894]  ? rcu_read_lock_sched_held+0x3f/0x70
>   [195191.943899]  ? pcpu_alloc+0x55b/0x7c0
>   [195191.943906]  ? mount_fs+0x3b/0x140
>   [195191.943908]  mount_fs+0x3b/0x140
>   [195191.943912]  ? __init_waitqueue_head+0x36/0x50
>   [195191.943916]  vfs_kern_mount+0x62/0x160
>   [195191.943927]  btrfs_mount+0x134/0x890 [btrfs]
>   [195191.943936]  ? rcu_read_lock_sched_held+0x3f/0x70
>   [195191.943938]  ? pcpu_alloc+0x55b/0x7c0
>   [195191.943943]  ? mount_fs+0x3b/0x140
>   [195191.943952]  ? btrfs_remount+0x570/0x570 [btrfs]
>   [195191.943954]  mount_fs+0x3b/0x140
>   [195191.943956]  ? __init_waitqueue_head+0x36/0x50
>   [195191.943960]  vfs_kern_mount+0x62/0x160
>   [195191.943963]  do_mount+0x1f9/0xd40
>   [195191.943967]  ? memdup_user+0x4b/0x70
>   [195191.943971]  ksys_mount+0x7e/0xd0
>   [195191.943974]  __x64_sys_mount+0x21/0x30
>   [195191.943977]  do_syscall_64+0x60/0x1b0
>   [195191.943980]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>   [195191.943983] RIP: 0033:0x7f570e4e524a
>   [195191.943985] Code: 48 8b 0d 51 fc 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1e fc 2a 00 f7 d8 64 89 01 48

Minor nit: if the Code: and Modules: lines are not essential for the
report, you can remove them from the trace as the lines are quite long.
I've removed them in the committed patch.

>   [195191.943986] RSP: 002b:00007ffd83589478 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
>   [195191.943989] RAX: ffffffffffffffda RBX: 0000563f335b2060 RCX: 00007f570e4e524a
>   [195191.943990] RDX: 0000563f335b2240 RSI: 0000563f335b2280 RDI: 0000563f335b2260
>   [195191.943992] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
>   [195191.943993] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 0000563f335b2260
>   [195191.943994] R13: 0000563f335b2240 R14: 0000000000000000 R15: 00000000ffffffff
>   [195191.944002] irq event stamp: 8688
>   [195191.944010] hardirqs last  enabled at (8687): [<ffffffff9cb004c3>] console_unlock+0x503/0x640
>   [195191.944012] hardirqs last disabled at (8688): [<ffffffff9ca037dd>] trace_hardirqs_off_thunk+0x1a/0x1c
>   [195191.944018] softirqs last  enabled at (8638): [<ffffffff9cc0a5d1>] __set_page_dirty_nobuffers+0x101/0x150
>   [195191.944020] softirqs last disabled at (8634): [<ffffffff9cc26bbe>] wb_wakeup_delayed+0x2e/0x60
>   [195191.944022] ---[ end trace 5d6e873a9a0b811a ]---
> 
> This happens because the inode does not have the flag I_LINKABLE set,
> which is a runtime only flag, not meant to be persisted, set when the
> inode is created through open(2) if the flag O_EXCL is not passed to it.
> Except for the warning, there are no other consequences (like corruptions
> or metadata inconsistencies).
> 
> Since it's pointless to replay a tmpfile as it would be deleted in a
> later phase of the log replay procedure (it has a link count of 0), fix
> this by not logging tmpfiles and if a tmpfile is found in a log (created
> by a kernel without this change), skip the replay of the inode.
> 
> A test case for fstests follows soon.
> 
> Reported-by: Martin Steigerwald <martin@lichtvoll.de>
> Link: https://lore.kernel.org/linux-btrfs/3666619.NTnn27ZJZE@merkaba/
> Fixes: 471d557afed1 ("Btrfs: fix loss of prealloc extents past i_size after fsync log replay")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks, the tmpfile logging logic makes sense to me. Patch added to
misc-next and queued for 4.20 and I've added stable tag for 4.9+.
