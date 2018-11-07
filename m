Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46823C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 20:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B81720818
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 20:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="mM+BlIDY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B81720818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbeKHGWH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 01:22:07 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36345 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbeKHGWG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 01:22:06 -0500
Received: by mail-yw1-f66.google.com with SMTP id h21-v6so7153569ywa.3
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 12:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VtTzoYuhtqg25ufCC+9RmUaq0YuwPfNyNnOVNVjlO+g=;
        b=mM+BlIDYcnSVIWviDlnvgSa5ckWD3X6pjxRQaVJhkVSAYrllLlhFtK56UfA/ZXADaL
         D00kXmFNAdlXDiMgmhWmzuuFgOxIXsPSoEVXOshYiIKsV5ucGDJXCqbCIqv2jX1eUwen
         Yrf2WzQqXI3Fmgx514Eyfm6tp9KbTDf898yRgZPwm3MkBTRnVSzeszb2bVur9ZGFWFNg
         rYQXmYZ2ou7XA4FSHTjM/CmgysA2U1apiAVepcobJaBgWP0ky5nWM8qo7mR3xsVytKEa
         l7Wesiom5HxeskQQp1JuFhoso/k4D4AOPE44aV3WMbJRGHFfbD8PFyu0NUDKfDohPdPL
         WAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VtTzoYuhtqg25ufCC+9RmUaq0YuwPfNyNnOVNVjlO+g=;
        b=khxX3eQp1x1+GWxSDUlM9C02vWxqQUyFUhdc1MQCBsIQ2LALt9pZMfTPGtNmtSbBKx
         y+03zoLeiYLHV84ShSmd1FMwLR5Gdu9he+kAIN2pR0n6cEur3x5C4gnfYWKUMKaQye+u
         0xr4BnsmUDujZXxJosJk5/0M8IyjJ3yz1rB80lu1EnsqXYrmKugKj5fX8bMaXMkHybPy
         o5O29uTy6vFboIfy9ZtA4cAIeI1z4pi65PP3Rl/nHEf2n9Il3BCwRw/Npy4QsLPA4SYZ
         vOMkS/PwwKF6iiLnHiCfOb89v7mLD0x6MOSm0qHSGWm38kmLgr7WdzBTB/PuON4OQewx
         KzMQ==
X-Gm-Message-State: AGRZ1gJb4/edLh497TYFUeqATlD9HBgkoUkhZSD/3H8Kh8iPwPhTAHYk
        sZy7iSitJ4WBMAwRIdVUohtZSEyLf0kSzw==
X-Google-Smtp-Source: AJdET5fM/FQ4EtsMjXvZ3xgl/r1/ck+lCGtLzZs0ZvslZxajvjqSZJNvZCDKPjxlaReAcezjYdS0xQ==
X-Received: by 2002:a81:1d5:: with SMTP id 204-v6mr1855470ywb.111.1541623800427;
        Wed, 07 Nov 2018 12:50:00 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:9d8c])
        by smtp.gmail.com with ESMTPSA id r185-v6sm753666ywd.40.2018.11.07.12.49.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Nov 2018 12:49:59 -0800 (PST)
Date:   Wed, 7 Nov 2018 15:49:58 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix data corruption due to cloning of eof block
Message-ID: <20181107204957.srlyv7ylnvy72ydl@macbook-pro-91.dhcp.thefacebook.com>
References: <20181105111417.11808-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105111417.11808-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 05, 2018 at 11:14:17AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We currently allow cloning a range from a file which includes the last
> block of the file even if the file's size is not aligned to the block
> size. This is fine and useful when the destination file has the same size,
> but when it does not and the range ends somewhere in the middle of the
> destination file, it leads to corruption because the bytes between the EOF
> and the end of the block have undefined data (when there is support for
> discard/trimming they have a value of 0x00).
> 
> Example:
> 
>  $ mkfs.btrfs -f /dev/sdb
>  $ mount /dev/sdb /mnt
> 
>  $ export foo_size=$((256 * 1024 + 100))
>  $ xfs_io -f -c "pwrite -S 0x3c 0 $foo_size" /mnt/foo
>  $ xfs_io -f -c "pwrite -S 0xb5 0 1M" /mnt/bar
> 
>  $ xfs_io -c "reflink /mnt/foo 0 512K $foo_size" /mnt/bar
> 
>  $ od -A d -t x1 /mnt/bar
>  0000000 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5
>  *
>  0524288 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c 3c
>  *
>  0786528 3c 3c 3c 3c 00 00 00 00 00 00 00 00 00 00 00 00
>  0786544 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  *
>  0790528 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5
>  *
>  1048576
> 
> The bytes in the range from 786532 (512Kb + 256Kb + 100 bytes) to 790527
> (512Kb + 256Kb + 4Kb - 1) got corrupted, having now a value of 0x00 instead
> of 0xb5.
> 
> This is similar to the problem we had for deduplication that got recently
> fixed by commit de02b9f6bb65 ("Btrfs: fix data corruption when
> deduplicating between different files").
> 
> Fix this by not allowing such operations to be performed and return the
> errno -EINVAL to user space. This is what XFS is doing as well at the VFS
> level. This change however now makes us return -EINVAL instead of
> -EOPNOTSUPP for cases where the source range maps to an inline extent and
> the destination range's end is smaller then the destination file's size,
> since the detection of inline extents is done during the actual process of
> dropping file extent items (at __btrfs_drop_extents()). Returning the
> -EINVAL error is done early on and solely based on the input parameters
> (offsets and length) and destination file's size. This makes us consistent
> with XFS and anyone else supporting cloning since this case is now checked
> at a higher level in the VFS and is where the -EINVAL will be returned
> from starting with kernel 4.20 (the VFS changed was introduced in 4.20-rc1
> by commit 07d19dc9fbe9 ("vfs: avoid problematic remapping requests into
> partial EOF block"). So this change is more geared towards stable kernels,
> as it's unlikely the new VFS checks get removed intentionally.
> 
> A test case for fstests follows soon, as well as an update to filter
> existing tests that expect -EOPNOTSUPP to accept -EINVAL as well.
> 
> CC: <stable@vger.kernel.org> # 4.4+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
