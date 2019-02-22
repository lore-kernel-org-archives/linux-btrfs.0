Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A832C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 12:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B77F2070D
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 12:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfJhmR87"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfBVMrP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:47:15 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45384 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfBVMrO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 07:47:14 -0500
Received: by mail-ed1-f65.google.com with SMTP id d9so1622400edh.12
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 04:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SpYaOHE6e+pPCap38VaUcdyVkBMoHtI/j387bdACpr0=;
        b=dfJhmR87uhGZoTbGrtvd1FcUAZpjmdhm3Yg4u+/q5AHjrGqaRnYmSAjfX06cxarWoT
         dF9d2Zv5QBTFyvRH8Kk37P/u6bvrds4suTWame3QKtZ2xrMWKBQWl9M8OZ8j2yQF4C8W
         IKZ0If/FDqJZPWHZGkTu2enF3t6hrCTf5Qu4tif1ak/r2k8cvzEHJYRVZ0NipYaxzzog
         MEcOafMZruGjEF1e787Y/6IHzspHOu/WQznCVaA+ucLbvV/PeJ9rxvkSwmOXoZsHbjOZ
         Yo+0Tv4zOVLrMDjo1RMWwieItq3bxAo/sAyTXqFBkwT619OsVPfJx9f9eKBeXHsPV95E
         xv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SpYaOHE6e+pPCap38VaUcdyVkBMoHtI/j387bdACpr0=;
        b=npqxAX/kHJYwYQs3TA5btKn61kHlg5zBBOJ36eH/O57zF+Bd7nGoUQYUcofEmAxN0L
         m6ugNglkKXocBp2rKMtdkS8IKQSkesbiiqinNvsSSoCNXAC8bj54I1DdGrb4E5dr1sXd
         r/jQX6H9I98r7zTkw0JQkpCojKyJRBrZ2+KIsX0hCLKYSR+fttONm5PnzugbpmBE3RBF
         JAYbEu6/I+SXZ8JOWG1cqzNQyH7zZC6rtxEW6Znr/SrRYENuPa/woq9KVNedq+rocKI3
         77AFfboxTNzLLoR97E9CCBixwnqWcSmaGoc/80bRwDdSELgu+ghi6DH8LF/dGh0N9dVR
         kDOg==
X-Gm-Message-State: AHQUAubagLIuP7NDGkQQCEIlnDQeZHULZt1YQUAjBT0OEYG9WOeDTd+7
        5t6y4ZNiLkl1RjbGMIXSKD0=
X-Google-Smtp-Source: AHgI3IauiGp0bCGIF4cgiCwEM5c6zS+Kjzi32PDjtx6QYJ0v+dM+/7fp+mg6Dqx4s769foTr6XSw5A==
X-Received: by 2002:a50:b699:: with SMTP id d25mr3178878ede.110.1550839632144;
        Fri, 22 Feb 2019 04:47:12 -0800 (PST)
Received: from [10.20.1.223] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id j6sm375391edd.43.2019.02.22.04.47.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 04:47:10 -0800 (PST)
Subject: Re: [PATCH 5/5] btrfs: extent_io: Unify the return value of
 btrfs_clone_extent_buffer() with alloc_extent_buffer()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
 <20190222101645.4403-6-wqu@suse.com>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <a0226a9c-d842-457d-240a-89d622476065@gmail.com>
Date:   Fri, 22 Feb 2019 14:47:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190222101645.4403-6-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 22.02.19 г. 12:16 ч., Qu Wenruo wrote:
> The direct callers are:
> 1) qgroup_rescan_leaf()
> 2) btrfs_compare_trees()
>    These two call sites are stubs.
> 
> 3) tree_mod_log_rewind()
> 4) get_old_root()
>    These two doesn't follow the name pattern *_extent_buffer(), thus we
>    don't need to unify their return value.
>    However for get_old_root(), all its eb assignment can no longer be
>    NULL, change its IS_ERR_OR_NULL() to IS_ERR().
> 
> 5) btrfs_search_slot_get_root()
>    This is a stub. The only caller has already handled the return value.
> 
> This patch should cover all the call sites of
> btrfs_clone_extent_buffer().
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c   |  8 ++++----
>  fs/btrfs/ctree.c     | 14 ++++++++------
>  fs/btrfs/extent_io.c |  4 ++--
>  fs/btrfs/qgroup.c    |  5 +++--
>  4 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 78556447e1d5..b6e469a12011 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -2016,8 +2016,8 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
>  		parent = found_key.offset;
>  		slot = path->slots[0];
>  		eb = btrfs_clone_extent_buffer(path->nodes[0]);
> -		if (!eb) {
> -			ret = -ENOMEM;
> +		if (IS_ERR(eb)) {
> +			ret = PTR_ERR(eb);
>  			break;
>  		}
>  		btrfs_release_path(path);
> @@ -2075,8 +2075,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
>  
>  		slot = path->slots[0];
>  		eb = btrfs_clone_extent_buffer(path->nodes[0]);
> -		if (!eb) {
> -			ret = -ENOMEM;
> +		if (IS_ERR(eb)) {
> +			ret = PTR_ERR(eb);
>  			break;
>  		}
>  		btrfs_release_path(path);
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 3276b743f40a..ea7ff0012007 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1384,7 +1384,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  		free_extent_buffer(eb_root);
>  	}
>  
> -	if (IS_ERR_OR_NULL(eb))
> +	if (IS_ERR(eb))
>  		return NULL;
>  	btrfs_tree_read_lock(eb);
>  	if (old_root) {
> @@ -2624,8 +2624,8 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
>  			down_read(&fs_info->commit_root_sem);
>  			b = btrfs_clone_extent_buffer(root->commit_root);
>  			up_read(&fs_info->commit_root_sem);
> -			if (!b)
> -				return ERR_PTR(-ENOMEM);
> +			if (IS_ERR(b))
> +				return b;
>  
>  		} else {
>  			b = root->commit_root;
> @@ -5431,7 +5431,8 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
>  			btrfs_clone_extent_buffer(left_root->commit_root);
>  	if (!left_path->nodes[left_level]) {
>  		up_read(&fs_info->commit_root_sem);
> -		ret = -ENOMEM;
> +		ret = PTR_ERR(left_path->nodes[left_level]);
> +		left_path->nodes[left_level] = NULL;

If we go into this branch this means left_path->nodes[left_level] was
NULL. PTR_ERR of NULL is, well, NULL and then you also set the
left_level to NULL. This is pointless...

>  		goto out;
>  	}
>  
> @@ -5439,9 +5440,10 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
>  	right_root_level = right_level;
>  	right_path->nodes[right_level] =
>  			btrfs_clone_extent_buffer(right_root->commit_root);
> -	if (!right_path->nodes[right_level]) {
> +	if (IS_ERR(right_path->nodes[right_level])) {

And here you do change the check to IS_ERR but only for the right_Path
and not left path this introduces asymmetry which makes code harder to
comprehend.

>  		up_read(&fs_info->commit_root_sem);
> -		ret = -ENOMEM;
> +		ret = PTR_ERR(right_path->nodes[right_level]);
> +		right_path->nodes[right_level] = NULL;
>  		goto out;
>  	}
>  	up_read(&fs_info->commit_root_sem);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index a19bd8bc3b32..dbdb649f1957 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4713,13 +4713,13 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>  
>  	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
>  	if (IS_ERR(new))
> -		return NULL;
> +		return new;
>  
>  	for (i = 0; i < num_pages; i++) {
>  		p = alloc_page(GFP_NOFS);
>  		if (!p) {
>  			btrfs_release_extent_buffer(new);
> -			return NULL;
> +			return ERR_PTR(-ENOMEM);
>  		}
>  		attach_extent_buffer_page(new, p);
>  		WARN_ON(PageDirty(p));
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4e473a998219..ccfa992a10bf 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3105,8 +3105,9 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
>  	fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
>  
>  	scratch_leaf = btrfs_clone_extent_buffer(path->nodes[0]);
> -	if (!scratch_leaf) {
> -		ret = -ENOMEM;
> +	if (IS_ERR(scratch_leaf)) {
> +		ret = PTR_ERR(scratch_leaf);
> +		scratch_leaf = NULL;
>  		mutex_unlock(&fs_info->qgroup_rescan_lock);
>  		goto out;
>  	}
> 
