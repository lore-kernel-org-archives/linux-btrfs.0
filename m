Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152DEC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 15:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF7F520821
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 15:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="t7hPe+wo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF7F520821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbeKAAyN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 20:54:13 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33890 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729613AbeKAAyM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 20:54:12 -0400
Received: by mail-yw1-f67.google.com with SMTP id v199-v6so6670765ywg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t/hv3o/uv3RE5PgKJlBpWAzl1lSKELdvopPkZ8gAwyg=;
        b=t7hPe+wom4568X81rtLzA0OuHx5sdcspuDGZXcYMQMeGAWQ8OtakFFyaqUipnb25c7
         0w/IkK2XS1FZOh5roBsBHKRQ4FMwsZ3gfO3RZm+DWLJmxQ0UDw/E4Xn8TNjxg/DU4Ihu
         CMT0XoQkZEO0V3gHJbT8ClElFRF3HVKqjHJpwaRnyJV6XRbjeFa/rgTY/pZiB+0gMp2p
         ykN4cyFKORo1TBxlFA60iPxuKcTIwbfF+4uLGdUYbR8YDEW4Tyss08WXd4xNPb1PafUm
         FcfOGlrdHVMTdGFjp11VvzWci9vqONYLcHOfb9bAZWfTE+m5Dx4s/c+bdlAw+Zt/DgNh
         848w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t/hv3o/uv3RE5PgKJlBpWAzl1lSKELdvopPkZ8gAwyg=;
        b=XRpeFL1fJ9xcM4XMKm0Yh0oRBcxR65ofjhsTHtRqKi7RmZYL1SZ3DAmNQGxQN15Rqt
         n0aP8q7mRx2iu7M70Q9L477AjG4+fQbBLmVQW2N06XuYVpGuW70PxzDI4eSbFgIDeFUK
         MmwjXBz0h629m5cV5xlCBYsMH1bbcw9ubYCYUUYf3vhwX9pu0VF0fAnLILI+wY/3lvNj
         BN84ZoBoAHOS2LlnJsjGy8ym7GF/5glDWEMCgMYbbitSGfAoSENADrL5CWqZg7fJOgkv
         d2Ua5KVUSs3FbP83Lm6DATFPFEXVyYiBvT/Vhrn/P9kVcc+HOrd6cuUgjU64tElCw2cy
         G9nw==
X-Gm-Message-State: AGRZ1gL6096kn4IlI1CUHHQi0Mzxa4HMtRR+MAOMCSEL7V/sZatzpaxm
        SaXbIO75Z8sJeWXsRFeg49ToWmL6kJfBtw==
X-Google-Smtp-Source: AJdET5eg+g6QI4Yfx6YwMpMCZ1hlDWVpPTn/bXn0jSbQIfpbxOwPE9syAZJQwCBb/6jAS8Nn1tS2Vw==
X-Received: by 2002:a81:b61a:: with SMTP id u26-v6mr3617718ywh.430.1541001336931;
        Wed, 31 Oct 2018 08:55:36 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:56b9])
        by smtp.gmail.com with ESMTPSA id k5-v6sm9234295ywi.94.2018.10.31.08.55.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 08:55:36 -0700 (PDT)
Date:   Wed, 31 Oct 2018 11:55:35 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix missing data checksums after a ranged fsync
 (msync)
Message-ID: <20181031155533.rs6zfmplg36wq4nn@macbook-pro-91.dhcp.thefacebook.com>
References: <20181029094206.18079-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029094206.18079-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
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

Nice catch,

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Josef
