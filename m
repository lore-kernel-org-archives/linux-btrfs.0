Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EF2C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 15:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73004218A2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 15:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfAYPG1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:06:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:45024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726991AbfAYPG1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 10:06:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A4F2AB6D
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 15:06:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E149BDA6F5; Fri, 25 Jan 2019 16:05:50 +0100 (CET)
Date:   Fri, 25 Jan 2019 16:05:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, wqu@suse.com, fdmanana@suse.com
Subject: Re: [PATCH] btrfs: Handle ENOMEM gracefully in cow_file_range_async
Message-ID: <20190125150545.GC2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, wqu@suse.com, fdmanana@suse.com
References: <20190109144303.31847-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109144303.31847-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 09, 2019 at 04:43:03PM +0200, Nikolay Borisov wrote:
> If we run out of memory during delalloc filling in compress case btrfs
> is going to BUG_ON. This is unnecessary since the higher levels code
> (btrfs_run_delalloc_range and its callers) gracefully handle error
> condtions and error out the page being submittede. Let's be a model
> kernel citizen and no panic the machine due to ENOMEM and instead fail
> the IO.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index cde51ace68b5..b4b2d7f8a98b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1197,7 +1197,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>  			 1, 0, NULL);
>  	while (start < end) {
>  		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
> -		BUG_ON(!async_cow); /* -ENOMEM */
> +		if (!async_cow)
> +			return -ENOMEM;

The error handling here is very simple and breaks the usual rule that
all functions must clean up after themselves before returning to the
caller.

This is async submission so it can be expected to do deferred cleanup,
but this cannot be easily seen from the function and should be better
documented.

What happens with the inode reference (igrab), what happens with all
work queued until now, or extent range state bits.

It's true that btrfs_run_delalloc_range does error handling, though it
does that from 4 different types of conditions (nocow, prealloc,
compression and async). I'd really like to see explained that there's
nothing left and cause surprises later. The memory allocation failures
are almost never tested so we have to be sure we understand the error
handling code flow. I can't say I do after reading your changelog and
the correctness proof is left as an exercise.

The error handling was brought by 524272607e882d04 "btrfs: Handle
delalloc error correctly to avoid ordered extent hang", so there's a
remote chance to cause lockups when the state is not cleaned up.
