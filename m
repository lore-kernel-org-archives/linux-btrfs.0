Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E075EC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 16:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B95C2208E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 16:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732186AbfDXQP2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 12:15:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:54718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727393AbfDXQP2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 12:15:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06A71AE7D;
        Wed, 24 Apr 2019 16:15:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 47DB3DA85E; Wed, 24 Apr 2019 18:16:30 +0200 (CEST)
Date:   Wed, 24 Apr 2019 18:16:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: send, flush dellaloc in order to avoid data loss
Message-ID: <20190424161628.GY20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190415082936.2173-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415082936.2173-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 15, 2019 at 09:29:36AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When we set a subvolume to read-only mode we do not flush dellaloc for any
> of its inodes (except if the filesystem is mounted with -o flushoncommit),
> since it does not affect correctness for any subsequent operations - except
> for a future send operation. The send operation will not be able to see the
> delalloc data since the respective file extent items, inode item updates,
> backreferences, etc, have not hit yet the subvolume and extent trees.
> 
> Effectively this means data loss, since the send stream will not contain
> any data from existing delalloc. Another problem from this is that if the
> writeback starts and finishes while the send operation is in progress, we
> have the subvolume tree being being modified concurrently which can result
> in send failing unexpectedly with EIO or hitting runtime errors, assertion
> failures or hitting BUG_ONs, etc.
> 
> Simple reproducer:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ btrfs subvolume create /mnt/sv
>   $ xfs_io -f -c "pwrite -S 0xea 0 108K" /mnt/sv/foo
> 
>   $ btrfs property set /mnt/sv ro true
>   $ btrfs send -f /tmp/send.stream /mnt/sv
> 
>   $ od -t x1 -A d /mnt/sv/foo
>   0000000 ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea
>   *
>   0110592
> 
>   $ umount /mnt
>   $ mkfs.btrfs -f /dev/sdc
>   $ mount /dev/sdc /mnt
> 
>   $ btrfs receive -f /tmp/send.stream /mnt
>   $ echo $?
>   0
>   $ od -t x1 -A d /mnt/sv/foo
>   0000000
>   # ---> empty file
> 
> Since this a problem that affects send only, fix it in send by flushing
> dellaloc for all the roots used by the send operation before send starts
> to process the commit roots.
> 
> This is a problem that affects send since it was introduced (commit
> 31db9f7c23fbf7 ("Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive"))
> but backporting it to older kernels has some dependencies:
> 
> - For kernels between 3.19 and 4.20, it depends on commit 3cd24c698004d2
>   ("btrfs: use tagged writepage to mitigate livelock of snapshot") because
>   the function btrfs_start_delalloc_snapshot() does not exist before that
>   commit. So one has to either pick that commit or replace the calls to
>   btrfs_start_delalloc_snapshot() in this patch with calls to
>   btrfs_start_delalloc_inodes().
> 
> - For kernels older than 3.19 it also requires commit e5fa8f865b3324
>   ("Btrfs: ensure send always works on roots without orphans") because
>   it depends on the function ensure_commit_roots_uptodate() which that
>   commits introduced.
> 
> - No dependencies for 5.0+ kernels.

^^^ thanks for writing the backporting instructions.

> 
> A test case for fstests follows soon.
> 
> CC: stable@vger.kernel.org # 3.19+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
