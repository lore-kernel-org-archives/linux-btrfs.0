Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB38C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 14:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37AC22075A
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 14:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfBVOxw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:53:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:34690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726090AbfBVOxv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 09:53:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B421CABD4
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 14:53:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8474DAA56; Fri, 22 Feb 2019 15:55:10 +0100 (CET)
Date:   Fri, 22 Feb 2019 15:55:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH v3] btrfs: factor our read/write stage off
 csum_tree_block() into its callers
Message-ID: <20190222145508.GE9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>
References: <20190219124353.22948-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219124353.22948-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 19, 2019 at 01:43:53PM +0100, Johannes Thumshirn wrote:
> Currently csum_tree_block() does two things, first it as it's name
> suggests it calculates the checksum for a tree-block. But it also writes
> this checksum to disk or reads an extent_buffer from disk and compares the
> checksum with the calculated checksum, depending on the verify argument.
> 
> Furthermore one of the two callers passes in '1' for the verify argument,
> the other one passes in '0'.
> 
> For clarity and less layering violations, factor out the second stage in
> csum_tree_block()'s callers.
> 
> Suggested-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> ---
> 
> Changes to v2:
> - Directly return -EINVAL instead of EUCLEAN
> 
> Changes to v1:
> - return error from csum_tree_buffer() in csum_dirty_buffer() instead of
>   EUCLEAN (Nikolay)
> ---
>  fs/btrfs/disk-io.c | 51 +++++++++++++++++++++++++++------------------------
>  1 file changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5216e7b3f9ad..77089283be51 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -552,7 +534,11 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  	ASSERT(memcmp_extent_buffer(eb, fs_info->fs_devices->metadata_uuid,
>  			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
>  
> -	return csum_tree_block(fs_info, eb, 0);
> +	if (WARN_ON(csum_tree_block(eb, result)))

I think the warn should go to csum_tree_block when the mapping function
returns 1, there's even a comment explaining why it can't normally
happen. The reason for the warning in csum_dirty_buffer is not very
clear from the context.

Otherwise ok, the verify or write semantics of a function that (by name)
only calculates checksum is confusing. Thanks.
