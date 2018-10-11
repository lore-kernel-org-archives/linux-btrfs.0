Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C18C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F01C2085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F01C2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbeJKWlc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:41:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:51742 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725984AbeJKWlc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:41:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02992B068;
        Thu, 11 Oct 2018 15:13:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2FE36DA862; Thu, 11 Oct 2018 17:13:48 +0200 (CEST)
Date:   Thu, 11 Oct 2018 17:13:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Message-ID: <20181011151346.GR29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:24:37PM +0200, Hans van Kranenburg wrote:
> This patch set contains an additional fix for a newly exposed bug after
> the previous attempt to fix a chunk allocator bug for new DUP chunks:
> 
> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
> 
> The DUP fix is "fix more DUP stripe size handling". I did that one
> before starting to change more things so it can be applied to earlier
> LTS kernels.
> 
> Besides that patch, which is fixing the bug in a way that is least
> intrusive, I added a bunch of other patches to help getting the chunk
> allocator code in a state that is a bit less error-prone and
> bug-attracting.
> 
> When running this and trying the reproduction scenario, I can now see
> that the created DUP device extent is 827326464 bytes long, which is
> good.
> 
> I wrote and tested this on top of linus 4.19-rc5. I still need to create
> a list of related use cases and test more things to at least walk
> through a bunch of obvious use cases to see if there's nothing exploding
> too quickly with these changes. However, I'm quite confident about it,
> so I'm sharing all of it already.
> 
> Any feedback and review is appreciated. Be gentle and keep in mind that
> I'm still very much in a learning stage regarding kernel development.

The patches look good, thanks. Problem is explained, preparatory work is
separated from the fix itself.

> The stable patches handling workflow is not 100% clear to me yet. I
> guess I have to add a Fixes: in the DUP patch which points to the
> previous commit 92e222df7b.

Almost nobody does it right, no worries. If you can identify a single
patch that introduces a bug then it's for Fixes:, otherwise a CC: stable
with version where it makes sense & applies is enough. I do that check
myself regardless of what's in the patch.

I ran the patches in a VM and hit a division-by-zero in test
fstests/btrfs/011, stacktrace below. First guess is that it's caused by
patch 3/6.

[ 3116.065595] BTRFS: device fsid e3bd8db5-304f-4b1a-8488-7791ea94088f devid 1 transid 5 /dev/vdb
[ 3116.071274] BTRFS: device fsid e3bd8db5-304f-4b1a-8488-7791ea94088f devid 2 transid 5 /dev/vdc
[ 3116.087086] BTRFS info (device vdb): disk space caching is enabled
[ 3116.088644] BTRFS info (device vdb): has skinny extents
[ 3116.089796] BTRFS info (device vdb): flagging fs with big metadata feature
[ 3116.093971] BTRFS info (device vdb): checking UUID tree
[ 3125.853755] BTRFS info (device vdb): dev_replace from /dev/vdb (devid 1) to /dev/vdd started
[ 3125.860269] divide error: 0000 [#1] PREEMPT SMP
[ 3125.861264] CPU: 1 PID: 6477 Comm: btrfs Not tainted 4.19.0-rc7-default+ #288
[ 3125.862841] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3125.865385] RIP: 0010:__btrfs_alloc_chunk+0x368/0xa70 [btrfs]
[ 3125.870541] RSP: 0018:ffffa4ea0409fa48 EFLAGS: 00010206
[ 3125.871862] RAX: 0000000004000000 RBX: ffff94e074374508 RCX: 0000000000000002
[ 3125.873587] RDX: 0000000000000000 RSI: ffff94e017818c80 RDI: 0000000002000000
[ 3125.874677] RBP: 0000000080800000 R08: 0000000000000000 R09: 0000000000000002
[ 3125.875816] R10: 0000000300000000 R11: 0000000080900000 R12: 0000000000000000
[ 3125.876742] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000002
[ 3125.877657] FS:  00007f6de34208c0(0000) GS:ffff94e07d600000(0000) knlGS:0000000000000000
[ 3125.878862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3125.880080] CR2: 00007ffe963d5ce8 CR3: 000000007659b000 CR4: 00000000000006e0
[ 3125.881485] Call Trace:
[ 3125.882105]  do_chunk_alloc+0x266/0x3e0 [btrfs]
[ 3125.882841]  btrfs_inc_block_group_ro+0x10e/0x160 [btrfs]
[ 3125.883875]  scrub_enumerate_chunks+0x18b/0x5d0 [btrfs]
[ 3125.884658]  ? is_module_address+0x11/0x30
[ 3125.885271]  ? wait_for_completion+0x160/0x190
[ 3125.885928]  btrfs_scrub_dev+0x1b8/0x5a0 [btrfs]
[ 3125.887767]  ? start_transaction+0xa1/0x470 [btrfs]
[ 3125.888648]  btrfs_dev_replace_start.cold.19+0x155/0x17e [btrfs]
[ 3125.889459]  btrfs_dev_replace_by_ioctl+0x35/0x60 [btrfs]
[ 3125.890251]  btrfs_ioctl+0x2a94/0x31d0 [btrfs]
[ 3125.890885]  ? do_sigaction+0x7c/0x210
[ 3125.891731]  ? do_vfs_ioctl+0xa2/0x6b0
[ 3125.892652]  do_vfs_ioctl+0xa2/0x6b0
[ 3125.893642]  ? do_sigaction+0x1a7/0x210
[ 3125.894665]  ksys_ioctl+0x3a/0x70
[ 3125.895523]  __x64_sys_ioctl+0x16/0x20
[ 3125.896339]  do_syscall_64+0x5a/0x1a0
[ 3125.896949]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3125.897638] RIP: 0033:0x7f6de28ecaa7
[ 3125.901313] RSP: 002b:00007ffe963da9c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3125.902486] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f6de28ecaa7
[ 3125.903538] RDX: 00007ffe963dae00 RSI: 00000000ca289435 RDI: 0000000000000003
[ 3125.904878] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 3125.905788] R10: 0000000000000008 R11: 0000000000000246 R12: 00007ffe963de26f
[ 3125.906700] R13: 0000000000000001 R14: 0000000000000004 R15: 000055fceeceb2a0
[ 3125.907954] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop
[ 3125.909342] ---[ end trace 5492bb467d3be2da ]---
[ 3125.910031] RIP: 0010:__btrfs_alloc_chunk+0x368/0xa70 [btrfs]
[ 3125.913600] RSP: 0018:ffffa4ea0409fa48 EFLAGS: 00010206
[ 3125.914595] RAX: 0000000004000000 RBX: ffff94e074374508 RCX: 0000000000000002
[ 3125.916209] RDX: 0000000000000000 RSI: ffff94e017818c80 RDI: 0000000002000000
[ 3125.917701] RBP: 0000000080800000 R08: 0000000000000000 R09: 0000000000000002
[ 3125.919209] R10: 0000000300000000 R11: 0000000080900000 R12: 0000000000000000
[ 3125.920782] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000002
[ 3125.922413] FS:  00007f6de34208c0(0000) GS:ffff94e07d600000(0000) knlGS:0000000000000000
[ 3125.924264] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3125.925627] CR2: 00007ffe963d5ce8 CR3: 000000007659b000 CR4: 00000000000006e0
