Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6EFC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3372077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B3372077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbeJKTe3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:34:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:45334 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbeJKTe2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:34:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7D3BAD16
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:07:29 +0000 (UTC)
Subject: Re: [PATCH v3 1/6] btrfs-progs: image: Use correct device size when
 restoring
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-2-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <1620cc91-8bec-4b29-adef-10f3f2c6531d@suse.com>
Date:   Thu, 11 Oct 2018 15:07:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181008123044.13413-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On  8.10.2018 15:30, Qu Wenruo wrote:
> When restoring btrfs image, the total_bytes of device item is not
> updated correctly. In fact total_bytes can be left 0 for restored image.
> 
> It doesn't trigger any error because btrfs check never checks
> total_bytes of dev item.
> However this is going to change.
> 
> Fix it by populating total_bytes of device item with the end position of
> last dev extent to make later btrfs check happy.

'Setting it to the end position' really means "setting the total device
size to the allocated space on the device". Is it more clear if stated
as the second way ?

In any case:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  image/main.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/image/main.c b/image/main.c
> index 351c5a256938..d5b89bc3149f 100644
> --- a/image/main.c
> +++ b/image/main.c
> @@ -2082,15 +2082,17 @@ static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
>  }
>  
>  static int fixup_devices(struct btrfs_fs_info *fs_info,
> -			 struct mdrestore_struct *mdres, off_t dev_size)
> +			 struct mdrestore_struct *mdres, int out_fd)
>  {
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_dev_item *dev_item;
> +	struct btrfs_dev_extent *dev_ext;
>  	struct btrfs_path path;
>  	struct extent_buffer *leaf;
>  	struct btrfs_root *root = fs_info->chunk_root;
>  	struct btrfs_key key;
>  	u64 devid, cur_devid;
> +	u64 dev_size; /* Get from last dev extents */
>  	int ret;
>  
>  	trans = btrfs_start_transaction(fs_info->tree_root, 1);
> @@ -2101,16 +2103,56 @@ static int fixup_devices(struct btrfs_fs_info *fs_info,
>  
>  	dev_item = &fs_info->super_copy->dev_item;
>  
> +	btrfs_init_path(&path);
>  	devid = btrfs_stack_device_id(dev_item);
>  
> +	key.objectid = devid;
> +	key.type = BTRFS_DEV_EXTENT_KEY;
> +	key.offset = (u64)-1;
> +
> +	ret = btrfs_search_slot(NULL, fs_info->dev_root, &key, &path, 0, 0);
> +	if (ret < 0) {
> +		error("failed to locate last dev extent of devid %llu: %s",
> +			devid, strerror(-ret));
> +		btrfs_release_path(&path);
> +		return ret;
> +	}
> +	if (ret == 0) {

nit: I'd prefer if this is an else if since it emphasizes the fact that
the if/elseif construct works on a single value.

> +		error("found invalid dev extent devid %llu offset -1",
> +			devid);
> +		btrfs_release_path(&path);
> +		return -EUCLEAN;
> +	}
> +	ret = btrfs_previous_item(fs_info->dev_root, &path, devid,
> +				  BTRFS_DEV_EXTENT_KEY);
> +	if (ret > 0)
> +		ret = -ENOENT;
> +	if (ret < 0) {

ditto

> +		error("failed to locate last dev extent of devid %llu: %s",
> +			devid, strerror(-ret));
> +		btrfs_release_path(&path);
> +		return ret;
> +	}
> +
> +	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +	dev_ext = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +				 struct btrfs_dev_extent);
> +	dev_size = key.offset + btrfs_dev_extent_length(path.nodes[0], dev_ext);
> +	btrfs_release_path(&path);
> +
>  	btrfs_set_stack_device_total_bytes(dev_item, dev_size);
>  	btrfs_set_stack_device_bytes_used(dev_item, mdres->alloced_chunks);
> +	/* Don't forget to enlarge the real file */
> +	ret = ftruncate64(out_fd, dev_size);
> +	if (ret < 0) {
> +		error("failed to enlarge result image: %s", strerror(errno));
> +		return -errno;
> +	}
>  
>  	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
>  	key.type = BTRFS_DEV_ITEM_KEY;
>  	key.offset = 0;
>  
> -	btrfs_init_path(&path);
>  
>  again:
>  	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
> @@ -2275,7 +2317,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
>  			return 1;
>  		}
>  
> -		ret = fixup_devices(info, &mdrestore, st.st_size);
> +		ret = fixup_devices(info, &mdrestore, fileno(out));
>  		close_ctree(info->chunk_root);
>  		if (ret)
>  			goto out;
> 
