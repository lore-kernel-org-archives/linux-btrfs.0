Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6D5C6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 17:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3164E2064C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 17:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3164E2064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbeKBCYa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 22:24:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:39238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbeKBCY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 22:24:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F1FF9AF8A;
        Thu,  1 Nov 2018 17:20:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 43647DAAFC; Thu,  1 Nov 2018 18:20:25 +0100 (CET)
Date:   Thu, 1 Nov 2018 18:20:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix missing data checksums after a ranged fsync
 (msync)
Message-ID: <20181101172025.GT9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181029094206.18079-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029094206.18079-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 29, 2018 at 09:42:06AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Recently we got a massive simplification for fsync, where for the fast
> path we no longer log new extents while their respective ordered extents
> are still running.
> 
> However that simplification introduced a subtle regression for the case
> where we use a ranged fsync (msync). Consider the following example:
> 
>                CPU 0                                    CPU 1
> 
>                                             mmap write to range [2Mb, 4Mb[
>   mmap write to range [512Kb, 1Mb[
>   msync range [512K, 1Mb[
>     --> triggers fast fsync
>         (BTRFS_INODE_NEEDS_FULL_SYNC
>          not set)
>     --> creates extent map A for this
>         range and adds it to list of
>         modified extents
>     --> starts ordered extent A for
>         this range
>     --> waits for it to complete
> 
>                                             writeback triggered for range
>                                             [2Mb, 4Mb[
>                                               --> create extent map B and
>                                                   adds it to the list of
>                                                   modified extents
>                                               --> creates ordered extent B
> 
>     --> start looking for and logging
>         modified extents
>     --> logs extent maps A and B
>     --> finds checksums for extent A
>         in the csum tree, but not for
>         extent B
>   fsync (msync) finishes
> 
>                                               --> ordered extent B
>                                                   finishes and its
>                                                   checksums are added
>                                                   to the csum tree
> 
>                                 <power cut>
> 
> After replaying the log, we have the extent covering the range [2Mb, 4Mb[
> but do not have the data checksum items covering that file range.
> 
> This happens because at the very beginning of an fsync (btrfs_sync_file())
> we start and wait for IO in the given range [512Kb, 1Mb[ and therefore
> wait for any ordered extents in that range to complete before we start
> logging the extents. However if right before we start logging the extent
> in our range [512Kb, 1Mb[, writeback is started for any other dirty range,
> such as the range [2Mb, 4Mb[ due to memory pressure or a concurrent fsync
> or msync (btrfs_sync_file() starts writeback before acquiring the inode's
> lock), an ordered extent is created for that other range and a new extent
> map is created to represent that range and added to the inode's list of
> modified extents.
> 
> That means that we will see that other extent in that list when collecting
> extents for logging (done at btrfs_log_changed_extents()) and log the
> extent before the respective ordered extent finishes - namely before the
> checksum items are added to the checksums tree, which is where
> log_extent_csums() looks for the checksums, therefore making us log an
> extent without logging its checksums. Before that massive simplification
> of fsync, this wasn't a problem because besides looking for checkums in
> the checksums tree, we also looked for them in any ordered extent still
> running.
> 
> The consequence of data checksums missing for a file range is that users
> attempting to read the affected file range will get -EIO errors and dmesg
> reports the following:
> 
>  [10188.358136] BTRFS info (device sdc): no csum found for inode 297 start 57344
>  [10188.359278] BTRFS warning (device sdc): csum failed root 5 ino 297 off 57344 csum 0x98f94189 expected csum 0x00000000 mirror 1
> 
> So fix this by skipping an extents outside of our logging range at
> btrfs_log_changed_extents() and leaving them on the list of modified
> extents so that any subsequent ranged fsync may collect them if needed.
> Also, if we find a hole extent outside of the range still log it, just
> to prevent having gaps between extent items after replaying the log,
> otherwise fsck will complain when we are not using the NO_HOLES feature
> (fstest btrfs/056 triggers such case).
> 
> Fixes: e7175a692765 ("btrfs: remove the wait ordered logic in the log_one_extent path")
> CC: stable@vger.kernel.org # 4.19+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks, added to misc-next and on the way to 4.20.
