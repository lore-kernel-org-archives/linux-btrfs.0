Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4407FC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1197B20C01
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfB0QUf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:20:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:54064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbfB0QUf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 11:20:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7FE2AEE8;
        Wed, 27 Feb 2019 16:20:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7E0C7DA83C; Wed, 27 Feb 2019 17:21:54 +0100 (CET)
Date:   Wed, 27 Feb 2019 17:21:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 10/10] btrfs: kill btrfs_setxattr
Message-ID: <20190227162154.GW24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-11-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550857192-10513-11-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 23, 2019 at 01:39:52AM +0800, Anand Jain wrote:
> Now btrfs_setxattr() is a very small function with just check for
> readonly FS and redirect the call to do_setxattr(). So instead
> move that checks to the parent functions.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4: born
>  fs/btrfs/acl.c   |  9 ++++++++-
>  fs/btrfs/props.c | 16 ++++++++++------
>  fs/btrfs/xattr.c | 30 ++++++++----------------------
>  fs/btrfs/xattr.h |  5 ++---
>  4 files changed, 28 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index e395615dd304..75abe7f0d05d 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -60,6 +60,7 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
>  	int ret, size = 0;
>  	const char *name;
>  	char *value = NULL;
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> @@ -95,7 +96,13 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
>  			goto out;
>  	}
>  
> -	ret = btrfs_setxattr(trans, inode, name, value, size, 0);
> +	if (btrfs_root_readonly(root)) {
> +		ret = -EROFS;
> +		goto out;
> +	}
> +
> +	ret = do_setxattr(trans, inode, name, value, size, 0);
> +
>  out:
>  	kfree(value);
>  
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index f878ba3160f0..be6d16ccc738 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -60,6 +60,7 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>  			  const char *name, const char *value, size_t value_len,
>  			  int flags)
>  {
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	const struct prop_handler *handler;
>  	int ret;
>  
> @@ -70,9 +71,12 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>  	if (!handler)
>  		return -EINVAL;
>  
> +	if (btrfs_root_readonly(root))
> +		return -EROFS;
> +
>  	if (value_len == 0) {
> -		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
> -				     flags);
> +		ret = do_setxattr(trans, inode, handler->xattr_name, NULL, 0,
> +				  flags);
>  		if (ret)
>  			return ret;
>  
> @@ -85,14 +89,14 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>  	ret = handler->validate(value, value_len);
>  	if (ret)
>  		return ret;
> -	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
> -			       value, value_len, flags);
> +	ret = do_setxattr(trans, inode, handler->xattr_name, value, value_len,
> +			  flags);
>  	if (ret)
>  		return ret;
>  	ret = handler->apply(inode, value, value_len);
>  	if (ret) {
> -		btrfs_setxattr(trans, inode, handler->xattr_name,
> -				 NULL, 0, flags);
> +		ret = do_setxattr(trans, inode, handler->xattr_name, NULL, 0,
> +				  flags);
>  		return ret;
>  	}
>  
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index b3281d4d95b9..4e1ccfbfa44a 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -76,9 +76,8 @@ int btrfs_getxattr(struct inode *inode, const char *name,
>  	return ret;
>  }
>  
> -static int do_setxattr(struct btrfs_trans_handle *trans,
> -		       struct inode *inode, const char *name,
> -		       const void *value, size_t size, int flags)
> +int do_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
> +		const char *name, const void *value, size_t size, int flags)
>  {
>  	struct btrfs_dir_item *di = NULL;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> @@ -217,22 +216,6 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -/*
> - * @value: "" makes the attribute to empty, NULL removes it
> - */
> -int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
> -		   const char *name, const void *value, size_t size, int flags)
> -{
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
> -
> -	ASSERT(!trans);
> -
> -	if (btrfs_root_readonly(root))
> -		return -EROFS;
> -
> -	return do_setxattr(trans, inode, name, value, size, flags);
> -}
> -
>  ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
>  {
>  	struct btrfs_key key;
> @@ -357,11 +340,14 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
>  
>  	name = xattr_full_name(handler, name);
>  
> +	if (btrfs_root_readonly(root))
> +		return -EROFS;
> +
>  	trans = btrfs_start_transaction(root, 2);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
>  
> -	ret = btrfs_setxattr(trans, inode, name, buffer, size, flags);
> +	ret = do_setxattr(trans, inode, name, buffer, size, flags);
>  
>  	if (!ret) {
>  		inode_inc_iversion(inode);
> @@ -444,8 +430,8 @@ static int btrfs_initxattrs(struct inode *inode,
>  		}
>  		strcpy(name, XATTR_SECURITY_PREFIX);
>  		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
> -		err = btrfs_setxattr(trans, inode, name, xattr->value,
> -				xattr->value_len, 0);
> +		err = do_setxattr(trans, inode, name, xattr->value,
> +				  xattr->value_len, 0);
>  		kfree(name);
>  		if (err < 0)
>  			break;
> diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
> index 471fcac6ff55..276f81a622d5 100644
> --- a/fs/btrfs/xattr.h
> +++ b/fs/btrfs/xattr.h
> @@ -12,9 +12,8 @@
>  
>  int btrfs_getxattr(struct inode *inode, const char *name,
>  		void *buffer, size_t size);
> -int btrfs_setxattr(struct btrfs_trans_handle *trans,
> -			    struct inode *inode, const char *name,
> -			    const void *value, size_t size, int flags);
> +int do_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
> +		const char *name, const void *value, size_t size, int flags);

No, this is backwards. Why do you promote a static helper to interface
function but without the btrfs_ prefix?

The point of do_something functions is to actually do the thing assuming
that external conditions have been checked, like the readonly status.
All such checks should happen at the entry, ie. beginning of the various
callbacks.
