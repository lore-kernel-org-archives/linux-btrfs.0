Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6F1C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 16:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9A02080A
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 16:31:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B9A02080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbeJaBZe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 21:25:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:40232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726985AbeJaBZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 21:25:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BCB69B123;
        Tue, 30 Oct 2018 16:31:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 493FBDAB9E; Tue, 30 Oct 2018 17:31:08 +0100 (CET)
Date:   Tue, 30 Oct 2018 17:31:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix cur_offset in the error case for nocow
Message-ID: <20181030163107.GC9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org
References: <1540893844-3480-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540893844-3480-1-git-send-email-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 06:04:04PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> When the cow_file_range fail, the related resources are
> unlocked according to the range (start-end), so the unlock
> cannot be repeated in run_delalloc_nocow.
> 
> In some cases (e.g. cur_offset <= end && cow_start!= -1),
> cur_offset is not updated correctly, so move the cur_offset
> update before cow_file_range.
> 
> ------------[ cut here ]------------
> kernel BUG at mm/page-writeback.c:2663!
> Internal error: Oops - BUG: 0 [#1] SMP
> CPU: 3 PID: 31525 Comm: kworker/u8:7 Tainted: P O
> Hardware name: Realtek_RTD1296 (DT)
> Workqueue: writeback wb_workfn (flush-btrfs-1)
> task: ffffffc076db3380 ti: ffffffc02e9ac000 task.ti: ffffffc02e9ac000
> PC is at clear_page_dirty_for_io+0x1bc/0x1e8
> LR is at clear_page_dirty_for_io+0x14/0x1e8
> pc : [<ffffffc00033c91c>] lr : [<ffffffc00033c774>] pstate: 40000145
> sp : ffffffc02e9af4f0
> Process kworker/u8:7 (pid: 31525, stack limit = 0xffffffc02e9ac020)
> Call trace:
> [<ffffffc00033c91c>] clear_page_dirty_for_io+0x1bc/0x1e8
> [<ffffffbffc514674>] extent_clear_unlock_delalloc+0x1e4/0x210 [btrfs]
> [<ffffffbffc4fb168>] run_delalloc_nocow+0x3b8/0x948 [btrfs]
> [<ffffffbffc4fb948>] run_delalloc_range+0x250/0x3a8 [btrfs]
> [<ffffffbffc514c0c>] writepage_delalloc.isra.21+0xbc/0x1d8 [btrfs]
> [<ffffffbffc516048>] __extent_writepage+0xe8/0x248 [btrfs]
> [<ffffffbffc51630c>] extent_write_cache_pages.isra.17+0x164/0x378 [btrfs]
> [<ffffffbffc5185a8>] extent_writepages+0x48/0x68 [btrfs]
> [<ffffffbffc4f5828>] btrfs_writepages+0x20/0x30 [btrfs]
> [<ffffffc00033d758>] do_writepages+0x30/0x88
> [<ffffffc0003ba0f4>] __writeback_single_inode+0x34/0x198
> [<ffffffc0003ba6c4>] writeback_sb_inodes+0x184/0x3c0
> [<ffffffc0003ba96c>] __writeback_inodes_wb+0x6c/0xc0
> [<ffffffc0003bac20>] wb_writeback+0x1b8/0x1c0
> [<ffffffc0003bb0f0>] wb_workfn+0x150/0x250
> [<ffffffc0002b0014>] process_one_work+0x1dc/0x388
> [<ffffffc0002b02f0>] worker_thread+0x130/0x500
> [<ffffffc0002b6344>] kthread+0x10c/0x110
> [<ffffffc000284590>] ret_from_fork+0x10/0x40
> Code: d503201f a9025bb5 a90363b7 f90023b9 (d4210000)
> ---[ end trace 65fecee7c2296f25 ]---
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>

As there's a reviewed-by I can fix the small issues at commit time, no
need to resend. Thanks.
