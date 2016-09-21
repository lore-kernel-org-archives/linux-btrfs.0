Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:34996 "EHLO
        okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756045AbcIUIU0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 04:20:26 -0400
Received: from pipebreaker.pl ([2001:470:71:68d::1] helo=mother.pipebreaker.pl)
        by okda.pipebreaker.pl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.87)
        (envelope-from <zdzichu@mother.pipebreaker.pl>)
        id 1bmc3f-004iMv-T2
        for linux-btrfs@vger.kernel.org; Wed, 21 Sep 2016 09:35:07 +0200
Date: Wed, 21 Sep 2016 09:35:02 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Message-ID: <20160921073502.GB357701@mother.pipebreaker.pl>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 03:28:25PM +0800, Qu Wenruo wrote:
> Hi,
> 
> For this well-known bug, is there any one fixing it?
> 
> It can't be more frustrating finding some one has already worked on it after
> spending days digging.
> 
> BTW, since kernel scrub is somewhat scrap for raid5/6, I'd like to implement
> btrfsck scrub support, at least we can use btrfsck to fix bad stripes before
> kernel fix.

  Why wouldn't you fix in-kernel code?  Why implement duplicate functionality
when you can fix the root cause?

-- 
Tomasz   .. oo o.   oo o. .o   .o o. o. oo o.   ..
Torcz    .. .o .o   .o .o oo   oo .o .. .. oo   oo
o.o.o.   .o .. o.   o. o. o.   o. o. oo .. ..   o.

