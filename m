Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B790C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB14D21480
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:34:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB14D21480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbeIYVmc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:42:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:40986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729306AbeIYVmc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:42:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A0DFAC46
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 15:34:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 99942DAE2F; Tue, 25 Sep 2018 17:34:28 +0200 (CEST)
Date:   Tue, 25 Sep 2018 17:34:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: tree-checker: Avoid using max() for stack
 array allocation
Message-ID: <20180925153428.GF3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180925000626.15474-1-wqu@suse.com>
 <20180925000626.15474-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925000626.15474-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 25, 2018 at 08:06:26AM +0800, Qu Wenruo wrote:
> Although BTRFS_NAME_LEN and XATTR_NAME_MAX is the same value (255),
> max(BTRFS_NAME_LEN, XATTR_NAME_MAX) should be optimized as const at
> runtime.
> 
> However S390x' arch dependent option "-mwarn-dynamicstack" could still
> report it as dyanamic stack allocation.
> 
> Just use BTRFS_NAME_LEN directly to avoid such false alert.

Same reasoning as for the NAME_MAX, these are different things.

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index db835635372f..4c045609909b 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -336,7 +336,7 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
>  		 */
>  		if (key->type == BTRFS_DIR_ITEM_KEY ||
>  		    key->type == BTRFS_XATTR_ITEM_KEY) {
> -			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
> +			char namebuf[BTRFS_NAME_LEN];

The updated implementation of max() can now handle the expression
without a warning, with sufficiently new compiler so I don't think we
need to fix that.

Alternatively, you could use BTRFS_NAME_LEN and add a
BUILD_BUG_ON(BTRFS_NAME_LEN < XATTR_NAME_MAX) with a comment why.

>  
>  			read_extent_buffer(leaf, namebuf,
>  					(unsigned long)(di + 1), name_len);
> -- 
> 2.19.0
