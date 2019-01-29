Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACD9C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 07:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D18052148E
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 07:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbfA2Hxh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:53:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:44912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbfA2Hxh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 02:53:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B6D3FAEA1;
        Tue, 29 Jan 2019 07:53:35 +0000 (UTC)
Subject: Re: [PATCH 03/11] btrfs: manage heuristic workspace as index 0
To:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-4-dennis@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <4bc26773-da13-3730-afda-78d672f348bc@suse.com>
Date:   Tue, 29 Jan 2019 09:53:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190128212437.11597-4-dennis@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> While the heuristic workspaces aren't really compression workspaces,
> they use the same interface for managing them. So rather than branching,
> let's just handle them once again as the index 0 compression type.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Nikolay Borisov <nborisov@suse.com> albeit one minor nit
below.
> ---
>  fs/btrfs/compression.c  | 107 +++++++++++-----------------------------
>  fs/btrfs/compression.h  |   3 +-
>  fs/btrfs/ioctl.c        |   2 +-
>  fs/btrfs/tree-checker.c |   4 +-
>  4 files changed, 33 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index aced261984e2..bda7e8d2cbc7 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -37,6 +37,8 @@ const char* btrfs_compress_type2str(enum btrfs_compression_type type)
>  	case BTRFS_COMPRESS_ZSTD:
>  	case BTRFS_COMPRESS_NONE:
>  		return btrfs_compress_types[type];
> +	default:
> +		return NULL;

nit: With this change...

>  	}
>  
>  	return NULL;

This becomes redundant. I doubt the compiler will issue a warning since
it should be clever enough to figure we will never exit the switch()
construct.

> @@ -769,6 +771,11 @@ static struct list_head *alloc_heuristic_ws(void)
>  	return ERR_PTR(-ENOMEM);
>  }
>  
> +const struct btrfs_compress_op btrfs_heuristic_compress = {
> +	.alloc_workspace = alloc_heuristic_ws,
> +	.free_workspace = free_heuristic_ws,
> +};
> +
>  struct workspace_manager {
>  	struct list_head idle_ws;
>  	spinlock_t ws_lock;
> @@ -782,9 +789,8 @@ struct workspace_manager {
>  
>  static struct workspace_manager wsm[BTRFS_COMPRESS_TYPES];
>  
> -static struct workspace_manager btrfs_heuristic_ws;
> -
>  static const struct btrfs_compress_op * const btrfs_compress_op[] = {
> +	&btrfs_heuristic_compress,
>  	&btrfs_zlib_compress,
>  	&btrfs_lzo_compress,
>  	&btrfs_zstd_compress,
> @@ -795,21 +801,6 @@ void __init btrfs_init_compress(void)
>  	struct list_head *workspace;
>  	int i;
>  
> -	INIT_LIST_HEAD(&btrfs_heuristic_ws.idle_ws);
> -	spin_lock_init(&btrfs_heuristic_ws.ws_lock);
> -	atomic_set(&btrfs_heuristic_ws.total_ws, 0);
> -	init_waitqueue_head(&btrfs_heuristic_ws.ws_wait);
> -
> -	workspace = alloc_heuristic_ws();
> -	if (IS_ERR(workspace)) {
> -		pr_warn(
> -	"BTRFS: cannot preallocate heuristic workspace, will try later\n");
> -	} else {
> -		atomic_set(&btrfs_heuristic_ws.total_ws, 1);
> -		btrfs_heuristic_ws.free_ws = 1;
> -		list_add(workspace, &btrfs_heuristic_ws.idle_ws);
> -	}
> -
>  	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
>  		INIT_LIST_HEAD(&wsm[i].idle_ws);
>  		spin_lock_init(&wsm[i].ws_lock);
> @@ -837,11 +828,10 @@ void __init btrfs_init_compress(void)
>   * Preallocation makes a forward progress guarantees and we do not return
>   * errors.
>   */
> -static struct list_head *__find_workspace(int type, bool heuristic)
> +static struct list_head *find_workspace(int type)
>  {
>  	struct list_head *workspace;
>  	int cpus = num_online_cpus();
> -	int idx = type - 1;
>  	unsigned nofs_flag;
>  	struct list_head *idle_ws;
>  	spinlock_t *ws_lock;
> @@ -849,19 +839,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
>  	wait_queue_head_t *ws_wait;
>  	int *free_ws;
>  
> -	if (heuristic) {
> -		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
> -		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
> -		total_ws = &btrfs_heuristic_ws.total_ws;
> -		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
> -		free_ws	 = &btrfs_heuristic_ws.free_ws;
> -	} else {
> -		idle_ws	 = &wsm[idx].idle_ws;
> -		ws_lock	 = &wsm[idx].ws_lock;
> -		total_ws = &wsm[idx].total_ws;
> -		ws_wait	 = &wsm[idx].ws_wait;
> -		free_ws	 = &wsm[idx].free_ws;
> -	}
> +	idle_ws	 = &wsm[type].idle_ws;
> +	ws_lock	 = &wsm[type].ws_lock;
> +	total_ws = &wsm[type].total_ws;
> +	ws_wait	 = &wsm[type].ws_wait;
> +	free_ws	 = &wsm[type].free_ws;
>  
>  again:
>  	spin_lock(ws_lock);
> @@ -892,10 +874,7 @@ static struct list_head *__find_workspace(int type, bool heuristic)
>  	 * context of btrfs_compress_bio/btrfs_compress_pages
>  	 */
>  	nofs_flag = memalloc_nofs_save();
> -	if (heuristic)
> -		workspace = alloc_heuristic_ws();
> -	else
> -		workspace = btrfs_compress_op[idx]->alloc_workspace();
> +	workspace = btrfs_compress_op[type]->alloc_workspace();
>  	memalloc_nofs_restore(nofs_flag);
>  
>  	if (IS_ERR(workspace)) {
> @@ -926,38 +905,23 @@ static struct list_head *__find_workspace(int type, bool heuristic)
>  	return workspace;
>  }
>  
> -static struct list_head *find_workspace(int type)
> -{
> -	return __find_workspace(type, false);
> -}
> -
>  /*
>   * put a workspace struct back on the list or free it if we have enough
>   * idle ones sitting around
>   */
> -static void __free_workspace(int type, struct list_head *workspace,
> -			     bool heuristic)
> +static void free_workspace(int type, struct list_head *workspace)
>  {
> -	int idx = type - 1;
>  	struct list_head *idle_ws;
>  	spinlock_t *ws_lock;
>  	atomic_t *total_ws;
>  	wait_queue_head_t *ws_wait;
>  	int *free_ws;
>  
> -	if (heuristic) {
> -		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
> -		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
> -		total_ws = &btrfs_heuristic_ws.total_ws;
> -		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
> -		free_ws	 = &btrfs_heuristic_ws.free_ws;
> -	} else {
> -		idle_ws	 = &wsm[idx].idle_ws;
> -		ws_lock	 = &wsm[idx].ws_lock;
> -		total_ws = &wsm[idx].total_ws;
> -		ws_wait	 = &wsm[idx].ws_wait;
> -		free_ws	 = &wsm[idx].free_ws;
> -	}
> +	idle_ws	 = &wsm[type].idle_ws;
> +	ws_lock	 = &wsm[type].ws_lock;
> +	total_ws = &wsm[type].total_ws;
> +	ws_wait	 = &wsm[type].ws_wait;
> +	free_ws	 = &wsm[type].free_ws;
>  
>  	spin_lock(ws_lock);
>  	if (*free_ws <= num_online_cpus()) {
> @@ -968,20 +932,12 @@ static void __free_workspace(int type, struct list_head *workspace,
>  	}
>  	spin_unlock(ws_lock);
>  
> -	if (heuristic)
> -		free_heuristic_ws(workspace);
> -	else
> -		btrfs_compress_op[idx]->free_workspace(workspace);
> +	btrfs_compress_op[type]->free_workspace(workspace);
>  	atomic_dec(total_ws);
>  wake:
>  	cond_wake_up(ws_wait);
>  }
>  
> -static void free_workspace(int type, struct list_head *ws)
> -{
> -	return __free_workspace(type, ws, false);
> -}
> -
>  /*
>   * cleanup function for module exit
>   */
> @@ -990,13 +946,6 @@ static void free_workspaces(void)
>  	struct list_head *workspace;
>  	int i;
>  
> -	while (!list_empty(&btrfs_heuristic_ws.idle_ws)) {
> -		workspace = btrfs_heuristic_ws.idle_ws.next;
> -		list_del(workspace);
> -		free_heuristic_ws(workspace);
> -		atomic_dec(&btrfs_heuristic_ws.total_ws);
> -	}
> -
>  	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
>  		while (!list_empty(&wsm[i].idle_ws)) {
>  			workspace = wsm[i].idle_ws.next;
> @@ -1042,8 +991,8 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
>  
>  	workspace = find_workspace(type);
>  
> -	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
> -	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
> +	btrfs_compress_op[type]->set_level(workspace, type_level);
> +	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
>  						      start, pages,
>  						      out_pages,
>  						      total_in, total_out);
> @@ -1072,7 +1021,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
>  	int type = cb->compress_type;
>  
>  	workspace = find_workspace(type);
> -	ret = btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
> +	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
>  	free_workspace(type, workspace);
>  
>  	return ret;
> @@ -1091,7 +1040,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
>  
>  	workspace = find_workspace(type);
>  
> -	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
> +	ret = btrfs_compress_op[type]->decompress(workspace, data_in,
>  						  dest_page, start_byte,
>  						  srclen, destlen);
>  
> @@ -1512,7 +1461,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
>   */
>  int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
>  {
> -	struct list_head *ws_list = __find_workspace(0, true);
> +	struct list_head *ws_list = find_workspace(0);
>  	struct heuristic_ws *ws;
>  	u32 i;
>  	u8 byte;
> @@ -1581,7 +1530,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
>  	}
>  
>  out:
> -	__free_workspace(0, ws_list, true);
> +	free_workspace(0, ws_list);
>  	return ret;
>  }
>  
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index 69a9197dadc3..53a8b9e93217 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -97,7 +97,7 @@ enum btrfs_compression_type {
>  	BTRFS_COMPRESS_ZLIB  = 1,
>  	BTRFS_COMPRESS_LZO   = 2,
>  	BTRFS_COMPRESS_ZSTD  = 3,
> -	BTRFS_COMPRESS_TYPES = 3,
> +	BTRFS_COMPRESS_TYPES = 4,
>  };
>  
>  struct btrfs_compress_op {
> @@ -125,6 +125,7 @@ struct btrfs_compress_op {
>  	void (*set_level)(struct list_head *ws, unsigned int type);
>  };
>  
> +extern const struct btrfs_compress_op btrfs_heuristic_compress;
>  extern const struct btrfs_compress_op btrfs_zlib_compress;
>  extern const struct btrfs_compress_op btrfs_lzo_compress;
>  extern const struct btrfs_compress_op btrfs_zstd_compress;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9c8e1734429c..20081465a451 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1410,7 +1410,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		return -EINVAL;
>  
>  	if (do_compress) {
> -		if (range->compress_type > BTRFS_COMPRESS_TYPES)
> +		if (range->compress_type >= BTRFS_COMPRESS_TYPES)
>  			return -EINVAL;
>  		if (range->compress_type)
>  			compress_type = range->compress_type;
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index a62e1e837a89..c88e146d8e99 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -133,9 +133,9 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
>  	 * Support for new compression/encryption must introduce incompat flag,
>  	 * and must be caught in open_ctree().
>  	 */
> -	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
> +	if (btrfs_file_extent_compression(leaf, fi) >= BTRFS_COMPRESS_TYPES) {
>  		file_extent_err(fs_info, leaf, slot,
> -	"invalid compression for file extent, have %u expect range [0, %u]",
> +	"invalid compression for file extent, have %u expect range [0, %u)",
>  			btrfs_file_extent_compression(leaf, fi),
>  			BTRFS_COMPRESS_TYPES);
>  		return -EUCLEAN;
> 
