Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1D1C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 08:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2232175B
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 08:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfA2IOW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:14:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:47780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbfA2IOV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 03:14:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 727E1AEE6;
        Tue, 29 Jan 2019 08:14:19 +0000 (UTC)
Subject: Re: [PATCH 09/11] btrfs: change set_level() to bound the level passed
 in
To:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-10-dennis@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <372d47b8-457d-db5d-61f4-de7b901c5e78@suse.com>
Date:   Tue, 29 Jan 2019 10:14:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190128212437.11597-10-dennis@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> Currently, the only user of set_level() is zlib which sets an internal
> workspace parameter. As level is now plumbed into get_workspace(), this
> can be handled there rather than separately.
> 
> This repurposes set_level() to bound the level passed in so it can be
> used when setting the mounts compression level and as well as verifying
> the level before getting a workspace. The other benefit is this divides
> the meaning of compress(0) and get_workspace(0). The former means we
> want to use the default compression level of the compression type. The
> latter means we can use any workspace available.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> ---
>  fs/btrfs/compression.c | 23 +++++++++++++++--------
>  fs/btrfs/compression.h |  4 ++--
>  fs/btrfs/lzo.c         |  3 ++-
>  fs/btrfs/super.c       |  4 +++-
>  fs/btrfs/zlib.c        | 18 +++++++++++-------
>  fs/btrfs/zstd.c        |  3 ++-
>  6 files changed, 35 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index e509071eaa69..a552c6f61e6d 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1008,9 +1008,9 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
>  	struct list_head *workspace;
>  	int ret;
>  
> -	workspace = get_workspace(type, level);
> +	level = btrfs_compress_op[type]->set_level(level);
>  
> -	btrfs_compress_op[type]->set_level(workspace, level);
> +	workspace = get_workspace(type, level);
>  	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
>  						      start, pages,
>  						      out_pages,
> @@ -1563,14 +1563,21 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
>  	return ret;
>  }
>  
> -unsigned int btrfs_compress_str2level(const char *str)
> +unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
>  {
> -	if (strncmp(str, "zlib", 4) != 0)
> +	unsigned int level;
> +	int ret;
> +
> +	if (!type)
>  		return 0;
>  
> -	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the number */
> -	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
> -		return str[5] - '0';
> +	if (str[0] == ':') {
> +		ret = kstrtouint(str + 1, 10, &level);
> +		if (ret)
> +			level = 0;
> +	}
> +
> +	level = btrfs_compress_op[type]->set_level(level);
>  
> -	return BTRFS_ZLIB_DEFAULT_LEVEL;
> +	return level;
>  }
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index e3627139bc5c..d607be40aa0e 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -90,7 +90,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
>  blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  				 int mirror_num, unsigned long bio_flags);
>  
> -unsigned btrfs_compress_str2level(const char *str);
> +unsigned int btrfs_compress_str2level(unsigned int type, const char *str);
>  
>  enum btrfs_compression_type {
>  	BTRFS_COMPRESS_NONE  = 0,
> @@ -149,7 +149,7 @@ struct btrfs_compress_op {
>  			  unsigned long start_byte,
>  			  size_t srclen, size_t destlen);
>  
> -	void (*set_level)(struct list_head *ws, unsigned int type);
> +	unsigned int (*set_level)(unsigned int level);

It might be good to document the return value since this is an
interface. AFAICS implementations are required to return the actual
level set irrespective of what level was passed in, no?

>  };
>  
>  extern const struct btrfs_compress_op btrfs_heuristic_compress;
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index f132af45a924..579d53ae256f 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -507,8 +507,9 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
>  	return ret;
>  }
>  
> -static void lzo_set_level(struct list_head *ws, unsigned int type)
> +static unsigned int lzo_set_level(unsigned int level)
>  {
> +	return 0;
>  }
>  
>  const struct btrfs_compress_op btrfs_lzo_compress = {
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index c5586ffd1426..b28dff207383 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -529,7 +529,9 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  				if (token != Opt_compress &&
>  				    token != Opt_compress_force)
>  					info->compress_level =
> -					  btrfs_compress_str2level(args[0].from);
> +					  btrfs_compress_str2level(
> +							BTRFS_COMPRESS_ZLIB,
> +							args[0].from + 4);
>  				btrfs_set_opt(info->mount_opt, COMPRESS);
>  				btrfs_clear_opt(info->mount_opt, NODATACOW);
>  				btrfs_clear_opt(info->mount_opt, NODATASUM);
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index e2173d0c4fd3..388b1f000fca 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -41,7 +41,12 @@ static void zlib_cleanup_workspace_manager(void)
>  
>  static struct list_head *zlib_get_workspace(unsigned int level)
>  {
> -	return btrfs_get_workspace(&wsm, level);
> +	struct list_head *ws = btrfs_get_workspace(&wsm, level);
> +	struct workspace *workspace = list_entry(ws, struct workspace, list);
> +
> +	workspace->level = level;
> +
> +	return ws;
>  }
>  
>  static void zlib_put_workspace(struct list_head *ws)
> @@ -413,15 +418,14 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
>  	return ret;
>  }
>  
> -static void zlib_set_level(struct list_head *ws, unsigned int type)
> +static unsigned int zlib_set_level(unsigned int level)
>  {
> -	struct workspace *workspace = list_entry(ws, struct workspace, list);
> -	unsigned int level = BTRFS_COMPRESS_LEVEL(type);
> -
> -	if (level > 9)
> +	if (!level)
> +		level = BTRFS_ZLIB_DEFAULT_LEVEL;
> +	else if (level > 9)
>  		level = 9;

nit:  This makes it a bit more obvious (IMO) that you are essentially
doing max:

if (!level)
   level = BTRFS_ZLIB_DEFAULT_LEVEL;
level = max(level, 9);

>  
> -	workspace->level = level > 0 ? level : 3;
> +	return level;
>  }
>  
>  const struct btrfs_compress_op btrfs_zlib_compress = {
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 404101864220..43f3be755b8c 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -441,8 +441,9 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
>  	return ret;
>  }
>  
> -static void zstd_set_level(struct list_head *ws, unsigned int type)
> +static unsigned int zstd_set_level(unsigned int level)
>  {
> +	return ZSTD_BTRFS_DEFAULT_LEVEL;
>  }
>  
>  const struct btrfs_compress_op btrfs_zstd_compress = {
> 
