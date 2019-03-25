Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE75C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4C220830
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbfCYNGR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:06:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:33120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731076AbfCYNGR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 09:06:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25244ABD2;
        Mon, 25 Mar 2019 13:06:15 +0000 (UTC)
Subject: Re: [PATCH] btrfs: use BUG() instead of BUG_ON(1)
To:     Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qu Wenruo <wqu@suse.com>, Liu Bo <bo.liu@linux.alibaba.com>,
        Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190325130256.1437810-1-arnd@arndb.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <78cd318c-2094-87ca-4843-46af5e3d11ef@suse.com>
Date:   Mon, 25 Mar 2019 15:06:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190325130256.1437810-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 25.03.19 г. 15:02 ч., Arnd Bergmann wrote:
> BUG_ON(1) leads to bogus warnings from clang when
> CONFIG_PROFILE_ANNOTATED_BRANCHES is set:
> 
> fs/btrfs/volumes.c:5041:3: error: variable 'max_chunk_size' is used uninitialized whenever 'if' condition is false
>       [-Werror,-Wsometimes-uninitialized]
>                 BUG_ON(1);
>                 ^~~~~~~~~
> include/asm-generic/bug.h:61:36: note: expanded from macro 'BUG_ON'
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
>                                    ^~~~~~~~~~~~~~~~~~~
> include/linux/compiler.h:48:23: note: expanded from macro 'unlikely'
>  #  define unlikely(x)   (__branch_check__(x, 0, __builtin_constant_p(x)))
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> fs/btrfs/volumes.c:5046:9: note: uninitialized use occurs here
>                              max_chunk_size);
>                              ^~~~~~~~~~~~~~
> include/linux/kernel.h:860:36: note: expanded from macro 'min'
>  #define min(x, y)       __careful_cmp(x, y, <)
>                                          ^
> include/linux/kernel.h:853:17: note: expanded from macro '__careful_cmp'
>                 __cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
>                               ^
> include/linux/kernel.h:847:25: note: expanded from macro '__cmp_once'
>                 typeof(y) unique_y = (y);               \
>                                       ^
> fs/btrfs/volumes.c:5041:3: note: remove the 'if' if its condition is always true
>                 BUG_ON(1);
>                 ^
> include/asm-generic/bug.h:61:32: note: expanded from macro 'BUG_ON'
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
>                                ^
> fs/btrfs/volumes.c:4993:20: note: initialize the variable 'max_chunk_size' to silence this warning
>         u64 max_chunk_size;
>                           ^
>                            = 0
> 
> Change it to BUG() so clang can see that this code path can never
> continue.

Long-term we have to eliminate to bug_on's but until then:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/btrfs/backref.c   | 4 ++--
>  fs/btrfs/ctree.c     | 4 ++--
>  fs/btrfs/extent_io.c | 8 ++++----
>  fs/btrfs/file.c      | 2 +-
>  fs/btrfs/inode.c     | 2 +-
>  fs/btrfs/root-tree.c | 2 +-
>  fs/btrfs/volumes.c   | 2 +-
>  7 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 11459fe84a29..2602072ed906 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -791,7 +791,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
>  			count = node->ref_mod * -1;
>  			break;
>  		default:
> -			BUG_ON(1);
> +			BUG();
>  		}
>  		*total_refs += count;
>  		switch (node->type) {
> @@ -1747,7 +1747,7 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
>  		else if (flags & BTRFS_EXTENT_FLAG_DATA)
>  			*flags_ret = BTRFS_EXTENT_FLAG_DATA;
>  		else
> -			BUG_ON(1);
> +			BUG();
>  		return 0;
>  	}
>  
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 324df36d28bf..75c69829d975 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -4674,7 +4674,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>  		btrfs_print_leaf(leaf);
>  		btrfs_crit(fs_info, "slot %d too large, nritems %d",
>  			   slot, nritems);
> -		BUG_ON(1);
> +		BUG();
>  	}
>  
>  	/*
> @@ -4754,7 +4754,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
>  			btrfs_print_leaf(leaf);
>  			btrfs_crit(fs_info, "slot %d old_data %d data_end %d",
>  				   slot, old_data, data_end);
> -			BUG_ON(1);
> +			BUG();
>  		}
>  		/*
>  		 * item0..itemN ... dataN.offset..dataN.size .. data0.size
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index ca8b8e785cf3..610a98857e22 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5746,13 +5746,13 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  		btrfs_err(fs_info,
>  			"memmove bogus src_offset %lu move len %lu dst len %lu",
>  			 src_offset, len, dst->len);
> -		BUG_ON(1);
> +		BUG();
>  	}
>  	if (dst_offset + len > dst->len) {
>  		btrfs_err(fs_info,
>  			"memmove bogus dst_offset %lu move len %lu dst len %lu",
>  			 dst_offset, len, dst->len);
> -		BUG_ON(1);
> +		BUG();
>  	}
>  
>  	while (len > 0) {
> @@ -5793,13 +5793,13 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  		btrfs_err(fs_info,
>  			  "memmove bogus src_offset %lu move len %lu len %lu",
>  			  src_offset, len, dst->len);
> -		BUG_ON(1);
> +		BUG();
>  	}
>  	if (dst_offset + len > dst->len) {
>  		btrfs_err(fs_info,
>  			  "memmove bogus dst_offset %lu move len %lu len %lu",
>  			  dst_offset, len, dst->len);
> -		BUG_ON(1);
> +		BUG();
>  	}
>  	if (dst_offset < src_offset) {
>  		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 34fe8a58b0e9..f28aed471693 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1025,7 +1025,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
>  			continue;
>  		}
>  
> -		BUG_ON(1);
> +		BUG();
>  	}
>  
>  	if (!ret && del_nr > 0) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 82fdda8ff5ab..98bc66d34e6c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1451,7 +1451,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  			extent_end = ALIGN(extent_end,
>  					   fs_info->sectorsize);
>  		} else {
> -			BUG_ON(1);
> +			BUG();
>  		}
>  out_check:
>  		if (extent_end <= start) {
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 893d12fbfda0..552efc88a016 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -141,7 +141,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>  		btrfs_print_leaf(path->nodes[0]);
>  		btrfs_crit(fs_info, "unable to update root key %llu %u %llu",
>  			   key->objectid, key->type, key->offset);
> -		BUG_ON(1);
> +		BUG();
>  	}
>  
>  	l = path->nodes[0];
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9024eee889b9..95223fd9f9d0 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5038,7 +5038,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	} else {
>  		btrfs_err(info, "invalid chunk type 0x%llx requested",
>  		       type);
> -		BUG_ON(1);
> +		BUG();
>  	}
>  
>  	/* We don't want a chunk larger than 10% of writable space */
> 
