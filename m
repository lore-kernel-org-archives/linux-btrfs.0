Return-Path: <SRS0=r+Ws=4Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A054C3F2CD
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02BA420801
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgB1OUo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 09:20:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:35616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgB1OUn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Feb 2020 09:20:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12623B24F;
        Fri, 28 Feb 2020 14:20:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 98A9FDA7FF; Fri, 28 Feb 2020 15:20:21 +0100 (CET)
Date:   Fri, 28 Feb 2020 15:20:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 20/21] btrfs: skip LOOP_NO_EMPTY_SIZE if not clustered
 allocation
Message-ID: <20200228142021.GL2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
References: <20200225035626.1049501-1-naohiro.aota@wdc.com>
 <20200225035626.1049501-21-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225035626.1049501-21-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 25, 2020 at 12:56:25PM +0900, Naohiro Aota wrote:
> LOOP_NO_EMPTY_SIZE is solely dedicated for clustered allocation. So, we can
> skip this stage and give up the allocation.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> ---
>  fs/btrfs/extent-tree.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index cb82eaf28033..055097bff12b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3848,6 +3848,9 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
>  		}
>  
>  		if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
> +			if (ffe_ctl->policy != BTRFS_EXTENT_ALLOC_CLUSTERED)
> +				return -ENOSPC;

This looks like functional change, unlike the rest so will need some
review still.
