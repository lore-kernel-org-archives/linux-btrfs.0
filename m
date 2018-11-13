Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C424C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 12:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455B322360
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 12:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 455B322360
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733020AbeKMWxa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 17:53:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:56336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732728AbeKMWxa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 17:53:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16A81B089;
        Tue, 13 Nov 2018 12:55:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B49A2DAC47; Tue, 13 Nov 2018 13:55:12 +0100 (CET)
Date:   Tue, 13 Nov 2018 13:55:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix rare chances for data loss when doing a fast
 fsync
Message-ID: <20181113125512.GX24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181112102358.5669-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112102358.5669-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 12, 2018 at 10:23:58AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> After the simplification of the fast fsync patch done recently by commit
> b5e6c3e170b7 ("btrfs: always wait on ordered extents at fsync time") and
> commit e7175a692765 ("btrfs: remove the wait ordered logic in the
> log_one_extent path"), we got a very short time window where we can get
> extents logged without writeback completing first or extents logged
> without logging the respective data checksums. Both issues can only happen
> when doing a non-full (fast) fsync.
> 
> As soon as we enter btrfs_sync_file() we trigger writeback, then lock the
> inode and then wait for the writeback to complete before starting to log
> the inode. However before we acquire the inode's lock and after we started
> writeback, it's possible that more writes happened and dirtied more pages.
> If that happened and those pages get writeback triggered while we are
> logging the inode (for example, the VM subsystem triggering it due to
> memory pressure, or another concurrent fsync), we end up seeing the
> respective extent maps in the inode's list of modified extents and will
> log matching file extent items without waiting for the respective
> ordered extents to complete, meaning that either of the following will
> happen:
> 
> 1) We log an extent after its writeback finishes but before its checksums
>    are added to the csum tree, leading to -EIO errors when attempting to
>    read the extent after a log replay.
> 
> 2) We log an extent before its writeback finishes.
>    Therefore after the log replay we will have a file extent item pointing
>    to an unwritten extent (and without the respective data checksums as
>    well).
> 
> This could not happen before the fast fsync patch simplification, because
> for any extent we found in the list of modified extents, we would wait for
> its respective ordered extent to finish writeback or collect its checksums
> for logging if it did not complete yet.
> 
> Fix this by triggering writeback again after acquiring the inode's lock
> and before waiting for ordered extents to complete.
> 
> Fixes: e7175a692765 ("btrfs: remove the wait ordered logic in the log_one_extent path")
> Fixes: b5e6c3e170b7 ("btrfs: always wait on ordered extents at fsync time")
> CC: stable@vger.kernel.org # 4.19+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next and queued for 4.20.

Thank you for such well written changelogs, it really helps to understand
what the patch does even if I'm not familiar with the code and the fsync
intricacies. A+
