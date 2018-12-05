Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1ECC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 16:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCD612084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 16:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="IRNcpm/U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCD612084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbeLEQ6w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 11:58:52 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37439 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeLEQ6w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 11:58:52 -0500
Received: by mail-yb1-f194.google.com with SMTP id w129-v6so7121913ybe.4
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2018 08:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7W6Z7tlyQ0Vsey8wyfayoU/0Rpm39XfE+AppXVkcnOE=;
        b=IRNcpm/UaRABxULqVtM+nvRXfCNFSpGw+s0h2D/gP2PK/modMDU1bZUylxlk6Jn5Bi
         ML7VicRdn9OHGEROBngCK7MUZMXmEqusLo912xZ9OS5CCAF7661SS+ph3iLVgMWfmmnQ
         BkQLqcKsbPLE7V/pld+dl4cDvc0X85rwsAKXXCRE++zpM+AT1XbPWW2i8kOjmRGYLLzr
         nXmq4EXbQp6LEM7/276RMKVuTdUMPd+9lGiOQBPbb1Tpzrh8xNv/Lq/cec0LNyF21tcf
         LYcCuBZltX+Qxa5MgxcO0C1IpU1CG1GszHKMZHQYdTgiSEbDhfj817HC67qBdEa4u95p
         sEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7W6Z7tlyQ0Vsey8wyfayoU/0Rpm39XfE+AppXVkcnOE=;
        b=S1OlsUpEjSMfJW3hUr2zbMTohLtO+td9b3ns+qbPOc/sfvKRdrEnFIztPkOEH1/xk/
         T65ObCCW4iGnSdJl1CzOge+yjyTxzSsj094PZ+TYljHeeSZW3CuZptDpgjmGFmVwe1fD
         tRjWglDzpgKlxKL/21Om0E9tCXgQdRPgVcNGWe4hoopflZ6tt+vqpCmmexgWmv4fq4Pi
         OcKRkiV6CKIGySm4pXk/tGiyGXfDEZqHYzBvniIi5x9rcQEw2xnnJB4wRMN9a38a0iPO
         1HzttMPSrjPwaCE/aiYiXGIjcm4nd2ua5wDytEadNJpt1Ax2ONWPX87qECttTwttFEZP
         gl0g==
X-Gm-Message-State: AA+aEWZtFV9cJaqejt38qPEEmq/Phe+0HG5gGeWlwCqqkm6s1A1yWN2a
        IyXB573fsQ77ZVQniZdzUHA4eQ==
X-Google-Smtp-Source: AFSGD/V6UvmUVlocc/RYlVLO3JOt73MUKKgLlmxq6nM568xl696/s1d1h9S0K/MdGLJezUgUdYYbgQ==
X-Received: by 2002:a81:1282:: with SMTP id 124mr5745609yws.154.1544029131066;
        Wed, 05 Dec 2018 08:58:51 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g138sm6719185ywb.64.2018.12.05.08.58.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 08:58:50 -0800 (PST)
Date:   Wed, 5 Dec 2018 11:58:49 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: Remove __extent_readpages
Message-ID: <20181205165847.gfmx3jmnpe42ucyt@MacBook-Pro-91.local>
References: <20181203102532.13945-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203102532.13945-1-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 03, 2018 at 12:25:32PM +0200, Nikolay Borisov wrote:
> When extent_readpages is called from the generic readahead code it first
> builds a batch of 16 pages (which might or might not be consecutive,
> depending on whether add_to_page_cache_lru failed) and submits them to
> __extent_readpages. The latter ensures that the range of pages (in the
> batch of 16) that is passed to __do_contiguous_readpages is consecutive.
> 
> If add_to_page_cache_lru does't fail then __extent_readpages will call
> __do_contiguous_readpages only once with the whole batch of 16.
> Alternatively, if add_to_page_cache_lru fails once on the 8th page (as an example)
> then the contigous page read code will be called twice.
> 
> All of this can be simplified by exploiting the fact that all pages passed
> to extent_readpages are consecutive, thus when the batch is built in
> that function it is already consecutive (barring add_to_page_cache_lru
> failures) so are ready to be submitted directly to __do_contiguous_readpages.
> Also simplify the name of the function to contiguous_readpages. 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> So this patch looks like a very nice cleanup, however when doing performance 
> measurements with fio I was shocked to see that it actually is detrimental to 
> performance. Here are the results: 
> 
> The command line used for fio: 
> fio --name=/media/scratch/seqread --rw=read --direct=0 --ioengine=sync --bs=4k
>  --numjobs=1 --size=1G --runtime=600  --group_reporting --loop 10
> 
> This was tested on a vm with 4g of ram so the size of the test is smaller than 
> the memory, so pages should have been nicely readahead. 
> 

What this patch changes is now we aren't reading all of the pages we are passed
by the readahead, so now we fall back to per-page reading when we go to read
those pages because the readahead window has already moved past them.  This
isn't great behavior, what we have is nice in that it tries to group the entire
range together as much as possible.  What your patch changes is that as soon as
we stop having a contiguous range we just bail and submit what we have.  Testing
it in isolation is likely to show very little change, but having recently
touched the fault in code where we definitely do not count major faults in some
cases I'd suspect that we're not reflecting this higher fault rate in the
performance counters properly.  We should preserve the existing behavior, what
hurts a little bit on a lightly loaded box is going to hurt a whole lot more on
a heavily loaded box.  Thanks,

Josef
