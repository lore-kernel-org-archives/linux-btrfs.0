Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A7BC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DDFB22360
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="J609Z6+t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DDFB22360
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbeKOFhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 00:37:22 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35944 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725756AbeKOFhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 00:37:22 -0500
Received: by mail-io1-f67.google.com with SMTP id m19so6937857ioh.3
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 11:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AUaflvQkHrgasvQhNcXpOCHu5X+IKjkiNt/fiZZ0nlc=;
        b=J609Z6+tnG4T+fTN6IGCuEoVPiMZ9QROO/sOKrb5ypKRLqJRTJL5Z1evPtH/vohJcP
         i5D4w4zI0rhDMuvt7vsScjZL1L5KtcKB/fwkgakjjTndYbzO2HpHiwd3htYuYZq1viYi
         W1Ph29gjfAOvrhr16z766kxYdJjiU8sebATIppUBaROawF5xjnwStSNobH0NHSS1OJKE
         qDsFZyH7lU+5clthCuSKUvKZ4zt3bGlIkuifV1V9OXt8m7fP9OkcW/FjcVCQmL+Jomdb
         tfBPTKFegI/6I7+NPc9C2/Ne9yiYHvD+y4Kh3G4Vv7fSN/TYC+4hVO/hdWs+JCZ99vlD
         us7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AUaflvQkHrgasvQhNcXpOCHu5X+IKjkiNt/fiZZ0nlc=;
        b=GnHWty0TK4nQwQ8j1cXkI987VeluEzcqQg6SJR37TGCE/WLBMnlbHywKHcat959O4c
         UJE4uqAY6bPnaGlBY3d04fKuXqwX0dfyeIXF4YcyjZ0ECO16vh/ZwUpNGcIrbhmhmdEl
         OcWTCAFk0gQ6/Mjp4rNKXi0eD7T0CWlUVkfyDj450ainEQMxELhgrjwWFs8eN9q2D3qY
         1GUaexQ5xKvJFIp11UpikpxE+rcxvOS73R/OwH13Se2HdB+OlSBt9Z0Qn6Ek5bmq+8GG
         ACAXWrQ7GSBRQWQlYeRmjCzzoflyCM/mGacefYNDBWVOc+JOYIOtWDE6wSbO7f+24m6D
         d8og==
X-Gm-Message-State: AGRZ1gJnM7Oj6RsnWp1XOwQ30rent/MGj7NrnZz/dVNmzo9x8fHEDh+8
        I4H8DmxTNtXeqMi3TWWAQQJh2KrnoaK5Yg==
X-Google-Smtp-Source: AFSGD/XqW27y1r1/fxw2+Zm4U3+uq+4sFPSGjBgI5VM4vxVJSiolMqj6FOp4QMrZUhcBHN12lphPHA==
X-Received: by 2002:a6b:1490:: with SMTP id 138mr2622656iou.103.1542223969743;
        Wed, 14 Nov 2018 11:32:49 -0800 (PST)
Received: from vader ([2620:10d:c090:180::1:2a61])
        by smtp.gmail.com with ESMTPSA id t6sm3300245ioc.87.2018.11.14.11.32.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Nov 2018 11:32:48 -0800 (PST)
Date:   Wed, 14 Nov 2018 11:32:47 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/6] btrfs: remove unused variable tree in
 bio_readpage_error()
Message-ID: <20181114193247.GC4173@vader>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <20181114133520.16069-5-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114133520.16069-5-jthumshirn@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 02:35:18PM +0100, Johannes Thumshirn wrote:
> Commit 2922040236f9 (btrfs: Remove extent_io_ops::writepage_end_io_hook)
> removed the indirection to extent_io_ops::writepage_end_io_hook but didn't
> remove the tree variable which then became unused.
> 
> Remove 'tree' as well to silence the warning when -Wunused-but-set-variable is
> used to compile btrfs.

The subject says bio_readpage_error() but this is
end_extent_writepage(). Otherwise,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/extent_io.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0f8f9c035812..17a15cc6b542 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2403,11 +2403,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
>  void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>  {
>  	int uptodate = (err == 0);
> -	struct extent_io_tree *tree;
>  	int ret = 0;
>  
> -	tree = &BTRFS_I(page->mapping->host)->io_tree;
> -
>  	btrfs_writepage_endio_finish_ordered(page, start, end, NULL, uptodate);
>  
>  	if (!uptodate) {
> -- 
> 2.16.4
> 
