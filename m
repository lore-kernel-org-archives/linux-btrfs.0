Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EC6C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 15:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D90FF218D8
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 15:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfCUPkB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:40:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:32862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfCUPkB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 11:40:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B47DACCD
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 15:40:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 53BD0DA825; Thu, 21 Mar 2019 16:41:13 +0100 (CET)
Date:   Thu, 21 Mar 2019 16:41:10 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Defer setting new inode mode until after
 do_set_acl succeeds
Message-ID: <20190321154110.GD8120@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190321092703.8136-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321092703.8136-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 21, 2019 at 11:27:03AM +0200, Nikolay Borisov wrote:
> Currently a reference to inode->i_mode is passed directly to
> posix_acl_update_mode when setting an ACL which results in the inode's
> mode always being changed. In case of errors (e.g. in do_set_acl or
> even starting a transaction) the old mode needs to be re-assigned to
> ->i_mode. This mode recovery is done only in case do_set_acl fails,
> which leads to buggy behavior in case btrfs_start_transaction fails.
> 
> Fix it by simply setting the new mode to a temporary variable which is
> assigned to inode->i_mode's only when do_set_acl succeeds. This covers
> both failure cases explained above.
> 
> Fixes: db0f220e98eb ("btrfs: start transaction in btrfs_set_acl")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/acl.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index b722866e1442..a0cfd2049ea5 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -99,7 +99,6 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
>  	}
>  
>  	ret = btrfs_setxattr(trans, inode, name, value, size, 0);
> -
>  out:
>  	kfree(value);
>  
> @@ -112,12 +111,12 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
>  int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	int ret;
> -	umode_t old_mode = inode->i_mode;
> +	umode_t mode;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  
>  	if (type == ACL_TYPE_ACCESS && acl) {
> -		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> +		ret = posix_acl_update_mode(inode, &mode, &acl);
>  		if (ret)
>  			return ret;
>  	}
> @@ -127,9 +126,8 @@ int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		return PTR_ERR(trans);
>  
>  	ret = do_set_acl(trans, inode, acl, type);
> -	if (ret) {
> -		inode->i_mode = old_mode;
> -	} else {
> +	if (!ret) {
> +		inode->i_mode = mode;

I like this flow much better, ie. update i_mod only if it's correct,
otherwise it's a no-op. Then we don't have to revert the change on each
possible error.

The patch that causes it is still in misc-next so the hash is not stable
and we can't use it for reference. So I suggest to fold the single
i_mode after transaction to "btrfs: start transaction in btrfs_set_acl"
and your patch can rework the i_mode handling.

We'll see when you see V2 if this could work or just go with a single
patch.
