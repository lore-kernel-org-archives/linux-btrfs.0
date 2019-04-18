Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC2DC10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A258217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbfDRNW5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:22:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:39526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729497AbfDRNW4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 09:22:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 28D05B642;
        Thu, 18 Apr 2019 13:22:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E0DCFDA871; Thu, 18 Apr 2019 15:24:00 +0200 (CEST)
Date:   Thu, 18 Apr 2019 15:23:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2 RFC] btrfs: start transaction in
 btrfs_ioctl_setflags()
Message-ID: <20190418132358.GM20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190417153706.29942-1-anand.jain@oracle.com>
 <20190417153706.29942-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417153706.29942-3-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 17, 2019 at 11:37:06PM +0800, Anand Jain wrote:
> When inode attribute flags is set through FS_IOC_SETFLAGS ioctl, there is
> a bit of duplicate codes, the following things happens twice -
> start/end_transaction, inode_inc_iversion(), current_time update to
> inode->i_ctime, and btrfs_update_inode(). These are updated both at
> btrfs_ioctl_setflags() and btrfs_set_props() as well. (RFC: So inode
> version and the generation number should have increased by +2, but I
> don't see that in the test case below ran without this patch)
> 
> This patch merges these two duplicate codes at btrfs_ioctl_setflags().
> 
> $ cat a
> mkfs.btrfs -fq /dev/sdb || exit
> mount /dev/sdb /btrfs
> touch /btrfs/file1
> sync
> echo before:
> btrfs in dump-super /dev/sdb | grep ^generation
> btrfs in dump-tree /dev/sdb | grep -A4 "257 XATTR_ITEM"
> btrfs in dump-tree /dev/sdb | grep -A4 "257 INODE_ITEM 0) item"
> echo
> echo "chattr +Ac /btrfs/file1"
> chattr +Ac /btrfs/file1
> sync
> echo after:
> btrfs in dump-super /dev/sdb | grep ^generation
> btrfs in dump-tree /dev/sdb | grep -A4 "257 XATTR_ITEM"
> btrfs in dump-tree /dev/sdb | grep -A4 "257 INODE_ITEM 0) item"
> 
> $ umount /btrfs; ./a
> before:
> generation		6
> 	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
> 		generation 6 transid 6 size 0 nbytes 0
> 		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
> 		sequence 19 flags 0x0(none)
> 
> chattr +Ac /btrfs/file1
> after:
> generation		7
> 	item 6 key (257 XATTR_ITEM 550297449) itemoff 15815 itemsize 51
> 		location key (0 UNKNOWN.0 0) type XATTR
> 		transid 7 data_len 4 name_len 17
> 		name: btrfs.compression
> 		data zlib
> 	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
> 		generation 6 transid 7 size 0 nbytes 0
> 		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
> 		sequence 21 flags 0xa00(NOATIME|COMPRESS)
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c | 38 ++++++++++++++++++--------------------
>  fs/btrfs/props.c |  6 +++---
>  fs/btrfs/props.h |  3 +++
>  3 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 63e6e2f5b659..82772523bb87 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -192,6 +192,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  	u64 old_flags;
>  	unsigned int old_i_flags;
>  	umode_t mode;
> +	const char *comp = NULL;
>  
>  	if (!inode_owner_or_capable(inode))
>  		return -EPERM;
> @@ -283,14 +284,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  	if (fsflags & FS_NOCOMP_FL) {
>  		binode->flags &= ~BTRFS_INODE_COMPRESS;
>  		binode->flags |= BTRFS_INODE_NOCOMPRESS;
> -
> -		/* set no-compression no need to validate prop here */
> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
> -					   0, 0);
> -		if (ret && ret != -ENODATA)
> -			goto out_drop;
>  	} else if (fsflags & FS_COMPR_FL) {
> -		const char *comp;
>  
>  		if (IS_SWAPFILE(inode)) {
>  			ret = -ETXTBSY;
> @@ -300,36 +294,40 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  		binode->flags |= BTRFS_INODE_COMPRESS;
>  		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
>  
> -		/* compress_type is already validated during mount options */
>  		comp = btrfs_compress_type2str(fs_info->compress_type);
>  		if (!comp || comp[0] == 0)
>  			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
> -
> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", comp,
> -					   strlen(comp), 0);
> -		if (ret)
> -			goto out_drop;
> -
>  	} else {
> -		/* reset prop, no need of validate prop here */
> -		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
> -					   0, 0);
> -		if (ret && ret != -ENODATA)
> -			goto out_drop;
>  		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
>  	}
>  
> -	trans = btrfs_start_transaction(root, 1);
> +	trans = btrfs_start_transaction(root, 3);

This should reflect if the properties are actually changed or not, so
there's not unnecessary reservation made.

>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
>  		goto out_drop;
>  	}
>  
> +	if (comp) {
> +		ret = btrfs_set_prop(trans, inode, "btrfs.compression", comp,
> +				     strlen(comp), 0);
> +		if (ret)
> +			goto out_abort;

Transaction abort should be done at the place where they happen and not
aggregated.

I see now that the validation is not necessary here.

> +		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
> +	} else {
> +		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL,
> +				     0, 0);
> +		if (ret && ret != -ENODATA)
> +			goto out_abort;

Same.

> +	}
> +
>  	btrfs_sync_inode_flags_to_i_flags(inode);
>  	inode_inc_iversion(inode);
>  	inode->i_ctime = current_time(inode);
>  	ret = btrfs_update_inode(trans, root, inode);
>  
> + out_abort:
> +	if (ret)
> +		btrfs_abort_transaction(trans, ret);
>  	btrfs_end_transaction(trans);
>   out_drop:
>  	if (ret) {
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index e356dd2a0f73..aedf5a7d69c9 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -72,9 +72,9 @@ int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
>  	return handler->validate(value, value_len);
>  }
>  
> -static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
> -			  const char *name, const char *value, size_t value_len,
> -			  int flags)
> +int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
> +		   const char *name, const char *value, size_t value_len,
> +		   int flags)

Exporting a fuction should be in another patch.

>  {
>  	const struct prop_handler *handler;
>  	int ret;
> diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
> index 01d2c1899bc7..30b99348977d 100644
> --- a/fs/btrfs/props.h
> +++ b/fs/btrfs/props.h
> @@ -12,6 +12,9 @@ void __init btrfs_props_init(void);
>  
>  int btrfs_set_prop_trans(struct inode *inode, const char *name,
>  			 const char *value, size_t value_len, int flags);
> +int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
> +		   const char *name, const char *value, size_t value_len,
> +		   int flags);
>  int btrfs_validate_prop(const char *name, const char *value, size_t value_len);
>  
>  int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
> -- 
> 2.17.1
