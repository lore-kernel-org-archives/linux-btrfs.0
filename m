Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A30C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 22:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D063F2075E
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 22:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfDBWDD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 18:03:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:52188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfDBWDD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 18:03:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8070DAF1E;
        Tue,  2 Apr 2019 22:03:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6B79CDA824; Wed,  3 Apr 2019 00:04:11 +0200 (CEST)
Date:   Wed, 3 Apr 2019 00:04:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4 RESEND] btrfs: fix property validate fail should not
 increment generation
Message-ID: <20190402220410.GH29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-6-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402100742.8355-6-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 06:07:42PM +0800, Anand Jain wrote:
> When the property fails to pass the prop_handlers::validate() check, the
> thread should exit with no changes in the kernel, but as we are starting
> the transaction too early, we have just updated the generation even if
> there is no change.

Agreed, this should be fixed.

> 
> For example:
> btrfs prop get /btrfs compression
>  compression=lzo
> sync
> btrfs in dump-super /dev/sdb | grep "^generation"
>  generation		32
> 
> Try to set an incomplete compression type
> 
> btrfs prop set /btrfs compression zli
>   ERROR: failed to set compression for /btrfs: Invalid argument
> sync
> 
> Set failed but generation is incremented
> btrfs in dump-super /dev/sdb | grep "^generation"
>  generation		33  <--
> 
> Fix it by collapsing btrfs_set_prop_trans() into btrfs_set_prop(), which
> provides flexibility to start the transaction after the
> prop_handlers::validate() has been checked.

Please split the changes, the collapsed function make it difficult to
review. It does not matter if you first clean up the functions and then
switch the transaction, or the other way around.

> As of now if the prop_handlers::apply() fails then we still increment
> the generation, but if there is strong prop_handlers::validate() then
> the prop_handlers::apply() can never fail.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c | 10 ++++------
>  fs/btrfs/props.c | 59 +++++++++++++++++++++++++-------------------------------
>  fs/btrfs/props.h |  4 ++--
>  fs/btrfs/xattr.c |  2 +-
>  4 files changed, 33 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 28ee9fe6edb4..0eeaf9a68082 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -284,8 +284,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  		binode->flags &= ~BTRFS_INODE_COMPRESS;
>  		binode->flags |= BTRFS_INODE_NOCOMPRESS;
>  
> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
> -					   0, 0);
> +		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>  		if (ret && ret != -ENODATA)
>  			goto out_drop;
>  	} else if (fsflags & FS_COMPR_FL) {
> @@ -303,14 +302,13 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  		if (!comp || comp[0] == 0)
>  			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
>  
> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", comp,
> -					   strlen(comp), 0);
> +		ret = btrfs_set_prop(inode, "btrfs.compression", comp,
> +				     strlen(comp), 0);
>  		if (ret)
>  			goto out_drop;
>  
>  	} else {
> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
> -					   0, 0);
> +		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>  		if (ret && ret != -ENODATA)
>  			goto out_drop;
>  		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index fb84e76f3b1d..99fa2459ba61 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -56,11 +56,12 @@ static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
>  	return NULL;
>  }
>  
> -static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
> -			  const char *name, const char *value, size_t value_len,
> -			  int flags)
> +int btrfs_set_prop(struct inode *inode, const char *name, const char *value,
> +		   size_t value_len, int flags)
>  {
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	const struct prop_handler *handler;
> +	struct btrfs_trans_handle *trans;
>  	int ret;
>  
>  	if (btrfs_root_readonly(BTRFS_I(inode)->root))
> @@ -74,50 +75,40 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>  		return -EINVAL;
>  
>  	if (value_len == 0) {
> +		/* Its called to reset the property */
> +		trans = btrfs_start_transaction(root, 2);
> +		if (IS_ERR(trans))
> +			return PTR_ERR(trans);
> +
>  		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
>  				       NULL, 0, flags);
> -		if (ret)
> -			return ret;
> -
> -		ret = handler->apply(inode, NULL, 0);
> -		ASSERT(ret == 0);
> -
> -		return ret;
> +		if (!ret) {
> +			ret = handler->apply(inode, NULL, 0);
> +			ASSERT(ret == 0);
> +		}
> +		goto out;

This block would be better in a separate helper, now that it starts the
transaction, eg.

	if (value_len == 0)
		return do_reset_property(inode, handler, flags);

>  	}
>  
>  	ret = handler->validate(value, value_len);
>  	if (ret)
>  		return ret;
> +
> +	trans = btrfs_start_transaction(root, 2);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
>  	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
>  			       value, value_len, flags);
>  	if (ret)
> -		return ret;
> +		goto out;
> +
>  	ret = handler->apply(inode, value, value_len);
>  	if (ret) {
> +		/* Apply failed. Reset the property. */
>  		btrfs_setxattr(trans, inode, handler->xattr_name,
>  				 NULL, 0, flags);

So that's not new code, but I wonder whether this is correct at all.
Reset means to the original value or to empty value? The problem here is
that it's under transaction, so this should be followed by an abort.

It maybe is possible to safely revert the value without aborting, as the
inode is locked.

> -		return ret;
> -	}
> -
> -	set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
> -
> -	return 0;
> -}
> -
> -int btrfs_set_prop_trans(struct inode *inode, const char *name,
> -			 const char *value, size_t value_len, int flags)
> -{
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	struct btrfs_trans_handle *trans;
> -	int ret;
> -
> -	trans = btrfs_start_transaction(root, 2);
> -	if (IS_ERR(trans))
> -		return PTR_ERR(trans);
> -
> -	ret = btrfs_set_prop(trans, inode, name, value, value_len, flags);
> -
> -	if (!ret) {
> +	} else {
> +		set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
>  		inode_inc_iversion(inode);
>  		inode->i_ctime = current_time(inode);
>  		set_bit(BTRFS_INODE_COPY_EVERYTHING,
> @@ -125,6 +116,8 @@ int btrfs_set_prop_trans(struct inode *inode, const char *name,
>  		ret = btrfs_update_inode(trans, root, inode);
>  		BUG_ON(ret);
>  	}
> +
> +out:
>  	btrfs_end_transaction(trans);
>  	return ret;
>  }
