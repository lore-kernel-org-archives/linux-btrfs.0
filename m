Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301CFC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 068572087C
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfCHOz2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:55:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:49910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726729AbfCHOz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 09:55:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BB14AAAE;
        Fri,  8 Mar 2019 14:55:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 651C3DA93A; Fri,  8 Mar 2019 15:56:44 +0100 (CET)
Date:   Fri, 8 Mar 2019 15:56:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 9/9] btrfs: kill btrfs_setxattr
Message-ID: <20190308145642.GS31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
 <1551414895-22925-10-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551414895-22925-10-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 01, 2019 at 12:34:55PM +0800, Anand Jain wrote:
> Now btrfs_setxattr() is a very small function with just check for
> readonly FS and redirect the call to do_setxattr(). So instead
> move that checks to the parent functions and call do_setxattr()
> directly.  Delete original btrfs_setxattr(), and rename do_setxattr()
> to btrfs_setxattr(). Also add few c-style. Kindly note the arguments
> of original do_setxattr() and original btrfs_setxattr() are same, so the
> diff obliterates the changes as described above.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v5: rename do_setxattr() to btrfs_setxattr(). change log update. fix c-style. 
> v4: born
>  fs/btrfs/acl.c   |  7 +++++++
>  fs/btrfs/props.c | 16 ++++++++++------
>  fs/btrfs/xattr.c | 29 +++++++++--------------------
>  fs/btrfs/xattr.h |  5 ++---
>  4 files changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 2b9c3394fc34..a8a1060c8cbe 100644
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
> +	if (btrfs_root_readonly(root)) {
> +		ret = -EROFS;
> +		goto out;

All the readonly checks needs to go first as it's the global condition,
the following checks make sure that the arguments are valid and depend
on the previous.

> -		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
> -				       NULL, 0, flags);
> +		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
> +				     flags);

drive-by change

>  		if (ret)
>  			return ret;
>  
> @@ -85,14 +89,14 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
>  	ret = handler->validate(value, value_len);
>  	if (ret)
>  		return ret;
> -	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
> -			       value, value_len, flags);
> +	ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
> +			     value_len, flags);

same

>  	if (ret)
>  		return ret;
>  	ret = handler->apply(inode, value, value_len);
>  	if (ret) {
> -		btrfs_setxattr(trans, inode, handler->xattr_name,
> -				 NULL, 0, flags);
> +		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
> +				     flags);

And that one silently changes the return value semantics but looks like
the other two, "just fixing the indentation". The original code does not
set 'ret' as the whole operation returns what the property handler
returned.

The setxattr call here resets the property. If this is not the
right, then fixed separately.
