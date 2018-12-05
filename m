Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E45C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 16:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00A4120892
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 16:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00A4120892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbeLEQOD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 11:14:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:39936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726918AbeLEQOD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 11:14:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82FCAAF5C
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 16:14:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 13DB8DAB92; Wed,  5 Dec 2018 17:13:40 +0100 (CET)
Date:   Wed, 5 Dec 2018 17:13:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv3] btrfs: Fix error handling in
 btrfs_cleanup_ordered_extents
Message-ID: <20181205161339.GC3905@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181121151052.18744-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121151052.18744-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 05:10:52PM +0200, Nikolay Borisov wrote:
> Running btrfs/124 in a loop hung up on me sporadically with the
> following call trace:
> 	btrfs           D    0  5760   5324 0x00000000
> 	Call Trace:
> 	 ? __schedule+0x243/0x800
> 	 schedule+0x33/0x90
> 	 btrfs_start_ordered_extent+0x10c/0x1b0 [btrfs]
> 	 ? wait_woken+0xa0/0xa0
> 	 btrfs_wait_ordered_range+0xbb/0x100 [btrfs]
> 	 btrfs_relocate_block_group+0x1ff/0x230 [btrfs]
> 	 btrfs_relocate_chunk+0x49/0x100 [btrfs]
> 	 btrfs_balance+0xbeb/0x1740 [btrfs]
> 	 btrfs_ioctl_balance+0x2ee/0x380 [btrfs]
> 	 btrfs_ioctl+0x1691/0x3110 [btrfs]
> 	 ? lockdep_hardirqs_on+0xed/0x180
> 	 ? __handle_mm_fault+0x8e7/0xfb0
> 	 ? _raw_spin_unlock+0x24/0x30
> 	 ? __handle_mm_fault+0x8e7/0xfb0
> 	 ? do_vfs_ioctl+0xa5/0x6e0
> 	 ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> 	 do_vfs_ioctl+0xa5/0x6e0
> 	 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
> 	 ksys_ioctl+0x3a/0x70
> 	 __x64_sys_ioctl+0x16/0x20
> 	 do_syscall_64+0x60/0x1b0
> 	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> This happens because during page writeback it's valid for
> writepage_delalloc to instantiate a delalloc range which doesn't
> belong to the page currently being written back.
> 
> The reason this case is valid is due to find_lock_delalloc_range
> returning any available range after the passed delalloc_start and
> ignorting whether the page under writeback is within that range.
> In turn ordered extents (OE) are always created for the returned range
> from find_lock_delalloc_range. If, however, a failure occurs while OE
> are being created then the clean up code in btrfs_cleanup_ordered_extents
> will be called.
> 
> Unfortunately the code in btrfs_cleanup_ordered_extents doesn't consider
> the case of such 'foreign' range being processed and instead it always
> assumes that the range OE are created for belongs to the page. This
> leads to the first page of such foregin range to not be cleaned up since
> it's deliberately missed skipped by the current cleaning up code.
> 
> Fix this by correctly checking whether the current page belongs to the
> range being instantiated and if so adjsut the range parameters
> passed for cleaning up. If it doesn't, then just clean the whole OE
> range directly.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
