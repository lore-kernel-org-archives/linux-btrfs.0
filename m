Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432F0C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18DFE217F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbfB0QHG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:07:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:51876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbfB0QHG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 11:07:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 555EBAED5;
        Wed, 27 Feb 2019 16:07:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3D0D3DA83C; Wed, 27 Feb 2019 17:08:26 +0100 (CET)
Date:   Wed, 27 Feb 2019 17:08:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 06/10] btrfs: start transaction in btrfs_set_prop_trans
Message-ID: <20190227160826.GT24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-7-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550857192-10513-7-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 23, 2019 at 01:39:48AM +0800, Anand Jain wrote:
> In preparation to make trans argument of btrfs_setxattr() a mandatory,
> start the transaction in btrfs_set_prop_trans.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4: born
>  fs/btrfs/props.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index e581da1bfbb6..f878ba3160f0 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/hashtable.h>
> +#include <linux/iversion.h>
>  #include "props.h"
>  #include "btrfs_inode.h"
>  #include "transaction.h"
> @@ -103,7 +104,25 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>  int btrfs_set_prop_trans(struct inode *inode, const char *name,
>  			   const char *value, size_t value_len, int flags)
>  {
> -	return btrfs_set_prop(NULL, inode, name, value, value_len, flags);
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_trans_handle *trans;
> +	int ret;
> +
> +	trans = btrfs_start_transaction(root, 2);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	ret = btrfs_set_prop(trans, inode, name, value, value_len, flags);
> +
> +	if (!ret) {
> +		inode_inc_iversion(inode);
> +		inode->i_ctime = current_time(inode);
> +		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
> +		ret = btrfs_update_inode(trans, root, inode);
> +		ASSERT(!ret);

This is not right. The previous code uses BUG_ON which is also not
right, but does not silently continue if asserts are compiled out.
Please add proper error handling here.

> +	}
> +	btrfs_end_transaction(trans);
> +	return ret;
>  }
>  
>  static int iterate_object_props(struct btrfs_root *root,
> -- 
> 1.8.3.1
