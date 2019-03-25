Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49906C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 17:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A8462087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 17:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfCYRFT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:05:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:50346 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbfCYRFS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 13:05:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9EB9AC44
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 17:05:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2FCDEDA98F; Mon, 25 Mar 2019 18:06:31 +0100 (CET)
Date:   Mon, 25 Mar 2019 18:06:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCh v2 1/9] btrfs: Move btrfs_check_chunk_valid() to
 tree-check.[ch] and export it
Message-ID: <20190325170630.GO10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320063717.31770-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:37:09PM +0800, Qu Wenruo wrote:
> By function, chunk item verification is more suitable to be done inside
> tree-checker.
> 
> So move btrfs_check_chunk_valid() to tree-checker.c and export it.
> 
> And since it's now moved to tree-checker, also add a better comment for
> what this function is doing.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 99 +++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/tree-checker.h |  3 ++
>  fs/btrfs/volumes.c      | 94 +-------------------------------------
>  3 files changed, 103 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index b8cdaf472031..4e44323ae758 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -448,6 +448,105 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
>  
> +/*
> + * The common chunk check which could also work on super block sys chunk array.
> + *
> + * Return -EUCLEAN if anything is corrupted.

Well, that's still confusing if you say EUCLEAN in the commend and use
EIO in the code.
