Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A8CC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 08:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E1A2177E
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 08:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfA2IJC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:09:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:46690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfA2IJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 03:09:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8C08FAF3D;
        Tue, 29 Jan 2019 08:08:58 +0000 (UTC)
Subject: Re: [PATCH 08/11] btrfs: plumb level through the compression
 interface
To:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-9-dennis@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ebc38878-5311-ac46-7384-560dd4dd24cb@suse.com>
Date:   Tue, 29 Jan 2019 10:08:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190128212437.11597-9-dennis@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> Zlib compression supports multiple levels, but doesn't require changing
> in how a workspace itself is created and managed. Zstd introduces a
> different memory requirement such that higher levels of compression
> require more memory. This requires changes in how the alloc()/get()
> methods work for zstd. This pach plumbs compression level through the
> interface as a parameter in preparation for zstd compression levels.
> This gives the compression types opportunity to create/manage based on
> the compression level.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/compression.c | 31 ++++++++++++++++---------------
>  fs/btrfs/compression.h |  7 ++++---
>  fs/btrfs/lzo.c         |  6 +++---
>  fs/btrfs/zlib.c        |  7 ++++---
>  fs/btrfs/zstd.c        |  6 +++---
>  5 files changed, 30 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ab694760ffdb..e509071eaa69 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -744,9 +744,9 @@ static void heuristic_cleanup_workspace_manager(void)
>  	btrfs_cleanup_workspace_manager(&heuristic_wsm);
>  }
>  
> -static struct list_head *heuristic_get_workspace(void)
> +static struct list_head *heuristic_get_workspace(unsigned int level)
>  {
> -	return btrfs_get_workspace(&heuristic_wsm);
> +	return btrfs_get_workspace(&heuristic_wsm, level);
>  }
>  
>  static void heuristic_put_workspace(struct list_head *ws)
> @@ -766,7 +766,7 @@ static void free_heuristic_ws(struct list_head *ws)
>  	kfree(workspace);
>  }
>  
> -static struct list_head *alloc_heuristic_ws(void)
> +static struct list_head *alloc_heuristic_ws(unsigned int level)
>  {
>  	struct heuristic_ws *ws;
>  
> @@ -825,7 +825,7 @@ void btrfs_init_workspace_manager(struct workspace_manager *wsm,
>  	 * Preallocate one workspace for each compression type so
>  	 * we can guarantee forward progress in the worst case
>  	 */
> -	workspace = wsm->ops->alloc_workspace();
> +	workspace = wsm->ops->alloc_workspace(0);
>  	if (IS_ERR(workspace)) {
>  		pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
>  	} else {
> @@ -853,7 +853,8 @@ void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
>   * Preallocation makes a forward progress guarantees and we do not return
>   * errors.
>   */
> -struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
> +struct list_head *btrfs_get_workspace(struct workspace_manager *wsm,
> +				      unsigned int level)
>  {
>  	struct list_head *workspace;
>  	int cpus = num_online_cpus();
> @@ -899,7 +900,7 @@ struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
>  	 * context of btrfs_compress_bio/btrfs_compress_pages
>  	 */
>  	nofs_flag = memalloc_nofs_save();
> -	workspace = wsm->ops->alloc_workspace();
> +	workspace = wsm->ops->alloc_workspace(level);
>  	memalloc_nofs_restore(nofs_flag);
>  
>  	if (IS_ERR(workspace)) {
> @@ -930,9 +931,9 @@ struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
>  	return workspace;
>  }
>  
> -static struct list_head *get_workspace(int type)
> +static struct list_head *get_workspace(int type, int level)
>  {
> -	return btrfs_compress_op[type]->get_workspace();
> +	return btrfs_compress_op[type]->get_workspace(level);
>  }
>  
>  /*
> @@ -1003,12 +1004,13 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
>  			 unsigned long *total_out)
>  {
>  	int type = BTRFS_COMPRESS_TYPE(type_level);
> +	int level = BTRFS_COMPRESS_LEVEL(type_level);
>  	struct list_head *workspace;
>  	int ret;
>  
> -	workspace = get_workspace(type);
> +	workspace = get_workspace(type, level);
>  
> -	btrfs_compress_op[type]->set_level(workspace, type_level);
> +	btrfs_compress_op[type]->set_level(workspace, level);
>  	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
>  						      start, pages,
>  						      out_pages,
> @@ -1037,7 +1039,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
>  	int ret;
>  	int type = cb->compress_type;
>  
> -	workspace = get_workspace(type);
> +	workspace = get_workspace(type, 0);
>  	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
>  	put_workspace(type, workspace);
>  
> @@ -1055,13 +1057,12 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
>  	struct list_head *workspace;
>  	int ret;
>  
> -	workspace = get_workspace(type);
> -
> +	workspace = get_workspace(type, 0);
>  	ret = btrfs_compress_op[type]->decompress(workspace, data_in,
>  						  dest_page, start_byte,
>  						  srclen, destlen);
> -
>  	put_workspace(type, workspace);
> +
>  	return ret;
>  }
>  
> @@ -1489,7 +1490,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
>   */
>  int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
>  {
> -	struct list_head *ws_list = get_workspace(0);
> +	struct list_head *ws_list = get_workspace(0, 0);
>  	struct heuristic_ws *ws;
>  	u32 i;
>  	u8 byte;
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index 05342ad081d6..e3627139bc5c 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -114,7 +114,8 @@ struct workspace_manager {
>  
>  void btrfs_init_workspace_manager(struct workspace_manager *wsm,
>  				  const struct btrfs_compress_op *ops);
> -struct list_head *btrfs_get_workspace(struct workspace_manager *wsm);
> +struct list_head *btrfs_get_workspace(struct workspace_manager *wsm,
> +				      unsigned int level);
>  void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws);
>  void btrfs_cleanup_workspace_manager(struct workspace_manager *wsm);
>  
> @@ -123,11 +124,11 @@ struct btrfs_compress_op {
>  
>  	void (*cleanup_workspace_manager)(void);
>  
> -	struct list_head *(*get_workspace)(void);
> +	struct list_head *(*get_workspace)(unsigned int level);
>  
>  	void (*put_workspace)(struct list_head *ws);
>  
> -	struct list_head *(*alloc_workspace)(void);
> +	struct list_head *(*alloc_workspace)(unsigned int level);
>  
>  	void (*free_workspace)(struct list_head *workspace);
>  
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index f0837b2c8e94..f132af45a924 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -73,9 +73,9 @@ static void lzo_cleanup_workspace_manager(void)
>  	btrfs_cleanup_workspace_manager(&wsm);
>  }
>  
> -static struct list_head *lzo_get_workspace(void)
> +static struct list_head *lzo_get_workspace(unsigned int level)
>  {
> -	return btrfs_get_workspace(&wsm);
> +	return btrfs_get_workspace(&wsm, level);
>  }
>  
>  static void lzo_put_workspace(struct list_head *ws)
> @@ -93,7 +93,7 @@ static void lzo_free_workspace(struct list_head *ws)
>  	kfree(workspace);
>  }
>  
> -static struct list_head *lzo_alloc_workspace(void)
> +static struct list_head *lzo_alloc_workspace(unsigned int level)
>  {
>  	struct workspace *workspace;
>  
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 04687bf692e3..e2173d0c4fd3 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -39,9 +39,9 @@ static void zlib_cleanup_workspace_manager(void)
>  	btrfs_cleanup_workspace_manager(&wsm);
>  }
>  
> -static struct list_head *zlib_get_workspace(void)
> +static struct list_head *zlib_get_workspace(unsigned int level)
>  {
> -	return btrfs_get_workspace(&wsm);
> +	return btrfs_get_workspace(&wsm, level);
>  }
>  
>  static void zlib_put_workspace(struct list_head *ws)
> @@ -58,7 +58,7 @@ static void zlib_free_workspace(struct list_head *ws)
>  	kfree(workspace);
>  }
>  
> -static struct list_head *zlib_alloc_workspace(void)
> +static struct list_head *zlib_alloc_workspace(unsigned int level)
>  {
>  	struct workspace *workspace;
>  	int workspacesize;
> @@ -71,6 +71,7 @@ static struct list_head *zlib_alloc_workspace(void)
>  			zlib_inflate_workspacesize());
>  	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
>  	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	workspace->level = level;
>  	if (!workspace->strm.workspace || !workspace->buf)
>  		goto fail;
>  
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index b06eaf171be7..404101864220 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -53,9 +53,9 @@ static void zstd_cleanup_workspace_manager(void)
>  	btrfs_cleanup_workspace_manager(&wsm);
>  }
>  
> -static struct list_head *zstd_get_workspace(void)
> +static struct list_head *zstd_get_workspace(unsigned int level)
>  {
> -	return btrfs_get_workspace(&wsm);
> +	return btrfs_get_workspace(&wsm, level);
>  }
>  
>  static void zstd_put_workspace(struct list_head *ws)
> @@ -72,7 +72,7 @@ static void zstd_free_workspace(struct list_head *ws)
>  	kfree(workspace);
>  }
>  
> -static struct list_head *zstd_alloc_workspace(void)
> +static struct list_head *zstd_alloc_workspace(unsigned int level)
>  {
>  	ZSTD_parameters params =
>  			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT);
> 
