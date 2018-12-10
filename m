Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E91FC04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 08:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F345020821
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 08:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F345020821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbeLJIs0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 03:48:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:55364 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbeLJIs0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 03:48:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47885AE3D;
        Mon, 10 Dec 2018 08:48:23 +0000 (UTC)
Subject: Re: [PATCH v2] Btrfs: use generic_remap_file_range_prep() for cloning
 and deduplication
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181207132453.5455-1-fdmanana@kernel.org>
 <20181207152538.19269-1-fdmanana@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d4bce2da-7803-8e5c-90a2-1ef8fe6be05f@suse.com>
Date:   Mon, 10 Dec 2018 10:48:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181207152538.19269-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 7.12.18 г. 17:25 ч., fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Since cloning and deduplication are no longer Btrfs specific operations, we
> now have generic code to handle parameter validation, compare file ranges
> used for deduplication, clear capabilities when cloning, etc. This change
> makes Btrfs use it, eliminating a lot of code in Btrfs and also fixing a
> few bugs, such as:
> 
> 1) When cloning, the destination file's capabilities were not dropped
>    (the fstest generic/513 tests this);
> 
> 2) We were not checking if the destination file is immutable;
> 
> 3) Not checking if either the source or destination files are swap
>    files (swap file support is coming soon for Btrfs);
> 
> 4) System limits were not checked (resource limits and O_LARGEFILE).
> 
> Note that the generic helper generic_remap_file_range_prep() does start
> and waits for writeback by calling filemap_write_and_wait_range(), however
> that is not enough for Btrfs for two reasons:
> 
> 1) With compression, we need to start writeback twice in order to get the
>    pages marked for writeback and ordered extents created;
> 
> 2) filemap_write_and_wait_range() (and all its other variants) only waits
>    for the IO to complete, but we need to wait for the ordered extents to
>    finish, so that when we do the actual reflinking operations the file
>    extent items are in the fs tree. This is also important due to the fact
>    that the generic helper, for the deduplication case, compares the
>    contents of the pages in the requested range, which might require
>    reading extents from disk in the very unlikely case that pages get
>    invalidated after writeback finishes (so the file extent items must be
>    up to date in the fs tree).
> 
> Since these reasons are specific to Btrfs we have to do it in the Btrfs
> code before calling generic_remap_file_range_prep(). This also results in
> a more simple way of dealing with existing delalloc in the source/target
> ranges, specially for the deduplication case where we used to lock all the
> pages first and then if we found any dealloc for the range, or ordered
> extent, we would unlock the pages trigger writeback and wait for ordered
> extents to complete, then lock all the pages again and check if
> deduplication can be done. So now we get a simpler approach: lock the
> inodes, then trigger writeback and then wait for ordered extents to
> complete.
> 
> So make btrfs use generic_remap_file_range_prep() (XFS and OCFS2 use it)
> to eliminate duplicated code, fix a few bugs and benefit from future bug
> fixes done there - for example the recent clone and dedupe bugs involving
> reflinking a partial EOF block got a counterpart fix in the generic helpe,
> since it affected all filesystems supporting these operations, so we no
> longer need special checks in Btrfs for them.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Two minor suggestions but other LGTM so:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> V2: Removed check that verifies if either of the inodes is a directory,
>     as it is done by generic_remap_file_range_prep(). Oddly in btrfs was being
>     done only for cloning but not for dedupe.
> 
>  fs/btrfs/ioctl.c | 612 ++++++++++++-------------------------------------------
>  1 file changed, 129 insertions(+), 483 deletions(-)
> 

<snip>

> @@ -4213,11 +3854,9 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>  	struct inode *inode = file_inode(file);
>  	struct inode *src = file_inode(file_src);
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);

nit: This variable can be removed  and btrfs_sb...

> -	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	int ret;
>  	u64 len = olen;
>  	u64 bs = fs_info->sb->s_blocksize;

can be used directly here, since we only care about the blocksize, saves
sizeof(void *) worth of bytes on the stack.

> -	int same_inode = src == inode;
>  
>  	/*
>  	 * TODO:
> @@ -4230,101 +3869,32 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>  	 *   be either compressed or non-compressed.
>  	 */
>  
> -	if (btrfs_root_readonly(root))
> -		return -EROFS;
> -
> -	if (file_src->f_path.mnt != file->f_path.mnt ||
> -	    src->i_sb != inode->i_sb)
> -		return -EXDEV;
> -
> -	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
> -		return -EISDIR;
> -
> -	if (!same_inode) {
> -		btrfs_double_inode_lock(src, inode);
> -	} else {
> -		inode_lock(src);
> -	}
> -
>  	/* don't make the dst file partly checksummed */
>  	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> -	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
> -		ret = -EINVAL;
> -		goto out_unlock;
> -	}
> +	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
> +		return -EINVAL;

This common check between btrfs_extent_same and btrfs_clone_files can be
factored out to btrfs_remap_file_range_prep or btrfs_remap_file_range

>  
> -	/* determine range to clone */
> -	ret = -EINVAL;
> -	if (off + len > src->i_size || off + len < off)
> -		goto out_unlock;
> -	if (len == 0)
> -		olen = len = src->i_size - off;

<snip>
>  }
>  
> 
