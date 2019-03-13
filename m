Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961FCC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 585312171F
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfCMJTM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:19:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:43456 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726843AbfCMJTL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 05:19:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F5F9AC3A;
        Wed, 13 Mar 2019 09:19:09 +0000 (UTC)
Subject: Re: [PATCH 2/6] btrfs: tree-checker: Verify dev item
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-3-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <cc998f0e-4c23-0732-8be5-f5488f2e8bbb@suse.com>
Date:   Wed, 13 Mar 2019 11:19:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313085511.23540-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 13.03.19 г. 10:55 ч., Qu Wenruo wrote:
> [BUG]
> For fuzzed image whose DEV_ITEM has invalid total_bytes as 0, then
> kernel will just panic:
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
>   #PF error: [normal kernel read fault]
>   PGD 800000022b2bd067 P4D 800000022b2bd067 PUD 22b2bc067 PMD 0
>   Oops: 0000 [#1] SMP PTI
>   CPU: 0 PID: 1106 Comm: mount Not tainted 5.0.0-rc8+ #9
>   RIP: 0010:btrfs_verify_dev_extents+0x2a5/0x5a0
>   Call Trace:
>    open_ctree+0x160d/0x2149
>    btrfs_mount_root+0x5b2/0x680
> 
> [CAUSE]
> If device extent verification finds a deivce with 0 total_bytes, then it
> assumes it's a seed dummy, then search for seed devices.
> 
> But in this case, there is no seed device at all, causing NULL pointer.
> 
> [FIX]
> Since this is caused by fuzzed image, let's go the tree-check way, just
> add a new verification for device item.
> 
> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202691
> Signed-off-by: Qu Wenruo <wqu@suse.com>


I had already reviewed the earlier posting of this patch so:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


> ---
>  fs/btrfs/tree-checker.c | 84 +++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.c      |  9 -----
>  fs/btrfs/volumes.h      |  9 +++++
>  3 files changed, 93 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index fe3f37c23c29..5ccb4be583ea 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -594,6 +594,87 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
>  
> +
> +__printf(4, 5)
> +__cold
> +static void dev_item_err(const struct btrfs_fs_info *fs_info,
> +			 const struct extent_buffer *eb, int slot,
> +			 const char *fmt, ...)
> +{
> +	struct btrfs_key key;
> +	struct va_format vaf;
> +	va_list args;
> +
> +	btrfs_item_key_to_cpu(eb, &key, slot);
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	btrfs_crit(fs_info,
> +	"corrupt %s: root=%llu block=%llu slot=%d devid=%llu %pV",
> +		btrfs_header_level(eb) == 0 ? "leaf" : "node",
> +		btrfs_header_owner(eb), btrfs_header_bytenr(eb), slot,
> +		key.objectid, &vaf);
> +	va_end(args);
> +}
> +
> +static int check_dev_item(struct btrfs_fs_info *fs_info,
> +			  struct extent_buffer *leaf,
> +			  struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_dev_item *ditem;
> +	u64 max_devid = max(BTRFS_MAX_DEVS(fs_info), BTRFS_MAX_DEVS_SYS_CHUNK);
> +
> +	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
> +		dev_item_err(fs_info, leaf, slot,
> +			     "invalid objectid: has=%llu expect=%llu",
> +			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
> +		goto error;
> +	}
> +	if (key->offset > max_devid) {
> +		dev_item_err(fs_info, leaf, slot,
> +			     "invalid devid: has=%llu expect=[0, %llu]",
> +			     key->offset, max_devid);
> +		goto error;
> +	}
> +	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
> +	if (btrfs_device_id(leaf, ditem) != key->offset) {
> +		dev_item_err(fs_info, leaf, slot,
> +			     "devid mismatch: key has=%llu item has=%llu",
> +			     key->offset, btrfs_device_id(leaf, ditem));
> +		goto error;
> +	}
> +
> +	/*
> +	 * Since btrfs device add doesn't check device size at all, we could
> +	 * have device item whose size is smaller than 1M which is useless, but
> +	 * still valid.
> +	 * So here we can only check the obviously wrong case.
> +	 */
> +	if (btrfs_device_total_bytes(leaf, ditem) == 0) {
> +		dev_item_err(fs_info, leaf, slot,
> +			     "invalid total bytes: have 0");
> +		goto error;
> +	}
> +	if (btrfs_device_bytes_used(leaf, ditem) >
> +	    btrfs_device_total_bytes(leaf, ditem)) {
> +		dev_item_err(fs_info, leaf, slot,
> +			     "invalid bytes used: have %llu expect [0, %llu]",
> +			     btrfs_device_bytes_used(leaf, ditem),
> +			     btrfs_device_total_bytes(leaf, ditem));
> +		goto error;
> +	}
> +	/*
> +	 * Remaining members like io_align/type/gen/dev_group aren't really
> +	 * utilized.
> +	 * Skip them to make later usage of them easier.
> +	 */
> +	return 0;
> +error:
> +	return -EUCLEAN;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -624,6 +705,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>  		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk,
>  					      key->offset);
>  		break;
> +	case BTRFS_DEV_ITEM_KEY:
> +		ret = check_dev_item(fs_info, leaf, key, slot);
> +		break;
>  	}
>  	return ret;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0e3822870f1e..0b839ecbe73f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4964,15 +4964,6 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
>  	btrfs_set_fs_incompat(info, RAID56);
>  }
>  
> -#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
> -			- sizeof(struct btrfs_chunk))		\
> -			/ sizeof(struct btrfs_stripe) + 1)
> -
> -#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
> -				- 2 * sizeof(struct btrfs_disk_key)	\
> -				- 2 * sizeof(struct btrfs_chunk))	\
> -				/ sizeof(struct btrfs_stripe) + 1)
> -
>  static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  			       u64 start, u64 type)
>  {
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index ed806649a473..481c012eae79 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -258,6 +258,15 @@ struct btrfs_fs_devices {
>  
>  #define BTRFS_BIO_INLINE_CSUM_SIZE	64
>  
> +#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
> +			- sizeof(struct btrfs_chunk))		\
> +			/ sizeof(struct btrfs_stripe) + 1)
> +
> +#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
> +				- 2 * sizeof(struct btrfs_disk_key)	\
> +				- 2 * sizeof(struct btrfs_chunk))	\
> +				/ sizeof(struct btrfs_stripe) + 1)
> +
>  /*
>   * we need the mirror number and stripe index to be passed around
>   * the call chain while we are processing end_io (especially errors).
> 
