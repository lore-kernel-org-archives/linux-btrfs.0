Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC71CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 17:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD6520863
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 17:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbfB1R7f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 12:59:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:59690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbfB1R7f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 12:59:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 513E1AE24
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 17:59:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F0EB1DA944; Thu, 28 Feb 2019 19:00:50 +0100 (CET)
Date:   Thu, 28 Feb 2019 19:00:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 09/12] btrfs: Factor out in_range macro
Message-ID: <20190228180048.GP31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190211083510.27591-1-nborisov@suse.com>
 <20190211083510.27591-10-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211083510.27591-10-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 10:35:07AM +0200, Nikolay Borisov wrote:
> This is used in more than one places so let's factor it out in ctree.h.
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
>  fs/btrfs/ctree.h       | 2 ++
>  fs/btrfs/extent-tree.c | 1 -
>  fs/btrfs/volumes.c     | 1 -
>  3 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 86dbf2160ae2..c61fff4c294d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3808,6 +3808,8 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
>  	return signal_pending(current);
>  }
>  
> +#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))

I think it's time to add a new file for such small helpers and not
clutter ctree.h. There's math.h but too specific (and we did object
against that back then but, well). Something like utils.h or common.h
would be good, with eg. the assert macros or cond_wake_mb, and the math
helpers too. That's for later and does not affect this patchet.
