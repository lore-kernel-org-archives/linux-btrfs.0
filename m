Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB87C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 23:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F65206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 23:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfDBXiM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 19:38:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:35700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfDBXiL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 19:38:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C52FCAC63
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2019 23:38:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C7002DA824; Wed,  3 Apr 2019 01:39:20 +0200 (CEST)
Date:   Wed, 3 Apr 2019 01:39:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Preamture OOM fixes
Message-ID: <20190402233920.GL29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190401082958.26470-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401082958.26470-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 01, 2019 at 11:29:56AM +0300, Nikolay Borisov wrote:
> David reported that following the async cow path refactoring that got into 
> misc-next he started seeing premature OOM kills due to large page allocations 
> (order 4). This was due to now the whole async context (alongisde ancillary 
> structures, describing chunks) being allocated in a single kmalloc call. The 
> first patch of this series aims to fix that by converting the kmalloc call to 
> kvmalloc. This will have virtually no perfromance impact for small writes and 
> for larger ones will fallback to vmalloc. 
> 
> However, while testing the first patch I observed BUG_ONs in the async
> csum calculation path to trigger. This is clearly caused by the fact that 
> the first patch introduces a fairly large memory allocation. Nevertheless, 
> having large allocations in the csum path without a fallback to some sort of 
> order 0 page allocation or at least graceful handling of memory errors is gross.
> Patch 2 aims to rectify this by switching the allocation in btrfs_csum_one_bio
> to using kvmalloc, giving greated chance for success. Even if patch 1 is ignored
> nothing prevents the csum calculation to trigger the bug on depending on the memory 
> usage/fragmentation of the server so IMO it's beneficial either ways.

For the record: the patches that introduced the preallocation + followup
cleanups have been removed from misc-next until we're sure that the
supposed change in IO submission path does not introduce further
surprises.

The potential performance impact is about to be evaluated. The error
not-handling currently depends on the kmalloc behaviour that does not
fail for small allocations, so current code is safer for users.

The preallocation provides a nicer way to handle errors early and fails
gracefully, unfortunately this is out of the safe zone of kmalloc so
this introduces a new problem.

The io submission path is probably the biggest and worst BUG_ON error
handling misuse, but also the hardest one to fix. We'll get there, but
as the prealloc patches showed we need to be careful.
