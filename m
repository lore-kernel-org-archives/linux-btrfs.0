Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB12C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 17:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57AEF223DD
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 17:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57AEF223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbeKNDGm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 22:06:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:50146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730730AbeKNDGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 22:06:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4B5CB69F
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 17:07:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6B573DAD3E; Tue, 13 Nov 2018 18:07:25 +0100 (CET)
Date:   Tue, 13 Nov 2018 18:07:24 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20181113170724.GE24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112213332.GS24115@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
> > This patchset can be fetched from github:
> > https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_rebased
> > 
> > Which is based on v4.20-rc1.
> 
> Thanks, I'll add it to for-next soon.

During test generic/517, the logs were full of the warning below. The reference
test on current master, effectively misc-4.20 which was used as base of your
branch did not get the warning.

[11540.167829] BTRFS: end < start 2519039 2519040
[11540.170513] WARNING: CPU: 1 PID: 539 at fs/btrfs/extent_io.c:436 insert_state+0xd8/0x100 [btrfs]
[11540.174411] Modules linked in: dm_thin_pool dm_persistent_data dm_bufio dm_bio_prison btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq dm_mod loop [last unloaded: libcrc32c]
[11540.178279] CPU: 1 PID: 539 Comm: xfs_io Tainted: G      D W         4.20.0-rc1-default+ #329
[11540.180616] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[11540.183754] RIP: 0010:insert_state+0xd8/0x100 [btrfs]
[11540.189173] RSP: 0018:ffffa0d245eafb20 EFLAGS: 00010282
[11540.189885] RAX: 0000000000000000 RBX: ffff9f0bb3267320 RCX: 0000000000000000
[11540.191646] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffffffa40c400d
[11540.192942] RBP: 0000000000266fff R08: 0000000000000001 R09: 0000000000000000
[11540.193871] R10: 0000000000000000 R11: ffffffffa629da2d R12: ffff9f0ba0281c60
[11540.195527] R13: 0000000000267000 R14: ffffa0d245eafb98 R15: ffffa0d245eafb90
[11540.197026] FS:  00007fa338eb4b80(0000) GS:ffff9f0bbd600000(0000) knlGS:0000000000000000
[11540.198251] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11540.199698] CR2: 00007fa33873bfb8 CR3: 000000006fb6e000 CR4: 00000000000006e0
[11540.201428] Call Trace:
[11540.202164]  __set_extent_bit+0x43b/0x5b0 [btrfs]
[11540.203223]  lock_extent_bits+0x5d/0x210 [btrfs]
[11540.204346]  ? _raw_spin_unlock+0x24/0x40
[11540.205381]  ? test_range_bit+0xdf/0x130 [btrfs]
[11540.206573]  lock_extent_range+0xb8/0x150 [btrfs]
[11540.207696]  btrfs_double_extent_lock+0x78/0xb0 [btrfs]
[11540.208988]  btrfs_extent_same_range+0x131/0x4e0 [btrfs]
[11540.210237]  btrfs_remap_file_range+0x337/0x350 [btrfs]
[11540.211448]  vfs_dedupe_file_range_one+0x141/0x150
[11540.212622]  vfs_dedupe_file_range+0x146/0x1a0
[11540.213795]  do_vfs_ioctl+0x520/0x6c0
[11540.214711]  ? __fget+0x109/0x1e0
[11540.215616]  ksys_ioctl+0x3a/0x70
[11540.216233]  __x64_sys_ioctl+0x16/0x20
[11540.216860]  do_syscall_64+0x54/0x180
[11540.217409]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11540.218126] RIP: 0033:0x7fa338a4daa7

