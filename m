Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325A0C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED0F720811
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="175UWisI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfC1PsX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:48:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49578 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfC1PsX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 11:48:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SFhjr7134766;
        Thu, 28 Mar 2019 15:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=sc/fLePp7sLYvfLqBxBE8Jb+ZMN4qbX8t5nNr1GxHl8=;
 b=175UWisItXxP6ajK5SutkO7cY3DqgQ2Kec4jJhy1kFTiQJ3YP5lmbb2jENAiRglpq1wF
 gEVFFxHfzVQbkxSW+k25HCTZ7oKzI5jltokY7I4Nzf58AIQ5QBPpJQP4takqOhoGwt2j
 hoizl5xRNdKKWC23m/9V973E2qsVeyYlK8hAQ4gOywJtOx5q1iPPrGD95b8SrIf9XSGM
 XSHZw5blhigS9zeJ64rBSg4Y/H4apgbaH78a6HYrQgpyCFaA7duq6GpUiTJJM2Qq9BKp
 DxsslMq/ML+Gtgmc/skxwb2jUimSKHi1x6za/KFA7rderikfdvS3tXi6biQkKKgLlvW7 Pg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2re6djqj2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 15:48:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2SFmHHv024531
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 15:48:17 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2SFmHBc003667;
        Thu, 28 Mar 2019 15:48:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 08:48:17 -0700
Date:   Thu, 28 Mar 2019 08:48:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 15/15] btrfs: Writeprotect mmap pages on snapshot
Message-ID: <20190328154816.GG1172@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-16-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-16-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9209 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280106
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:03:01PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Inorder to make sure mmap'd files don't change after snapshot,
> writeprotect the mmap pages on snapshot. This is done by performing
> a data writeback on the pages (which simply mark the pages are
> wrprotected). This way if the user process tries to access the memory
> we will get another fault and we can perform a CoW.
> 
> In order to accomplish this, we tag all CoW pages as
> PAGECACHE_TAG_TOWRITE, and add the mmapd inode in delalloc_inodes.
> During snapshot, it starts writeback of all delalloc'd inodes and
> here we perform a data writeback. We don't want to keep the inodes
> in delalloc_inodes until it umount (WARN_ON), so we remove it
> during inode evictions.
> 
> This looks hackish. Other alternatives could be to create another
> list for mmap'd files or rename delalloc_inodes to writeback_inodes.
> Suggestions?

Is there a function to invalidate only the writable mappings in the
pagecache?  Could there be?

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/ctree.h |  3 ++-
>  fs/btrfs/dax.c   |  7 +++++++
>  fs/btrfs/inode.c | 13 ++++++++++++-
>  fs/dax.c         |  3 +++
>  4 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 21068dc4a95a..68a63d93556a 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3252,7 +3252,8 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *new_root,
>  			     struct btrfs_root *parent_root,
>  			     u64 new_dirid);
> - void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
> +void btrfs_add_delalloc_inodes(struct btrfs_root *root, struct inode *inode);
> +void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
>  			       unsigned *bits);
>  void btrfs_clear_delalloc_extent(struct inode *inode,
>  				 struct extent_state *state, unsigned *bits);
> diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
> index d73945d50b88..bcb961242c74 100644
> --- a/fs/btrfs/dax.c
> +++ b/fs/btrfs/dax.c
> @@ -166,10 +166,17 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
>  {
>  	vm_fault_t ret;
>  	pfn_t pfn;
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct btrfs_inode *binode = BTRFS_I(inode);
>  	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &pfn, NULL, &btrfs_iomap_ops);
>  	if (ret & VM_FAULT_NEEDDSYNC)
>  		ret = dax_finish_sync_fault(vmf, PE_SIZE_PTE, pfn);
>  
> +	/* Insert into delalloc so we get writeback calls on snapshots */
> +	if (vmf->flags & FAULT_FLAG_WRITE &&
> +			!test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &binode->runtime_flags))
> +		btrfs_add_delalloc_inodes(binode->root, inode);
> +
>  	return ret;
>  }
>  
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5350e5f23728..3b72c1c96b34 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1713,7 +1713,7 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
>  	spin_unlock(&BTRFS_I(inode)->lock);
>  }
>  
> -static void btrfs_add_delalloc_inodes(struct btrfs_root *root,
> +void btrfs_add_delalloc_inodes(struct btrfs_root *root,
>  				      struct inode *inode)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> @@ -5358,12 +5358,17 @@ void btrfs_evict_inode(struct inode *inode)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_trans_handle *trans;
> +	struct btrfs_inode *binode = BTRFS_I(inode);
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_block_rsv *rsv;
>  	int ret;
>  
>  	trace_btrfs_inode_evict(inode);
>  
> +	if (IS_DAX(inode)
> +	    && test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &binode->runtime_flags))
> +		btrfs_del_delalloc_inode(root, binode);
> +
>  	if (!root) {
>  		clear_inode(inode);
>  		return;
> @@ -8683,6 +8688,10 @@ static int btrfs_dax_writepages(struct address_space *mapping,
>  {
>  	struct inode *inode = mapping->host;
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> +	struct btrfs_inode *binode = BTRFS_I(inode);
> +	if ((wbc->sync_mode == WB_SYNC_ALL) &&
> +	    test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &binode->runtime_flags))
> +		btrfs_del_delalloc_inode(binode->root, binode);
>  	return dax_writeback_mapping_range(mapping, fs_info->fs_devices->latest_bdev,
>  			wbc);
>  }
> @@ -9981,6 +9990,8 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
>  	delalloc_work = container_of(work, struct btrfs_delalloc_work,
>  				     work);
>  	inode = delalloc_work->inode;
> +	if (IS_DAX(inode))
> +		filemap_fdatawrite(inode->i_mapping);
>  	filemap_flush(inode->i_mapping);
>  	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
>  				&BTRFS_I(inode)->runtime_flags))
> diff --git a/fs/dax.c b/fs/dax.c
> index 93146142bb00..c42e9cb486ef 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -753,6 +753,9 @@ static void *dax_insert_entry(struct xa_state *xas,
>  	if (dirty)
>  		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
>  
> +	if (cow)
> +		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
> +

Was this supposed to go with the dax_insert_entry changes (patch 9)?

--D

>  	xas_unlock_irq(xas);
>  	return entry;
>  }
> -- 
> 2.16.4
> 
