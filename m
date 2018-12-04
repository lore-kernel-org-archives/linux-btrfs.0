Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFEFC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4D32082D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E4D32082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbeLDLQs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 06:16:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:48204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727374AbeLDLQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 06:16:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5165AAA71;
        Tue,  4 Dec 2018 11:16:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AA36EDA7A3; Tue,  4 Dec 2018 12:16:25 +0100 (CET)
Date:   Tue, 4 Dec 2018 12:16:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] btrfs: scrub: fix circular locking dependency
 warning
Message-ID: <20181204111625.GK17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1543554924-17397-1-git-send-email-anand.jain@oracle.com>
 <1543554924-17397-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543554924-17397-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 30, 2018 at 01:15:23PM +0800, Anand Jain wrote:
> @@ -3757,10 +3757,13 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
>  
>  static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
>  {
> +	lockdep_assert_held(&fs_info->scrub_lock);
>  	if (--fs_info->scrub_workers_refcnt == 0) {
> +		mutex_unlock(&fs_info->scrub_lock);
>  		btrfs_destroy_workqueue(fs_info->scrub_workers);
>  		btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
>  		btrfs_destroy_workqueue(fs_info->scrub_parity_workers);
> +		mutex_lock(&fs_info->scrub_lock);
>  	}
>  	WARN_ON(fs_info->scrub_workers_refcnt < 0);
>  }

btrfs/011 lockdep warning is gone, but now there's a list corruption
reported by btrfs/073. I'm testing the 2 patches on top of current
master to avoid interference with misc-next patches.

btrfs/073               [11:07:19]
[ 3580.466293] run fstests btrfs/073at 2018-12-04 11:07:19
[ 3580.610367] BTRFS info (device vda): disk space caching is enabled
[ 3580.612809] BTRFS info (device vda): has skinny extents
[ 3580.876639] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 1 transid 5 /dev/vdb
[ 3580.880569] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 2 transid 5 /dev/vdc
[ 3580.882947] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 3 transid 5 /dev/vdd
[ 3580.885499] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 4 transid 5 /dev/vde
[ 3580.887972] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 5 transid 5 /dev/vdf
[ 3580.890394] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 6 transid 5 /dev/vdg
[ 3580.893729] BTRFS: device fsid d452261d-c956-4b54-aab9-8318c3c211fcdevid 7 transid 5 /dev/vdh
[ 3580.903180] BTRFS info (device vdb): disk space caching is enabled
[ 3580.904538] BTRFS info (device vdb): has skinny extents
[ 3580.905322] BTRFS info (device vdb): flagging fs with big metadatafeature
[ 3580.908555] BTRFS info (device vdb): checking UUID tree
[ 3580.951440] ------------[ cut here ]------------
[ 3580.954122] list_add corruption. prev->next should be next(ffffa189faa9acc8), but was ffffa189faa9adc0. (prev=ffffa189faa9a480).
[ 3580.960061] WARNING: CPU: 0 PID: 24578 at lib/list_debug.c:28__list_add_valid+0x4d/0x70
[ 3580.962346] BTRFS info (device vdb): use no compression, level 0
[ 3580.963694] Modules linked in: dm_flakey dm_mod btrfs libcrc32c xorzstd_decompress zstd_compress xxhash raid6_pq loop
[ 3580.963702] CPU: 0 PID: 24578 Comm: btrfs Not tainted4.20.0-rc5-default+ #366
[ 3580.963703] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[ 3580.963706] RIP: 0010:__list_add_valid+0x4d/0x70
[ 3580.963708] RSP: 0018:ffffb72d88817b90 EFLAGS: 00010286
[ 3580.963709] RAX: 0000000000000000 RBX: ffffb72d88817c10 RCX:0000000000000000
[ 3580.963710] RDX: 0000000000000002 RSI: 0000000000000001 RDI:ffffffff860c4c1d
[ 3580.963710] RBP: ffffa189faa9acc8 R08: 0000000000000001 R09:0000000000000000
[ 3580.963714] R10: 0000000000000000 R11: ffffffff882a0a2d R12:ffffa189faa9ac70
[ 3580.966020] BTRFS info (device vdb): disk space caching is enabled
[ 3580.967721] R13: ffffa189faa9a480 R14: ffffa189faa9ac70 R15:ffffa189faa9ac78
[ 3580.967724] FS:  00007f04289d1700(0000) GS:ffffa189fd400000(0000)knlGS:0000000000000000
[ 3580.967725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3580.967725] CR2: 00007f7b58b034ac CR3: 00000000699d9000 CR4:00000000000006f0
[ 3580.967729] Call Trace:
[ 3580.967736]  __mutex_add_waiter+0x34/0x70
[ 3580.967743]  ? drain_workqueue+0x1e/0x180
[ 3580.994465]  __mutex_lock+0x134/0x9d0
[ 3580.995526]  ? __schedule+0x2eb/0xb20
[ 3580.996584]  ? drain_workqueue+0x1e/0x180
[ 3580.997727]  drain_workqueue+0x1e/0x180
[ 3580.998793]  destroy_workqueue+0x17/0x240
[ 3580.999879]  btrfs_destroy_workqueue+0x57/0x200 [btrfs]
[ 3581.001148]  scrub_workers_put+0x6c/0x90 [btrfs]
[ 3581.002257]  btrfs_scrub_dev+0x2f6/0x590 [btrfs]
[ 3581.003370]  ? __sb_start_write+0x12c/0x1d0
[ 3581.004450]  ? mnt_want_write_file+0x24/0x60
[ 3581.005613]  btrfs_ioctl+0xfc7/0x2f00 [btrfs]
[ 3581.006361]  ? get_task_io_context+0x2d/0x90
[ 3581.007025]  ? do_vfs_ioctl+0xa2/0x6d0
[ 3581.007699]  do_vfs_ioctl+0xa2/0x6d0
[ 3581.008603]  ? __fget+0x109/0x1e0
[ 3581.009413]  ksys_ioctl+0x3a/0x70
[ 3581.010326]  __x64_sys_ioctl+0x16/0x20
[ 3581.011234]  do_syscall_64+0x54/0x180
[ 3581.012143]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3581.013213] RIP: 0033:0x7f042bac9aa7
[ 3581.014133] Code: 00 00 90 48 8b 05 f1 83 2c 00 64 c7 00 26 00 00 0048 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c1 83 2c 00 f7 d8 64 89 01 48
[ 3581.018486] RSP: 002b:00007f04289d0d38 EFLAGS: 00000246 ORIG_RAX:0000000000000010
[ 3581.019703] RAX: ffffffffffffffda RBX: 000055c05475de10 RCX:00007f042bac9aa7
[ 3581.021465] RDX: 000055c05475de10 RSI: 00000000c400941b RDI:0000000000000003
[ 3581.023120] RBP: 0000000000000000 R08: 00007f04289d1700 R09:0000000000000000
[ 3581.024968] R10: 00007f04289d1700 R11: 0000000000000246 R12:00007ffd6b29a03e
[ 3581.027977] R13: 00007ffd6b29a03f R14: 00007ffd6b29a040 R15:0000000000000000
[ 3581.029767] irq event stamp: 0
[ 3581.030631] hardirqs last  enabled at (0): [<0000000000000000>](null)
[ 3581.032630] hardirqs last disabled at (0): [<ffffffff8605c23b>]copy_process.part.72+0x86b/0x1e20
[ 3581.034970] softirqs last  enabled at (0): [<ffffffff8605c23b>]copy_process.part.72+0x86b/0x1e20
[ 3581.037224] softirqs last disabled at (0): [<0000000000000000>](null)
[ 3581.038955] ---[ end trace f0e217183915884a ]---
