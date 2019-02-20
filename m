Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20470C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 18:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC03E206C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 18:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfBTS7E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:59:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:34316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfBTS7D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 13:59:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DA567AE3C;
        Wed, 20 Feb 2019 18:59:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B8A3CDA853; Wed, 20 Feb 2019 20:00:22 +0100 (CET)
Date:   Wed, 20 Feb 2019 20:00:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/3] btrfs: kill __btrfs_set_prop()
Message-ID: <20190220190020.GA9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1549937931-15339-1-git-send-email-anand.jain@oracle.com>
 <1549937931-15339-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549937931-15339-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 12, 2019 at 10:18:49AM +0800, Anand Jain wrote:
> btrfs_set_prop() is a redirect to __btrfs_set_prop() with the
> transaction handler equal to NULL. And __btrfs_set_prop() inturn diectly
> uses trans to do_setxattr() which when trans is NULL creates a transaction.

That's right and I think that some of the callsites could actually pass
the existing transaction to btrfs_set_prop instead of relying on the
fallback behaviour.

Also, the potential NULL as transaction handle is not a good thing from
the API point of view and I'd like to reduce that to minimum (there are
some justified cases).

> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3f9d7be30bf4..5a4ed2f66e09 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -284,7 +284,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  		binode->flags &= ~BTRFS_INODE_COMPRESS;
>  		binode->flags |= BTRFS_INODE_NOCOMPRESS;
>  
> -		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
> +		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
> +				     0);
>  		if (ret && ret != -ENODATA)
>  			goto out_drop;
>  	} else if (fsflags & FS_COMPR_FL) {
> @@ -302,13 +303,14 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  		if (!comp || comp[0] == 0)
>  			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
>  
> -		ret = btrfs_set_prop(inode, "btrfs.compression",
> -				     comp, strlen(comp), 0);
> +		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", comp,
> +				     strlen(comp), 0);
>  		if (ret)
>  			goto out_drop;
>  
>  	} else {
> -		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
> +		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
> +				     0);
>  		if (ret && ret != -ENODATA)
>  			goto out_drop;
>  		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);

When the if-else block ends, there's a new transaction started, this
seems unnecessary.

> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index dc6140013ae8..4525a2a4d1cd 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -85,12 +85,9 @@ static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
>  	return NULL;
>  }
>  
> -static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
> -			    struct inode *inode,
> -			    const char *name,
> -			    const char *value,
> -			    size_t value_len,
> -			    int flags)
> +int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
> +		   const char *name, const char *value, size_t value_len,
> +		   int flags)
>  {
>  	const struct prop_handler *handler;
>  	int ret;
> @@ -133,15 +130,6 @@ static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> -int btrfs_set_prop(struct inode *inode,
> -		   const char *name,
> -		   const char *value,
> -		   size_t value_len,
> -		   int flags)
> -{
> -	return __btrfs_set_prop(NULL, inode, name, value, value_len, flags);

I agree that one function would be better here, with defined semantics
of 'trans'.

There are more cleanups around the properties, also in the xattr
handling functions. This patchset is a step in the right direction and I
think the cleanups could be more extensive.

The idea for the xattr function:

- the VFS callbacks (like btrfs_xattr_handler_set_prop) will start the
  transaction themselves and pass the handle to the prop function

- a xattr function that does not take a valid trans could be named like
  btrfs_setxattr_notrans and will start the transaction, ie. lifting
  that to the callers

- there's a maze of the xattr callbacks so assertions are needed
