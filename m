Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE8AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 14:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633C3223DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 14:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zE2uYdY7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 633C3223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbeKMABu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 19:01:50 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35703 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbeKMABu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 19:01:50 -0500
Received: by mail-qk1-f195.google.com with SMTP id w204so13428180qka.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 06:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EWpkN/5L9uan+oi+FualNWx746u21RhP78czXzrEOQA=;
        b=zE2uYdY7eUVhcKoGnAqTo/a2gSkXO4Yxfw0tYlZ4auFpwFv/TTh/dKZtbCUtYBCrr1
         nT/DjScpoLqf23Eb7IWJZPY7D/y52od8tmY5GTVTGrrVOv1OExthyVjr304P0o6N9p0o
         LuUx6fxidDkB5Sf8BNsyKWNJf00uxuabN76wH/9BMul9irmApGWNyqFLuirJDHqegZTA
         xRfJOXjQHvQ2qYTFz7vzVuethR4STttO6hGXumSxBOYXsbJRGpiuPSHUk7lzhudSAxi+
         a2d+bhf56ivxFteWVSkpgmF88F+C+vvPa2WMTEvWyVKWy4y0edH2xZpF8RFY8jlzb+00
         d5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EWpkN/5L9uan+oi+FualNWx746u21RhP78czXzrEOQA=;
        b=uigQnAb39MVNwiXpSZ+2NjRcWo+99p1HtNTjoXvJxm/FMA/lIWbj/sH8cHZGqoTXp7
         qCClNF2Z6880HgchP8dyux+E6jnAiixUGsH5oiE9oJ9tTF9WCDU4WP/7r2tjL7CyZWqo
         O3PNXHx7D511BpA4hKPW9doDIChH9q/Pn05T7YVYdpr4RC2uJsyFG13rA5bMo2xIB6Zt
         abUaJBIagM5pWAfKuBZcVFR3TBBsuZlEhyv8KIyGlOrRTj8DSaGk3iu0TyOpSUNQfh48
         VBFt5eeYY6ftzMabZiKrcukmWWwUMyAF1IQKS6/JGfrWlkMnmLEM480gVO4ViCF0Qy3L
         8LJg==
X-Gm-Message-State: AGRZ1gIZicgUqNaFC9bDk7+O/Cn0rJOflGMmgE4QamwtN6SY5JeEGdnb
        BdtewYpsLbIsZDwXCqxkrvItXzWae6M=
X-Google-Smtp-Source: AJdET5cbh+zLmUwatR23RayNVmiAXd8gxB2xiki0vIzdIPTznCxYkXVyK5+RwgPn5wtjYCYRVyeCuQ==
X-Received: by 2002:ac8:23dc:: with SMTP id r28mr967341qtr.89.1542031703850;
        Mon, 12 Nov 2018 06:08:23 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:d2de])
        by smtp.gmail.com with ESMTPSA id j89sm9603911qkh.34.2018.11.12.06.08.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 06:08:23 -0800 (PST)
Date:   Mon, 12 Nov 2018 09:08:22 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix rare chances for data loss when doing a fast
 fsync
Message-ID: <20181112140821.jxhwegemim4wvzv6@MacBook-Pro-91.local>
References: <20181112102358.5669-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112102358.5669-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
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

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
