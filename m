Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A3DC32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 09:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DCE620827
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 09:55:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DCE620827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbeKFTTc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 14:19:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:46374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729241AbeKFTTc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 14:19:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7250AD93;
        Tue,  6 Nov 2018 09:55:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C904DDA8C8; Tue,  6 Nov 2018 10:54:51 +0100 (CET)
Date:   Tue, 6 Nov 2018 10:54:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Btrfs: implement swap file support
Message-ID: <20181106095451.GG9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
References: <cover.1538072009.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1538072009.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 27, 2018 at 11:17:32AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> This series implements swap file support for Btrfs.
> 
> Changes from v8 [1]:
> 
> - Fixed a bug in btrfs_swap_activate() which would cause us to miss some
>   file extents if they were merged into one extent map entry.
> - Fixed build for !CONFIG_SWAP.
> - Changed all error messages to KERN_WARN.
> - Unindented long error messages.
> 
> I've Cc'd Jon and Al on patch 3 this time, so hopefully we can get an
> ack for that one, too.
> 
> Thanks!
> 
> 1: https://www.spinics.net/lists/linux-btrfs/msg82267.html
> 
> Omar Sandoval (6):
>   mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
>   mm: export add_swap_extent()
>   vfs: update swap_{,de}activate documentation
>   Btrfs: prevent ioctls from interfering with a swap file
>   Btrfs: rename get_chunk_map() and make it non-static
>   Btrfs: support swap files

fstest generic/472 reports an assertion failure. This is on the updated fstests
git (70c4067285b0bc076), though it should not matter:

[16597.002190] assertion failed: IS_ALIGNED(start, fs_info->sectorsize) && IS_ALIGNED(end + 1, fs_info->sectorsize), file: fs/btrfs/file-item.c, line: 319
[16597.016154] ------------[ cut here ]------------
[16597.020911] kernel BUG at fs/btrfs/ctree.h:3448!
[16597.025692] invalid opcode: 0000 [#1] PREEMPT SMP
[16597.030540] CPU: 1 PID: 2216 Comm: swapon Tainted: G        W         4.19.0-1.ge195904-vanilla+ #343
[16597.030542] Hardware name: empty empty/S3993, BIOS PAQEX0-3 02/24/2008
[16597.030617] RIP: 0010:btrfs_lookup_csums_range+0x3ee/0x6e0 [btrfs]
[16597.030623] RSP: 0018:ffff959a8210fc00 EFLAGS: 00010286
[16597.030626] RAX: 000000000000008b RBX: ffff959a8210fc40 RCX: 0000000000000000
[16597.030628] RDX: 0000000000000000 RSI: ffff89c766fd60a8 RDI: ffff89c766fd60a8
[16597.030630] RBP: 0000000000f10000 R08: 0000000000000001 R09: 0000000000000000
[16597.030631] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[16597.030633] R13: ffff89c74f47c000 R14: 0000000000000000 R15: 0000000000003e4f
[16597.030635] FS:  00007f3d80a18700(0000) GS:ffff89c766e00000(0000) knlGS:0000000000000000
[16597.030637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16597.030639] CR2: 00007f3d7fa733b0 CR3: 000000021e0b5000 CR4: 00000000000006e0
[16597.030640] Call Trace:
[16597.030657]  ? __mutex_unlock_slowpath+0x4b/0x2b0
[16597.142625]  ? btrfs_cross_ref_exist+0x6d/0xa0 [btrfs]
[16597.142674]  csum_exist_in_range+0x43/0xc2 [btrfs]
[16597.152938]  can_nocow_extent+0x442/0x4a0 [btrfs]
[16597.152993]  btrfs_swap_activate+0x19f/0x680 [btrfs]
[16597.162947]  __do_sys_swapon+0xdf8/0x1550
[16597.162965]  do_syscall_64+0x5c/0x1b0
[16597.162971]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[16597.162974] RIP: 0033:0x7f3d7fb1f067
[16597.198875] RSP: 002b:00007ffcf9c49808 EFLAGS: 00000202 ORIG_RAX: 00000000000000a7
[16597.198877] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3d7fb1f067
[16597.198879] RDX: 00007ffcf9c49910 RSI: 0000000000000000 RDI: 00007ffcf9c4a8f0
[16597.198884] RBP: 0000000000000000 R08: 00007f3d7fdd8c40 R09: 00007f3d8081dfc0
[16597.228520] R10: 000000001cc0c4fd R11: 0000000000000202 R12: 00000000004006a0
[16597.228522] R13: 00007ffcf9c498f0 R14: 0000000000000000 R15: 0000000000000000
[16597.311530] ---[ end trace f4dc8cabefc3e36d ]---
[16597.316318] RIP: 0010:btrfs_lookup_csums_range+0x3ee/0x6e0 [btrfs]
[16597.341828] RSP: 0018:ffff959a8210fc00 EFLAGS: 00010286
[16597.341834] RAX: 000000000000008b RBX: ffff959a8210fc40 RCX: 0000000000000000
[16597.354588] RDX: 0000000000000000 RSI: ffff89c766fd60a8 RDI: ffff89c766fd60a8
[16597.354590] RBP: 0000000000f10000 R08: 0000000000000001 R09: 0000000000000000
[16597.354592] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[16597.354593] R13: ffff89c74f47c000 R14: 0000000000000000 R15: 0000000000003e4f
[16597.354595] FS:  00007f3d80a18700(0000) GS:ffff89c766e00000(0000) knlGS:0000000000000000
[16597.354596] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16597.354598] CR2: 00007f3d7fa733b0 CR3: 000000021e0b5000 CR4: 00000000000006e0
